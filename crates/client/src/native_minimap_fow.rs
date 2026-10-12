//! Current client FoW on the original Map10 content rectangle. The original
//! shader arithmetic is separate from the local Bevy draw/linear-sampler bridge.
use bevy::{prelude::*,
    ecs::system::{lifetimeless::SRes,SystemParamItem},
    render::{extract_resource::{ExtractResource,ExtractResourcePlugin},render_asset::RenderAssets,
        render_phase::{Draw,DrawError,DrawFunctions,PhaseItem,RenderCommand,RenderCommandResult,RenderCommandState,SetItemPipeline,TrackedRenderPass},
        render_resource::*,renderer::{RenderDevice,RenderGraph},texture::GpuImage,RenderApp},
    shader::ShaderRef,
    ui_render::{ui_material::{MaterialNode,UiMaterial},DrawUiMaterial,DrawUiMaterialNode,SetMatUiViewBindGroup,TransparentUi,UiMaterialBatch,UiMaterialPipeline,UiMaterialPlugin}};

#[derive(Asset,TypePath,AsBindGroup,Clone,Debug)]
struct FogMaterial {#[texture(0)] #[sampler(1)] texture:Handle<Image>}
impl UiMaterial for FogMaterial {
    fn fragment_shader()->ShaderRef {"shaders/native_minimap_fow.wgsl".into()}
}
// UiMaterial's default non-premultiplied alpha blending is used. Since native
// MinimapFoW RGB is exactly zero, both RGB premultiplication conventions agree.
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
struct Ticket {session:u64,team:u8,node:Entity,material:AssetId<FogMaterial>,image:AssetId<Image>}
#[derive(Resource,Clone,Default,ExtractResource)] struct Frame {ticket:Option<Ticket>}
struct Owned {entity:Entity,material:Handle<FogMaterial>}
#[derive(Resource,Default)] struct Live {owned:Option<Owned>}
pub(super) struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Live>().init_resource::<Frame>()
            .add_plugins((UiMaterialPlugin::<FogMaterial>::default(),ExtractResourcePlugin::<Frame>::default()))
            .add_systems(Update,update.after(super::update).before(crate::render_probe::capture));
        if let Some(render_app)=app.get_sub_app_mut(RenderApp) {
            render_app.init_resource::<Binding>()
                .add_systems(RenderGraph,prepare_binding.after(crate::fow_gpu::Encoded)
                    .before(bevy::core_pipeline::schedule::camera_driver));
            // Replace only this material's draw lookup; all other UI commands
            // remain untouched. Queue still uses standard UiMaterial extraction.
            let draw=GuardedDraw(RenderCommandState::new(render_app.world_mut()));
            render_app.world().resource::<DrawFunctions<TransparentUi>>().write()
                .add_with::<DrawUiMaterial<FogMaterial>,_>(draw);
        }
    }
}
fn retire(live:&mut Live,frame:&mut Frame,commands:&mut Commands,materials:&mut Assets<FogMaterial>) {
    frame.ticket=None;
    if let Some(owned)=live.owned.take() {commands.entity(owned.entity).despawn();materials.remove(owned.material.id());}
}
fn update(mut commands:Commands,game:Res<crate::Match>,connection:Res<crate::Connection>,base:Res<super::Live>,
    fog:Option<Res<crate::fow_gpu::Images>>,mut materials:ResMut<Assets<FogMaterial>>,mut live:ResMut<Live>,mut frame:ResMut<Frame>) {
    // Roster is used solely for the local viewer's team, never actor positions.
    let context=game.snapshot.as_ref().filter(|s|Some(s.session)==connection.session && base.session==Some(s.session))
        .and_then(|s|s.roster.iter().find(|p|Some(p.id)==connection.id && p.team<2).map(|p|(s.session,p.team)));
    let (Some((session,team)),Some(rect),Some(fog))=(context,base.rect,fog) else {
        retire(&mut live,&mut frame,&mut commands,&mut materials);return;
    };
    let image=fog.output.clone();
    if live.owned.as_ref().is_some_and(|o|!materials.contains(o.material.id())) {
        retire(&mut live,&mut frame,&mut commands,&mut materials);
    }
    if live.owned.is_none() {
        let material=materials.add(FogMaterial{texture:image.clone()});
        let entity=commands.spawn((Node::default(),MaterialNode(material.clone()),GlobalZIndex(81),Name::new("NativeMap10MinimapFoW"))).id();
        live.owned=Some(Owned{entity,material});
    }
    let owned=live.owned.as_ref().unwrap();
    if materials.get(&owned.material).is_some_and(|m|m.texture!=image) {
        materials.get_mut(&owned.material).unwrap().texture=image.clone();
    }
    commands.entity(owned.entity).insert(Node{position_type:PositionType::Absolute,
        left:Val::Px(rect.left),top:Val::Px(rect.top),width:Val::Px(rect.width),height:Val::Px(rect.height),..default()});
    frame.ticket=Some(Ticket{session,team,node:owned.entity,material:owned.material.id(),image:image.id()});
}

