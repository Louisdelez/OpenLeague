//! Selected original Simple pickup draw configuration and92F7D0 packet binding.
//! Particle and emitter/system/color/scroll producers remain explicit inputs.
use openleague_core::native_simple_type0_quad as native;
#[derive(Clone,Copy,Debug)]pub enum Profile {HealStarTrail,HealMesh,ManaStarSwirl,ManaShafts}
#[derive(Clone,Copy,Debug)]pub struct Config {pub particle_type:u32,pub orientation:u32,pub start_frame:u32,pub frame_count:u32,pub atlas:[u16;2],pub bias:[f32;2]}
impl Config {
 pub fn for_profile(profile:Profile)->Self {
  let (particle_type,orientation,start_frame,bias)=match profile {
   Profile::HealStarTrail=>(0,0,0,[1.,1.]),Profile::HealMesh=>(1,2,1,[1.,1.]),
   Profile::ManaStarSwirl=>(0,0,0,[1.,1.]),Profile::ManaShafts=>(1,3,3,[1.,3.]),
  };
  Self {particle_type,orientation,start_frame,frame_count:4,atlas:[2,2],bias}
 }
}
#[derive(Clone,Copy)]pub struct Particle {pub position:[f32;3],pub scale:f32,pub rotation:f32,pub age:f32,pub lookup:[f32;2]}
#[derive(Clone,Copy)]pub struct Frame {pub instance_e0:f32,pub system_bc:f32,pub system_c0:f32,pub rgba:[f32;4],pub scroll:[f32;2]}
pub struct Packet {pub native:native::Quad,pub indices:[u16;6],pub atlas:[u16;2]}
/// Native live gate is1>age. A retired or unordered particle produces no packet.
pub fn packet(config:Config,particle:Particle,frame:Frame,view:Option<[f32;16]>)->Result<Option<Packet>,&'static str> {
 if !(1.>particle.age){return Ok(None);}
 if config.particle_type>1 || config.frame_count!=4 || config.atlas!=[2,2] || config.start_frame>=4 {return Err("pickup draw configuration outside qualified profiles");}
 if particle.position.into_iter().chain([particle.scale,frame.instance_e0,frame.system_bc,frame.system_c0]).chain(particle.lookup).chain(config.bias).chain(frame.rgba).chain(frame.scroll).any(|v|!v.is_finite()){return Err("nonfinite pickup draw input");}
 let base=crate::simple_selected_axes::selected(config.orientation,particle.rotation,view)?;
 //92F8B4:system+C0 times system+BC; then92FACD/92FAE5, preserving f32 order.
 let scale=(particle.scale*frame.instance_e0)*(frame.system_c0*frame.system_bc);
 let a=config.bias[1]*scale;let b=scale*config.bias[0];
 let axis_a=std::array::from_fn(|i|f32::from_bits(base[i])*a);
 let axis_b=std::array::from_fn(|i|f32::from_bits(base[i+3])*b);
 let quad=native::pack(native::Input {center:particle.position,axis_a,axis_b,rgba:frame.rgba,
  channel0_origin:frame.scroll,channel0_z:config.start_frame as f32,channel1_origin:particle.lookup}).map_err(|_|"pickup native packet rejected")?;
 Ok(Some(Packet {native:quad,indices:[0,1,2,0,2,3],atlas:config.atlas}))
}
/// Reads the exact arrays consumed by the original caller, without resampling.
pub fn particle(state:&openleague_core::native_simple_particle_update::State,index:usize)->Result<Particle,&'static str>{
 let age=*state.ages.get(index).ok_or("pickup age index missing")?;
 Ok(Particle {age:f32::from_bits(age),position:state.positions.get(index).ok_or("pickup position index missing")?.map(f32::from_bits),
  scale:f32::from_bits(*state.scales.get(index).ok_or("pickup scale index missing")?),
  rotation:f32::from_bits(*state.scalar.get(index).ok_or("pickup rotation index missing")?),
  lookup:[f32::from_bits(*state.attribute_a.get(index).ok_or("pickup lookupA index missing")?),f32::from_bits(*state.attribute_b.get(index).ok_or("pickup lookupB index missing")?)]})
}

#[cfg(test)]
#[path="relic_pickup_simple_draw_tests.rs"]
mod tests;
