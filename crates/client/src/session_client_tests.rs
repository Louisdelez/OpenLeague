use super::*;
fn nonce(v:u8)->t::RequestNonce {t::RequestNonce([v;16])}
fn key(v:u8)->t::Secret32 {t::Secret32::from_bytes([v;32]).unwrap()}
fn request()->t::JoinRequest {t::JoinRequest{version:t::VERSION,champion:"garen".into(),summoners:[None,None],recovery_key:key(1),request_nonce:nonce(2)}}
fn welcome(player:u32)->t::Welcome {t::Welcome{version:t::VERSION,context:t::Context{session:77,player,epoch:1},
    request_nonce:nonce(2),access_key:key(3),next_sequence:1,bootstrap:t::ClockBootstrap::Running}}
fn snapshot()->openleague_core::Snapshot {
    let navigation=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut game=openleague_core::Simulation::new(navigation).unwrap();game.session=77;game.join("garen").unwrap();game.snapshot()
}
fn input_sequence(message:t::ClientMessage)->u64 {match message{t::ClientMessage::Session(input)=>input.sequence,_=>panic!("input")}}

#[test] fn context_recovery_handles_lost_commit_without_creating_another_participant() {
    let mut c=Client::new(request(),true,nonce(7)).unwrap();
    let info=t::ContextResponse{request_nonce:nonce(7),context:t::Context{session:77,player:21,epoch:2},availability:t::Availability::Busy};
    assert_eq!(c.context_response(&info,nonce(8)).unwrap(),ContextOutcome::Waiting);assert!(c.context().is_none());
    assert!(matches!(c.pending_request(),Some(t::ClientMessage::ContextQuery(_))));
    let info=t::ContextResponse{availability:t::Availability::Detached,..info};
    assert_eq!(c.context_response(&info,nonce(8)).unwrap(),ContextOutcome::ResumePrepared);
    assert!(matches!(c.pending_request(),Some(t::ClientMessage::Resume(r)) if r.expected==info.context));
    let w=t::Welcome{context:t::Context{epoch:3,..info.context},request_nonce:nonce(8),next_sequence:17,..welcome(21)};
    assert_eq!(c.welcome(w).unwrap(),WelcomeOutcome::ResetClock(t::Context{epoch:3,..info.context}));
    assert_eq!(input_sequence(c.input(t::Input::Heartbeat).unwrap()),17);assert!(!c.ready());
}
#[test] fn missing_recovery_lease_is_explicit_and_never_falls_back_to_join() {
    let mut c=Client::new(request(),true,nonce(7)).unwrap();
    c.rejection(&t::Rejection{request_nonce:Some(nonce(7)),context:None,reason:t::RejectionCode::UnknownLease},nonce(8)).unwrap();
    assert!(c.failure().is_some());assert!(c.pending_request().is_none());assert!(!c.ready());
}
#[test] fn stale_nonces_and_foreign_contexts_cannot_replace_pending_handshake() {
    let mut c=Client::new(request(),true,nonce(7)).unwrap();
    let wrong=t::ContextResponse{request_nonce:nonce(6),context:t::Context{session:77,player:21,epoch:2},availability:t::Availability::Detached};
    assert!(c.context_response(&wrong,nonce(8)).is_err());assert!(c.known_context().is_none());
    let info=t::ContextResponse{request_nonce:nonce(7),availability:t::Availability::Busy,..wrong};
    c.context_response(&info,nonce(8)).unwrap();
    let foreign=t::ContextResponse{context:t::Context{player:22,..info.context},..info.clone()};
    assert!(c.context_response(&foreign,nonce(8)).is_err());assert_eq!(c.known_context(),Some(info.context));
    assert!(c.welcome(welcome(21)).is_err());assert!(c.context().is_none());
}
#[test] fn duplicate_welcome_does_not_reset_sequence_or_applied_clock() {
    let mut c=Client::new(request(),false,nonce(7)).unwrap();let w=welcome(21);
    c.welcome(w.clone()).unwrap();assert_eq!(input_sequence(c.input(t::Input::Heartbeat).unwrap()),1);
    c.clock_applied(w.context,1).unwrap();assert_eq!(c.welcome(w.clone()).unwrap(),WelcomeOutcome::Duplicate);
    assert_eq!(input_sequence(c.input(t::Input::Heartbeat).unwrap()),3);
    assert!(c.welcome(t::Welcome{access_key:key(4),..w}).is_err());
}
#[test] fn completed_frame_duplicates_are_ignored_without_reopening_or_representing_state(){
 let state=snapshot();let w=welcome(state.players[0].id);let mut client=Client::new(request(),false,nonce(7)).unwrap();
 client.welcome(w.clone()).unwrap();let mut sender=session_wire::Sender::new(w.context).unwrap();let packets=sender.encode(&state,0).unwrap();
 for p in &packets{client.frame(p).unwrap();}let states=client.take_ready_states();assert_eq!(states.len(),1);
 client.presented(w.context,states[0].frame_ordinal).unwrap();assert!(client.ready());assert_eq!(client.received_frame_ordinal(),1);
 for p in packets.iter().rev(){client.frame(p).unwrap();}assert!(client.take_ready_states().is_empty());assert!(client.ready());assert_eq!(client.received_frame_ordinal(),1);
}
#[test] fn paused_state_is_withheld_until_clock_applied_and_real_state_commit_acknowledged() {
    let state=snapshot();let player=state.players[0].id;let mut c=Client::new(request(),false,nonce(7)).unwrap();
    let w=t::Welcome{bootstrap:t::ClockBootstrap::Paused{through_ordinal:1},..welcome(player)};
    c.welcome(w.clone()).unwrap();let mut sender=session_wire::Sender::new(w.context).unwrap();
    for packet in sender.encode(&state,1).unwrap(){c.frame(&packet).unwrap();}
    assert!(c.take_ready_states().is_empty());assert!(!c.ready());assert!(c.input(t::Input::Command(openleague_core::Action::Stop)).is_err());
    // Controlled applied-ordinal input: this test does NOT execute EffectClock.
    c.clock_applied(w.context,1).unwrap();let states=c.take_ready_states();assert_eq!(states.len(),1);assert!(!c.ready());
    c.presented(w.context,states[0].frame_ordinal).unwrap();assert!(c.ready());
    let mut changed=state.clone();changed.roster.clear();
    for packet in sender.encode(&changed,1).unwrap(){c.frame(&packet).unwrap();}
    let states=c.take_ready_states();assert_eq!(states[0].snapshot.tick,state.tick);assert_eq!(states[0].frame_ordinal,2);
    assert!(!c.ready());c.presented(w.context,2).unwrap();assert!(c.ready());
    // This exercises transport order only; the real journals must separately
    // validate a same-tick roster change before calling presented().
}
#[test] fn cumulative_ack_retransmission_uses_fresh_sequence_after_heartbeat() {
    let mut c=Client::new(request(),false,nonce(7)).unwrap();let w=welcome(21);c.welcome(w.clone()).unwrap();
    let a=c.clock_applied(w.context,1).unwrap().unwrap();assert_eq!(input_sequence(a),1);
    assert_eq!(input_sequence(c.input(t::Input::Heartbeat).unwrap()),2);
    let retry=c.clock_applied(w.context,1).unwrap().unwrap();assert_eq!(input_sequence(retry),3);
}
#[test] fn waiting_states_are_bounded_and_old_epoch_fragments_cannot_fill_them() {
    let state=snapshot();let mut c=Client::new(request(),false,nonce(7)).unwrap();let w=t::Welcome{
        bootstrap:t::ClockBootstrap::Paused{through_ordinal:1},..welcome(state.players[0].id)};c.welcome(w.clone()).unwrap();
    let mut sender=session_wire::Sender::new(w.context).unwrap();
    for _ in 0..MAX_WAITING_STATES {for packet in sender.encode(&state,1).unwrap(){c.frame(&packet).unwrap();}}
    let mut foreign=session_wire::Sender::new(t::Context{epoch:2,..w.context}).unwrap();
    for packet in foreign.encode(&state,1).unwrap(){assert!(c.frame(&packet).is_err());}
    let mut rejected=false;for packet in sender.encode(&state,1).unwrap(){rejected|=c.frame(&packet).is_err();}
    assert!(rejected);assert_eq!(c.waiting.len(),MAX_WAITING_STATES);assert!(c.failure().is_some());
    assert!(c.input(t::Input::Heartbeat).is_err());assert!(c.take_ready_states().is_empty());
}
#[test] fn sequence_exhaustion_and_unapplied_clock_keep_inputs_closed() {
    let mut c=Client::new(request(),false,nonce(7)).unwrap();let w=welcome(21);c.welcome(w.clone()).unwrap();
    c.sequence=u64::MAX;assert!(c.input(t::Input::Heartbeat).is_err());assert_eq!(c.sequence,u64::MAX);
    assert!(c.validate_clock(&t::ClockEnvelope{context:t::Context{epoch:2,..w.context},ordinal:1,opcode:0xa1,payload:vec![]}).is_err());
    assert!(!c.ready());
}

