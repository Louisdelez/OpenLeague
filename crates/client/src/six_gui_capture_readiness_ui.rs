//! Readonly witness of the real Bevy 0.19 UI material preparation inputs.
//! Same-material batching stays enabled. A member must contribute vertices;
//! another member's representative batch never qualifies a fully clipped glyph.
use bevy::{prelude::*, asset::AssetId,
    render::{Render, RenderApp, RenderSystems, render_asset::RenderAssets,
        render_phase::ViewSortedRenderPhases, render_resource::{PipelineCache,CachedRenderPipelineId},
        sync_world::MainEntity, texture::GpuImage, view::{ExtractedView,RetainedViewEntity}},
    ui_render::{TransparentUi,UiCameraView,UiViewTarget,ui_material::UiMaterial,
        ExtractedUiMaterialNodes,ExtractedUiMaterialNode,
            PreparedUiMaterial,UiMaterialBatch,prepare_uimaterial_nodes}};
use crate::six_gui_capture_readiness::types::{Frame,Scope,UiTicket,UiMaterial as Kind};
use std::ops::Range;

// These are the exact private constants used by bevy_ui_render 0.19.0.
// Pin that source before future adoption; this only observes its CPU predicate.
const QUAD: [Vec2;4] = [Vec2::new(-0.5,-0.5),Vec2::new(0.5,-0.5),Vec2::new(0.5,0.5),Vec2::new(-0.5,0.5)];
const VERTICES_PER_QUAD:u32 = 6;
const OBSERVATION_LIMIT:usize = 16_384;
fn bounded_input(nodes:usize,phases:impl Iterator<Item=usize>)->Result<(),String> {
    if nodes>OBSERVATION_LIMIT{return Err("UI extraction inputs exceed bounded observation".into());}
    let mut items=0usize;
    for count in phases {
        items=items.checked_add(count).ok_or("UI phase observation count overflow")?;
        if items>OBSERVATION_LIMIT{return Err("UI sorted phase items exceed bounded observation".into());}
    }
    Ok(())
}

#[derive(Clone,Debug)]
struct Group<K> {material:K,representative:usize,range:Range<u32>,contributors:u32}
/// Mirrors prepare_uimaterial_nodes' material-run bookkeeping, not its draws.
struct Walk<K> {last:Option<(K,usize)>,groups:Vec<Group<K>>,next:u32}
impl<K:Copy+PartialEq> Default for Walk<K> {
    fn default()->Self {Self {last:None,groups:Vec::new(),next:0}}
}
impl<K:Copy+PartialEq> Walk<K> {
    fn break_run(&mut self) {self.last=None;}
    fn member(&mut self,index:usize,material:K,contributes:bool)->Result<(usize,Option<Range<u32>>),String> {
        let group=match self.last {
            Some((previous,group)) if previous==material =>group,
            _=>{let group=self.groups.len();self.groups.push(Group {material,representative:index,
                range:self.next..self.next,contributors:0});self.last=Some((material,group));group},
        };
        let range=if contributes {
            let end=self.next.checked_add(VERTICES_PER_QUAD).ok_or("UI vertex observation range overflow")?;
            let range=self.next..end;self.next=end;let value=&mut self.groups[group];
            value.range.end=end;value.contributors=value.contributors.checked_add(1).ok_or("UI contribution count overflow")?;
            Some(range)
        }else{None};
        Ok((group,range))
    }
}

