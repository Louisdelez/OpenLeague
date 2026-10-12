from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
p=r/'crates/client/src/grass_spatial_extents.rs';s=p.read_text(encoding='utf-8');assert 'pub fn update_try' not in s
signature="pub fn update(node:&mut IndexedNode,radius:&mut f32,local:[f32;6],mut apply:impl FnMut(Event,[f32;6],f32,[i32;4]))->Result<(),&'static str> {"
adapter=signature+"\n    update_try(node,radius,local,|event,local,radius,bounds|{apply(event,local,radius,bounds);Ok(())})\n}\npub fn update_try(node:&mut IndexedNode,radius:&mut f32,local:[f32;6],mut apply:impl FnMut(Event,[f32;6],f32,[i32;4])->Result<(),&'static str>)->Result<(),&'static str> {"
assert signature in s;s=s.replace(signature,adapter)
s=s.replace('apply(Event::Bounds,node.local_bounds,*radius,node.integer_bounds);','apply(Event::Bounds,node.local_bounds,*radius,node.integer_bounds)?;').replace('apply(Event::Parent,node.local_bounds,*radius,node.integer_bounds);','apply(Event::Parent,node.local_bounds,*radius,node.integer_bounds)?;');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_spatial_chain.rs';s=p.read_text(encoding='utf-8');assert 'pub fn propagate_try' not in s
signature="pub fn propagate(aabb:[f32;6],node:Option<&mut IndexedNode>,radius:&mut f32,mut apply:impl FnMut(Event,Snapshot))->Result<(),&'static str> {"
adapter=signature+"\n    propagate_try(aabb,node,radius,|event,snapshot|{apply(event,snapshot);Ok(())})\n}\n/// Fallible observers allow real parent reindexing to stop on unsupported state.\npub fn propagate_try(aabb:[f32;6],node:Option<&mut IndexedNode>,radius:&mut f32,mut apply:impl FnMut(Event,Snapshot)->Result<(),&'static str>)->Result<(),&'static str> {"
assert signature in s;s=s.replace(signature,adapter)
s=s.replace('apply(Event::Bounds,snapshot(node,*radius));','apply(Event::Bounds,snapshot(node,*radius))?;').replace('apply(Event::Parent,snapshot(node,*radius));','apply(Event::Parent,snapshot(node,*radius))?;').replace('apply(Event::Extents,snapshot(node,*radius));','apply(Event::Extents,snapshot(node,*radius))?;')
s=s.replace('grass_spatial_extents::update(node,radius,local,|event,','grass_spatial_extents::update_try(node,radius,local,|event,');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_object_registry.rs';s=p.read_text(encoding='utf-8');assert 'pub fn update_aabb' not in s
anchor='/// Owned equivalent of successful native71A560 wrapper destruction.'
code='''#[derive(Clone,Copy)] pub enum UpdateEvent {Bounds,Parent,Extents,Insert,Schedule}
/// Executes each parent operation at its native position in the spatial chain.
pub fn update_aabb(registry:&mut Registry,tree:&mut Tree,service:&Service,index:usize,aabb:[f32;6],mut apply:impl FnMut(UpdateEvent,crate::grass_spatial_chain::Snapshot))->Result<(),&'static str> {
    let object=registry.objects.get_mut(index).ok_or("invalid spatial object update")?;
    if registry.recycled.contains(&index){return Err("recycled spatial object update");}
    if object.parent.is_some()&&service.root.is_none(){return Err("missing spatial tree service root");}
    let Object{indexed,radius,parent,..}=object;indexed.node.parent_present=parent.is_some();
    crate::grass_spatial_chain::propagate_try(aabb,Some(indexed),radius,|event,state|{
        apply(match event{crate::grass_spatial_chain::Event::Bounds=>UpdateEvent::Bounds,crate::grass_spatial_chain::Event::Parent=>UpdateEvent::Parent,crate::grass_spatial_chain::Event::Extents=>UpdateEvent::Extents},state);
        if matches!(event,crate::grass_spatial_chain::Event::Parent) {
            let current=parent.ok_or("missing spatial object parent")?;let root=service.root.ok_or("missing spatial tree service root")?;
            crate::grass_pool::reindex(tree,current,root,index as u64,index as u64,state.integer_bounds,state.center[1],[state.local[1],state.local[4]],parent,|_|{},|event|apply(match event{crate::grass_insertion::Event::Insert(_)=>UpdateEvent::Insert,crate::grass_insertion::Event::Schedule(_)=>UpdateEvent::Schedule},state))?;
        }
        Ok(())
    })?;
    indexed.node.parent_present=parent.is_some();Ok(())
}
'''
assert anchor in s;s=s.replace(anchor,code+anchor);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_actor_aabb.rs';s=p.read_text(encoding='utf-8');assert 'pub fn refresh_owned' not in s
anchor='fn derive(aabb:'
code='''/// Refreshes actor metrics through its owned spatial registry and tree.
pub fn refresh_owned(position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32,registry:&mut crate::grass_object_registry::Registry,tree:&mut crate::grass_subdivision::Tree,service:&crate::grass_tree_service::Service,object:Option<usize>,apply:impl FnMut(crate::grass_object_registry::UpdateEvent,crate::grass_spatial_chain::Snapshot))->Result<State,&'static str> {
    let aabb=calculate(position,model_scales,bounds);
    if let Some(index)=object{crate::grass_object_registry::update_aabb(registry,tree,service,index,aabb,apply)?;}
    Ok(derive(aabb,raw_shape,raw_radius,initial_height,initial_radius))
}
'''
assert anchor in s;s=s.replace(anchor,code+anchor);p.write_text(s,encoding='utf-8')
for name in ['install_grass_registered_tree.py','probe_native_grass_registered_tree.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
