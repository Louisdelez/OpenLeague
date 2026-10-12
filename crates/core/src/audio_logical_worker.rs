//! Persistent9214F0 worker composed with backend-reference ownership and routes.
//! The device adapter owns actual creation, refresh, command submission and release.
//! No backend reference is allocated until it returns an owned physical voice.
use crate::{audio_backend_references::Registry,audio_logical_registration::{Manager,Entry,WorkerCommand},audio_routing::{VoiceRoute,ListenerMaskCommand},audio_emitter_position::{self,PositionUpdate}};

pub struct Created<V> {pub voice:Option<V>,pub actor_resolved:bool}
pub trait Backend {
    type Voice;
    /// Native6CE0E0 ->6F79D0. Preserve event, actor field1C, XYZ and age.
    /// The adapter must report actual creation failure and retain physical ownership.
    fn create(&mut self,entry:&Entry)->Created<Self::Voice>;
    fn engine_available(&self)->bool;
    fn object_id(&self,voice:&Self::Voice)->i32;
    fn submit_position(&mut self,command:PositionUpdate);
    fn refresh(&mut self,voice:&Self::Voice);
    fn submit_listener_mask(&mut self,command:ListenerMaskCommand);
    /// Native release precedes dropping the retained owner. Implement the real
    /// release backend; a silent placeholder must not be connected to runtime.
    fn release(&mut self,voice:&mut Self::Voice);
}
#[derive(Debug,PartialEq)]
pub struct InvalidPosition {pub backend_reference:i32,pub error:audio_emitter_position::Error}
/// Runs creates, repeated dirty updates, then releases in qualified manager order.
/// Position validation failures remain explicit. Manager producers already reject
/// nonfinite positions, so they indicate invalid restored/caller state here.
pub fn process<B:Backend>(manager:&mut Manager,voices:&mut Registry<B::Voice>,backend:&mut B)->Vec<InvalidPosition> {
    let mut errors=Vec::new();
    manager.process_pending(|command| {
        match command {
            WorkerCommand::Create {entry,..}=>{
                let created=backend.create(&entry);
                return voices.retain_created(entry.field1c_raw,created.actor_resolved,created.voice);
            },
            WorkerCommand::Position {backend_reference,position}=>{
                if let Some(entry)=voices.get(backend_reference as u32){
                    let route=VoiceRoute{object_id:backend.object_id(&entry.voice),actor_id:entry.actor_id};
                    match audio_emitter_position::dispatch(Some(route),backend.engine_available(),position){
                        Ok(dispatch)=>{
                            if let Some(command)=dispatch.position_update{backend.submit_position(command);}
                            if dispatch.refresh_voice{backend.refresh(&entry.voice);}
                        },
                        Err(error)=>errors.push(InvalidPosition{backend_reference,error}),
                    }
                }
            },
            WorkerCommand::Boolean {backend_reference,value_raw}=>{
                if let Some(entry)=voices.get(backend_reference as u32){
                    let route=VoiceRoute{object_id:backend.object_id(&entry.voice),actor_id:entry.actor_id};
                    if let Some(command)=crate::audio_routing::listener_update(Some(route),backend.engine_available(),value_raw){backend.submit_listener_mask(command);}
                }
            },
            WorkerCommand::Release {backend_reference}=>{
                // Backend release is a native void operation. Ownership is erased
                // afterwards; a managed voice finalizer may run on this drop.
                let result=voices.release(backend_reference as u32,|voice|{backend.release(voice);Ok::<(),std::convert::Infallible>(())});
                match result{Ok(_)=>{},Err(never)=>match never{}}
            },
        }
        0
    });
    errors
}

