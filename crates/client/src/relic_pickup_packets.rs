//! Composes actual particle arrays with the already qualified Simple draw caller.
//! System scale, color, scroll and camera remain supplied by their actual owners.
use crate::{relic_pickup_simulation::Host,relic_pickup_simple_draw::{self as draw,Config,Frame,Packet,Profile}};
pub fn packets(profile:Profile,host:&Host,frame:Frame,view:Option<[f32;16]>)->Result<Vec<Packet>,&'static str>{
 let state=host.state.particles.as_ref().ok_or("pickup actual storage missing")?;
 let mut out=Vec::new();out.try_reserve(state.active as usize).map_err(|_|"pickup packet reservation failed")?;
 for i in 0..state.ages.len(){if let Some(packet)=draw::packet(Config::for_profile(profile),draw::particle(state,i)?,frame,view)?{out.push(packet);}}
 Ok(out)
}
