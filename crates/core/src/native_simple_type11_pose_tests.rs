use super::*;
use crate::native_simple_animation_policy as animation;
use crate::native_simple_animation_clock::Clip;
use crate::native_actor_effect_owner::{Actor,Owner};
use serde_json::Value;

fn bytes(hex:&str)->Vec<u8>{(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect()}
fn joints(b:&[u8])->Vec<Joint>{assert_eq!(b.len()%40,0);b.chunks_exact(40).map(|c|c.try_into().unwrap()).collect()}
fn actor()->Owner{Owner {actor:Some(Actor {position:[0.;3],direction:[0.;3],flags:0,type_tag:0,primary_status:0,current_id:1,field_50c:0}),previous_id:1}}
fn model(source:Arc<Pose>,transform:[u32;10])->ModelProvider{
    ModelProvider {owner:Some(actor()),kind:ProviderKind::GeometryOrPose,model:Some(Model {pose:Some(source),transform,lazy_update:false})}
}
fn instance(id:u32,fill:u8,count:usize)->InstanceHandle{
    InstanceHandle::new(id,Instance {resource:id,destination:Some(Pose::new(77,vec![[fill;40];count]).unwrap()),inverse:[u32::from_le_bytes([fill;4]);10]}).unwrap()
}
struct SharedProvider {state:Arc<Mutex<ModelProvider>>,mode:String,events:Arc<Mutex<Vec<&'static str>>>}
impl Provider for SharedProvider {
    fn pose(&mut self)->Result<Option<Arc<Pose>>,Error>{self.events.lock().unwrap().push("pose");self.state.lock().unwrap().pose()}
    fn transform(&mut self)->Result<Option<[u32;10]>,Error>{
        self.events.lock().unwrap().push("transform");
        let mut state=self.state.lock().unwrap();
        // These mutations correspond ONLY to the two explicitly injected
        //native-oracle races at its memcpy boundary, not gameplay behavior.
        if self.mode=="provider_removed_after_copy" {state.owner=None;}
        if self.mode=="expired_after_copy" {state.owner.as_mut().unwrap().actor=None;}
        state.transform()
    }
}
fn shared(p:ModelProvider,mode:&str)->(ProviderHandle,Arc<Mutex<ModelProvider>>,Arc<Mutex<Vec<&'static str>>>){
    let state=Arc::new(Mutex::new(p));let events=Arc::new(Mutex::new(Vec::new()));
    let handle:ProviderHandle=Arc::new(Mutex::new(Box::new(SharedProvider {state:state.clone(),mode:mode.to_owned(),events:events.clone()})));
    (handle,state,events)
}

struct Other;
impl animation::Backend for Other{
    fn lookup(&mut self,_:u32)->Option<Clip>{panic!("not a clip case")}
    fn special_kind11(&mut self,_:&mut animation::State){panic!("owned type11 hook was bypassed")}
    fn evaluate_uncompressed(&mut self,_:Clip,_:u32,_:u32,_:&mut animation::State){panic!("not a clip case")}
    fn evaluate_compressed(&mut self,_:Clip,_:u32,_:u32,_:&mut animation::State){panic!("not a clip case")}
}
fn input()->animation::Input{animation::Input {definition_kind:11,clip_index:u32::MAX,time:0,baseline:0,mapping:0}}

#[test]
fn type11_owned_policy_queue_and_pose_match44_original_lifetimes(){
    let p:Value=serde_json::from_str(include_str!("../../../data/4.20/type11_pose_contract.json")).unwrap();
    let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),44);assert_eq!(p["native_entries"]["pose_callback"],82);
    for (case,row) in rows.iter().enumerate(){
        let mode=row["mode"].as_str().unwrap();let count=row["joint_count"].as_u64().unwrap() as usize;let fill=row["fill"].as_u64().unwrap() as u8;
        let mut source=(0..count*40).map(|i|((i*37+count*11)&255) as u8).collect::<Vec<_>>();
        let transform=std::array::from_fn(|i|(row["input_transform"][i].as_f64().unwrap() as f32).to_bits());
        let mut state=model(Arc::new(Pose::new(77,joints(&source)).unwrap()),transform);
        match mode {
            "owner_null"=>state.owner=None,
            "expired"|"control_null"|"raw_null"=>state.owner.as_mut().unwrap().actor=None,
            "model_null"=>state.model=None,
            "inner_null"|"pose_null"=>state.model.as_mut().unwrap().pose=None,
            "generic_null"=>state.kind=ProviderKind::GenericNullPose,
            "valid"|"provider_removed_after_copy"|"expired_after_copy"=>{},
            _=>panic!("unknown oracle mode"),
        }
        let (provider,provider_state,events)=shared(state,mode);
        let handles:Vec<_>=(0..4).map(|i|instance(0x30001000+i*0x400,fill,count)).collect();
        let mut queue=Queue::new(8);let order=row["order"].as_array().unwrap();
        for index in order {
            let i=index.as_u64().unwrap() as usize;
            let mut state=animation::State {clock:123,resource:handles[i].id(),pose_flag:0x7f};
            let before=state.clone();let mut other=Other;
            let mut backend=Animation::new(&mut other,&mut queue,handles[i].clone(),provider.clone());
            animation::update(&mut state,&input(),&mut backend).unwrap();assert!(backend.error().is_none());assert_eq!(state,before);
        }
        let calls:Vec<_>=queue.calls().collect();
        assert_eq!(calls.iter().map(|c|c.argument).collect::<Vec<_>>(),order.iter().map(|i|handles[i.as_u64().unwrap() as usize].id()).collect::<Vec<_>>());
        assert!(calls.iter().all(|c|c.handler==HANDLER));assert!(events.lock().unwrap().is_empty());
        for h in &handles {assert_eq!(h.owner().lock().unwrap().destination.as_ref().unwrap().joints(),vec![[fill;40];count]);}
        if row["late_source"].as_bool().unwrap(){
            source.iter_mut().for_each(|v|*v^=0x69);
            if let Some(m)=provider_state.lock().unwrap().model.as_mut(){if m.pose.is_some(){m.pose=Some(Arc::new(Pose::new(77,joints(&source)).unwrap()));}}
        }
        let mut batch=queue.begin_drain().unwrap();assert!(queue.is_empty());let mut completed=Vec::new();
        while let Some(c)=batch.next().unwrap(){completed.push(c.call.argument);}
        assert_eq!(completed,calls.iter().map(|c|c.argument).collect::<Vec<_>>());assert_eq!(batch.remaining(),0);
        for h in &handles {
            let actual=h.owner().lock().unwrap();
            if let Some(expected)=row["contexts"].as_array().unwrap().iter().find(|v|v["instance"].as_u64().unwrap()==h.id() as u64){
                assert_eq!(actual.destination.as_ref().unwrap().joints(),joints(&bytes(expected["pose_hex"].as_str().unwrap())),"pose case{case}");
                let words:[u32;10]=std::array::from_fn(|i|u32::from_str_radix(expected["transform_words"][i].as_str().unwrap().trim_start_matches("0x"),16).unwrap());
                assert_eq!(actual.inverse,words,"transform case{case}");
            }else{
                assert_eq!(actual.destination.as_ref().unwrap().joints(),vec![[fill;40];count],"absent case{case}");
                assert_eq!(actual.inverse,[u32::from_le_bytes([fill;4]);10]);
            }
        }
        assert!(queue.begin_drain().unwrap().next().unwrap().is_none());
        let applied=mode=="valid"||mode.ends_with("_after_copy");
        assert_eq!(events.lock().unwrap().iter().filter(|e|**e=="transform").count(),if applied {order.len()} else {0});
    }
}

