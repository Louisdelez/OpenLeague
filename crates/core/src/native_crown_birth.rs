//! Stationary Crown Startup/On birth sequencer, composed from qualified core ports.
//! No renderer, lifecycle expiry, shared RNG initialization or ordinary loader claim.
//! The narrow fixture domain is explicit: owner scale1, no velocity/shape/attribute
//! provider, no death/trail emitters, no end override; exact four Crown profiles only.
use crate::{native_random::Rng55, native_complex_vectors::{ComplexVectors,Field},
    native_complex_color::ComplexColor, native_complex_uv_parameters::UvParameters,
    native_complex_birth, native_complex_emission_count as count,
    native_complex_emission_gate as gate};

pub type Error = &'static str;
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Side { Order, Chaos }
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Phase { On, Startup }
#[derive(Debug, Clone)]
pub struct Profile { vectors:ComplexVectors, color:ComplexColor, uv:UvParameters,
    side:Side,phase:Phase,duration:f32,rate:f32,life:f32,max_births:usize }
impl Profile {
    /// The two exact decoded crown On documents. Strings were lexically parsed
    /// by the scratch exporter; raw fields and resource SHA remain beside them.
    pub fn load(side:Side)->Result<Self,Error> {
        let document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/nexus_crown/crown_on_profiles.json"))
            .map_err(|_|"invalid pinned Crown profile document")?;
        let reference=match side {Side::Order=>"Order_Nexus_Base_Glow_on.troy",Side::Chaos=>"Chaos_Nexus_Base_Glow_on.troy"};
        let group=document["profiles"].as_array().ok_or("missing Crown profiles")?.iter()
            .find(|p|p["reference"].as_str()==Some(reference)).ok_or("missing Crown source")?["fields"].clone();
        let vectors=ComplexVectors::from_group(&group).map_err(|_|"unsupported Crown vectors")?;
        let color=ComplexColor::from_group(&group).map_err(|_|"unsupported Crown color")?;
        let uv=UvParameters::from_group(&group).map_err(|_|"unsupported Crown UV")?;
        // This sequencer is not a general emitter. Reject extension of its domain.
        if group["e-life"]!=-1 || group["p-life"]!=2 || group["e-rate"]!=2 || group["p-type"]!=3
            || color.table.len()!=1 || color.probabilities.iter().flatten().any(|p|!p.constant || p.constant_value!=1.)
            || uv.parameters.iter().any(|p|p.authored) { return Err("Crown profile left the qualified On domain"); }
        Ok(Self {vectors,color,uv,side,phase:Phase::On,duration:f32::MAX,rate:2.,life:2.,max_births:1})
    }
    /// Source-authored finite Startup profiles; this is not an Idle phase clock.
    pub fn load_startup(side:Side)->Result<Self,Error> {
        let document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/nexus_crown/crown_startup_profiles.json"))
            .map_err(|_|"invalid pinned Crown Startup document")?;
        let reference=match side {Side::Order=>"Order_Nexus_Base_Glow.troy",Side::Chaos=>"Chaos_Nexus_Base_Glow.troy"};
        let group=&document["profiles"].as_array().ok_or("missing Crown Startup profiles")?.iter()
            .find(|p|p["reference"].as_str()==Some(reference)).ok_or("missing Crown Startup source")?["fields"];
        let (rate,life,max_births)=match side {Side::Order=>(4.,1.,2),Side::Chaos=>(2.,2.,1)};
        let vectors=ComplexVectors::from_group(group).map_err(|_|"unsupported Startup vectors")?;
        let color=ComplexColor::from_group(group).map_err(|_|"unsupported Startup birth color")?;
        let uv=UvParameters::from_group(group).map_err(|_|"unsupported Startup UV")?;
        if group["e-life"].as_f64()!=Some(90.) || group["p-life"]!=life || group["e-rate"]!=rate || group["p-type"]!=3
            || !color.reader_accepted || color.table.len()!=256
            || color.probabilities.iter().flatten().any(|p|!p.constant || p.constant_value!=1.)
            || uv.parameters.iter().any(|p|p.authored) {return Err("Crown Startup left its bounded source domain");}
        Ok(Self {vectors,color,uv,side,phase:Phase::Startup,duration:90.,rate,life,max_births})
    }
    pub fn side(&self)->Side {self.side}
    pub fn phase(&self)->Phase {self.phase}
    /// Inclusive lifetime boundary plus one straddling emission batch. The
    /// host rejects overflow before commit, even for unsupported frame histories.
    pub fn particle_capacity(&self)->usize {(self.rate*self.life) as usize+self.max_births}
    /// Original934860 caller order. FIELDS enum order is DIFFERENT: Scale is
    /// sampled before QuadRotation. The shared UV draw is unconditional here.
    pub fn birth(&self,time:f32,previous:f32,count:i32,index:u32,position:[f32;3],rng:&mut Rng55)->Result<Birth,Error> {
        if !time.is_finite() || time<0. || !previous.is_finite() || !position.iter().all(|v|v.is_finite()) {
            return Err("nonfinite or negative Crown birth input");
        }
        let schedule=native_complex_birth::scheduled_birth(time,previous,count,index,position,position)
            .ok_or("invalid Crown batch index")?;
        let age=crate::native_complex_age::EmitterAgeInput {config_308:f32::MAX,config_30c:f32::MAX,
            instance_7c:self.duration,time,owner_a8:0.,offset_2ec:0.};
        let mut next=rng.clone();
        let (color,age)=self.color.create_birth_color_at_emitter_age(age,&mut next).map_err(|_|"Crown color sample failed")?;
        let mut vectors=[[0.;3];10];
        for field in [Field::PostOffset,Field::Scale,Field::QuadRotation,Field::Velocity,Field::Acceleration,
            Field::RotationVelocity,Field::BirthRotationAcceleration,Field::Drag,Field::OrbitVelocity,Field::Offset] {
            let config=self.vectors.field(field);
            let value=config.sample_age(age.normalized,[1.;3]).map_err(|_|"Crown vector sample failed")?;
            vectors[field as usize]=config.create_multiplier(value,&mut next);
        }
        let shared_uv=next.fraction(); //9360D8..9361FA; required even when all UV parameters are absent.
        let uv=self.uv.sample_birth(age.normalized,shared_uv).map_err(|_|"Crown UV sample failed")?;
        *rng=next;
        Ok(Birth {schedule,color,vectors,life:self.life,shared_uv,uv})
    }
}
#[derive(Debug, Clone)]
pub struct Birth {
    pub schedule:native_complex_birth::Birth,
    pub color:[f32;4], pub vectors:[[f32;3];10], pub life:f32, pub shared_uv:f32,
    pub uv:crate::native_complex_uv_scroll::Scroll,
}
impl Birth {pub fn vector(&self,field:Field)->[f32;3] {self.vectors[field as usize]}}

