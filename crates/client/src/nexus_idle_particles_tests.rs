//! Original descriptor/rig data; controlled ECS and clock inputs. No GPU claim.
use super::*;
// Existing lifecycle tests exercise the unchanged per-source engine.
use super::SourceHost as Host;
use bevy::mesh::skinning::SkinnedMeshInverseBindposes;

struct Fixture { world: World, spec: Spec, root: Entity, nodes: Vec<Entity>, binding: Binding }
impl Fixture {
    fn new() -> Self {
        let mut world = World::new(); let spec = Spec::original().unwrap();
        let root = world.spawn((Transform::IDENTITY, GlobalTransform::IDENTITY)).id();
        let nodes: Vec<_> = spec.nodes.iter().map(|n| world.spawn((Name::new(n.name.clone()),
            Transform::IDENTITY, GlobalTransform::IDENTITY)).id()).collect();
        for (i, n) in spec.nodes.iter().enumerate() {
            world.entity_mut(nodes[i]).insert(ChildOf(n.parent.map(|j| nodes[j]).unwrap_or(root)));
        }
        let joints: Vec<_> = spec.nodes.iter().enumerate().filter(|(_, n)| n.joint).map(|(i, _)| nodes[i]).collect();
        world.entity_mut(nodes[0]).insert(SkinnedMesh {
            joints, inverse_bindposes: Handle::<SkinnedMeshInverseBindposes>::default(),
        });
        let bones = spec.descriptors.iter().map(|d| nodes[d.node]).collect::<Vec<_>>().try_into().unwrap();
        let binding = Binding { root, model: Handle::<Gltf>::default().id(), scene: Handle::<WorldAsset>::default().id(),
            nodes: nodes.clone(), bones };
        Self { world, spec, root, nodes, binding }
    }
    fn bind(&self, host: &mut Host, session: u64, now: f64) {
        host.begin_frame(Some(session)).unwrap();
        // Lifecycle fixtures start at a controlled server tick zero. Production
        // supplies the accepted snapshot's actual phase/tick before every bind.
        if host.phase.is_none() { host.observe_phase(Phase::Startup,0,now).unwrap(); }
        host.bind(session, 101, self.binding.clone(), now).unwrap();
        host.publish(&self.spec, [Mat4::IDENTITY; SLOTS]);
    }
}

#[test]
fn nexus_idle_original_eleven_descriptors_and_twenty_one_bones_are_exact() {
    let f = Fixture::new(); let (nodes, bones) = resolve_nodes(&f.world, f.root, &f.spec).unwrap();
    assert_eq!(nodes, f.nodes); assert_eq!(bones, f.binding.bones);
    assert_eq!(f.spec.descriptors[0].authored, "Order_Nexus.troy center");
    assert_eq!(f.spec.descriptors[9].key, "0xceaff836");
    assert_eq!(f.spec.descriptors[10].authored, "Order_Nexus_Base_Glow.troy base6");
    assert_eq!(f.spec.descriptors.iter().filter(|d| d.resource == "Order_Nexus_Crystal_Glow.troy").count(), 6);
}

#[test]
fn nexus_idle_nonempty_collection_updates_without_duplicate_or_restart() {
    let f = Fixture::new(); let mut h = Host::default(); f.bind(&mut h, 1, 20.);
    let cycle = h.cycle().unwrap(); let owners: Vec<_> = h.frame.requests.iter().map(|r| r.owner).collect();
    for time in [20., 20.25, 109., 111., 300.] {
        f.bind(&mut h, 1, time);
        assert_eq!(h.cycle(), Some(cycle)); assert_eq!(h.frame.requests.len(), 11);
        assert_eq!(h.frame.requests.iter().map(|r| r.owner).collect::<Vec<_>>(), owners);
        assert!(h.frame.retired.is_empty()); assert_eq!(h.frame.requests[0].age_seconds, time - 20.);
    }
    // This asserts retained resource identities, not particles alive for 280s.
    assert_eq!(h.next_cycle, 1); assert_eq!(h.next_binding, 1);
}

