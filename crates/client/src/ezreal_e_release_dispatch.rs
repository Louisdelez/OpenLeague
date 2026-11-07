//! Exactly one drain of accepted E release VFX births per real client frame.
//! Independent audio owns its own queue. Effects only borrow this immutable batch.
use bevy::{diagnostic::FrameCount,prelude::*};
use crate::ezreal_e_release_events::{Request,State as Events};
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
            return Err("E release VFX batch is not from the current frame/context");
        }
        Ok(&self.requests)
    }
}
fn collect(frame:Res<FrameCount>,clock:Res<crate::native_effect_clock::EffectClock>,
    connection:Res<crate::Connection>,mut state:ResMut<crate::Match>,mut batch:ResMut<Batch>){
    batch.publish(frame.0,clock.now,connection.ready()&&clock.presentation_ready(),clock.paused(),&mut state.ezreal_e_release_events);
}
pub(crate) struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App){app.init_resource::<Batch>().add_systems(PostUpdate,collect.in_set(Dispatch));}
}
#[cfg(test)]
mod tests {
    use super::*;
    fn events()->Events {let(mut s,o,mut e)=crate::ezreal_e_release_events::test_fixture();s.tick+=1;
        crate::ezreal_e_release_events::test_event(&mut s,o,1,openleague_core::ezreal_e_accepted_releases::Phase::Arrival,
            openleague_core::Point{x:100.,z:5000.});e.observe_test_frame(&s,1.01,true,false).unwrap();e}
    #[test]
    fn one_phase_batch_is_drained_once_and_cannot_cross_frame_clock_or_epoch(){
        let mut e=events();let mut b=Batch::default();b.publish(1,1.01,true,false,&mut e);
        assert_eq!(b.requests(1,1.01,&e).unwrap().len(),1);assert!(e.take(1.01,true,false).is_empty());
        assert!(b.requests(2,1.01,&e).is_err());assert!(b.requests(1,1.02,&e).is_err());
        let(s,epoch,o)=e.context().unwrap();e.begin_epoch(s,epoch+1,o);assert!(b.requests(1,1.01,&e).is_err());
    }
    #[test]
    fn pause_and_duplicate_collection_consume_without_replay(){
        for paused in [false,true]{let mut e=events();let mut b=Batch::default();b.publish(1,1.01,true,paused,&mut e);
            if paused{assert!(b.requests(1,1.01,&e).unwrap().is_empty());}else{b.publish(1,1.01,true,false,&mut e);assert!(b.requests(1,1.01,&e).is_err());}
            b.publish(2,1.01,true,false,&mut e);assert!(b.requests(2,1.01,&e).unwrap().is_empty());}
    }
}