/// The exact source predicate at prepare_uimaterial_nodes lines 438..497.
/// A true result means six CPU vertices are emitted, not that pixels exist.
fn contributes<M:UiMaterial>(node:&ExtractedUiMaterialNode<M>)->Result<bool,String> {
    let size=node.rect.size();
    if !size.is_finite()||size.min_element()<=0.||!node.transform.x_axis.is_finite()
        ||!node.transform.y_axis.is_finite()||!node.transform.translation.is_finite() {
        return Err("actual extracted UI rect/transform is invalid".into());
    }
    let positions=QUAD.map(|position|node.transform.transform_point2(position*size));
    if positions.iter().any(|p|!p.is_finite()){return Err("actual extracted UI positions are nonfinite".into());}
    let diff=if let Some(clip)=node.clip {
        if !clip.min.is_finite()||!clip.max.is_finite(){return Err("actual extracted UI clip is nonfinite".into());}
        [Vec2::new((clip.min.x-positions[0].x).max(0.),(clip.min.y-positions[0].y).max(0.)),
            Vec2::new((clip.max.x-positions[1].x).min(0.),(clip.min.y-positions[1].y).max(0.)),
            Vec2::new((clip.max.x-positions[2].x).min(0.),(clip.max.y-positions[2].y).min(0.)),
            Vec2::new((clip.min.x-positions[3].x).max(0.),(clip.max.y-positions[3].y).min(0.))]
    }else{[Vec2::ZERO;4]};
    let transformed=node.transform.transform_vector2(size).abs();
    // Match the renderer's strict equality and its rotation bypass; no epsilon
    // or stronger guessed visibility/culling rule is introduced by this observer.
    Ok(!(node.transform.x_axis[1]==0. && (diff[0].x-diff[1].x>=transformed.x || diff[1].y-diff[2].y>=transformed.y)))
}
#[derive(Clone)]
struct Row<K> {
    view:RetainedViewEntity,phase_index:usize,extracted_index:usize,
    entity:(Entity,MainEntity),material:K,pipeline:CachedRenderPipelineId,
    group:usize,contribution:Option<Range<u32>>,camera:Entity,
}
#[derive(Resource)]
struct Witness<M:UiMaterial> {serial:u64,scope:Option<Scope>,rows:Vec<Row<AssetId<M>>>,
    groups:Vec<Group<AssetId<M>>>,missing:Vec<String>}
impl<M:UiMaterial> Default for Witness<M> {
    fn default()->Self {Self {serial:0,scope:None,rows:Vec::new(),groups:Vec::new(),missing:Vec::new()}}
}

pub(crate) fn install(app:&mut App) {
    let Some(render)=app.get_sub_app_mut(RenderApp)else{return;};
    render.init_resource::<Witness<crate::native_hud_icon_material::IconMaterial>>()
        .init_resource::<Witness<crate::native_font_material::FontMaterial>>()
        .add_systems(Render,
            snapshot::<crate::native_hud_icon_material::IconMaterial>
                .after(RenderSystems::PhaseSort)
                .before(prepare_uimaterial_nodes::<crate::native_hud_icon_material::IconMaterial>))
        .add_systems(Render,
            snapshot::<crate::native_font_material::FontMaterial>
                .after(RenderSystems::PhaseSort)
                .before(prepare_uimaterial_nodes::<crate::native_font_material::FontMaterial>));
}
fn snapshot<M:UiMaterial>(world:&mut World) {
    let mut witness=Witness::<M>::default();
    let result=(||->Result<(),String>{
        let frame=world.get_resource::<Frame>().ok_or("current extracted CPU frame absent before UI prepare")?;
        witness.serial=frame.serial;witness.scope=frame.scope.clone();
        let nodes=world.get_resource::<ExtractedUiMaterialNodes<M>>().ok_or("actual UI material extraction inputs absent")?;
        let phases=world.get_resource::<ViewSortedRenderPhases<TransparentUi>>().ok_or("actual sorted UI phases absent")?;
        bounded_input(nodes.uinodes.len(),phases.values().map(|phase|phase.items.len()))?;
        let mut walk=Walk::default();
        // Keep the native hash-map view iteration order. Its prepared global
        // vertex ranges are checked afterward; any changed order rejects.
        for (view,phase) in phases.iter() {
            walk.break_run();
            for (phase_index,item) in phase.items.values().enumerate() {
                let Some(node)=nodes.uinodes.get(item.index).filter(|node|node.render_entity==item.entity.0)else{
                    walk.break_run();continue;
                };
                if node.main_entity!=item.entity.1{return Err("actual UI main entity differs from its extraction input".into());}
                let count=contributes(node)?;
                let (group,contribution)=walk.member(phase_index,node.material,count)?;
                witness.rows.push(Row {view:*view,phase_index,extracted_index:item.index,entity:item.entity,
                    material:node.material,pipeline:item.pipeline,group,contribution,camera:node.extracted_camera_entity});
            }
        }
        witness.groups=walk.groups;Ok(())
    })();
    if let Err(error)=result{witness.missing.push(error);}
    // This private witness is the only mutation; native extraction, phases,
    // batches, materials, cameras and draw functions are observed unchanged.
    world.insert_resource(witness);
}