#[test]
fn exact_delivered_observation_batch_keeps_inputs_closed_and_rejects_holes_replays_and_empty_poll() {
    let state=snapshot();let w=welcome(state.players[0].id);let mut client=Client::new(request(),false,nonce(7)).unwrap();
    client.welcome(w.clone()).unwrap();let mut sender=session_wire::Sender::new(w.context).unwrap();
    for packet in sender.encode(&state,0).unwrap(){client.frame(&packet).unwrap();}
    let _undelivered=sender.encode(&state,0).unwrap(); // ordinal2 never reaches the receiver
    for packet in sender.encode(&state,0).unwrap(){client.frame(&packet).unwrap();}
    assert!(!client.observation_ready(w.context,1));
    let batch=client.take_ready_states();assert_eq!(batch.iter().map(|f|f.frame_ordinal).collect::<Vec<_>>(),vec![1,3]);
    assert!(!client.ready());assert!(client.input(t::Input::Command(openleague_core::Action::Stop)).is_err());
    for id in [1,3]{assert!(client.observation_ready(w.context,id));}
    for id in [0,2,4,u64::MAX]{assert!(!client.observation_ready(w.context,id));}
    for context in [t::Context{epoch:2,..w.context},t::Context{player:w.context.player+1,..w.context},t::Context{session:u64::MAX,..w.context}]{
        assert!(!client.observation_ready(context,1));
    }
    client.presented(w.context,1).unwrap();assert!(!client.observation_ready(w.context,1));
    assert!(client.observation_ready(w.context,3));assert!(!client.ready());
    client.presented(w.context,3).unwrap();assert!(client.ready());assert!(!client.observation_ready(w.context,3));
    for packet in sender.encode(&state,0).unwrap(){client.frame(&packet).unwrap();}
    assert_eq!(client.take_ready_states().len(),1);assert!(client.observation_ready(w.context,4));
    assert!(client.take_ready_states().is_empty());assert!(!client.observation_ready(w.context,4));assert!(!client.ready());
    for packet in sender.encode(&state,0).unwrap(){client.frame(&packet).unwrap();}
    assert_eq!(client.take_ready_states().len(),1);assert!(client.observation_ready(w.context,5));assert!(!client.observation_ready(w.context,4));
}
#[test]
fn observation_admission_waits_for_applied_clock_and_is_revoked_by_recovery_or_failure() {
    let state=snapshot();let mut client=Client::new(request(),false,nonce(7)).unwrap();
    let w=t::Welcome{bootstrap:t::ClockBootstrap::Paused{through_ordinal:1},..welcome(state.players[0].id)};
    client.welcome(w.clone()).unwrap();let mut sender=session_wire::Sender::new(w.context).unwrap();
    for packet in sender.encode(&state,1).unwrap(){client.frame(&packet).unwrap();}
    assert!(client.take_ready_states().is_empty());assert!(!client.observation_ready(w.context,1));
    client.clock_applied(w.context,1).unwrap();assert_eq!(client.take_ready_states().len(),1);
    assert!(client.observation_ready(w.context,1));assert!(!client.ready());
    client.failed=Some("controlled transport failure");assert!(!client.observation_ready(w.context,1));
    assert!(client.take_ready_states().is_empty());assert!(client.observation_batch.is_empty());
    client.failed=None;assert!(!client.observation_ready(w.context,1));
    for packet in sender.encode(&state,1).unwrap(){client.frame(&packet).unwrap();}
    assert_eq!(client.take_ready_states().len(),1);assert!(client.observation_ready(w.context,2));
    client.recover(nonce(8)).unwrap();assert!(client.observation_batch.is_empty());assert!(!client.observation_ready(w.context,2));
}
