use super::*;
use openleague_core::{Navigation,Simulation,Snapshot};

fn snapshot(tick:u64)->Snapshot {
    let mut cells=Vec::new();
    for _ in 0..16 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#,&cells).unwrap();
    let mut game=Simulation::new(nav).unwrap();game.session=7;game.join("garen").unwrap();
    let mut snapshot=game.snapshot();snapshot.tick=tick;
    snapshot.players[0].effects.courage_until=160;
    snapshot.players[0].cooldown_totals[1]=Some(720);snapshot.players[0].cooldowns[1]=730;
    snapshot
}
fn state()->Match {
    let mut state=Match::default();state.attack_visuals.reset(7);state.vilemaw_visuals.reset(7);state.w_visuals.reset(7);state.missile_journal.reset(7);state
}
fn missile()->openleague_core::annie::Missile {
    openleague_core::annie::Missile {source:1,target:2,position:openleague_core::Point{x:25.,z:25.},
        raw:80.,cost:60.,refund_ticks:60,cooldown_ready:100}
}
fn desired(root:Entity,started:u64)->Desired {
    Desired {root,identity:w::Identity {session:7,source:1,started,end:started+150}}
}

#[test]
fn w_invalid_state_rejects_before_missile_commit_and_valid_same_tick_can_follow() {
    let mut state=state();let mut bad=snapshot(11);bad.players[0].cooldown_totals[1]=None;
    bad.spell_projectiles.push(missile());
    let attacks=state.attack_visuals.clone();let courage=state.w_visuals.clone();
    assert!(accept_presentations(&mut state,&bad,1.).is_err());
    assert_eq!(state.attack_visuals,attacks);assert_eq!(state.w_visuals,courage);
    assert!(state.missile_journal.drain().is_empty());
    bad.players[0].cooldown_totals[1]=Some(720);
    assert!(accept_presentations(&mut state,&bad,1.).unwrap());
    assert_eq!(state.missile_journal.drain().len(),1);
    assert!(state.w_visuals.0.sustained(1,1.).is_some());
}

#[test]
fn w_missile_failure_does_not_commit_either_visual_consumer() {
    let mut state=state();let mut bad=snapshot(11);bad.spell_projectiles=vec![missile(),missile()];
    let attacks=state.attack_visuals.clone();let courage=state.w_visuals.clone();
    assert!(accept_presentations(&mut state,&bad,1.).is_err());
    assert_eq!(state.attack_visuals,attacks);assert_eq!(state.w_visuals,courage);
    assert!(state.missile_journal.drain().is_empty());
    bad.spell_projectiles.pop();assert!(accept_presentations(&mut state,&bad,1.).unwrap());
    assert_eq!(state.missile_journal.drain().len(),1);
}

#[test]
fn w_each_intermediate_hidden_packet_and_session_reset_retires_context() {
    let mut state=state();accept_presentations(&mut state,&snapshot(11),1.).unwrap();
    let mut hidden=snapshot(12);hidden.players.clear();
    accept_presentations(&mut state,&hidden,1.1).unwrap();
    assert!(state.w_visuals.0.sustained(1,1.1).is_none());
    accept_presentations(&mut state,&snapshot(13),1.2).unwrap();
    assert!(state.w_visuals.0.sustained(1,1.2).unwrap().age_seconds>0.2);
    state.attack_visuals.reset(8);state.vilemaw_visuals.reset(8);state.w_visuals.reset(8);state.missile_journal.reset(8);
    assert!(state.w_visuals.0.sustained(1,1.2).is_none());
    assert!(accept_presentations(&mut state,&snapshot(14),1.3).is_err());
}

