//! Native ambient requests and persistent logical registration.
//! Logical handles do not represent physical voice acceptance.
use bevy::prelude::*;
use openleague_core::{audio_requests::Request,native_random::Rng55};
use crate::native_ambient_parent::{AmbientParent,SceneFrame};
use std::collections::BTreeMap;
type Key = (String, u64);
struct Active { document:serde_json::Value, parent:Option<AmbientParent>, birth: f32, previous_time: f32, token:u64, pose:Option<(Vec3,Mat4)>, retired:bool, stop:openleague_core::audio_emitter_stop::StopState, end:Option<openleague_core::audio_emitter_end::Marks> }
impl Active {
 fn handle(&self)->i32{self.parent.as_ref().map_or(-1,|p|p.parent.state.audio.handles[0] as i32)}
}
/// One stream for ambient parents, seeded once at resource creation.
/// Other effect/camera consumers still need migration to this shared ownership.
#[derive(Resource)]
pub struct AmbientRandom(pub Rng55);
impl Default for AmbientRandom {
 fn default()->Self {
  #[cfg(windows)]
  let ticks={
   #[repr(C)] struct FileTime{low:u32,high:u32}
   #[link(name="kernel32")] unsafe extern "system"{fn GetSystemTimeAsFileTime(value:*mut FileTime);}
   let mut value=FileTime{low:0,high:0};unsafe{GetSystemTimeAsFileTime(&mut value)};
   (u64::from(value.high)<<32)|u64::from(value.low)
  };
  #[cfg(not(windows))]
  let ticks=116444736000000000u64+u64::try_from(std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).expect("UTC clock before epoch").as_nanos()/100).expect("FILETIME overflow");
  Self(Rng55::from_filetime(ticks))
 }
}
#[derive(Debug)]
pub struct Pending {
    pub source: Key,
    /// Stable producer lifetime identity; not a playing ID or native object pointer.
    pub owner_token:u64,
    pub event_id: u32,
    pub request: Request,
}
#[derive(Resource, Default)]
pub struct AmbientRequests {
    active: BTreeMap<Key, Active>,
    ended: BTreeMap<u64,(Key,Active)>,
    next_token:u64,
    stopped:Vec<u32>,
    cleaned:u64,
    /// Native engine88 stamp: one wrapping increment per effect update pass.
    pub pass_stamp:u32,
    pub logical: openleague_core::audio_logical_registration::Manager,
    pub pending: Vec<Pending>,
    pub unresolved: Vec<Key>,
    pub owner_fallbacks:Vec<Key>,
    pub rejected: Vec<(Key, String)>,
}
impl AmbientRequests {
    /// Read-only diagnostics; pending requests are not accepted or audible voices.
    pub fn diagnostic(&self)->serde_json::Value {
        serde_json::json!({
            "active":self.active.iter().map(|(key,a)|serde_json::json!({"source":key,"token":a.token,"birth":a.birth,"previous_time":a.previous_time,"handle":a.handle()})).collect::<Vec<_>>(),
            "pending":self.pending.iter().map(|p|serde_json::json!({"source":p.source,"owner_token":p.owner_token,"event_id":p.event_id,"slot":p.request.slot,"age":p.request.age,"position":p.request.position})).collect::<Vec<_>>(),
            "cleaned_count":self.cleaned,"stop_pending_count":self.stopped.len(),"uninitialized_ended_count":self.ended.values().filter(|(_,a)|a.parent.is_none()).count(),"pass_stamp":self.pass_stamp,"ended_count":self.ended.len(),"unresolved":self.unresolved,"owner_fallbacks":self.owner_fallbacks,"rejected":self.rejected,
            "logical_pending":self.logical.pending_key_calls(),
            "logical_release_pending":self.logical.release_keys(),
            "backend_available":false
        })
    }
    /// Local ownership tokens, distinct from native logical/playing IDs.
    pub fn ended_tokens(&self)->Vec<u64> {self.ended.keys().copied().collect()}
    /// Call only from actual particle cleanup/reset, never from animation End.
    /// The release callback queues logical release, not synchronous voice Stop.
    /// Finished bit is mandatory; End alone never releases a live resource.
    pub fn finish_cleanup(&mut self,token:u64,mut release:impl FnMut(i32))->bool {
        if !self.stopped.contains(&(token as u32)){return false;}
        if !self.ended.get(&token).is_some_and(|(_,a)|a.parent.as_ref().is_some_and(|p|p.parent.state.audio.flags_1dc&2!=0)){return false;}
        let Some((_,mut active))=self.ended.remove(&token) else {return false;};
        if let Some(parent)=active.parent.as_mut(){
            let mut handles=parent.parent.state.audio.handles.map(|h|h as i32);
            openleague_core::audio_emitter_drain::release_handles(&mut handles,|h|{self.logical.queue_release(h);release(h);});
            parent.parent.state.audio.handles=handles.map(|h|h as u32);
        }
        self.stopped.retain(|&id|u64::from(id)!=token);self.cleaned+=1;true
    }
}
fn document(particle: &str) -> Result<serde_json::Value, &'static str> {
    let raw = match particle {
        "Audio-Emitter_TT_BrazierChains.troy" => include_str!("../../../data/4.20/particles/Audio-Emitter_TT_BrazierChains.json"),
        "Audio-Emitter_TT_ChainsSwing.troy" => include_str!("../../../data/4.20/particles/Audio-Emitter_TT_ChainsSwing.json"),
        "Audio-Emitter_TT_ChainsSwingBase.troy" => include_str!("../../../data/4.20/particles/Audio-Emitter_TT_ChainsSwingBase.json"),
        "Audio-Emitter_TT_Shopkeeper_idle.troy" => include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle.json"),
        "Audio-Emitter_TT_Shopkeeper_idle2.troy" => include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle2.json"),
        _ => return Err("unqualified ambient particle"),
    };
    let data: serde_json::Value = serde_json::from_str(raw).expect("verified particle JSON");
    Ok(data)
}
/// Only source-proven failed bone lookups on the ordinary animation-owner path.
/// A disappeared entity or unloaded model is not evidence of this native fallback.
fn native_missing_bone(source:&crate::map_audio::AmbientPosition,offset:u64)->bool {
    static DATA:std::sync::OnceLock<serde_json::Value>=std::sync::OnceLock::new();
    let data=DATA.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/ambient_events.json")).unwrap());
    data["models"][&source.native_asset]["events"].as_array().is_some_and(|rows|rows.iter().any(|r|
        r["record_offset"].as_u64()==Some(offset) && r["bone"].as_str()==Some(source.bone.as_str()) &&
        r["particle"].as_str()==Some(source.particle.as_str()) && r["attachment_source_resolved"]==false &&
        r["flags"].as_u64().is_some_and(|f|f&4==0)))
}
fn resolve_pose(source:&crate::map_audio::AmbientPosition,key:&Key,transforms:&Query<&GlobalTransform>,players:&Query<&crate::map_ambient::AmbientPlayer>)->Result<Option<(Vec3,Mat4,bool)>,&'static str> {
    let (transform,fallback)=if let Some(entity)=source.attachment {
        let Ok(transform)=transforms.get(entity) else{return Ok(None);};(transform,false)
    }else{
        if !native_missing_bone(source,key.1){return Ok(None);}
        let Some(root)=players.iter().find(|a|a.0.id==key.0 && a.0.native==source.native_asset).map(|a|a.1) else{return Ok(None);};
        let Ok(transform)=transforms.get(root) else{return Ok(None);};(transform,true)
    };
    let matrix=Mat4::from_scale(Vec3::splat(20.))*transform.to_matrix();
    let orientation=Mat4::from_cols_array(&openleague_core::native_actor_effect_owner::orientation(matrix.to_cols_array())?);
    if !matrix.w_axis.truncate().is_finite(){return Err("nonfinite ambient owner position");}
    Ok(Some((matrix.w_axis.truncate(),orientation,fallback)))
}
fn pending(source: &Key, owner_token:u64, request: Request) -> Pending {
    let event_id = openleague_core::audio_release::event_id(&request.event)
        .expect("verified ASCII native event name");
    Pending { source: source.clone(), owner_token, event_id, request }
}
pub fn update(time: Res<crate::native_effect_clock::EffectClock>, queue: Res<crate::map_events::Queue>,
    positions: Res<crate::map_audio::AmbientPositions>, mut requests: ResMut<AmbientRequests>,
    transforms:Query<&GlobalTransform>,players:Query<&crate::map_ambient::AmbientPlayer>,camera:Res<crate::camera_native::NativeCamera>,
    windows:Query<&Window,With<bevy::window::PrimaryWindow>>,settings:Res<crate::native_user_settings::Loaded>,
    mut random:ResMut<AmbientRandom>) {
    let state = &mut *requests;
    state.pending.clear(); state.unresolved.clear(); state.owner_fallbacks.clear(); state.rejected.clear();
    // Native92B306 runs before per-instance updates, including an empty pass.
    state.pass_stamp=state.pass_stamp.wrapping_add(1);
    for cue in &queue.0 {
        if !cue.particle.starts_with("Audio-Emitter_") { continue; }
        let key = (cue.instance.clone(), cue.record_offset);
        if !cue.start {
            // Native5B5440 marks; normal game removal occurs after this particle pass.
            if let Some(mut active)=state.active.remove(&key) {
                let mut marks=openleague_core::audio_emitter_end::Marks {ending_raw:0,remaining_raw:0};
                marks.mark(true);active.end=Some(marks);
                state.ended.insert(active.token,(key,active));
            }
        } else {
            match document(&cue.particle) {
                Ok(document) => {
                    if state.active.contains_key(&key) {state.rejected.push((key,"duplicate start requires qualified particle reset".into()));continue;}
                    let Some(next)=state.next_token.checked_add(1).filter(|v|*v<=u32::MAX as u64) else {state.rejected.push((key,"emitter ownership token exhausted".into()));continue;};
                    let token=next;state.next_token=next;
                    // Start5B54C0 supplies factory position before End can erase the
                    // public position track. Deferred6C9210 forwards it even if ended.
                    let cue_source=crate::map_audio::AmbientPosition{native_asset:cue.native_asset.clone(),particle:cue.particle.clone(),bone:cue.bone.clone(),attachment:cue.attachment,native_position:None};
                    let source=positions.0.get(&key).unwrap_or(&cue_source);
                    let pose=match resolve_pose(source,&key,&transforms,&players){
                        Ok(Some((position,orientation,fallback)))=>{if fallback{state.owner_fallbacks.push(key.clone());}Some((position,orientation))},
                        Ok(None)=>None,Err(error)=>{state.rejected.push((key.clone(),error.into()));None}
                    };
                    state.active.insert(key,Active {document,parent:None,birth:time.now as f32,previous_time:time.now as f32,token,pose,retired:false,stop:openleague_core::audio_emitter_stop::StopState{flags:0,stop_time:0.,handles:[-1;2]},end:None});
                }
                Err(error) => { state.rejected.push((key, error.into())); }
            }
        }
    }
    // Native instance vector order is creation order, not lexical source-name order.
    let mut ordered=state.active.iter().map(|(k,a)|(a.token,k.clone())).collect::<Vec<_>>();
    ordered.extend(state.ended.iter().map(|(t,(k,_))|(*t,k.clone())));
    ordered.sort_by_key(|(token,_)|*token);
    let aspect=windows.single().ok().map(|w|w.width()/w.height());
    for (token,key) in ordered {
        let active=if let Some((_,a))=state.ended.get_mut(&token){a}else{state.active.get_mut(&key).unwrap()};
        let request_time=active.previous_time;active.previous_time=time.now as f32;
        let (position,orientation)=if active.end.is_some(){
            let Some(pose)=active.pose else{state.unresolved.push(key);continue;};pose
        }else{
            let Some(source)=positions.0.get(&key) else{state.unresolved.push(key);continue;};
            match resolve_pose(source,&key,&transforms,&players){
                Ok(Some((position,orientation,fallback)))=>{
                    if fallback && !state.owner_fallbacks.contains(&key){state.owner_fallbacks.push(key.clone());}
                    active.pose=Some((position,orientation));(position,orientation)
                },
                Ok(None)=>{state.unresolved.push(key);continue;},Err(error)=>{state.rejected.push((key,error.into()));continue;}
            }
        };
        let Some(aspect)=aspect else {state.rejected.push((key,"missing primary viewport".into()));continue;};
        let owner=match crate::simple_owner_pose::SimpleOwnerPose::new(position,orientation,0.) {
            Ok(v)=>v,Err(e)=>{state.rejected.push((key,e.into()));continue;}
        };
        if active.parent.is_none(){
            match AmbientParent::new(&active.document,active.birth,&owner,random.0.clone()) {
                Ok(mut parent)=>{parent.parent.state.audio.times[1]=request_time.to_bits();active.parent=Some(parent);}
                Err(e)=>{state.rejected.push((key,e));continue;}
            }
        }
        let parent=active.parent.as_mut().unwrap();
        // 58D12C particles precede 58D1AB wrapper removal. A retired wrapper's
        // request is consumed on the following particle pass, never on End.
        if active.retired {
            active.stop.flags=parent.parent.state.audio.flags_1dc;
            active.stop.handles=parent.parent.state.audio.handles.map(|h|h as i32);
            active.stop.request(time.now as f32,parent.config_flags as u8,active.token as u32,&mut state.stopped,|h|state.logical.queue_release(h)).expect("single local stop queue");
            parent.parent.state.audio.handles=active.stop.handles.map(|h|h as u32);
        }
        // Missing poses do not reset the original birth or replay old creation sounds.
        parent.parent.state.audio.times[1]=request_time.to_bits();
        let before=state.logical.pending_key_calls().len();let mut transient=Vec::new();
        let result=parent.update_scene_shared(SceneFrame{time:time.now as f32,owner:&owner,direction:Vec3::ZERO,
            instance_flags:active.stop.flags,source_flags:0x10,quality_setting:settings.effects_quality() as u32,
            root_clock:state.pass_stamp,status:0,emit:true,camera:&camera,aspect},&mut state.logical,&mut transient,&mut random.0);
        for &handle in &state.logical.pending_key_calls()[before..] {
            if let Some(entry)=state.logical.entry(handle){state.pending.push(pending(&key,active.token,Request{slot:0x10,event:entry.event.clone(),position:entry.position,age:entry.age}));}
        }
        for request in transient{state.pending.push(pending(&key,active.token,request));}
        if let Err(error)=result{state.rejected.push((key,error));}
    }
    // Native stopped-parent drain follows parent updates and requires finished bit2.
    let finished=state.stopped.iter().map(|&t|u64::from(t)).collect::<Vec<_>>();
    for token in finished {state.finish_cleanup(token,|_|{});}
    // Native registry removal calls wrapper cleanup (6C9360), requesting Troy stop.
    for (_,a) in state.ended.values_mut(){a.retired=true;}
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::{map_audio::{AmbientPositions, AmbientPosition}, map_events::{Queue, EmitterCue}};
    fn cue(particle: &str, start: bool, offset: u64) -> EmitterCue {
        EmitterCue { start, instance: "prop01".into(), native_asset: "TT_Brazier".into(),
            name: particle.into(), particle: particle.into(), bone: "native_bone".into(),
            attachment: None, record_offset: offset, flags: 1, cycle: 0, elapsed_seconds: 0.,
            evaluated_frame: 0., source_start_frame: 0., source_end_frame: 5., loop_reset: false }
    }
    pub(super) fn app() -> App {
        let mut app=App::new(); app.init_resource::<Time>().init_resource::<crate::native_effect_clock::EffectClock>().init_resource::<Queue>()
            .init_resource::<AmbientPositions>().init_resource::<AmbientRequests>()
            .insert_resource(AmbientRandom(Rng55::seeded(17)))
            .insert_resource(crate::native_user_settings::load(std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..").as_path()).unwrap())
            .add_systems(Update,update);
        let mut camera=crate::camera_native::NativeCamera::default();camera.pose(Vec3::new(370.,0.,385.),0.016,0.).unwrap();app.insert_resource(camera);
        app.world_mut().spawn((Window::default(),bevy::window::PrimaryWindow));app
    }
    fn position(app: &mut App, offset: u64, value: Option<[f32;3]>) {
        let attachment=value.map(|v|app.world_mut().spawn(GlobalTransform::from(Transform::from_translation(Vec3::from_array(v)/20.).with_scale(Vec3::splat(0.05)))).id());
        app.world_mut().resource_mut::<AmbientPositions>().0.insert(("prop01".into(),offset),
            AmbientPosition {native_asset:"TT_Brazier".into(),particle:String::new(),bone:String::new(),attachment,native_position:value});
    }
    #[test]
    fn actual_create_field_posts_once_and_end_does_not_emit_stop() {
        let mut a=app(); position(&mut a,400,Some([7400.,2.,7700.]));
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_BrazierChains.troy",true,400)]; a.update();
        let r=a.world().resource::<AmbientRequests>(); assert_eq!(r.pending.len(),1);
        assert_eq!(r.pending[0].request.event,"Play_sfx_Env_Map10_Emitter_brazierchain");
        assert_eq!(r.pending[0].request.slot,0x18); assert_eq!(r.pending[0].source,("prop01".into(),400));
        assert_eq!(r.pending[0].event_id,openleague_core::audio_release::event_id(&r.pending[0].request.event).unwrap());
        a.world_mut().resource_mut::<Queue>().0.clear(); a.update(); assert!(a.world().resource::<AmbientRequests>().pending.is_empty());
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_BrazierChains.troy",false,400)]; a.update();
        let r=a.world().resource::<AmbientRequests>(); assert!(r.active.is_empty()); assert!(r.pending.is_empty());assert_eq!(r.ended.len(),1);
    }
    #[test]
    fn native_persistent_registration_is_retained_without_physical_backend() {
        let mut a=app(); position(&mut a,528,Some([7400.,5.,7700.]));
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,528)]; a.update();
        let r=a.world().resource::<AmbientRequests>(); assert_eq!(r.pending.len(),1);
        assert_eq!(r.pending[0].request.event,"Play_sfx_TT_Shopkeeper_idle1"); assert_eq!(r.pending[0].request.slot,0x10);
        a.world_mut().resource_mut::<Queue>().0.clear(); position(&mut a,528,Some([7407.,8.,7709.]));
        a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=2.; a.update(); a.update();
        let r=a.world().resource::<AmbientRequests>(); assert!(r.pending.is_empty());
        assert_eq!(r.active[&("prop01".into(),528)].handle(),1);
        assert_eq!(r.logical.pending_key_calls(),&[1]);
        let entry=r.logical.entry(1).unwrap();assert_eq!(entry.backend_reference,-1);
        assert_eq!(entry.position,[7407.,8.,7709.]);assert_eq!(entry.age,0.);
    }
    #[test]
    fn missing_attachment_never_posts_origin_or_late_creation() {
        let mut a=app(); position(&mut a,400,None);
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_BrazierChains.troy",true,400)]; a.update();
        assert_eq!(a.world().resource::<AmbientRequests>().unresolved.len(),1);
        assert!(a.world().resource::<AmbientRequests>().pending.is_empty());
        a.world_mut().resource_mut::<Queue>().0.clear();
        a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=1.; a.update();
        position(&mut a,400,Some([7400.,2.,7700.])); a.update();
        let r=a.world().resource::<AmbientRequests>(); assert!(r.pending.is_empty());
        assert_ne!(r.active[&("prop01".into(),400)].parent.as_ref().unwrap().parent.state.audio.flags_1dc&0x20,0);
    }
    #[test]
    fn unknown_particle_is_rejected_and_same_frame_end_initializes_resource() {
        let mut a=app(); position(&mut a,400,Some([7400.,2.,7700.]));
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_unknown.troy",true,1),
            cue("Audio-Emitter_TT_ChainsSwing.troy",true,400),cue("Audio-Emitter_TT_ChainsSwing.troy",false,400)]; a.update();
        let r=a.world().resource::<AmbientRequests>(); assert_eq!(r.rejected.len(),1);
        assert!(r.active.is_empty()); assert_eq!(r.pending.len(),1);assert_eq!(r.ended.len(),1);assert!(r.ended.values().all(|(_,a)|a.parent.is_some()));
    }
    #[test]
    fn end_defers_stop_and_finished_cleanup_preserves_restarted_owner() {
        let mut a=app();position(&mut a,528,Some([7400.,2.,7700.]));
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,528)];a.update();
        let key=("prop01".into(),528);
        let original_owner=a.world().resource::<AmbientRequests>().pending[0].owner_token;
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",false,528)];a.update();
        let token=a.world().resource::<AmbientRequests>().ended_tokens()[0];assert_eq!(token,original_owner);
        let r=a.world().resource::<AmbientRequests>();assert!(r.pending.is_empty());assert_eq!(r.ended[&token].1.handle(),1);assert_eq!(r.ended[&token].1.end.unwrap().ending_raw,1);
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,528)];a.update();
        let r=a.world().resource::<AmbientRequests>();assert_ne!(r.active[&key].token,token);assert_eq!(r.ended.len(),1);assert_eq!(r.pending[0].owner_token,r.active[&key].token);assert_ne!(r.pending[0].owner_token,original_owner);
        assert!(!a.world_mut().resource_mut::<AmbientRequests>().finish_cleanup(token,|_|panic!("premature cleanup")));
        a.world_mut().resource_mut::<Queue>().0.clear();
        for frame in 1..=120 {a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=frame as f64/30.;a.update();}
        let r=a.world().resource::<AmbientRequests>();assert!(r.ended.is_empty());assert_eq!(r.logical.release_keys().iter().filter(|&&h|h==1).count(),1);assert_eq!(r.active[&key].handle(),2);
    }

    #[test]
    fn same_frame_start_end_survives_position_track_removal_and_cleans() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/ambient_ended_initialization_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),6);
        for case in proof["cases"].as_array().unwrap().iter().filter(|c|c["ended"]==true){assert_eq!(case["update_return"],0);assert_eq!(case["initialized"],case["after_update"]);}
        let mut a=app();
        a.add_systems(Update,crate::map_audio::ambient_cues.before(update));
        let bone=a.world_mut().spawn(GlobalTransform::from(Transform::from_translation(Vec3::new(370.,0.,385.)).with_scale(Vec3::splat(0.05)))).id();
        let mut start=cue("Audio-Emitter_TT_BrazierChains.troy",true,400);start.attachment=Some(bone);
        let mut end=start.clone();end.start=false;
        a.world_mut().resource_mut::<Queue>().0=vec![start,end];a.update();
        assert!(a.world().resource::<AmbientPositions>().0.is_empty());
        let r=a.world().resource::<AmbientRequests>();assert!(r.unresolved.is_empty());assert!(r.rejected.is_empty());
        assert_eq!(r.pending.len(),1);assert_eq!(r.pending[0].request.position,[7400.,0.,7700.]);
        assert_eq!(r.ended.len(),1);assert!(r.ended.values().all(|(_,a)|a.parent.is_some()));assert!(r.stopped.is_empty());
        a.world_mut().resource_mut::<Queue>().0.clear();
        for frame in 1..=120 {a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=frame as f64/30.;a.update();}
        let r=a.world().resource::<AmbientRequests>();assert!(r.ended.is_empty());assert_eq!(r.cleaned,1);assert!(r.pending.is_empty());
    }

    #[test]
    fn end_retains_pose_and_delays_stop_until_next_particle_pass() {
        let mut a=app();position(&mut a,528,Some([7400.,0.,7700.]));
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,528)];a.update();
        a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=1.;
        position(&mut a,528,None);
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",false,528)];a.update();
        let r=a.world().resource::<AmbientRequests>();let token=r.ended_tokens()[0];
        assert!(r.unresolved.is_empty());assert!(r.rejected.is_empty());assert!(r.stopped.is_empty());
        assert_eq!(r.ended[&token].1.stop.flags&0x40,0);
        assert_eq!(r.logical.entry(1).unwrap().position,[7400.,0.,7700.]);
        assert!(!a.world_mut().resource_mut::<AmbientRequests>().finish_cleanup(token,|_|panic!("End is not cleanup")));
        a.world_mut().resource_mut::<Queue>().0.clear();
        for frame in 1..=600 {
            a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=1.+frame as f64/30.;a.update();
            let r=a.world().resource::<AmbientRequests>();assert!(r.unresolved.is_empty());assert!(r.rejected.is_empty());
            if let Some((_,ended))=r.ended.get(&token){assert_ne!(ended.stop.flags&0x40,0);assert_eq!(ended.birth,0.);}
        }
        let r=a.world().resource::<AmbientRequests>();assert!(r.ended.is_empty());assert!(r.stopped.is_empty());assert_eq!(r.cleaned,1);
        assert_eq!(r.logical.release_keys().iter().filter(|&&h|h==1).count(),1);
    }

    #[test]
    fn scene_camera_controls_release_reacquire_and_previous_frame_age() {
        let mut a=app();position(&mut a,528,Some([7400.,0.,7700.]));
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,528)];a.update();
        a.world_mut().resource_mut::<Queue>().0.clear();
        a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=0.25;
        a.world_mut().resource_mut::<crate::camera_native::NativeCamera>().pose(Vec3::new(150.,0.,220.),0.016,0.25).unwrap();a.update();
        let r=a.world().resource::<AmbientRequests>();assert!(r.rejected.is_empty());assert_eq!(r.logical.release_keys(),&[1]);
        a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=0.5;
        a.world_mut().resource_mut::<crate::camera_native::NativeCamera>().pose(Vec3::new(370.,0.,385.),0.016,0.5).unwrap();a.update();
        let r=a.world().resource::<AmbientRequests>();assert!(r.rejected.is_empty());assert_eq!(r.pending.len(),1);
        assert_eq!(r.pending[0].request.age,0.25);assert_eq!(r.active[&("prop01".into(),528)].handle(),2);
        assert_eq!(r.active[&("prop01".into(),528)].parent.as_ref().unwrap().parent.state.clock,r.pass_stamp);
    }
    #[test]
    fn sources_update_in_creation_order_and_missing_pose_never_consumes_stream() {
        let mut a=app();for offset in [9,1]{position(&mut a,offset,Some([7400.,0.,7700.]));}
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,9),cue("Audio-Emitter_TT_Shopkeeper_idle2.troy",true,1)];a.update();
        let r=a.world().resource::<AmbientRequests>();assert!(r.rejected.is_empty());assert_eq!(r.pending.iter().map(|p|p.source.1).collect::<Vec<_>>(),vec![9,1]);
        a.world_mut().resource_mut::<Queue>().0.clear();for offset in [9,1]{position(&mut a,offset,None);}
        let before=a.world().resource::<AmbientRandom>().0.clone();a.update();
        let r=a.world().resource::<AmbientRequests>();assert_eq!(r.unresolved.len(),2);assert!(r.pending.is_empty());
        let after=&a.world().resource::<AmbientRandom>().0;assert_eq!(before.words,after.words);assert_eq!((before.first,before.second),(after.first,after.second));
    }
    #[test]
    fn original_missing_chain_bone_posts_from_live_owner_without_alias() {
        let mut a=app();let root=a.world_mut().spawn(GlobalTransform::from(Transform::from_translation(Vec3::new(370.,0.,385.)).with_scale(Vec3::splat(0.05)))).id();
        let mut player=crate::map_ambient::AmbientPlayer::clock_test_fixture(AnimationNodeIndex::new(0),root);
        player.0.id="prop01".into();player.0.native="TT_Chains_Bot_Lane".into();a.world_mut().spawn(player);
        let source=AmbientPosition{native_asset:"TT_Chains_Bot_Lane".into(),particle:"Audio-Emitter_TT_ChainsSwing.troy".into(),bone:"Chain4-3".into(),attachment:None,native_position:None};
        assert!(native_missing_bone(&source,304));assert!(!native_missing_bone(&source,528));
        a.world_mut().resource_mut::<AmbientPositions>().0.insert(("prop01".into(),304),source);
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_ChainsSwing.troy",true,304)];a.update();
        let r=a.world().resource::<AmbientRequests>();assert!(r.unresolved.is_empty());assert!(r.rejected.is_empty());assert_eq!(r.owner_fallbacks,vec![("prop01".into(),304)]);
        assert_eq!(r.pending.len(),1);assert_eq!(r.pending[0].request.position,[7400.,0.,7700.]);
        a.world_mut().resource_mut::<Queue>().0.clear();a.world_mut().despawn(root);a.update();
        let r=a.world().resource::<AmbientRequests>();assert_eq!(r.unresolved.len(),1);assert!(r.pending.is_empty());
    }
    #[test]
    fn fallback_orientation_matches_native_provider_captures() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/animation_owner_fallback_contract.json")).unwrap();
        for row in proof["orientation"].as_array().unwrap().iter().filter(|r|r["live"]==true && r["found"]==false){
            let input=std::array::from_fn(|i|row["input"][i].as_f64().unwrap() as f32);
            let output=openleague_core::native_actor_effect_owner::orientation(input).unwrap();
            assert_eq!(output.map(f32::to_bits),std::array::from_fn(|i|row["words"][i].as_u64().unwrap() as u32));
        }
    }
    #[test]
    fn invalid_camera_returns_shared_random_state_without_posting() {
        let mut a=app();position(&mut a,528,Some([7400.,0.,7700.]));
        a.insert_resource(crate::camera_native::NativeCamera::default());
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,528)];
        let before=a.world().resource::<AmbientRandom>().0.clone();a.update();
        let r=a.world().resource::<AmbientRequests>();assert_eq!(r.rejected.len(),1);assert!(r.logical.pending_key_calls().is_empty());assert!(r.pending.is_empty());
        let after=&a.world().resource::<AmbientRandom>().0;assert_eq!(before.words,after.words);assert_eq!((before.first,before.second),(after.first,after.second));
    }
    #[test]
    fn request_age_uses_previous_game_frame_and_freezes_while_wall_time_advances() {
        let mut a=app(); position(&mut a,528,Some([7400.,5.,7700.]));
        a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=10.;
        a.world_mut().resource_mut::<Queue>().0=vec![cue("Audio-Emitter_TT_Shopkeeper_idle.troy",true,528)]; a.update();
        a.world_mut().resource_mut::<Queue>().0.clear();
        for (game,expected) in [(10.25,0.),(12.,0.25),(12.,2.),(12.,2.),(13.,2.),(13.,3.)] {
            a.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(7));
            a.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=game;
            a.update();
            let r=a.world().resource::<AmbientRequests>();
            assert!(r.pending.is_empty());
            assert_eq!(r.logical.entry(1).unwrap().age,0.);
            assert_eq!(r.active[&("prop01".into(),528)].previous_time,game as f32);
            assert_eq!(r.active[&("prop01".into(),528)].handle(),1);
            let _=expected;
        }
    }

}

#[cfg(test)]mod stamp_tests{
 use super::*;
 #[test]fn pass_stamp_advances_without_elapsed_time_and_wraps(){
  let mut app=super::tests::app();
  for expected in 1..=3{app.update();assert_eq!(app.world().resource::<AmbientRequests>().pass_stamp,expected);}
  assert_eq!(app.world().resource::<crate::native_effect_clock::EffectClock>().now,0.);
  app.world_mut().resource_mut::<AmbientRequests>().pass_stamp=u32::MAX;app.update();assert_eq!(app.world().resource::<AmbientRequests>().pass_stamp,0);
 }
}
