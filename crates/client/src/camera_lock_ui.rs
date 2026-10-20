//! One ordinary Map10 camera button from original HUD records and HUDAtlas.
//! Hover/press/release wiring is explicit local product policy; no native
//! callback, full HUD framebuffer, physical-input or GPU qualification claim.
use bevy::{prelude::*, input::ButtonState, window::{PrimaryWindow, WindowEvent},
    ui_render::ui_material::MaterialNode};
use std::collections::BTreeMap;
use crate::{camera_lock::{Owner, Origin, Request, Setting},
    native_hud_panels::Panel, native_hud_element_storage::ElementStorage,
    native_hud_icon_material::IconMaterial, native_zip_provider::StartupHud};

const NAMES: [&str; 6] = ["CameraIcon_Off", "CameraIcon_On", "CameraIcon_Pressed",
    "CameraIconLocked_Off", "CameraIconLocked_On", "CameraIconLocked_Pressed"];

#[derive(SystemSet, Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub(crate) struct InputSet;

#[derive(Clone, Copy, Debug, PartialEq)]
struct Rect([f32; 4]);
impl Rect {
    fn contains(self, p: Vec2) -> bool { p.is_finite() && p.x >= self.0[0] && p.y >= self.0[1] && p.x < self.0[2] && p.y < self.0[3] }
    fn bits(self) -> [u32; 4] { self.0.map(f32::to_bits) }
    fn from_node(n: &Node) -> Result<Self, String> {
        let (Val::Px(x), Val::Px(y), Val::Px(w), Val::Px(h)) = (n.left, n.top, n.width, n.height) else { return Err("Camera button has no pixel rectangle".into()); };
        if ![x,y,w,h].iter().all(|v| v.is_finite()) || w <= 0. || h <= 0. { return Err("Camera button rectangle unavailable".into()); }
        Ok(Self([x,y,x+w,y+h]))
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Context { owner: Owner, rect: [u32; 4] }
#[derive(Clone, Copy, Debug)]
struct Gesture { owner: Owner, expected_revision: u64, expected_locked: bool }

/// Ordered owned pointer state; it never changes global button or focus state.
#[derive(Resource, Default)]
pub struct Capture {
    window: Option<Entity>, context: Option<Context>, point: Option<Vec2>,
    left: bool, right: bool, armed: Option<Gesture>, blocked: bool,
}
impl Capture {
    pub fn blocks_world_pointer(&self) -> bool { self.blocked }
    fn reset(&mut self) { *self = Self::default(); }
    fn frame<'a>(&mut self, window: Entity, focused: bool, rect: Rect, owner: Owner,
        human_enabled: bool, revision: u64, locked: bool, events: impl Iterator<Item=&'a WindowEvent>) -> Vec<Gesture> {
        let events = events.collect::<Vec<_>>();
        let context = Context { owner, rect: rect.bits() };
        let changed = self.window != Some(window) || self.context != Some(context);
        let invalid_batch = events.iter().any(|event| match event {
            WindowEvent::WindowResized(e) => e.window == window,
            WindowEvent::WindowScaleFactorChanged(e) => e.window == window,
            WindowEvent::WindowBackendScaleFactorChanged(e) => e.window == window,
            WindowEvent::WindowFocused(e) => e.window == window && !e.focused,
            WindowEvent::WindowDestroyed(e) => e.window == window,
            WindowEvent::KeyboardFocusLost(_) => true,
            WindowEvent::KeyboardInput(e) => e.window == window && e.key_code == KeyCode::Escape && e.state == ButtonState::Pressed,
            _ => false,
        });
        if changed || !focused || !human_enabled || invalid_batch {
            self.point = None; self.left = false; self.right = false; self.armed = None;
        }
        self.window = Some(window); self.context = Some(context);
        let enabled = focused && human_enabled && !changed && !invalid_batch;
        let mut out = Vec::new();
        self.blocked = self.point.is_some_and(|p| rect.contains(p)) || self.armed.is_some();
        for event in events {
            match event {
                WindowEvent::CursorMoved(e) if e.window == window => {
                    self.point = Some(e.position).filter(|p| p.is_finite());
                }
                WindowEvent::CursorLeft(e) if e.window == window => { self.point = None; self.armed = None; }
                WindowEvent::MouseButtonInput(e) if e.window == window => {
                    let inside = self.point.is_some_and(|p| rect.contains(p));
                    self.blocked |= inside || self.armed.is_some();
                    match (e.button, e.state) {
                        (MouseButton::Left, ButtonState::Pressed) => {
                            let fresh = !self.left; self.left = true;
                            if fresh && !self.right && inside && enabled {
                                self.armed = Some(Gesture { owner, expected_revision: revision, expected_locked: locked });
                            }
                        }
                        (MouseButton::Left, ButtonState::Released) => {
                            self.left = false;
                            if let Some(gesture) = self.armed.take() { if inside && enabled { out.push(gesture); } }
                        }
                        (MouseButton::Right, ButtonState::Pressed) => { self.right = true; self.armed = None; }
                        (MouseButton::Right, ButtonState::Released) => { self.right = false; }
                        _ => {},
                    }
                }
                _ => {},
            }
            self.blocked |= self.point.is_some_and(|p| rect.contains(p)) || self.armed.is_some();
        }
        if !enabled { self.point = None; self.armed = None; out.clear(); }
        out
    }
    fn appearance(&self, rect: Rect) -> usize {
        if self.armed.is_some() { 2 } else if self.point.is_some_and(|p| rect.contains(p)) { 1 } else { 0 }
    }
}

struct Owned { entity: Entity, material: Handle<IconMaterial> }
#[derive(Resource, Default)]
struct Live { sources: BTreeMap<String, Panel>, owned: Option<Owned>, error: Option<String> }

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        // IconMaterial's UiMaterialPlugin is already installed by native_hud_panels.
        app.init_resource::<Live>().init_resource::<Capture>().add_systems(Startup, setup)
            .add_systems(Update, update.in_set(InputSet).after(crate::receive).after(crate::shop_ui::update)
                .after(crate::ordinary_camera_input::drive).before(crate::native_minimap::InputSet)
                .before(crate::commands).before(crate::camera).before(crate::render_probe::capture));
    }
}

