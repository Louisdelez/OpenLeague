//! Exactly one drain of accepted impact VFX births per real client frame.
//! Independent audio owns its own queue. Effects only borrow this immutable batch.
use bevy::{diagnostic::FrameCount,prelude::*};
use crate::ezreal_r_flash_events::{Request,State as Events};
#[derive(SystemSet,Debug,Clone,Copy,PartialEq,Eq,Hash)]
pub(crate) struct Dispatch;
#[derive(Resource,Default)]
pub(crate) struct Batch {frame:Option<u32>,clock:Option<u64>,context:Option<(u64,u64,u32)>,requests:Vec<Request>}
impl Batch {
    fn publish(&mut self,frame:u32,now:f64,ready:bool,paused:bool,events:&mut Events){
        if self.frame==Some(frame) {
            // A duplicate scheduled collector is a configuration error. It cannot
            // reuse the prior batch or create a second drain within that frame.
            self.clock=None;self.context=None;self.requests.clear();return;
        }
        self.frame=Some(frame);self.clock=Some(now.to_bits());
        self.requests=events.take(now,ready,paused);self.context=events.context();
        if !ready || !events.presentation_ready(now){self.context=None;self.requests.clear();}
    }
    pub(crate) fn requests<'a>(&'a self,frame:u32,now:f64,events:&Events)->Result<&'a [Request],&'static str>{
        if self.frame!=Some(frame) || self.clock!=Some(now.to_bits()) || self.context.is_none()
            || self.context!=events.context() || !events.presentation_ready(now) {
            return Err("impact VFX batch is not from the current frame/context");
        }
        Ok(&self.requests)
    }
}
fn collect(frame:Res<FrameCount>,clock:Res<crate::native_effect_clock::EffectClock>,
    connection:Res<crate::Connection>,mut state:ResMut<crate::Match>,mut batch:ResMut<Batch>){
    batch.publish(frame.0,clock.now,connection.ready()&&clock.presentation_ready(),clock.paused(),&mut state.ezreal_r_flash_events);
}
pub(crate) struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App){app.init_resource::<Batch>().add_systems(PostUpdate,collect.in_set(Dispatch));}
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::ezreal_r_flash_events::test_fixture;
    #[test]
    fn one_drain_fans_out_to_both_effects_and_never_an_older_frame(){
        let (_,_,mut events)=test_fixture([100.,5000.]);let mut batch=Batch::default();
        batch.publish(12,1.01,true,false,&mut events);
        let flash=batch.requests(12,1.01,&events).unwrap();let dust=batch.requests(12,1.01,&events).unwrap();
        assert_eq!(flash,dust);assert_eq!(flash.len(),1);
        assert!(batch.requests(13,1.01,&events).is_err());assert!(batch.requests(12,1.02,&events).is_err());
        assert!(events.take(1.01,true,false).is_empty());
        batch.publish(13,1.01,true,false,&mut events);assert!(batch.requests(13,1.01,&events).unwrap().is_empty());
    }
    #[test]
    fn pause_disconnect_and_duplicate_collector_consume_without_retry(){
        for mode in 0..3 {let (_,_,mut events)=test_fixture([100.,5000.]);let mut b=Batch::default();
            b.publish(5,1.01,mode!=1,mode==0,&mut events);
            if mode==2 {b.publish(5,1.01,true,false,&mut events);}
            if mode==0 {assert!(b.requests(5,1.01,&events).unwrap().is_empty());}
            else {assert!(b.requests(5,1.01,&events).is_err());}
            b.publish(6,1.01,true,false,&mut events);
            assert!(match b.requests(6,1.01,&events){Ok(r)=>r.is_empty(),Err(_)=>true});
        }
    }
    #[test]
    fn current_epoch_and_revocation_remain_required_after_the_batch_is_published(){
        let (_,owner,mut events)=test_fixture([100.,5000.]);let mut b=Batch::default();b.publish(1,1.01,true,false,&mut events);
        events.begin_epoch(7,2,owner);assert!(b.requests(1,1.01,&events).is_err());
        let (_,_,mut events)=test_fixture([100.,5000.]);b.publish(2,1.01,true,false,&mut events);
        events.suspend();assert!(b.requests(2,1.01,&events).is_err());
    }
}
