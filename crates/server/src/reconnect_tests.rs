use super::*;
use std::collections::VecDeque;

// Explicit deterministic injection, not a production RNG or real OS test.
struct Keys { values:VecDeque<Result<Secret32,EntropyUnavailable>>, calls:usize }
impl Keys {fn new(values:&[u8])->Self {Self{values:values.iter().map(|v|Ok(key(*v))).collect(),calls:0}}}
impl Entropy for Keys {
    fn access_key(&mut self)->Result<Secret32,EntropyUnavailable> {
        self.calls+=1;self.values.pop_front().unwrap_or(Err(EntropyUnavailable))
    }
}
fn key(v:u8)->Secret32 {Secret32::from_bytes([v;32]).unwrap()}
fn nonce(v:u8)->RequestNonce {RequestNonce([v;16])}
fn peer(v:u16)->SocketAddr {SocketAddr::from(([127,0,0,1],10000+v))}
fn t(v:u64)->Duration {Duration::from_secs(v)}
fn request(v:u8)->JoinRequest {JoinRequest{version:wire::VERSION,champion:"garen".into(),summoners:[None,None],
    recovery_key:key(v),request_nonce:nonce(v)}}
fn registry()->Registry {Registry::new(77,Limits::default()).unwrap()}
fn join(r:&mut Registry,p:u16,id:u32,req:&JoinRequest,keys:&mut Keys)->Welcome {
    match r.prepare_join(peer(p),req,t(0),keys).unwrap() {
        JoinPreparation::New(p)=>p.commit(id,ClockBootstrap::Running).unwrap(),
        _=>panic!("new registration required"),
    }
}
fn resume_request(w:&Welcome,k:u8,n:u8)->ResumeRequest {ResumeRequest{version:wire::VERSION,
    expected:w.context,recovery_key:key(k),request_nonce:nonce(n)}}
fn input(w:&Welcome,seq:u64,input:Input)->SessionInput {SessionInput{version:wire::VERSION,
    context:w.context,access_key:w.access_key.clone(),sequence:seq,input}}
fn resume(r:&mut Registry,p:u16,req:&ResumeRequest,now:u64,keys:&mut Keys)->Attached {
    match r.prepare_resume(peer(p),req,t(now),keys).unwrap() {
        ResumePreparation::New(p)=>p.commit(ClockBootstrap::Running).unwrap(),
        _=>panic!("new endpoint required"),
    }
}

#[test] fn join_retransmission_is_same_identity_without_entropy_or_activity_refresh() {
    let mut r=registry();let req=request(1);let mut keys=Keys::new(&[10]);let w=join(&mut r,1,21,&req,&mut keys);
    let before=r.view();
    let replay=match r.prepare_join(peer(1),&req,t(29),&mut keys).unwrap(){JoinPreparation::Replay(w)=>w,_=>panic!("replay")};
    assert_eq!(serde_json::to_value(&replay).unwrap(),serde_json::to_value(&w).unwrap());
    assert_eq!(r.view(),before);assert_eq!(keys.calls,1);
    assert!(r.poll(t(30)).unwrap().is_empty());
    assert_eq!(r.poll(t(31)).unwrap(),vec![Transition::Detached(Endpoint{peer:peer(1),context:w.context})]);
    assert_eq!(r.live_players(),1);
}

#[test] fn offline_reservation_has_no_expiry_and_resume_keeps_player_and_sequence() {
    let mut r=registry();let mut keys=Keys::new(&[10,11]);let w=join(&mut r,1,21,&request(1),&mut keys);
    r.prepare_input(peer(1),&input(&w,9,Input::Heartbeat),t(1)).unwrap().commit(None).unwrap();
    r.poll(t(32)).unwrap();let before=r.view();r.poll(t(1_000_000)).unwrap();
    assert_eq!(r.live_players(),1);assert_eq!(r.view().leases,before.leases);
    let attached=resume(&mut r,2,&resume_request(&w,1,5),1_000_001,&mut keys);
    assert_eq!(attached.welcome.context,Context{epoch:2,..w.context});
    assert_eq!(attached.welcome.next_sequence,10);assert!(attached.previous.is_none());
    assert_ne!(attached.welcome.access_key,w.access_key);assert!(r.forbids_legacy(peer(1))&&r.forbids_legacy(peer(2)));
    // The registry has no Simulation::join or replacement gameplay object.
    assert_eq!(r.view().leases.len(),1);assert_eq!(r.view().leases[0].context.player,21);
}