#[test]
fn nexus_idle_fog_rebind_keeps_birth_and_completed_slots() {
    let f = Fixture::new(); let mut h = Host::default(); f.bind(&mut h, 7, 10.);
    let cycle = h.cycle().unwrap(); let first = h.frame.requests[0].owner;
    h.complete(cycle, 2).unwrap(); h.begin_frame(Some(7)).unwrap(); h.drop_binding();
    assert_eq!(h.frame.retired.len(), 11); assert!(h.frame.requests.is_empty());
    let mut rebound = f.binding.clone(); rebound.root = f.nodes[10]; // controlled replacement identity, no actual scene claim
    h.begin_frame(Some(7)).unwrap(); h.bind(7, 101, rebound, 100.).unwrap();
    h.publish(&f.spec, [Mat4::IDENTITY; SLOTS]);
    assert_eq!(h.cycle(), Some(cycle)); assert_eq!(h.created_at(), Some(10.));
    assert_eq!(h.frame.requests.len(), 10); assert!(!h.frame.requests.iter().any(|r| r.descriptor.slot == 2));
    assert_eq!(h.frame.requests[0].owner.effect_id, first.effect_id);
    assert_ne!(h.frame.requests[0].owner.attachment_generation, first.attachment_generation);
    assert_eq!(h.frame.requests[0].age_seconds, 90.);
}

#[test]
fn nexus_idle_session_change_retires_exact_old_owners_and_new_cycle() {
    let f = Fixture::new(); let mut h = Host::default(); f.bind(&mut h, 7, 50.);
    let old = h.cycle().unwrap(); let owners = h.owners();
    f.bind(&mut h, 8, 60.);
    assert_eq!(h.frame.retired, owners); assert_ne!(h.cycle().unwrap(), old);
    assert_eq!(h.frame.requests[0].age_seconds, 0.);
    assert!(h.complete(old, 1).is_err());
}

#[test]
fn nexus_idle_epoch_is_not_a_new_cycle_and_clock_pause_does_not_age() {
    let f = Fixture::new(); let mut h = Host::default(); f.bind(&mut h, 7, 5.);
    let id = h.cycle(); let frame = h.frame.ordinal;
    // No transport epoch enters this identity; same EffectClock sample repeats.
    for _ in 0..4 { f.bind(&mut h, 7, 5.); }
    assert_eq!(h.cycle(), id); assert_eq!(h.frame.ordinal, frame + 4);
    assert_eq!(h.frame.requests[0].age_seconds, 0.);
    h.begin_frame(Some(7)).unwrap(); assert!(h.bind(7, 101, f.binding.clone(), 4.).is_err());
    assert!(h.frame.requests.is_empty());
    assert!(h.bind(7, 101, f.binding.clone(), f64::NAN).is_err());
}

#[test]
fn nexus_idle_explicit_retire_releases_only_binding_no_source_mutation() {
    let f = Fixture::new(); let mut h = Host::default(); f.bind(&mut h, 1, 1.);
    let count = f.world.entities().len(); let id = h.cycle().unwrap();
    h.retire(); assert_eq!(h.frame.retired.len(), 11); assert_eq!(h.cycle(), None);
    assert_eq!(f.world.entities().len(), count); assert!(resolve_nodes(&f.world, f.root, &f.spec).is_ok());
    assert!(h.complete(id, 1).is_err());
    f.bind(&mut h, 1, 30.); assert_ne!(h.cycle(), Some(id)); assert_eq!(h.created_at(), Some(1.));
}

#[test]
fn nexus_idle_completed_resources_do_not_recreate_at_authored_lifetime_boundaries() {
    let f = Fixture::new(); let mut h = Host::default(); f.bind(&mut h, 1, 0.);
    let id = h.cycle().unwrap(); for slot in 1..=11 { h.complete(id, slot).unwrap(); }
    for now in [1., 87., 89., 91., 95., 900.] { f.bind(&mut h, 1, now); assert!(h.frame.requests.is_empty()); }
    assert_eq!(h.cycle(), Some(id)); assert_eq!(h.next_cycle, 1);
    assert!(h.complete(id, 0).is_err()); assert!(h.complete(id, 12).is_err());
}