pub(crate) fn ready<M:UiMaterial>(world:&World,ticket:&UiTicket,id:AssetId<M>,view:RetainedViewEntity)
    ->Result<serde_json::Value,String> {
    let actual=match ticket.material {Kind::Icon(id)=>id.untyped(),Kind::Font(id)=>id.untyped()};
    if actual!=id.untyped(){return Err("current UI ticket material type/identity differs".into());}
    let frame=world.get_resource::<Frame>().ok_or("current extracted frame absent at UI readiness")?;
    let witness=world.get_resource::<Witness<M>>().ok_or("readonly before-prepare UI witness absent")?;
    if witness.serial==0||witness.serial!=frame.serial||witness.scope!=frame.scope||!witness.missing.is_empty() {
        return Err(format!("UI source-generation/scope witness pending or rejected: {:?}",witness.missing));
    }
    let scope=frame.scope.as_ref().ok_or("current accepted UI scope absent")?;
    if !frame.ui.contains(ticket){return Err("UI ticket differs from the current exact frame census".into());}
    if world.get_resource::<RenderAssets<PreparedUiMaterial<M>>>().and_then(|a|a.get(id)).is_none(){
        return Err("actual UI prepared material/bind group pending".into());
    }
    let images=world.get_resource::<RenderAssets<GpuImage>>().ok_or("actual UI GPU image registry absent")?;
    if ticket.images.iter().any(|id|images.get(*id).is_none()){return Err("actual UI ticket GPU image pending".into());}
    let matches=witness.rows.iter().filter(|row|row.view==view&&row.entity.1==MainEntity::from(ticket.draw)).collect::<Vec<_>>();
    if matches.len()!=1{return Err("unique current extracted/queued own UI member pending".into());}
    let row=matches[0];
    if row.material!=id{return Err("actual queued UI member material differs".into());}
    let own=row.contribution.as_ref().ok_or("own UI member is entirely clipped and emitted no vertices")?;
    let group=witness.groups.get(row.group).ok_or("own UI member group witness absent")?;
    let expected=RetainedViewEntity::new(MainEntity::from(scope.camera),None,0);
    if world.get::<ExtractedView>(row.camera).map(|v|v.retained_view_entity)!=Some(expected){
        return Err("own UI extraction input belongs to another main camera".into());
    }
    let ui=world.get::<UiCameraView>(row.camera).ok_or("actual UI camera link missing")?.0;
    if world.get::<UiViewTarget>(ui).map(|v|v.0)!=Some(row.camera)
        ||world.get::<ExtractedView>(ui).map(|v|v.retained_view_entity)!=Some(view) {
        return Err("own UI extraction input view/target differs".into());
    }
    let phase=world.get_resource::<ViewSortedRenderPhases<TransparentUi>>().and_then(|p|p.get(&view))
        .ok_or("actual current UI phase absent after prepare")?;
    let member=phase.items.get_index(row.phase_index).map(|(_,item)|item).ok_or("actual own UI phase index retired")?;
    if member.entity!=row.entity||member.index!=row.extracted_index||member.pipeline!=row.pipeline {
        return Err("actual own UI phase/extraction/pipeline identity changed after snapshot".into());
    }
    let representative=phase.items.get_index(group.representative).map(|(_,item)|item)
        .ok_or("actual UI representative index retired")?;
    let representative_row=witness.rows.iter().find(|candidate|candidate.view==view&&candidate.phase_index==group.representative&&candidate.group==row.group)
        .ok_or("actual UI representative witness missing")?;
    if representative.entity!=representative_row.entity||representative.pipeline!=representative_row.pipeline
        ||representative.index!=representative_row.extracted_index||representative.pipeline!=row.pipeline {
        return Err("actual UI representative/material pipeline changed or differs".into());
    }
    let batch=world.get::<UiMaterialBatch<M>>(representative.entity.0).ok_or("actual UI representative prepared batch pending")?;
    if group.material!=id||batch.material!=id||batch.range!=group.range||group.contributors==0
        ||representative.batch_range!=(0..group.contributors)||own.start<batch.range.start||own.end>batch.range.end||own.end-own.start!=VERTICES_PER_QUAD {
        return Err("actual UI representative batch/range differs from exact current contributing members".into());
    }
    if row.phase_index!=group.representative&&!member.batch_range.is_empty(){
        return Err("nonrepresentative UI member unexpectedly owns another prepared batch".into());
    }
    if !world.get_resource::<PipelineCache>().is_some_and(|cache|cache.get_render_pipeline(row.pipeline).is_some()){
        return Err("current exact UI representative/member compiled pipeline pending".into());
    }
    Ok(serde_json::json!({"phase":"primary_UI","serial":frame.serial,"main_entity":ticket.draw.to_bits(),
        "render_entity":row.entity.0.to_bits(),"representative_main":representative.entity.1.id().to_bits(),
        "representative_render":representative.entity.0.to_bits(),"material":format!("{id:?}"),
        "member_vertex_range":[own.start,own.end],"prepared_batch_range":[batch.range.start,batch.range.end],
        "prepared_member_count":group.contributors,"compiled_pipeline":format!("{:?}",row.pipeline),
        "readonly_source_clip_predicate_contributes":true,"same_material_batching_preserved":true,
        "DrawUiMaterial_success_observed":false,"GPU_execution_or_visible_pixels_qualified":false,
        "limit":"Source clip/contribution plus actual prepared representative range; private vertex buffer bytes and successful draw execution are not observed."}))
}