#[test] fn active_connection_is_busy_and_two_resume_attempts_cannot_both_win() {
    let mut r=registry();let mut keys=Keys::new(&[10,11,12]);let w=join(&mut r,1,21,&request(1),&mut keys);
    let req=resume_request(&w,1,5);let before=r.view();
    assert!(matches!(r.prepare_resume(peer(2),&req,t(30),&mut keys),Err(Error::Busy)));
    assert_eq!(r.view(),before);assert_eq!(keys.calls,1);
    let a=resume(&mut r,2,&req,31,&mut keys);assert_eq!(a.previous,Some(Endpoint{peer:peer(1),context:w.context}));
    let before=r.view();let competing=ResumeRequest{request_nonce:nonce(6),..req.clone()};
    assert!(matches!(r.prepare_resume(peer(3),&competing,t(31),&mut keys),Err(Error::StaleEpoch{..})));
    let current=ResumeRequest{expected:a.welcome.context,..competing};
    assert!(matches!(r.prepare_resume(peer(3),&current,t(31),&mut keys),Err(Error::Busy)));
    assert_eq!(r.view(),before);assert_eq!(keys.calls,2);
}

#[test] fn lost_welcome_replay_is_exact_but_does_not_extend_endpoint_or_hide_epoch_hole() {
    let mut r=registry();let mut keys=Keys::new(&[10,11]);let w=join(&mut r,1,21,&request(1),&mut keys);
    let req=resume_request(&w,1,5);let a=resume(&mut r,2,&req,31,&mut keys);let before=r.view();
    let replay=match r.prepare_resume(peer(2),&req,t(60),&mut keys).unwrap(){ResumePreparation::Replay(w)=>w,_=>panic!("replay")};
    assert_eq!(serde_json::to_value(&replay).unwrap(),serde_json::to_value(&a.welcome).unwrap());assert_eq!(r.view(),before);
    r.poll(t(62)).unwrap();let detached=r.view();
    // Explicit MVP boundary: original expected epoch cannot recover a handshake
    // after its accepted endpoint also died. Future launcher must resolve it.
    assert!(matches!(r.prepare_resume(peer(2),&req,t(63),&mut keys),Err(Error::ReplayExpired)));
    assert!(matches!(r.prepare_resume(peer(3),&req,t(63),&mut keys),Err(Error::StaleEpoch{current}) if current==a.welcome.context));
    assert_eq!(r.view(),detached);assert_eq!(r.live_players(),1);
}

#[test] fn retired_epoch_and_wrong_key_peer_or_session_cannot_act_or_leave() {
    let mut r=registry();let mut keys=Keys::new(&[10,11]);let w=join(&mut r,1,21,&request(1),&mut keys);
    let a=resume(&mut r,2,&resume_request(&w,1,5),31,&mut keys);let before=r.view();
    for body in [Input::Heartbeat,Input::Leave,Input::PauseRequest{paused:true},Input::ClockAck{ordinal:1},Input::Command(openleague_core::Action::Stop)] {
        assert!(matches!(r.prepare_input(peer(1),&input(&w,100,body),t(40)),Err(Error::Unauthorized)));
    }
    let mut wrong=input(&a.welcome,1,Input::Heartbeat);wrong.access_key=key(99);
    assert!(matches!(r.prepare_input(peer(2),&wrong,t(40)),Err(Error::Unauthorized)));
    wrong=input(&a.welcome,1,Input::Heartbeat);wrong.context.session+=1;
    assert!(matches!(r.prepare_input(peer(2),&wrong,t(40)),Err(Error::Unauthorized)));
    assert!(matches!(r.prepare_input(peer(3),&input(&a.welcome,1,Input::Heartbeat),t(40)),Err(Error::Unauthorized)));
    assert_eq!(r.view(),before);
}

#[test] fn stale_heartbeat_and_duplicate_or_invalid_ack_never_extend_busy() {
    let mut r=registry();let mut keys=Keys::new(&[10]);let w=join(&mut r,1,21,&request(1),&mut keys);
    r.prepare_input(peer(1),&input(&w,1,Input::Heartbeat),t(1)).unwrap().commit(None).unwrap();
    let ack=input(&w,2,Input::ClockAck{ordinal:1});
    let proof=PreparedAck::check(w.context,1,1).unwrap();r.prepare_input(peer(1),&ack,t(2)).unwrap().commit(Some(proof)).unwrap();
    let before=r.view();
    assert!(matches!(r.prepare_input(peer(1),&input(&w,1,Input::Heartbeat),t(30)),Err(Error::StaleSequence)));
    assert!(matches!(r.prepare_input(peer(1),&input(&w,3,Input::ClockAck{ordinal:1}),t(30)),Err(Error::StaleAck)));
    assert!(PreparedAck::check(w.context,2,1).is_err());
    assert!(matches!(r.prepare_input(peer(1),&input(&w,3,Input::ClockAck{ordinal:2}),t(30)).unwrap().commit(None),Err(Error::AckProofRequired)));
    assert_eq!(r.view(),before);assert_eq!(r.poll(t(33)).unwrap().len(),1);
}

