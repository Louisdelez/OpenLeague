//! One event, one stationary quad under an explicit local ground/flex policy.
use std::collections::BTreeMap;
use crate::{ezreal_q_flash_events::{Identity,Request,State as Events},ezreal_q_flash_profile::Profile};
pub(crate) const MAX_FLASHES:usize=32;
#[derive(Clone,Debug)]
pub(crate) struct Entry {pub(crate) request:Request,pub(crate) center:[f32;3],pub(crate) scale:f32,
    pub(crate) angle:f32,pub(crate) progress:f32,started:f64,life:f32,factor:f32}
#[derive(Clone,Default)]
pub(crate) struct State {pub(crate) rows:BTreeMap<Identity,Entry>,context:Option<(u64,u64,u32)>,clock:Option<f64>}
impl State {
    pub(crate) fn plan(&self,events:&Events,requests:&[Request],now:f64,paused:bool,profile:&Profile,
        mut terrain:impl FnMut([f32;2])->Result<f32,&'static str>)->Result<Self,&'static str>{
        let context=events.context().filter(|(_,epoch,viewer)|*epoch!=0&&*viewer!=0).ok_or("flash epoch unavailable")?;
        if !events.presentation_ready(now) || !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            return Err("flash clock or event authority unavailable");
        }
        if requests.len()>MAX_FLASHES {return Err("flash request budget exceeded");}
        let mut next=if self.context==Some(context){self.clone()}else{Self {context:Some(context),..Self::default()}};
        // Revocation wins even while the effect clock is paused. No target ID lookup.
        next.rows.retain(|_,entry|events.authorizes(&entry.request)
            && now>=entry.started && now-entry.started<f64::from(entry.life)
            // Local normalized lifetime is f32. Rounding onto the endpoint
            // retires this entry normally instead of failing the whole host.
            && ((now-entry.started) as f32/entry.life)<1.);
        for request in requests {
            if paused || !events.authorizes(request) {continue;}
            if next.rows.contains_key(&request.identity) {return Err("flash birth identity repeated");}
            if next.rows.len()==MAX_FLASHES {return Err("flash live budget exceeded");}
            let (life,factor,angle)=profile.birth()?;
            let y=terrain([request.position.x,request.position.z])?;
            if !y.is_finite(){return Err("flash terrain nonfinite");}
            next.rows.insert(request.identity,Entry {request:*request,center:[request.position.x,y,request.position.z],
                scale:factor,angle,progress:0.,started:now,life,factor});
        }
        for entry in next.rows.values_mut() {
            let xz=[entry.request.position.x,entry.request.position.z];
            if !xz.into_iter().all(f32::is_finite){return Err("flash public point nonfinite");}
            let y=terrain(xz)?;if !y.is_finite(){return Err("flash terrain nonfinite");}
            entry.center=[xz[0],y,xz[1]];
            let age=(now-entry.started) as f32/entry.life;
            entry.progress=age;entry.scale=profile.scale_at(entry.factor,age)?;
        }
        next.clock=Some(now);Ok(next)
    }
}
pub(crate) fn map10_height(xz:[f32;2])->Result<f32,&'static str>{
    let data=openleague_core::map10_dense_height::binding().map_err(|_|"flash Map10 dense binding unavailable")?;
    data.sample_local_f32(xz).map_err(|_|"flash point outside valid Map10 dense data")
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::ezreal_q_flash_events::test_fixture;
    #[test]
    fn one_birth_scales_once_freezes_on_pause_and_expires_without_rebirth(){
        let p=Profile::load().unwrap();let (mut snapshot,owner,mut events)=test_fixture([100.,5000.]);
        let requests=events.take(1.01,true,false);assert_eq!(requests.len(),1);
        let state=State::default().plan(&events,&requests,1.01,false,&p,|_|Ok(75.)).unwrap();
        assert_eq!(state.rows.len(),1);let entry=state.rows.values().next().unwrap();assert_eq!((entry.scale,entry.angle),(150.,1.));
        let half=state.plan(&events,&[],1.01+f64::from(0.3f32)*0.5,false,&p,|_|Ok(75.)).unwrap();
        assert!((half.rows.values().next().unwrap().scale-75.).abs()<0.6);
        let time=half.clock.unwrap();snapshot.tick+=1;
        events.observe_test_frame(&snapshot,time,true,true).unwrap();assert!(events.take(time,true,true).is_empty());
        let frozen=half.plan(&events,&[],time,true,&p,|_|Ok(75.)).unwrap();
        assert_eq!(frozen.rows.values().next().unwrap().scale,half.rows.values().next().unwrap().scale);
        let end=state.plan(&events,&[],1.01+f64::from(0.3f32),false,&p,|_|Ok(75.)).unwrap();assert!(end.rows.is_empty());
        let rounded=state.plan(&events,&[],1.01+f64::from(0.3f32)-1e-10,false,&p,|_|Ok(75.)).unwrap();
        assert!(rounded.rows.is_empty());
        assert!(events.take(1.31,true,false).is_empty());assert_eq!(owner,requests[0].identity.owner);
    }
    #[test]
    fn terrain_errors_nonfinite_and_real_dense_bounds_never_publish_zero_substitutes(){
        let p=Profile::load().unwrap();let (_,_,mut events)=test_fixture([100.,5000.]);let requests=events.take(1.01,true,false);
        for fail in [None,Some(f32::NAN)] {
            assert!(State::default().plan(&events,&requests,1.01,false,&p,|_|fail.ok_or("unavailable")).is_err());
        }
        let grid=openleague_core::map10_dense_height::binding().unwrap();let xz=grid.grid().spec().min_xz;
        assert_eq!(map10_height(xz).unwrap().to_bits(),0x4315_7f68);
        assert!(map10_height([xz[0]-1.,xz[1]]).is_err());assert!(map10_height([f32::NAN,xz[1]]).is_err());
    }
    #[test]
    fn frozen_contact_survives_target_absence_but_same_batch_reveal_cannot_keep_old_quad(){
        let p=Profile::load().unwrap();let (mut snapshot,_,mut events)=test_fixture([100.,5000.]);
        let requests=events.take(1.01,true,false);let state=State::default().plan(&events,&requests,1.01,false,&p,|_|Ok(9.)).unwrap();
        assert!(!snapshot.players.iter().any(|actor|actor.id==900)); // Codec fixture has no live target entity.
        let old=snapshot.ezreal_q_accepted_impacts.clone();snapshot.tick+=1;snapshot.ezreal_q_accepted_impacts=None;
        events.observe_test_frame(&snapshot,1.02,true,false).unwrap();snapshot.tick+=1;snapshot.ezreal_q_accepted_impacts=old;
        events.observe_test_frame(&snapshot,1.02,true,false).unwrap();assert!(events.take(1.02,true,false).is_empty());
        assert!(state.plan(&events,&[],1.02,false,&p,|_|Ok(9.)).unwrap().rows.is_empty());
        assert_eq!(state.rows.values().next().unwrap().center,[100.,9.,5000.]);
    }
}