#[test]
fn type11_absence_precedes_destination_and_skeleton_replacement_is_explicit(){
    let source=Arc::new(Pose::new(77,vec![[9;40]]).unwrap());let mut p=model(source,IDENTITY);
    let mut d=Instance {resource:1,destination:None,inverse:[42;10]};let before=d.clone();
    p.owner=None;assert_eq!(consume(&mut d,&mut p),Ok(Outcome::SourceAbsent));assert_eq!(d,before);
    p.owner=Some(actor());assert_eq!(consume(&mut d,&mut p).unwrap_err(),Failure {phase:Phase::BeforeCopy,error:Error::MissingDestination});assert_eq!(d,before);
    d.destination=Some(Pose::new(88,vec![[3;40]]).unwrap());let before=d.clone();
    assert_eq!(consume(&mut d,&mut p).unwrap_err().error,Error::SkeletonChanged {destination:88,source:77});assert_eq!(d,before);
    d.destination=Some(Pose::new(77,vec![]).unwrap());let before=d.clone();
    assert_eq!(consume(&mut d,&mut p).unwrap_err().error,Error::JointCountChanged {destination:0,source:1});assert_eq!(d,before);
    p.model.as_mut().unwrap().lazy_update=true;assert!(matches!(consume(&mut d,&mut p).unwrap_err().error,Error::Unsupported(_)));assert_eq!(d,before);
}

