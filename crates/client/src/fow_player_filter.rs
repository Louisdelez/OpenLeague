//! Native6B3FA0 player+5E8 bit11 and descriptor+34 restricted-view comparison.
//! Caller supplies flags/identifiers; their live producers remain open.
use crate::{fow_registered_filter::ActorFilter,fow_entity_registry::EntityRegistry,fow_source_factory::{CircleView,CircleSource}};
pub struct PlayerViewActor {pub filter:ActorFilter,pub descriptor_identity:u32}
impl CircleView {
    /// Restriction uses the descriptor identity, separate from source/actor handles.
    pub fn select_player_source(&mut self,source:&mut CircleSource,local_team:u32,restricted_descriptor:Option<u32>,registry:&EntityRegistry<'_,PlayerViewActor>)->Result<bool,&'static str> {
        if source.owner_tag!=local_team {return Ok(false);}
        let eligible=match source.registered_actor(registry) {
            None=>restricted_descriptor.is_none(),
            Some(actor)=>actor.filter.eligible_local() && restricted_descriptor.is_none_or(|id|id==actor.descriptor_identity),
        };
        if !eligible {source.withdraw_from(&mut self.layer)?;}
        Ok(eligible)
    }
}

#[cfg(test)] mod tests {
    use super::*;
    use crate::{fow_source_factory::*,fow_regions::StencilRegion,fow_entity_registry::EntityRegistry};
    use std::collections::BTreeMap;
    #[test] fn restricted_player_descriptor_gates_match_3456_native_frames() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_restricted_filter_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),3456);
        for c in proof["cases"].as_array().unwrap() {
            let presence=c["presence"].as_str().unwrap();
            let registrations:BTreeMap<u32,u32>=if presence=="absent_registration" {BTreeMap::new()}else{(0..3).map(|i|(55+i,0x12340000+i)).collect()};
            let actors:BTreeMap<u32,PlayerViewActor>=if presence=="actor" {(0..3).map(|i|(0x12340000+i,PlayerViewActor {descriptor_identity:if c["descriptor_matches"].as_bool().unwrap() {66}else{67},filter:ActorFilter {team_tag:c["actor_tag"].as_u64().unwrap() as u32,flag_ad:c["flag_ad"].as_bool().unwrap(),flag_118:c["flag_118"].as_bool().unwrap(),descriptor_24:c["flag_24"].as_bool().unwrap(),descriptor_2c:c["flag_2c"].as_bool().unwrap()}})).collect()}else{BTreeMap::new()};
            let registry=EntityRegistry {registrations:&registrations,actors:&actors};
            let mut factory=CircleFactory::default();let mut view=CircleView::new(8).unwrap();let mut references=Vec::new();
            for (i,center) in [[0.,0.],[1000.,0.],[10000.,10000.]].into_iter().enumerate() {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:c["source_tag"].as_u64().unwrap() as u32,owner:None,center,radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
                if c["initial_applied"].as_bool().unwrap() {let strong=reference.upgrade().unwrap();strong.lock().unwrap().apply_to_layer(&mut view.layer,StencilRegion {words:vec![0x55555555;2],rect:[1,2,5,6],applied:false}).unwrap();}
                references.push(reference);
            }
            for reference in &references {
                let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                if view.select_player_source(&mut source,100,if c["restricted"].as_bool().unwrap() {Some(66)}else{None},&registry).unwrap() {view.enqueue_update(reference,&mut source,false,0,[0.,0.],15398.671875,5.001,&[]).unwrap();}
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