#[cfg(test)] mod tests {
    use super::*;
    use crate::audio_requests::Request;
    use std::{cell::RefCell,rc::Rc};
    struct Voice{object:i32,events:Rc<RefCell<Vec<String>>>}
    impl Drop for Voice{fn drop(&mut self){self.events.borrow_mut().push("drop".into());}}
    struct Device{available:bool,create_ok:bool,object:i32,events:Rc<RefCell<Vec<String>>>}
    impl Backend for Device {
        type Voice=Voice;
        fn create(&mut self,entry:&Entry)->Created<Voice>{
            assert_eq!(entry.event,"Play_sfx_TT_Shopkeeper_idle1");assert_eq!(entry.age,0.25);
            self.events.borrow_mut().push("create".into());
            Created{voice:self.create_ok.then(||Voice{object:self.object,events:self.events.clone()}),actor_resolved:false}
        }
        fn engine_available(&self)->bool{self.available}
        fn object_id(&self,voice:&Voice)->i32{voice.object}
        fn submit_position(&mut self,c:PositionUpdate){assert_eq!(c.orientation,audio_emitter_position::OrientationState::NotInitializedByNativeProducer);assert_eq!(c.position,[7.,8.,9.]);self.events.borrow_mut().push(format!("position:{}",c.object_id));}
        fn refresh(&mut self,_:&Voice){self.events.borrow_mut().push("refresh".into());}
        fn submit_listener_mask(&mut self,c:ListenerMaskCommand){self.events.borrow_mut().push(format!("mask:{}:{}",c.object_id,c.listener_mask));}
        fn release(&mut self,_:&mut Voice){self.events.borrow_mut().push("release".into());}
    }
    fn setup()->(Manager,Registry<Voice>,Device){
        let mut manager=Manager::default();manager.register(&Request{slot:0x10,event:"Play_sfx_TT_Shopkeeper_idle1".into(),position:[1.,2.,3.],age:0.25}).unwrap();
        (manager,Registry::default(),Device{available:true,create_ok:true,object:2,events:Rc::new(RefCell::new(Vec::new()))})
    }
    #[test] fn pending_create_updates_and_release_preserve_native_order_and_zero_reference(){
        let (mut manager,mut voices,mut backend)=setup();
        manager.update_position(1,[7.,8.,9.]).unwrap();manager.update_boolean(1,255);manager.queue_release(1);manager.queue_release(1);
        assert!(process(&mut manager,&mut voices,&mut backend).is_empty());
        assert_eq!(*backend.events.borrow(),["create","position:2","refresh","mask:2:0","position:2","refresh","mask:2:0","release","drop"]);
        assert_eq!(voices.next_id(),1);assert!(voices.get(0).is_none());assert!(manager.entry(1).is_none());
        assert!(manager.pending_key_calls().is_empty()&&manager.update_keys().is_empty()&&manager.release_keys().is_empty());
        backend.events.borrow_mut().clear();assert!(process(&mut manager,&mut voices,&mut backend).is_empty());assert!(backend.events.borrow().is_empty());
    }
    #[test] fn failed_creation_does_not_allocate_reference_or_manufacture_update_targets(){
        let (mut manager,mut voices,mut backend)=setup();backend.create_ok=false;
        manager.update_position(1,[7.,8.,9.]).unwrap();manager.update_boolean(1,1);
        assert!(process(&mut manager,&mut voices,&mut backend).is_empty());assert_eq!(manager.entry(1).unwrap().backend_reference,-1);assert_eq!(voices.next_id(),0);
        manager.queue_release(1);process(&mut manager,&mut voices,&mut backend);assert_eq!(*backend.events.borrow(),["create"]);assert!(manager.entry(1).is_none());
    }
    #[test] fn unavailable_engine_and_invalid_object_still_refresh_but_never_submit_position(){
        for (available,object) in [(false,2),(true,-1),(true,0)]{
            let (mut manager,mut voices,mut backend)=setup();backend.available=available;backend.object=object;
            process(&mut manager,&mut voices,&mut backend);assert_eq!(manager.entry(1).unwrap().backend_reference,0);
            backend.events.borrow_mut().clear();manager.update_position(1,[7.,8.,9.]).unwrap();process(&mut manager,&mut voices,&mut backend);
            assert_eq!(*backend.events.borrow(),["refresh"]);
        }
    }
    #[test] fn actor_bound_reference_skips_unbound_position_and_listener_routes(){
        let (mut manager,mut voices,mut backend)=setup();
        let id=voices.retain_created(7,true,Some(Voice{object:2,events:backend.events.clone()}));assert_eq!(id,0);
        // Explicitly restored native worker state: successful create maps to bound0.
        manager.process_pending(|command|{assert!(matches!(command,WorkerCommand::Create{..}));0});
        manager.update_position(1,[7.,8.,9.]).unwrap();manager.update_boolean(1,1);
        process(&mut manager,&mut voices,&mut backend);assert!(backend.events.borrow().is_empty());
        manager.queue_release(1);process(&mut manager,&mut voices,&mut backend);assert_eq!(*backend.events.borrow(),["release","drop"]);
    }
}
