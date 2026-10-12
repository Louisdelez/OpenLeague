//! Selected On Simple glow. Uses the qualified Simple emission/insertion/update
//! bodies. Admission, stream ordering and missing-pose policy are local adapters.
use bevy::prelude::*;
use openleague_core::{native_random::Rng55,native_simple_emission_count as count,
    native_simple_emission_lifecycle as emission,native_simple_particle_update as particles,
    native_simple_birth_parameters as birth,native_scalar_parameter::ScalarParameter};
use crate::{nexus_glow_state::{Key,ParticleId,Side},nexus_idle_particles::{CycleId,Frame,Request}};
use std::collections::BTreeMap;
pub const EMITTER_CAPACITY:usize=12;
// rate<=4, life1, native per-update cap2. Includes the stale-age slots awaiting
// the emission-before-update order. Any escape fails transactionally, never grows.
pub const SLOT_CAPACITY:usize=8;
pub const DRAW_CAPACITY:usize=EMITTER_CAPACITY*SLOT_CAPACITY;
#[derive(Clone,Debug)]
pub struct Profile {pub side:Side,pub rate:ScalarParameter,pub scale:ScalarParameter,
    pub life:ScalarParameter,pub color_v:f32,pub authored_duration:Option<f32>}
fn numeric(v:&serde_json::Value)->Option<Vec<f32>> {
    if let Some(s)=v.as_str(){return s.split_whitespace().map(str::parse).collect::<Result<Vec<f32>,_>>().ok();}
    if let Some(n)=v.as_f64(){return Some(vec![n as f32]);}
    v.as_array()?.iter().map(|v|v.as_f64().map(|n|n as f32)).collect()
}
impl Profile {
    pub fn load(side:Side)->Result<Self,String> {
        let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_glow_profiles.json")).map_err(|e|e.to_string())?;
        let reference=if side==Side::Order{"Order_Nexus_Crystal_Glow_on.troy"}else{"Chaos_Nexus_Crystal_Glow_on.troy"};
        let row=doc["resources"].as_array().ok_or("Simple glow resources absent")?.iter().find(|r|r["reference"]==reference).ok_or("Simple glow source absent")?;
        let group=&row["group"];let fields=group["fields"].as_object().ok_or("Simple glow fields absent")?;
        let get=|key:&str|fields.get(key).and_then(numeric);
        let expected_rate=if side==Side::Order{4.}else{3.};let expected_scale=if side==Side::Order{100.}else{50.};
        let color_v=if side==Side::Order{1.}else{0.2};
        let color=if side==Side::Order{"color-nexus-gem-glow.tga"}else{"color-turretcrystal.tga"};
        let duration=get("e-life").and_then(|v|v.first().copied());
        let allowed=["e-life","e-rate","p-startframe","p-life","p-numframes","p-texdiv","p-colorscale",
            "p-bindtoemitter","p-colortype","p-frameRate","p-rgba","rendermode","p-type","p-scale","p-texture"];
        if group["class"]!="Simple" || group["name"]!="glow" || fields.keys().any(|k|!allowed.contains(&k.as_str()))
            || get("e-rate")!=Some(vec![expected_rate]) || get("p-scale")!=Some(vec![expected_scale])
            || get("p-life")!=Some(vec![1.]) || get("p-type")!=Some(vec![0.]) || get("rendermode")!=Some(vec![0.])
            || get("p-startframe")!=Some(vec![3.]) || get("p-numframes")!=Some(vec![1.]) || get("p-frameRate")!=Some(vec![0.])
            || get("p-texdiv")!=Some(vec![2.,2.]) || get("p-colortype")!=Some(vec![1.,0.])
            || get("p-colorscale")!=Some(vec![1.,color_v]) || get("p-bindtoemitter")!=Some(vec![1.,1.])
            || fields.get("p-rgba").and_then(|v|v.as_str())!=Some(color)
            || fields.get("p-texture").and_then(|v|v.as_str())!=Some("glows.tga")
            || duration!=if side==Side::Order{Some(-1.)}else{None}
        {return Err("Simple glow source escaped selected native profile".into());}
        let read=|key:&str,default:f32|ScalarParameter::read_numeric(key,default,|k|get(k))
            .map_err(|e|format!("Simple glow scalar {e:?}"))?.ok_or_else(||format!("Simple glow missing {key}"));
        Ok(Self{side,rate:read("e-rate",1.)?,scale:read("p-scale",1.)?,life:read("p-life",1.)?,color_v,authored_duration:duration})
    }
}
pub fn side(r:&Request)->Result<Option<Side>,&'static str> {
    if !(2..=7).contains(&r.descriptor.slot){return Ok(None);}
    let result=match r.descriptor.resource.as_str(){
        "Order_Nexus_Crystal_Glow_on.troy"=>Side::Order,"Chaos_Nexus_Crystal_Glow_on.troy"=>Side::Chaos,
        "Order_Nexus_Crystal_Glow.troy"|"Chaos_Nexus_Crystal_Glow.troy"=>return Ok(None),
        _=>return Err("Simple glow resource outside selected profiles"),
    };
    if r.cycle.session==0 || r.cycle.source==0 || r.cycle.serial==0 || r.owner.session!=r.cycle.session
        || r.owner.effect_id==0 || r.owner.attachment_generation==0 || r.native_idle_resource_flag!=0x10
        || r.descriptor.node!=[8,3,4,5,6,7][usize::from(r.descriptor.slot-2)]
        || r.descriptor.bone!=format!("gnome{}",r.descriptor.slot-1) || !r.attachment_world.is_finite()
        || !r.started_at.is_finite() || !r.age_seconds.is_finite() || !(0. ..=f32::MAX as f64).contains(&r.age_seconds)
    {return Err("Simple glow identity/bone/time invalid");}Ok(Some(result))
}
fn identity()->[u32;16]{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0})}
fn empty_particles()->particles::State {
    particles::State{last_time:f32::MIN.to_bits(),life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],
        scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],
        previous_heights:vec![],bounds:openleague_core::native_simple_bounds_policy::State{
            bounds:openleague_core::native_simple_particle_bounds::Bounds{minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0}
}
#[derive(Clone)]
pub struct Slot {pub key:Key,pub cycle:CycleId,pub side:Side,pub age:f32,pub clock:f64,pub seen:bool,
    pub storage:particles::State,pub birth:Vec<u32>,pub identities:Vec<u32>,pub emitted:u32,
    pub missing_pose_frames:u64,owner:emission::State,previous_position:[u32;3],admitted:bool}