#[test]
fn nexus_idle_absent_ambiguous_reparented_and_wrong_skin_bones_are_refused() {
    let mut f = Fixture::new(); f.world.entity_mut(f.nodes[9]).remove::<Name>();
    assert!(resolve_nodes(&f.world, f.root, &f.spec).unwrap_err().contains("absent or ambiguous"));
    let mut f = Fixture::new(); f.world.spawn((Name::new("center"), ChildOf(f.root)));
    assert!(resolve_nodes(&f.world, f.root, &f.spec).unwrap_err().contains("absent or ambiguous"));
    let mut f = Fixture::new(); f.world.entity_mut(f.nodes[9]).insert(ChildOf(f.root));
    assert!(resolve_nodes(&f.world, f.root, &f.spec).unwrap_err().contains("ancestry"));
    let mut f = Fixture::new(); f.world.get_mut::<SkinnedMesh>(f.nodes[0]).unwrap().joints.swap(0, 1);
    assert!(resolve_nodes(&f.world, f.root, &f.spec).unwrap_err().contains("skin joint identity"));
}

#[test]
fn nexus_idle_other_root_same_names_cannot_supply_missing_attachment() {
    let mut f = Fixture::new(); let other = f.world.spawn_empty().id();
    f.world.entity_mut(f.nodes[9]).insert(ChildOf(other));
    assert!(resolve_nodes(&f.world, f.root, &f.spec).is_err());
}

#[test]
fn nexus_idle_frame_uses_full_affine_without_native_pose_or_scale_invention() {
    let f = Fixture::new(); let mut h = Host::default(); f.bind(&mut h, 2, 3.);
    let shear = Mat4::from_cols(Vec4::X, Vec4::new(0.2, 1., 0., 0.), Vec4::Z, Vec4::new(5., 6., 7., 1.));
    let mut matrices = [Mat4::IDENTITY; SLOTS]; matrices[0] = shear;
    h.publish(&f.spec, matrices); assert_eq!(h.frame.requests[0].attachment_world, shear);
    assert_eq!(h.frame.requests[1].attachment_world, Mat4::IDENTITY);
    assert_eq!(h.frame.requests[0].native_idle_resource_flag, 0x10);
}

#[test]
fn nexus_idle_frame_and_owner_exhaustion_fail_without_reusing_identity() {
    let f = Fixture::new(); let mut h = Host::default(); h.frame.ordinal = u64::MAX;
    assert!(h.begin_frame(Some(1)).is_err());
    let mut h = Host::default(); h.next_cycle = u64::MAX;
    h.begin_frame(Some(1)).unwrap();h.observe_phase(Phase::Startup,0,0.).unwrap();
    assert!(h.bind(1, 101, f.binding.clone(), 0.).is_err()); assert!(h.cycle().is_none());
    let mut h = Host::default(); h.next_binding = u64::MAX;
    h.begin_frame(Some(1)).unwrap();h.observe_phase(Phase::Startup,0,0.).unwrap();
    assert!(h.bind(1, 101, f.binding.clone(), 0.).is_err()); assert!(h.owners().is_empty());
}

#[test]
fn server_phase_changes_all_resources_once_and_stale_completion_cannot_retire_on() {
    let f=Fixture::new();let mut h=Host::default();
    h.begin_frame(Some(1)).unwrap();h.observe_phase(Phase::Startup,2247,10.).unwrap();
    h.bind(1,101,f.binding.clone(),10.).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
    let old=h.cycle().unwrap();let owners=h.owners();h.complete(old,1).unwrap();
    h.begin_frame(Some(1)).unwrap();h.observe_phase(Phase::On {started_tick:2250},2253,10.2).unwrap();
    h.bind(1,101,f.binding.clone(),10.2).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
    let on=h.cycle().unwrap();assert_ne!(old,on);assert_eq!(h.frame.retired,owners);
    assert_eq!(h.frame.requests.len(),11);assert!(h.frame.requests.iter().all(|r|r.descriptor.resource.ends_with("_on.troy")));
    assert_eq!(h.frame.requests[0].descriptor.resource,"Order_Nexus_on.troy");
    assert!((h.frame.requests[0].age_seconds-0.1).abs()<1e-10);assert!(h.complete(old,1).is_err());
    for tick in [2253,2256,3000] {
        h.begin_frame(Some(1)).unwrap();h.observe_phase(Phase::On {started_tick:2250},tick,11.).unwrap();
        h.bind(1,101,f.binding.clone(),11.).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
        assert_eq!(h.cycle(),Some(on));assert!(h.frame.retired.is_empty());
    }
}

