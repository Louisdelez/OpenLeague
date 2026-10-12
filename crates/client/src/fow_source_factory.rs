//! Native 6B0790 initialized fields and 6B1B20 circular factory ownership.
//! Qualified for a null weak-provider input; caller identity/team producers remain open.
use std::sync::{Arc,Mutex,Weak};
use crate::{fow_position::SourcePosition,fow_source_update::Parameters,fow_regions::StencilRegion};
pub struct CachedOwner {pub key:u64,pub handle:u32}
pub struct Inputs {
    pub opaque_ids:[u32;2],
    pub owner_tag:u32,
    pub owner:Option<CachedOwner>,
    pub center:[f32;2],
    pub radius:f32,
    pub secondary_metric:f32,
    pub source_metric:f32,
    pub lifetime:f32,
}
pub struct ActorWeakAnchor {pub key:u64}
pub struct AiCreationFlags {pub stamp:u32,pub flag64:u8,pub flag65:u8,pub flag66:u8,pub obstruction:bool}
pub struct CircleSource {
    pub provider:Option<Weak<ActorWeakAnchor>>,
    pub ai_creation_flags:Option<AiCreationFlags>,
    pub opaque_ids:[u32;2],
    pub owner_tag:u32,
    pub position:SourcePosition,
    pub parameters:Parameters,
    pub region:Option<StencilRegion>,
    pub pending:bool,
}
impl CircleSource {
    pub fn new_without_weak_provider(input:Inputs)->Self {
        let (cached_owner,owner_handle)=input.owner.map(|o|(Some(o.key),o.handle)).unwrap_or((None,0));
        Self {provider:None,ai_creation_flags:None,opaque_ids:input.opaque_ids,owner_tag:input.owner_tag,
            position:SourcePosition {center:input.center,cached_owner,owner_handle,remaining_lifetime:input.lifetime},
            parameters:Parameters {radius:input.radius,secondary_metric:input.secondary_metric,source_metric:input.source_metric,scale:1.,bias:0.,generation_dirty:true},
            region:None,pending:false}
    }
    /// Default native circular source starts with terrain obstruction checks enabled.
    pub fn stencil(&self,dimension:usize,extent:f32,terrain:&crate::fow_terrain_ray::TerrainGrid<'_>,owners:&[Option<crate::fow_owner::Owner>])->Result<StencilRegion,&'static str> {
        let reference=crate::fow_owner::Reference {handle:self.position.owner_handle,cached_key:self.position.cached_owner.unwrap_or(0),owner_tag:self.owner_tag};
        crate::fow_occluded::owned_circle_stencil(&self.parameters.circle(self.position.center),dimension,extent,self.parameters.source_metric,terrain,&reference,owners)
    }
    pub fn apply_to_layer(&mut self,layer:&mut crate::fow_regions::CountedLayer,mut mask:StencilRegion)->Result<(),&'static str> {
        layer.replace_external(self.region.as_mut(),&mut mask)?;
        self.region=Some(mask);
        Ok(())
    }
    pub fn withdraw_from(&mut self,layer:&mut crate::fow_regions::CountedLayer)->Result<bool,&'static str> {
        let Some(mask)=self.region.as_mut() else {return Ok(false);};
        layer.retire_external(mask)
    }
    pub fn applied(&self)->bool {self.region.as_ref().is_some_and(|region|region.applied)}
}
#[derive(Default)]
pub struct CircleFactory {sources:Vec<Arc<Mutex<CircleSource>>>}
impl CircleFactory {
    /// Manager retains the strong owner; consumers receive a weak source reference.
    pub fn source_count(&self)->usize {self.sources.len()}
    /// Native 6B1F90 notifies listeners before erasing the last manager owner.
    pub fn retire(&mut self,reference:&Weak<Mutex<CircleSource>>,mut notify:impl FnMut(&mut CircleSource)->Result<(),&'static str>)->Result<bool,&'static str> {
        let Some(index)=self.sources.iter().position(|source|reference.ptr_eq(&Arc::downgrade(source))) else {return Ok(false);};
        {
            let mut source=self.sources[index].lock().map_err(|_|"poisoned fog source")?;
            notify(&mut source)?;
        }
        self.sources.remove(index);
        Ok(true)
    }
    pub fn create_without_weak_provider(&mut self,input:Inputs)->Weak<Mutex<CircleSource>> {
        let source=Arc::new(Mutex::new(CircleSource::new_without_weak_provider(input)));
        let reference=Arc::downgrade(&source);self.sources.push(source);reference
    }
}
#[cfg(test)] mod tests {
    use super::*;
    fn input(tag:u32,lifetime:f32,has_owner:bool,radius:f32)->Inputs {
        Inputs {opaque_ids:[55,66],owner_tag:tag,owner:if has_owner {Some(CachedOwner {key:17,handle:0x12340002})}else{None},center:[7684.,6934.],radius,secondary_metric:128.,source_metric:64.,lifetime}
    }
    #[test] fn initialized_fields_match_complete_native_base_constructor() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_source_constructor_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),24);
        for c in proof["cases"].as_array().unwrap() {
            let source=CircleSource::new_without_weak_provider(input(c["team_tag"].as_u64().unwrap() as u32,c["lifetime"].as_f64().unwrap() as f32,c["has_owner"].as_bool().unwrap(),c["radius"].as_f64().unwrap() as f32));
            let words=[("0x4",source.position.center[0].to_bits()),("0x8",source.position.center[1].to_bits()),("0xc",source.parameters.radius.to_bits()),("0x10",source.parameters.secondary_metric.to_bits()),("0x14",source.parameters.source_metric.to_bits()),("0x18",source.parameters.scale.to_bits()),("0x1c",source.parameters.bias.to_bits()),("0x20",source.position.remaining_lifetime.to_bits()),("0x24",source.position.owner_handle),("0x28",source.opaque_ids[0]),("0x2c",source.opaque_ids[1]),("0x30",source.owner_tag)];
            for (offset,bits) in words {assert_eq!(bits,c["result_words"][offset].as_u64().unwrap() as u32,"constructor {offset} {c}");}
            for offset in ["0x38","0x3c","0x40","0x48","0x4c","0x50","0x54","0x58"] {assert_eq!(c["result_words"][offset],0);}
            assert!(source.region.is_none());assert_eq!(source.position.cached_owner.is_some(),c["cached_owner"].as_bool().unwrap());
            assert_eq!(source.applied(),c["applied"].as_bool().unwrap());assert_eq!(source.parameters.generation_dirty,c["generation_dirty"].as_bool().unwrap());assert_eq!(source.pending,c["pending"].as_bool().unwrap());
        }
    }
    #[test] fn manager_and_returned_reference_match_original_circle_factory() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_circle_factory_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),24);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();
            let reference=factory.create_without_weak_provider(input(c["owner_tag"].as_u64().unwrap() as u32,c["lifetime"].as_f64().unwrap() as f32,c["has_owner"].as_bool().unwrap(),c["radius"].as_f64().unwrap() as f32));
            assert_eq!(factory.sources.len(),c["manager_source_count"].as_u64().unwrap() as usize);
            assert_eq!(Weak::strong_count(&reference),c["strong_count"].as_u64().unwrap() as usize);
            // Native weak count includes the implicit weak reference held by strong owners.
            assert_eq!(Weak::weak_count(&reference)+1,c["weak_count"].as_u64().unwrap() as usize);
            let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();
            assert_eq!(source.position.owner_handle,c["source_handle"].as_u64().unwrap() as u32);assert_eq!(source.owner_tag,c["source_tag"].as_u64().unwrap() as u32);
            assert_eq!(source.applied(),c["applied"].as_bool().unwrap());assert_eq!(source.parameters.generation_dirty,c["generation_dirty"].as_bool().unwrap());
        }
    }
}

