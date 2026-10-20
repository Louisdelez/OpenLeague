//! A current visible E episode owns one RNG and all three authored groups.
//! No historic path, target lookup, extrapolation or post-authorization tail.
use std::collections::{BTreeMap,BTreeSet};
use openleague_core::{native_random::Rng55,native_complex_particle_storage::GlobalVectors};
use crate::{ezreal_e_bolt_presentation::{CurrentE,Key},ezreal_e_bolt_local as local,
    ezreal_e_simple_parameters::Group,ezreal_e_simple_simulation as simple,
    ezreal_e_complex_parameters::Parameters as ComplexParameters,ezreal_e_complex_simulation as complex};
pub(crate) const MAX_EPISODES:usize=64;
pub(crate) const MAX_TOTAL_QUADS:usize=8192;
pub(crate) struct Profiles {pub complex:ComplexParameters,pub simple:[local::Simple;2]}
impl Profiles {
    pub(crate) fn load()->Result<Self,&'static str>{Ok(Self{
        complex:ComplexParameters::load(local::POLICY,local::complex_timing()?.life)?,
        simple:[local::Simple::load(Group::Magicdust)?,local::Simple::load(Group::Dust)?]})}
}
#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord)]
pub(crate) struct Identity {pub key:Key,pub epoch:u64,pub incarnation:u64}
impl From<&CurrentE> for Identity {
    fn from(s:&CurrentE)->Self{Self{key:s.key,epoch:s.epoch,incarnation:s.incarnation}}
}
#[derive(Clone)]
pub(crate) struct Entry {pub sample:CurrentE,pub complex:complex::State,pub simple:[simple::State;2],
    pub rng:Rng55,started:f64,clock:f64,pose:[u32;16],ordinal:u64}