fn source(hud: &StartupHud) -> Result<BTreeMap<String, Panel>, String> {
    let mut out = BTreeMap::new();
    for layout in &hud.shadow_isles_layouts {
        if layout.request != "HUD/Elements/ShadowIslesMinimapRight.ini" { continue; }
        for record in &layout.structure.accepted {
            let s = &record.element.storage;
            let name = std::str::from_utf8(s.bytes()[..32].split(|b| *b == 0).next().unwrap()).map_err(|_| "Camera source name encoding")?;
            if !NAMES.contains(&name) { continue; }
            if s.kind() != 1 || s.bytes()[0x1e0..0x200].split(|b| *b == 0).next().unwrap() != b"HUDAtlas"
                || s.bytes()[0x204..0x214] != s.bytes()[0x214..0x224] { return Err("Camera source icon/atlas/UV mismatch".into()); }
            let mut storage = ElementStorage::new(1).map_err(str::to_owned)?; storage.write_bytes(0, s.bytes());
            if out.insert(name.to_owned(), Panel { name: name.into(), path: layout.request.clone(), storage }).is_some() { return Err("Duplicate camera icon source".into()); }
        }
    }
    if out.len() != NAMES.len() { return Err("Six original camera appearance records required".into()); }
    let reference = &out[NAMES[0]].storage;
    for panel in out.values() {
        // Layers/response/enabled differ. Rect/anchor/fraction/aspect must agree.
        for offset in [0x1a8,0x1ac,0x1b0,0x1b4,0x1b8,0x1bc,0x1c0,0x1c4,0x1c8,0x1cc,0x1d0,0x1d4,0x1d8] {
            if panel.storage.word(offset) != reference.word(offset) { return Err("Camera appearance rectangles differ".into()); }
        }
        if panel.storage.flags() & 0x80 == 0 { return Err("Camera KeepMaxScale source missing".into()); }
    }
    Ok(out)
}

