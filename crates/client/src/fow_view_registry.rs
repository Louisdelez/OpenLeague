//! Native6B3B80 construction and existing-event66D460 subscription semantics.
//! Dispatcher creation, view destruction and GPU texture initialization remain open.
use std::sync::{Arc,Mutex,Weak};
use crate::fow_source_factory::{CircleView,CircleFactory,CircleSource};
pub struct RegisteredView {
    pub extent:f32,
    pub circle:CircleView,
    // Native6B2D10 allocates512 words without initializing their contents.
    pub scratch_word_capacity:usize,
    pub scratch_initialized:bool,
    pub scratch_applied:bool,
    pub scratch_dirty:bool,
    pub scratch_rect:[usize;4],
}
#[derive(Default)]
pub struct ViewRegistry {views:Vec<Weak<Mutex<RegisteredView>>>,event_initialized:bool}
pub struct Retirement {pub removed:bool,pub callbacks:usize,pub remaining_applied:Option<bool>}
impl ViewRegistry {
    pub fn construct(&mut self,extent:f32)->Result<Arc<Mutex<RegisteredView>>,&'static str> {
        if !extent.is_finite() || extent<=0. {return Err("unqualified native view extent");}
        let view=Arc::new(Mutex::new(RegisteredView {extent,circle:CircleView::new(128)?,scratch_word_capacity:512,scratch_initialized:false,scratch_applied:false,scratch_dirty:true,scratch_rect:[0;4]}));
        self.event_initialized=true;self.views.push(Arc::downgrade(&view));Ok(view)
    }
    pub fn subscription_count(&self)->usize {self.views.len()}
    pub fn event_count(&self)->usize {usize::from(self.event_initialized)}
    /// Manager ownership remains alive while registered view callbacks run.
    pub fn retire_source(&mut self,factory:&mut CircleFactory,reference:&Weak<Mutex<CircleSource>>)->Result<Retirement,&'static str> {
        self.retire_source_observed(factory,reference,|_|{})
    }
    /// Callback-entry observer supports native ordering diagnostics without retaining views.
    pub fn retire_source_observed(&mut self,factory:&mut CircleFactory,reference:&Weak<Mutex<CircleSource>>,mut observe:impl FnMut(usize))->Result<Retirement,&'static str> {
        let mut callbacks=0;let mut remaining_applied=None;
        let removed=factory.retire(reference,|source| {
            let mut index=0;
            while index<self.views.len() {
                if let Some(view)=self.views[index].upgrade() {
                    observe(Arc::as_ptr(&view) as usize);
                    view.lock().map_err(|_|"poisoned registered fog view")?.circle.retire(reference,source)?;callbacks+=1;index+=1;
                }else{
                    // Native dispatcher erases expired subscriptions during event delivery.
                    self.views.remove(index);
                }
            }
            remaining_applied=Some(source.applied());
            Ok(())
        })?;
        Ok(Retirement {removed,callbacks,remaining_applied})
    }
}
#[cfg(test)] mod tests {
    use super::*;
    use crate::{fow_source_factory::Inputs,fow_regions::StencilRegion};
    #[test] fn constructed_view_subscription_retires_source_like_original_constructor() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_view_constructor_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),2);
        for c in proof["cases"].as_array().unwrap() {
            let mut registry=ViewRegistry::default();let view=registry.construct(c["extent"].as_f64().unwrap() as f32).unwrap();
            assert_eq!(registry.subscription_count(),c["subscriber_count"].as_u64().unwrap() as usize);
            assert_eq!(Arc::strong_count(&view),c["self_control_strong"].as_u64().unwrap() as usize);
            assert_eq!(Arc::weak_count(&view)+1,c["self_control_weak"].as_u64().unwrap() as usize);
            {let view=view.lock().unwrap();assert_eq!(view.circle.layer.dimension(),c["dimension"].as_u64().unwrap() as usize);assert_eq!(view.extent.to_bits(),c["extent_bits"].as_u64().unwrap() as u32);
                assert!(view.circle.layer.counts.iter().all(|v|*v==0));assert!(view.circle.layer.pixels.iter().all(|v|*v==0));assert!(view.circle.pending.entries().is_empty());assert_eq!(view.circle.budget.smoothed_delta.to_bits(),c["initialized_words"]["0x4c"].as_u64().unwrap() as u32);
                assert_eq!(view.scratch_word_capacity,c["initialized_words"]["0x28"].as_u64().unwrap() as usize);assert!(!view.scratch_initialized);assert!(!view.scratch_applied);assert!(view.scratch_dirty);assert_eq!(view.scratch_rect,[0;4]);}
            let mut factory=CircleFactory::default();let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55,66],owner_tag:100,owner:None,center:[128.,128.],radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
            {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();let mut view=view.lock().unwrap();source.apply_to_layer(&mut view.circle.layer,StencilRegion {words:vec![0x55555555;512],rect:[1,2,5,6],applied:false}).unwrap();assert!(view.circle.layer.counts.iter().any(|v|*v!=0));}
            let report=registry.retire_source(&mut factory,&reference).unwrap();assert!(report.removed);assert_eq!(report.callbacks,c["callbacks"].as_u64().unwrap() as usize);
            assert_eq!(factory.source_count(),0);assert!(reference.upgrade().is_none());let view=view.lock().unwrap();assert!(view.circle.layer.counts.iter().all(|v|*v==0));assert!(view.circle.layer.pixels.iter().all(|v|*v==0));
        }
    }
}

