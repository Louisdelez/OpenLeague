use super::*;
use crate::spawn_mist_state::fingerprint;
fn binding(world:&mut World,config:&Configuration)->Binding{
 Binding{session:7,map_root:world.spawn_empty().id(),model:Handle::<Gltf>::default().id(),roots:[world.spawn_empty().id(),world.spawn_empty().id()],positions:config.positions}
}
fn state_words(state:&State)->serde_json::Value{
 serde_json::json!({"ordinal":state.ordinal,"clock":state.last_clock,"rng":[state.rng.first,state.rng.second],"rng_words":state.rng.words.to_vec(),
  "effects":state.active.as_ref().map(|a|a.effects.iter().map(|e|e.host.storage.particles.iter().map(|r|serde_json::json!({"life":r.life,"color":r.color,"scale":r.scale,"uv":r.uv,"surface":r.surface.to_vec(),"counter":r.field_88})).collect::<Vec<_>>()).collect::<Vec<_>>())})
}
#[test]
fn native_two_source_plans_preserve_rng_and_owned_buffers_until_atomic_publication(){
 let config=local_configuration().unwrap();let mut world=World::new();let owner=binding(&mut world,&config);
 assert_eq!(config.sources[0].native.effect,Effect::Chaos);assert_eq!(config.sources[1].native.effect,Effect::Order);
 assert_eq!(owner.positions[0],[14350.8f32,170.404,7305.33].map(f32::to_bits));
 assert_eq!(owner.positions[1],[1076.6f32,164.69,7303.47].map(f32::to_bits));
 assert!(config.sources.iter().all(|s|!s.getter_source.attribute_enabled&&!s.native.factory.provider_capability));
 let mut state=State::new(Rng55::from_filetime(116_444_736_123_456_789));
 for now in [0.,0.1,0.8,1.2,2.1,4.2,6.2]{let before=state_words(&state);let plan=state.planned(Some(owner),now,&config.sources).unwrap();
  assert_eq!(state_words(&state),before,"Planning must not publish a partial source or RNG");state.commit(plan,Some(owner)).unwrap();
 }
 let before=state_words(&state);let mut invalid=config.sources.clone();invalid[1].profile.lifetime_scale.table.clear();
 assert!(state.planned(Some(owner),7.5,&invalid).is_err(),"Late Order lifetime sampler failure must reject the staged Chaos+Order plan");
 assert_eq!(state_words(&state),before);
 let pending=state.planned(Some(owner),6.5,&config.sources).unwrap();let mut stale=owner;stale.session+=1;
 assert!(state.commit(pending,Some(stale)).is_err());assert_eq!(state_words(&state),before);
 // Loss of an owner must retire both effects without advancing the stream.
 let rng=fingerprint(&state.rng);let plan=state.retired().unwrap();state.commit(plan,None).unwrap();
 assert!(state.active.is_none());assert_eq!(fingerprint(&state.rng),rng);
 // A new source lease starts at the current clock; the application stream is
 // retained rather than seeded again with the first session's seed.
 let mut next=owner;next.session+=1;next.roots=[world.spawn_empty().id(),world.spawn_empty().id()];
 let plan=state.planned(Some(next),6.5,&config.sources).unwrap();state.commit(plan,Some(next)).unwrap();
 assert_eq!(state.active.as_ref().unwrap().binding,next);
 assert!(state.active.as_ref().unwrap().effects.iter().all(|e|e.created.context.start==6.5));
 println!("Native source-parameter ports; two-source staging, late sampler failure, stale owner rejection, retirement and retained application RNG passed. No GPU/original-trigger claim.");
}
fn material()->MistMaterial{MistMaterial::from_images(std::array::from_fn(|_|Handle::default()),Inputs{uv_scale_offset:Vec4::new(2.,1.,0.,0.),lookup_uv:Vec2::ZERO,color_factor:Vec4::ONE,fog_uv_scale_offset:Vec4::ZERO,output_encoding:OutputEncoding::RawNumeric,cull:Cull::None,shader_class:1,uv_mode:2,render_mode:4,vertex_colors:false,reflected:false,soft:false,mult_pass:false,screen_uv:false,alpha_slice:0.,fresnel_rgb:Vec3::ZERO}).unwrap()}
#[test]
fn missing_draw_owner_withdrawal_and_failed_canonical_clock_cannot_leave_admitted_mist(){
 let config=local_configuration().unwrap();let mut world=World::new();world.init_resource::<Assets<Mesh>>();world.init_resource::<Assets<MistMaterial>>();world.init_resource::<ReadyAnswers>();
 let owner=binding(&mut world,&config);for slot in 0..2{world.entity_mut(owner.roots[slot]).insert(SourceRoot{session:owner.session,slot,map_root:owner.map_root,model:owner.model,position:owner.positions[slot]});}
 let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,vec![[0.,0.,0.],[1.,0.,0.],[0.,0.,1.]]);
 let bounds=mesh.compute_aabb().unwrap();let mut backend=Backend::default();backend.binding=Some(owner);
 backend.publish(&mut world,Some(owner),vec![Prepared{source:0,slot:0,birth:0,counter:0,mesh,bounds,material:material(),images:std::array::from_fn(|_|Handle::<Image>::default().id())}]).unwrap();
 let ticket=backend.tickets().pop().unwrap();world.despawn(ticket.draw);world.resource_mut::<Assets<Mesh>>().remove(ticket.mesh);
 assert!(backend.validate_retained(&world).is_err());
 // Retirement is safe even when the prior private entity/asset disappeared.
 backend.publish(&mut world,None,vec![]).unwrap();assert!(backend.tickets().is_empty());assert!(backend.binding.is_none());assert!(world.resource::<Assets<MistMaterial>>().is_empty());
 // A replaced marker is not our source-root lease and must survive retirement.
 let mut foreign=*world.get::<SourceRoot>(owner.roots[0]).unwrap();foreign.position[0]=0;world.entity_mut(owner.roots[0]).insert(foreign);
 retire_roots(&mut world,Some(owner));assert_eq!(world.get::<SourceRoot>(owner.roots[0]),Some(&foreign));assert!(world.get_entity(owner.roots[1]).is_err());
 // Actual clock plugin fails without its canonical owner. A stopped clock is
 // rejected before native sampling; withdrawal remains possible without it.
 let mut app=App::new();app.add_plugins(crate::native_effect_clock::Plugin);app.update();
 let clock=app.world().resource::<crate::native_effect_clock::EffectClock>();assert_eq!(clock.diagnostic()["failed"],true);
 let mut state=State::new(Rng55::seeded(17));let initial=state.planned(Some(owner),0.,&config.sources).unwrap();state.commit(initial,Some(owner)).unwrap();let before=state_words(&state);
 assert!(planned_with_clock(&state,Some(owner),&config,Some(clock)).is_err());assert_eq!(state_words(&state),before);
 let plan=planned_with_clock(&state,None,&config,None).unwrap();let rng=fingerprint(&state.rng);state.commit(plan,None).unwrap();assert!(state.active.is_none());assert_eq!(fingerprint(&state.rng),rng);
 println!("Controlled private lease fixture: missing draw cleanup, foreign root preservation, real stopped-clock rejection and clock-independent two-source retirement passed. No GPU-ready fixture or native pixels.");
}