#[test]
fn w_owner_is_stable_per_identity_and_changes_after_cast_root_or_session() {
    let mut world=World::new();let root=world.spawn_empty().id();let next_root=world.spawn_empty().id();
    let mut bindings=Bindings::default();let mut requests=host::Requests::default();
    bindings.reconcile(Some(7),&[desired(root,10)],&mut requests).unwrap();
    let first=bindings.active[&1];
    for _ in 0..8 {bindings.reconcile(Some(7),&[desired(root,10)],&mut requests).unwrap();assert_eq!(bindings.active[&1],first);}
    bindings.reconcile(Some(7),&[desired(root,730)],&mut requests).unwrap();
    assert!(bindings.active[&1].owner>first.owner);
    let second=bindings.active[&1];
    bindings.reconcile(Some(7),&[desired(next_root,730)],&mut requests).unwrap();
    assert!(bindings.active[&1].owner>second.owner);assert_eq!(bindings.active[&1].root,next_root);
    bindings.reconcile(Some(7),&[],&mut requests).unwrap();assert!(bindings.active.is_empty());
    bindings.reconcile(None,&[],&mut requests).unwrap();assert_eq!(requests.session(),None);
    let mut next=desired(root,10);next.identity.session=8;
    bindings.reconcile(Some(8),&[next],&mut requests).unwrap();
    assert_eq!(requests.session(),Some(8));assert_eq!(bindings.active[&1].identity.session,8);
}

#[test]
fn w_bad_owner_request_and_exhaustion_clear_only_w_requests_until_reset() {
    let mut world=World::new();let root=world.spawn_empty().id();
    let mut bindings=Bindings::default();let mut requests=host::Requests::default();
    bindings.reconcile(Some(7),&[desired(root,10)],&mut requests).unwrap();
    assert!(bindings.reconcile(Some(7),&[desired(root,10),desired(root,10)],&mut requests).is_err());
    assert!(bindings.active.is_empty());assert_eq!(requests.session(),None);
    assert!(bindings.reconcile(Some(7),&[desired(root,10)],&mut requests).is_err());
    bindings.reconcile(None,&[],&mut requests).unwrap();bindings.reconcile(Some(7),&[],&mut requests).unwrap();
    bindings.next_owner=u32::MAX as u64+1;
    assert!(bindings.reconcile(Some(7),&[desired(root,10)],&mut requests).is_err());
    assert!(bindings.active.is_empty());assert!(bindings.failure.as_deref().unwrap().contains("exhausted"));
}

#[derive(Resource,Default)] struct DeferredObserved(bool);
fn pending_root(mut commands:Commands,mut state:ResMut<Match>) {
    let root=commands.spawn(crate::actor_fow::Root).id();state.visuals.insert(1,root);
}
fn see_deferred(state:Res<Match>,roots:Query<(),With<crate::actor_fow::Root>>,bindings:Res<Bindings>,mut seen:ResMut<DeferredObserved>) {
    seen.0=roots.contains(state.visuals[&1]) && bindings.active[&1].root==state.visuals[&1];
}
#[test]
fn w_requests_follow_real_deferred_root_and_hide_when_snapshot_is_absent() {
    let mut state=state();let snap=snapshot(11);accept_presentations(&mut state,&snap,1.).unwrap();state.snapshot=Some(snap);
    let mut app=App::new();app.insert_resource(state).init_resource::<Bindings>().init_resource::<host::Requests>()
        .init_resource::<crate::native_effect_clock::EffectClock>().init_resource::<DeferredObserved>()
        .add_systems(Update,(pending_root,bevy::ecs::schedule::ApplyDeferred,update_requests,see_deferred).chain());
    app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=1.;
    app.update();assert!(app.world().resource::<DeferredObserved>().0);
    // Run only the real requests system after removing the current snapshot.
    app.world_mut().resource_mut::<Match>().snapshot=None;
    use bevy::ecs::system::RunSystemOnce;
    app.world_mut().run_system_once(update_requests).unwrap();
    assert!(app.world().resource::<Bindings>().active.is_empty());
    assert_eq!(app.world().resource::<host::Requests>().session(),None);
}

#[test]
fn w_setup_requests_the_verified_base_assets_without_claiming_gpu_load() {
    let mut app=App::new();app.add_plugins((bevy::app::TaskPoolPlugin::default(),AssetPlugin::default()))
        .init_asset::<Gltf>().init_asset::<Image>().add_systems(Startup,host::setup);
    app.world_mut().run_schedule(Startup);
    let profile=app.world().resource::<host::Profile>();let server=app.world().resource::<AssetServer>();
    assert_eq!(server.get_path(profile.model.id()).unwrap().path().to_str(),Some(host::BASE_MODEL));
    assert_eq!(server.get_path(profile.texture.id()).unwrap().path().to_str(),Some(crate::garen_w_profile::BASE_OVERRIDE.texture_asset));
    assert_eq!(host::BASE_TEXTURE,crate::garen_w_profile::BASE_OVERRIDE.texture_asset);
}