#[cfg(test)]mod tests {
    use super::*;
    fn node(clip:Option<Rect>)->ExtractedUiMaterialNode<crate::native_hud_icon_material::IconMaterial> {
        ExtractedUiMaterialNode {stack_index:0,transform:bevy::math::Affine2::IDENTITY,
            rect:Rect::from_corners(Vec2::ZERO,Vec2::splat(10.)),border:default(),border_radius:[0.;4],
            material:Handle::<crate::native_hud_icon_material::IconMaterial>::default().id(),clip,
            extracted_camera_entity:Entity::PLACEHOLDER,main_entity:MainEntity::from(Entity::PLACEHOLDER),render_entity:Entity::PLACEHOLDER}
    }
    #[test]fn six_gui_ui_same_material_members_share_representative_but_own_distinct_vertex_spans(){
        let mut walk=Walk::<u32>::default();let(a,first)=walk.member(0,7,true).unwrap();let(b,second)=walk.member(1,7,true).unwrap();
        assert_eq!(a,b);assert_eq!(first,Some(0..6));assert_eq!(second,Some(6..12));
        assert_eq!(walk.groups[a].representative,0);assert_eq!(walk.groups[a].range,0..12);assert_eq!(walk.groups[a].contributors,2);
    }
    #[test]fn six_gui_ui_clipped_representative_does_not_make_itself_a_contributor_when_neighbor_draws(){
        let mut walk=Walk::<u32>::default();let(a,first)=walk.member(0,7,false).unwrap();let(b,second)=walk.member(1,7,true).unwrap();
        assert_eq!(a,b);assert!(first.is_none());assert_eq!(second,Some(0..6));assert_eq!(walk.groups[a].representative,0);
        assert_eq!(walk.groups[a].range,0..6);assert_eq!(walk.groups[a].contributors,1);
    }
    #[test]fn six_gui_ui_foreign_material_phase_item_breaks_shared_material_run(){
        let mut walk=Walk::<u32>::default();let(a,_)=walk.member(0,7,true).unwrap();walk.break_run();let(b,_)=walk.member(2,7,true).unwrap();
        assert_ne!(a,b);assert_eq!(walk.groups[b].representative,2);assert_eq!(walk.groups[b].range,6..12);
    }
    #[test]fn six_gui_ui_exact_axis_aligned_clip_discards_only_entirely_clipped_contribution(){
        assert!(contributes(&node(None)).unwrap());
        assert!(!contributes(&node(Some(Rect::from_corners(Vec2::splat(20.),Vec2::splat(30.))))).unwrap());
        assert!(contributes(&node(Some(Rect::from_corners(Vec2::ZERO,Vec2::splat(4.))))).unwrap());
    }
    #[test]fn six_gui_ui_nonfinite_source_geometry_is_not_a_readiness_witness(){
        let mut value=node(None);value.transform.translation.x=f32::NAN;assert!(contributes(&value).is_err());
    }
    #[test]fn six_gui_ui_observation_refuses_excess_or_overflow_without_truncating_members(){
        assert!(bounded_input(OBSERVATION_LIMIT,[8_000,8_384].into_iter()).is_ok());
        assert!(bounded_input(OBSERVATION_LIMIT+1,[1].into_iter()).is_err());
        assert!(bounded_input(1,[8_000,8_385].into_iter()).is_err());
        assert!(bounded_input(1,[usize::MAX,1].into_iter()).is_err());
    }
}
