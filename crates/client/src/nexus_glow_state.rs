//! Startup Complex glow only. Native parameter/count/color/UV ports, with an
//! explicit local admission clock/RNG stream and bounded private ownership.
//! On resources are Simple: a phase change retires this group, never restarts it.
use bevy::prelude::*;
use openleague_core::{native_complex_vectors::{ComplexVectors,Field},native_complex_color::ComplexColor,
    native_complex_uv_parameters::UvParameters,native_complex_uv_scroll::Scroll,native_complex_birth,
    native_complex_emission_gate as gate,native_complex_emission_count as count,native_random::Rng55,
    native_complex_particle_age};
use crate::nexus_idle_particles::{CycleId,Frame,Request};
use std::collections::BTreeMap;
pub const EMITTER_CAPACITY:usize=12;
pub const PARTICLE_CAPACITY:usize=4; // life1, rate<=3, strict elapsed>life removal
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Side {Order,Chaos}
impl Side {pub fn index(self)->usize {if self==Self::Order {0}else{1}}}
#[derive(Clone,Debug)]
pub struct Profile {pub side:Side,pub rate:f32,pub duration:f32,pub vectors:ComplexVectors,
    pub birth_color:ComplexColor,pub lifetime_color:ComplexColor,pub uv:UvParameters}
