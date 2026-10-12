//! Normal Annie Q projection. Verified native arithmetic plus an explicit reconstructed owner adapter.
use crate::{annie_q_vfx::Flights, projected_render::ProjectedMaterial, projected_surface::TerrainProjection,
    projected_terrain::TerrainSurfaces, native_projected_parent::{Parent,Input as ParentInput}, simple_owner_pose::SimpleOwnerPose,
    simple_projected_config::SimpleProjectedConfig, simple_system::SimpleSystemState, projected_inputs::ProjectionInputs, terrain_material, Match};
use bevy::prelude::*;
use std::collections::{HashMap,HashSet};
type Key=(u32,u32,u64);
// Local zero-viewport adapter, not a recovered native camera producer.
// The constant negative half-space rejects all finite bounds, while the native
// parent still receives stop/owner-loss updates and runs its hidden-frame path.
fn empty_view_packet()->openleague_core::native_troy_scratch::Scratch {
    let mut packet=openleague_core::native_troy_scratch::Scratch::default();
    packet.set_visibility_inputs([[0,0,0,(-1f32).to_bits()];6],[[0,1,2];6]);
    packet
}
fn config()->Result<SimpleProjectedConfig,String> {
    let document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).map_err(|e|e.to_string())?;
    let c=SimpleProjectedConfig::from_troy(&document,"Projected")?;
    if c.single_particle!=1 || c.simple_orientation!=0 || c.texture!="disintegrate-light.dds" {return Err("unsupported normal projected emitter variant".into());}
    if c.owner_scale_coefficients.iter().any(|v|*v!=0.) {return Err("nonzero owner scale coefficients need qualified runtime owner-factor producers".into());}
    Ok(c)
}
// Native default wrapper9283F0: origin0, scale1, offset0.
// Source is the native QPC/GameClock resource; historical frame scheduling and pause remain open.
fn native_time(source:f64)->Result<f32,&'static str>{
 openleague_core::native_troy_clock::Clock{origin:0.,scale:1.,offset:0.}.sample(Some(source))
}
// Concrete projectile owner orientation719D20, gated by actual Troy flags.
// Native moving position is passed without a /20 then *20 coordinate round-trip.
fn native_pose(position:Vec3,direction:Vec3,flags:u32,mut matrix:Mat4,extent:f32)->Result<SimpleOwnerPose,&'static str>{
    if flags&0x10!=0 && flags&0x20==0 {
        let (ok,m)=openleague_core::native_missile_effect_owner::orientation(Some(direction.to_array()))?;
        if ok {matrix=Mat4::from_cols_array(&m);}
    }
    SimpleOwnerPose::new(position,matrix,extent)
}
// Native simple factor constructor9414A9 sets E0=1;93FB60 second-child loop
// preserves it for Annie's authored/default zero p-flexscale gate.
fn update_owner_scale(child:&mut openleague_core::native_troy_scalar::Child,radius:f32)->u32 {
    openleague_core::native_troy_scalar::apply(radius.to_bits(),0,1f32.to_bits(),1f32.to_bits(),&mut [],std::slice::from_mut(child))
}
// Native load sets12C=1; deferred registry44 resets maskFFFFFFFF before activation.
// The local adapter starts after this initialization stage (12 composed native cases).
// Root/team inputs are explicit adapters until their native producers are integrated.
#[derive(Debug)]
struct OwnerVisibility {enabled:bool,mode:u32,mask:u32,suppression:u8}
impl OwnerVisibility {
 fn initialized()->Self {Self{enabled:false,mode:1,mask:u32::MAX,suppression:1}}
 fn update(&mut self,root_filter:bool,team:Option<u32>,provider_visible:Option<bool>) {
  let visible=openleague_core::native_projectile_owner_properties::projectile_team_visible(0x212,root_filter,team,self.mask);
  self.suppression=openleague_core::native_projectile_owner_properties::source_suppression(self.enabled,self.mode,visible,provider_visible);
 }
 fn activate(&mut self,root_filter:bool,team:Option<u32>,provider_visible:Option<bool>) {
  self.enabled=true;self.update(root_filter,team,provider_visible);
 }
 fn deactivate(&mut self) {self.enabled=false;}
 fn draw_visible(&self)->bool {
  // Bevy supplies camera culling separately. Only native suppression is consumed here.
  openleague_core::native_troy_frame_gate::source_visible(true,0,(self.suppression&1)<<3)
 }
}
struct Lifetime {trace:Vec<serde_json::Value>,captured_phases:HashSet<&'static str>,visibility:OwnerVisibility,parent:Parent,config_flags:u32,build_up:f32,radius:f32,rate:f32,system:SimpleSystemState,wrapper:openleague_core::native_projectile_stop_dispatch::Wrapper,requests:u32,pose_flags:u32,pose_matrix:Mat4,owner_position:Vec3,owner_direction:Vec3,scale_child:openleague_core::native_troy_scalar::Child}
impl Lifetime {
    fn new(native_position:Vec3,c:&SimpleProjectedConfig,initialized_at:f64)->Result<Self,&'static str> {
        // Original missile7172B0 uses flags0 and the fresh wrapper has pending flags0.
        let mut setup=openleague_core::native_projectile_factory_pose::Setup::load(0,0,native_position.to_array(),true)?;
        setup.first_update(true);
        let pose_matrix=Mat4::from_cols_array(&setup.troy_matrix.map(f32::from_bits));
        let pose=native_pose(Vec3::from_array(setup.troy_position.map(f32::from_bits)),Vec3::ZERO,setup.troy_flags,pose_matrix,c.scale)?;
        // Supplied logical RNG seed; native global owner/RNG population remains unqualified.
        // Deferred wrapper44 supplies the initialization clock through Troy118/request200.
        let clock=native_time(initialized_at)?;
        let started=openleague_core::native_troy_resource_initial::start(clock,0.,0.)?;
        let start=f32::from_bits(started.clock_words[0]);
        let parent=Parent::new(start,&pose,c)?;
        let document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).map_err(|_|"invalid Annie resource")?;
        let system=&document["sections"]["System"];
        use openleague_core::native_troy_simulation_flags as settings;
        let config_flags=settings::apply_simulate_offscreen(settings::apply_simulate_every_frame(0,system)?,system)?;
        let build_up=settings::build_up_time(system)?;
        let radius=f32::from_bits(openleague_core::native_troy_position_bounds::Config::from_decoded_system(system)?.group_vis_bits);
        // Explicit local quality3 until historical graphics options are connected.
        let rate=f32::from_bits(settings::engine_timing_words(3)[0]);
        let mut visibility=OwnerVisibility::initialized();
        // Local effect creation invokes native activation; original registry caller remains open.
        // Global team filter disabled is the supplied local profile, not a recovered FOW producer.
        visibility.activate(false,None,Some(true));
        Ok(Self{trace:Vec::new(),captured_phases:HashSet::new(),visibility,parent,config_flags,build_up,radius,rate,system:SimpleSystemState{flags:1,start_time:start,stop_time:0.},wrapper:openleague_core::native_projectile_stop_dispatch::Wrapper{ended:0,linked:true},requests:0,pose_flags:setup.troy_flags,pose_matrix,owner_position:native_position,owner_direction:Vec3::ZERO,scale_child:openleague_core::native_troy_scalar::Child{coefficients:c.owner_scale_coefficients.map(f32::to_bits),owner:[0;2],value:1f32.to_bits()}})
    }
    #[cfg(test)]
    fn frame(&mut self,source_now:f64,native_position:Vec3,native_direction:Vec3,ended:bool,c:&SimpleProjectedConfig)->Result<Option<TerrainProjection>,&'static str> {
        self.frame_with_owner(source_now,Some((native_position,native_direction)),ended,c)
    }
    #[cfg(test)]
    fn frame_with_owner(&mut self,source_now:f64,owner:Option<(Vec3,Vec3)>,ended:bool,c:&SimpleProjectedConfig)->Result<Option<TerrainProjection>,&'static str> {
        self.frame_with_context(source_now,owner,ended,c,&openleague_core::native_troy_scratch::Scratch::default())
    }
    #[cfg(test)]
    fn frame_with_context(&mut self,source_now:f64,owner:Option<(Vec3,Vec3)>,ended:bool,c:&SimpleProjectedConfig,packet:&openleague_core::native_troy_scratch::Scratch)->Result<Option<TerrainProjection>,&'static str>{
        let accepted=self.update_owner(owner,ended);
        let result=self.particle_frame(source_now,c,packet);
        if !accepted {self.drain_removal();}
        result
    }
    fn update_owner(&mut self,owner:Option<(Vec3,Vec3)>,ended:bool)->bool {
        if ended {self.wrapper.projectile_end(true);}
        // Native940D2F publishes instance1DC bit1 to resource2D, read by928490.
        let resource_finished=self.parent.state.audio.flags_1dc&2!=0;
        let accepted=self.wrapper.update_owner_gate(self.wrapper.linked,resource_finished,true,owner.is_some());
        if accepted {
            self.visibility.update(false,None,owner.map(|_|true));
            if let Some((position,direction))=owner {self.owner_position=position;self.owner_direction=direction;}
        }
        accepted
    }
    fn drain_removal(&mut self) {self.wrapper.cleanup(true,&mut self.requests);}
    fn particle_frame(&mut self,source_now:f64,c:&SimpleProjectedConfig,packet:&openleague_core::native_troy_scratch::Scratch)->Result<Option<TerrainProjection>,&'static str>{
        let clock=native_time(source_now)?;
        if self.requests&0x400!=0 {self.system.stop(clock)?;}
        let pose=native_pose(self.owner_position,self.owner_direction,self.pose_flags,self.pose_matrix,c.scale)?;
        self.pose_matrix=pose.orientation;
        let decision=self.parent.update(ParentInput{time:clock,owner:&pose,direction:self.owner_direction,flags:self.system.flags|((self.visibility.suppression&1)<<3),source_flags:0,config_flags:self.config_flags,build_up:self.build_up,rate:self.rate,radius:self.radius,scratch:packet},c)?;
        if std::env::var_os("OPENLEAGUE_PROJECTED_CAMERA_REENTRY").is_some(){
            self.trace.push(serde_json::json!({"time":clock,"visible":decision.visible,"path":format!("{:?}",decision.path),"simulation_time_bits":self.parent.state.motion.last,"storage":self.parent.child.gate_child().resource,"active":self.parent.child.active_count,"position":self.parent.child.position.to_array()}));
        }
        if !decision.visible || decision.path!=openleague_core::native_troy_frame_gate::Path::Continue{return Ok(None);}
        if self.parent.child.active_count==0 || !self.visibility.draw_visible() {return Ok(None);}
        // Constant authored scale, default constructor factors and zero rotation velocity.
        // Subsequent native factor setters and live flag mutations remain to qualify.
        update_owner_scale(&mut self.scale_child,0.);
        let inputs=ProjectionInputs::new(self.parent.child.position,self.parent.child.scale,f32::from_bits(self.scale_child.value),1.,1.,c.scale_bias,self.parent.child.angle)?;
        TerrainProjection::new(inputs.position.xz(),inputs.half_size,inputs.angle).and_then(|p|p.with_native_height(self.parent.child.position.y,c.projection_range,c.projection_fading)).map(Some).ok_or("invalid normal projected footprint")
    }
}
struct Draw {entity:Entity,mesh:Handle<Mesh>,material:Handle<ProjectedMaterial>,geometry_key:(u64,Vec<Entity>),vertices:usize}
struct Effect {identity:u32,started:f64,last_frame_time:f64,lifetime:Lifetime,draw:Option<Draw>}
#[derive(Component)]
pub(crate) struct ProjectedDraw;
#[derive(Resource,Default)]
pub struct Live {
    parent_traces:Vec<serde_json::Value>,spatial:crate::effect_spatial_registry::Effects,next_identity:u32,
    session:Option<u64>,effects:HashMap<Key,Effect>,retired:HashSet<Key>,reported:bool,
    cache_hits:usize,geometry_rebuilds:usize,avoided_vertices:usize,rebuilt_vertices:usize,
    spawned:usize,visible_frames:usize,cleaned:usize,max_vertices:usize,max_visible_draws:usize,captured:bool,off_captured:bool,
    captured_owners:HashSet<Key>,capture_frames:Vec<serde_json::Value>,
}

