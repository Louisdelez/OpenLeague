//! SOURCE ONLY. Requires separately adopted local Bevy copy-witness dependency.
//! One pending + one completed slot; no latest-report or <=2-serial acceptance.
//! Copy encoding/readback is not DrawMaterial/uniform/display-exposure proof.
use super::*;
use crate::six_gui_capture_readiness::types::{Frame,GpuReport,Owner as FrameOwner};
use bevy::{camera::NormalizedRenderTarget,render::{RenderApp,view::screenshot::{
    ScreenshotCopyRequest,ScreenshotCopyFrameSerial,ScreenshotCopySelection,
    ScreenshotCopySelections,ScreenshotCopySelected,ScreenshotCopyReceipt,ScreenshotCopySkipped}}};
use std::sync::{Arc,Mutex};

#[derive(Clone,Debug,PartialEq)]
struct Key {entity:Entity,request_id:u64,serial:u64,target:NormalizedRenderTarget,owner:FrameOwner}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
enum ProofScope {Scene,TerminalConsumer}
fn proof_scope(label:Label)->ProofScope {
    if label.scene(){ProofScope::Scene}else{ProofScope::TerminalConsumer}
}
#[derive(Clone)]
struct Frozen {
    key:Key,request:Capture,frame:Frame,selected_tick:u64,
    selected_combat:Option<CombatEvidence>,selected_spell:Option<SpellEvidence>,follow_ready:bool,
    follow_revision:Option<u64>,terminal_consumer_ready:bool,
}
struct Pending {
    entity:Entity,request:Capture,frozen:Option<Arc<Frozen>>,
    gpu:Option<Arc<GpuReport>>,fault:Option<String>,
}
struct Complete {
    entity:Entity,request:Capture,frozen:Option<Arc<Frozen>>,gpu:Option<Arc<GpuReport>>,
    receipt:Option<ScreenshotCopyReceipt>,fault:Option<String>,skip:bool,
}
#[derive(Default)]
struct Slots {pending:Option<Pending>,complete:Option<Complete>,last_id:u64,poison:Option<String>}
#[derive(Resource,Clone,Default)]
pub(crate) struct Bridge(Arc<Mutex<Slots>>);
pub(super) struct Proof {
    pub(super) verified:bool,pub(super) selected_tick:Option<u64>,
    pub(super) selected_combat:Option<CombatEvidence>,pub(super) selected_spell:Option<SpellEvidence>,pub(super) diagnostic:serde_json::Value,
}