#[cfg(test)] mod mask_integration_tests {
    use super::*;
    #[test] fn factory_sources_feed_original_map10_owned_masks_and_count_layer() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_owned_contract.json")).unwrap();
        let metadata=&proof["terrain"];let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=crate::fow_terrain_ray::TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        assert_eq!(proof["cases"].as_array().unwrap().len(),24);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();let handle=0x12340002;
            let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55,66],owner_tag:7,owner:Some(CachedOwner {key:17,handle}),center:std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32),radius:c["radius"].as_f64().unwrap() as f32,secondary_metric:128.,source_metric:c["source_metric"].as_f64().unwrap() as f32,lifetime:0.});
            let mut owners:Vec<Option<crate::fow_owner::Owner>>=(0..4).map(|_|None).collect();
            owners[2]=Some(crate::fow_owner::Owner {key:17,handle,owner_tag:if c["owner_valid"].as_bool().unwrap() {7}else{8},percent:c["owner_percent"].as_f64().unwrap() as f32,flat:c["owner_flat"].as_f64().unwrap() as f32});
            let n=c["dimension"].as_u64().unwrap() as usize;
            let source=reference.upgrade().unwrap();let mut source=source.lock().unwrap();
            let mask=source.stencil(n,c["extent"].as_f64().unwrap() as f32,&terrain,&owners).unwrap();
            let words:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
            assert_eq!(mask.words,words,"created Map10 source {c}");
            assert_eq!(mask.rect,std::array::from_fn(|i|c["rect"][i].as_u64().unwrap() as usize));
            let mut layer=crate::fow_regions::CountedLayer::new(n).unwrap();source.apply_to_layer(&mut layer,mask).unwrap();assert!(source.applied());
            for z in 0..n {for x in 0..n {let i=z*n+x;let selected=words[i/32]&(1<<(i%32))!=0;assert_eq!(layer.counts[i],u8::from(selected));assert_eq!(layer.pixels[(n-z-1)*n+x],if selected {255}else{0});}}
            assert!(source.withdraw_from(&mut layer).unwrap());assert!(!source.applied());assert!(layer.counts.iter().all(|v|*v==0));assert!(layer.pixels.iter().all(|v|*v==0));
        }
    }
}

#[cfg(test)] mod release_tests {
    use super::*;
    #[test] fn synchronous_notification_rollback_and_weak_expiration_match_original_release() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_source_release_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),12);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();
            let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55,66],owner_tag:100,owner:None,center:[128.,128.],radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
            assert_eq!(reference.strong_count(),c["before_strong"].as_u64().unwrap() as usize);
            assert_eq!(reference.weak_count()+1,c["before_weak"].as_u64().unwrap() as usize);
            {
                let source=reference.upgrade().unwrap();let mut source=source.lock().unwrap();
                source.region=Some(StencilRegion {words:vec![0x55555555;2],rect:[1,2,5,6],applied:c["initial_applied"].as_bool().unwrap()});
            }
            let mut layer=crate::fow_regions::CountedLayer::new(8).unwrap();layer.counts.fill(c["initial_count"].as_u64().unwrap() as u8);layer.pixels.fill(90);
            let observer=c["observer"].as_bool().unwrap();let mut callbacks=0;let mut applied_after=false;
            assert!(factory.retire(&reference,|source| {
                if observer {
                    let native_callback=c["trace"].as_array().unwrap().iter().find(|event|event["kind"]=="callback").unwrap();
                    assert_eq!(reference.strong_count(),native_callback["strong"].as_u64().unwrap() as usize);
                    assert_eq!(source.applied(),native_callback["applied"].as_bool().unwrap());
                    source.withdraw_from(&mut layer)?;callbacks+=1;
                }
                applied_after=source.applied();Ok(())
            }).unwrap());
            assert_eq!(callbacks,usize::from(observer));assert_eq!(applied_after,c["applied_after"].as_bool().unwrap());
            assert_eq!(factory.source_count(),c["manager_source_count"].as_u64().unwrap() as usize);
            assert_eq!(reference.strong_count(),c["after_strong"].as_u64().unwrap() as usize);
            assert_eq!(reference.upgrade().is_none(),c["weak_expired"].as_bool().unwrap());
            for cell in c["changes"].as_array().unwrap() {
                assert_eq!(layer.counts[cell["index"].as_u64().unwrap() as usize],cell["count"].as_u64().unwrap() as u8,"release count {c}");
                assert_eq!(layer.pixels[cell["texture_index"].as_u64().unwrap() as usize],cell["visibility"].as_u64().unwrap() as u8,"release visibility {c}");
            }
            if observer {
                let trace=c["trace"].as_array().unwrap();
                let callback=trace.iter().position(|event|event["kind"]=="callback").unwrap();
                let source_free=trace.iter().position(|event|event["kind"]=="free" && event["source"]==true).unwrap();
                assert!(callback<source_free);
            }
            assert!(!factory.retire(&reference,|_|panic!("expired source must not notify twice")).unwrap());
        }
    }
}


