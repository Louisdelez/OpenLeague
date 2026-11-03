//! Application-local reconstructed Map10 mist state. All two-source frames and
//! their one RNG stream are planned together; publication precedes commit.
//! Original all-effects global RNG order and static factory trigger are unknown.
use bevy::{asset::AssetId,prelude::*};
use openleague_core::native_random::Rng55;
use crate::{spawn_mist_host::{EffectState,HostSource},spawn_mist_world::ReconstructedHeader,
 relic_pickup_seven_host::Owner};

#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]
pub struct Binding{pub session:u64,pub map_root:Entity,pub model:AssetId<Gltf>,pub roots:[Entity;2],pub positions:[[u32;3];2]}
impl Binding{
 pub fn owner(self,index:usize)->Owner{
  let position=self.positions[index];let mut matrix=Mat4::IDENTITY.to_cols_array().map(f32::to_bits);
  matrix[12..15].copy_from_slice(&position);
  // Model token is an owned slot within this exact binding, not a native pointer.
  Owner{root_token:self.roots[index].to_bits(),model_token:index as u64+1,matrix,position}
 }
}
#[derive(Clone)]pub struct Active{pub binding:Binding,pub effects:[EffectState;2],pub headers:[ReconstructedHeader;2]}
#[derive(Resource,Clone)]pub struct State{pub active:Option<Active>,pub rng:Rng55,pub ordinal:u64,pub last_clock:Option<f64>}
pub struct Plan{pub next:State,base_ordinal:u64,base_rng:(u32,u32,[u32;55]),pub binding:Option<Binding>}
pub fn fingerprint(rng:&Rng55)->(u32,u32,[u32;55]){(rng.first,rng.second,rng.words)}
impl State{
 pub fn new(rng:Rng55)->Self{Self{active:None,rng,ordinal:0,last_clock:None}}
 /// Withdrawing an owner requires no usable clock or GPU resource. Preserve
 /// the RNG and last good clock while retiring the entire two-source state.
 pub fn retired(&self)->Result<Plan,String>{let mut next=self.clone();next.active=None;next.ordinal=next.ordinal.checked_add(1).ok_or("mist retire ordinal overflow")?;
  Ok(Plan{next,base_ordinal:self.ordinal,base_rng:fingerprint(&self.rng),binding:None})}
 pub fn planned(&self,binding:Option<Binding>,now:f64,sources:&[HostSource;2])->Result<Plan,String>{
  if !now.is_finite()||now<0.||now>f32::MAX as f64||self.last_clock.is_some_and(|last|now<last){return Err("mist canonical clock invalid".into());}
  if binding.is_some_and(|b|b.positions.iter().flatten().any(|v|!f32::from_bits(*v).is_finite())){return Err("mist placement nonfinite".into());}
  let mut next=self.clone();next.ordinal=next.ordinal.checked_add(1).ok_or("mist frame ordinal overflow")?;
  next.last_clock=Some(now);
  match binding{
   None=>next.active=None,
   Some(binding)=>{
    if next.active.as_ref().is_none_or(|a|a.binding!=binding){
     // Catalog order is Chaos line88, then Order line89. Create and advance both
     // against one staged stream; neither change leaks from a failed plan.
     let chaos=EffectState::new(&sources[0],binding.owner(0),now as f32,&mut next.rng)?;
     let order=EffectState::new(&sources[1],binding.owner(1),now as f32,&mut next.rng)?;
     next.active=Some(Active{binding,effects:[chaos,order],headers:[ReconstructedHeader::neutral_fogcircle_v2();2]});
    }
    let active=next.active.as_mut().unwrap();
    for i in 0..2{if let Some(frame)=active.effects[i].planned_frame(&sources[i],next.ordinal,now as f32,binding.owner(i),&next.rng)?{
      active.effects[i]=frame.state;next.rng=frame.rng;
    }}
   }
  }
  Ok(Plan{next,base_ordinal:self.ordinal,base_rng:fingerprint(&self.rng),binding})
 }
 pub fn validate(&self,plan:&Plan,binding:Option<Binding>)->Result<(),String>{
  if self.ordinal!=plan.base_ordinal||fingerprint(&self.rng)!=plan.base_rng||binding!=plan.binding{return Err("mist owner/RNG plan became stale".into());}Ok(())
 }
 pub fn commit(&mut self,plan:Plan,binding:Option<Binding>)->Result<(),String>{self.validate(&plan,binding)?;*self=plan.next;Ok(())}
}
