//! Local ordered pointer policy. Sends only the existing ordinary Move command.
//! Original minimap mouse callbacks, attack/ping/targeted spells remain unported.
use bevy::{prelude::*,input::ButtonState,window::{PrimaryWindow,WindowEvent}};
use super::{Live,geometry::{Projection,Rect}};

#[derive(SystemSet,Debug,Clone,Copy,PartialEq,Eq,Hash)] pub(crate) struct InputSet;
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
struct Context {identity:(u64,u32,Option<u64>),window:Entity,rect:[u32;4]}
#[derive(Clone,Copy,Debug)] enum Intent {Camera(Vec2),Move(Vec2)}
#[derive(Resource,Default)] pub(crate) struct Capture {
    window:Option<Entity>,context:Option<Context>,point:Option<Vec2>,focused:bool,
    left:bool,right:bool,drag:bool,blocked:bool,
}
impl Capture {
    pub(crate) fn blocks_world_pointer(&self)->bool {self.blocked}
    fn cancel(&mut self) {self.drag=false;}
    fn frame<'a>(&mut self,window:Option<Entity>,focused:bool,rect:Option<Rect>,context:Option<Context>,events:impl Iterator<Item=&'a WindowEvent>)->Vec<Intent> {
        let events=events.collect::<Vec<_>>();
        let invalid_batch=events.iter().any(|event|match event {
            WindowEvent::WindowResized(e)=>Some(e.window)==window,
            WindowEvent::WindowScaleFactorChanged(e)=>Some(e.window)==window,
            WindowEvent::WindowBackendScaleFactorChanged(e)=>Some(e.window)==window,
            WindowEvent::KeyboardInput(e)=>Some(e.window)==window && e.key_code==KeyCode::Escape && e.state==ButtonState::Pressed,
            _=>false,
        });
        if self.window!=window {self.window=window;self.point=None;self.left=false;self.right=false;self.focused=focused;self.cancel();}
        let changed=self.context!=context;
        if changed || !focused || invalid_batch {self.cancel();}
        self.context=context;
        // A new epoch/identity/UI gate never inherits a held press. Require a
        // fresh press in a later frame, after the real presentation barrier.
        let enabled=context.is_some() && !changed && focused && !invalid_batch;
        let hovered=|p:Option<Vec2>|p.is_some_and(|p|rect.is_some_and(|r|r.contains(p)));
        self.blocked=self.drag || hovered(self.point);
        let mut out=Vec::new();
        for event in events {
            match event {
                WindowEvent::CursorMoved(e) if Some(e.window)==window => {
                    self.point=Some(e.position).filter(|p|p.is_finite());
                    if enabled && self.focused && self.drag && hovered(self.point) {out.push(Intent::Camera(e.position));}
                }
                WindowEvent::CursorLeft(e) if Some(e.window)==window => {self.point=None;}
                WindowEvent::MouseButtonInput(e) if Some(e.window)==window => {
                    let inside=hovered(self.point);self.blocked|=inside || self.drag;
                    match (e.button,e.state) {
                        (MouseButton::Left,ButtonState::Pressed)=>{
                            let fresh=!self.left;self.left=true;
                            if fresh && !self.right && inside && enabled && self.focused {self.drag=true;out.push(Intent::Camera(self.point.unwrap()));}
                        }
                        (MouseButton::Left,ButtonState::Released)=>{self.left=false;self.cancel();}
                        (MouseButton::Right,ButtonState::Pressed)=>{
                            let fresh=!self.right;self.right=true;
                            if fresh && !self.left && !self.drag && inside && enabled && self.focused {out.push(Intent::Move(self.point.unwrap()));}
                            self.cancel();
                        }
                        (MouseButton::Right,ButtonState::Released)=>{self.right=false;}
                        _=>{},
                    }
                }
                WindowEvent::WindowFocused(e) if Some(e.window)==window=>{
                    self.focused=e.focused;if !e.focused {self.point=None;self.left=false;self.right=false;self.cancel();out.clear();}
                }
                WindowEvent::KeyboardFocusLost(_)=>{self.point=None;self.left=false;self.right=false;self.cancel();out.clear();}
                WindowEvent::WindowDestroyed(e) if Some(e.window)==window=>{self.focused=false;self.point=None;self.cancel();out.clear();}
                _=>{},
            }
            self.blocked|=hovered(self.point) || self.drag;
        }
        if !focused || invalid_batch {out.clear();self.point=None;}
        out
    }
}
pub(super) fn input(mut capture:ResMut<Capture>,live:Res<Live>,state:Res<crate::Match>,mut connection:ResMut<crate::Connection>,
    shop:Res<crate::shop_ui::Filters>,inventory:Res<crate::native_hud_inventory::Capture>,windows:Query<(Entity,&Window),With<PrimaryWindow>>,
    mut events:MessageReader<WindowEvent>,terrain:Res<crate::picking::Terrain>,mut camera:ResMut<crate::ordinary_camera_input::Controls>,
    mut focus:ResMut<crate::CameraFocus>) {
    let window=windows.single().ok();let rect=live.rect;
    let identity=connection.inventory_input_identity();
    let snapshot=state.snapshot.as_ref().filter(|s|Some(s.session)==connection.session);
    let context=window.and_then(|(window_id,window)|{
        if !window.focused || shop.open || shop.focused || inventory.blocks_commands() || live.error.is_some() {return None;}
        let identity=identity?;let snapshot=snapshot?;
        if snapshot.winner.is_some() || !snapshot.players.iter().any(|p|p.id==identity.1) {return None;}
        Some(Context{identity,window:window_id,rect:rect?.bits()})
    });
    let intents=capture.frame(window.map(|w|w.0),window.is_some_and(|w|w.1.focused),rect,context,events.read());
    let (Some(rect),Ok(projection))=(rect,Projection::map10()) else{return;};
    for intent in intents {
        let cursor=match intent {Intent::Camera(p)|Intent::Move(p)=>p};let Some(point)=projection.inverse(rect,cursor) else {continue;};
        match intent {
            // Preserve current focus Y, exactly as the existing arrow pan does.
            // Camera inspection does not require a walkable cell; no guessed
            // wall height or mutation of the native camera solver is involved.
            Intent::Camera(_)=>{camera.minimap_focus();focus.0.x=point.x/20.;focus.0.z=point.z/20.;}
            Intent::Move(_)=>{
                // Ordinary navigation validation. Never relocate a blocked cell.
                if terrain.0.ground(point).is_none() {continue;}
                if let Err(error)=connection.send_action(openleague_core::Action::Move{point}) {connection.report(&error);break;}
            }
        }
    }
}
#[cfg(test)] #[path="native_minimap_input_tests.rs"] mod tests;