#[test] fn authenticated_leave_and_host_abandon_revoke_without_repeat_retirement() {
    let mut r=registry();let mut keys=Keys::new(&[10,11]);let w=join(&mut r,1,21,&request(1),&mut keys);
    let other=join(&mut r,2,22,&request(2),&mut keys);
    let leave=r.prepare_input(peer(1),&input(&w,1,Input::Leave),t(1)).unwrap().commit(None).unwrap();
    assert!(matches!(leave.transition,Some(Transition::Retired{player:21,reason:Retirement::Leave,..})));
    let before=r.view();assert!(matches!(r.prepare_resume(peer(3),&resume_request(&w,1,7),t(2),&mut keys),Err(Error::Retired)));
    assert_eq!(r.view(),before);assert!(matches!(r.abandon(22,t(2)).unwrap(),Some(Transition::Retired{reason:Retirement::Abandon,..})));
    assert_eq!(r.abandon(22,t(3)).unwrap(),None);assert_eq!(r.live_players(),0);
    assert!(matches!(r.prepare_input(peer(2),&input(&other,1,Input::Heartbeat),t(4)),Err(Error::Unauthorized)));
}

#[test] fn drain_removes_offline_reservations_but_keeps_connected_participants() {
    let mut r=registry();let mut keys=Keys::new(&[10,11]);let one=join(&mut r,1,21,&request(1),&mut keys);
    let two=join(&mut r,2,22,&request(2),&mut keys);
    r.prepare_input(peer(2),&input(&two,1,Input::Heartbeat),t(29)).unwrap().commit(None).unwrap();
    let events=r.begin_drain(t(31)).unwrap();
    assert_eq!(events,vec![Transition::Retired{player:21,endpoint:Some(Endpoint{peer:peer(1),context:one.context}),reason:Retirement::OwnerDrain}]);
    assert_eq!(r.live_players(),1);assert!(r.view().leases.iter().all(|l|!l.resumable));
    assert!(matches!(r.prepare_resume(peer(3),&resume_request(&one,1,7),t(32),&mut keys),Err(Error::Closing)));
    assert!(matches!(r.prepare_join(peer(3),&request(3),t(32),&mut keys),Err(Error::Closing)));
    assert!(r.begin_drain(t(32)).unwrap().is_empty());
    assert_eq!(r.poll(t(60)).unwrap().len(),1);assert_eq!(r.live_players(),0);
    assert!(r.poll(t(100)).unwrap().is_empty());
}

#[test] fn entropy_capacity_and_bootstrap_failures_do_not_publish_partial_owner() {
    let mut r=Registry::new(77,Limits::new(1,1,1).unwrap()).unwrap();let mut empty=Keys::new(&[]);let before=r.view();
    assert!(matches!(r.prepare_join(peer(1),&request(1),t(0),&mut empty),Err(Error::EntropyUnavailable)));
    assert_eq!(r.view(),before);let mut keys=Keys::new(&[10,11,12]);
    match r.prepare_join(peer(1),&request(1),t(0),&mut keys).unwrap() {
        JoinPreparation::New(p)=>assert!(matches!(p.commit(21,ClockBootstrap::Paused{through_ordinal:0}),Err(Error::InvalidBootstrap))),
        _=>panic!("new"),
    }
    assert_eq!(r.view(),before);let w=join(&mut r,1,21,&request(1),&mut keys);let before=r.view();
    assert!(matches!(r.prepare_join(peer(2),&request(2),t(1),&mut keys),Err(Error::Capacity)));
    assert!(matches!(r.prepare_resume(peer(2),&resume_request(&w,1,7),t(31),&mut keys),Err(Error::Capacity)));
    assert_eq!(r.view(),before);
}

