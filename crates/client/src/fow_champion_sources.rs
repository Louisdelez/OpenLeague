//! Snapshot adapter into qualified circular source/view contracts.
//! Living allied champions, lane units, pets and sight buildings; server remains authoritative.
use bevy::prelude::*;
use std::{collections::BTreeMap,sync::{Mutex,Weak,OnceLock}};
use openleague_core::Snapshot;
use crate::{fow_source_factory::{CircleFactory,CircleSource,Inputs},fow_source_update::ActorParameters,map10_vision_view::Map10VisionView};
// Local transport provenance, not a complete-snapshot or GPU certificate.
#[derive(Clone,Debug)]
pub(crate) struct MaskSourceStamp {
    pub session:u64,
    pub team:u8,
    pub episode:u64,
    pub represented_tick:u64,
    instance:Weak<()>,
    view:Weak<Mutex<crate::fow_view_registry::RegisteredView>>,
}
impl MaskSourceStamp {
    pub(crate) fn same_episode(&self,other:&Self)->bool {
        self.session==other.session && self.team==other.team && self.episode==other.episode
            && self.instance.ptr_eq(&other.instance) && self.view.ptr_eq(&other.view)
    }
}
#[derive(Default)]
struct MaskSourceStatus {
    identity:std::sync::Arc<()>,
    view:Option<Weak<Mutex<crate::fow_view_registry::RegisteredView>>>,
    episode:u64,
    current:Option<MaskSourceStamp>,
}
impl MaskSourceStatus {
    fn invalidate(&mut self) {self.current=None;}
    fn bind(&mut self,map:&Map10VisionView)->Result<(),&'static str> {
        let actual=std::sync::Arc::downgrade(&map.view);
        if self.view.as_ref().is_some_and(|bound|!bound.ptr_eq(&actual)) {
            self.invalidate();
            // Do not relabel caches owned by another view. Coherent recreation
            // of Sources and Map10VisionView is a separate explicit operation.
            return Err("vision view replaced; coherent source/view reset required");
        }
        if self.view.is_none() {self.view=Some(actual);}
        Ok(())
    }
    fn publish(&mut self,session:u64,team:u8,tick:u64)->Result<(),&'static str> {
        let new_episode=self.current.as_ref().is_none_or(|s|s.session!=session || s.team!=team);
        let episode=if new_episode {self.episode.checked_add(1).ok_or("vision mask episode exhausted")?}else{self.episode};
        let view=self.view.as_ref().ok_or("vision mask has no bound view")?.clone();
        self.episode=episode;
        self.current=Some(MaskSourceStamp {session,team,episode,represented_tick:tick,
            instance:std::sync::Arc::downgrade(&self.identity),view});
        Ok(())
    }
}