#[test]
fn late_join_and_reconnect_use_phase_age_not_model_ready_or_eighty_nine_second_timer() {
    let f=Fixture::new();let mut h=Host::default();
    h.begin_frame(Some(2)).unwrap();h.observe_phase(Phase::On {started_tick:2250},6000,5.).unwrap();
    h.bind(2,101,f.binding.clone(),5.).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
    let cycle=h.cycle().unwrap();assert_eq!(h.frame.requests[0].age_seconds,125.);
    h.begin_frame(Some(2)).unwrap();h.drop_binding();
    h.observe_phase(Phase::On {started_tick:2250},6000,10.).unwrap();
    h.begin_frame(Some(2)).unwrap();h.observe_phase(Phase::On {started_tick:2250},6003,11.).unwrap();
    h.bind(2,101,f.binding.clone(),11.).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
    assert_eq!(h.cycle(),Some(cycle));assert_eq!(h.frame.requests[0].age_seconds,131.);
    // Duplicate paused tick/clock cannot reset or advance the presentation.
    for _ in 0..3 {
        h.begin_frame(Some(2)).unwrap();h.observe_phase(Phase::On {started_tick:2250},6003,11.).unwrap();
        h.bind(2,101,f.binding.clone(),11.).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
        assert_eq!(h.frame.requests[0].age_seconds,131.);assert_eq!(h.cycle(),Some(cycle));
    }
}

#[test]
fn a_new_phase_does_not_inherit_extrapolated_age_and_backward_state_cannot_restart_it() {
    let f=Fixture::new();let mut h=Host::default();f.bind(&mut h,1,0.);
    h.begin_frame(Some(1)).unwrap();h.observe_phase(Phase::Startup,2249,1000.).unwrap();
    h.bind(1,101,f.binding.clone(),1000.).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
    assert_eq!(h.frame.requests[0].age_seconds,1000.);
    h.begin_frame(Some(1)).unwrap();h.observe_phase(Phase::On {started_tick:2250},2250,1001.).unwrap();
    h.bind(1,101,f.binding.clone(),1001.).unwrap();h.publish(&f.spec,[Mat4::IDENTITY;SLOTS]);
    assert_eq!(h.frame.requests[0].age_seconds,0.);let cycle=h.cycle();
    assert!(h.observe_phase(Phase::Startup,100,1002.).is_err());
    assert!(h.observe_phase(Phase::On {started_tick:2670},3000,1002.).is_err());
    assert!(h.observe_phase(Phase::On {started_tick:2250},2250,1000.).is_err());
    assert_eq!(h.cycle(),cycle);assert_eq!(h.phase.unwrap().phase,Phase::On {started_tick:2250});
}

#[test]
fn chaos_idle_uses_its_actual_model_and_eleven_original_attachments() {
    let order=Spec::original().unwrap();let chaos=Spec::for_model(CHAOS_MODEL).unwrap();
    assert_eq!(chaos.asset,CHAOS_ASSET);assert_ne!(chaos.asset,order.asset);
    assert_eq!(chaos.descriptors.len(),11);
    for (a,b) in order.descriptors.iter().zip(&chaos.descriptors) {
        assert_eq!(a.node,b.node);assert_eq!(a.skin_index,b.skin_index);assert_eq!(a.bone,b.bone);
        assert_eq!(b.resource,a.resource.replacen("Order","Chaos",1));
        assert_eq!(b.authored,format!("{} {}",b.resource,b.bone));
    }
    assert!(supports_model(MODEL));assert!(supports_model(CHAOS_MODEL));
    assert!(!supports_model("ChaosNexusDestroyed"));assert!(Spec::for_model("ChaosNexusDestroyed").is_err());
    let f=Fixture::new();assert_eq!(resolve_nodes(&f.world,f.root,&chaos).unwrap().1,f.binding.bones);
}