fn owner_key(owner:Owner)->FrameOwner {
    FrameOwner {pid:std::process::id(),session:owner.session,player:owner.player,epoch:owner.epoch}
}
fn same_request(a:&Capture,b:&Capture)->bool {
    a.owner==b.owner&&a.ordinal==b.ordinal&&a.label==b.label&&a.path==b.path
        &&a.tick==b.tick&&a.result==b.result&&a.follow_revision==b.follow_revision&&a.spell_evidence==b.spell_evidence
}
fn selection_key(selection:&ScreenshotCopySelection,owner:FrameOwner)->Key {
    Key {entity:selection.entity,request_id:selection.request_id,serial:selection.frame_serial,
        target:selection.target.clone(),owner}
}
fn exact_gpu(frozen:&Frozen,selection:&ScreenshotCopySelection,report:&GpuReport)->Result<(),String> {
    let key=selection_key(selection,frozen.key.owner);
    if key!=frozen.key||key.serial==0||frozen.frame.serial!=key.serial||report.serial!=key.serial {
        return Err("copy/CPU/GPU serial or full entity/request/target differs".into());
    }
    if frozen.frame.scope.as_ref()!=Some(&report.scope)||report.scope.target!=key.target
        ||report.scope.owner!=key.owner||frozen.frame.meshes!=report.meshes||frozen.frame.ui!=report.ui {
        return Err("exact same-frame owner/scope/complete ticket vectors differ".into());
    }
    if report.draw_material_success_observed||report.visible_pixels_qualified {
        return Err("unsupported draw/pixel qualification in resource report".into());
    }
    if proof_scope(frozen.request.label)==ProofScope::Scene&&(!frozen.frame.missing.is_empty()||!report.missing.is_empty()
        ||frozen.frame.meshes.is_empty()||frozen.frame.ui.is_empty()) {
        return Err("same-frame resources missing or unsupported draw/pixel qualification".into());
    }
    Ok(())
}
fn exact_receipt(frozen:&Frozen,receipt:&ScreenshotCopyReceipt,image:&Image)->Result<(),String> {
    if selection_key(&receipt.selection,frozen.key.owner)!=frozen.key
        ||receipt.extent!=image.texture_descriptor.size||receipt.texture_format!=image.texture_descriptor.format
        ||receipt.extent.width!=1280||receipt.extent.height!=800||receipt.extent.depth_or_array_layers!=1
        ||image.data.as_ref().is_none_or(|bytes|bytes.is_empty()||bytes.len()>32*1024*1024) {
        return Err("owned copy receipt/actual delivered Image extent/format differs".into());
    }
    Ok(())
}
impl Slots {
    fn reserve(&mut self,entity:Entity,request:Capture)->Result<(),String> {
        if self.poison.is_some()||self.pending.is_some()||self.complete.is_some() {
            return Err("copy ledger unavailable: preserve existing pending/completed entry".into());
        }
        if request.ordinal==0||request.ordinal<=self.last_id {return Err("copy request id is zero or reused".into());}
        self.last_id=request.ordinal;
        self.pending=Some(Pending {entity,request,frozen:None,gpu:None,fault:None});Ok(())
    }
    fn freeze(&mut self,entity:Entity,id:u64,value:Result<Frozen,String>) {
        let Some(pending)=self.pending.as_mut() else {self.poison=Some("selection has no pending owner".into());return;};
        if pending.entity!=entity||pending.request.ordinal!=id {self.poison=Some("foreign selection key".into());return;}
        if pending.frozen.is_some() {pending.fault=Some("duplicate immutable selection".into());return;}
        match value {
            Ok(frozen) if frozen.key.entity==entity&&frozen.key.request_id==id
                &&frozen.key.owner==owner_key(pending.request.owner)&&same_request(&frozen.request,&pending.request)=>{
                pending.frozen=Some(Arc::new(frozen));
            },
            Ok(_)=>pending.fault=Some("frozen selection differs from reserved request/owner".into()),
            Err(error)=>pending.fault=Some(error),
        }
    }
    fn gpu(&mut self,key:&Key,report:Arc<GpuReport>,checked:Result<(),String>) {
        let Some(pending)=self.pending.as_mut() else{return;};
        if pending.frozen.as_ref().map(|f|&f.key)!=Some(key) {return;}
        if pending.gpu.is_some() {pending.fault=Some("duplicate same-frame GPU report".into());return;}
        match checked {Ok(())=>pending.gpu=Some(report),Err(error)=>pending.fault=Some(error)}
    }
    fn copied(&mut self,entity:Entity,request:&Capture,receipt:Option<ScreenshotCopyReceipt>,image:&Image,current:Option<Owner>)->bool {
        if let Some(complete)=self.complete.as_mut() {
            complete.fault=Some("duplicate image callback; no successful receipt retained".into());
            self.poison=Some("duplicate callback".into());return false;
        }
        let Some(pending)=self.pending.take() else {self.poison=Some("retired or unknown image callback".into());return false;};
        if pending.entity!=entity||!same_request(&pending.request,request) {
            self.pending=Some(pending);self.poison=Some("foreign callback must not retire pending owner".into());return false;
        }
        let mut fault=pending.fault;
        if current!=Some(request.owner) {fault=Some("copy callback accepted owner was retired or changed".into());}
        if fault.is_none() {
            fault=match (&pending.frozen,&pending.gpu,&receipt) {
                (Some(frozen),Some(_),Some(receipt))=>exact_receipt(frozen,receipt,image).err(),
                _=>Some("selection, exact GPU record or same-entity receipt missing".into()),
            };
        }
        self.complete=Some(Complete {entity,request:pending.request,frozen:pending.frozen,gpu:pending.gpu,receipt,fault,skip:false});true
    }
    fn skipped(&mut self,event:&ScreenshotCopySkipped) {
        if let Some(complete)=self.complete.as_mut() {
            complete.fault=Some("duplicate or late skip after completion".into());self.poison=Some("duplicate skip".into());return;
        }
        let Some(pending)=self.pending.take() else {self.poison=Some("retired or unknown skip".into());return;};
        if pending.entity!=event.entity||pending.request.ordinal!=event.request_id {
            self.pending=Some(pending);self.poison=Some("foreign skip must not retire pending owner".into());return;
        }
        let mismatch=pending.frozen.as_ref().is_some_and(|f|event.frame_serial!=Some(f.key.serial)
            ||event.target.as_ref()!=Some(&f.key.target));
        if mismatch {
            self.pending=Some(pending);self.poison=Some("foreign skip serial/target must not retire pending owner".into());return;
        }
        let reason=format!("Bevy exact-copy skipped: {:?}",event.reason);
        self.complete=Some(Complete {entity:pending.entity,request:pending.request,frozen:pending.frozen,
            gpu:pending.gpu,receipt:None,fault:Some(reason),skip:true});
    }
    fn take(&mut self,entity:Entity,request:&Capture)->Result<Complete,String> {
        let Some(complete)=self.complete.as_ref() else{return Err("completed copy record absent or retired".into());};
        if complete.entity!=entity||!same_request(&complete.request,request) {
            return Err("completed copy belongs to a foreign entity/owner/ordinal/role/path".into());
        }
        let mut complete=self.complete.take().unwrap();
        if let Some(poison)=&self.poison {complete.fault=Some(poison.clone());}
        Ok(complete)
    }
}

