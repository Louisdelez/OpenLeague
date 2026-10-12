//! Local pointer gesture over the original six inventory rectangles.
//! No native drag callbacks/threshold, optimistic inventory mutation or queued retry.
use bevy::{prelude::*,input::ButtonState,window::{PrimaryWindow,WindowEvent}};
use openleague_core::Action;

#[derive(SystemSet,Debug,Clone,Copy,PartialEq,Eq,Hash)]
pub(crate) struct InputSet;
#[derive(Clone,Debug,PartialEq,Eq)]
struct Context {
    identity:(u64,u32,Option<u64>),
    window:u64,
    inventory:[Option<u32>;6],
    counts:[u8;6],
    rectangles:[[u32;4];6],
}
#[derive(Clone,Debug)]
struct Drag { from:u8, context:Context }
#[derive(Resource,Default)]
pub(crate) struct Capture {
    drag:Option<Drag>,
    cancelled_until_release:bool,
    block_frame:bool,
    ordered:OrderedPointer,
}
#[derive(Default)]
struct OrderedPointer {
    window:Option<Entity>,
    focused:bool,
    point:Option<Vec2>,
    left_down:bool,
    right_down:bool,
}
impl Capture {
    pub(crate) fn blocks_commands(&self)->bool {self.block_frame}
    fn cancel(&mut self,input:&Pointer) {
        self.drag=None;
        self.cancelled_until_release=input.focused && input.left_down && !input.left_released;
    }
    fn step(&mut self,input:&Pointer,context:Option<Context>)->Option<Action> {
        let had_capture=self.drag.is_some() || self.cancelled_until_release;
        self.block_frame=had_capture;
        let hovered=context.as_ref().and_then(|c|slot_at(&c.rectangles,input.point));
        if hovered.is_some() && (input.left_pressed || input.right_pressed) {self.block_frame=true;}
        if self.cancelled_until_release {
            if !input.focused || !input.left_down || input.left_released {self.cancelled_until_release=false;}
            return None;
        }
        // A direct contradictory sample has no ordered press location. Production
        // ordered_frame supplies one edge at a time, including same-frame drags.
        if !input.focused || input.focus_lost || input.escape || context.is_none()
            || (input.left_pressed && input.left_released) {
            if had_capture {self.cancel(input);}
            return None;
        }
        let context=context.unwrap();
        if let Some(drag)=self.drag.as_ref() {
            if drag.context!=context || input.right_pressed {
                self.cancel(input);return None;
            }
            if input.left_released {
                let from=drag.from;
                let expected_inventory=drag.context.inventory;
                let expected_counts=drag.context.counts;
                self.drag=None;
                return hovered.filter(|to|*to!=from).map(|to|Action::SwapItemsChecked{
                    from,to,expected_inventory,expected_counts,
                });
            }
            if !input.left_down {self.cancel(input);}
            return None;
        }
        if input.left_pressed && input.left_down && !input.right_pressed && !input.right_down {
            if let Some(from)=hovered.filter(|slot|context.inventory[*slot as usize].is_some()) {
                self.drag=Some(Drag{from,context});self.block_frame=true;
            }
        }
        None
    }
}
impl Capture {
    /// Consume the same aggregate event stream Winit supplies, in OS order.
    /// No cursor sample from the end of the frame is used as a press position.
    fn ordered_frame<'a>(&mut self,window:Option<Entity>,focused:bool,context:Option<Context>,
        events:impl Iterator<Item=&'a WindowEvent>,mut observe:impl FnMut(&str,&Pointer,&Self,Option<&Action>),
    )->Vec<Action> {
        let events=events.collect::<Vec<_>>();
        // The Window/rectangles already describe the end of this event batch.
        // Coordinates from before a resize/scale change cannot use that geometry.
        let geometry_changed=events.iter().any(|event|match event {
            WindowEvent::WindowResized(e)=>Some(e.window)==window,
            WindowEvent::WindowScaleFactorChanged(e)=>Some(e.window)==window,
            WindowEvent::WindowBackendScaleFactorChanged(e)=>Some(e.window)==window,
            _=>false,
        });
        let context=if geometry_changed {None}else{context};
        let mut blocked=self.drag.is_some() || self.cancelled_until_release;
        if self.ordered.window!=window {
            self.drag=None;self.cancelled_until_release=false;
            self.ordered=OrderedPointer{window,focused,..default()};
        }
        if window.is_none() || !focused {self.ordered.point=None;self.ordered.focused=false;}
        let mut frame_pointer=Pointer{point:self.ordered.point,focused:focused && self.ordered.focused,
            left_down:self.ordered.left_down,right_down:self.ordered.right_down,..default()};
        // Validate current session/epoch/inventory even in a frame without events.
        self.step(&frame_pointer,context.clone());blocked|=self.block_frame;
        observe(if geometry_changed{"frame_gate_geometry_changed"}else{"frame_gate"},&frame_pointer,self,None);
        let mut actions=Vec::new();
        for event in events {
            let mut pointer=Pointer{point:self.ordered.point,focused:focused && self.ordered.focused,
                left_down:self.ordered.left_down,right_down:self.ordered.right_down,..default()};
            let label=match event {
                WindowEvent::CursorMoved(e) if Some(e.window)==window => {
                    self.ordered.point=Some(e.position).filter(|p|p.is_finite());
                    pointer.point=self.ordered.point;"cursor"
                }
                WindowEvent::CursorLeft(e) if Some(e.window)==window => {
                    self.ordered.point=None;pointer.point=None;"cursor_left"
                }
                WindowEvent::MouseButtonInput(e) if Some(e.window)==window => {
                    match (e.button,e.state) {
                        (MouseButton::Left,ButtonState::Pressed) => {
                            pointer.left_pressed=!self.ordered.left_down;
                            self.ordered.left_down=true;pointer.left_down=true;
                        }
                        (MouseButton::Left,ButtonState::Released) => {
                            pointer.left_released=self.ordered.left_down;
                            self.ordered.left_down=false;pointer.left_down=false;
                        }
                        (MouseButton::Right,ButtonState::Pressed) => {
                            pointer.right_pressed=!self.ordered.right_down;self.ordered.right_down=true;pointer.right_down=true;
                        }
                        (MouseButton::Right,ButtonState::Released) => {self.ordered.right_down=false;pointer.right_down=false;},
                        _ => continue,
                    }
                    "button"
                }
                WindowEvent::KeyboardInput(e) if Some(e.window)==window
                    && e.key_code==KeyCode::Escape && e.state==ButtonState::Pressed => {
                    pointer.escape=true;"escape"
                }
                WindowEvent::WindowFocused(e) if Some(e.window)==window => {
                    self.ordered.focused=e.focused;pointer.focused=focused && e.focused;
                    if !e.focused {
                        pointer.focus_lost=true;self.ordered.point=None;
                        self.ordered.left_down=false;self.ordered.right_down=false;
                        pointer.left_down=false;pointer.right_down=false;pointer.point=None;
                    }
                    "focus"
                }
                WindowEvent::KeyboardFocusLost(_) => {
                    pointer.focus_lost=true;self.ordered.point=None;
                    // This global keyboard notification does not carry a window.
                    // Retire the gesture/anchor, but do not latch a still-focused
                    // primary window off until a WindowFocused(true) that may not follow.
                    self.ordered.focused=focused;self.ordered.left_down=false;self.ordered.right_down=false;
                    pointer.focused=focused;pointer.left_down=false;pointer.right_down=false;pointer.point=None;"keyboard_focus_lost"
                }
                WindowEvent::WindowResized(e) if Some(e.window)==window => {
                    pointer.focus_lost=true;self.ordered.point=None;pointer.point=None;"resize"
                }
                WindowEvent::WindowScaleFactorChanged(e) if Some(e.window)==window => {
                    pointer.focus_lost=true;self.ordered.point=None;pointer.point=None;"scale_factor"
                }
                WindowEvent::WindowBackendScaleFactorChanged(e) if Some(e.window)==window => {
                    pointer.focus_lost=true;self.ordered.point=None;pointer.point=None;"backend_scale_factor"
                }
                WindowEvent::WindowDestroyed(e) if Some(e.window)==window => {
                    pointer.focus_lost=true;self.ordered.point=None;pointer.point=None;
                    self.ordered.focused=false;pointer.focused=false;"window_destroyed"
                }
                _ => continue,
            };
            let action=self.step(&pointer,context.clone());blocked|=self.block_frame;
            if geometry_changed && label=="button" {blocked=true;}
            observe(label,&pointer,self,action.as_ref());
            if let Some(action)=action {actions.push(action);}
            frame_pointer=pointer;
        }
        // Every event in this frame shares one command-suppression decision.
        // A cursor event after release must not unblock world/learning actions.
        if geometry_changed {self.ordered.point=None;}
        self.block_frame=blocked;
        observe("frame_end",&frame_pointer,self,None);
        actions
    }
}
#[derive(Default)]
struct Pointer {
    point:Option<Vec2>,focused:bool,focus_lost:bool,escape:bool,
    left_pressed:bool,left_released:bool,left_down:bool,right_pressed:bool,right_down:bool,
}
fn slot_at(rectangles:&[[u32;4];6],point:Option<Vec2>)->Option<u8> {
    let point=point.filter(|point|point.is_finite())?;
    let mut found=None;
    for (slot,bits) in rectangles.iter().enumerate() {
        let [x,y,right,bottom]=bits.map(f32::from_bits);
        if point.x>=x && point.y>=y && point.x<right && point.y<bottom {
            if found.is_some() {return None;} // Never choose arbitrarily between overlapping slots.
            found=Some(slot as u8);
        }
    }
    found
}
fn rectangles(panels:&[crate::native_hud_panels::Panel],dimensions:[u32;2],scalar:f32,dpi:f32)->Result<[[u32;4];6],String> {
    if panels.len()!=6 {return Err("six native inventory rectangles required".into());}
    let mut result=[[0;4];6];
    for (slot,panel) in panels.iter().enumerate() {
        // Exactly the same source enable-bit and payload as an occupied icon.
        // Empty destinations have geometry, but do not gain a visible image.
        let mut storage=super::copy_storage(&panel.storage);storage.set_word(0x48,storage.flags()|1);
        let panel=crate::native_hud_panels::Panel{name:panel.name.clone(),path:panel.path.clone(),storage};
        let (node,_)=crate::native_hud_panels::payload(&panel,dimensions,scalar,dpi,Handle::default())?;
        let (Val::Px(x),Val::Px(y),Val::Px(width),Val::Px(height))=(node.left,node.top,node.width,node.height) else {return Err("inventory geometry is not in logical pixels".into());};
        let rect=[x,y,x+width,y+height];
        if rect.iter().any(|v|!v.is_finite()) || width<=0. || height<=0. {return Err("inventory rectangle is not finite and positive".into());}
        result[slot]=rect.map(f32::to_bits);
    }
    Ok(result)
}
fn context(connection:&crate::Connection,game:&crate::Match,shop:&crate::shop_ui::Filters,
    panels:&[crate::native_hud_panels::Panel],window_id:Entity,window:&Window,scalar:f32)->Option<Context> {
    if shop.open || shop.focused {return None;}
    let identity=connection.inventory_input_identity()?;
    let snapshot=game.snapshot.as_ref()?;
    if snapshot.session!=identity.0 || snapshot.winner.is_some() {return None;}
    let player=snapshot.players.iter().find(|p|p.id==identity.1)?;
    if !player.health.is_finite() || player.health<=0. {return None;}
    // Use the renderer's validation too: unsupported items never become invisible draggable items.
    super::values(snapshot,Some(identity.1)).ok()??;
    Some(Context{identity,window:window_id.to_bits(),inventory:player.inventory,counts:player.inventory_counts,
        rectangles:rectangles(panels,[window.physical_width(),window.physical_height()],scalar,window.scale_factor()).ok()?})
}
#[derive(Default)]
pub(super) struct Trace {
    initialized:bool,path:Option<std::path::PathBuf>,frame:u64,
    rows:std::collections::VecDeque<serde_json::Value>,dropped_frames:u64,
}
impl Trace {
    fn enabled(&mut self)->bool {
        if !self.initialized {self.initialized=true;self.path=std::env::var_os("OPENLEAGUE_NATIVE_HUD_INVENTORY_DRAG_TRACE").map(Into::into);}
        self.path.is_some()
    }
    fn record(&mut self,row:serde_json::Value) {
        if self.rows.len()==128 {self.rows.pop_front();self.dropped_frames+=1;}
        self.rows.push_back(row);
        if let Some(path)=&self.path {
            let value=serde_json::json!({"schema":1,"kind":"ordered_inventory_drag_observation","complete":false,
                "max_frames":128,"max_decisions_per_frame":64,"dropped_frames":self.dropped_frames,"frames":self.rows});
            match serde_json::to_vec_pretty(&value).map_err(std::io::Error::other).and_then(|bytes|std::fs::write(path,bytes)) {
                Ok(())=>{},Err(error)=>eprintln!("Inventory drag trace failed: {error}"),
            }
        }
    }
}
pub(super) fn input(mut capture:ResMut<Capture>,icons:Res<super::Icons>,game:Res<crate::Match>,
    mut connection:ResMut<crate::Connection>,shop:Res<crate::shop_ui::Filters>,
    windows:Query<(Entity,&Window),With<PrimaryWindow>>,viewport:Res<crate::native_hud_viewport::Viewport>,
    mut events:MessageReader<WindowEvent>,mut trace:Local<Trace>) {
    let window=windows.single().ok();
    let current=window.filter(|_|icons.error.is_none() && icons.signature.is_some())
        .and_then(|(entity,w)|context(&connection,&game,&shop,&icons.panels,entity,w,viewport.scalar));
    let enabled=trace.enabled();trace.frame=trace.frame.saturating_add(1);
    let mut rows=Vec::new();let mut dropped=0u64;
    let had_capture=capture.drag.is_some() || capture.cancelled_until_release;
    let actions=capture.ordered_frame(window.map(|(e,_)|e),window.is_some_and(|(_,w)|w.focused),current.clone(),events.read(),|event,p,s,a| {
        if !enabled {return;}
        if rows.len()==64 {dropped+=1;return;}
        rows.push(serde_json::json!({"event":event,"point":p.point.map(|v|v.to_array()),"focused":p.focused,"focus_lost":p.focus_lost,
            "escape":p.escape,"left_pressed":p.left_pressed,"left_released":p.left_released,"left_down":p.left_down,"right_pressed":p.right_pressed,"right_down":p.right_down,
            "hovered":current.as_ref().and_then(|c|slot_at(&c.rectangles,p.point)),"captured_from":s.drag.as_ref().map(|d|d.from),
            "cancelled_until_release":s.cancelled_until_release,"block_frame":s.block_frame,"action":a}));
    });
    let mut sends=Vec::new();
    for action in actions {
        // Retire the gesture BEFORE sending. Failure may already have reached
        // the kernel; Connection owns its sequence/recovery, never retry here.
        let result=connection.send_action(action);
        if let Err(error)=&result {connection.report(error);}
        // send_action returns public metadata only, never a secure envelope/key.
        if enabled {sends.push(match result {Ok(public)=>serde_json::json!({"sent":true,"public":public}),Err(error)=>serde_json::json!({"sent":false,"error":error})});}
    }
    if enabled && (had_capture || rows.len()>2 || dropped>0 || !sends.is_empty()) {
        let row=serde_json::json!({"frame":trace.frame,"unix_ms":std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).ok().map(|v|v.as_millis()),
            "session":game.snapshot.as_ref().map(|s|s.session),"tick":game.snapshot.as_ref().map(|s|s.tick),
            "identity":connection.inventory_input_identity(),"ready":connection.ready(),"shop_open":shop.open,"shop_focused":shop.focused,
            "icons_ready":icons.signature.is_some(),"icons_error":icons.error,"context_valid":current.is_some(),
            "context_inventory":current.as_ref().map(|c|c.inventory),"context_counts":current.as_ref().map(|c|c.counts),
            "rectangles":current.as_ref().map(|c|c.rectangles.map(|r|r.map(f32::from_bits))),
            "window":window.map(|(e,w)|serde_json::json!({"entity":e.to_bits(),"focused":w.focused,"physical":[w.physical_width(),w.physical_height()],"dpi":w.scale_factor(),"cursor_final_diagnostic_only":w.cursor_position().map(|v|v.to_array())})),
            "decisions":rows,"dropped_decisions":dropped,"sends":sends});
        trace.record(row);
    }
}
#[cfg(test)]
#[path="native_hud_inventory_drag_tests.rs"]
mod tests;
