//! Original6B3FA0 local-team, non-spectator registered actor filter.
//! Raw flags are retained: their producers and other view modes remain unqualified.
pub struct ActorFilter {
    pub team_tag:u32,
    pub flag_ad:bool,
    pub flag_118:bool,
    pub descriptor_24:bool,
    pub descriptor_2c:bool,
}
impl ActorFilter {
    pub fn eligible_local(&self)->bool {
        self.flag_ad && !self.flag_118 && self.team_tag!=300 && (self.descriptor_2c || self.descriptor_24)
    }
}
impl crate::fow_source_factory::CircleView {
    /// Missing registration/actor follows the original fallback to source scheduling.
    pub fn select_local_source(&mut self,source:&mut crate::fow_source_factory::CircleSource,local_team:u32,registry:&crate::fow_entity_registry::EntityRegistry<'_,ActorFilter>)->Result<bool,&'static str> {
        // Native6B418F false spectator skips the source, preserving an existing mask.
        if source.owner_tag!=local_team {return Ok(false);}
        let eligible=source.registered_actor(registry).is_none_or(ActorFilter::eligible_local);
        if !eligible {source.withdraw_from(&mut self.layer)?;}
        Ok(eligible)
    }
}
#[cfg(test)] mod tests {
    use super::*;
    use crate::{fow_source_factory::*,fow_regions::StencilRegion,fow_entity_registry::EntityRegistry};
    use std::collections::BTreeMap;
    #[test] fn registered_actor_gates_mask_withdrawal_and_schedule_match_288_native_frames() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_registered_filter_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),288);
        for c in proof["cases"].as_array().unwrap() {
            let presence=c["presence"].as_str().unwrap();
            let registrations:BTreeMap<u32,u32>=if presence=="absent_registration" {BTreeMap::new()}else{(0..3).map(|i|(55+i,0x12340000+i)).collect()};
            let actors:BTreeMap<u32,ActorFilter>=if presence=="actor" {(0..3).map(|i|(0x12340000+i,ActorFilter {team_tag:c["actor_tag"].as_u64().unwrap() as u32,flag_ad:c["flag_ad"].as_bool().unwrap(),flag_118:c["flag_118"].as_bool().unwrap(),descriptor_24:c["flag_24"].as_bool().unwrap(),descriptor_2c:c["flag_2c"].as_bool().unwrap()})).collect()}else{BTreeMap::new()};
            let registry=EntityRegistry {registrations:&registrations,actors:&actors};
            let mut factory=CircleFactory::default();let mut view=CircleView::new(8).unwrap();let mut references=Vec::new();
            for (i,center) in [[0.,0.],[1000.,0.],[10000.,10000.]].into_iter().enumerate() {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:None,center,radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
                if c["initial_applied"].as_bool().unwrap() {let strong=reference.upgrade().unwrap();strong.lock().unwrap().apply_to_layer(&mut view.layer,StencilRegion {words:vec![0x55555555;2],rect:[1,2,5,6],applied:false}).unwrap();}
                references.push(reference);
            }
            for reference in &references {
                let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                if view.select_local_source(&mut source,100,&registry).unwrap() {view.enqueue_update(reference,&mut source,false,0,[0.,0.],15398.671875,5.001,&[]).unwrap();}
            }
            let native=&c["before_processing"];
            assert_eq!(view.layer.counts,native["counts"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"counts {c}");
            assert_eq!(view.pending.entries().len(),native["pending"].as_array().unwrap().len(),"selection {c}");
            for (entry,expected) in view.pending.entries().iter().zip(native["pending"].as_array().unwrap()) {
                assert_eq!(references.iter().position(|r|r.as_ptr() as usize==entry.source).unwrap(),expected["identity"].as_u64().unwrap() as usize);
                assert!((f32::from_bits(entry.priority_bits)-f32::from_bits(expected["priority_bits"].as_u64().unwrap() as u32)).abs()<=0.000001);
            }
            for (i,reference) in references.iter().enumerate() {let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();assert_eq!(source.applied(),native["applied_flags"][i].as_bool().unwrap());assert_eq!(source.pending,native["pending_flags"][i].as_bool().unwrap());}
            let mut generated=Vec::new();view.process_frame(&factory,3.,|source,_|{generated.push(source.opaque_ids[0]-55);Ok(())}).unwrap();
            assert_eq!(generated,c["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
            assert_eq!(view.layer.counts,c["counts_after"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>());
            for (i,reference) in references.iter().enumerate() {let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();assert_eq!(source.applied(),c["applied_after"][i].as_bool().unwrap());assert_eq!(source.pending,c["pending_flags_after"][i].as_bool().unwrap());}
        }
    }
}

/// Qualified inputs for the local-team, non-spectator source pass.
pub struct LocalViewInputs {
    pub local_team:u32,
    pub force:bool,
    pub refresh_frames:i32,
    pub camera:[f32;2],
    pub extent:f32,
    pub now:f32,
}
impl crate::fow_source_factory::CircleView {
    /// Native order: resolve/filter actor, withdraw excluded mask, then schedule.
    pub fn enqueue_local_source(&mut self,reference:&std::sync::Weak<std::sync::Mutex<crate::fow_source_factory::CircleSource>>,source:&mut crate::fow_source_factory::CircleSource,input:&LocalViewInputs,registry:&crate::fow_entity_registry::EntityRegistry<'_,ActorFilter>,owners:&[Option<crate::fow_owner::Owner>])->Result<bool,&'static str> {
        if !self.select_local_source(source,input.local_team,registry)? {return Ok(false);}
        self.enqueue_update(reference,source,input.force,input.refresh_frames,input.camera,input.extent,input.now,owners)
    }
}

#[cfg(test)] mod team_tests {
    use super::*;
    use crate::{fow_source_factory::*,fow_regions::StencilRegion,fow_entity_registry::EntityRegistry};
    use std::collections::BTreeMap;
    #[test] fn other_team_sources_preserve_existing_masks_without_scheduling_864_native_frames() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_team_filter_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),864);
        for c in proof["cases"].as_array().unwrap() {
            let presence=c["presence"].as_str().unwrap();
            let registrations:BTreeMap<u32,u32>=if presence=="absent_registration" {BTreeMap::new()}else{(0..3).map(|i|(55+i,0x12340000+i)).collect()};
            let actors:BTreeMap<u32,ActorFilter>=if presence=="actor" {(0..3).map(|i|(0x12340000+i,ActorFilter {team_tag:c["actor_tag"].as_u64().unwrap() as u32,flag_ad:c["flag_ad"].as_bool().unwrap(),flag_118:c["flag_118"].as_bool().unwrap(),descriptor_24:c["flag_24"].as_bool().unwrap(),descriptor_2c:c["flag_2c"].as_bool().unwrap()})).collect()}else{BTreeMap::new()};
            let registry=EntityRegistry {registrations:&registrations,actors:&actors};
            let mut factory=CircleFactory::default();let mut view=CircleView::new(8).unwrap();let mut references=Vec::new();
            for (i,center) in [[0.,0.],[1000.,0.],[10000.,10000.]].into_iter().enumerate() {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:c["source_tag"].as_u64().unwrap() as u32,owner:None,center,radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
                if c["initial_applied"].as_bool().unwrap() {let strong=reference.upgrade().unwrap();strong.lock().unwrap().apply_to_layer(&mut view.layer,StencilRegion {words:vec![0x55555555;2],rect:[1,2,5,6],applied:false}).unwrap();}
                references.push(reference);
            }
            for reference in &references {
                let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                if view.select_local_source(&mut source,100,&registry).unwrap() {view.enqueue_update(reference,&mut source,false,0,[0.,0.],15398.671875,5.001,&[]).unwrap();}
            }
            let native=&c["before_processing"];
            assert_eq!(view.layer.counts,native["counts"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"counts {c}");
            assert_eq!(view.pending.entries().len(),native["pending"].as_array().unwrap().len(),"selection {c}");
            for (entry,expected) in view.pending.entries().iter().zip(native["pending"].as_array().unwrap()) {
                assert_eq!(references.iter().position(|r|r.as_ptr() as usize==entry.source).unwrap(),expected["identity"].as_u64().unwrap() as usize);
                assert!((f32::from_bits(entry.priority_bits)-f32::from_bits(expected["priority_bits"].as_u64().unwrap() as u32)).abs()<=0.000001);
            }
            for (i,reference) in references.iter().enumerate() {let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();assert_eq!(source.applied(),native["applied_flags"][i].as_bool().unwrap());assert_eq!(source.pending,native["pending_flags"][i].as_bool().unwrap());}
            let mut generated=Vec::new();view.process_frame(&factory,3.,|source,_|{generated.push(source.opaque_ids[0]-55);Ok(())}).unwrap();
            assert_eq!(generated,c["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
            assert_eq!(view.layer.counts,c["counts_after"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>());
            for (i,reference) in references.iter().enumerate() {let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();assert_eq!(source.applied(),c["applied_after"][i].as_bool().unwrap());assert_eq!(source.pending,c["pending_flags_after"][i].as_bool().unwrap());}
        }
    }
}