fn identity_matrix()->[f32;16]{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1.}else{0.})}
impl Entry {
    fn new(sample:CurrentE,now:f64,p:&Profiles)->Result<Self,&'static str>{
        let pose=local::pose(&sample)?;let position:[u32;3]=pose[12..15].try_into().unwrap();
        let (complex,rng)=complex::State::new(&p.complex,0.,position.map(f32::from_bits),&local::random(&sample))?;
        let input=simple::Pose{previous:pose,current:pose,previous_inverse:local::translated_inverse(pose)?};
        Ok(Self{sample,complex,simple:[simple::State::new(0.,input)?,simple::State::new(0.,input)?],
            rng,started:now,clock:now,pose,ordinal:0})
    }
    fn plan(&self,sample:CurrentE,now:f64,p:&Profiles)->Result<Self,&'static str>{
        if Identity::from(&sample)!=Identity::from(&self.sample)||now<self.clock||now-self.clock>0.25{
            return Err("E current episode identity/step changed");}
        let pose=local::pose(&sample)?;let time=local::age(self.started,now)?;
        let ordinal=self.ordinal.checked_add(1).ok_or("E episode ordinal exhausted")?;
        let previous_words:[u32;3]=self.pose[12..15].try_into().unwrap();
        let current_words:[u32;3]=pose[12..15].try_into().unwrap();
        let previous_position=previous_words.map(f32::from_bits);let current_position=current_words.map(f32::from_bits);
        let instance=complex::Instance{duration:p.complex.timing.life,rate_owner_scale:1.,life_owner_scale:1.,
            life_coefficients:[0.;3],life_symmetry:0,limit:0,single_flag:0,stopped_flag:0,
            past_end:time>=p.complex.timing.life,globals:GlobalVectors{unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]},motion_scratch:[0;3]};
        let dynamics=complex::Dynamics{owner_delta:std::array::from_fn(|i|current_position[i]-previous_position[i]),
            owner_extra:[0.;3],default_vector:[0.;3],scale_owner:1.,lookup_modes:p.complex.lookup.modes,
            lookup_scale:p.complex.lookup.scale,lookup_offset:p.complex.lookup.offset,
            surface_direct:false,local_matrix:None,attach_matrix:None};
        let birth=complex::BirthSource{orientation:identity_matrix(),primary:identity_matrix(),world_acceleration:[0.;3],
            orbit_secondary:[0.;3],uv_aux:[0.;2],rate_multiplier:1.,distance_anchor:0.};
        // Original group order: Complex missile1, Simple magicdust, Simple dust.
        // Every plan is read-only; neither state nor shared RNG is committed if
        // any later group fails. Neutral external inputs are named by POLICY.
        let (complex,rng)=self.complex.plan(&p.complex,complex::Frame{provenance:local::POLICY,ordinal,time,
            previous_position,current_position,instance,birth,dynamics},&self.rng)?;
        let input=simple::Pose{previous:self.pose,current:pose,previous_inverse:local::translated_inverse(self.pose)?};
        let mut no_terrain=|_|Err("E local binding has no terrain callback");
        let (magic,rng)=self.simple[0].plan(&p.simple[0].parameters,&p.simple[0].frame(ordinal,time,input)?,&rng,&mut no_terrain)?;
        let (dust,rng)=self.simple[1].plan(&p.simple[1].parameters,&p.simple[1].frame(ordinal,time,input)?,&rng,&mut no_terrain)?;
        Ok(Self{sample,complex,simple:[magic,dust],rng,started:self.started,clock:now,pose,ordinal})
    }
    pub(crate) fn count(&self)->usize{self.complex.particles().len()+self.simple.iter().map(|s|s.live_indices().count()).sum::<usize>()}
}
#[derive(Clone,Default)]
pub(crate) struct State {pub rows:BTreeMap<Identity,Entry>,rejected:BTreeSet<Identity>,context:Option<(u64,u64)>,clock:Option<f64>}
impl State {
    pub(crate) fn reject_active(&mut self){
        self.rejected.extend(self.rows.keys().copied());self.rows.clear();
    }
    pub(crate) fn plan(&self,samples:&[CurrentE],now:f64,context:(u64,u64),p:&Profiles)->Result<Self,&'static str>{
        if !now.is_finite()||now<0.||samples.len()>MAX_EPISODES||context.1==0
            ||self.context==Some(context)&&self.clock.is_some_and(|old|now<old){return Err("E current host boundary invalid");}
        let mut ids=BTreeSet::new();let mut ordinals=BTreeSet::new();
        for sample in samples{
            if sample.key.session!=context.0||sample.epoch!=context.1||sample.key.owner==0||sample.key.team>1
                ||sample.key.ordinal==0||sample.incarnation==0||sample.sample_frame==0
                ||sample.authorization_frame<sample.sample_frame||!ids.insert(Identity::from(sample))
                ||!ordinals.insert(sample.key.ordinal){return Err("E current host sample identity invalid");}
            local::pose(sample)?;
        }
        let mut next=if self.context==Some(context){self.clone()}else{Self{context:Some(context),..Self::default()}};
        next.rows.retain(|id,_|ids.contains(id));next.rejected.retain(|id|ids.contains(id));
        let mut total=0usize;
        for sample in samples{
            let id=Identity::from(sample);if next.rejected.contains(&id){continue;}
            let old=match next.rows.get(&id){Some(old)=>old.clone(),None=>Entry::new(*sample,now,p)?};
            let entry=old.plan(*sample,now,p)?;total=total.checked_add(entry.count()).ok_or("E particle budget overflow")?;
            if total>MAX_TOTAL_QUADS{return Err("E total visible particle budget exceeded");}
            next.rows.insert(id,entry);
        }
        next.clock=Some(now);Ok(next)
    }
    /// After an arithmetic/geometry error the same authorized incarnation cannot
    /// silently restart with a fresh seed next frame. The bounded tombstones die
    /// on absence/context change; the channel supplies a new incarnation on reveal.
    pub(crate) fn reject(&mut self,samples:&[CurrentE],now:f64,context:(u64,u64)){
        self.rows.clear();self.rejected=samples.iter().take(MAX_EPISODES).map(Identity::from).collect();
        self.context=Some(context);self.clock=now.is_finite().then_some(now);
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use openleague_core::Point;
    fn sample()->CurrentE{CurrentE{key:Key{session:(1<<60)+7,owner:17,team:0,ordinal:(1<<60)+9},
        epoch:(1<<61)+3,incarnation:1,position:Point{x:100.,z:300.},y_native:200.,direction:Point{x:1.,z:0.},
        sample_tick:20,sample_frame:30,authorization_frame:31}}
    fn context(s:CurrentE)->(u64,u64){(s.key.session,s.epoch)}
    #[test]
    fn all_three_groups_share_a_transaction_and_failed_late_group_does_not_consume_rng(){
        let mut p=Profiles::load().unwrap();let s=sample();let id=Identity::from(&s);
        let base=State::default().plan(&[s],1.,context(s),&p).unwrap();let words=base.rows[&id].rng.words;
        let expected=base.plan(&[s],1.125,context(s),&p).unwrap();
        let saved=p.simple[1].parameters.rate.clone();p.simple[1].parameters.rate=local::scalar(f32::MAX);
        assert!(base.plan(&[s],1.125,context(s),&p).is_err());assert_eq!(base.rows[&id].rng.words,words);
        p.simple[1].parameters.rate=saved;
        let actual=base.plan(&[s],1.125,context(s),&p).unwrap();
        assert_eq!(actual.rows[&id].rng.words,expected.rows[&id].rng.words);
        let e=&actual.rows[&id];assert!(!e.complex.particles().is_empty());
        assert!(e.simple.iter().all(|state|state.live_indices().count()>0));
        assert_ne!(e.rng.words,local::random(&s).words,"the shared generator advanced across the episode");
    }
    #[test]
    fn lost_authority_destroys_all_groups_and_reveal_starts_at_current_xyz(){
        let p=Profiles::load().unwrap();let s=sample();let a=State::default().plan(&[s],1.,context(s),&p).unwrap();
        let b=a.plan(&[],1.125,context(s),&p).unwrap();assert!(b.rows.is_empty());
        let mut revealed=s;revealed.incarnation+=1;revealed.position.x=900.;revealed.sample_frame+=2;revealed.authorization_frame+=2;
        let c=b.plan(&[revealed],5.,context(s),&p).unwrap();let e=&c.rows[&Identity::from(&revealed)];
        assert_eq!(e.started,5.);assert_eq!(e.pose[12],900f32.to_bits());assert_eq!(e.complex.time(),0.);
        assert!(!c.rows.contains_key(&Identity::from(&s)));
    }
    #[test]
    fn failed_episode_cannot_restart_until_absence_or_a_new_incarnation(){
        let p=Profiles::load().unwrap();let s=sample();let mut a=State::default().plan(&[s],1.,context(s),&p).unwrap();
        assert!(a.plan(&[s],1.5,context(s),&p).is_err());a.reject(&[s],1.5,context(s));
        assert!(a.plan(&[s],1.6,context(s),&p).unwrap().rows.is_empty());
        let mut next=s;next.incarnation+=1;
        assert_eq!(a.plan(&[next],1.6,context(s),&p).unwrap().rows.len(),1);
        let absent=a.plan(&[],1.6,context(s),&p).unwrap();assert!(absent.rejected.is_empty());
    }
    #[test]
    fn permission_only_refresh_does_not_move_reseed_or_emit_at_frozen_time(){
        let p=Profiles::load().unwrap();let s=sample();let id=Identity::from(&s);
        let a=State::default().plan(&[s],1.,context(s),&p).unwrap().plan(&[s],1.125,context(s),&p).unwrap();
        let mut permission=s;permission.authorization_frame+=1;
        let b=a.plan(&[permission],1.125,context(s),&p).unwrap();
        assert_eq!(a.rows[&id].rng.words,b.rows[&id].rng.words);assert_eq!(a.rows[&id].count(),b.rows[&id].count());
        assert_eq!(b.rows[&id].sample.sample_frame,s.sample_frame);
        let mut moved=permission;moved.position.x+=1.;assert!(a.plan(&[moved],1.125,context(s),&p).is_err());
    }
    #[test]
    fn high_epoch_bits_and_sample_uniqueness_are_never_truncated(){
        let p=Profiles::load().unwrap();let s=sample();let a=State::default().plan(&[s],1.,context(s),&p).unwrap();
        let mut next=s;next.epoch^=1<<55;let b=a.plan(&[next],1.,context(next),&p).unwrap();
        assert_eq!(b.rows.len(),1);assert!(!b.rows.contains_key(&Identity::from(&s)));
        assert!(b.rows.contains_key(&Identity::from(&next)));
        assert!(a.plan(&[s,s],1.,context(s),&p).is_err());
        let mut bad=s;bad.authorization_frame=bad.sample_frame-1;assert!(a.plan(&[bad],1.,context(s),&p).is_err());
        assert!(a.plan(&[s],f64::NAN,context(s),&p).is_err());
    }
}
