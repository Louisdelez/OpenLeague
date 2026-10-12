//! Native game-object ID factory and registered-source creation.
//! Allocation callbacks are explicit: no native heap defaults are invented.
use std::collections::BTreeMap;
use crate::audio_source_storage::RegisteredSources;
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct RegisterCommand {pub object_id:u32,pub listener_mask:u32,pub extra_raw:u32}
pub fn registration_command(object_id:u32,listener_mask:u32)->Option<RegisterCommand> {
    (object_id!=0 && object_id!=u32::MAX).then_some(RegisterCommand {object_id,listener_mask,extra_raw:0})
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct GameObject {
    pub object_id:u32,
    // Constructor copies global2D773B4 (zero-filled at image startup).
    // It is not the current listener orientation or an initialized source position.
    pub cached_vector_words:[u32;3],
    pub field14_raw:u32,
    pub field18_raw:u8,
}
pub struct Factory {pub next_id:u32}
/// PE-backed initial state. Own one factory across the engine; creating a new
/// ambient producer must not reset this counter. Runtime restores remain explicit.
impl Default for Factory {fn default()->Self{Self {next_id:2}}}
/// Initial image words only. Callers retain the actual global vector thereafter.
pub const IMAGE_INITIAL_CACHED_VECTOR_WORDS:[u32;3]=[0,0,0];
impl Factory {
    /// Counter and cached vector belong to shared engine state; no per-voice reset.
    pub fn create(&mut self,orientation_words:[u32;3],engine_available:bool,
        allocate:impl FnOnce()->bool,mut enqueue:impl FnMut(RegisterCommand)->u32)->Option<GameObject> {
        let object=allocate().then(|| {
            if engine_available {
                if let Some(command)=registration_command(self.next_id,1) {let _=enqueue(command);}
            }
            GameObject {object_id:self.next_id,cached_vector_words:orientation_words,field14_raw:0,field18_raw:1}
        });
        // Original70565A advances even after allocation failure or rejected ID.
        self.next_id=self.next_id.wrapping_add(1);
        object
    }
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Allocation {Object100Bytes,Node12Bytes}
#[derive(Default)]
pub struct Registry {objects:BTreeMap<u32,RegisteredSources>}
impl Registry {
    pub fn get(&self,id:u32)->Option<&RegisteredSources> {self.objects.get(&id)}
    pub fn get_mut(&mut self,id:u32)->Option<&mut RegisteredSources> {self.objects.get_mut(&id)}
    pub fn restore(&mut self,id:u32,object:RegisteredSources) {self.objects.insert(id,object);}
    /// Existing object updates mask/dirty only. New allocations expose the
    /// untouched upper5 mode bits explicitly through the supplied memory seed.
    /// An object or hash-node allocation failure leaves the registry unchanged.
    pub fn register(&mut self,command:RegisterCommand,mut allocate:impl FnMut(Allocation)->Option<u8>)->bool {
        let mask=command.listener_mask as u8;
        if let Some(object)=self.objects.get_mut(&command.object_id) {
            object.listener_mask=mask;object.dirty_flags|=0x40000000;
            return true;
        }
        let Some(mode_seed)=allocate(Allocation::Object100Bytes) else {return false;};
        if allocate(Allocation::Node12Bytes).is_none() {return false;}
        let object=RegisteredSources::restore(Vec::new(),mode_seed&0xf8,mask,0xc0000001)
            .expect("empty native source descriptor");
        self.objects.insert(command.object_id,object);
        true
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[derive(serde::Deserialize)]
    struct Packet {object_id:u32,listener_mask:u32,extra_raw:u32}
    #[derive(serde::Deserialize)]
    struct FactoryCase {
        counter:u32,engine_available:bool,allocation_failure:bool,queue_result:u32,
        next_counter:u32,created:bool,packets:Vec<Packet>,
    }
    #[derive(serde::Deserialize)]
    struct Fields {count:usize,mask:u8,mode:u8,dirty:u32}
    #[derive(serde::Deserialize)]
    struct RegistrationCase {
        existing:bool,allocation_seed:u8,mask:u32,object_allocation_failure:bool,
        node_allocation_failure:bool,created_or_existing:bool,fields:Option<Fields>,
    }
    #[derive(serde::Deserialize)]
    struct Contract {
        factory_cases:Vec<FactoryCase>,registration_cases:Vec<RegistrationCase>,wrapper_orientation_words:[u32;3],
    }
    fn contract()->Contract {
        serde_json::from_str(include_str!("../../../data/4.20/audio_object_registration_contract.json")).unwrap()
    }
    #[test]
    fn original_object_factory_id_wrap_failure_and_register_packets_match() {
        let c=contract();assert_eq!(c.factory_cases.len(),40);
        for row in c.factory_cases {
            let mut factory=Factory {next_id:row.counter};let mut packets=Vec::new();
            let object=factory.create(c.wrapper_orientation_words,row.engine_available,||!row.allocation_failure,|p| {
                packets.push(p);row.queue_result
            });
            assert_eq!(factory.next_id,row.next_counter);assert_eq!(object.is_some(),row.created);
            if let Some(object)=object {
                assert_eq!(object.object_id,row.counter);assert_eq!(object.cached_vector_words,c.wrapper_orientation_words);
                assert_eq!(object.field14_raw,0);assert_eq!(object.field18_raw,1);
            }
            assert_eq!(packets.len(),row.packets.len());
            for (packet,expected) in packets.iter().zip(row.packets) {
                assert_eq!(*packet,RegisterCommand {object_id:expected.object_id,listener_mask:expected.listener_mask,extra_raw:expected.extra_raw});
            }
        }
    }
    #[test]
    fn original_worker_registration_existing_mask_and_seed_defaults_match() {
        let c=contract();assert_eq!(c.registration_cases.len(),120);
        for row in c.registration_cases {
            let mut registry=Registry::default();
            if row.existing {
                registry.restore(386,RegisteredSources::restore(vec![crate::audio_source_storage::RawSource {words:[0;6]};3],
                    row.allocation_seed,0,0x12345678).unwrap());
            }
            let mut allocations=Vec::new();
            let result=registry.register(RegisterCommand {object_id:386,listener_mask:row.mask,extra_raw:0},|kind| {
                allocations.push(kind);
                match kind {
                    Allocation::Object100Bytes=>(!row.object_allocation_failure).then_some(row.allocation_seed),
                    Allocation::Node12Bytes=>(!row.node_allocation_failure).then_some(0),
                }
            });
            assert_eq!(result,row.created_or_existing);
            if let Some(fields)=row.fields {
                let object=registry.get(386).unwrap();
                assert_eq!(object.sources().len(),fields.count);assert_eq!(object.mode_raw,fields.mode);
                assert_eq!(object.listener_mask,fields.mask);assert_eq!(object.dirty_flags,fields.dirty);
            } else {assert!(registry.get(386).is_none());}
            assert_eq!(allocations,if row.existing {vec![]} else if row.object_allocation_failure {
                vec![Allocation::Object100Bytes]
            } else {vec![Allocation::Object100Bytes,Allocation::Node12Bytes]});
        }
    }
    #[test]
    fn native_id_registration_point_storage_and_listener_distance_connect() {
        let mut factory=Factory {next_id:123};let mut registry=Registry::default();
        let object=factory.create([0,0,0x3f800000],true,||true,|command| {
            assert!(registry.register(command,|_|Some(0)));1
        }).unwrap();
        let point=crate::audio_emitter_position::dispatch(
            Some(crate::audio_routing::VoiceRoute {object_id:object.object_id as i32,actor_id:0}),
            true,[7400.,1500.,7700.]).unwrap().position_update.unwrap();
        let source=crate::audio_source_storage::RawSource::from_point(point,[0x7fc00000;3]);
        crate::audio_source_storage::apply_registered(registry.get_mut(point.object_id),&[source],0).unwrap();
        let listeners=[crate::audio_distance::Listener {position:[7400.,500.,7700.],distance_scale:1.};8];
        assert_eq!(registry.get(point.object_id).unwrap().nearest_distance(&listeners).unwrap(),1000.);
        assert!(registry.get(999).is_none());assert_eq!(factory.next_id,124);
    }
}
#[derive(Debug,Clone,Copy,PartialEq)]
pub enum PositionError {InvalidPoint,InvalidHeight}
impl GameObject {
    /// 707420 caches inputXYZ, but submits[X,field14*-2500,Z] when available.
    /// ObjectFFFFFFFF is accepted on this path; object0 is rejected byAEB1C0.
    pub fn update_position(&mut self,point:[f32;3],engine_available:bool)
        ->Result<Option<crate::audio_emitter_position::PositionUpdate>,PositionError> {
        if point.iter().any(|v|!v.is_finite()) {return Err(PositionError::InvalidPoint);}
        let submitted=if engine_available && self.object_id!=0 {
            let height=f32::from_bits(self.field14_raw)*-2500.;
            if !height.is_finite() {return Err(PositionError::InvalidHeight);}
            Some(crate::audio_emitter_position::PositionUpdate {
                object_id:self.object_id,position:[point[0],height,point[2]],
                orientation:crate::audio_emitter_position::OrientationState::NotInitializedByNativeProducer,
            })
        } else {None};
        self.cached_vector_words=point.map(f32::to_bits);
        Ok(submitted)
    }
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum UnregisterCommand {Single(u32),All}
pub fn unregister_command(object_id:u32)->Option<UnregisterCommand> {
    match object_id {0=>None,u32::MAX=>Some(UnregisterCommand::All),id=>Some(UnregisterCommand::Single(id))}
}
#[derive(Debug,Clone,PartialEq,Eq)]
pub enum RemovedObject {
    Destroyed {dirty_flags:u32},
    /// Ownership leaves the registry and must remain with outstanding voices.
    /// This is source-descriptor ownership only, not a complete native voice.
    Retained(RegisteredSources),
}

impl Registry {
    /// B099D0 increments low30 reference bits and preserves both upper flags.
    pub fn acquire(&mut self,id:u32)->Option<&mut RegisteredSources> {
        let object=self.objects.get_mut(&id)?;
        object.dirty_flags=(object.dirty_flags&0xc0000000)|(object.dirty_flags.wrapping_add(1)&0x3fffffff);
        Some(object)
    }
    fn removed(mut object:RegisteredSources,single:bool)->RemovedObject {
        let upper=object.dirty_flags&(if single {0x40000000} else {0xc0000000});
        object.dirty_flags=upper|(object.dirty_flags.wrapping_sub(1)&0x3fffffff);
        if object.dirty_flags&0x3fffffff==0 {
            RemovedObject::Destroyed {dirty_flags:object.dirty_flags}
        } else {RemovedObject::Retained(object)}
    }
    /// Single removal clears bit31; global removal preserves both upper bits
    /// and leaves reserved ID0 registered. Outstanding sources leave this table
    /// as owned values for the voice backend; full retained-voice release is separate.
    pub fn unregister(&mut self,command:UnregisterCommand)->Vec<RemovedObject> {
        match command {
            UnregisterCommand::Single(id)=>self.objects.remove(&id)
                .map(|object|vec![Self::removed(object,true)]).unwrap_or_default(),
            UnregisterCommand::All=>{
                let objects=std::mem::take(&mut self.objects);
                let mut removed=Vec::new();
                for (id,object) in objects {
                    if id==0 {self.objects.insert(id,object);}
                    else {removed.push(Self::removed(object,false));}
                }
                removed
            }
        }
    }
}
#[cfg(test)]
mod lifecycle_tests {
    use super::*;
    #[derive(serde::Deserialize)]
    struct Message {object_id:u32,position_bits:Option<[u32;3]>,opaque_tail:Option<[u32;3]>}
    #[derive(serde::Deserialize)]
    struct PositionCase {object_id:u32,height_raw:f32,engine_available:bool,stack_seed:u32,input_point:[f32;3],stored_point_bits:[u32;3],messages:Vec<Message>}
    #[derive(serde::Deserialize)]
    struct PacketCase {object_id:u32,messages:Vec<Message>,result:u32}
    #[derive(serde::Deserialize)]
    struct ReferenceCase {found:bool,prior_flags:u32,after_flags:u32}
    #[derive(serde::Deserialize)]
    struct RemovalCase {found:bool,prior_flags:u32,after_flags:u32,destroyed:bool}
    #[derive(serde::Deserialize)]
    struct Contract {unregister_all_cases:Vec<AllCase>,position_cases:Vec<PositionCase>,unregister_packet_cases:Vec<PacketCase>,acquire_cases:Vec<ReferenceCase>,unregister_cases:Vec<RemovalCase>}
    #[derive(serde::Deserialize)]
    struct AllObject {object_id:u32,after_flags:u32,registered_after:bool,destroyed:bool}
    #[derive(serde::Deserialize)]
    struct AllCase {input_ids:Vec<u32>,prior_flags:u32,objects:Vec<AllObject>}
    #[test]
    fn original_unregister_all_preserves_reserved_zero_and_retained_upper_bits() {
        let cases=contract().unregister_all_cases;assert_eq!(cases.len(),40);
        for mut c in cases {
            let mut registry=Registry::default();
            for id in c.input_ids {
                registry.restore(id,RegisteredSources::restore(
                    vec![crate::audio_source_storage::RawSource {words:[id;6]}],
                    0xa1,0x81,c.prior_flags).unwrap());
            }
            let removed=registry.unregister(UnregisterCommand::All);
            c.objects.sort_by_key(|o|o.object_id);
            let expected:Vec<_>=c.objects.iter().filter(|o|!o.registered_after).collect();
            assert_eq!(removed.len(),expected.len());
            for (actual,expected) in removed.iter().zip(expected) {
                match actual {
                    RemovedObject::Destroyed {dirty_flags}=>{
                        assert!(expected.destroyed);assert_eq!(*dirty_flags,expected.after_flags);
                    }
                    RemovedObject::Retained(object)=>{
                        assert!(!expected.destroyed);assert_eq!(object.dirty_flags,expected.after_flags);
                        assert_eq!(object.sources()[0].words,[expected.object_id;6]);
                    }
                }
            }
            for expected in c.objects {
                assert_eq!(registry.get(expected.object_id).is_some(),expected.registered_after);
                if let Some(object)=registry.get(expected.object_id) {assert_eq!(object.dirty_flags,expected.after_flags);}
            }
        }
    }
    fn contract()->Contract {serde_json::from_str(include_str!("../../../data/4.20/audio_object_lifecycle_contract.json")).unwrap()}
    fn sources(flags:u32)->RegisteredSources {
        RegisteredSources::restore(vec![crate::audio_source_storage::RawSource {words:[1,2,3,4,5,6]}],0xa1,0x81,flags).unwrap()
    }
    #[test]
    fn native_game_object_point_height_override_and_packet_bits_match() {
        let cases=contract().position_cases;assert_eq!(cases.len(),48);
        for c in cases {
            let mut object=GameObject {object_id:c.object_id,cached_vector_words:[0;3],field14_raw:c.height_raw.to_bits(),field18_raw:1};
            let command=object.update_position(c.input_point,c.engine_available).unwrap();
            assert_eq!(object.cached_vector_words,c.stored_point_bits);assert_eq!(usize::from(command.is_some()),c.messages.len());
            if let Some(command)=command {
                let expected=&c.messages[0];assert_eq!(command.object_id,expected.object_id);
                let words=command.native_words([c.stack_seed;3]);
                assert_eq!(&words[..3],&expected.position_bits.unwrap());assert_eq!(&words[3..],&expected.opaque_tail.unwrap());
            }
        }
    }
    #[test]
    fn native_reference_acquisition_and_unregister_retention_match() {
        let c=contract();assert_eq!(c.acquire_cases.len(),20);assert_eq!(c.unregister_cases.len(),40);
        for row in c.acquire_cases {
            let mut registry=Registry::default();
            if row.found {registry.restore(386,sources(row.prior_flags));}
            let result=registry.acquire(386);assert_eq!(result.is_some(),row.found);
            if let Some(object)=result {assert_eq!(object.dirty_flags,row.after_flags);}
        }
        for row in c.unregister_cases {
            let mut registry=Registry::default();let unrelated=sources(0xc0000001);registry.restore(193,unrelated.clone());
            if row.found {registry.restore(386,sources(row.prior_flags));}
            let result=registry.unregister(UnregisterCommand::Single(386)).pop();
            assert_eq!(result.is_some(),row.found);assert!(registry.get(386).is_none());assert_eq!(registry.get(193),Some(&unrelated));
            if let Some(result)=result {
                match result {
                    RemovedObject::Destroyed {dirty_flags}=>{assert!(row.destroyed);assert_eq!(dirty_flags,row.after_flags);}
                    RemovedObject::Retained(object)=>{
                        assert!(!row.destroyed);assert_eq!(object.dirty_flags,row.after_flags);
                        assert_eq!(object.sources()[0].words,[1,2,3,4,5,6]);
                    }
                }
            }
        }
        let mut registry=Registry::default();registry.restore(123,sources(0xc0000001));
        registry.acquire(123).unwrap();
        let RemovedObject::Retained(owned)=registry.unregister(UnregisterCommand::Single(123)).pop().unwrap() else {panic!("voice reference must survive");};
        assert_eq!(owned.dirty_flags,0x40000001);assert!(registry.get(123).is_none());
    }
    #[test]
    fn unregister_packet_api_and_invalid_point_preserve_state() {
        let c=contract();assert_eq!(c.unregister_packet_cases.len(),4);
        for row in c.unregister_packet_cases {
            let command=unregister_command(row.object_id);
            assert_eq!(usize::from(command.is_some()),row.messages.len());
            assert_eq!(row.result,if command.is_some(){1}else{2});
        }
        let mut registry=Registry::default();registry.restore(123,sources(0xc0000001));
        assert_eq!(registry.unregister(UnregisterCommand::All).len(),1);
        assert!(registry.get(123).is_none());
        let mut object=GameObject {object_id:123,cached_vector_words:[1,2,3],field14_raw:0,field18_raw:1};
        let before=object;
        assert_eq!(object.update_position([f32::NAN;3],true),Err(PositionError::InvalidPoint));assert_eq!(object,before);
    }
}
impl GameObject {
    /// 7074B0 stores the raw flag; force optionally sets height exactly0 or1.
    /// This setter itself submits no audio position message.
    pub fn set_flag(&mut self,flag:u8,force:bool) {
        self.field18_raw=flag;
        if force {self.field14_raw=(if flag!=0 {0_f32} else {1_f32}).to_bits();}
    }
    /// 707610 changes height only on the native update branches. A height update
    /// emits a position even for delta0; negative deltas are not clamped away.
    pub fn tick_height(&mut self,delta:f32,engine_available:bool)
        ->Result<Option<crate::audio_emitter_position::PositionUpdate>,PositionError> {
        let height=f32::from_bits(self.field14_raw);
        if !height.is_finite() {return Err(PositionError::InvalidHeight);}
        let next=if self.field18_raw!=0 {
            if height>0. {0.} else {return Ok(None);}
        } else if height<1. {
            if !delta.is_finite() {return Err(PositionError::InvalidHeight);}
            (height+delta).min(1.)
        } else {return Ok(None);};
        if !next.is_finite() {return Err(PositionError::InvalidHeight);}
        let command=if engine_available && self.object_id!=0 {
            let x=f32::from_bits(self.cached_vector_words[0]);
            let z=f32::from_bits(self.cached_vector_words[2]);
            let y=next*-2500.;
            if !x.is_finite() || !z.is_finite() {return Err(PositionError::InvalidPoint);}
            if !y.is_finite() {return Err(PositionError::InvalidHeight);}
            Some(crate::audio_emitter_position::PositionUpdate {
                object_id:self.object_id,position:[x,y,z],
                orientation:crate::audio_emitter_position::OrientationState::NotInitializedByNativeProducer,
            })
        } else {None};
        self.field14_raw=next.to_bits();
        Ok(command)
    }
}
impl RegisteredSources {
    /// Native final-reference fragments decrement low30 bits, preserve upper2,
    /// and request destruction at zero. Caller must discard the object at true.
    /// Full native destructor callbacks remain separate from this source state.
    pub fn release_reference(&mut self)->bool {
        self.dirty_flags=(self.dirty_flags&0xc0000000)|(self.dirty_flags.wrapping_sub(1)&0x3fffffff);
        self.dirty_flags&0x3fffffff==0
    }
}
#[cfg(test)]
mod height_reference_tests {
    use super::*;
    #[derive(serde::Deserialize)]
    struct SetterCase {height_bits:u32,flag:u8,force:u8,after_height_bits:u32,after_flag:u8}
    #[derive(serde::Deserialize)]
    struct Message {object_id:u32,position_bits:[u32;3],opaque_tail:[u32;3]}
    #[derive(serde::Deserialize)]
    struct TickCase {height_bits:u32,flag:u8,delta:f32,object_id:u32,engine_available:bool,stack_seed:u32,after_height_bits:u32,messages:Vec<Message>}
    #[derive(serde::Deserialize)]
    struct ReleaseCase {prior_flags:u32,after_flags:u32,destroyed:bool}
    #[derive(serde::Deserialize)]
    struct Contract {setter_cases:Vec<SetterCase>,height_tick_cases:Vec<TickCase>,final_reference_cases:Vec<ReleaseCase>}
    fn contract()->Contract {serde_json::from_str(include_str!("../../../data/4.20/audio_object_height_reference_contract.json")).unwrap()}
    fn object(id:u32,height:u32,flag:u8)->GameObject {
        GameObject {object_id:id,cached_vector_words:[7400_f32.to_bits(),1500_f32.to_bits(),7700_f32.to_bits()],field14_raw:height,field18_raw:flag}
    }
    #[test]
    fn native_raw_flag_and_force_height_setter_match() {
        let cases=contract().setter_cases;assert_eq!(cases.len(),36);
        for c in cases {
            let mut object=object(123,c.height_bits,0x55);
            object.set_flag(c.flag,c.force!=0);
            assert_eq!(object.field18_raw,c.after_flag);assert_eq!(object.field14_raw,c.after_height_bits);
        }
    }
    #[test]
    fn native_height_tick_and_position_packets_match_bits_without_clamping_delta() {
        let cases=contract().height_tick_cases;assert_eq!(cases.len(),1080);
        for c in cases {
            let mut object=object(c.object_id,c.height_bits,c.flag);let before=object.cached_vector_words;
            let command=object.tick_height(c.delta,c.engine_available).unwrap();
            assert_eq!(object.field14_raw,c.after_height_bits);assert_eq!(object.field18_raw,c.flag);
            assert_eq!(object.cached_vector_words,before);assert_eq!(usize::from(command.is_some()),c.messages.len());
            if let Some(command)=command {
                let expected=&c.messages[0];assert_eq!(command.object_id,expected.object_id);
                let words=command.native_words([c.stack_seed;3]);
                assert_eq!(&words[..3],&expected.position_bits);assert_eq!(&words[3..],&expected.opaque_tail);
            }
        }
    }
    #[test]
    fn native_final_reference_and_height_storage_distance_bridge_match() {
        let cases=contract().final_reference_cases;assert_eq!(cases.len(),20);
        for c in cases {
            let mut source=RegisteredSources::restore(Vec::new(),0,1,c.prior_flags).unwrap();
            assert_eq!(source.release_reference(),c.destroyed);assert_eq!(source.dirty_flags,c.after_flags);
        }
        let mut registry=Registry::default();
        assert!(registry.register(RegisterCommand {object_id:123,listener_mask:1,extra_raw:0},|_|Some(0)));
        let mut object=object(123,0,1);object.set_flag(0,false);
        let update=object.tick_height(0.25,true).unwrap().unwrap();
        assert_eq!(update.position,[7400.,-625.,7700.]);
        let raw=crate::audio_source_storage::RawSource::from_point(update,[0x7fc00000;3]);
        crate::audio_source_storage::apply_registered(registry.get_mut(123),&[raw],0).unwrap();
        let listeners=[crate::audio_distance::Listener {position:[7400.,500.,7700.],distance_scale:1.};8];
        assert_eq!(registry.get(123).unwrap().nearest_distance(&listeners).unwrap(),1125.);
        registry.acquire(123).unwrap();
        let RemovedObject::Retained(mut retained)=registry.unregister(UnregisterCommand::Single(123)).pop().unwrap()
            else {panic!("playing voice reference remains");};
        assert!(retained.release_reference());assert_eq!(retained.dirty_flags,0x40000000);
    }
}

#[cfg(test)] mod startup_tests {
 use super::*;
 #[test] fn startup_factory_sequence_matches_original_image_without_seed_overrides(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_object_startup_contract.json")).unwrap();
  let mut factory=Factory::default();assert_eq!(u64::from(factory.next_id),proof["counter_initial"].as_u64().unwrap());
  assert_eq!(serde_json::json!(IMAGE_INITIAL_CACHED_VECTOR_WORDS),proof["cached_vector_initial_words"]);
  for row in proof["cases"].as_array().unwrap(){
   assert_eq!(u64::from(factory.next_id),row["counter_before"].as_u64().unwrap());
   let mut packets=Vec::new();
   let object=factory.create(IMAGE_INITIAL_CACHED_VECTOR_WORDS,row["engine_available"].as_bool().unwrap(),||!row["allocation_failed"].as_bool().unwrap(),|p|{packets.push(serde_json::json!({"type":11,"object_id":p.object_id,"listener_mask":p.listener_mask,"extra_raw":p.extra_raw}));1});
   assert_eq!(object.is_some(),row["result_present"].as_bool().unwrap());
   assert_eq!(u64::from(factory.next_id),row["next_counter"].as_u64().unwrap());assert_eq!(serde_json::json!(packets),row["packets"]);
   if let Some(object)=object{assert_eq!(u64::from(object.object_id),row["object_id"].as_u64().unwrap());assert_eq!(serde_json::json!(object.cached_vector_words),row["cached_vector_words"]);}
  }
 }
}
