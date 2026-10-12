from pathlib import Path
root=Path('E:/OpenLeague')
p=root/'crates/client/src/grass_live_registry.rs'
s=p.read_text(encoding='utf-8')
assert 'fn drain_subdivisions' not in s
needle='    Ok(())\n }\n fn report'
replacement='''    self.drain_subdivisions()?;
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
 fn report'''
assert needle in s
s=s.replace(needle,replacement,1)
s=s.replace('"root_members":self.service.root.map(|root|self.tree.nodes[root].members.len()),','"root_members":self.service.root.map(|root|self.tree.nodes[root].members.len()),"queued_subdivisions":self.tree.queue.len(),"live_nodes":self.tree.nodes.iter().filter(|node|!node.detached).count(),"maximum_depth":self.tree.depths.iter().enumerate().filter(|(i,_)|!self.tree.nodes[*i].detached).map(|(_,depth)|*depth).max(),')
test='''
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
'''
assert s.endswith('}\n')
s=s[:-2]+test+'}\n'
p.write_text(s,encoding='utf-8')
print('Installed live subdivision drain and compound 96-actor lifecycle check')