fn numeric_fields(raw:&serde_json::Value)->Result<serde_json::Value,String> {
    let mut fields=raw.as_object().ok_or("Glow profile object missing")?.clone();
    for (key,value) in &mut fields {
        if let Some(text)=value.as_str() {
            if key=="p-texture" {continue;}
            let parts=text.split_whitespace().map(str::parse::<f64>).collect::<Result<Vec<_>,_>>().map_err(|_|"Glow nonnumeric field")?;
            if parts.is_empty() || parts.iter().any(|v|!v.is_finite()) {return Err("Glow empty/nonfinite field".into());}
            *value=if parts.len()==1 {serde_json::json!(parts[0])}else{serde_json::json!(parts)};
        }
    }Ok(serde_json::Value::Object(fields))
}
impl Profile {
    pub fn load(side:Side)->Result<Self,String> {
        let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_glow_profiles.json")).map_err(|e|e.to_string())?;
        let reference=if side==Side::Order {"Order_Nexus_Crystal_Glow.troy"}else{"Chaos_Nexus_Crystal_Glow.troy"};
        let resource=doc["resources"].as_array().ok_or("Glow resources absent")?.iter().find(|v|v["reference"]==reference).ok_or("Glow source absent")?;
        let group=&resource["group"];let fields=numeric_fields(&group["fields"])?;
        if group["class"]!="Complex" || group["name"]!="glow" || fields["p-type"].as_f64()!=Some(0.)
            || fields["rendermode"].as_f64()!=Some(0.) || fields["p-life"].as_f64()!=Some(1.)
            || fields["e-life"].as_f64()!=Some(100.) || fields["p-startframe"].as_f64()!=Some(3.)
            || fields["p-numframes"].as_f64()!=Some(1.) || fields["p-frameRate"].as_f64()!=Some(0.)
            || fields["p-texdiv"]!=serde_json::json!([2.,2.]) || fields["p-bindtoemitter"]!=serde_json::json!([1.,1.])
            || fields["p-texture"]!="glows.tga" {return Err("Glow profile left the admitted native subset".into());}
        let rate=fields["e-rate"].as_f64().ok_or("Glow rate absent")? as f32;
        if rate!=if side==Side::Order {2.5}else{3.} {return Err("Glow rate changed".into());}
        let vectors=ComplexVectors::from_group(&fields).map_err(|e|format!("Glow vectors {e:?}"))?;
        for field in openleague_core::native_complex_vectors::FIELDS {
            let cfg=vectors.field(field);
            if cfg.probabilities.iter().flatten().any(|p|!p.constant||p.constant_value!=1.)
                || (field!=Field::Scale && (cfg.authored||cfg.table!=vec![[0.;3]])) {return Err("Glow requires another vector producer".into());}
        }
        let scale=if side==Side::Order {[100.;3]}else{[50.,50.,0.]};
        if vectors.field(Field::Scale).table.iter().any(|v|*v!=scale) {return Err("Glow scale changed".into());}
        let birth_color=ComplexColor::from_group(&fields).map_err(|e|format!("Glow birth color {e:?}"))?;
        let lifetime_color=ComplexColor::from_lifetime_group(&fields).map_err(|e|format!("Glow lifetime color {e:?}"))?;
        for color in [&birth_color,&lifetime_color] {
            if !color.reader_accepted || color.table.len()!=256 || color.probabilities.iter().flatten().any(|p|!p.constant||p.constant_value!=1.) {
                return Err("Glow color requires another probability producer".into());
            }
        }
        let uv=UvParameters::from_group(&fields).map_err(|e|format!("Glow UV {e:?}"))?;
        if uv.parameters.iter().any(|p|p.authored) {return Err("Glow authored UV outside admitted subset".into());}
        Ok(Self {side,rate,duration:100.,vectors,birth_color,lifetime_color,uv})
    }
    fn birth(&self,time:f32,previous:f32,rng:&mut Rng55)->Result<Birth,String> {
        // Bound zero-offset particles: local center remains zero and the current
        // real attachment is supplied at draw time. No historical pose synthesis.
        let schedule=native_complex_birth::scheduled_birth(time,previous,1,0,[0.;3],[0.;3]).ok_or("Glow birth schedule")?;
        let age=openleague_core::native_complex_age::EmitterAgeInput {config_308:f32::MAX,config_30c:f32::MAX,
            instance_7c:self.duration,time,owner_a8:0.,offset_2ec:0.};
        let (color,age)=self.birth_color.create_birth_color_at_emitter_age(age,rng).map_err(|e|format!("Glow birth RGBA {e:?}"))?;
        let mut vectors=[[0.;3];10];
        // The real934860 order differs from the Field enum order.
        for field in [Field::PostOffset,Field::Scale,Field::QuadRotation,Field::Velocity,Field::Acceleration,
            Field::RotationVelocity,Field::BirthRotationAcceleration,Field::Drag,Field::OrbitVelocity,Field::Offset] {
            let config=self.vectors.field(field);let value=config.sample_age(age.normalized,[1.;3]).map_err(|e|format!("Glow birth vector {e:?}"))?;
            vectors[field as usize]=config.create_multiplier(value,rng);
        }
        let shared_uv=rng.fraction(); // unconditional native draw, even absent UV fields
        let uv=self.uv.sample_birth(age.normalized,shared_uv).map_err(|e|format!("Glow birth UV {e:?}"))?;
        Ok(Birth {time:schedule.time,life:1.,color,scale:vectors[Field::Scale as usize],uv,shared_uv})
    }
}
#[derive(Clone,Debug)]
pub struct Birth {pub time:f32,pub life:f32,pub color:[f32;4],pub scale:[f32;3],pub uv:Scroll,pub shared_uv:f32}
#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord)]
pub struct Key {pub source:u32,pub slot:u8}
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]
pub struct ParticleId {pub session:u64,pub source:u32,pub cycle:u64,pub slot:u8,pub birth:u32}
#[derive(Clone,Debug)]
pub struct Particle {pub id:ParticleId,pub birth:Birth,pub rgba:[f32;4]}
#[derive(Clone,Debug)]
pub struct Slot {pub key:Key,pub cycle:CycleId,pub side:Side,pub particles:Vec<Particle>,pub age:f32,pub clock:f64,
    pub seen:bool,pub emitted:u32,has_emitted:bool,last_emission:f32,previous_frame:f32,
    expiration_time:f32,admitted_last_frame:bool,pub missing_pose_frames:u64}