#[cfg(test)] mod multi_release_tests {
    use super::*;
    #[test] fn multiple_sources_and_repeated_observers_match_native_sequences() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_multi_source_release_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),36);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();
            let mut references=Vec::new();
            let mut layer=crate::fow_regions::CountedLayer::new(8).unwrap();
            for i in 0..3 {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:None,center:[128.,128.],radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
                let definition=&proof["definitions"][i];
                let mask=StencilRegion {words:vec![definition["word"].as_u64().unwrap() as u32;2],rect:std::array::from_fn(|j|definition["rect"][j].as_u64().unwrap() as usize),applied:false};
                {
                    let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                    if c["initial_applied"].as_bool().unwrap() {source.apply_to_layer(&mut layer,mask).unwrap();}
                    else {source.region=Some(mask);}
                }
                references.push(reference);
            }
            let bytes=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as u8).collect::<Vec<_>>();
            assert_eq!(layer.counts,bytes(&c["initial_counts"]));assert_eq!(layer.pixels,bytes(&c["initial_pixels"]));
            for step in c["steps"].as_array().unwrap() {
                let identity=step["removed"].as_u64().unwrap() as usize;let reference=&references[identity];
                let mut callback_count=0;
                assert!(factory.retire(reference,|source| {
                    for expected in step["callbacks"].as_array().unwrap() {
                        assert_eq!(reference.strong_count(),expected["strong"].as_u64().unwrap() as usize);
                        assert_eq!(source.applied(),expected["applied"].as_bool().unwrap());
                        source.withdraw_from(&mut layer)?;callback_count+=1;
                    }
                    Ok(())
                }).unwrap());
                assert_eq!(callback_count,c["observers"].as_u64().unwrap() as usize);
                let order:Vec<usize>=factory.sources.iter().map(|source|references.iter().position(|weak|weak.ptr_eq(&Arc::downgrade(source))).unwrap()).collect();
                let expected_order:Vec<usize>=step["remaining_order"].as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as usize).collect();
                assert_eq!(order,expected_order,"manager compaction {c}");
                assert_eq!(layer.counts,bytes(&step["counts"]),"counts {c}");assert_eq!(layer.pixels,bytes(&step["pixels"]),"pixels {c}");
                assert_eq!(reference.strong_count(),step["strong_after"].as_u64().unwrap() as usize);
                assert!(reference.upgrade().is_none());
                for i in order {assert_eq!(references[i].strong_count(),1);assert!(references[i].upgrade().is_some());}
                assert!(!factory.retire(reference,|_|panic!("retired source must not notify twice")).unwrap());
            }
            assert_eq!(factory.source_count(),0);
            if c["observers"].as_u64().unwrap()>0 {assert!(layer.counts.iter().all(|v|*v==0));assert!(layer.pixels.iter().all(|v|*v==0));}
        }
    }
}