#[test] fn dropped_preparation_invalid_ack_proof_and_backward_time_preserve_state() {
    let mut r=registry();let mut keys=Keys::new(&[10,11,12]);
    {let prepared=r.prepare_join(peer(1),&request(1),t(0),&mut keys).unwrap();drop(prepared);}
    assert_eq!(r.live_players(),0);let w=join(&mut r,1,21,&request(1),&mut keys);
    let before=r.view();{let p=r.prepare_resume(peer(2),&resume_request(&w,1,7),t(31),&mut keys).unwrap();drop(p);}
    assert_eq!(r.view(),before);
    let wrong=PreparedAck::check(Context{epoch:2,..w.context},1,1).unwrap();
    assert!(matches!(r.prepare_input(peer(1),&input(&w,1,Input::ClockAck{ordinal:1}),t(1)).unwrap().commit(Some(wrong)),Err(Error::AckProofRequired)));
    assert_eq!(r.view(),before);r.poll(t(2)).unwrap();let before=r.view();
    assert!(matches!(r.poll(t(1)),Err(Error::ClockWentBack)));assert_eq!(r.view(),before);
}

#[test] fn resumed_clock_bootstrap_is_required_before_commit_and_is_cached_exactly() {
    let mut r=registry();let mut keys=Keys::new(&[10,11,12]);let w=join(&mut r,1,21,&request(1),&mut keys);
    let req=resume_request(&w,1,7);let before=r.view();
    match r.prepare_resume(peer(2),&req,t(31),&mut keys).unwrap() {
        ResumePreparation::New(p)=>assert!(matches!(p.commit(ClockBootstrap::Paused{through_ordinal:0}),Err(Error::InvalidBootstrap))),
        _=>panic!("new"),
    }
    assert_eq!(r.view(),before);
    let w=match r.prepare_resume(peer(2),&req,t(31),&mut keys).unwrap() {
        ResumePreparation::New(p)=>p.commit(ClockBootstrap::Paused{through_ordinal:1}).unwrap().welcome,
        _=>panic!("new"),
    };
    let mut barrier=wire::BootstrapBarrier::new(&w).unwrap();barrier.observe_state(w.context,1,1).unwrap();assert!(!barrier.ready());
    barrier.observe_clock(w.context,1).unwrap();assert!(barrier.ready());
}

#[test] fn collision_identity_mismatch_and_retired_endpoints_reject_before_entropy() {
    let mut r=registry();let mut keys=Keys::new(&[10,10]);let req=request(1);let w=join(&mut r,1,21,&req,&mut keys);
    let before=r.view();let mut changed=req.clone();changed.champion="annie".into();
    assert!(matches!(r.prepare_join(peer(1),&changed,t(1),&mut keys),Err(Error::JoinMismatch)));
    assert!(matches!(r.prepare_join(peer(1),&request(2),t(1),&mut keys),Err(Error::EndpointRetired)));
    assert_eq!(keys.calls,1);
    assert!(matches!(r.prepare_resume(peer(2),&resume_request(&w,1,7),t(31),&mut keys),Err(Error::KeyCollision)));
    assert_eq!(r.view(),before);
}

#[test] fn sequence_and_epoch_exhaustion_refuse_without_wrap() {
    let mut r=registry();let mut keys=Keys::new(&[10]);let w=join(&mut r,1,21,&request(1),&mut keys);
    // Controlled counter injection only; no normal process/gameplay claim.
    r.leases[0].last_sequence=u64::MAX;let before=r.view();
    assert!(matches!(r.prepare_resume(peer(2),&resume_request(&w,1,7),t(31),&mut keys),Err(Error::CounterExhausted)));
    assert_eq!(r.view(),before);
    r.leases[0].last_sequence=0;r.leases[0].epoch=u64::MAX;
    let req=ResumeRequest{expected:Context{epoch:u64::MAX,..w.context},..resume_request(&w,1,7)};let before=r.view();
    assert!(matches!(r.prepare_resume(peer(2),&req,t(31),&mut keys),Err(Error::CounterExhausted)));
    assert_eq!(r.view(),before);assert_eq!(keys.calls,1);
}

#[test] fn registry_view_and_typed_debug_expose_no_capabilities() {
    let mut r=registry();let mut keys=Keys::new(&[213]);let mut req=request(199);
    req.request_nonce=nonce(17); // Public nonce must not equal the secret sentinel.
    let w=join(&mut r,1,21,&req,&mut keys);
    for text in [format!("{:?}",r.view()),format!("{req:?}"),format!("{w:?}"),w.public_log().to_string()] {
        assert!(!text.contains("213"));assert!(!text.contains("199"));
    }
}
