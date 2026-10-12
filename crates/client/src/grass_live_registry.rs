//! Live snapshot/model adapter to the qualified owned spatial contracts.
use bevy::prelude::*;
use std::collections::BTreeMap;
use crate::{grass_object_registry::{Registry,Wrapper},grass_subdivision::Tree,grass_tree_service::Service};
pub struct Observation {pub id:u32,pub model:String,pub position:[f32;3],pub actor_scale:f32}
struct Tracked {index:usize,model:String}
#[derive(Resource)]
pub struct Live {pub registry:Registry,pub tree:Tree,pub service:Service,active:BTreeMap<u32,Tracked>,session:Option<u64>,last_error:Option<String>,unqualified_models:BTreeMap<u32,String>}
impl Default for Live {
 fn default()->Self {
    let mut tree=Tree{nodes:Vec::new(),midpoints:Vec::new(),depths:Vec::new(),queued:Vec::new(),queue:Vec::new(),pool:Vec::new(),pool_capacity:0,max_depth:0};
    let service=crate::grass_tree_service::create(&mut tree).expect("native spatial tree defaults");
    Self{registry:Registry{objects:Vec::new(),recycled:Vec::new(),recycled_capacity:0},tree,service,active:BTreeMap::new(),session:None,last_error:None,unqualified_models:BTreeMap::new()}
 }
}
impl Live {
 fn retire(&mut self,id:u32)->Result<(),&'static str> {
    let actor=self.active.get(&id).ok_or("missing live spatial actor")?;
    let mut wrapper=Wrapper{object:Some(actor.index),released:false};crate::grass_object_registry::dispose(&mut wrapper,&mut self.registry,&mut self.tree,|_|{})?;
    self.active.remove(&id);Ok(())
 }
 pub fn synchronize(&mut self,session:u64,observations:&[Observation])->Result<(),&'static str> {
    let mut desired=BTreeMap::new();
    // Resolve actual model resources and arithmetic before changing ownership.
    for actor in observations {
        let model=crate::grass_model_bounds::model(&actor.model)?;
        if !actor.actor_scale.is_finite()||actor.position.iter().any(|v|!v.is_finite()){return Err("invalid live spatial actor input");}
        let aabb=crate::grass_actor_aabb::calculate(actor.position,Some([model.skin_scale,actor.actor_scale]),||model.local);
        if aabb.iter().any(|v|!v.is_finite()){return Err("live spatial actor bounds overflow");}
        if desired.insert(actor.id,(actor,aabb)).is_some(){return Err("duplicate live spatial actor identity");}
    }
    let reset=self.session!=Some(session);
    let remove:Vec<_>=self.active.iter().filter_map(|(id,tracked)|if reset||desired.get(id).is_none_or(|(actor,_)|actor.model!=tracked.model){Some(*id)}else{None}).collect();
    for id in remove{self.retire(id)?;}
    if reset{crate::grass_tree_service::close(&mut self.service,&mut self.tree)?;self.service=crate::grass_tree_service::create(&mut self.tree)?;self.session=Some(session);}
    for (id,(actor,aabb)) in desired {
        if let Some(tracked)=self.active.get(&id) {
            crate::grass_object_registry::update_aabb(&mut self.registry,&mut self.tree,&self.service,tracked.index,aabb,|_,_|{})?;
        }else{
            let center=[(aabb[0]+aabb[3])*0.5,(aabb[4]+aabb[1])*0.5,(aabb[5]+aabb[2])*0.5];
            let upper=std::array::from_fn::<_,3,_>(|i|(aabb[i+3]-aabb[i])*0.5);let lower=upper.map(|v|f32::from_bits(v.to_bits()^0x80000000));
            // Rust storage is explicitly zeroed; this is not a native heap ABI claim.
            let index=crate::grass_object_registry::register(&mut self.registry,&mut self.tree,&self.service,u64::from(id),center,[lower[0],lower[1],lower[2],upper[0],upper[1],upper[2]],crate::grass_spatial_bounds::IntegerProfile::Sse,[0;4],|_,_|{})?;
            self.active.insert(id,Tracked{index,model:actor.model.clone()});
        }
    }
    self.drain_subdivisions()?;
    Ok(())
 }
 fn drain_subdivisions(&mut self)->Result<(),&'static str> {
    if self.tree.queue.is_empty(){return Ok(());}
    // Member identities are object slots, not network identities. Preserve every
    // slot, including recycled storage, so subdivision writes the right parent.
    let mut actors:Vec<crate::grass_subdivision::Actor>=self.registry.objects.iter().map(|object|crate::grass_subdivision::Actor{
        bounds:object.indexed.integer_bounds,center_y:object.indexed.node.center[1],
        local_y:[object.indexed.local_bounds[1],object.indexed.local_bounds[4]],parent:object.parent
    }).collect();
    let result=crate::grass_subdivision::drain(&mut self.tree,&mut actors,|_|{});
    // Preserve ownership writes even if a later queued operation fails.
    for (object,actor) in self.registry.objects.iter_mut().zip(actors){
        object.parent=actor.parent;object.indexed.node.parent_present=actor.parent.is_some();
    }
    result
 }
 fn report(&self,tick:Option<u64>)->serde_json::Value {
    let objects:Vec<_>=self.active.iter().map(|(id,tracked)|{let object=&self.registry.objects[tracked.index];serde_json::json!({"id":id,"model":tracked.model,"object":tracked.index,"owner":object.owner,"parent":object.parent,"center_bits":object.indexed.node.center.map(f32::to_bits),"local_bits":object.indexed.local_bounds.map(f32::to_bits),"integer_bounds":object.indexed.integer_bounds})}).collect();
    serde_json::json!({"session":self.session,"tick":tick,"registered":self.active.len(),"objects":objects,"root":self.service.root,"root_members":self.service.root.map(|root|self.tree.nodes[root].members.len()),"queued_subdivisions":self.tree.queue.len(),"live_nodes":self.tree.nodes.iter().filter(|node|!node.detached).count(),"maximum_depth":self.tree.depths.iter().enumerate().filter(|(i,_)|!self.tree.nodes[*i].detached).map(|(_,depth)|*depth).max(),"recycled_objects":self.registry.recycled.len(),"object_pool_capacity":self.registry.recycled_capacity,"error":self.last_error,"unqualified_loaded_models":self.unqualified_models,"collector_mask_bound":false})
 }
}
pub fn update(state:Res<crate::Match>,loaded:Query<&crate::animation::Playback>,mut live:ResMut<Live>) {
    if let Some(snapshot)=&state.snapshot {
        let models:BTreeMap<_,_>=loaded.iter().map(|model|(model.network_id(),model.model_name())).collect();
        let (observations,unqualified)=loaded_observations(snapshot,&models);live.unqualified_models=unqualified;
        let error=live.synchronize(snapshot.session,&observations).err().map(str::to_owned);
        if error!=live.last_error{if let Some(error)=&error{eprintln!("OpenLeague spatial actors: {error}");}live.last_error=error;}
    }else if live.session.is_some(){live.unqualified_models.clear();let error=live.synchronize(0,&[]).err().map(str::to_owned);live.last_error=error;}
    if let Ok(path)=std::env::var("OPENLEAGUE_SPATIAL_ACTORS_PROBE"){if let Ok(text)=serde_json::to_string_pretty(&live.report(state.snapshot.as_ref().map(|s|s.tick))){let _=std::fs::write(path,text);}}
}
fn loaded_observations(snapshot:&openleague_core::Snapshot,models:&BTreeMap<u32,&str>)->(Vec<Observation>,BTreeMap<u32,String>) {
    let mut observations=Vec::new();let mut unqualified=BTreeMap::new();
    let mut observe=|id:u32,expected:&str,position:[f32;3]|{
        let Some(name)=models.get(&id) else{return;};
        if !name.eq_ignore_ascii_case(expected){return;}
        if crate::grass_model_bounds::model(name).is_err(){unqualified.insert(id,(*name).to_owned());return;}
        observations.push(Observation{id,model:(*name).to_owned(),position,actor_scale:1.});
    };
    for actor in &snapshot.players{observe(actor.id,&actor.champion,[actor.position.x,actor.height,actor.position.z]);}
    for unit in &snapshot.units{
        let name=if unit.kind.structure()&&unit.health<=0.{format!("{}_destroyed",unit.definition)}else{unit.definition.clone()};
        observe(unit.id,&name,[unit.position.x,unit.height,unit.position.z]);
    }
    if let Some(map)=&snapshot.map10 {
        for altar in &map.altars {
            // Same identity and model choice as receive's actual visual producer.
            let name=if altar.name=="altar_west"{"altar_l"}else{"altar_r"};
            observe(altar.id,name,[altar.position.x,altar.height,altar.position.z]);
        }
    }
    (observations,unqualified)
}
#[cfg(test)] mod tests {
 use super::*;
 fn actor(id:u32,name:&str,x:f32)->Observation{Observation{id,model:name.into(),position:[x,44.,8100.],actor_scale:1.}}
 #[test] fn actual_model_registry_tracks_movement_removal_reuse_and_session_reset() {
    let mut live=Live::default();live.synchronize(7,&[actor(1,"garen",14700.),actor(2,"annie",14000.)]).unwrap();assert_eq!(live.active.len(),2);let root=live.service.root.unwrap();assert_eq!(live.tree.nodes[root].members.len(),2);
    let index=live.active[&1].index;let before=live.registry.objects[index].indexed.integer_bounds;
    live.synchronize(7,&[actor(1,"garen",14800.)]).unwrap();assert_eq!(live.active.len(),1);assert_eq!(live.registry.recycled.len(),1);assert_ne!(live.registry.objects[index].indexed.integer_bounds,before);
    live.synchronize(7,&[actor(1,"garen",14800.),actor(3,"ahri",13000.)]).unwrap();assert_eq!(live.registry.recycled.len(),0);assert_eq!(live.tree.nodes[root].members.len(),2);
    live.synchronize(8,&[actor(4,"aatrox",12000.)]).unwrap();assert_eq!(live.active.len(),1);assert_eq!(live.registry.objects[live.active[&4].index].owner,4);assert_eq!(live.tree.nodes[live.service.root.unwrap()].members.len(),1);
    let len=live.active.len();assert!(live.synchronize(8,&[actor(5,"unknown-model",1.)]).is_err());assert_eq!(live.active.len(),len);
    assert!(live.synchronize(8,&[actor(5,"garen",1.),actor(5,"garen",2.)]).is_err());assert_eq!(live.active.len(),len);
    live.synchronize(8,&[]).unwrap();assert!(live.active.is_empty());assert_eq!(live.tree.nodes[live.service.root.unwrap()].members.len(),0);
 }

 #[test] fn live_subdivision_preserves_ownership_through_crossing_withdrawal_and_pool_reuse() {
    fn verify(live:&Live){
        assert!(live.tree.queue.is_empty());
        let mut seen=std::collections::BTreeSet::new();
        for (node_index,node) in live.tree.nodes.iter().enumerate().filter(|(_,n)|!n.detached){
            for child in node.children.into_iter().flatten(){assert!(!live.tree.nodes[child].detached);assert_eq!(live.tree.nodes[child].parent,Some(node_index));}
            for member in &node.members{
                let index=member.id as usize;assert!(seen.insert(index),"duplicate object membership");
                assert!(!live.registry.recycled.contains(&index));
                let object=&live.registry.objects[index];assert_eq!(object.parent,Some(node_index));assert!(object.indexed.node.parent_present);
                assert!(crate::grass_parent::contains(node.bounds,object.indexed.integer_bounds));
            }
        }
        assert_eq!(seen.len(),live.active.len());
        for tracked in live.active.values(){assert!(seen.contains(&tracked.index));}
        for index in &live.registry.recycled{assert!(live.registry.objects[*index].parent.is_none());assert!(!live.registry.objects[*index].indexed.node.parent_present);}
    }
    let mut live=Live::default();
    let mut observations:Vec<_>=(0..96).map(|i|Observation{id:1000+i,model:"garen".into(),position:[7000.+(i%12) as f32*120.,44.,7000.+(i/12) as f32*120.],actor_scale:1.}).collect();
    live.synchronize(9,&observations).unwrap();verify(&live);
    assert!(live.tree.depths.iter().any(|depth|*depth>2));
    assert!(live.active.values().any(|tracked|live.registry.objects[tracked.index].parent!=live.service.root));
    for actor in &mut observations{actor.position[0]=-actor.position[0];actor.position[2]=-actor.position[2];}
    live.synchronize(9,&observations).unwrap();verify(&live);
    observations.retain(|actor|actor.id%2==0);live.synchronize(9,&observations).unwrap();verify(&live);assert_eq!(live.registry.recycled.len(),48);
    for i in 0..48{observations.push(Observation{id:2000+i,model:"annie".into(),position:[10000.+(i%8) as f32*140.,60.,5000.+(i/8) as f32*140.],actor_scale:1.});}
    live.synchronize(9,&observations).unwrap();verify(&live);assert_eq!(live.registry.objects.len(),96);assert!(live.registry.recycled.is_empty());
    live.synchronize(9,&[]).unwrap();verify(&live);assert_eq!(live.registry.recycled.len(),96);
    assert!(live.tree.nodes[live.service.root.unwrap()].children.iter().all(Option::is_none));
    live.synchronize(10,&observations).unwrap();verify(&live);assert_eq!(live.registry.objects.len(),96);
 }

 #[test] fn loaded_world_models_follow_snapshot_identity_position_removal_and_unqualified_variants(){
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let player=simulation.join("garen").unwrap();let mut snapshot=simulation.snapshot();snapshot.session=700;
    let template=snapshot.units[0].clone();snapshot.units.clear();
    let world:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_grass_world_model_bounds.json")).unwrap();
    let mut names=BTreeMap::new();names.insert(player,"garen".to_owned());
    for (i,name) in world.as_object().unwrap().keys().enumerate(){let mut unit=template.clone();unit.id=50000+i as u32;unit.definition=name.clone();unit.kind=openleague_core::world::Kind::Monster;unit.health=100.;unit.position=openleague_core::Point{x:7000.+i as f32*80.,z:8100.};unit.height=45.;names.insert(unit.id,name.clone());snapshot.units.push(unit);}
    let mut unresolved=template.clone();unresolved.id=60000;unresolved.definition="missing-structure".into();unresolved.kind=openleague_core::world::Kind::Turret;unresolved.health=100.;snapshot.units.push(unresolved);names.insert(60000,"missing-structure".into());
    let mut live=Live::default();let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (observations,unqualified)=loaded_observations(&snapshot,&loaded);
    assert_eq!(observations.len(),17);assert_eq!(unqualified.len(),1);assert_eq!(unqualified[&60000],"missing-structure");live.synchronize(700,&observations).unwrap();assert!(live.tree.queue.is_empty());
    let id=snapshot.units[0].id;let slot=live.active[&id].index;let before=live.registry.objects[slot].indexed.integer_bounds;snapshot.units[0].position.x+=500.;
    let (observations,_)=loaded_observations(&snapshot,&loaded);live.synchronize(700,&observations).unwrap();assert_ne!(live.registry.objects[slot].indexed.integer_bounds,before);
    snapshot.units.remove(0);let (observations,_)=loaded_observations(&snapshot,&loaded);live.synchronize(700,&observations).unwrap();assert!(!live.active.contains_key(&id));assert!(live.registry.recycled.contains(&slot));
    snapshot.units.last_mut().unwrap().health=0.;let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert!(unqualified.is_empty(),"previous live model must not stand in for destroyed model");assert_eq!(observations.len(),16);
    let mut destroyed=names.clone();destroyed.insert(60000,"missing-structure_destroyed".into());let destroyed=destroyed.iter().map(|(id,n)|(*id,n.as_str())).collect();let (_,unqualified)=loaded_observations(&snapshot,&destroyed);assert_eq!(unqualified[&60000],"missing-structure_destroyed");
 }

 #[test] fn loaded_intact_structures_register_and_retire_when_destroyed_variant_changes(){
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let mut snapshot=simulation.snapshot();snapshot.session=701;
    let template=snapshot.units[0].clone();snapshot.units.clear();
    let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_grass_structure_model_bounds.json")).unwrap();let mut names=BTreeMap::new();
    for (i,name) in catalog.as_object().unwrap().keys().enumerate(){let mut unit=template.clone();unit.id=70000+i as u32;unit.definition=name.clone();unit.kind=openleague_core::world::Kind::Turret;unit.health=100.;unit.position=openleague_core::Point{x:6000.+i as f32*600.,z:7000.};names.insert(unit.id,name.clone());snapshot.units.push(unit);}
    let mut live=Live::default();let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert_eq!(observations.len(),12);assert!(unqualified.is_empty());live.synchronize(701,&observations).unwrap();
    for tracked in live.active.values(){let object=&live.registry.objects[tracked.index];assert!(object.indexed.node.parent_present);assert_eq!(live.tree.nodes[object.parent.unwrap()].members.iter().filter(|m|m.id==tracked.index as u64).count(),1);}
    let id=snapshot.units[0].id;let slot=live.active[&id].index;let original=names[&id].clone();snapshot.units[0].health=0.;let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert_eq!(observations.len(),11);assert!(unqualified.is_empty());live.synchronize(701,&observations).unwrap();assert!(live.registry.recycled.contains(&slot));assert!(live.registry.objects[slot].parent.is_none());
    names.insert(id,format!("{original}_destroyed"));let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert!(unqualified.is_empty());assert_eq!(observations.len(),12);live.synchronize(701,&observations).unwrap();assert_eq!(live.active[&id].model,format!("{original}_destroyed"));assert_eq!(live.active[&id].index,slot);assert!(live.registry.objects[slot].parent.is_some());
    snapshot.units[0].health=100.;names.insert(id,original);let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (observations,_)=loaded_observations(&snapshot,&loaded);live.synchronize(701,&observations).unwrap();assert_eq!(live.active.len(),12);assert_eq!(live.active[&id].index,slot);
 }

 #[test] fn actual_map10_altars_follow_loaded_network_identity_movement_and_removal(){
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let mut snapshot=simulation.snapshot();snapshot.session=702;
    let map=snapshot.map10.as_mut().unwrap();assert_eq!(map.altars.len(),2);let west=map.altars.iter().find(|altar|altar.name=="altar_west").unwrap().id;let east=map.altars.iter().find(|altar|altar.name!="altar_west").unwrap().id;
    let models=BTreeMap::from([(west,"altar_l"),(east,"altar_r")]);let (observations,unqualified)=loaded_observations(&snapshot,&models);assert_eq!(observations.len(),2);assert!(unqualified.is_empty());let mut live=Live::default();live.synchronize(702,&observations).unwrap();assert_eq!(live.active[&west].model,"altar_l");assert_eq!(live.active[&east].model,"altar_r");
    let slot=live.active[&west].index;let before=live.registry.objects[slot].indexed.node.center;snapshot.map10.as_mut().unwrap().altars.iter_mut().find(|altar|altar.id==west).unwrap().position.x+=120.;let (observations,_)=loaded_observations(&snapshot,&models);live.synchronize(702,&observations).unwrap();assert_ne!(live.registry.objects[slot].indexed.node.center,before);
    let wrong=BTreeMap::from([(west,"altar_r"),(east,"altar_r")]);let (observations,_)=loaded_observations(&snapshot,&wrong);assert_eq!(observations.len(),1);live.synchronize(702,&observations).unwrap();assert!(!live.active.contains_key(&west));assert!(live.registry.recycled.contains(&slot));
    snapshot.map10=None;let (observations,_)=loaded_observations(&snapshot,&models);assert!(observations.is_empty());live.synchronize(702,&observations).unwrap();assert!(live.active.is_empty());
 }
}