impl Slot {
    pub fn live_indices(&self)->impl Iterator<Item=usize>+'_ {self.storage.ages.iter().enumerate().filter(|(_,a)|f32::from_bits(**a)<1.).map(|(i,_)|i)}
    pub fn id(&self,index:usize)->ParticleId {ParticleId{session:self.cycle.session,source:self.key.source,cycle:self.cycle.serial,slot:self.key.slot,birth:self.identities[index]}}
    fn step(&mut self,profile:&Profile,matrix:[u32;16],position:[u32;3],allow_birth:bool,rng:&mut Rng55)->Result<(),String> {
        if !allow_birth {self.admitted=false;}else if !self.admitted {self.owner.previous=self.age.to_bits();self.admitted=true;}
        if allow_birth {
            let rate=birth::sample_rate(&profile.rate.table,Some(&profile.rate.probability),0.,1.,rng).map_err(str::to_owned)?;
            let timing=count::Input{time:self.age,start:0.,previous:0.,life:f32::MAX,delay:0.,period:f32::MAX,window:f32::MAX,rate,single:0,emitted:0};
            // Only constant parameters, no attribute/force/rotation-list producer.
            let values=birth::sample_base(&profile.life.table,&[0.],&profile.scale.table,&[0.],0.).map_err(str::to_owned)?;
            let source=birth::BaseBirth{values,position:[0;3],velocity:[0;3],offset:[0;3]};
            let curves=birth::BirthCurves{life:Some(&profile.life.probability),factor:Some(&profile.scale.probability),
                scalar:None,rotation:None,position:[None;3],velocity:[None;3],offset:[None;3]};
            let prepared=emission::Prepared{life:values.life,scalar:values.scalar,rate:values.rotation,factor:values.factor,
                // e-local-orient defaults to1. Use the actual owner transfer even
                // though this profile's authored/default offset and velocity are0.
                offset:[0;3],position_offset:[0;3],velocity:[0;3],matrix,previous_position:self.previous_position,
                current_position:position,bounds_factor:1f32.to_bits(),scale:particles::Table{values:&[1.],probability:None},terrain:0};
            let old_birth=self.birth.clone();let old_ages=self.storage.ages.clone();
            let count=emission::update_with_source(&mut self.owner,timing,&prepared,&mut self.storage,&mut self.birth,rng,
                &mut |_|Err("Simple glow terrain is not selected"),&mut |_,rng|Ok(source.birth(&curves,rng))).map_err(str::to_owned)?;
            if !(0..=2).contains(&count) || self.birth.len()>SLOT_CAPACITY {return Err("Simple glow emission exceeded bounded profile".into());}
            self.identities.resize(self.birth.len(),0);let mut assigned=0;
            for i in 0..self.birth.len(){if i>=old_birth.len() || self.birth[i]!=old_birth[i] || f32::from_bits(old_ages[i])>=1. && self.storage.ages[i]==0 {
                self.emitted=self.emitted.checked_add(1).ok_or("Simple glow identity exhausted")?;
                self.identities[i]=self.emitted;assigned+=1;
            }}
            if assigned!=count {return Err("Simple glow insertion identity mismatch".into());}
        }
        let attrs=[particles::Attribute{mode:1,multiplier:1f32.to_bits(),offset:0},
            particles::Attribute{mode:0,multiplier:profile.color_v.to_bits(),offset:0}];
        particles::update(&particles::Input{time:self.age.to_bits(),cap:f32::MAX.to_bits(),birth:&self.birth,bounds_flag:0,
            previous_position:self.previous_position,current_position:position,initial_inverse:identity(),current_matrix:identity(),
            bind_begin:1f32.to_bits(),bind_end:1f32.to_bits(),sticky:0,local:0,circular:0,direction:0,force_resource:0,force_graph:None,
            scalar_enabled:0,scalar_table:particles::Table{values:&[0.],probability:None},
            scale_table:particles::Table{values:&[1.],probability:None},attributes:attrs,bounds_factor:1f32.to_bits(),terrain_enabled:0},
            &mut self.storage,rng,&mut |_|Err("Simple glow terrain is not selected"),&mut |_|{}).map_err(str::to_owned)?;
        self.previous_position=position;Ok(())
    }
}
#[derive(Resource,Clone,Default)]
pub struct State {pub session:Option<u64>,pub ordinal:u64,pub slots:Vec<Slot>,last_clock:Option<f64>}
impl State {
    pub fn live_count(&self)->usize{self.slots.iter().map(|s|s.live_indices().count()).sum()}
    /// Stream cloned from the preceding Startup plan. Both plans are published
    /// together, so a later image/camera/mesh error consumes neither births nor RNG.
    pub fn planned(&self,frame:&Frame,now:f64,profiles:&[Profile;2],admitted:bool,rng:&Rng55)->Result<Option<(Self,Rng55)>,String>{
        if frame.ordinal==0 || !now.is_finite(){return Err("Simple glow ordinal/clock unavailable".into());}
        if self.session==frame.session && frame.ordinal<=self.ordinal{return Ok(None);}
        if frame.error.is_some(){return Err("Simple glow upstream frame unavailable".into());}
        let mut next=self.clone();let mut random=rng.clone();
        if next.session!=frame.session {next.slots.clear();next.session=frame.session;next.last_clock=None;}
        if next.last_clock.is_some_and(|old|now<old){return Err("Simple glow clock regressed".into());}
        next.last_clock=Some(now);next.ordinal=frame.ordinal;
        if frame.session.is_none(){next.slots.clear();return Ok(Some((next,random)));}
        let mut cycles=BTreeMap::new();let mut current=BTreeMap::new();
        for r in &frame.requests {
            if frame.session!=Some(r.cycle.session){return Err("Simple glow mixed session".into());}
            if cycles.insert(r.cycle.source,r.cycle).is_some_and(|old|old!=r.cycle){return Err("Simple glow mixed cycles".into());}
            if let Some(side)=side(r).map_err(str::to_owned)? {
                let key=Key{source:r.cycle.source,slot:r.descriptor.slot};
                if current.insert(key,(r,side)).is_some(){return Err("Simple glow duplicate slot".into());}
            }
        }
        next.slots.retain(|s|cycles.get(&s.key.source).is_none_or(|c|*c==s.cycle));
        let sources:std::collections::BTreeSet<_>=next.slots.iter().map(|s|s.key.source).chain(current.keys().map(|k|k.source)).collect();
        if sources.len()>2 || next.slots.len()+current.keys().filter(|k|!next.slots.iter().any(|s|s.key==**k)).count()>EMITTER_CAPACITY {
            return Err("Simple glow source/slot capacity exceeded".into());
        }
        for (key,(r,side)) in &current {if !next.slots.iter().any(|s|s.key==*key) {
            let (_,position)=crate::nexus_complex_live::owner_pose(r)?;
            next.slots.push(Slot{key:*key,cycle:r.cycle,side:*side,age:r.age_seconds as f32,clock:now,seen:false,
                storage:empty_particles(),birth:vec![],identities:vec![],emitted:0,missing_pose_frames:0,
                owner:emission::State{previous:(r.age_seconds as f32).to_bits(),emitted:0,counter:0,bounds_factor:1f32.to_bits()},
                previous_position:position.to_array().map(f32::to_bits),admitted:false});
        }}
        next.slots.sort_by_key(|s|s.key);
        for slot in &mut next.slots {
            let observed=current.get(&slot.key).map(|(r,_)|r.age_seconds).unwrap_or(0.);
            let age=(f64::from(slot.age)+(now-slot.clock)).max(observed);
            if !age.is_finite() || age>f32::MAX as f64 {return Err("Simple glow age overflow".into());}
            slot.age=age as f32;slot.clock=now;
            let (matrix,position)=if let Some((r,side))=current.get(&slot.key) {
                if *side!=slot.side || r.cycle!=slot.cycle {return Err("Simple glow profile changed within cycle".into());}
                slot.seen=true;let (matrix,position)=crate::nexus_complex_live::owner_pose(r)?;
                (matrix.to_cols_array().map(f32::to_bits),position.to_array().map(f32::to_bits))
            }else{slot.seen=false;slot.missing_pose_frames=slot.missing_pose_frames.saturating_add(1);(identity(),slot.previous_position)};
            slot.step(&profiles[slot.side.index()],matrix,position,admitted&&slot.seen,&mut random)?;
        }
        Ok(Some((next,random)))
    }
}
#[cfg(test)]
#[path="nexus_glow_simple_tests.rs"]
pub(crate) mod tests;