// Real local framing/serde path, controlled Simulation snapshots, no sockets/GPU.
fn wire_snapshot(sender:&mut openleague_core::session_wire::Sender,
    assembler:&mut openleague_core::session_wire::Assembler,snapshot:&Snapshot)
    ->openleague_core::session_transport::StateEnvelope {
    let mut completed=None;
    for packet in sender.encode(snapshot,1).unwrap().into_iter().rev() {
        if let Some(value)=assembler.push(&packet).unwrap(){assert!(completed.is_none());completed=Some(value);}
    }
    completed.unwrap().decode().unwrap()
}

#[test]
fn actual_framed_snapshots_at_one_tick_retire_all_three_presentations_transactionally() {
    use openleague_core::{attack_presentation as attack,attacks::Windup,session_transport::Context,session_wire};
    let context=Context{session:7,player:1,epoch:1};
    let mut sender=session_wire::Sender::new(context).unwrap();let mut receiver=session_wire::Assembler::new(context).unwrap();
    let mut state=state();begin_presentation_epoch(&mut state,7,1).unwrap();
    let mut facts=attack::State::default();let audience=attack::Audience::from_visibility(true,true);
    let q=facts.begin(1,10,20,attack::Kind::GarenQ,audience).unwrap();
    let mut active=snapshot(11);active.attack_events=facts.events();active.spell_projectiles.push(missile());
    active.players[0].windup=Some(Windup{target:2,started:10,release:20,cancelable:true,critical:false,presentation:Some(q)});
    let one=wire_snapshot(&mut sender,&mut receiver,&active);
    assert_eq!(one.frame_ordinal,1);assert_eq!(one.snapshot.tick,11);
    assert!(accept_presentations_frame(&mut state,&one.snapshot,one.frame_ordinal,5.).unwrap());
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Appeared);
    let selected=state.attack_visuals.selection(1,5.,Some(1.)).unwrap();let courage=state.w_visuals.0.sustained(1,5.).unwrap();
    let two=wire_snapshot(&mut sender,&mut receiver,&active);
    assert_eq!(two.frame_ordinal,2);assert_eq!(two.snapshot.tick,one.snapshot.tick);
    accept_presentations_frame(&mut state,&two.snapshot,two.frame_ordinal,5.).unwrap();
    assert_eq!(state.attack_visuals.selection(1,5.,Some(1.)).unwrap(),selected);
    assert_eq!(state.w_visuals.0.sustained(1,5.).unwrap(),courage);
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Observed);
    facts.cancel(q,11,attack::CancelReason::Order,audience).unwrap();
    let mut stopped=active.clone();stopped.attack_events=facts.events();stopped.spell_projectiles.clear();
    stopped.players[0].windup=None;stopped.players[0].effects.courage_until=0;
    let three=wire_snapshot(&mut sender,&mut receiver,&stopped);
    assert_eq!(three.frame_ordinal,3);assert_eq!(three.snapshot.tick,11);
    accept_presentations_frame(&mut state,&three.snapshot,three.frame_ordinal,5.).unwrap();
    assert!(state.attack_visuals.selection(1,5.,Some(1.)).is_none());assert!(state.w_visuals.0.sustained(1,5.).is_none());
    let removed=state.missile_journal.drain();assert_eq!(removed.len(),1);
    assert_eq!(removed[0].kind,openleague_core::missile_lifecycle::Kind::Disappeared);assert_eq!(removed[0].tick,11);
    assert!(!accept_presentations_frame(&mut state,&one.snapshot,one.frame_ordinal,5.).unwrap());
    assert!(state.missile_journal.drain().is_empty());assert!(state.attack_visuals.selection(1,5.,Some(1.)).is_none());
}