/// Qualified native view callback: retire count region, then purge/rebuild pending heap.
/// Full view initialization/registration and live source scheduling remain separate.
pub struct CircleView {
    pub budget:crate::fow_schedule::FrameBudget,
    pub layer:crate::fow_regions::CountedLayer,
    pub pending:crate::fow_pending::PendingSources,
}
impl CircleView {
    pub fn new(dimension:usize)->Result<Self,&'static str> {Ok(Self {budget:Default::default(),layer:crate::fow_regions::CountedLayer::new(dimension)?,pending:Default::default()})}
    pub fn enqueue(&mut self,reference:&Weak<Mutex<CircleSource>>,priority_bits:u32) {
        self.pending.push(crate::fow_pending::Entry {source:reference.as_ptr() as usize,priority_bits});
    }
    pub fn retire(&mut self,reference:&Weak<Mutex<CircleSource>>,source:&mut CircleSource)->Result<(),&'static str> {
        source.withdraw_from(&mut self.layer)?;
        self.pending.retire(reference.as_ptr() as usize);Ok(())
    }
}
#[cfg(test)] mod pending_view_tests {
    use super::*;
    #[test] fn source_view_mask_and_pending_heap_match_native_removal() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_pending_release_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),192);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();
            let mut references=Vec::new();
            let mut view=CircleView::new(8).unwrap();
            for i in 0..3 {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:None,center:[128.,128.],radius:200.,secondary_metric:128.,source_metric:64.,lifetime:0.});
                let definition=&proof["definitions"][i];
                let mask=StencilRegion {words:vec![definition["word"].as_u64().unwrap() as u32;2],rect:std::array::from_fn(|j|definition["rect"][j].as_u64().unwrap() as usize),applied:false};
                {
                    let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                    if c["initial_applied"].as_bool().unwrap() {source.apply_to_layer(&mut view.layer,mask).unwrap();}
                    else {source.region=Some(mask);}
                }
                references.push(reference);
            }
            for value in c["pattern"].as_array().unwrap() {
                let i=value.as_u64().unwrap() as usize;
                view.enqueue(&references[i],c["priorities"][i].as_u64().unwrap() as u32);
            }
            let check_pending=|view:&CircleView,expected:&serde_json::Value| {
                let actual:Vec<(usize,u32)>=view.pending.entries().iter().map(|entry|(references.iter().position(|weak|weak.as_ptr() as usize==entry.source).unwrap(),entry.priority_bits)).collect();
                let expected:Vec<(usize,u32)>=expected.as_array().unwrap().iter().map(|v|(v["identity"].as_u64().unwrap() as usize,v["priority_bits"].as_u64().unwrap() as u32)).collect();
                assert_eq!(actual,expected,"pending heap {c}");
            };
            check_pending(&view,&c["initial_pending"]);
            let bytes=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as u8).collect::<Vec<_>>();
            assert_eq!(view.layer.counts,bytes(&c["initial_counts"]));assert_eq!(view.layer.pixels,bytes(&c["initial_pixels"]));
            for step in c["steps"].as_array().unwrap() {
                let identity=step["removed"].as_u64().unwrap() as usize;let reference=&references[identity];
                let mut callback_count=0;
                assert!(factory.retire(reference,|source| {
                    for expected in step["callbacks"].as_array().unwrap() {
                        assert_eq!(reference.strong_count(),expected["strong"].as_u64().unwrap() as usize);
                        assert_eq!(source.applied(),expected["applied"].as_bool().unwrap());
                        view.retire(reference,source)?;callback_count+=1;
                    }
                    Ok(())
                }).unwrap());
                check_pending(&view,&step["pending"]);
                assert_eq!(callback_count,c["observers"].as_u64().unwrap() as usize);
                let order:Vec<usize>=factory.sources.iter().map(|source|references.iter().position(|weak|weak.ptr_eq(&Arc::downgrade(source))).unwrap()).collect();
                let expected_order:Vec<usize>=step["remaining_order"].as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as usize).collect();
                assert_eq!(order,expected_order,"manager compaction {c}");
                assert_eq!(view.layer.counts,bytes(&step["counts"]),"counts {c}");assert_eq!(view.layer.pixels,bytes(&step["pixels"]),"pixels {c}");
                assert_eq!(reference.strong_count(),step["strong_after"].as_u64().unwrap() as usize);
                assert!(reference.upgrade().is_none());
                for i in order {assert_eq!(references[i].strong_count(),1);assert!(references[i].upgrade().is_some());}
                assert!(!factory.retire(reference,|_|panic!("retired source must not notify twice")).unwrap());
            }
            assert_eq!(factory.source_count(),0);
            if c["observers"].as_u64().unwrap()>0 {assert!(view.layer.counts.iter().all(|v|*v==0));assert!(view.layer.pixels.iter().all(|v|*v==0));}
        }
    }
}


impl CircleView {
    pub fn enqueue_update(&mut self,reference:&Weak<Mutex<CircleSource>>,source:&mut CircleSource,force:bool,refresh_frames:i32,camera:[f32;2],extent:f32,now:f32,owners:&[Option<crate::fow_owner::Owner>])->Result<bool,&'static str> {
        if !crate::fow_schedule::needs_update(force,refresh_frames,source.parameters.generation_dirty,source.applied(),source.pending) {return Ok(false);}
        let owner=crate::fow_owner::Reference {handle:source.position.owner_handle,cached_key:source.position.cached_owner.unwrap_or(0),owner_tag:source.owner_tag};
        let modifiers=crate::fow_owner::modifiers([source.parameters.scale,source.parameters.bias],&owner,owners)?;
        let radius=f64::from(source.parameters.radius)*f64::from(modifiers[0])+f64::from(modifiers[1]);
        let priority=crate::fow_schedule::priority(source.position.center,camera,radius,extent,now)?;
        self.enqueue(reference,priority.to_bits());source.pending=true;Ok(true)
    }
    /// Caller supplies the qualified generator; sources stay queued if generation errors.
    pub fn process_frame(&mut self,factory:&CircleFactory,delta:f32,mut generate:impl FnMut(&mut CircleSource,&mut crate::fow_regions::CountedLayer)->Result<(),&'static str>)->Result<usize,&'static str> {
        let count=self.budget.work_count(delta,self.pending.entries().len())?;
        for _ in 0..count {
            let identity=self.pending.entries()[0].source;
            let source=factory.sources.iter().find(|source|Arc::as_ptr(source) as usize==identity).ok_or("expired source remained in fog pending heap")?.clone();
            let mut source=source.lock().map_err(|_|"poisoned fog source")?;
            source.withdraw_from(&mut self.layer)?;
            generate(&mut source,&mut self.layer)?;
            source.pending=false;self.pending.pop();
        }
        Ok(count)
    }
}
#[cfg(test)] mod schedule_view_tests {
    use super::*;
    #[test] fn source_view_enqueue_and_frame_processing_match_original_schedule() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_frame_schedule_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),576);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();let mut view=CircleView::new(8).unwrap();let mut references=Vec::new();
            for (i,center) in [[0.,0.],[1000.,0.],[10000.,10000.]].into_iter().enumerate() {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:None,center,radius:c["radius"].as_f64().unwrap() as f32,secondary_metric:128.,source_metric:64.,lifetime:0.});
                {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                    source.parameters.generation_dirty=c["dirty"].as_bool().unwrap();
                    if c["initial_applied"].as_bool().unwrap() {source.apply_to_layer(&mut view.layer,StencilRegion {words:vec![0x55555555;2],rect:[1,2,5,6],applied:false}).unwrap();}
                    view.enqueue_update(&reference,&mut source,c["force"].as_bool().unwrap(),0,[0.,0.],15398.671875,c["now"].as_f64().unwrap() as f32,&[]).unwrap();
                }references.push(reference);
            }
            let compare=|view:&CircleView,expected:&serde_json::Value| {
                assert_eq!(view.pending.entries().len(),expected.as_array().unwrap().len());
                for (entry,native) in view.pending.entries().iter().zip(expected.as_array().unwrap()) {
                    let identity=references.iter().position(|weak|weak.as_ptr() as usize==entry.source).unwrap();
                    assert_eq!(identity,native["identity"].as_u64().unwrap() as usize);
                    assert!((f32::from_bits(entry.priority_bits)-f32::from_bits(native["priority_bits"].as_u64().unwrap() as u32)).abs()<=0.000001);
                }
            };
            compare(&view,&c["before_processing"]["pending"]);
            view.budget.smoothed_delta=c["previous_delta"].as_f64().unwrap() as f32;let mut generated=Vec::new();
            view.process_frame(&factory,c["delta"].as_f64().unwrap() as f32,|source,_| {generated.push((source.opaque_ids[0]-55) as usize);Ok(())}).unwrap();
            let expected:Vec<usize>=c["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect();assert_eq!(generated,expected);
            compare(&view,&c["pending_after"]);assert_eq!(view.budget.smoothed_delta.to_bits(),c["smoothed_delta_bits"].as_u64().unwrap() as u32);
            for (i,reference) in references.iter().enumerate() {let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();assert_eq!(source.pending,c["pending_flags_after"][i].as_bool().unwrap());}
        }
    }
}