fn visibility_bounds(position:Vec3)->Result<[f32;6],&'static str> {
    let document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).map_err(|_|"invalid Annie native resource")?;
    let config=openleague_core::native_troy_position_bounds::Config::from_decoded_system(&document["sections"]["System"])?;
    let bounds=config.bounds(position.to_array().map(f32::to_bits));
    Ok([bounds.minimum[0],bounds.minimum[1],bounds.minimum[2],bounds.maximum[0],bounds.maximum[1],bounds.maximum[2]].map(f32::from_bits))
}

fn release(draw:Draw,commands:&mut Commands,meshes:&mut Assets<Mesh>,materials:&mut Assets<ProjectedMaterial>) {
    commands.entity(draw.entity).despawn();meshes.remove(draw.mesh.id());materials.remove(draw.material.id());
}
pub fn update(mut commands:Commands,clock:Res<crate::native_effect_clock::EffectClock>,state:Res<Match>,flights:Res<Flights>,surfaces:Res<TerrainSurfaces>,assets:Res<AssetServer>,mut meshes:ResMut<Assets<Mesh>>,mut materials:ResMut<Assets<ProjectedMaterial>>,mut live:ResMut<Live>,native_camera:Res<crate::camera_native::NativeCamera>,windows:Query<&Window,With<bevy::window::PrimaryWindow>>) {
    let session=state.snapshot.as_ref().map(|s|s.session);
    if live.session!=session {
        for (_,effect) in live.effects.drain() {if let Some(draw)=effect.draw {release(draw,&mut commands,&mut meshes,&mut materials);}}
        live.parent_traces.clear();live.retired.clear();live.captured_owners.clear();live.session=session;live.spatial=Default::default();live.next_identity=0;
    }
    let Some(snapshot)=state.snapshot.as_ref() else {return;};
    // Consume the full chronological owner stream, including complete lifetimes
    // received between render frames. Only the final state reaches GPU extraction.
    for frame in &flights.projection_frames {
    let mut owners:Vec<_>=frame.owners.iter().copied().filter(|(key,_,_,_,_)|snapshot.players.iter().any(|p|p.id==key.0 && p.champion.eq_ignore_ascii_case("annie"))).map(|(key,started,position,direction,ended)|(key,started,Some((position,direction)),ended)).collect();
    let present:HashSet<_>=owners.iter().map(|o|o.0).collect();
    live.retired.retain(|key|present.contains(key));
    let abandoned:Vec<_>=live.effects.keys().filter(|k|!present.contains(k)).copied().collect();
    for key in abandoned {if let Some(effect)=live.effects.get(&key) {owners.push((key,effect.started,None,false));}}
    let c=match config() {Ok(c)=>c,Err(e)=>{if !live.reported {warn!("Annie Projected unavailable: {e}");live.reported=true;}return;}};
    let path=std::env::var_os("OPENLEAGUE_PROJECTED_LIVE_PROBE").map(std::path::PathBuf::from).filter(|p|p.parent()==Some(std::path::Path::new("E:/OpenLeague/logs")));
    let now=frame.time;
    let is_render_frame=(now-clock.now).abs()<1e-6;
    let viewport=windows.single().ok().map(|w|[w.physical_width(),w.physical_height()]).unwrap_or([0,0]);
    let drawable=viewport[0]>0 && viewport[1]>0;
    for (key,started,owner,ended) in owners.iter().copied() {
        if live.retired.contains(&key) {continue;}
        if !live.effects.contains_key(&key) {
            if ended {live.retired.insert(key);continue;}
            let Some((position,_))=owner else {continue;};
            let mut lifetime=match Lifetime::new(position,&c,now) {Ok(l)=>l,Err(e)=>{warn!("Annie Projected owner rejected: {e}");live.retired.insert(key);continue;}};
            let Some(identity)=live.next_identity.checked_add(1) else {warn!("effect identity exhausted");live.retired.insert(key);continue;};
            live.next_identity=identity;lifetime.visibility=OwnerVisibility::initialized();
            live.effects.insert(key,Effect{identity,started,last_frame_time:now,lifetime,draw:None});
            if !live.reported {warn!("Annie Projected normal binding active: native clock/start/lifetimes/scale/attachment; native projectile marker/cleanup/stop request; native factory flags and provider orientation gate; native activation and suppression draw gate; local root filter disabled, team/FOW providers unqualified; native acquisition-loss gate, local Shot-presence ownership adapter; network end trigger and registry scheduling reconstructed, default scale factors, FOW1, baseline alpha ADD/depth GreaterEqual and clamp/linear/LOD0 sampler qualified; interleaved renderer state, team/FOW and receiver fidelity remain open.");live.reported=true;}
        }
    }
    // Native GAMESTATE_GAMELOOP: entity updates -> camera selection ->
    // particles -> removals (58CE78 -> 58D11D -> 58D12C -> 58D1AB).
    let mut removals=Vec::new();
    let mut finished=Vec::new();
    for (key,_,owner,ended) in &owners {
        if let Some(effect)=live.effects.get_mut(key) {
            if !effect.lifetime.update_owner(*owner,*ended) {removals.push(*key);}
        }
    }
    // Current owner positions and frame ordering are explicit client adapters.
    let mut packet=openleague_core::native_troy_scratch::Scratch::default();
    let selection=(||->Result<Vec<openleague_core::entity_visibility_merge::Transition>, &'static str>{
        let window=windows.single().map_err(|_|"missing primary effect viewport")?;
        let mut observations=Vec::new();
        for (key,_,owner,_) in &owners {
            if let Some(effect)=live.effects.get(key).filter(|effect|effect.lifetime.wrapper.linked) {
                let position=owner.map(|(p,_)|p).unwrap_or(effect.lifetime.owner_position);
                observations.push((effect.identity,visibility_bounds(position)?));
            }
        }
        live.spatial.synchronize(&observations)?;
        if window.physical_width()==0 || window.physical_height()==0 {
            packet=empty_view_packet();
            return live.spatial.select_none();
        }
        let volume=native_camera.culling_volume(window.width()/window.height())?;
        packet.set_visibility_inputs(std::array::from_fn(|i|volume.planes[i].coefficients.map(f32::to_bits)),std::array::from_fn(|i|volume.planes[i].indices.map(|v|v as u32)));
        live.spatial.select(&volume)
    })();
    match selection {
        Ok(events)=>for event in events {
            if let Some(effect)=live.effects.values_mut().find(|e|e.identity==event.identity) {
                if event.active {effect.lifetime.visibility.activate(false,None,Some(true));}
                else {effect.lifetime.visibility.deactivate();}
            }
        },
        Err(error)=>{warn!("Annie spatial selection rejected: {error}");for effect in live.effects.values(){if let Some(draw)=&effect.draw{commands.entity(draw.entity).insert(Visibility::Hidden);}}return;}
    }
    let (mut cache_hits,mut geometry_rebuilds,mut avoided_vertices,mut rebuilt_vertices)=(0usize,0usize,0usize,0usize);
    for (key,started,_,_) in owners {
        let Some(effect)=live.effects.get_mut(&key) else {continue;};
        // Hidden native frames may freeze the simulation clock. Keep the last
        // invocation separately so replay cannot move an existing effect backwards.
        let effect_now=now.max(effect.last_frame_time).max(f32::from_bits(effect.lifetime.parent.state.motion.last) as f64);
        effect.last_frame_time=effect_now;
        let projection=match effect.lifetime.particle_frame(effect_now,&c,&packet) {Ok(p)=>p,Err(e)=>{warn!("Annie Projected update rejected: {e}");effect.lifetime.parent.state.audio.flags_1dc|=2;None}};
        if std::env::var_os("OPENLEAGUE_PROJECTED_CAMERA_REENTRY").is_some(){
            let hidden=effect.lifetime.trace.last().is_some_and(|f|f["visible"]==false);
            let returned=effect.lifetime.trace.iter().any(|f|f["path"]=="Skip");
            let phase=if hidden{"hidden"}else if returned{"returned"}else{"initial"};
            if is_render_frame && drawable && (hidden||projection.is_some()) && !effect.lifetime.captured_phases.contains(phase){
                if let Some(path)=&path{
                    commands.spawn(bevy::render::view::screenshot::Screenshot::primary_window()).observe(bevy::render::view::screenshot::save_to_disk(path.with_extension(format!("owner-{}-{phase}.png",effect.identity))));
                    effect.lifetime.captured_phases.insert(phase);
                }
            }
        }
        if effect.lifetime.parent.state.audio.flags_1dc&2!=0 {
            finished.push(key);continue;
        }
        if let Some(projection)=projection {
            let geometry_key=surfaces.geometry_key(projection);
            let cached=effect.draw.as_ref().filter(|draw|draw.geometry_key==geometry_key).map(|draw|draw.vertices);
            let mesh=if let Some(vertices)=cached{cache_hits+=1;avoided_vertices+=vertices;None}else{geometry_rebuilds+=1;let mesh=surfaces.projected_mesh(projection);rebuilt_vertices+=mesh.as_ref().map_or(0,Mesh::count_vertices);mesh};
            if let Some(vertices)=cached.or_else(||mesh.as_ref().map(Mesh::count_vertices)) {
                if let Some(draw)=&mut effect.draw {
                    if let Some(mesh)=mesh {if let Some(mut existing)=meshes.get_mut(draw.mesh.id()) {*existing=mesh;}draw.geometry_key=geometry_key;draw.vertices=vertices;}
                    if let Some(mut material)=materials.get_mut(draw.material.id()) {let uv=effect.lifetime.parent.child.color_uv;material.color_lookup=Vec4::new(uv.x,uv.y,1.,0.);material.world_to_projection=projection.world_to_uv;material.projection_height=projection.native_height.unwrap_or(Vec3::new(0.,5.,200.)).extend(1.);}
                    commands.entity(draw.entity).insert(Visibility::Inherited);
                } else {
                    let mesh=meshes.add(mesh.expect("uncached receiver geometry"));let uv=effect.lifetime.parent.child.color_uv;let material=materials.add(ProjectedMaterial{texture:terrain_material::projected_image(&assets,"particles/annie/disintegrate-light.png".into()),color_texture:terrain_material::projected_image(&assets,"particles/annie/color-hold.png".into()),color_lookup:Vec4::new(uv.x,uv.y,1.,0.),world_to_projection:projection.world_to_uv,projection_height:projection.native_height.unwrap_or(Vec3::new(0.,5.,200.)).extend(1.),..default()});
                    let entity=commands.spawn((Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),Transform::IDENTITY,Visibility::Inherited,ProjectedDraw,bevy::light::NotShadowCaster,bevy::light::NotShadowReceiver)).id();
                    effect.draw=Some(Draw{entity,mesh,material,geometry_key,vertices});live.spawned+=1;
                }
                live.visible_frames+=1;live.max_vertices=live.max_vertices.max(vertices);
                let loaded=live.effects.get(&key).and_then(|e|e.draw.as_ref()).and_then(|d|materials.get(d.material.id())).is_some_and(|m|assets.is_loaded_with_dependencies(m.texture.id()) && assets.is_loaded_with_dependencies(m.color_texture.id()));
                // Separate screenshots preserve each cast, including the warmed
                // second pipeline. Request metadata does not assert GPU pixels.
                if is_render_frame && drawable && std::env::var_os("OPENLEAGUE_PROJECTED_CAMERA_REENTRY").is_none() && live.max_visible_draws>0 && loaded && now-started>=0.12 && !live.captured_owners.contains(&key) {
                    if let Some(path)=&path {
                        let shot=live.spawned;let output=path.with_extension(format!("shot-{shot}.png"));
                        let frame=live.effects.get(&key).map(|e|serde_json::json!({"shot":shot,"requested_at":now,"effect_age":now-started,"position_native":e.lifetime.parent.child.position.to_array(),"particle_age":e.lifetime.parent.child.normalized_age,"scale":e.lifetime.parent.child.scale,"angle":e.lifetime.parent.child.angle,"active_count":e.lifetime.parent.child.active_count,"vertices":vertices,"path":output.to_string_lossy()}));
                        let mut request=commands.spawn(bevy::render::view::screenshot::Screenshot::primary_window());
                        request.observe(bevy::render::view::screenshot::save_to_disk(output));
                        if !live.captured {request.observe(bevy::render::view::screenshot::save_to_disk(path.with_extension("png")));live.captured=true;}
                        live.captured_owners.insert(key);if let Some(frame)=frame{live.capture_frames.push(frame);}
                    }
                }
            } else if let Some(draw)=&effect.draw {commands.entity(draw.entity).insert(Visibility::Hidden);}
        } else if let Some(draw)=&effect.draw {commands.entity(draw.entity).insert(Visibility::Hidden);}
    }
    for key in removals {
        if let Some(effect)=live.effects.get_mut(&key) {effect.lifetime.drain_removal();}
    }
    for key in finished {
        let effect=live.effects.remove(&key).unwrap();
        if !effect.lifetime.trace.is_empty(){live.parent_traces.push(serde_json::json!({"identity":effect.identity,"frames":effect.lifetime.trace}));}
        if let Some(draw)=effect.draw {release(draw,&mut commands,&mut meshes,&mut materials);live.cleaned+=1;}
        live.retired.insert(key);
    }
    // Native removal drains after the particle phase. Detach spatial wrappers
    // now while resources awaiting their next stop-consumption pass survive.
    let registered=live.effects.values().filter(|effect|effect.lifetime.wrapper.linked).map(|effect|effect.identity).collect::<Vec<_>>();
    if let Err(error)=live.spatial.retain_wrappers(&registered) {warn!("Annie spatial retirement failed: {error}");}
    live.cache_hits+=cache_hits;live.geometry_rebuilds+=geometry_rebuilds;live.avoided_vertices+=avoided_vertices;live.rebuilt_vertices+=rebuilt_vertices;
    if let Some(path)=path {
        if is_render_frame && drawable && live.spawned>0 && live.effects.is_empty() && (live.captured || !live.parent_traces.is_empty()) && !live.off_captured {
            commands.spawn(bevy::render::view::screenshot::Screenshot::primary_window()).observe(bevy::render::view::screenshot::save_to_disk(path.with_extension("off.png")));live.off_captured=true;
        }
        let record=serde_json::json!({"complete":false,"normal_binding":true,"viewport":viewport,"native_owner_acquisition_gate_binding":true,"native_owner_scale_gate_binding":true,"native_visibility_activation_binding":true,"native_visibility_suppression_binding":true,"native_spatial_selection_binding":true,"native_parent_frame_binding":true,"effect_quality_source":"explicit local setting3; historical UI pending","visibility_source":"native camera/grid/query/merge with reused spatial registry; local stable identities and current-owner frame scheduling; root filter disabled and team/FOW providers remain open","owner_acquisition_source":"local Shot presence; original weak-control lifetime producer remains unqualified","native_pose_binding":true,"native_position_coordinate_roundtrip":false,"native_stop_dispatch_binding":true,"native_clock_binding":true,"time_source":"Windows QPC and native GameClock arithmetic; Bevy First scheduling adapter","clock":clock.diagnostic(),"active_effect_states":live.effects.values().map(|e|serde_json::json!({"identity":e.identity,"started":e.started,"last_frame_time":e.last_frame_time,"last_trace":e.lifetime.trace.last(),"owner_position":e.lifetime.owner_position.to_array(),"owner_direction":e.lifetime.owner_direction.to_array(),"projection_position":e.lifetime.parent.child.position.to_array(),"simulation_time_bits":e.lifetime.parent.state.motion.last})).collect::<Vec<_>>(),"created_effects":live.next_identity,"retired_effects":live.retired.len(),"spawned":live.spawned,"visible_frames":live.visible_frames,"max_visible_draws":live.max_visible_draws,"cleaned":live.cleaned,"active_effects":live.effects.len(),"active_draws":live.effects.values().filter(|e|e.draw.is_some()).count(),"geometry_cache_hits":live.cache_hits,"geometry_rebuild_attempts":live.geometry_rebuilds,"geometry_vertices_reused":live.avoided_vertices,"geometry_vertices_rebuilt":live.rebuilt_vertices,"max_vertices":live.max_vertices,"capture_requested":live.captured,"off_capture_requested":live.off_captured,"capture_frames":live.capture_frames,"parent_traces":live.parent_traces,"limits":["Native QPC/frame-delta/GameClock source; Bevy First-boundary frame scheduling adapter, ordered pause/resume receiver implemented; graphical pause, resync and scale transitions remain unqualified.","Projectile marker, wrapper cleanup and Troy stop request use the native dispatch port; disappearance trigger, weak ownership, registry scheduling and owner status remain reconstructed adapters; pose now consumes exact native moving-position/direction fields.","Native initial flags0 retain constructor orientation; later flag producers/default factor1/FOW1; baseline alpha ADD/depth GreaterEqual and clamp/linear/LOD0 sampler qualified; interleaved overrides and receiver fidelity remain unqualified."]});
        if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&record).unwrap()) {warn!("Annie Projected probe: {e}");}
    }
    }
}
pub fn visibility_probe(query:Query<&ViewVisibility,With<ProjectedDraw>>,mut live:ResMut<Live>) {
    live.max_visible_draws=live.max_visible_draws.max(query.iter().filter(|v|v.get()).count());
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn finished_resource_rejects_live_owner_before_pose_update() {
        let c=config().unwrap();let position=Vec3::new(100.,200.,300.);
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_resource_finished_contract.json")).unwrap();
        assert_eq!(proof["finish_publication_cases"].as_array().unwrap().len(),256);
        for row in proof["finish_publication_cases"].as_array().unwrap() {
            let mut life=Lifetime::new(position,&c,0.).unwrap();
            life.parent.state.audio.flags_1dc=row["instance_flags"].as_u64().unwrap() as u8;
            let finished=row["resource_finished"]==1;
            assert_eq!(life.update_owner(Some((position+Vec3::X,Vec3::Z)),false),!finished);
            assert_eq!(life.owner_position,if finished {position}else{position+Vec3::X});
            assert_eq!(life.requests&0x400,0);
        }
    }
    #[test]
    fn batched_removal_waits_for_all_particle_frames_and_preserves_last_pose() {
        let c=config().unwrap();let position=Vec3::new(100.,200.,300.);
        let mut effects=[Lifetime::new(position,&c,0.).unwrap(),Lifetime::new(position,&c,0.).unwrap()];
        let packet=openleague_core::native_troy_scratch::Scratch::default();
        for effect in &mut effects {
            assert!(!effect.update_owner(Some((position+Vec3::X*100.,Vec3::Z)),true));
            assert_eq!(effect.owner_position,position);
        }
        for index in 0..effects.len() {
            effects[index].particle_frame(0.125,&c,&packet).unwrap();
            assert!(effects.iter().all(|effect|effect.requests&0x400==0 && effect.wrapper.linked));
        }
        for effect in &mut effects {effect.drain_removal();}
        for effect in &mut effects {
            assert!(!effect.wrapper.linked);assert_ne!(effect.requests&0x400,0);
            assert_eq!(effect.system.flags&0x10,0);
            effect.particle_frame(0.25,&c,&packet).unwrap();
            assert_ne!(effect.system.flags&0x10,0);
        }
    }
    #[test]
    fn initialization_clock_matches_native_deferred_reset() {
        let c=config().unwrap();
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_initialization_clock_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),4);
        for case in cases {
            let initialized_at=case["initialization_time"].as_f64().unwrap();
            let life=Lifetime::new(Vec3::new(500.,600.,700.),&c,initialized_at).unwrap();
            let expected=case["reset_clock_bits"][0].as_u64().unwrap() as u32;
            assert_eq!(life.system.start_time.to_bits(),expected);
            assert_eq!(life.parent.state.motion.last,expected);
        }
    }
    #[test]
    fn native_visibility_activation_bridge_matches48_original_sequences() {
     let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_visibility_activation_contract.json")).unwrap();let mut count=0;
     for c in proof["cases"].as_array().unwrap() {
      let mut visibility=OwnerVisibility::initialized();visibility.mask=c["team_mask"].as_u64().unwrap() as u32;
      let filter=c["root_filter_enabled"].as_bool().unwrap();let team=c["team_id"].as_u64().map(|v|v as u32);let provider=c["provider_present"].as_bool().unwrap().then_some(true);
      visibility.update(filter,team,provider);assert_eq!(visibility.suppression,c["dormant"]["visibility"].as_u64().unwrap() as u8);
      visibility.activate(filter,team,provider);assert_eq!(visibility.suppression,c["active"]["visibility"].as_u64().unwrap() as u8);assert_eq!(visibility.draw_visible(),visibility.suppression==0);
      visibility.deactivate();assert_eq!(visibility.suppression,c["disabled_before_update"]["visibility"].as_u64().unwrap() as u8);
      visibility.update(filter,team,provider);assert_eq!(visibility.suppression,c["disabled"]["visibility"].as_u64().unwrap() as u8);assert!(!visibility.draw_visible());count+=1;
     }
     assert_eq!(count,48);
    }
    #[test]
    fn normal_adapter_follows_native_frames_and_owner_end_without_nonfinite_geometry() {
        let c=config().unwrap();let mut lifetime=Lifetime::new(Vec3::new(100.,200.,300.),&c,0.).unwrap();
        assert!(lifetime.frame(0.,Vec3::new(100.,200.,300.),Vec3::ZERO,false,&c).unwrap().is_none());
        let projection=lifetime.frame(0.125,Vec3::new(112.5,200.,300.),Vec3::ZERO,false,&c).unwrap().unwrap();
        assert_eq!(lifetime.parent.child.position,Vec3::new(112.5,200.,300.));
        assert_eq!(projection.uv(Vec3::new(112.5,200.,300.)/20.),Vec2::splat(0.5));
        lifetime.frame(0.25,Vec3::new(125.,200.,300.),Vec3::ZERO,true,&c).unwrap();
        assert_eq!(lifetime.system.flags&0x10,0);
        assert_ne!(lifetime.requests&0x400,0);
        assert_eq!(lifetime.owner_position,Vec3::new(112.5,200.,300.));
        assert!(lifetime.frame(0.375,Vec3::new(125.,200.,300.),Vec3::ZERO,true,&c).unwrap().is_none());
        assert!(lifetime.parent.child.finished);assert_eq!(lifetime.parent.child.active_count,0);
        assert!(lifetime.parent.child.position.is_finite());
    }
    #[test]
    fn normal_lifetime_camera_exit_reentry_suspends_and_reuses_particles(){
        let c=config().unwrap();let mut life=Lifetime::new(Vec3::new(100.,200.,300.),&c,10.).unwrap();
        let owner=Some((Vec3::new(100.,200.,300.),Vec3::ZERO));let visible=openleague_core::native_troy_scratch::Scratch::default();
        let mut hidden=visible.clone();hidden.words[0x78/4]=(-1f32).to_bits();
        life.frame_with_context(10.,owner,false,&c,&visible).unwrap();
        assert!(life.frame_with_context(10.125,owner,false,&c,&visible).unwrap().is_some());
        assert!(life.frame_with_context(10.25,owner,false,&c,&hidden).unwrap().is_none());
        assert_eq!(life.parent.child.gate_child().resource,0);
        let last=life.parent.state.motion.last;
        life.frame_with_context(10.375,owner,false,&c,&hidden).unwrap();assert_eq!(life.parent.state.motion.last,last);
        life.frame_with_context(10.5,owner,false,&c,&visible).unwrap();assert_ne!(life.parent.child.gate_child().resource,0);
        assert!(life.frame_with_context(10.625,owner,false,&c,&visible).unwrap().is_some());
        assert!(life.frame_with_context(10.75,owner,true,&c,&hidden).unwrap().is_none());
        assert_eq!(life.system.flags&0x10,0);assert_ne!(life.requests&0x400,0);
        life.frame_with_context(10.875,owner,true,&c,&hidden).unwrap();assert_ne!(life.parent.state.audio.flags_1dc&2,0);
    }
    #[test]
    fn minimized_view_preserves_hidden_clock_but_consumes_owner_end() {
        let c=config().unwrap();let position=Vec3::new(100.,200.,300.);
        let owner=Some((position,Vec3::ZERO));let mut life=Lifetime::new(position,&c,0.).unwrap();
        life.frame(0.,position,Vec3::ZERO,false,&c).unwrap();
        life.frame(0.125,position,Vec3::ZERO,false,&c).unwrap();
        let hidden=empty_view_packet();
        assert!(!hidden.contains_bounds([0;6]).unwrap());
        life.frame_with_context(0.25,owner,false,&c,&hidden).unwrap();
        let clock=life.parent.state.motion.last;
        assert!(life.frame_with_context(1.,owner,false,&c,&hidden).unwrap().is_none());
        assert_eq!(life.parent.state.motion.last,clock);
        life.frame_with_context(1.125,owner,true,&c,&hidden).unwrap();
        assert_eq!(life.system.flags&0x10,0);assert_ne!(life.requests&0x400,0);
        life.frame_with_context(1.25,owner,true,&c,&hidden).unwrap();
        assert_ne!(life.parent.state.audio.flags_1dc&2,0);
        assert_eq!(life.parent.child.active_count,0);
    }
    #[test]
    fn released_draw_removes_entity_and_both_owned_assets() {
        use bevy::ecs::world::CommandQueue;
        let mut world=World::new();let mut queue=CommandQueue::default();
        let mut meshes=Assets::<Mesh>::default();let mut materials=Assets::<ProjectedMaterial>::default();
        let mesh=meshes.add(Rectangle::new(1.,1.));let material=materials.add(ProjectedMaterial{texture:Handle::default(),..default()});
        let entity=world.spawn_empty().id();
        release(Draw{entity,mesh:mesh.clone(),material:material.clone(),geometry_key:(0,vec![]),vertices:0},&mut Commands::new(&mut queue,&world),&mut meshes,&mut materials);
        queue.apply(&mut world);
        assert!(world.get_entity(entity).is_err());assert!(meshes.get(mesh.id()).is_none());assert!(materials.get(material.id()).is_none());
    }

    #[test]
    fn native_pose_bridge_matches45_live_original_factory_provider_profiles(){
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_pose_composition_contract.json")).unwrap();let mut count=0;
        for row in proof["cases"].as_array().unwrap().iter().filter(|r|r["effect_live"]==true && r["owner_live"]==true){
            let vec=|key:&str|Vec3::from_array(std::array::from_fn(|i|row[key][i].as_f64().unwrap() as f32));
            let matrix=Mat4::from_cols_array(&std::array::from_fn(|i|f32::from_bits(row["before"]["source_matrix"][i].as_u64().unwrap() as u32)));
            let pose=native_pose(vec("position"),vec("direction"),row["flags"].as_u64().unwrap() as u32,matrix,500.).unwrap();
            assert_eq!(pose.position.to_array().map(f32::to_bits),std::array::from_fn(|i|row["result"]["source_position"][i].as_u64().unwrap() as u32));
            assert_eq!(pose.orientation.to_cols_array().map(f32::to_bits),std::array::from_fn(|i|row["result"]["source_matrix"][i].as_u64().unwrap() as u32));count+=1;
        }assert_eq!(count,45);
    }

    #[test]
    fn native_owner_loss_bridge_matches_fifteen_original_frames_and_defers_cleanup() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_owner_acquisition_contract.json")).unwrap();
        let c=config().unwrap();let mut count=0;
        for case in proof["cases"].as_array().unwrap().iter().filter(|r|r["initial_ended"]==0 && r["provider_present"]==true && r["resource_live"]==true) {
            let mut life=Lifetime::new(Vec3::new(500.,600.,700.),&c,0.).unwrap();
            let mut rejected=false;
            for (i,f) in case["stages"].as_array().unwrap().iter().enumerate() {
                let owner=f["owner_live"].as_bool().unwrap().then(||(Vec3::from_array(std::array::from_fn(|j|f["owner_position"][j].as_f64().unwrap() as f32)),Vec3::ZERO));
                life.frame_with_owner(i as f64*0.025,owner,false,&c).unwrap();
                assert_eq!(life.wrapper.ended,f["after"]["ended"].as_u64().unwrap() as u32);
                rejected|=!f["continues"].as_bool().unwrap();
                assert_eq!(life.wrapper.linked,!rejected);
                assert_eq!(life.requests&0x400!=0,rejected);
                if owner.is_none() && !rejected {assert_eq!(life.system.flags&0x10,0,"loss frame must not consume stop yet");}
                count+=1;
            }
        }
        assert_eq!(count,15);
    }

    #[test]
    fn native_owner_scale_reader_and_simple_child_match_ten_original_profiles(){
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/annie_projected_owner_scale_contract.json")).unwrap();let mut count=0;
        for row in proof["cases"].as_array().unwrap(){
            let mut document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();
            for (key,value) in row["fields"].as_object().unwrap(){document["sections"]["Projected"][key]=value.clone();}
            let c=SimpleProjectedConfig::from_troy(&document,"Projected").unwrap();
            assert_eq!(c.owner_scale_coefficients.map(f32::to_bits),std::array::from_fn(|i|row["coefficients"][i].as_u64().unwrap() as u32));
            let mut child=openleague_core::native_troy_scalar::Child{coefficients:c.owner_scale_coefficients.map(f32::to_bits),owner:[2f32.to_bits(),3f32.to_bits()],value:1f32.to_bits()};
            assert_eq!(child.value,row["initial_factor"].as_u64().unwrap() as u32);
            let scalar=update_owner_scale(&mut child,row["scalar"].as_f64().unwrap() as f32);
            assert_eq!(scalar,row["system_scalar"].as_u64().unwrap() as u32);assert_eq!(child.value,row["final_factor"].as_u64().unwrap() as u32);count+=1;
        }assert_eq!(count,10);
    }
}