#[test]
fn resumed_epoch_at_same_tick_keeps_courage_and_missile_identity_and_frame_barrier() {
    let mut state=state();begin_presentation_epoch(&mut state,7,1).unwrap();let mut active=snapshot(11);
    active.spell_projectiles.push(missile());accept_presentations_frame(&mut state,&active,19,5.).unwrap();
    state.missile_journal.drain();let before=state.w_visuals.0.sustained(1,5.25).unwrap();
    assert!(begin_presentation_epoch(&mut state,7,2).unwrap());
    assert!(accept_presentations_frame(&mut state,&active,1,5.25).unwrap());
    assert_eq!(state.w_visuals.0.sustained(1,5.25).unwrap(),before);
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Observed);
    assert!(!begin_presentation_epoch(&mut state,7,2).unwrap());
    let mut departed=active.clone();departed.players.clear();departed.roster.clear();departed.spell_projectiles.clear();
    assert!(!accept_presentations_frame(&mut state,&departed,1,5.25).unwrap());
    assert_eq!(state.w_visuals.0.sustained(1,5.25).unwrap(),before);
    assert!(accept_presentations_frame(&mut state,&departed,2,5.25).unwrap());
    assert!(state.w_visuals.0.sustained(1,5.25).is_none());assert_eq!(state.missile_journal.drain().len(),1);
}

#[test]
fn framed_invalid_batch_and_epoch_leave_every_presentation_at_previous_commit() {
    let mut state=state();begin_presentation_epoch(&mut state,7,1).unwrap();let mut active=snapshot(11);
    active.spell_projectiles.push(missile());accept_presentations_frame(&mut state,&active,1,5.).unwrap();state.missile_journal.drain();
    let attacks=state.attack_visuals.clone();let courage=state.w_visuals.clone();
    assert!(begin_presentation_epoch(&mut state,8,2).is_err());assert!(begin_presentation_epoch(&mut state,7,0).is_err());
    for failure in 0..2 {
        let mut bad=active.clone();
        if failure==0 {bad.players[0].cooldown_totals[1]=None;} else {bad.spell_projectiles.push(missile());}
        assert!(accept_presentations_frame(&mut state,&bad,2,5.).is_err());
        assert_eq!(state.attack_visuals,attacks);assert_eq!(state.w_visuals,courage);assert!(state.missile_journal.drain().is_empty());
    }
    assert!(accept_presentations_frame(&mut state,&active,2,5.).unwrap());
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Observed);
    let mut backwards=active.clone();backwards.tick=10;
    assert!(!accept_presentations_frame(&mut state,&backwards,3,5.).unwrap());
    assert!(state.missile_journal.drain().is_empty());
}

#[test]
fn vilemaw_failure_is_transactional_with_garen_courage_and_missiles() {
    use crate::vilemaw_attack_animation::tests::{snapshot as boss_snapshot,facts,all,SOURCE};
    use openleague_core::attack_presentation::{Kind,Phase};
    let mut state=state();begin_presentation_epoch(&mut state,7,1).unwrap();
    let mut facts=facts();accept_presentations_frame(&mut state,&boss_snapshot(0,&facts,None),1,0.).unwrap();
    let attack=facts.begin(SOURCE,10,40,Kind::Basic,all()).unwrap();
    let mut active=boss_snapshot(11,&facts,Some(attack));active.spell_projectiles.push(missile());
    let attacks=state.attack_visuals.clone();let courage=state.w_visuals.clone();let boss=state.vilemaw_visuals.clone();
    let mut bad=active.clone();bad.vilemaw_attack_events[0].phase=Phase::Started{kind:Kind::Critical};
    assert!(accept_presentations_frame(&mut state,&bad,2,0.).is_err());
    assert_eq!(state.attack_visuals,attacks);assert_eq!(state.w_visuals,courage);assert_eq!(state.vilemaw_visuals,boss);
    assert!(state.missile_journal.drain().is_empty());
    bad=active.clone();bad.spell_projectiles.push(missile());
    assert!(accept_presentations_frame(&mut state,&bad,2,0.).is_err());
    assert_eq!(state.vilemaw_visuals,boss);assert!(state.missile_journal.drain().is_empty());
    assert!(accept_presentations_frame(&mut state,&active,2,0.).unwrap());
    assert!(state.vilemaw_visuals.selection(SOURCE,0.,Some(2.)).is_some());
    assert_eq!(state.missile_journal.drain().len(),1);
}