pub(super) fn reserve(world:&World,entity:Entity,request:&Capture)->Result<(),String> {
    let bridge=world.get_resource::<Bridge>().ok_or("opt-in copy bridge unavailable")?.clone();
    let mut slots=bridge.0.lock().map_err(|_|"copy ledger poisoned")?;
    slots.reserve(entity,request.clone())
}
fn mirror(frame:Option<Res<Frame>>,mut serial:ResMut<ScreenshotCopyFrameSerial>) {
    // A terminal consumer may have an exact scene scope while its hidden local
    // model is missing. Export the real serial; never empty/filter raw missing.
    serial.0=frame.as_ref().filter(|f|f.scope.is_some()).map(|f|f.serial).unwrap_or(0);
}
fn one_readonly<T:Component>(world:&World)->Option<Entity> {
    // Preserve ordinary query default disabling filters without creating a
    // mutable QueryState while MainWorld is held by screenshot extraction.
    let disabling=world.get_resource::<bevy::ecs::entity_disabling::DefaultQueryFilters>()
        .map(|filters|filters.disabling_ids().collect::<Vec<_>>()).unwrap_or_default();
    let mut rows=world.iter_entities().filter(|entity|entity.contains::<T>()
        &&!disabling.iter().any(|id|entity.contains_id(*id))).map(|entity|entity.id());
    let value=rows.next()?;rows.next().is_none().then_some(value)
}
fn camera_follow_readonly(world:&World,host:&Host,accepted:Owner)->bool {
    let Some(window)=one_readonly::<bevy::window::PrimaryWindow>(world).filter(|e|world.get::<Window>(*e).is_some())else{return false;};
    let expected=crate::camera_lock::Owner {pid:std::process::id(),session:accepted.session,
        player:accepted.player,epoch:accepted.epoch,primary_window:window};
    let Some(setting)=world.get_resource::<crate::camera_lock::Setting>()else{return false;};
    let Some(revision)=host.camera_revision else{return false;};
    setting.owner()==Some(expected)&&setting.available()&&setting.locked()&&setting.revision()==revision
        &&setting.last_origin()==host.camera_acquisition_ordinal.map(crate::camera_lock::Origin::Observer)
        &&world.get_resource::<FollowSample>().is_some_and(|sample|follow_matches(expected,revision,sample))
}
fn consumer_ready(world:&World,label:Label)->bool {
    match label {
        Label::Baseline|Label::Combat|Label::SpellW|Label::SpellE|Label::SpellR=>true,
        Label::Splash=>!world.resource::<crate::native_endgame_ui::View>().dismissed
            &&one_readonly::<crate::native_endgame_ui::Splash>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display!=Display::None),
        Label::Results=>world.resource::<crate::native_endgame_ui::View>().dismissed
            &&one_readonly::<crate::match_results_ui::ResultsPanel>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display!=Display::None)
            &&one_readonly::<crate::native_endgame_ui::Splash>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display==Display::None),
    }
}
fn scope_json(scope:&crate::six_gui_capture_readiness::types::Scope)->serde_json::Value {
    // Exact existing request-token scope representation, with no Shared/latest
    // report read and no new mutable access to the readiness producer.
    serde_json::json!({"owner":{"pid":scope.owner.pid,"session":scope.owner.session,"player":scope.owner.player,"epoch":scope.owner.epoch},
        "team":scope.team,"window":scope.window.to_bits(),"camera":scope.camera.to_bits(),"target":format!("{:?}",scope.target),
        "model_root":scope.model_root.to_bits(),"map_root":scope.map_root.to_bits(),"model":format!("{:?}",scope.model),"map":format!("{:?}",scope.map),
        "model_scene":format!("{:?}",scope.model_scene),"map_scene":format!("{:?}",scope.map_scene),
        "model_instance":format!("{:?}",scope.model_instance),"map_instance":format!("{:?}",scope.map_instance),
        "scene_FoW_output":format!("{:?}",scope.visibility_output)})
}
fn freeze(world:&World,event:&ScreenshotCopySelected)->Result<Frozen,String> {
    let request=world.get::<Capture>(event.entity).ok_or("selected request component retired")?.clone();
    let host=world.get_resource::<Host>().ok_or("selected Host absent")?;
    let snapshot=world.resource::<crate::Match>().snapshot.as_ref().ok_or("selected received snapshot absent")?;
    let frame=world.get_resource::<Frame>().ok_or("selected CPU frame absent")?.clone();
    let scope=frame.scope.as_ref().ok_or("selected CPU scope unavailable")?;
    let key=selection_key(&event.selection,owner_key(request.owner));
    if event.entity!=event.selection.entity||key.request_id!=request.ordinal||key.serial==0
        ||frame.serial!=key.serial||frame.source_tick!=Some(snapshot.tick)||scope.target!=key.target
        ||scope.owner!=key.owner||owner(world.resource::<crate::Connection>())!=Some(request.owner)
        ||snapshot.session!=request.owner.session||snapshot.tick<request.tick
        ||host.owner!=Some(request.owner)||host.pending_capture!=Some(request.label)
        ||request.ordinal>=host.next_request||!host.captures.contains(request.label.name())
        ||request.path!=host.directory.join(format!("{}.png",request.label.name())) {
        return Err("selected exact CPU frame/request/owner/session/target/source tick differs".into());
    }
    let scene=request.label.scene();
    if scene&&!frame.missing.is_empty() {return Err("selected scene CPU resource census missing".into());}
    if scene&&request.resource_token.as_ref().and_then(|token|token.get("scope"))!=Some(&scope_json(scope)) {
        return Err("request scene scope differs from immutable selected-frame scope".into());
    }
    let follow_ready=camera_follow_readonly(world,host,request.owner);
    if scene&&(request.follow_revision!=host.camera_revision||!follow_ready) {
        return Err("selected normal camera follow/revision changed".into());
    }
    let selected_combat=if request.label==Label::Combat {combat_evidence(snapshot,request.owner,Some(request.owner))}else{None};
    let selected_spell=spell_evidence(request.label,snapshot,request.owner,Some(request.owner));
    if !spell_selection_matches(request.label,request.spell_evidence,selected_spell,snapshot.tick)
        ||request.result.map(|key|terminal(snapshot,request.owner)==Ok(key))
        .unwrap_or(snapshot.winner.is_none()&&snapshot.result.is_none())==false
        ||(request.label==Label::Combat&&selected_combat.is_none())||!consumer_ready(world,request.label) {
        return Err("selected copied-frame combat phase or terminal result/consumer unavailable".into());
    }
    Ok(Frozen {key,request,frame,selected_tick:snapshot.tick,selected_combat,selected_spell,
        follow_ready,follow_revision:host.camera_revision,terminal_consumer_ready:true})
}
fn selected(event:On<ScreenshotCopySelected>,world:&World) {
    if world.get::<Capture>(event.entity).is_none(){return;}
    let value=freeze(world,&event); // Read-only MainWorld and clone before taking bridge lock.
    if let Some(bridge)=world.get_resource::<Bridge>() {
        if let Ok(mut slots)=bridge.0.lock(){slots.freeze(event.entity,event.selection.request_id,value);}
    }
}
fn skipped(event:On<ScreenshotCopySkipped>,world:&World) {
    if world.get::<Capture>(event.entity).is_none(){return;}
    if let Some(bridge)=world.get_resource::<Bridge>() {if let Ok(mut slots)=bridge.0.lock(){slots.skipped(&event);}}
}
pub(crate) fn observe_gpu(world:&World,report:&GpuReport) {
    let Some(bridge)=world.get_resource::<Bridge>().cloned()else{return;};
    let Some(selections)=world.get_resource::<ScreenshotCopySelections>()else{return;};
    let values=selections.iter().map(|(_,selection)|selection.clone()).collect::<Vec<_>>();
    let frozen=bridge.0.lock().ok().and_then(|s|s.pending.as_ref().and_then(|p|p.frozen.clone()));
    let Some(frozen)=frozen else{return;};
    for selection in values {
        if selection.entity!=frozen.key.entity {continue;}
        let checked=exact_gpu(&frozen,&selection,report); // Full vector equality outside bridge lock.
        let report=Arc::new(report.clone());
        if let Ok(mut slots)=bridge.0.lock(){slots.gpu(&frozen.key,report,checked);}
    }
}
pub(super) fn delivered(world:&World,entity:Entity,image:&Image)->bool {
    let Some(request)=world.get::<Capture>(entity).cloned()else{return false;};
    let receipt=world.get::<ScreenshotCopyReceipt>(entity).cloned();
    let current=owner(world.resource::<crate::Connection>());
    let Some(bridge)=world.get_resource::<Bridge>()else{return false;};
    bridge.0.lock().map(|mut slots|slots.copied(entity,&request,receipt,image,current)).unwrap_or(false)
}
fn proof(complete:Complete)->Proof {
    let verified=!complete.skip&&complete.fault.is_none()&&complete.frozen.is_some()&&complete.gpu.is_some()&&complete.receipt.is_some()
        &&complete.frozen.as_ref().is_some_and(|f|spell_selection_matches(f.request.label,f.request.spell_evidence,f.selected_spell,f.selected_tick));
    let frozen=complete.frozen.as_ref();
    let receipt=complete.receipt.as_ref();
    let scene=proof_scope(complete.request.label)==ProofScope::Scene;
    Proof {verified,selected_tick:frozen.map(|f|f.selected_tick),selected_combat:frozen.and_then(|f|f.selected_combat),selected_spell:frozen.and_then(|f|f.selected_spell),
        diagnostic:serde_json::json!({"schema":"six_GUI_exact_copy_frame_join/v1","verified":verified,"failure":complete.fault,
            "proof_scope":if scene{"scene"}else{"terminal_consumer"},
            "scene_resources_qualified":verified&&scene,"terminal_widget_GPU_readiness_qualified":false,
            "raw_CPU_missing":frozen.map(|f|f.frame.missing.clone()),"raw_GPU_missing":complete.gpu.as_ref().map(|g|g.missing.clone()),
            "terminal_scene_missing_is_diagnostic_not_filtered":!scene,
            "full_entity_bits":complete.entity.to_bits(),"request_id":complete.request.ordinal,
            "selected_spell_evidence":frozen.and_then(|f|f.selected_spell),"spell_state_only_not_pose_or_model_proof":true,
            "selected_tick":frozen.map(|f|f.selected_tick),"selected_CPU_source_tick":frozen.and_then(|f|f.frame.source_tick),
            "selected_CPU_serial":frozen.map(|f|f.frame.serial),"GPU_serial":complete.gpu.as_ref().map(|g|g.serial),
            "copy_receipt_serial":receipt.map(|r|r.selection.frame_serial),
            "normalized_target":frozen.map(|f|format!("{:?}",f.key.target)),
            "scope_owner":frozen.map(|f|serde_json::json!({"pid":f.key.owner.pid,"session":f.key.owner.session,"player":f.key.owner.player,"epoch":f.key.owner.epoch})),
            "selected_scope":frozen.and_then(|f|f.frame.scope.as_ref().map(scope_json)),
            "complete_CPU_mesh_count":frozen.map(|f|f.frame.meshes.len()),"complete_CPU_UI_count":frozen.map(|f|f.frame.ui.len()),
            "exact_scope_and_complete_ticket_vectors_compared":verified,"fresh2_or_latest_report_used":false,
            "selected_normal_follow_ready":frozen.map(|f|f.follow_ready),"selected_follow_revision":frozen.and_then(|f|f.follow_revision),
            "selected_terminal_consumer_ready":frozen.map(|f|f.terminal_consumer_ready),
            "extent":receipt.map(|r|[r.extent.width,r.extent.height,r.extent.depth_or_array_layers]),
            "texture_format":receipt.map(|r|format!("{:?}",r.texture_format)),
            "same_owned_Delivery_Image_and_receipt":verified,"DrawMaterial_or_uniform_content_or_exposure_or_pixels_qualified":false})}
}
pub(super) fn take(world:&World,entity:Entity,request:&Capture)->Result<Proof,String> {
    let bridge=world.get_resource::<Bridge>().ok_or("copy bridge absent")?.clone();
    let complete=bridge.0.lock().map_err(|_|"copy bridge poisoned")?.take(entity,request)?;
    Ok(proof(complete))
}
pub(super) fn drain_skips(world:&mut World,host:&mut Host) {
    let Some(bridge)=world.get_resource::<Bridge>().cloned()else{return;};
    let (poison,skipped,pending)=match bridge.0.lock() {
        Ok(slots)=>(slots.poison.clone(),slots.complete.as_ref().filter(|c|c.skip).map(|c|(c.entity,c.request.clone())),
            slots.pending.as_ref().map(|p|(p.entity,p.request.clone()))),
        Err(_)=>{fail(host,"copy bridge mutex poisoned".into());return;},
    };
    if let Some(error)=poison {fail(host,error);return;}
    if let Some((entity,request))=pending {
        if host.pending_capture!=Some(request.label)||host.owner!=Some(request.owner)
            ||owner(world.resource::<crate::Connection>())!=Some(request.owner)
            ||!world.get::<Capture>(entity).is_some_and(|c|same_request(c,&request)) {
            let error="pending copy entity/request or accepted owner retired".to_string();
            if let Ok(mut slots)=bridge.0.lock(){slots.poison=Some(error.clone());}
            fail(host,error);return;
        }
    }
    let Some((entity,request))=skipped else{return;};
    if host.pending_capture!=Some(request.label)||host.owner!=Some(request.owner)
        ||owner(world.resource::<crate::Connection>())!=Some(request.owner)
        ||!world.get::<Capture>(entity).is_some_and(|c|same_request(c,&request)) {
        fail(host,"skipped copy no longer binds exact pending owner/request".into());return;
    }
    match take(world,entity,&request) {
        Ok(proof)=>{
            host.pending_capture=None;host.captures.remove(request.label.name());
            row(host,"framebuffer_deferred",serde_json::json!({"ordinal":request.ordinal,"label":request.label,
                "reason":"actual one-shot copy skipped","recoverable":true,"image_saved":false,
                "copy_frame_join":proof.diagnostic,"visible_pixels_qualified":false}));
            if let Ok(mut entity)=world.get_entity_mut(entity){entity.remove::<Capture>();}
        },Err(error)=>fail(host,error),
    }
}
pub(super) fn install(app:&mut App) {
    let bridge=Bridge::default();
    app.insert_resource(bridge.clone()).init_resource::<ScreenshotCopyFrameSerial>()
        .add_systems(PostUpdate,mirror.after(crate::six_gui_capture_readiness::Collect))
        .add_observer(selected).add_observer(skipped);
    app.sub_app_mut(RenderApp).insert_resource(bridge);
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::six_gui_capture_readiness::types::{Scope,MeshTicket,MeshRole,MeshMaterial,UiTicket,UiRole,UiMaterial};
    use bevy::render::render_resource::{Extent3d,TextureFormat};
    struct Fixture {request:Capture,frozen:Frozen,selection:ScreenshotCopySelection,gpu:GpuReport,receipt:ScreenshotCopyReceipt,image:Image}
    fn fixture()->Fixture {
        // Synthetic CPU identity/transport fixture. No app/window/renderer/network/files.
        let mut world=World::new();let entity=world.spawn_empty().id();
        let window=world.spawn_empty().id();let camera=world.spawn_empty().id();let draw=world.spawn_empty().id();
        let owner=Owner {session:11,player:21,epoch:Some(2)};
        let mut instances=bevy::world_serialization::WorldInstanceSpawner::default();
        let model_instance=instances.spawn(Handle::<bevy::world_serialization::WorldAsset>::default());
        let map_instance=instances.spawn(Handle::<bevy::world_serialization::WorldAsset>::default());
        let target=bevy::camera::RenderTarget::Window(bevy::window::WindowRef::Entity(window)).normalize(Some(window)).unwrap();
        let scope=Scope {owner:owner_key(owner),team:0,window,camera,target:target.clone(),model_root:draw,map_root:window,
            model:Handle::<Gltf>::default().id(),map:Handle::<Gltf>::default().id(),
            model_scene:Handle::<bevy::world_serialization::WorldAsset>::default().id(),
            map_scene:Handle::<bevy::world_serialization::WorldAsset>::default().id(),model_instance,map_instance,
            visibility_output:Handle::<Image>::default().id()};
        let mesh=MeshTicket {role:MeshRole::LocalModel,draw,mesh:Handle::<Mesh>::default().id(),
            material:MeshMaterial::Fog(Handle::<crate::map_fog::FogMaterial>::default().id()),
            images:vec![Handle::<Image>::default().id()],native_visibility:Some(scope.visibility_output),skin:None,standard_source:None};
        let ui=UiTicket {role:UiRole::Glyph,draw:camera,material:UiMaterial::Font(Handle::<crate::native_font_material::FontMaterial>::default().id()),images:vec![Handle::<Image>::default().id()]};
        let frame=Frame {serial:19,source_tick:Some(77),scope:Some(scope.clone()),missing:vec![],meshes:vec![mesh],ui:vec![ui]};
        let request=Capture {owner,tick:75,result:None,label:Label::Combat,path:PathBuf::from("E:/OpenLeague/logs/synthetic-source-only/combat.png"),
            ordinal:7,resource_token:None,follow_revision:Some(3),combat_evidence:None,spell_evidence:None};
        let selection=ScreenshotCopySelection {entity,request_id:7,frame_serial:19,target};
        let frozen=Frozen {key:selection_key(&selection,scope.owner),request:request.clone(),frame:frame.clone(),selected_tick:77,
            selected_combat:Some(CombatEvidence::AuthoritativeWindup {source:21,target:22,started:76,release:79,snapshot_tick:77}),
            selected_spell:None,follow_ready:true,follow_revision:Some(3),terminal_consumer_ready:true};
        let gpu=GpuReport {serial:19,scope,meshes:frame.meshes,ui:frame.ui,missing:vec![],observations:serde_json::Value::Null,
            draw_material_success_observed:false,visible_pixels_qualified:false};
        let receipt=ScreenshotCopyReceipt {selection:selection.clone(),extent:Extent3d {width:1280,height:800,depth_or_array_layers:1},texture_format:TextureFormat::Rgba8Unorm};
        let mut image=Image::default();image.texture_descriptor.size=receipt.extent;image.texture_descriptor.format=receipt.texture_format;
        image.data=Some(vec![0;1280*800*4]);
        Fixture {request,frozen,selection,gpu,receipt,image}
    }
    fn pending(f:&Fixture)->Slots {
        let mut slots=Slots::default();slots.reserve(f.selection.entity,f.request.clone()).unwrap();
        slots.freeze(f.selection.entity,f.request.ordinal,Ok(f.frozen.clone()));slots
    }
    fn gpu(slots:&mut Slots,f:&Fixture) {
        slots.gpu(&f.frozen.key,Arc::new(f.gpu.clone()),exact_gpu(&f.frozen,&f.selection,&f.gpu));
    }
    #[test]
    fn copy_join_exact_serial_scope_owner_and_complete_ticket_vectors_reject_fresh2_aliases() {
        let f=fixture();assert!(exact_gpu(&f.frozen,&f.selection,&f.gpu).is_ok());
        for field in 0..10 {
            let mut report=f.gpu.clone();match field {
                0=>report.serial-=1,1=>report.serial+=1,2=>report.scope.owner.pid+=1,
                3=>report.scope.owner.session+=1,4=>report.scope.owner.player+=1,
                5=>report.scope.owner.epoch=None,6=>report.meshes[0].images.clear(),
                7=>report.ui[0].images.clear(),8=>report.missing.push("not-ready".into()),
                _=>report.scope.camera=report.scope.window,
            }assert!(exact_gpu(&f.frozen,&f.selection,&report).is_err(),"foreign field {field}");
        }
    }
    #[test]
    fn copy_join_receipt_requires_exact_entity_request_serial_target_extent_format_and_image() {
        let f=fixture();assert!(exact_receipt(&f.frozen,&f.receipt,&f.image).is_ok());
        for field in 0..6 {
            let mut receipt=f.receipt.clone();match field {
                0=>receipt.selection.entity=f.gpu.scope.camera,1=>receipt.selection.request_id+=1,
                2=>receipt.selection.frame_serial+=1,3=>receipt.extent.width-=1,
                4=>receipt.texture_format=TextureFormat::Bgra8Unorm,
                _=>receipt.selection.target=bevy::camera::RenderTarget::Window(bevy::window::WindowRef::Entity(f.gpu.scope.camera)).normalize(Some(f.gpu.scope.camera)).unwrap(),
            }assert!(exact_receipt(&f.frozen,&receipt,&f.image).is_err());
        }
        let mut absent=f.image.clone();absent.data=None;assert!(exact_receipt(&f.frozen,&f.receipt,&absent).is_err());
    }
    #[test]
    fn copy_join_one_completed_copy_retains_original_frozen_tick_not_later_gpu_and_consumes_once() {
        let f=fixture();let mut slots=pending(&f);gpu(&mut slots,&f);
        assert!(slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));
        let mut later=f.gpu.clone();later.serial+=1;
        slots.gpu(&f.frozen.key,Arc::new(later),Err("later report is not this copy".into()));
        let proof=proof(slots.take(f.selection.entity,&f.request).unwrap());assert!(proof.verified);
        assert_eq!(proof.selected_tick,Some(77));assert_eq!(proof.diagnostic["GPU_serial"],19);
        assert!(slots.take(f.selection.entity,&f.request).is_err());
    }
    #[test]
    fn copy_join_duplicate_selection_gpu_or_image_never_retains_success() {
        let f=fixture();
        for duplicate in 0..3 {
            let mut slots=pending(&f);gpu(&mut slots,&f);
            if duplicate==0 {slots.freeze(f.selection.entity,7,Ok(f.frozen.clone()));}
            if duplicate==1 {gpu(&mut slots,&f);}
            assert!(slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));
            if duplicate==2 {assert!(!slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));}
            assert!(!proof(slots.take(f.selection.entity,&f.request).unwrap()).verified);
        }
    }
    #[test]
    fn copy_join_missing_selection_gpu_or_receipt_stays_unqualified() {
        let f=fixture();
        for missing in 0..3 {
            let mut slots=Slots::default();slots.reserve(f.selection.entity,f.request.clone()).unwrap();
            if missing!=0 {slots.freeze(f.selection.entity,7,Ok(f.frozen.clone()));}
            if missing!=1 {gpu(&mut slots,&f);}
            let receipt=if missing==2 {None}else{Some(f.receipt.clone())};
            assert!(slots.copied(f.selection.entity,&f.request,receipt,&f.image,Some(f.request.owner)));
            assert!(!proof(slots.take(f.selection.entity,&f.request).unwrap()).verified);
        }
    }
    #[test]
    fn copy_join_skip_consumes_only_matching_request_and_never_claims_an_image() {
        use bevy::render::view::screenshot::ScreenshotCopySkipReason;
        let f=fixture();let mut slots=pending(&f);
        let event=ScreenshotCopySkipped {entity:f.selection.entity,request_id:7,frame_serial:Some(19),target:Some(f.selection.target.clone()),reason:ScreenshotCopySkipReason::MissingSwapChainView};
        slots.skipped(&event);assert!(slots.pending.is_none());
        let complete=slots.take(f.selection.entity,&f.request).unwrap();assert!(complete.skip);assert!(complete.receipt.is_none());assert!(!proof(complete).verified);
        let mut foreign=pending(&f);let mut wrong=event.clone();wrong.request_id=8;
        foreign.skipped(&wrong);assert!(foreign.pending.is_some());assert!(foreign.complete.is_none());
        let mut foreign=pending(&f);let mut wrong=event.clone();wrong.frame_serial=Some(20);
        foreign.skipped(&wrong);assert!(foreign.pending.is_some());assert!(foreign.complete.is_none());
    }
    #[test]
    fn copy_join_retired_owner_epoch_and_full_entity_generation_are_rejected() {
        let f=fixture();
        let mut foreign=Slots::default();foreign.reserve(f.selection.entity,f.request.clone()).unwrap();
        let mut frozen=f.frozen.clone();frozen.key.owner.epoch=Some(3);
        foreign.freeze(f.selection.entity,7,Ok(frozen));assert!(foreign.pending.as_ref().unwrap().frozen.is_none());
        assert!(foreign.pending.as_ref().unwrap().fault.is_some());
        for current in [None,Some(Owner {epoch:Some(3),..f.request.owner})] {
            let mut slots=pending(&f);gpu(&mut slots,&f);
            assert!(slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,current));
            assert!(!proof(slots.take(f.selection.entity,&f.request).unwrap()).verified);
        }
        let mut world=World::new();let old=world.spawn_empty().id();world.despawn(old);let new=world.spawn_empty().id();assert_ne!(old,new);
        let mut slots=Slots::default();slots.reserve(new,f.request.clone()).unwrap();
        assert!(!slots.copied(old,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));assert_eq!(slots.pending.as_ref().unwrap().entity,new);
    }
    #[test]
    fn copy_join_request_ids_cannot_reuse_or_overwrite_either_bounded_slot() {
        let f=fixture();let mut slots=pending(&f);assert!(slots.reserve(f.gpu.scope.camera,f.request.clone()).is_err());gpu(&mut slots,&f);
        assert!(slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));
        assert!(slots.reserve(f.gpu.scope.camera,f.request.clone()).is_err());slots.take(f.selection.entity,&f.request).unwrap();
        assert!(slots.reserve(f.gpu.scope.camera,f.request.clone()).is_err());
        let mut next=f.request.clone();next.ordinal=8;assert!(slots.reserve(f.gpu.scope.camera,next).is_ok());
    }
    #[test]
    fn copy_join_readonly_unique_lookup_preserves_default_and_custom_disabling_filters() {
        #[derive(Component)]struct OtherDisabled;
        let mut world=World::new();let live=world.spawn(bevy::window::PrimaryWindow).id();
        assert_eq!(one_readonly::<bevy::window::PrimaryWindow>(&world),Some(live));
        world.spawn((bevy::window::PrimaryWindow,bevy::ecs::entity_disabling::Disabled));
        assert_eq!(one_readonly::<bevy::window::PrimaryWindow>(&world),Some(live));
        world.register_disabling_component::<OtherDisabled>();world.spawn((bevy::window::PrimaryWindow,OtherDisabled));
        assert_eq!(one_readonly::<bevy::window::PrimaryWindow>(&world),Some(live));
        world.spawn(bevy::window::PrimaryWindow);assert!(one_readonly::<bevy::window::PrimaryWindow>(&world).is_none());
    }
    #[test]
    fn copy_join_mirror_preserves_terminal_missing_but_absent_frame_or_scope_never_exports_stale_serial() {
        use bevy::ecs::system::RunSystemOnce;
        // CPU system test only. No real extraction/window/terminal UI or GPU.
        let f=fixture();let mut world=World::new();world.init_resource::<ScreenshotCopyFrameSerial>();
        world.insert_resource(f.frozen.frame.clone());world.run_system_once(mirror).unwrap();
        assert_eq!(world.resource::<ScreenshotCopyFrameSerial>().0,19);
        world.resource_mut::<Frame>().missing.push("terminal scene census unavailable".into());
        world.run_system_once(mirror).unwrap();assert_eq!(world.resource::<ScreenshotCopyFrameSerial>().0,19);
        assert_eq!(world.resource::<Frame>().missing,vec!["terminal scene census unavailable"]);
        world.resource_mut::<Frame>().missing.clear();world.resource_mut::<Frame>().scope=None;
        world.run_system_once(mirror).unwrap();assert_eq!(world.resource::<ScreenshotCopyFrameSerial>().0,0);
        world.remove_resource::<Frame>();world.run_system_once(mirror).unwrap();
        assert_eq!(world.resource::<ScreenshotCopyFrameSerial>().0,0);
    }
    #[test]
    fn copy_join_terminal_scope_retains_raw_scene_missing_without_claiming_widget_GPU_readiness() {
        let mut f=fixture();f.frozen.frame.missing=vec!["local model hidden".into()];
        f.gpu.missing=vec!["local skin not drawn in terminal".into()];
        assert!(exact_gpu(&f.frozen,&f.selection,&f.gpu).is_err());
        f.request.label=Label::Results;f.request.result=Some((77,0));f.frozen.request=f.request.clone();f.frozen.selected_combat=None;
        assert!(exact_gpu(&f.frozen,&f.selection,&f.gpu).is_ok());
        let mut wrong=f.gpu.clone();wrong.scope.owner.epoch=Some(3);
        assert!(exact_gpu(&f.frozen,&f.selection,&wrong).is_err());
        let mut slots=pending(&f);gpu(&mut slots,&f);
        assert!(slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));
        let proof=proof(slots.take(f.selection.entity,&f.request).unwrap());assert!(proof.verified);
        assert_eq!(proof.diagnostic["proof_scope"],"terminal_consumer");
        assert_eq!(proof.diagnostic["scene_resources_qualified"],false);
        assert_eq!(proof.diagnostic["terminal_widget_GPU_readiness_qualified"],false);
        assert_eq!(proof.diagnostic["raw_CPU_missing"],serde_json::json!(["local model hidden"]));
        assert_eq!(proof.diagnostic["raw_GPU_missing"],serde_json::json!(["local skin not drawn in terminal"]));
    }

    fn spell_case(label:Label,tick:u64)->SpellEvidence {
        match label {
            Label::SpellW=>SpellEvidence::FrozenDomain{source:21,rank:1,starts:70,until:310,center:Point{x:100.,z:100.},snapshot_tick:tick},
            Label::SpellE=>SpellEvidence::Pillar{source:21,starts:70,until:250,center:Point{x:200.,z:100.},snapshot_tick:tick},
            Label::SpellR=>SpellEvidence::Subjugate{source:21,target:22,rank:1,starts:70,until:310,pulses:0,snapshot_tick:tick},
            _=>panic!("spell source fixture only"),
        }
    }
    #[test]
    fn copy_join_spell_roles_keep_scene_census_and_selected_facts_not_late_callback_phase() {
        for label in [Label::SpellW,Label::SpellE,Label::SpellR] {
            let mut f=fixture();f.request.label=label;f.request.path=PathBuf::from(format!("E:/OpenLeague/logs/synthetic-source-only/{}.png",label.name()));
            f.request.spell_evidence=Some(spell_case(label,75));f.frozen.request=f.request.clone();f.frozen.selected_combat=None;
            f.frozen.selected_spell=Some(spell_case(label,77));
            let mut slots=pending(&f);gpu(&mut slots,&f);
            assert!(slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));
            let proof=proof(slots.take(f.selection.entity,&f.request).unwrap());assert!(proof.verified);
            assert_eq!(proof.selected_spell,Some(spell_case(label,77)));assert_eq!(proof.selected_tick,Some(77));
            assert_eq!(proof.diagnostic["proof_scope"],"scene");assert_eq!(proof.diagnostic["selected_spell_evidence"],serde_json::to_value(spell_case(label,77)).unwrap());
            assert_eq!(proof.diagnostic["DrawMaterial_or_uniform_content_or_exposure_or_pixels_qualified"],false);
        }
    }
    #[test]
    fn copy_join_spell_missing_wrong_effect_tick_serial_or_resources_never_qualify_and_combat_stays_distinct() {
        for case in 0..6 {
            let mut f=fixture();f.request.label=Label::SpellE;f.request.spell_evidence=Some(spell_case(Label::SpellE,75));
            f.frozen.request=f.request.clone();f.frozen.selected_combat=None;f.frozen.selected_spell=Some(spell_case(Label::SpellE,77));
            match case {0=>f.frozen.selected_spell=None,1=>f.frozen.selected_spell=Some(spell_case(Label::SpellW,77)),
                2=>f.frozen.selected_spell=Some(spell_case(Label::SpellE,78)),3=>f.gpu.serial+=1,4=>f.gpu.missing.push("pillar-resource-diagnostic".into()),
                _=>{f.request.spell_evidence=Some(spell_case(Label::SpellW,75));f.frozen.request=f.request.clone();f.frozen.selected_spell=Some(spell_case(Label::SpellW,77));}};
            let mut slots=pending(&f);gpu(&mut slots,&f);
            assert!(slots.copied(f.selection.entity,&f.request,Some(f.receipt.clone()),&f.image,Some(f.request.owner)));
            assert!(!proof(slots.take(f.selection.entity,&f.request).unwrap()).verified);
        }
        let f=fixture();assert_eq!(f.request.label,Label::Combat);assert!(f.frozen.selected_combat.is_some());assert!(f.frozen.selected_spell.is_none());
        assert_eq!(proof_scope(Label::Combat),ProofScope::Scene);assert_eq!(proof_scope(Label::Results),ProofScope::TerminalConsumer);
    }

}