impl CircleSource {
    /// Native6B14E0 rebuilds only a dirty mask, then applies its current bounds.
    pub fn regenerate_cached(&mut self,layer:&mut crate::fow_regions::CountedLayer,extent:f32,terrain:&crate::fow_terrain_ray::TerrainGrid<'_>,owners:&[Option<crate::fow_owner::Owner>])->Result<bool,&'static str> {
        let rebuilt=self.parameters.generation_dirty;
        let mask=if rebuilt {self.stencil(layer.dimension(),extent,terrain,owners)?} else {
            let cached=self.region.as_ref().ok_or("clean fog source has no qualified cached stencil")?;
            let owner=crate::fow_owner::Reference {handle:self.position.owner_handle,cached_key:self.position.cached_owner.unwrap_or(0),owner_tag:self.owner_tag};
            let [scale,bias]=crate::fow_owner::modifiers([self.parameters.scale,self.parameters.bias],&owner,owners)?;
            let circle=crate::fow_shapes::Circle {center:self.position.center,radius:self.parameters.radius,scale,bias};
            StencilRegion {words:cached.words.clone(),rect:circle.bounds(layer.dimension(),extent)?,applied:false}
        };
        self.apply_to_layer(layer,mask)?;self.parameters.generation_dirty=false;Ok(rebuilt)
    }
}

#[cfg(test)] mod complete_frame_tests {
    use super::*;
    #[test] fn complete_map10_frames_match_native_masks_counts_and_cache_flags() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_frames_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),16);
        let metadata=&proof["terrain"];let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=crate::fow_terrain_ray::TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        let extent=proof["extent"].as_f64().unwrap() as f32;let camera=std::array::from_fn(|i|proof["camera"][i].as_f64().unwrap() as f32);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();let mut view=CircleView::new(128).unwrap();let mut references=Vec::new();
            for i in 0..3 {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:None,center:std::array::from_fn(|j|proof["centers"][i][j].as_f64().unwrap() as f32),radius:c["radius"].as_f64().unwrap() as f32,secondary_metric:128.,source_metric:64.,lifetime:0.});
                {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();source.region=Some(StencilRegion {words:vec![0;512],rect:[0;4],applied:false});
                    if c["initial_applied"].as_bool().unwrap() {assert!(source.regenerate_cached(&mut view.layer,extent,&terrain,&[]).unwrap());}}
                references.push(reference);
            }
            let compare=|view:&CircleView,expected:&serde_json::Value| {
                let sparse=|v:&serde_json::Value| {let mut out=vec![0u8;16384];for pair in v.as_array().unwrap() {out[pair[0].as_u64().unwrap() as usize]=pair[1].as_u64().unwrap() as u8;}out};
                assert_eq!(view.layer.counts,sparse(&expected["counts"]),"frame counters {c}");assert_eq!(view.layer.pixels,sparse(&expected["pixels"]),"frame pixels {c}");
                assert_eq!(view.budget.smoothed_delta.to_bits(),expected["smoothed_delta_bits"].as_u64().unwrap() as u32);
                assert_eq!(view.pending.entries().len(),expected["pending"].as_array().unwrap().len());
                for (entry,native) in view.pending.entries().iter().zip(expected["pending"].as_array().unwrap()) {
                    assert_eq!(references.iter().position(|weak|weak.as_ptr() as usize==entry.source).unwrap(),native["identity"].as_u64().unwrap() as usize);
                    assert!((f32::from_bits(entry.priority_bits)-f32::from_bits(native["priority_bits"].as_u64().unwrap() as u32)).abs()<=0.000001);
                }
                for (i,reference) in references.iter().enumerate() {
                    let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();let native=&expected["sources"][i];let mask=source.region.as_ref().unwrap();
                    assert_eq!(source.applied(),native["applied"].as_bool().unwrap());assert_eq!(source.pending,native["pending"].as_bool().unwrap());assert_eq!(source.parameters.generation_dirty,native["dirty"].as_bool().unwrap());
                    assert_eq!(mask.rect,std::array::from_fn(|j|native["rect"][j].as_u64().unwrap() as usize));
                    let words:Vec<u32>=native["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(mask.words,words,"source mask {c}");
                }
            };
            compare(&view,&c["initial"]);
            for frame in c["frames"].as_array().unwrap() {
                if frame["step"]==1 {
                    {let strong=references[0].upgrade().unwrap();let mut source=strong.lock().unwrap();source.position.center[0]+=128.;source.parameters.generation_dirty=true;}
                    {let strong=references[1].upgrade().unwrap();let mut source=strong.lock().unwrap();source.parameters.radius*=1.25;source.parameters.generation_dirty=true;}
                }
                for reference in &references {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();view.enqueue_update(reference,&mut source,frame["force"].as_bool().unwrap(),0,camera,extent,frame["now"].as_f64().unwrap() as f32,&[]).unwrap();}
                let mut generated=Vec::new();let mut queries=0;
                view.process_frame(&factory,frame["delta"].as_f64().unwrap() as f32,|source,layer| {
                    generated.push((source.opaque_ids[0]-55) as usize);if source.regenerate_cached(layer,extent,&terrain,&[])? {queries+=1;}Ok(())
                }).unwrap();
                let expected:Vec<usize>=frame["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect();assert_eq!(generated,expected);
                assert_eq!(queries,frame["source_queries"].as_array().unwrap().len());compare(&view,&frame["after"]);
            }
        }
    }
}