#[derive(Debug, Clone, PartialEq)]
pub struct Emitter {
    /// Raw meanings follow instance+74/+78/+80/+108/+118, not live-count guesses.
    pub has_emitted:bool, pub last_emission:f32, pub previous_frame:f32,
    pub distance_anchor:f32, pub emitted:u32,
}
impl Default for Emitter {
    fn default()->Self {Self {has_emitted:false,last_emission:0.,previous_frame:f32::MIN,distance_anchor:f32::MIN,emitted:0}}
}
#[derive(Debug, Clone)]
pub struct Plan { before:Emitter, after:Emitter, rng_before:Rng55, rng_after:Rng55, births:Vec<Birth> }
fn same_rng(a:&Rng55,b:&Rng55)->bool {a.first==b.first && a.second==b.second && a.words==b.words}
impl Plan { pub fn births(&self)->&[Birth] {&self.births} }
impl Emitter {
    /// Local transaction wrapper: caller reserves owned storage before commit.
    /// Uses elapsed effect time and an explicit unchanged native attachment
    /// position. Passing wall-clock time or reseeding on fog/rebind is forbidden.
    pub fn prepare(&self,profile:&Profile,time:f32,position:[f32;3],rng:&Rng55)->Result<Plan,Error> {
        if !time.is_finite() || time<0. || time<self.previous_frame || self.emitted>=i32::MAX as u32
            || !position.iter().all(|v|v.is_finite()) {return Err("unsupported Crown frame domain");}
        let mut after=self.clone();let mut next=rng.clone();let mut births=Vec::new();
        let mut raw=gate::State {field118:self.emitted,field108:self.distance_anchor};
        let decision=gate::evaluate(gate::Inputs {time,elapsed:time,period:f32::MAX,active:f32::MAX,
            offset:0.,duration:profile.duration,flag334:0,flag74:u8::from(self.has_emitted),flag11c:0,past_end:false},&mut raw,
            |_|count::evaluate(count::Inputs {time,elapsed:time,period:f32::MAX,owner_start:0.,last_emission:self.last_emission,
                rate:profile.rate,owner_scale:1.,limit:0,emitted:self.emitted as i32,flag74:u8::from(self.has_emitted),flag334:0}))
            .map_err(|_|"unsupported Crown emission gate")?;
        after.emitted=raw.field118;after.distance_anchor=raw.field108;
        if let gate::Decision::Count {value,birth_requested:true}=decision {
            // Original count cap is1 at rate2,2 at rate4. Preserve the complete
            // ordered batch and its shared RNG stream; do not reuse its final ID.
            let count=usize::try_from(value).map_err(|_|"Crown negative birth count")?;
            if count>profile.max_births {return Err("Crown count escaped authored rate domain");}
            if self.emitted.checked_add(count as u32).is_none_or(|n|n>i32::MAX as u32) {return Err("Crown counter exhausted");}
            births.try_reserve(count).map_err(|_|"Crown storage reservation failed")?;
            after.last_emission=time; //9351C8 precedes append loop.
            for index in 0..count {
                births.push(profile.birth(time,self.previous_frame,value,index as u32,position,&mut next)?);
                //9367E5/93680E initialize the negative emitter distance sentinel on birth.
                //936994 adds zero in this unchanged-position sequencer domain.
                if after.distance_anchor < 0. { after.distance_anchor=0.; }
                after.emitted=after.emitted.checked_add(1).ok_or("Crown counter exhausted")?; //936DB1
            }
            after.has_emitted=true; //936DEF after the loop.
        }
        after.previous_frame=time; //9345D2 follows the separate frame callbacks.
        Ok(Plan {before:self.clone(),after,rng_before:rng.clone(),rng_after:next,births})
    }
    /// A stale plan cannot rewind the shared RNG or emitter. Only the safe host
    /// transaction is local; this does not claim native failure atomicity.
    pub fn commit(&mut self,plan:Plan,rng:&mut Rng55)->Result<Vec<Birth>,Error> {
        if *self!=plan.before || !same_rng(rng,&plan.rng_before) {return Err("stale Crown emission plan");}
        *self=plan.after;*rng=plan.rng_after;Ok(plan.births)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/nexus_crown/crown_native_vectors.json")).unwrap()}
    fn rng_eq(rng:&Rng55,row:&serde_json::Value) {
        assert_eq!(rng.first,row["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,row["second"].as_u64().unwrap() as u32);
        assert_eq!(rng.words.to_vec(),row["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
    }
    fn side(row:&serde_json::Value)->Side {if row["color"][0]==255 {Side::Order}else{Side::Chaos}}
    fn check(birth:&Birth,row:&serde_json::Value) {
        let bits=|key:&str|row[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
        assert_eq!(birth.color.map(f32::to_bits).to_vec(),bits("rgba"));
        assert_eq!(birth.vectors.iter().map(|v|v.map(f32::to_bits).to_vec()).collect::<Vec<_>>(),
            row["vectors"].as_array().unwrap().iter().map(|v|v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>()).collect::<Vec<_>>());
        assert_eq!(birth.schedule.time.to_bits(),row["birth_time"].as_u64().unwrap() as u32);
        assert_eq!(birth.life.to_bits(),row["life"].as_u64().unwrap() as u32);
        assert_eq!(birth.shared_uv.to_bits(),row["uv_shared"].as_u64().unwrap() as u32);
        assert_eq!(birth.uv.origin.into_iter().chain(birth.uv.rate).flatten().map(f32::to_bits).collect::<Vec<_>>(),bits("uv"));
    }
    #[test]
    fn whole_birth_native_packets_and_all_rng_words_match() {
        let proof=proof();let rows=proof["whole_birth"].as_array().unwrap();assert_eq!(rows.len(),18);
        for row in rows {let p=Profile::load(side(row)).unwrap();let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            rng_eq(&rng,&row["initial_rng"]);
            for (i,birth) in row["births"].as_array().unwrap().iter().enumerate() {
                check(&p.birth(1.,f32::MIN,row["count"].as_i64().unwrap() as i32,i as u32,[10.,20.,30.],&mut rng).unwrap(),birth);
            }rng_eq(&rng,&row["rng"]);
        }
    }
    #[test]
    fn sequential_native_gate_count_commit_and_third_uv_draw_match() {
        let proof=proof();let mut steps=0;
        for row in proof["emission"].as_array().unwrap() {let p=Profile::load(side(row)).unwrap();let mut state=Emitter::default();let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            for frame in row["steps"].as_array().unwrap() {steps+=1;let word=|v:&serde_json::Value|u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap();
                rng_eq(&rng,&frame["initial_rng"]);
                let plan=state.prepare(&p,f32::from_bits(word(&frame["time_bits"])),[10.,20.,30.],&rng).unwrap();
                let births=state.commit(plan,&mut rng).unwrap();assert_eq!(births.len(),frame["births"].as_array().unwrap().len());
                for (birth,expected) in births.iter().zip(frame["births"].as_array().unwrap()) {check(birth,expected);}
                rng_eq(&rng,&frame["rng"]);let s=&frame["state"];
                assert_eq!(u32::from(state.has_emitted),word(&s["0x74"]));assert_eq!(state.last_emission.to_bits(),word(&s["0x78"]));
                assert_eq!(state.previous_frame.to_bits(),word(&s["0x80"]));assert_eq!(state.distance_anchor.to_bits(),word(&s["0x108"]));assert_eq!(state.emitted,word(&s["0x118"]));
            }
        }assert_eq!(steps,54);
    }
    #[test]
    fn stale_plan_cannot_rewind_shared_rng_or_emitter() {
        let p=Profile::load(Side::Order).unwrap();let mut state=Emitter::default();let mut rng=Rng55::seeded(42);
        let plan=state.prepare(&p,0.,[0.;3],&rng).unwrap();let stale=plan.clone();
        state.commit(plan,&mut rng).unwrap();let before=state.clone();let rng_before=rng.clone();
        assert!(state.commit(stale,&mut rng).is_err());assert_eq!(state,before);assert!(same_rng(&rng,&rng_before));
        assert!(state.prepare(&p,f32::NAN,[0.;3],&rng).is_err());
        let plan=state.prepare(&p,0.5,[0.;3],&rng).unwrap();rng.fraction();
        assert!(state.commit(plan,&mut rng).is_err());assert_eq!(state,before);
    }

    #[test]
    fn startup_authored_color_age_and_two_birth_batch_preserve_rng_order() {
        for (side,initial,life,capacity) in [(Side::Order,[0.,0.,1.,0.],1.,6),(Side::Chaos,[1.,0.,1.,0.],2.,5)] {
            let profile=Profile::load_startup(side).unwrap();
            assert_eq!(profile.particle_capacity(),capacity);
            let mut emitter=Emitter::default();let mut rng=Rng55::seeded(42);
            let first=emitter.prepare(&profile,0.,[10.,20.,30.],&rng).unwrap();
            let first=emitter.commit(first,&mut rng).unwrap();
            assert_eq!(first.len(),1);assert_eq!(first[0].color,initial);assert_eq!(first[0].life,life);
            let mut expected=rng.clone();let count=if side==Side::Order {2}else{1};
            let expected_births:Vec<_>=(0..count).map(|index|profile.birth(0.5,0.,count,index as u32,[10.,20.,30.],&mut expected).unwrap()).collect();
            let plan=emitter.prepare(&profile,0.5,[10.,20.,30.],&rng).unwrap();
            assert_eq!(emitter.emitted,1); // preparation is still private
            let births=emitter.commit(plan,&mut rng).unwrap();assert_eq!(births.len(),count as usize);
            assert!(same_rng(&rng,&expected));assert_eq!(emitter.emitted,1+count as u32);
            for (birth,wanted) in births.iter().zip(expected_births) {
                assert_eq!(birth.schedule.time.to_bits(),wanted.schedule.time.to_bits());
                assert_eq!(birth.vectors,wanted.vectors);assert_eq!(birth.shared_uv,wanted.shared_uv);
            }
            if side==Side::Order {assert_eq!((births[0].schedule.time,births[1].schedule.time),(0.25,0.5));}
            // The native baked table is indexed by emitter age/90, not particle life.
            let mut late_rng=Rng55::seeded(42);
            let late=profile.birth(81.9,81.8,1,0,[0.;3],&mut late_rng).unwrap();
            let normalized=crate::native_complex_age::EmitterAgeInput {config_308:f32::MAX,config_30c:f32::MAX,
                instance_7c:90.,time:81.9,owner_a8:0.,offset_2ec:0.}.evaluate().normalized;
            let index=crate::native_scalar_parameter::baked_scalar_index(256,normalized).unwrap();
            assert_eq!(late.color,profile.color.table[index]);assert_ne!(late.color,initial);
        }
    }
    #[test]
    fn startup_duration_boundary_stops_births_and_counter_overflow_is_transactional() {
        let profile=Profile::load_startup(Side::Order).unwrap();let mut emitter=Emitter::default();let mut rng=Rng55::seeded(13);
        let plan=emitter.prepare(&profile,89.5,[0.;3],&rng).unwrap();
        assert_eq!(emitter.commit(plan,&mut rng).unwrap().len(),2);
        let previous_rng=rng.clone();let count=emitter.emitted;
        for time in [90.,90.5,200.] {
            let plan=emitter.prepare(&profile,time,[0.;3],&rng).unwrap();assert!(emitter.commit(plan,&mut rng).unwrap().is_empty());
            assert!(same_rng(&rng,&previous_rng));assert_eq!(emitter.emitted,count);
        }
        let emitter=Emitter {emitted:i32::MAX as u32-1,has_emitted:true,previous_frame:0.,last_emission:0.,..Emitter::default()};
        assert!(emitter.prepare(&profile,0.5,[0.;3],&rng).is_err());
        assert_eq!(emitter.emitted,i32::MAX as u32-1);assert!(same_rng(&rng,&previous_rng));
    }
    #[test]
    fn startup_original_reader_tables_and_sequential_packets_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/nexus_crown/crown_startup_native_vectors.json")).unwrap();
        let side=|reference:&str|if reference.starts_with("Order_"){Side::Order}else{Side::Chaos};
        let word=|v:&serde_json::Value|u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap();
        let tables=proof["reader_tables"].as_array().unwrap();assert_eq!(tables.len(),2);
        for row in tables {
            let profile=Profile::load_startup(side(row["reference"].as_str().unwrap())).unwrap();
            assert_eq!(profile.color.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),
                row["table_bits"].as_array().unwrap().iter().map(word).collect::<Vec<_>>());
        }
        let mut frames=0;let mut packets=0;
        for row in proof["emission"].as_array().unwrap() {
            let profile=Profile::load_startup(side(row["reference"].as_str().unwrap())).unwrap();
            let mut state=Emitter::default();let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            for frame in row["steps"].as_array().unwrap() {
                frames+=1;rng_eq(&rng,&frame["initial_rng"]);
                let plan=state.prepare(&profile,f32::from_bits(word(&frame["time_bits"])),[10.,20.,30.],&rng).unwrap();
                let births=state.commit(plan,&mut rng).unwrap();
                let expected=frame["births"].as_array().unwrap();assert_eq!(births.len(),expected.len());packets+=births.len();
                for (birth,expected) in births.iter().zip(expected){check(birth,expected);}
                rng_eq(&rng,&frame["rng"]);let s=&frame["state"];
                assert_eq!(u32::from(state.has_emitted),word(&s["0x74"]));
                assert_eq!(state.last_emission.to_bits(),word(&s["0x78"]));
                assert_eq!(state.previous_frame.to_bits(),word(&s["0x80"]));
                assert_eq!(state.distance_anchor.to_bits(),word(&s["0x108"]));
                assert_eq!(state.emitted,word(&s["0x118"]));
            }
        }
        assert_eq!((frames,packets),(40,40));
    }
}