fn both(h:&mut super::Host,f:&Fixture,session:u64,phase:Phase,tick:u64,now:f64) {
    h.begin_frame(Some(session)).unwrap();h.observe_phase(phase,tick,now).unwrap();
    h.bind_source(session,101,&f.spec,f.binding.clone(),[Mat4::IDENTITY;SLOTS],now).unwrap();
    let mut b=f.binding.clone();b.root=f.nodes[10]; // distinct controlled root in the same World
    h.bind_source(session,202,&Spec::for_model(CHAOS_MODEL).unwrap(),b,[Mat4::IDENTITY;SLOTS],now).unwrap();
    h.finish_frame();
}
#[test]
fn two_nexus_sources_have_disjoint_owners_and_independent_completion_and_retirement() {
    let f=Fixture::new();let mut h=super::Host::default();both(&mut h,&f,9,Phase::Startup,30,5.);
    assert_eq!(h.frame.requests.len(),22);
    let ids:HashSet<_>=h.frame.requests.iter().map(|r|r.owner.effect_id).collect();assert_eq!(ids.len(),22);
    let blue=h.sources[&101].state.cycle().unwrap();let red=h.sources[&202].state.cycle().unwrap();
    assert_ne!(blue.serial,red.serial);let redowners=h.sources[&202].state.owners();
    h.complete(blue,1).unwrap();assert_eq!(h.frame.requests.len(),21);
    assert!(h.frame.requests.iter().any(|r|r.cycle==red && r.descriptor.slot==1));
    h.retire_source(101);h.finish_frame();
    assert_eq!(h.frame.requests.len(),11);assert_eq!(h.sources[&202].state.owners(),redowners);
    assert!(h.frame.retired.iter().all(|r|!redowners.contains(r)));
    assert!(h.complete(blue,1).is_err());h.complete(red,1).unwrap();
    assert_eq!(h.frame.requests.len(),10);
}
#[test]
fn two_nexus_fog_rebind_keeps_age_identity_and_does_not_restart_the_other_source() {
    let f=Fixture::new();let mut h=super::Host::default();
    let phase=Phase::On {started_tick:2250};both(&mut h,&f,9,phase,6000,5.);
    let red=h.sources[&202].state.cycle().unwrap();let blue=h.sources[&101].state.owners();
    let old=h.sources[&202].state.owners();
    h.begin_frame(Some(9)).unwrap();h.observe_phase(phase,6000,10.).unwrap();
    h.sources.get_mut(&202).unwrap().state.drop_binding();
    h.bind_source(9,101,&f.spec,f.binding.clone(),[Mat4::IDENTITY;SLOTS],10.).unwrap();h.finish_frame();
    assert_eq!(h.frame.requests.len(),11);assert_eq!(h.sources[&101].state.owners(),blue);
    assert_eq!(h.frame.retired,old);
    both(&mut h,&f,9,phase,6003,11.);
    assert_eq!(h.sources[&202].state.cycle(),Some(red));assert_eq!(h.sources[&101].state.owners(),blue);
    assert_eq!(h.frame.requests.iter().find(|r|r.cycle.source==202).unwrap().age_seconds,131.);
    let new=h.sources[&202].state.owners();assert_eq!(new[0].effect_id,old[0].effect_id);
    assert_ne!(new[0].attachment_generation,old[0].attachment_generation);
}
#[test]
fn common_phase_replaces_both_sources_once_and_session_change_rejects_old_completions() {
    let f=Fixture::new();let mut h=super::Host::default();both(&mut h,&f,9,Phase::Startup,2249,1000.);
    let old:Vec<_>=h.sources.values().map(|s|s.state.cycle().unwrap()).collect();
    both(&mut h,&f,9,Phase::On {started_tick:2250},2250,1001.);
    assert_eq!(h.frame.retired.len(),22);assert_eq!(h.frame.requests.len(),22);
    assert!(h.frame.requests.iter().all(|r|r.age_seconds==0. && r.descriptor.resource.ends_with("_on.troy")));
    for c in old {assert!(h.complete(c,1).is_err());}
    let owners:Vec<_>=h.frame.requests.iter().map(|r|r.owner).collect();
    both(&mut h,&f,9,Phase::On {started_tick:2250},2250,1001.);
    assert!(h.frame.retired.is_empty());assert_eq!(h.frame.requests.iter().map(|r|r.owner).collect::<Vec<_>>(),owners);
    let old=h.sources[&202].state.cycle().unwrap();
    both(&mut h,&f,10,Phase::Startup,0,1002.);
    assert_eq!(h.frame.retired.len(),22);assert!(h.complete(old,1).is_err());
    assert!(h.frame.requests.iter().all(|r|r.owner.session==10 && r.age_seconds==0.));
}