fn setup(hud: Res<StartupHud>, mut live: ResMut<Live>) {
    match source(&hud) { Ok(sources) => live.sources = sources,
        Err(error) => { eprintln!("Camera button unavailable: {error}"); live.error = Some(error); } }
}
fn retire(live: &mut Live, capture: &mut Capture, commands: &mut Commands, materials: &mut Assets<IconMaterial>) {
    if let Some(owned) = live.owned.take() { commands.entity(owned.entity).despawn(); materials.remove(owned.material.id()); }
    capture.reset();
}
fn owned_panel(panel: &Panel) -> Result<Panel, String> {
    let mut storage = ElementStorage::new(1).map_err(str::to_owned)?; storage.write_bytes(0, panel.storage.bytes());
    // Local controller selects exactly one appearance; original record retained.
    storage.set_word(0x48, storage.flags() | 1);
    Ok(Panel { name: panel.name.clone(), path: panel.path.clone(), storage })
}
fn update(mut commands: Commands, game: Res<crate::Match>, windows: Query<(Entity, &Window), With<PrimaryWindow>>,
    atlases: Res<crate::native_hud_atlases::Atlases>, viewport: Res<crate::native_hud_viewport::Viewport>,
    images: Res<Assets<Image>>, mut materials: ResMut<Assets<IconMaterial>>, mut lock: ResMut<Setting>,
    mut live: ResMut<Live>, mut capture: ResMut<Capture>, mut events: MessageReader<WindowEvent>) {
    let Some(owner) = lock.owner().filter(|_| lock.available()) else { events.clear(); retire(&mut live, &mut capture, &mut commands, &mut materials); return; };
    if !game.snapshot.as_ref().is_some_and(|snapshot| snapshot.session == owner.session
        && snapshot.map10.is_some() && snapshot.winner.is_none() && snapshot.result.is_none()
        && snapshot.players.iter().any(|player| player.id == owner.player)) {
        events.clear(); retire(&mut live, &mut capture, &mut commands, &mut materials); return;
    }
    let Ok((window_id, window)) = windows.single() else { events.clear(); retire(&mut live, &mut capture, &mut commands, &mut materials); return; };
    if owner.primary_window != window_id || live.sources.len() != 6 { events.clear(); retire(&mut live, &mut capture, &mut commands, &mut materials); return; }
    let preparation = (|| -> Result<_, String> {
        let atlas = atlases.entries.iter().find(|a| a.normalized == "Textures/HUDAtlas.dds").ok_or("Camera HUDAtlas unavailable")?;
        if atlas.width != 1024 || atlas.height != 1024 || !images.contains(atlas.image.id()) { return Err("Camera original atlas dimensions/image unavailable".into()); }
        let dimensions = [window.physical_width(), window.physical_height()]; let dpi = window.scale_factor();
        let panel = owned_panel(&live.sources[NAMES[0]])?;
        let (node, _) = crate::native_hud_panels::payload(&panel, dimensions, viewport.scalar, dpi, atlas.image.clone())?;
        Ok((Rect::from_node(&node)?, dimensions, dpi, atlas.image.clone()))
    })();
    let (rect, dimensions, dpi, image) = match preparation { Ok(v) => v, Err(error) => {
        events.clear(); retire(&mut live, &mut capture, &mut commands, &mut materials);
        if live.error.as_ref() != Some(&error) { eprintln!("Camera button unavailable: {error}"); live.error = Some(error); } return;
    }};
    let gestures = capture.frame(window_id, window.focused, rect, owner, lock.human_enabled(), lock.revision(), lock.locked(), events.read());
    for gesture in gestures {
        let request = lock.request(!gesture.expected_locked, Origin::Ui).map(|next| Request {
            owner: gesture.owner, expected_revision: gesture.expected_revision,
            expected_locked: gesture.expected_locked, ..next
        });
        if let Err(error) = request.and_then(|request| lock.consume(request)) { eprintln!("Camera button request refused: {error:?}"); }
    }
    // A real stationary cursor can supply hover after a reopening barrier. It
    // never supplies a press/release or completes the discarded gesture batch.
    if capture.point.is_none() && window.focused && lock.human_enabled() {
        capture.point = window.cursor_position().filter(|p| p.is_finite());
        capture.blocked |= capture.point.is_some_and(|p| rect.contains(p));
    }
    let index = usize::from(lock.locked()) * 3 + capture.appearance(rect);
    let panel = match owned_panel(&live.sources[NAMES[index]]) { Ok(v) => v, Err(error) => { eprintln!("Camera button unavailable: {error}"); retire(&mut live, &mut capture, &mut commands, &mut materials); return; } };
    let (node, material) = match crate::native_hud_panels::payload(&panel, dimensions, viewport.scalar, dpi, image) {
        Ok(v) => v, Err(error) => { eprintln!("Camera button unavailable: {error}"); retire(&mut live, &mut capture, &mut commands, &mut materials); return; }
    };
    let z = GlobalZIndex(80 + panel.storage.word(0x1a4) as i32);
    if let Some(owned) = &live.owned {
        let Some(mut current) = materials.get_mut(&owned.material) else { retire(&mut live, &mut capture, &mut commands, &mut materials); return; };
        if current.texture != material.texture || current.parameters.uv != material.parameters.uv
            || current.parameters.vertex_color != material.parameters.vertex_color || current.parameters.tint != material.parameters.tint || current.parameters.mode != material.parameters.mode { *current = material; }
        commands.entity(owned.entity).insert((node, z));
    } else {
        let material = materials.add(material); let entity = commands.spawn((node, MaterialNode(material.clone()), z, Name::new("NativeMap10CameraLockButton"))).id();
        live.owned = Some(Owned { entity, material });
    }
    live.error = None;
}

#[cfg(test)]
#[path = "camera_lock_ui_tests.rs"]
mod tests;