impl CircleSource {
    /// Native6198F0 resolves the actor-held weak source before updating parameters.
    pub fn update_weak_from_actor(reference:&Weak<Mutex<CircleSource>>,actor:&crate::fow_source_update::ActorParameters)->Result<bool,&'static str> {
        let Some(strong)=reference.upgrade() else {return Ok(false);};
        let mut source=strong.lock().map_err(|_|"poisoned fog source")?;
        crate::fow_source_update::update(Some(&mut source.parameters),actor);Ok(true)
    }
}
#[cfg(test)] mod owned_frame_tests {
    use super::*;
    #[test] fn owned_frames_match_native_updates_masks_and_priority_fallback() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_owned_frames_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),8);
        let metadata=&proof["terrain"];let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=crate::fow_terrain_ray::TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        let extent=proof["extent"].as_f64().unwrap() as f32;let camera=std::array::from_fn(|i|proof["camera"][i].as_f64().unwrap() as f32);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();let mut view=CircleView::new(128).unwrap();let mut references=Vec::new();
            let mut owners:Vec<Option<crate::fow_owner::Owner>>=(0..3).map(|i|Some(crate::fow_owner::Owner {key:17+i,handle:0x12340000+i as u32,owner_tag:if c["owner_valid"].as_bool().unwrap() {100}else{200},percent:0.,flat:0.})).collect();
            for i in 0..3 {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:Some(CachedOwner {key:17+i as u64,handle:0x12340000+i as u32}),center:std::array::from_fn(|j|proof["centers"][i][j].as_f64().unwrap() as f32),radius:c["radius"].as_f64().unwrap() as f32,secondary_metric:128.,source_metric:64.,lifetime:0.});
                {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();source.region=Some(StencilRegion {words:vec![0;512],rect:[0;4],applied:false});
                    if c["initial_applied"].as_bool().unwrap() {assert!(source.regenerate_cached(&mut view.layer,extent,&terrain,&owners).unwrap());}}
                references.push(reference);
            }
            let compare=|view:&CircleView,expected:&serde_json::Value| {
                let sparse=|v:&serde_json::Value| {let mut out=vec![0u8;16384];for pair in v.as_array().unwrap() {out[pair[0].as_u64().unwrap() as usize]=pair[1].as_u64().unwrap() as u8;}out};
                assert_eq!(view.layer.counts,sparse(&expected["counts"]),"frame counters {c}");assert_eq!(view.layer.pixels,sparse(&expected["pixels"]),"frame pixels {c}");
                assert_eq!(view.budget.smoothed_delta.to_bits(),expected["smoothed_delta_bits"].as_u64().unwrap() as u32);
                assert_eq!(view.pending.entries().len(),expected["pending"].as_array().unwrap().len());
                for (entry,native) in view.pending.entries().iter().zip(expected["pending"].as_array().unwrap()) {
                    assert_eq!(references.iter().position(|weak|weak.as_ptr() as usize==entry.source).unwrap(),native["identity"].as_u64().unwrap() as usize);
                    assert!((f32::from_bits(entry.priority_bits)-f32::from_bits(native["priority_bits"].as_u64().unwrap() as u32)).abs()<=0.000001);
                }
                for (i,reference) in references.iter().enumerate() {
                    let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();let native=&expected["sources"][i];let mask=source.region.as_ref().unwrap();
                    let expected_bits:[u32;5]=std::array::from_fn(|j|native["parameter_bits"][j].as_u64().unwrap() as u32);assert_eq!(source.parameters.bits(),expected_bits);
                    assert_eq!(source.applied(),native["applied"].as_bool().unwrap());assert_eq!(source.pending,native["pending"].as_bool().unwrap());assert_eq!(source.parameters.generation_dirty,native["dirty"].as_bool().unwrap());
                    assert_eq!(mask.rect,std::array::from_fn(|j|native["rect"][j].as_u64().unwrap() as usize));
                    let words:Vec<u32>=native["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(mask.words,words,"source mask {c}");
                }
            };
            compare(&view,&c["initial"]);
            for frame in c["frames"].as_array().unwrap() {
                if frame["step"]==1 {
                    {let strong=references[0].upgrade().unwrap();let mut source=strong.lock().unwrap();source.position.center[0]+=128.;source.parameters.generation_dirty=true;}

                }
                if frame["step"]==1 || frame["step"]==3 {
                    for (i,reference) in references.iter().enumerate() {
                        let owner=owners[i].as_mut().unwrap();owner.percent=if frame["step"]==1 {0.5}else{0.};owner.flat=if frame["step"]==1 {50.}else{0.};
                        let actor=crate::fow_source_update::ActorParameters {character_radius:Some(c["radius"].as_f64().unwrap() as f32*if i==1 {1.25}else{1.}),metric_override:0.,secondary_override:0.,metric_fallback:64.,secondary_fallback:128.,modifiers:openleague_core::vision::RadiusModifiers {percent_bubble_radius_mod:owner.percent,flat_bubble_radius_mod:owner.flat}};
                        assert!(CircleSource::update_weak_from_actor(reference,&actor).unwrap());assert_eq!(reference.strong_count(),1);
                    }
                }
                for reference in &references {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();view.enqueue_update(reference,&mut source,frame["force"].as_bool().unwrap(),0,camera,extent,frame["now"].as_f64().unwrap() as f32,&owners).unwrap();}
                let mut generated=Vec::new();let mut queries=0;
                view.process_frame(&factory,frame["delta"].as_f64().unwrap() as f32,|source,layer| {
                    generated.push((source.opaque_ids[0]-55) as usize);if source.regenerate_cached(layer,extent,&terrain,&owners)? {queries+=1;}Ok(())
                }).unwrap();
                let expected:Vec<usize>=frame["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect();assert_eq!(generated,expected);
                assert_eq!(queries,frame["source_queries"].as_array().unwrap().len());compare(&view,&frame["after"]);
            }
        }
    }
}