#[derive(Clone,Copy,Debug,PartialEq,Eq)]
struct BindingKey {ticket:Ticket,texture:TextureId,view:TextureViewId}
struct ReadyBinding {key:BindingKey,group:BindGroup}
#[derive(Resource,Default)] struct Binding(Option<ReadyBinding>);
fn current_key(world:&World,ticket:Ticket)->Option<BindingKey> {
    if !crate::fow_gpu::ready_for_team(world,ticket.session,ticket.team,ticket.image) {return None;}
    let image=world.get_resource::<RenderAssets<GpuImage>>()?.get(ticket.image)?;
    let d=&image.texture_descriptor;
    if d.format!=TextureFormat::Rgba8Unorm || d.dimension!=TextureDimension::D2
        || d.size!=(Extent3d{width:512,height:512,depth_or_array_layers:1}) || d.sample_count!=1 {return None;}
    Some(BindingKey{ticket,texture:image.texture.id(),view:image.texture_view.id()})
}
fn prepare_binding(world:&mut World) {
    let ticket=world.get_resource::<Frame>().and_then(|f|f.ticket);
    let key=ticket.and_then(|t|current_key(world,t));
    let Some(key)=key else {world.resource_mut::<Binding>().0=None;return;};
    if world.resource::<Binding>().0.as_ref().is_some_and(|b|b.key==key) {return;}
    // The standard PreparedUiMaterial may still refer to a previous GPU
    // allocation under the same AssetId. This group binds the CURRENT view.
    let device=world.resource::<RenderDevice>();let cache=world.resource::<PipelineCache>();
    let layout=&world.resource::<UiMaterialPipeline<FogMaterial>>().ui_layout;
    let gpu=world.resource::<RenderAssets<GpuImage>>();let image=gpu.get(key.ticket.image).unwrap();
    let sampler=device.create_sampler(&SamplerDescriptor{address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,
        min_filter:FilterMode::Linear,mag_filter:FilterMode::Linear,lod_min_clamp:0.,lod_max_clamp:0.,..default()});
    let group=device.create_bind_group("minimap-current-fow",&cache.get_bind_group_layout(layout),
        &BindGroupEntries::sequential((&image.texture_view,&sampler)));
    world.resource_mut::<Binding>().0=Some(ReadyBinding{key,group});
}
struct SetCurrentFogBindGroup;
impl RenderCommand<TransparentUi> for SetCurrentFogBindGroup {
    type Param=SRes<Binding>;type ViewQuery=();type ItemQuery=();
    fn render<'w>(_item:&TransparentUi,_view:(),_entity:Option<()>,binding:SystemParamItem<'w,'_,Self::Param>,pass:&mut TrackedRenderPass<'w>)->RenderCommandResult {
        let Some(binding)=&binding.into_inner().0 else {return RenderCommandResult::Skip;};
        pass.set_bind_group(1,&binding.group,&[]);RenderCommandResult::Success
    }
}
type CommandsForFog=(SetItemPipeline,SetMatUiViewBindGroup<FogMaterial,0>,SetCurrentFogBindGroup,DrawUiMaterialNode<FogMaterial>);
struct GuardedDraw(RenderCommandState<TransparentUi,CommandsForFog>);
fn accepts(current:Option<BindingKey>,bound:Option<BindingKey>,node:Entity,material:AssetId<FogMaterial>)->bool {
    current.is_some_and(|c|Some(c)==bound && c.ticket.node==node && c.ticket.material==material)
}
impl Draw<TransparentUi> for GuardedDraw {
    fn prepare(&mut self,world:&World) {self.0.prepare(world);}
    fn draw<'w>(&mut self,world:&'w World,pass:&mut TrackedRenderPass<'w>,view:Entity,item:&TransparentUi)->Result<(),DrawError> {
        let Some(batch)=world.get::<UiMaterialBatch<FogMaterial>>(item.entity()) else {return Ok(());};
        let current=world.get_resource::<Frame>().and_then(|f|f.ticket).and_then(|t|current_key(world,t));
        let bound=world.get_resource::<Binding>().and_then(|b|b.0.as_ref().map(|b|b.key));
        if !accepts(current,bound,item.main_entity().id(),batch.material) {return Ok(());}
        self.0.draw(world,pass,view,item)
    }
}
#[cfg(test)] #[path="native_minimap_fow_tests.rs"] mod tests;