#[test]
fn framed_vilemaw_same_tick_resolution_and_recovery_preserve_age_and_all_journals() {
    use crate::vilemaw_attack_animation::tests::{snapshot as boss_snapshot,facts,all,SOURCE};
    use openleague_core::{attack_presentation::Kind,session_transport::Context,session_wire};
    let mut state=state();begin_presentation_epoch(&mut state,7,1).unwrap();let mut facts=facts();
    let context=Context{session:7,player:1,epoch:1};
    let mut sender=session_wire::Sender::new(context).unwrap();let mut receiver=session_wire::Assembler::new(context).unwrap();
    let initial=wire_snapshot(&mut sender,&mut receiver,&boss_snapshot(0,&facts,None));
    accept_presentations_frame(&mut state,&initial.snapshot,initial.frame_ordinal,0.).unwrap();
    let attack=facts.begin(SOURCE,10,40,Kind::Basic,all()).unwrap();
    let mut snapshot=boss_snapshot(40,&facts,Some(attack));snapshot.spell_projectiles.push(missile());
    let active=wire_snapshot(&mut sender,&mut receiver,&snapshot);
    accept_presentations_frame(&mut state,&active.snapshot,active.frame_ordinal,1.).unwrap();
    let before=state.vilemaw_visuals.selection(SOURCE,1.,Some(2.)).unwrap();
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Appeared);
    facts.resolve(attack,40,Kind::Basic,true,all()).unwrap();
    let mut snapshot=boss_snapshot(40,&facts,None);snapshot.spell_projectiles.push(missile());
    let resolved=wire_snapshot(&mut sender,&mut receiver,&snapshot);
    accept_presentations_frame(&mut state,&resolved.snapshot,resolved.frame_ordinal,1.).unwrap();
    assert_eq!(state.vilemaw_visuals.selection(SOURCE,1.,Some(2.)).unwrap(),before);
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Observed);
    assert!(!accept_presentations_frame(&mut state,&active.snapshot,active.frame_ordinal,1.).unwrap());
    assert!(begin_presentation_epoch(&mut state,7,2).unwrap());
    let resumed=Context{epoch:2,..context};let mut sender=session_wire::Sender::new(resumed).unwrap();
    let mut receiver=session_wire::Assembler::new(resumed).unwrap();let frame=wire_snapshot(&mut sender,&mut receiver,&snapshot);
    accept_presentations_frame(&mut state,&frame.snapshot,frame.frame_ordinal,1.).unwrap();
    assert_eq!(state.vilemaw_visuals.selection(SOURCE,1.,Some(2.)).unwrap(),before);
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Observed);
    assert!(!begin_presentation_epoch(&mut state,7,1).unwrap());
    assert!(!accept_presentations_frame(&mut state,&active.snapshot,frame.frame_ordinal,1.).unwrap());
}

#[test]
fn vilemaw_diagnostic_commits_gameplay_and_other_visuals_but_disables_boss_output() {
    use crate::vilemaw_attack_animation::tests::{snapshot as boss_snapshot,facts,all,SOURCE};
    use openleague_core::attack_presentation::Kind;
    let mut state=state();let mut facts=facts();let attack=facts.begin(SOURCE,10,40,Kind::Basic,all()).unwrap();
    let mut snapshot=boss_snapshot(11,&facts,Some(attack));snapshot.vilemaw_attack_presentation_error=Some("controlled diagnostic".into());
    snapshot.spell_projectiles.push(missile());
    assert!(accept_presentations(&mut state,&snapshot,0.).unwrap());
    assert!(state.vilemaw_visuals.error().is_some());assert!(state.vilemaw_visuals.selection(SOURCE,0.,Some(2.)).is_none());
    assert_eq!(state.missile_journal.drain()[0].kind,openleague_core::missile_lifecycle::Kind::Appeared);
}
