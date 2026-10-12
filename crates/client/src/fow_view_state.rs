//! Shared native2D7C06C/070/074/078 cache and6B2C80 selector cycling.
//! Caller retains one shared state across view updates, not one per view.
pub struct SharedViewState {
    pub initialized_bits:u32,
    pub cached_restricted:bool,
    pub refresh_remaining:i32,
    pub configured_enabled:bool,
}
impl SharedViewState {
    /// Called before source selection. Config input mirrors the external reader boundary.
    pub fn begin_update(&mut self,player_flags:Option<u32>,read_enabled:bool)->i32 {
        let restricted=player_flags.is_some_and(|flags|flags&0x800!=0);
        if self.initialized_bits&1==0 {self.initialized_bits|=1;self.cached_restricted=restricted;}
        if self.initialized_bits&2==0 {self.initialized_bits|=2;self.refresh_remaining=if self.cached_restricted {20}else{0};}
        if self.cached_restricted!=restricted {self.cached_restricted=restricted;self.refresh_remaining=20;}
        if self.initialized_bits&4==0 {self.initialized_bits|=4;self.configured_enabled=read_enabled;}
        self.refresh_remaining
    }
    /// Native6B4526 decrements before processing the queued sources.
    pub fn after_source_selection(&mut self) {if self.refresh_remaining>0 {self.refresh_remaining-=1;}}
}
pub fn cycle_native_selection(value:i32)->i32 {match value {-1=>0,0=>1,1=>-2,-2=>0,_=>value}}
#[cfg(test)] mod tests {
    use super::*;
    use crate::{fow_source_factory::*,fow_regions::StencilRegion,fow_entity_registry::EntityRegistry,fow_player_filter::PlayerViewActor,fow_registered_filter::ActorFilter};
    use std::collections::BTreeMap;
    #[test] fn shared_refresh_initialization_transitions_and_selector_match_original() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_view_refresh_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),144);
        for c in proof["cases"].as_array().unwrap() {
            let mut state=SharedViewState {initialized_bits:c["initial_bits"].as_u64().unwrap() as u32,cached_restricted:c["initial_cached"].as_bool().unwrap(),refresh_remaining:c["initial_remaining"].as_i64().unwrap() as i32,configured_enabled:true};
            let registrations:BTreeMap<u32,u32>=(0..3).map(|i|(55+i,0x12340000+i)).collect();
            let actors:BTreeMap<u32,PlayerViewActor>=(0..3).map(|i|(0x12340000+i,PlayerViewActor {descriptor_identity:66,filter:ActorFilter {team_tag:100,flag_ad:true,flag_118:false,descriptor_24:true,descriptor_2c:false}})).collect();
            let registry=EntityRegistry {registrations:&registrations,actors:&actors};
            let mut factory=CircleFactory::default();let mut view=CircleView::new(8).unwrap();let mut references=Vec::new();
            for (i,center) in [[0.,0.],[1000.,0.],[10000.,10000.]].into_iter().enumerate() {
                references.push(factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:None,center,radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.}));
            }
            for frame in c["frames"].as_array().unwrap() {
                let restricted=frame["restricted"].as_bool().unwrap();let counter=state.begin_update(Some(if restricted {0x800}else{0}),true);
                let native=&frame["before_processing"];
                assert_eq!(counter as u32,native["refresh_before"].as_u64().unwrap() as u32);
                assert_eq!(state.cached_restricted,native["cached_restricted"].as_bool().unwrap());assert_eq!(state.initialized_bits,native["init_bits"].as_u64().unwrap() as u32);
                view.layer.counts.fill(0);view.layer.pixels.fill(0);
                for reference in &references {
                    let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                    if let Some(region)=source.region.as_mut() {region.applied=false;}
                    source.apply_to_layer(&mut view.layer,StencilRegion {words:vec![0x55555555;2],rect:[1,2,5,6],applied:false}).unwrap();source.parameters.generation_dirty=false;
                    if view.select_player_source(&mut source,100,if restricted {Some(66)}else{None},&registry).unwrap() {view.enqueue_update(reference,&mut source,false,counter,[0.,0.],15398.671875,5.001,&[]).unwrap();}
                }
                assert_eq!(view.pending.entries().len(),native["pending"].as_array().unwrap().len());
                assert_eq!(view.layer.counts,native["counts"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>());
                for (i,reference) in references.iter().enumerate() {let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();assert_eq!(source.applied(),native["applied_flags"][i].as_bool().unwrap());assert_eq!(source.pending,native["pending_flags"][i].as_bool().unwrap());}
                for (entry,expected) in view.pending.entries().iter().zip(native["pending"].as_array().unwrap()) {assert_eq!(references.iter().position(|r|r.as_ptr() as usize==entry.source).unwrap(),expected["identity"].as_u64().unwrap() as usize);assert!((f32::from_bits(entry.priority_bits)-f32::from_bits(expected["priority_bits"].as_u64().unwrap() as u32)).abs()<=0.000001);}
                state.after_source_selection();assert_eq!(state.refresh_remaining as u32,frame["refresh_after"].as_u64().unwrap() as u32);
                let mut generated=Vec::new();view.process_frame(&factory,3.,|source,_| {generated.push(source.opaque_ids[0]-55);Ok(())}).unwrap();
                assert_eq!(generated,frame["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
            }
        }
        assert_eq!(proof["selection_cases"].as_array().unwrap().len(),8);
        for c in proof["selection_cases"].as_array().unwrap() {let mut value=c["initial"].as_i64().unwrap() as i32;for expected in c["values"].as_array().unwrap() {value=cycle_native_selection(value);assert_eq!(value,expected.as_i64().unwrap() as i32);}}
    }
}