#[derive(Resource,Default)]
pub struct Sources {
    pub factory:CircleFactory,
    pub active:BTreeMap<u32,Weak<Mutex<CircleSource>>>,
    session:Option<u64>,team:Option<u8>,last_snapshot:Option<u64>,last_error:Option<String>,
    mask_status:MaskSourceStatus,
}
impl Sources {
    pub(crate) fn invalidate_mask(&mut self) {self.mask_status.invalidate();}
    pub(crate) fn mask_stamp(&self,map:&Map10VisionView,session:u64,team:u8)->Option<MaskSourceStamp> {
        let stamp=self.mask_status.current.as_ref()?;
        if team>1 || stamp.session!=session || stamp.team!=team
            || self.session!=Some(session) || self.team!=Some(team)
            || self.last_snapshot!=Some(stamp.represented_tick)
            || !stamp.view.ptr_eq(&std::sync::Arc::downgrade(&map.view)) {return None;}
        Some(stamp.clone())
    }
    /// Success certifies one healthy, possibly budgeted processing cycle.
    /// It never asserts that the entire current snapshot has regenerated.
    pub(crate) fn process_snapshot_cycle(&mut self,state:&Snapshot,viewer:u32,map:&mut Map10VisionView,camera:[f32;2],now:f32,delta:f32)->Result<usize,&'static str> {
        let result=self.synchronize(state,viewer,map).and_then(|_|self.process(map,camera,now,delta))
            .and_then(|count| {
                let team=self.team.ok_or("vision cycle has no represented team")?;
                let tick=self.last_snapshot.ok_or("vision cycle has no represented tick")?;
                self.mask_status.publish(state.session,team,tick)?;
                Ok(count)
            });
        if result.is_err() {self.invalidate_mask();}
        result
    }

    pub fn synchronize(&mut self,state:&Snapshot,viewer:u32,map:&mut Map10VisionView)->Result<(),&'static str> {
        self.mask_status.bind(map)?;
        let result=(|| {
        let team=state.roster.iter().find(|p|p.id==viewer).ok_or("missing vision viewer roster")?.team;
        if team>1 {return Err("unsupported vision viewer team");}
        if self.session==Some(state.session) && self.team==Some(team) && self.last_snapshot==Some(state.tick) {return Ok(());}
        let mut desired=BTreeMap::new();
        struct Observation {position:openleague_core::Point,modifiers:openleague_core::vision::RadiusModifiers,geometry:crate::fow_actor_metrics::CharacterGeometry,radius:f32}
        for p in state.players.iter().filter(|p|p.team==team && p.health>0.) {
            let geometry=crate::fow_character_geometry::native_character(&p.champion,None)?;
            let radius=openleague_core::vision::native_base_radius(&p.champion).ok_or("missing native perception radius")?;
            if !p.position.finite() || !radius.is_finite() || radius<=0. {return Err("invalid champion vision input");}
            desired.insert(p.id,Observation {position:p.position,modifiers:p.vision_radius_modifiers,geometry,radius});
        }
        for unit in state.units.iter().filter(|u|u.team==team && u.health>0. && unit_gives_vision(u.kind)) {
            let geometry=crate::fow_character_geometry::native_character(&unit.definition,None)?;
            let radius=openleague_core::vision::native_base_radius(&unit.definition).ok_or("missing native unit perception radius")?;
            if !unit.position.finite() || !radius.is_finite() || radius<=0. {return Err("invalid unit vision input");}
            if desired.insert(unit.id,Observation {position:unit.position,modifiers:unit.vision_radius_modifiers,geometry,radius}).is_some() {return Err("duplicate network vision identity");}
        }
        let reset=self.session!=Some(state.session) || self.team!=Some(team);
        let remove:Vec<_>=self.active.keys().copied().filter(|id|reset || !desired.contains_key(id)).collect();
        for id in remove {let reference=self.active.get(&id).unwrap();map.registry.retire_source(&mut self.factory,reference)?;self.active.remove(&id);}
        for (id,observation) in desired {
            let Observation {position,modifiers,geometry,radius}=observation;
            let reference=self.active.entry(id).or_insert_with(||self.factory.create_without_weak_provider(Inputs {
                // Snapshot identity is an adapter; native descriptor identity is unavailable.
                opaque_ids:[id,0],owner_tag:(u32::from(team)+1)*100,owner:None,center:[position.x,position.z],radius,
                secondary_metric:geometry.secondary,source_metric:geometry.radius,lifetime:0.,
            }));
            CircleSource::update_weak_from_actor(reference,&ActorParameters {character_radius:Some(radius),metric_override:0.,secondary_override:0.,metric_fallback:geometry.radius,secondary_fallback:geometry.secondary,modifiers})?;
            let strong=reference.upgrade().ok_or("expired active champion vision source")?;let mut source=strong.lock().map_err(|_|"poisoned champion vision source")?;
            let center=[position.x,position.z];let epsilon=f32::from_bits(0x3727c5ac);
            if !((center[0]-source.position.center[0]).abs()<=epsilon && (center[1]-source.position.center[1]).abs()<=epsilon) {source.position.center=center;source.parameters.generation_dirty=true;}
        }
        self.session=Some(state.session);self.team=Some(team);self.last_snapshot=Some(state.tick);Ok(())
        })();
        if result.is_err() {self.invalidate_mask();}
        result
    }
    pub fn process(&mut self,map:&Map10VisionView,camera:[f32;2],now:f32,delta:f32)->Result<usize,&'static str> {
        self.mask_status.bind(map)?;
        let result=(|| {
        #[derive(serde::Deserialize)] struct Metadata {min:[f32;3],#[serde(rename="cellSize")]cell_size:f32,width:usize,height:usize}
        struct Terrain {metadata:Metadata,flags:Vec<u16>}
        static TERRAIN:OnceLock<Terrain>=OnceLock::new();let data=TERRAIN.get_or_init(||Terrain {
            metadata:serde_json::from_str(include_str!("../../../assets/maps/tt_navigation_grid.json")).expect("native Map10 terrain metadata"),
            flags:include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin").chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect(),
        });
        let terrain=crate::fow_terrain_ray::TerrainGrid {width:data.metadata.width,height:data.metadata.height,origin:data.metadata.min,cell_size:data.metadata.cell_size,flags:&data.flags};
        let mut view=map.view.lock().map_err(|_|"poisoned Map10 vision view")?;
        for reference in self.active.values() {let strong=reference.upgrade().ok_or("expired champion vision source")?;let mut source=strong.lock().map_err(|_|"poisoned champion vision source")?;view.circle.enqueue_update(reference,&mut source,false,0,camera,map.geometry.extent,now,&[])?;}
        view.circle.process_frame(&self.factory,delta,|source,layer| {source.regenerate_cached(layer,map.geometry.extent,&terrain,&[])?;Ok(())})
        })();
        if result.is_err() {self.invalidate_mask();}
        result
    }
}
pub fn update(state:Res<crate::Match>,connection:Res<crate::Connection>,mut sources:ResMut<Sources>,mut map:ResMut<Map10VisionView>,time:Res<Time>,focus:Res<crate::CameraFocus>) {
    let (Some(snapshot),Some(viewer))=(&state.snapshot,connection.id) else {sources.invalidate_mask();return;};
    let result=sources.process_snapshot_cycle(snapshot,viewer,&mut map,[focus.0.x*20.,focus.0.z*20.],snapshot.tick as f32/openleague_core::TICK_RATE as f32,time.delta_secs());
    let error=result.err().map(str::to_owned);if error!=sources.last_error {if let Some(error)=&error {eprintln!("OpenLeague champion vision: {error}");}sources.last_error=error;}
    if let Ok(path)=std::env::var("OPENLEAGUE_CHAMPION_VISION_PROBE") {
        if let Ok(view)=map.view.lock() {let report=serde_json::json!({"complete":false,"session":snapshot.session,"tick":snapshot.tick,"sources":sources.factory.source_count(),"pending":view.circle.pending.entries().len(),"visible_cells":view.circle.layer.pixels.iter().filter(|v|**v!=0).count(),"source_ids":sources.active.keys().collect::<Vec<_>>(),"error":sources.last_error,"gpu_bound":false,"limits":["Snapshot adapter; native actor descriptor/provider and filter producers remain open.","Allied champions/lane/pet/turret/fountain sources only; altar, ward, stealth and spectator vision missing.","CPU masks only; server filtering remains authoritative and GPU fog is not bound."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());}
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn snapshot_sources_follow_movement_death_removal_modifiers_and_session_reset() {
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut simulation=openleague_core::Simulation::new(nav).unwrap();let viewer=simulation.join("garen").unwrap();let enemy=simulation.join("annie").unwrap();
        simulation.players.get_mut(&viewer).unwrap().position=openleague_core::Point {x:7684.,z:6934.};simulation.players.get_mut(&enemy).unwrap().team=1;
        let mut snapshot=simulation.snapshot();snapshot.session=77;let mut map=Map10VisionView::native_map10().unwrap();let mut sources=Sources::default();sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert_eq!(sources.factory.source_count(),1);assert!(!sources.active.contains_key(&enemy));
        for _ in 0..10 {sources.process(&map,[7684.,6934.],0.,1./30.).unwrap();}
        assert!(map.view.lock().unwrap().circle.layer.pixels.iter().any(|v|*v!=0));
        let old=sources.active[&viewer].clone();{let source=old.upgrade().unwrap();let source=source.lock().unwrap();assert_eq!(source.parameters.source_metric,75.);assert_eq!(source.parameters.secondary_metric,35.);assert_eq!(source.parameters.radius,1350.);}
        snapshot.tick+=1;let p=snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap();p.position.x+=250.;p.vision_radius_modifiers.percent_bubble_radius_mod=-0.5;sources.synchronize(&snapshot,viewer,&mut map).unwrap();let strong=old.upgrade().unwrap();assert_eq!(strong.lock().unwrap().position.center[0],7934.);assert_eq!(strong.lock().unwrap().parameters.scale,0.5);drop(strong);
        snapshot.tick+=1;snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().health=0.;sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert!(old.upgrade().is_none());assert_eq!(sources.factory.source_count(),0);assert!(map.view.lock().unwrap().circle.layer.counts.iter().all(|v|*v==0));assert!(map.view.lock().unwrap().circle.pending.entries().is_empty());
        snapshot.tick+=1;snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().health=100.;sources.synchronize(&snapshot,viewer,&mut map).unwrap();let before_reset=sources.active[&viewer].clone();snapshot.session+=1;snapshot.tick=0;sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert!(before_reset.upgrade().is_none());assert_eq!(sources.factory.source_count(),1);
    }
}

/// Preserves current server eligibility; native full actor/filter producers remain open.
fn unit_gives_vision(kind:openleague_core::world::Kind)->bool {
    kind.lane() || matches!(kind,openleague_core::world::Kind::Pet|openleague_core::world::Kind::Turret|openleague_core::world::Kind::Fountain)
}
#[cfg(test)] mod unit_tests {
    use super::*;
    use openleague_core::world::Kind;
    #[test] fn unit_sources_follow_eligibility_overlap_death_modifiers_and_removal() {
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let viewer=simulation.join("garen").unwrap();
        let mut snapshot=simulation.snapshot();snapshot.session=88;
        let template=snapshot.units.iter().find(|u|u.kind==Kind::Turret).unwrap().clone();snapshot.units.clear();
        let team=snapshot.players.iter().find(|p|p.id==viewer).unwrap().team;
        let definitions=[(Kind::Melee,"Blue_Minion_Basic"),(Kind::Caster,"Blue_Minion_Wizard"),(Kind::Siege,"Blue_Minion_MechCannon"),(Kind::Super,"Blue_Minion_MechMelee"),(Kind::Pet,"AnnieTibbers"),(Kind::Turret,"TT_OrderTurret1"),(Kind::Fountain,"TT_OrderTurret4"),(Kind::Monster,"TT_NWolf"),(Kind::Boss,"TT_Spiderboss"),(Kind::Inhibitor,"TT_OrderInhibitor"),(Kind::Nexus,"OrderNexus")];
        for (i,(kind,definition)) in definitions.iter().enumerate() {let mut u=template.clone();u.id=50000+i as u32;u.team=team;u.kind=*kind;u.definition=definition.to_string();u.health=100.;u.position=openleague_core::Point {x:7684.,z:6934.};snapshot.units.push(u);}
        let mut enemy=snapshot.units[0].clone();enemy.id=60000;enemy.team=1-team;snapshot.units.push(enemy);
        let mut map=Map10VisionView::native_map10().unwrap();let mut sources=Sources::default();sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert_eq!(sources.factory.source_count(),8);
        for i in 0..7 {assert!(sources.active.contains_key(&(50000+i)));}for i in 7..11 {assert!(!sources.active.contains_key(&(50000+i)));}assert!(!sources.active.contains_key(&60000));
        for _ in 0..20 {sources.process(&map,[7684.,6934.],0.,1./30.).unwrap();}assert!(map.view.lock().unwrap().circle.layer.counts.iter().any(|v|*v>1));
        let melee=sources.active[&50000].clone();snapshot.tick+=1;snapshot.units[0].vision_radius_modifiers.percent_bubble_radius_mod=-0.5;snapshot.units[0].position.x+=100.;sources.synchronize(&snapshot,viewer,&mut map).unwrap();{let strong=melee.upgrade().unwrap();let s=strong.lock().unwrap();assert_eq!(s.parameters.radius,1200.);assert_eq!(s.parameters.scale,0.5);assert_eq!(s.position.center[0],7784.);}
        snapshot.tick+=1;snapshot.units[0].health=0.;sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert!(melee.upgrade().is_none());assert_eq!(sources.factory.source_count(),7);
        snapshot.tick+=1;snapshot.units.clear();sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert_eq!(sources.factory.source_count(),1);assert!(map.view.lock().unwrap().circle.pending.entries().iter().all(|e|e.source==sources.active[&viewer].as_ptr() as usize));
    }
}
#[cfg(test)]
pub(crate) mod mask_provenance_tests {
    use super::*;
    pub(crate) fn native_fixture()->(Snapshot,u32,Map10VisionView,Sources) {
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut simulation=openleague_core::Simulation::new(nav).unwrap();
        let viewer=simulation.join("garen").unwrap();let ally=simulation.join("annie").unwrap();
        let team=simulation.players[&viewer].team;
        simulation.players.get_mut(&viewer).unwrap().position=openleague_core::Point {x:7684.,z:6934.};
        let a=simulation.players.get_mut(&ally).unwrap();a.team=team;a.position=openleague_core::Point {x:7900.,z:6934.};
        let mut snapshot=simulation.snapshot();snapshot.session=901;
        (snapshot,viewer,Map10VisionView::native_map10().unwrap(),Sources::default())
    }
    pub(crate) fn cycle(sources:&mut Sources,snapshot:&Snapshot,viewer:u32,map:&mut Map10VisionView)->Result<usize,&'static str> {
        sources.process_snapshot_cycle(snapshot,viewer,map,[7684.,6934.],snapshot.tick as f32/openleague_core::TICK_RATE as f32,1./30.)
    }
    #[test]
    fn healthy_native_sources_keep_episode_and_represented_tick_with_budgeted_work() {
        let (mut snapshot,viewer,mut map,mut sources)=native_fixture();
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
        let first=sources.mask_stamp(&map,snapshot.session,team).unwrap();
        assert!(!map.view.lock().unwrap().circle.pending.entries().is_empty(),"healthy does not mean a fully drained mask");
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let repeated=sources.mask_stamp(&map,snapshot.session,team).unwrap();
        assert!(first.same_episode(&repeated));assert_eq!(first.represented_tick,repeated.represented_tick);
        snapshot.tick+=1;snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().position.x+=100.;
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let moved=sources.mask_stamp(&map,snapshot.session,team).unwrap();
        assert!(first.same_episode(&moved));assert_eq!(moved.represented_tick,snapshot.tick);
        assert!(map.view.lock().unwrap().circle.layer.pixels.iter().any(|p|*p!=0));
    }
    #[test]
    fn native_source_error_and_view_replacement_revoke_then_recover_without_relabel() {
        let (mut snapshot,viewer,mut map,mut sources)=native_fixture();
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
        let first=sources.mask_stamp(&map,snapshot.session,team).unwrap();
        snapshot.tick+=1;snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().position.x+=30.;
        assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let _guard=map.view.lock().unwrap();panic!("intentional view-lock poison in CPU fixture");
        })).is_err());
        assert_eq!(cycle(&mut sources,&snapshot,viewer,&mut map),Err("poisoned Map10 vision view"));
        assert_eq!(sources.last_snapshot,Some(snapshot.tick),"synchronize committed before the real process failure");
        assert!(sources.mask_stamp(&map,snapshot.session,team).is_none());
        map.view.clear_poison();cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let after_process_error=sources.mask_stamp(&map,snapshot.session,team).unwrap();
        assert_eq!(after_process_error.episode,first.episode+1);
        snapshot.tick+=1;let saved=snapshot.players.iter().find(|p|p.id==viewer).unwrap().position;
        snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().position.x=f32::NAN;
        assert!(cycle(&mut sources,&snapshot,viewer,&mut map).is_err());
        assert!(sources.mask_stamp(&map,snapshot.session,team).is_none());
        assert!(cycle(&mut sources,&snapshot,viewer,&mut map).is_err());
        snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().position=saved;
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let recovered=sources.mask_stamp(&map,snapshot.session,team).unwrap();
        assert_eq!(recovered.episode,after_process_error.episode+1);assert!(!first.same_episode(&recovered));
        let mut replacement=Map10VisionView::native_map10().unwrap();
        assert_eq!(cycle(&mut sources,&snapshot,viewer,&mut replacement),Err("vision view replaced; coherent source/view reset required"));
        assert!(sources.mask_stamp(&map,snapshot.session,team).is_none());
        assert!(sources.mask_stamp(&replacement,snapshot.session,team).is_none());
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        assert_eq!(sources.mask_stamp(&map,snapshot.session,team).unwrap().episode,recovered.episode+1);
    }
    #[test]
    fn source_episode_exhaustion_fails_closed_without_wrap() {
        let (snapshot,viewer,mut map,mut sources)=native_fixture();
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();sources.invalidate_mask();
        sources.mask_status.episode=u64::MAX;
        assert_eq!(cycle(&mut sources,&snapshot,viewer,&mut map),Err("vision mask episode exhausted"));
        let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
        assert!(sources.mask_stamp(&map,snapshot.session,team).is_none());assert_eq!(sources.mask_status.episode,u64::MAX);
    }
}

