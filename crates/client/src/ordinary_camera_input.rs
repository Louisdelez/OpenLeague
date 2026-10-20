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
        app.init_resource::<Controls>().init_resource::<crate::camera_lock::Setting>()
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
    shop: Res<crate::shop_ui::Filters>, time: Res<Time>, mut focus: ResMut<crate::CameraFocus>,
    windows: Query<(Entity, &Window), With<PrimaryWindow>>, mut lock: ResMut<crate::camera_lock::Setting>) {
    use crate::camera_lock::{Admission, Origin, Owner};
    let window = windows.single().ok();
    let gesture_identity = connection.inventory_input_identity();
    let owner = window.and_then(|(primary_window, _)| gesture_identity.map(|(session, player, epoch)|
        Owner { pid: std::process::id(), session, player, epoch, primary_window }));
    let snapshot = state.snapshot.as_ref().filter(|snapshot| Some(snapshot.session) == connection.session);
    let target = snapshot.and_then(|snapshot| snapshot.players.iter().find(|player| Some(player.id) == connection.id))
        .map(|player| Vec3::new(player.position.x, player.height, player.position.z) / 20.)
        .filter(|point| point.is_finite());
    let terminal = snapshot.is_some_and(|snapshot| snapshot.winner.is_some() || snapshot.result.is_some());
    let ready = connection.ready() && snapshot.is_some() && owner.is_some() && target.is_some();
    let human_enabled = ready && !terminal && !shop.open && !shop.focused && window.is_some_and(|(_, w)| w.focused);
    if lock.reconcile(Admission { owner, ready, terminal, human_enabled }) { controls.suspend(); }
    // Physical Y is collected only for the real focused primary window. A
    // reopening frame cannot replay a tap. No observer touches these key sets.
    let toggle = std::mem::take(&mut controls.toggle);
    if toggle && controls.armed && human_enabled && window.is_some_and(|(e, _)| controls.window == Some(e)) {
        let request = lock.request(!lock.locked(), Origin::Hotkey);
        if let Err(error) = request.and_then(|request| lock.consume(request)) { eprintln!("Camera Y request refused: {error:?}"); }
    }
    controls.follow = lock.locked();
    controls.apply(Context { identity: connection.session.zip(connection.id), enabled: human_enabled, target }, time.delta_secs(), &mut focus.0);
    // Explicit ordinary product policy: an existing lock follows only the
    // local player's finite accepted Snapshot position even in the background
    // or with shop open. Space/pan/Y still require real keyboard focus.
    if lock.follows_authoritative_target() { if let Some(target) = target { focus.0 = target; } }
    controls.follow = lock.locked();
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

#[cfg(test)] mod shared_setting_tests {
    use super::*;
    use bevy::input::{InputPlugin, keyboard::Key};
    fn scene() -> (App, Entity) {
        let navigation=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut simulation=openleague_core::Simulation::new(navigation).unwrap();simulation.session=42;let id=simulation.join("garen").unwrap();
        let connection=crate::Connection{link:crate::session_connection::Link::legacy(),welcome_history:Default::default(),socket:std::net::UdpSocket::bind("127.0.0.1:0").unwrap(),id:Some(id),session:Some(42),sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default()};
        let mut app=App::new();app.add_plugins(InputPlugin).insert_resource(connection).insert_resource(crate::Match{snapshot:Some(simulation.snapshot()),..default()})
            .init_resource::<Controls>().init_resource::<crate::camera_lock::Setting>().insert_resource(Time::<()>::default()).insert_resource(crate::CameraFocus(Vec3::ZERO));
        let mut shop=crate::shop_ui::Filters::default();shop.open=false;shop.focused=false;app.insert_resource(shop);
        let window=app.world_mut().spawn((Window{focused:true,..default()},PrimaryWindow)).id();
        app.add_systems(PreUpdate,collect.after(InputSystems)).add_systems(Update,drive);app.update();app.update();(app,window)
    }
    fn key(app:&mut App,window:Entity,key_code:KeyCode,state:ButtonState) {
        app.world_mut().write_message(KeyboardInput{key_code,logical_key:Key::Character("camera fixture".into()),state,text:None,repeat:false,window});
    }
    #[test] fn ordinary_physical_y_routes_to_shared_consumer_once_and_unfocused_y_space_are_discarded() {
        let (mut app,window)=scene();
        key(&mut app,window,KeyCode::KeyY,ButtonState::Pressed);key(&mut app,window,KeyCode::KeyY,ButtonState::Released);app.update();
        let setting=app.world().resource::<crate::camera_lock::Setting>();assert!(setting.locked());assert_eq!(setting.last_origin(),Some(crate::camera_lock::Origin::Hotkey));
        let request=setting.request(false,crate::camera_lock::Origin::Ui).unwrap();app.world_mut().resource_mut::<crate::camera_lock::Setting>().consume(request).unwrap();
        app.world_mut().get_mut::<Window>(window).unwrap().focused=false;let focus=Vec3::new(200.,4.,300.);app.world_mut().resource_mut::<crate::CameraFocus>().0=focus;
        for key_code in [KeyCode::KeyY,KeyCode::Space] {key(&mut app,window,key_code,ButtonState::Pressed);key(&mut app,window,key_code,ButtonState::Released);}app.update();
        assert!(!app.world().resource::<crate::camera_lock::Setting>().locked());assert_eq!(app.world().resource::<crate::CameraFocus>().0,focus);
        app.world_mut().get_mut::<Window>(window).unwrap().focused=true;app.update();app.update();assert!(!app.world().resource::<crate::camera_lock::Setting>().locked());
    }
    #[test] fn ordinary_background_lock_follows_snapshot_without_altering_human_input() {
        let (mut app,window)=scene();
        app.world_mut().resource_mut::<ButtonInput<KeyCode>>().press(KeyCode::KeyY);
        let request=app.world().resource::<crate::camera_lock::Setting>().request(true,crate::camera_lock::Origin::Observer(77)).unwrap();
        let lease=app.world_mut().resource_mut::<crate::camera_lock::Setting>().acquire_observer(request).unwrap();
        app.world_mut().get_mut::<Window>(window).unwrap().focused=false;
        let target=Vec3::new(300.,9.,330.);
        {let mut state=app.world_mut().resource_mut::<crate::Match>();let p=state.snapshot.as_mut().unwrap().players.first_mut().unwrap();p.position.x=target.x*20.;p.height=target.y*20.;p.position.z=target.z*20.;}
        app.update();assert_eq!(app.world().resource::<crate::CameraFocus>().0,target);assert!(!app.world().get::<Window>(window).unwrap().focused);
        // InputPlugin may naturally clear keys on genuine backend focus events;
        // this fixture supplies no such event. CameraLock itself never releases.
        assert!(app.world().resource::<ButtonInput<KeyCode>>().pressed(KeyCode::KeyY));
        let serial=app.world().resource::<crate::camera_lock::Setting>().last_serial()+1;
        app.world_mut().resource_mut::<crate::camera_lock::Setting>().restore_observer(&lease,serial).unwrap();
        assert!(app.world().resource::<ButtonInput<KeyCode>>().pressed(KeyCode::KeyY));
    }
    #[test] fn either_winner_or_final_result_refuses_follow_without_rewriting_terminal_camera() {
        for result_only in [false,true] {
            let (mut app,window)=scene();
            let request=app.world().resource::<crate::camera_lock::Setting>().request(true,crate::camera_lock::Origin::Observer(77)).unwrap();
            app.world_mut().resource_mut::<crate::camera_lock::Setting>().consume(request).unwrap();
            {let mut state=app.world_mut().resource_mut::<crate::Match>();let snapshot=state.snapshot.as_mut().unwrap();
                if result_only {snapshot.winner=None;snapshot.result=Some(openleague_core::match_results::MatchResult{session:42,ended_tick:snapshot.tick,winner:0,players:Vec::new(),destroyed_nexus:None});}
                else {snapshot.winner=Some(0);snapshot.result=None;}}
            app.world_mut().get_mut::<Window>(window).unwrap().focused=false;
            let terminal_focus=Vec3::new(100.,4.,140.);app.world_mut().resource_mut::<crate::CameraFocus>().0=terminal_focus;app.update();
            assert!(!app.world().resource::<crate::camera_lock::Setting>().follows_authoritative_target());
            assert_eq!(app.world().resource::<crate::CameraFocus>().0,terminal_focus);
            let request=app.world().resource::<crate::camera_lock::Setting>().request(false,crate::camera_lock::Origin::Observer(77)).unwrap();
            assert_eq!(app.world_mut().resource_mut::<crate::camera_lock::Setting>().consume(request),Err(crate::camera_lock::Rejection::Terminal));
        }
    }
}