#[test]
fn type11_failure_after_copy_retains_owners_and_never_replays_batch(){
    let (provider,_,events)=shared(model(Arc::new(Pose::new(77,vec![[9;40]]).unwrap()),[f32::NAN.to_bits();10]),"valid");
    let h=instance(1,3,1);let weak=Arc::downgrade(h.owner());let mut queue=Queue::new(3);
    queue.enqueue(h.clone(),provider.clone()).unwrap();queue.enqueue(h.clone(),provider.clone()).unwrap();
    let mut batch=queue.begin_drain().unwrap();let failure=batch.next().unwrap_err();assert_eq!(failure.phase,Phase::AfterCopy);
    assert_eq!(h.owner().lock().unwrap().destination.as_ref().unwrap().joints(),[[9;40]]);
    assert_eq!(h.owner().lock().unwrap().inverse,[0x03030303;10]);assert_eq!(batch.remaining(),2);
    let events_before=events.lock().unwrap().clone();assert_eq!(batch.next().unwrap_err().error,Error::Interrupted);assert_eq!(*events.lock().unwrap(),events_before);
    drop(h);drop(provider);assert!(weak.upgrade().is_some());drop(batch);assert!(weak.upgrade().is_none());
}

#[test]
fn type11_next_batch_capacity_resource_and_reentry_fail_without_loss(){
    let (provider,_,_)=shared(model(Arc::new(Pose::new(77,vec![[9;40]]).unwrap()),IDENTITY),"valid");
    let h=instance(1,3,1);let mut queue=Queue::new(1);queue.enqueue(h.clone(),provider.clone()).unwrap();
    assert_eq!(queue.enqueue(h.clone(),provider.clone()),Err(Error::Capacity));assert_eq!(queue.len(),1);
    let mut first=queue.begin_drain().unwrap();queue.enqueue(h.clone(),provider.clone()).unwrap();first.next().unwrap();assert_eq!(queue.len(),1);
    let mut second=queue.begin_drain().unwrap();let guard=h.owner().lock().unwrap();assert_eq!(second.next().unwrap_err().error,Error::BusyOrPoisoned);drop(guard);
    assert_eq!(second.next().unwrap_err().error,Error::Interrupted);
    let mut other=Other;let mut backend=Animation::new(&mut other,&mut queue,h,provider);
    let mut s=animation::State {clock:0,resource:2,pose_flag:7};assert!(animation::update(&mut s,&input(),&mut backend).is_err());assert_eq!(backend.error(),Some(&Error::ResourceMismatch));
}

#[test]
fn type11_zero_resource_skips_queue_and_nonfinite_unused_scale_is_ignored(){
    let (provider,_,_)=shared(model(Arc::new(Pose::new(77,vec![]).unwrap()),IDENTITY),"valid");
    let mut queue=Queue::new(0);let mut other=Other;let mut backend=Animation::new(&mut other,&mut queue,instance(1,3,0),provider);
    let mut s=animation::State {clock:123,resource:0,pose_flag:7};animation::update(&mut s,&input(),&mut backend).unwrap();assert!(backend.error().is_none());assert!(backend.queue.is_empty());
    let mut t=IDENTITY;t[3]=f32::NAN.to_bits();t[4]=f32::INFINITY.to_bits();t[5]=f32::NEG_INFINITY.to_bits();assert_eq!(inverse_transform(t).unwrap(),inverse_transform(IDENTITY).unwrap());
}