#[derive(Resource,Clone)]
pub struct State {pub session:Option<u64>,pub ordinal:u64,pub slots:Vec<Slot>,pub rng:Rng55,last_clock:Option<f64>}
pub fn side(request:&Request)->Result<Option<Side>,&'static str> {
    if !(2..=7).contains(&request.descriptor.slot) {return Ok(None);}
    let side=match request.descriptor.resource.as_str() {
        "Order_Nexus_Crystal_Glow.troy"=>Side::Order,"Chaos_Nexus_Crystal_Glow.troy"=>Side::Chaos,
        "Order_Nexus_Crystal_Glow_on.troy"|"Chaos_Nexus_Crystal_Glow_on.troy"=>return Ok(None),
        _=>return Err("Glow slot has unsupported source"),
    };
    let node=[8,3,4,5,6,7][usize::from(request.descriptor.slot-2)];
    if request.cycle.session==0 || request.cycle.serial==0 || request.cycle.source==0
        || request.owner.session!=request.cycle.session || request.owner.effect_id==0 || request.owner.attachment_generation==0
        || request.native_idle_resource_flag!=0x10 || request.descriptor.bone!=format!("gnome{}",request.descriptor.slot-1)
        || request.descriptor.node!=node || !request.age_seconds.is_finite() || request.age_seconds<0.
        || request.age_seconds>f32::MAX as f64 || !request.started_at.is_finite() || !request.attachment_world.is_finite()
    {return Err("Glow request identity, bone or time invalid");}Ok(Some(side))
}
impl State {
    pub fn new(seed:u32)->Self {Self {session:None,ordinal:0,slots:Vec::new(),rng:Rng55::seeded(seed),last_clock:None}}
    pub fn live_count(&self)->usize {self.slots.iter().map(|s|s.particles.len()).sum()}
    pub fn planned(&self,frame:&Frame,now:f64,profiles:&[Profile;2],admitted:bool)->Result<Option<Self>,String> {
        if frame.ordinal==0 || !now.is_finite() {return Err("Glow ordinal/clock unavailable".into());}
        if frame.session==self.session && frame.ordinal<=self.ordinal {return Ok(None);}
        if frame.error.is_some() {return Err("Glow upstream frame unavailable".into());}
        let mut next=self.clone();
        if next.session!=frame.session {next.slots.clear();next.session=frame.session;next.last_clock=None;}
        if next.last_clock.is_some_and(|old|now<old) {return Err("Glow effect clock regressed".into());}
        next.ordinal=frame.ordinal;next.last_clock=Some(now);
        if frame.session.is_none() {next.slots.clear();return Ok(Some(next));}
        let mut cycles=BTreeMap::new();let mut current=BTreeMap::new();
        for r in &frame.requests {
            if frame.session!=Some(r.cycle.session) {return Err("Glow mixed session".into());}
            if cycles.insert(r.cycle.source,r.cycle).is_some_and(|old|old!=r.cycle) {return Err("Glow mixed cycle".into());}
            if let Some(side)=side(r)? {
                let key=Key {source:r.cycle.source,slot:r.descriptor.slot};
                if current.insert(key,(r,side)).is_some() {return Err("Glow duplicate source/slot".into());}
            }
        }
        if cycles.len()>2 {return Err("Glow requires the two Map10 Nexus sources".into());}
        next.slots.retain(|s|cycles.get(&s.key.source).is_none_or(|c|*c==s.cycle));
        let sources:std::collections::BTreeSet<_>=next.slots.iter().map(|s|s.key.source).chain(current.keys().map(|k|k.source)).collect();
        if sources.len()>2 || next.slots.len()+current.keys().filter(|k|!next.slots.iter().any(|s|s.key==**k)).count()>EMITTER_CAPACITY {return Err("Glow emitter capacity exceeded".into());}
        for (key,(r,side)) in &current {if !next.slots.iter().any(|s|s.key==*key) {
            let mut particles=Vec::new();particles.try_reserve_exact(PARTICLE_CAPACITY).map_err(|_|"Glow particle reservation failed")?;
            next.slots.push(Slot {key:*key,cycle:r.cycle,side:*side,particles,age:r.age_seconds as f32,clock:now,seen:false,emitted:0,
                has_emitted:false,last_emission:r.age_seconds as f32,previous_frame:f32::MIN,expiration_time:f32::MIN,
                admitted_last_frame:false,missing_pose_frames:0});
        }}
        next.slots.sort_by_key(|s|s.key); // explicit local shared-stream order
        for slot in &mut next.slots {
            let projected=f64::from(slot.age)+(now-slot.clock);
            let observed=current.get(&slot.key).map(|(r,_)|r.age_seconds).unwrap_or(0.);
            let age=projected.max(observed);if !age.is_finite() || age>f32::MAX as f64 {return Err("Glow age overflow".into());}
            slot.age=age as f32;slot.clock=now;
            native_complex_particle_age::remove_expired(slot.age,slot.expiration_time,&mut slot.particles,|p|(p.birth.time,p.birth.life),|_,_|{});
            slot.expiration_time=slot.age;
            let Some((r,side))=current.get(&slot.key) else {slot.seen=false;slot.admitted_last_frame=false;
                slot.missing_pose_frames=slot.missing_pose_frames.saturating_add(1);continue;};
            if *side!=slot.side || r.cycle!=slot.cycle {return Err("Glow profile changed within cycle".into());}
            slot.seen=true;
            if !admitted {slot.admitted_last_frame=false;continue;}
            if !slot.admitted_last_frame { // local admission: never replay births from missing pose/resources
                slot.last_emission=slot.age;
                if slot.has_emitted {slot.previous_frame=slot.age;}
            }
            slot.admitted_last_frame=true;
            let profile=&profiles[slot.side.index()];
            let mut gate_state=gate::State {field118:slot.emitted,field108:f32::MIN};
            let decision=gate::evaluate(gate::Inputs {time:slot.age,elapsed:slot.age,period:f32::MAX,active:f32::MAX,
                offset:0.,duration:profile.duration,flag334:0,flag74:u8::from(slot.has_emitted),flag11c:0,past_end:false},&mut gate_state,
                |_|count::evaluate(count::Inputs {time:slot.age,elapsed:slot.age,period:f32::MAX,owner_start:0.,last_emission:slot.last_emission,
                    rate:profile.rate,owner_scale:1.,limit:0,emitted:slot.emitted as i32,flag74:u8::from(slot.has_emitted),flag334:0}))
                .map_err(|e|format!("Glow gate {e:?}"))?;
            if let gate::Decision::Count {value,birth_requested:true}=decision {
                if value!=1 || slot.particles.len()>=PARTICLE_CAPACITY {return Err("Glow native rate/capacity escaped subset".into());}
                slot.particles.try_reserve(1).map_err(|_|"Glow birth reservation failed")?;
                let birth=profile.birth(slot.age,slot.previous_frame,&mut next.rng)?;
                slot.emitted=slot.emitted.checked_add(1).ok_or("Glow identity overflow")?;
                if slot.emitted>=i32::MAX as u32 {return Err("Glow count overflow".into());}
                slot.last_emission=slot.age;slot.has_emitted=true;
                slot.particles.push(Particle {id:ParticleId {session:slot.cycle.session,source:slot.key.source,
                    cycle:slot.cycle.serial,slot:slot.key.slot,birth:slot.emitted},rgba:birth.color,birth});
            }
            slot.previous_frame=slot.age;
            for particle in &mut slot.particles {
                particle.rgba=profile.lifetime_color.update_lifetime_color(particle.birth.color,slot.age,particle.birth.time,particle.birth.life,&mut next.rng)
                    .map_err(|e|format!("Glow lifetime color {e:?}"))?.0;
            }
        }
        Ok(Some(next))
    }
}
#[cfg(test)]
#[path="nexus_glow_state_tests.rs"]
pub(crate) mod tests;