pub struct AiInputs {
    pub opaque_ids:[u32;2],pub owner_tag:u32,pub owner_handle:u32,
    pub secondary_position:[f32;3],pub character_radius:f32,pub flat_modifier:f32,
    pub secondary_metric:f32,pub source_metric:f32,pub stamp:u32,
}
impl CircleFactory {
    /// Qualified649040 creation path; actor pre-initialization remains external.
    pub fn create_ai_source(&mut self,input:AiInputs,provider:&Arc<ActorWeakAnchor>)->Weak<Mutex<CircleSource>> {
        // Original6490EE/6490F9/649103 loads778 in both arithmetic terms.
        let radius=input.character_radius*(input.flat_modifier+1.)+input.flat_modifier;
        let mut source=CircleSource::new_without_weak_provider(Inputs {
            opaque_ids:input.opaque_ids,owner_tag:input.owner_tag,owner:Some(CachedOwner {key:provider.key,handle:input.owner_handle}),
            center:[input.secondary_position[0],input.secondary_position[2]],radius,
            secondary_metric:input.secondary_metric,source_metric:input.source_metric,lifetime:0.,
        });
        source.provider=Some(Arc::downgrade(provider));
        source.ai_creation_flags=Some(AiCreationFlags {stamp:input.stamp,flag64:1,flag65:1,flag66:0,obstruction:true});
        let source=Arc::new(Mutex::new(source));let reference=Arc::downgrade(&source);self.sources.push(source);reference
    }
}
#[cfg(test)] mod ai_creation_tests {
    use super::*;
    #[test] fn ai_creation_fields_and_provider_retention_match_original_unit_path() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_ai_creation_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),36);
        for c in proof["cases"].as_array().unwrap() {
            let provider=Arc::new(ActorWeakAnchor {key:17});let mut factory=CircleFactory::default();
            let reference=factory.create_ai_source(AiInputs {opaque_ids:[12345,678],owner_tag:c["tag"].as_u64().unwrap() as u32,owner_handle:0x12340002,secondary_position:std::array::from_fn(|i|c["secondary_position"][i].as_f64().unwrap() as f32),character_radius:c["character_radius"].as_f64().unwrap() as f32,flat_modifier:c["flat"].as_f64().unwrap() as f32,secondary_metric:128.,source_metric:64.,stamp:0},&provider);
            assert_eq!(reference.strong_count(),c["source_strong"].as_u64().unwrap() as usize);assert_eq!(reference.weak_count()+1,c["source_weak"].as_u64().unwrap() as usize);
            assert_eq!(Arc::weak_count(&provider),c["provider_weak_delta"].as_u64().unwrap() as usize);
            {
                let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();
                for (offset,bits) in [("0x4",source.position.center[0].to_bits()),("0x8",source.position.center[1].to_bits()),("0xc",source.parameters.radius.to_bits()),("0x10",source.parameters.secondary_metric.to_bits()),("0x14",source.parameters.source_metric.to_bits()),("0x18",source.parameters.scale.to_bits()),("0x1c",source.parameters.bias.to_bits()),("0x20",source.position.remaining_lifetime.to_bits()),("0x24",source.position.owner_handle),("0x28",source.opaque_ids[0]),("0x2c",source.opaque_ids[1]),("0x30",source.owner_tag)] {assert_eq!(bits,c["words"][offset].as_u64().unwrap() as u32,"AI creation {offset} {c}");}
                assert_eq!(source.position.cached_owner,Some(17));assert!(source.provider.as_ref().unwrap().ptr_eq(&Arc::downgrade(&provider)));
                assert_eq!(source.applied(),c["applied"].as_bool().unwrap());assert_eq!(source.parameters.generation_dirty,c["dirty"].as_bool().unwrap());
                let flags=source.ai_creation_flags.as_ref().unwrap();assert_eq!(flags.stamp,c["words"]["0x60"].as_u64().unwrap() as u32);
                let word=c["words"]["0x64"].as_u64().unwrap() as u32;assert_eq!(flags.flag64,word as u8);assert_eq!(flags.flag65,(word>>8) as u8);assert_eq!(flags.flag66,(word>>16) as u8);assert_eq!(flags.obstruction,c["obstruction"].as_bool().unwrap());
            }
            assert!(factory.retire(&reference,|_|Ok(())).unwrap());assert_eq!(Arc::weak_count(&provider),c["provider_weak_delta_after_removal"].as_u64().unwrap() as usize);assert!(reference.upgrade().is_none());
        }
    }
}