#[cfg(test)] mod destruction_tests {
    use super::*;
    use crate::{fow_source_factory::Inputs,fow_regions::StencilRegion};
    #[test] fn expired_view_is_not_called_and_subscription_is_pruned_on_original_dispatch() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_view_destruction_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),4);
        for c in proof["cases"].as_array().unwrap() {
            let mut registry=ViewRegistry::default();let view=registry.construct(c["extent"].as_f64().unwrap() as f32).unwrap();
            let mut factory=CircleFactory::default();let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55,66],owner_tag:100,owner:None,center:[128.,128.],radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
            {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();let mut view=view.lock().unwrap();source.apply_to_layer(&mut view.circle.layer,StencilRegion {words:vec![0x55555555;512],rect:[1,2,5,6],applied:false}).unwrap();}
            let view=if c["destroy_first"].as_bool().unwrap() {drop(view);assert_eq!(registry.views[0].strong_count(),c["self_control_strong_after"].as_u64().unwrap() as usize);assert!(registry.views[0].upgrade().is_none());None}else{Some(view)};
            assert_eq!(registry.subscription_count(),1); // Expiration alone does not erase the event slot.
            let report=registry.retire_source(&mut factory,&reference).unwrap();
            assert!(report.removed);assert_eq!(report.callbacks,c["callbacks"].as_u64().unwrap() as usize);assert_eq!(report.remaining_applied,Some(c["source_applied_after_removal"].as_bool().unwrap()));
            assert_eq!(registry.subscription_count(),c["subscriber_count_after"].as_u64().unwrap() as usize);assert!(reference.upgrade().is_none());
            if let Some(view)=view {let view=view.lock().unwrap();assert!(view.circle.layer.counts.iter().all(|v|*v==0));assert!(view.circle.layer.pixels.iter().all(|v|*v==0));}
        }
    }
}