struct OwnerPhaseInputs {eligible:u8,events:Vec<&'static str>}
impl crate::native_troy_owner_pose::Backend for OwnerPhaseInputs {
    fn eligible(&mut self)->u8{self.events.push("eligible");self.eligible}
    fn position(&mut self)->Option<[u32;3]>{self.events.push("position");None}
    fn direction(&mut self)->Option<[u32;3]>{self.events.push("direction");None}
    fn orientation(&mut self)->Option<[u32;16]>{panic!("flags do not request orientation")}
    fn secondary_status(&mut self)->u8{self.events.push("secondary");0}
    fn primary_status(&mut self)->u8{self.events.push("primary");1}
    fn deferred(&mut self,_:DeferredCall,_:&mut Vec<DeferredCall>){panic!("typed pose consumer must own callback")}
}
fn owner_values()->(crate::native_troy_properties::Source,crate::native_troy_properties::Emitter){
    use crate::native_troy_properties::{Source,Emitter};
    use crate::native_troy_position_bounds::Bounds;
    (Source {requests:0,flags:0,visibility:0,params:[0;3],color:[0;8],matrix:[0;16],channels:[0;3],field_80:0,position:[0;3],direction:[0;3]},
    Emitter {flags:0,source_flags:0x80,channels:[0;3],field_80:0,params:[0;3],color:[0;8],matrix:[0;16],bounds:Bounds {position:[0;3],minimum:[0;3],maximum:[0;3]},direction:[0;3]})
}
#[test]
fn type11_owner_phase_gates_queue_and_retains_failure_after_clear(){
    let (provider,provider_state,events)=shared(model(Arc::new(Pose::new(77,vec![[9;40]]).unwrap()),IDENTITY),"valid");
    let h=instance(1,3,1);let mut queue=Queue::new(2);queue.enqueue(h.clone(),provider.clone()).unwrap();
    let (mut source,mut emitter)=owner_values();
    let config=crate::native_troy_owner_pose::Config {group_vis:1f32.to_bits(),flags:0};
    let mut other=OwnerPhaseInputs {eligible:0,events:Vec::new()};
    assert_eq!(queue.transfer_owner(&mut source,&mut emitter,config,false,&mut other).unwrap(),0);
    assert!(other.events.is_empty());assert_eq!(queue.len(),1);
    assert_eq!(queue.transfer_owner(&mut source,&mut emitter,config,true,&mut other).unwrap(),0);
    assert_eq!(other.events,["eligible"]);assert_eq!(queue.len(),1);assert!(events.lock().unwrap().is_empty());assert_eq!(emitter.source_flags,0x80);
    other.eligible=1;other.events.clear();
    assert_eq!(queue.transfer_owner(&mut source,&mut emitter,config,true,&mut other).unwrap(),1);
    assert_eq!(other.events,["eligible","position","direction","secondary","primary"]);
    assert!(queue.is_empty());assert_eq!(emitter.source_flags,0x88);
    assert_eq!(h.owner().lock().unwrap().destination.as_ref().unwrap().joints(),[[9;40]]);
    // Host-only arithmetic rejection after the native-order joint copy. The
    // infallible legacy callback loop must not lose this owning failure.
    provider_state.lock().unwrap().model.as_mut().unwrap().transform[0]=f32::NAN.to_bits();
    queue.enqueue(h.clone(),provider.clone()).unwrap();queue.enqueue(h.clone(),provider.clone()).unwrap();
    let mut failure=queue.transfer_owner(&mut source,&mut emitter,config,true,&mut other).unwrap_err();
    assert!(queue.is_empty());assert_eq!(failure.failure.phase,Phase::AfterCopy);
    let retained=failure.retained.as_mut().unwrap();assert_eq!(retained.remaining(),2);
    let before=events.lock().unwrap().clone();assert_eq!(retained.next().unwrap_err().error,Error::Interrupted);assert_eq!(*events.lock().unwrap(),before);
    let weak=Arc::downgrade(h.owner());drop(h);drop(provider);assert!(weak.upgrade().is_some());drop(failure);assert!(weak.upgrade().is_none());
}