impl CircleSource {
    /// The source first opaque identity resolves through registration and actor maps.
    pub fn registered_actor<'a,T>(&self,registry:&crate::fow_entity_registry::EntityRegistry<'a,T>)->Option<&'a T> {
        registry.resolve(self.opaque_ids[0])
    }
}

#[cfg(test)] mod registered_map10_tests {
    use super::*;
    #[test] fn registered_map10_frames_match_native_actor_filter_masks_and_transitions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_registered_map10_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),32);
        let metadata=&proof["terrain"];let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=crate::fow_terrain_ray::TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        let extent=proof["extent"].as_f64().unwrap() as f32;let camera=std::array::from_fn(|i|proof["camera"][i].as_f64().unwrap() as f32);
        for c in proof["cases"].as_array().unwrap() {
            let mut factory=CircleFactory::default();let mut view=CircleView::new(128).unwrap();let mut references=Vec::new();
            for i in 0..3 {
                let reference=factory.create_without_weak_provider(Inputs {opaque_ids:[55+i as u32,66],owner_tag:100,owner:None,center:std::array::from_fn(|j|proof["centers"][i][j].as_f64().unwrap() as f32),radius:c["radius"].as_f64().unwrap() as f32,secondary_metric:128.,source_metric:64.,lifetime:0.});
                {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();source.region=Some(StencilRegion {words:vec![0;512],rect:[0;4],applied:false});
                    if c["initial_applied"].as_bool().unwrap() {assert!(source.regenerate_cached(&mut view.layer,extent,&terrain,&[]).unwrap());}}
                references.push(reference);
            }
            let compare=|view:&CircleView,expected:&serde_json::Value| {
                let sparse=|v:&serde_json::Value| {let mut out=vec![0u8;16384];for pair in v.as_array().unwrap() {out[pair[0].as_u64().unwrap() as usize]=pair[1].as_u64().unwrap() as u8;}out};
                assert_eq!(view.layer.counts,sparse(&expected["counts"]),"frame counters {c}");assert_eq!(view.layer.pixels,sparse(&expected["pixels"]),"frame pixels {c}");
                assert_eq!(view.budget.smoothed_delta.to_bits(),expected["smoothed_delta_bits"].as_u64().unwrap() as u32);
                assert_eq!(view.pending.entries().len(),expected["pending"].as_array().unwrap().len());
                for (entry,native) in view.pending.entries().iter().zip(expected["pending"].as_array().unwrap()) {
                    assert_eq!(references.iter().position(|weak|weak.as_ptr() as usize==entry.source).unwrap(),native["identity"].as_u64().unwrap() as usize);
                    assert!((f32::from_bits(entry.priority_bits)-f32::from_bits(native["priority_bits"].as_u64().unwrap() as u32)).abs()<=0.000001);
                }
                for (i,reference) in references.iter().enumerate() {
                    let strong=reference.upgrade().unwrap();let source=strong.lock().unwrap();let native=&expected["sources"][i];let mask=source.region.as_ref().unwrap();
                    assert_eq!(source.applied(),native["applied"].as_bool().unwrap());assert_eq!(source.pending,native["pending"].as_bool().unwrap());assert_eq!(source.parameters.generation_dirty,native["dirty"].as_bool().unwrap());
                    assert_eq!(mask.rect,std::array::from_fn(|j|native["rect"][j].as_u64().unwrap() as usize));
                    let words:Vec<u32>=native["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(mask.words,words,"source mask {c}");
                }
            };
            compare(&view,&c["initial"]);
            for frame in c["frames"].as_array().unwrap() {
                if frame["step"]==1 {
                    {let strong=references[0].upgrade().unwrap();let mut source=strong.lock().unwrap();source.position.center[0]+=128.;source.parameters.generation_dirty=true;}
                    {let strong=references[1].upgrade().unwrap();let mut source=strong.lock().unwrap();source.parameters.radius*=1.25;source.parameters.generation_dirty=true;}
                }
                let registrations:std::collections::BTreeMap<u32,u32>=(0..3).map(|i|(55+i,0x12340000+i)).collect();
                let actors:std::collections::BTreeMap<u32,crate::fow_registered_filter::ActorFilter>=if c["presence"]=="actor" {
                    frame["actor_states"].as_array().unwrap().iter().enumerate().map(|(i,v)|(0x12340000+i as u32,crate::fow_registered_filter::ActorFilter {
                        team_tag:v["team_tag"].as_u64().unwrap() as u32,flag_ad:v["flag_ad"].as_bool().unwrap(),flag_118:v["flag_118"].as_bool().unwrap(),descriptor_24:v["descriptor_24"].as_bool().unwrap(),descriptor_2c:v["descriptor_2c"].as_bool().unwrap()
                    })).collect()
                }else{std::collections::BTreeMap::new()};
                let registry=crate::fow_entity_registry::EntityRegistry {registrations:&registrations,actors:&actors};
                for reference in &references {let strong=reference.upgrade().unwrap();let mut source=strong.lock().unwrap();
                    view.enqueue_local_source(reference,&mut source,&crate::fow_registered_filter::LocalViewInputs {local_team:100,force:frame["force"].as_bool().unwrap(),refresh_frames:0,camera,extent,now:frame["now"].as_f64().unwrap() as f32},&registry,&[]).unwrap();
                }
                let mut generated=Vec::new();let mut queries=0;
                view.process_frame(&factory,frame["delta"].as_f64().unwrap() as f32,|source,layer| {
                    generated.push((source.opaque_ids[0]-55) as usize);if source.regenerate_cached(layer,extent,&terrain,&[])? {queries+=1;}Ok(())
                }).unwrap();
                let expected:Vec<usize>=frame["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect();assert_eq!(generated,expected);
                assert_eq!(queries,frame["source_queries"].as_array().unwrap().len());compare(&view,&frame["after"]);
            }
        }
    }
}