#[cfg(test)] mod event_creation_tests {
    use super::*;
    use crate::{fow_source_factory::Inputs,fow_regions::StencilRegion};
    #[test] fn empty_dispatcher_creates_retirement_event_and_delivers_original_callback() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_event_creation_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),2);
        for c in proof["cases"].as_array().unwrap() {
            let mut registry=ViewRegistry::default();assert_eq!(registry.event_count(),0);let view=registry.construct(c["extent"].as_f64().unwrap() as f32).unwrap();
            assert_eq!(registry.event_count(),c["event_count"].as_u64().unwrap() as usize);
            assert_eq!(registry.subscription_count(),c["subscriber_count"].as_u64().unwrap() as usize);
            assert_eq!(Arc::strong_count(&view),c["self_control_strong"].as_u64().unwrap() as usize);
            assert_eq!(Arc::weak_count(&view)+1,c["self_control_weak"].as_u64().unwrap() as usize);
            {let view=view.lock().unwrap();assert_eq!(view.circle.layer.dimension(),c["dimension"].as_u64().unwrap() as usize);assert_eq!(view.extent.to_bits(),c["extent_bits"].as_u64().unwrap() as u32);
                assert!(view.circle.layer.counts.iter().all(|v|*v==0));assert!(view.circle.layer.pixels.iter().all(|v|*v==0));assert!(view.circle.pending.entries().is_empty());assert_eq!(view.circle.budget.smoothed_delta.to_bits(),c["initialized_words"]["0x4c"].as_u64().unwrap() as u32);
                assert_eq!(view.scratch_word_capacity,c["initialized_words"]["0x28"].as_u64().unwrap() as usize);assert!(!view.scratch_initialized);assert!(!view.scratch_applied);assert!(view.scratch_dirty);assert_eq!(view.scratch_rect,[0;4]);}
            let mut factory=CircleFactory::default();let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55,66],owner_tag:100,owner:None,center:[128.,128.],radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
            {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();let mut view=view.lock().unwrap();source.apply_to_layer(&mut view.circle.layer,StencilRegion {words:vec![0x55555555;512],rect:[1,2,5,6],applied:false}).unwrap();assert!(view.circle.layer.counts.iter().any(|v|*v!=0));}
            let report=registry.retire_source(&mut factory,&reference).unwrap();assert!(report.removed);assert_eq!(report.callbacks,c["callbacks"].as_u64().unwrap() as usize);
            assert_eq!(factory.source_count(),0);assert!(reference.upgrade().is_none());let view=view.lock().unwrap();assert!(view.circle.layer.counts.iter().all(|v|*v==0));assert!(view.circle.layer.pixels.iter().all(|v|*v==0));
        }
    }
}


#[cfg(test)] mod multiple_view_tests {
    use super::*;
    use crate::fow_source_factory::Inputs;
    #[test] fn growth_expiration_order_and_pending_cleanup_match_34_original_sequences() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_multiple_views_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),34);
        for c in proof["cases"].as_array().unwrap() {
            let mut registry=ViewRegistry::default();let count=c["view_count"].as_u64().unwrap() as usize;
            let mut views:Vec<Option<Arc<Mutex<RegisteredView>>>>=(0..count).map(|_|Some(registry.construct(15398.671875).unwrap())).collect();
            let identities:Vec<usize>=views.iter().map(|view|Arc::as_ptr(view.as_ref().unwrap()) as usize).collect();
            assert_eq!(registry.event_count(),1);assert_eq!(registry.subscription_count(),c["initial_subscribers"].as_u64().unwrap() as usize);
            let mut factory=CircleFactory::default();let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55,66],owner_tag:100,owner:None,center:[128.,128.],radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
            for (i,view) in views.iter_mut().enumerate() {
                if c["pending"].as_bool().unwrap() {view.as_ref().unwrap().lock().unwrap().circle.enqueue(&reference,0x3f800000);}
                if c["expired_mask"].as_u64().unwrap()&(1<<i)!=0 {view.take();}
            }
            assert_eq!(registry.subscription_count(),count);
            let mut order=Vec::new();let report=registry.retire_source_observed(&mut factory,&reference,|identity|order.push(identities.iter().position(|v|*v==identity).unwrap())).unwrap();
            assert!(report.removed);assert_eq!(report.callbacks,c["callback_order"].as_array().unwrap().len());assert_eq!(order,c["callback_order"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect::<Vec<_>>());
            assert_eq!(registry.subscription_count(),c["subscriber_count_after"].as_u64().unwrap() as usize);assert_eq!(registry.event_count(),c["event_count"].as_u64().unwrap() as usize);
            for (i,view) in views.iter().enumerate() {if let Some(view)=view {assert_eq!(view.lock().unwrap().circle.pending.entries().len(),c["pending_counts_after"][i].as_u64().unwrap() as usize);}}
            assert_eq!(factory.source_count(),0);assert!(reference.upgrade().is_none());
        }
    }
}
