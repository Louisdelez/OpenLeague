//! Ordinary camera input. Default bindings come from original Input.ini;
//! tap duration, follow precedence and UI gates are explicit local policy.
use bevy::{input::{ButtonState, InputSystems, keyboard::{KeyboardFocusLost, KeyboardInput}}, prelude::*, window::PrimaryWindow};
use std::collections::HashSet;

const ARROWS: [KeyCode; 4] = [KeyCode::ArrowUp, KeyCode::ArrowDown, KeyCode::ArrowLeft, KeyCode::ArrowRight];
const PAN_SPEED: f32 = 150.; // Preserve the existing client speed (render units/s).

#[derive(Resource, Default)]
pub struct Controls {
    held: HashSet<KeyCode>,
    taps: [bool; 4],
    center_tap: bool,
    toggle: bool,
    window: Option<Entity>,
    identity: Option<(u64, u32)>,
    armed: bool,
    follow: bool,
    wheel_window: Option<Entity>,
}

#[derive(Clone, Copy)]
struct Context {
    identity: Option<(u64, u32)>,
    enabled: bool,
    target: Option<Vec3>,
}

impl Controls {
    fn clear_frame(&mut self) {
        self.taps = [false; 4]; self.center_tap = false; self.toggle = false;
        self.wheel_window = None;
    }

    fn discard_gestures(&mut self) { self.held.clear(); self.clear_frame(); }

    fn suspend(&mut self) { self.discard_gestures(); self.armed = false; }

    fn key(&mut self, key: KeyCode, state: ButtonState, repeat: bool) {
        if !ARROWS.contains(&key) && key != KeyCode::Space && key != KeyCode::KeyY { return; }
        match state {
            ButtonState::Released => { self.held.remove(&key); }
            ButtonState::Pressed if !repeat => {
                if !self.held.insert(key) { return; }
                if let Some(index) = ARROWS.iter().position(|candidate| *candidate == key) { self.taps[index] = true; }
                if key == KeyCode::Space { self.center_tap = true; }
                if key == KeyCode::KeyY { self.toggle = !self.toggle; }
            }
            // An OS repeat cannot resurrect a held key discarded by a gate.
            ButtonState::Pressed => {}
        }
    }

    fn apply(&mut self, context: Context, delta: f32, focus: &mut Vec3) {
        if self.identity != context.identity {
            self.identity = context.identity; self.follow = false; self.suspend();
        }
        let target = context.target.filter(|point| point.is_finite());
        if !context.enabled || context.identity.is_none() || target.is_none() || self.window.is_none() {
            self.suspend(); return;
        }
        if !self.armed {
            // Discard the reopening frame as event queues do not retain relative
            // order with shop, network or focus transitions. No delayed gesture.
            self.discard_gestures(); self.armed = true; return;
        }
        self.wheel_window = self.window;
        if self.toggle { self.follow = !self.follow; }
        if self.follow || self.center_tap || self.held.contains(&KeyCode::Space) {
            *focus = target.unwrap();
        } else if delta.is_finite() && delta > 0. {
            let active: [bool; 4] = std::array::from_fn(|i| self.taps[i] || self.held.contains(&ARROWS[i]));
            let direction = Vec3::new(i32::from(active[3]) as f32 - i32::from(active[2]) as f32, 0.,
                i32::from(active[1]) as f32 - i32::from(active[0]) as f32);
            // A complete short tap gets one ordinary frame of movement. No
            // guessed native key duration, minimum pixels or fabricated cadence.
            *focus += direction * delta * PAN_SPEED;
        }
        self.taps = [false; 4]; self.center_tap = false; self.toggle = false;
    }

    /// Explicit local minimap policy: a manual pan releases Y follow.
    pub(crate) fn minimap_focus(&mut self) { self.follow=false; self.center_tap=false; }

    pub fn accepts_wheel(&self, window: Entity) -> bool { self.wheel_window == Some(window) }

    #[cfg(test)]
    pub(crate) fn wheel_fixture(window: Entity) -> Self { Self { wheel_window: Some(window), ..default() } }
}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Controls>()
            .add_systems(PreUpdate, collect.after(InputSystems))
            .add_systems(Update, drive.after(crate::receive).after(crate::shop_ui::update).before(crate::camera));
    }
}

fn collect(mut controls: ResMut<Controls>, mut keys: MessageReader<KeyboardInput>,
    mut lost: MessageReader<KeyboardFocusLost>, windows: Query<(Entity, &Window), With<PrimaryWindow>>) {
    controls.clear_frame();
    let focus_lost = lost.read().next().is_some(); lost.clear();
    let Ok((entity, window)) = windows.single() else { controls.suspend(); controls.window = None; keys.clear(); return; };
    if controls.window != Some(entity) { controls.suspend(); controls.window = Some(entity); }
    if focus_lost || !window.focused { controls.suspend(); controls.window = None; keys.clear(); return; }
    for key in keys.read().filter(|key| key.window == entity) { controls.key(key.key_code, key.state, key.repeat); }
}

pub(crate) fn drive(mut controls: ResMut<Controls>, connection: Res<crate::Connection>, state: Res<crate::Match>,
    shop: Res<crate::shop_ui::Filters>, time: Res<Time>, mut focus: ResMut<crate::CameraFocus>) {
    let identity = connection.session.zip(connection.id);
    let snapshot = state.snapshot.as_ref().filter(|snapshot| Some(snapshot.session) == connection.session);
    let target = snapshot.and_then(|snapshot| snapshot.players.iter().find(|player| Some(player.id) == connection.id))
        .map(|player| Vec3::new(player.position.x, player.height, player.position.z) / 20.);
    let enabled = connection.ready() && !shop.open && !shop.focused
        && snapshot.is_some_and(|snapshot| snapshot.winner.is_none());
    // Pause and death do not move simulation or predict respawn: camera alone
    // can inspect the last accepted position, using real frame time as before.
    controls.apply(Context { identity, enabled, target }, time.delta_secs(), &mut focus.0);
}

#[cfg(test)]
#[path = "ordinary_camera_input_tests.rs"]
mod tests;

#[cfg(test)] mod minimap_tests {
    use super::*;
    #[test] fn manual_minimap_focus_releases_follow_without_inventing_actor_motion() {
        let mut controls=Controls{window:Some(Entity::PLACEHOLDER),identity:Some((1,21)),armed:true,follow:true,..default()};
        let context=Context{identity:Some((1,21)),enabled:true,target:Some(Vec3::splat(100.))};
        let mut focus=Vec3::ZERO;controls.apply(context,0.016,&mut focus);assert_eq!(focus,Vec3::splat(100.));
        controls.minimap_focus();focus=Vec3::new(200.,4.,300.);controls.apply(context,0.016,&mut focus);assert_eq!(focus,Vec3::new(200.,4.,300.));
        controls.key(KeyCode::KeyY,ButtonState::Pressed,false);controls.apply(context,0.016,&mut focus);assert_eq!(focus,Vec3::splat(100.));
    }
}
