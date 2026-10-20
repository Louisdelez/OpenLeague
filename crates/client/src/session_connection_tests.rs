//! Prepared tests: controlled server packets, real local UDP and (Windows test)
//! the application-owned clock. No test here claims a complete GUI reconnect.
use super::*;
use openleague_core::{session_wire,session_transport as t};

fn nonce(v:u8)->t::RequestNonce {t::RequestNonce([v;16])}
fn key(v:u8)->t::Secret32 {t::Secret32::from_bytes([v;32]).unwrap()}
fn snapshot()->Snapshot {
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=911;
    game.join("garen").unwrap();game.snapshot()
}
fn fixture(secure:bool)->(Connection,UdpSocket,Snapshot,t::Welcome) {
    let state=snapshot();let player=state.players[0].id;
    let server=UdpSocket::bind("127.0.0.1:0").unwrap();server.set_read_timeout(Some(Duration::from_millis(100))).unwrap();
    let socket=UdpSocket::bind("127.0.0.1:0").unwrap();socket.connect(server.local_addr().unwrap()).unwrap();socket.set_nonblocking(true).unwrap();
    let client=secure.then(||Client::new(t::JoinRequest{version:t::VERSION,champion:"garen".into(),
        summoners:[Some(openleague_core::summoners::Spell::Smite),None],recovery_key:key(213),request_nonce:nonce(12)},false,nonce(13)).unwrap());
    let connection=Connection{socket,link:Link::new(client),id:None,session:None,sequence:0,
        last_join:Instant::now()-RETRANSMIT,champion:"garen".into(),summoners:[Some(openleague_core::summoners::Spell::Smite),None],
        rejection:String::new(),assembler:Default::default(),welcome_history:Default::default()};
    let welcome=t::Welcome{version:t::VERSION,context:t::Context{session:state.session,player,epoch:1},
        request_nonce:nonce(12),access_key:key(214),next_sequence:1,bootstrap:t::ClockBootstrap::Running};
    (connection,server,state,welcome)
}
fn receive(server:&UdpSocket)->Vec<u8> {let mut bytes=[0;16384];let n=server.recv(&mut bytes).unwrap();bytes[..n].to_vec()}
fn welcome(connection:&mut Connection,w:&t::Welcome,state:&mut crate::Match) {
    let row=connection.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionWelcome(w.clone())).unwrap()).unwrap();
    assert!(matches!(row,Some(Incoming::Welcome{epoch:Some(c),..}) if c==w.context));
    connection.id=Some(w.context.player);connection.session=Some(w.context.session);
    state.attack_visuals.reset(w.context.session);state.vilemaw_visuals.reset(w.context.session);state.w_visuals.reset(w.context.session);state.missile_journal.reset(w.context.session);
    assert!(crate::garen_w_live::begin_presentation_epoch(state,w.context.session,w.context.epoch).unwrap());
}
fn frame(connection:&mut Connection,sender:&mut session_wire::Sender,state:&Snapshot,clock:u64) {
    for bytes in sender.encode(state,clock).unwrap() {assert!(connection.decode_datagram(&bytes).unwrap().is_none());}
}
fn commit(connection:&mut Connection,state:&mut crate::Match,incoming:Incoming,now:f64) {
    let Incoming::State{snapshot,delivery:Some((context,ordinal))}=incoming else {panic!("state")};
    openleague_core::entity_facing::validate_snapshot(&snapshot).unwrap();
    assert!(crate::garen_w_live::accept_presentations_frame(state,&snapshot,ordinal,now).unwrap());
    state.snapshot=Some(snapshot);connection.presented(Some((context,ordinal))).unwrap();
}

#[test] fn secure_endpoint_requires_os_resolved_loopback_before_any_send() {
    assert!(validate_endpoint("127.0.0.1:5896".parse().unwrap()).is_ok());
    assert!(validate_endpoint("127.8.9.10:5896".parse().unwrap()).is_ok());
    for remote in ["192.0.2.1:5896","0.0.0.0:5896","10.1.2.3:5896","[2001:db8::1]:5896"] {
        assert_eq!(validate_endpoint(remote.parse().unwrap()),Err("Private session endpoint is not local"));
    }
}

#[test] fn pending_request_retransmits_exactly_without_exposing_recovery_key_in_public_input() {
    let (mut c,server,_,_)=fixture(true);
    c.maintain_session();let first=receive(&server);
    c.link.last_sent-=RETRANSMIT;c.maintain_session();let second=receive(&server);
    assert_eq!(first,second);
    assert!(matches!(serde_json::from_slice::<t::ClientMessage>(&first).unwrap(),t::ClientMessage::JoinResumable(_)));
    assert!(!c.ready());assert!(c.send_action(Action::Stop).is_err());assert!(c.send_pause(true).is_err());
    assert!(server.recv(&mut [0;8]).is_err());
}
#[test] fn ready_requires_committed_presentation_then_all_actions_share_one_secure_sequence() {
    let (mut c,server,s,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);assert!(c.inventory_input_identity().is_none());
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut sender,&s,0);
    let pending=c.take_ready_states();assert_eq!(pending.len(),1);assert!(!c.ready());
    assert!(c.send_action(Action::Stop).is_err());assert!(c.send_pause(false).is_err());
    commit(&mut c,&mut state,pending.into_iter().next().unwrap(),0.);assert!(c.ready());assert_eq!(c.inventory_input_identity(),Some((s.session,w.context.player,Some(1))));
    let public=c.send_action(Action::SummonerTarget{slot:0,target:None}).unwrap();
    assert!(!public.to_string().contains("access_key"));assert!(!public.to_string().contains("214"));
    c.send_action(Action::Learn{slot:0}).unwrap();c.send_action(Action::Buy{item:2003}).unwrap();c.send_pause(true).unwrap();
    for expected in 1..=4 {let t::ClientMessage::Session(input)=serde_json::from_slice(&receive(&server)).unwrap() else {panic!("secure input")};
        assert_eq!(input.sequence,expected);assert_eq!(input.context,w.context);}
    assert_eq!(c.sequence,0,"legacy sequence is not the secure sequence");
}
#[test] fn newer_same_tick_frame_updates_snapshot_only_after_journal_commit() {
    let (mut c,_,s,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut sender,&s,0);
    let first=c.take_ready_states().pop().unwrap();commit(&mut c,&mut state,first,0.);
    let mut changed=s.clone();changed.players[0].gold+=10.;frame(&mut c,&mut sender,&changed,0);
    let pending=c.take_ready_states();assert!(!c.ready());assert_eq!(state.snapshot.as_ref().unwrap().players[0].gold,s.players[0].gold);
    commit(&mut c,&mut state,pending.into_iter().next().unwrap(),0.);
    assert!(c.ready());assert_eq!(state.snapshot.as_ref().unwrap().tick,s.tick);assert_eq!(state.snapshot.as_ref().unwrap().players[0].gold,changed.players[0].gold);
}
#[test] fn interruption_changes_socket_and_queries_same_player_without_leave_or_new_join() {
    let (mut c,server,s,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut sender,&s,0);
    let input=c.take_ready_states().pop().unwrap();commit(&mut c,&mut state,input,0.);
    let old_socket=c.socket.local_addr().unwrap();c.network_interrupted();assert!(!c.ready());
    assert_eq!((c.session,c.id),(Some(s.session),Some(w.context.player)));
    assert_eq!(state.snapshot.as_ref().unwrap().players[0].health,s.players[0].health);
    c.maintain_session();assert_ne!(c.socket.local_addr().unwrap(),old_socket);
    let bytes=receive(&server);let t::ClientMessage::ContextQuery(query)=serde_json::from_slice(&bytes).unwrap() else {panic!("context only")};
    assert_eq!(query.expected_session,Some(s.session));
    let response=t::ContextResponse{request_nonce:query.request_nonce,context:w.context,availability:t::Availability::Busy};
    c.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionContext(response.clone())).unwrap()).unwrap();
    c.maintain_session();assert_eq!(receive(&server),bytes,"Busy repeats exactly the same query");
    let response=t::ContextResponse{availability:t::Availability::Detached,..response};
    c.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionContext(response)).unwrap()).unwrap();
    c.maintain_session();let t::ClientMessage::Resume(resume)=serde_json::from_slice(&receive(&server)).unwrap() else {panic!("resume only")};
    assert_eq!(resume.expected,w.context);assert!(!c.ready());
}
#[test] fn legacy_commands_remain_legacy_and_explicit_departure_closes_once() {
    let (mut c,server,s,w)=fixture(false);c.id=Some(w.context.player);c.session=Some(s.session);
    c.send_action(Action::Stop).unwrap();
    assert!(matches!(serde_json::from_slice::<ClientPacket>(&receive(&server)).unwrap(),ClientPacket::Command{sequence:1,action:Action::Stop}));
    c.depart().unwrap();assert!(matches!(serde_json::from_slice::<ClientPacket>(&receive(&server)).unwrap(),ClientPacket::Leave{sequence:2,..}));
    c.depart().unwrap();c.maintain_session();assert!(c.send_action(Action::Stop).is_err());assert!(server.recv(&mut [0;8]).is_err());
}
#[test] fn unframed_or_foreign_state_never_unlocks_a_secure_client() {
    let (mut c,_,s,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let body=t::StateEnvelope{context:w.context,frame_ordinal:1,clock_ordinal:0,snapshot:s.clone()};
    assert!(c.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionState(body)).unwrap()).is_err());
    let mut wrong=session_wire::Sender::new(t::Context{epoch:2,..w.context}).unwrap();
    for bytes in wrong.encode(&s,0).unwrap() {assert!(c.decode_datagram(&bytes).is_err());}
    assert!(c.take_ready_states().is_empty());assert!(!c.ready());
}

#[test] fn late_duplicate_frames_do_not_postpone_recovery_after_silence() {
    let (mut c,server,s,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();let chunks=sender.encode(&s,0).unwrap();
    for chunk in &chunks {c.decode_datagram(chunk).unwrap();}
    let pending=c.take_ready_states().pop().unwrap();commit(&mut c,&mut state,pending,0.);
    // Controlled deadline only: no real five-second outage is claimed here.
    c.link.last_received=Instant::now()-SILENCE;let before=c.link.last_received;
    for chunk in &chunks {assert!(c.decode_datagram(chunk).unwrap().is_none());}
    assert_eq!(c.link.last_received,before);assert!(c.take_ready_states().is_empty());
    c.maintain_session();assert!(!c.ready());
    assert!(matches!(serde_json::from_slice::<t::ClientMessage>(&receive(&server)).unwrap(),t::ClientMessage::ContextQuery(_)));
    assert_eq!(state.snapshot.as_ref().unwrap().tick,s.tick);
}

#[test] fn resumed_same_session_keeps_last_gameplay_until_same_tick_commit() {
    let (mut c,server,s,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut sender,&s,0);
    let first=c.take_ready_states().pop().unwrap();commit(&mut c,&mut state,first,0.);
    assert_eq!(c.inventory_input_identity(),Some((s.session,w.context.player,Some(1))));
    c.network_interrupted();assert!(c.inventory_input_identity().is_none());c.maintain_session();
    let t::ClientMessage::ContextQuery(query)=serde_json::from_slice(&receive(&server)).unwrap() else {panic!("query")};
    c.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionContext(t::ContextResponse{
        request_nonce:query.request_nonce,context:w.context,availability:t::Availability::Detached})).unwrap()).unwrap();
    c.maintain_session();
    let t::ClientMessage::Resume(resume)=serde_json::from_slice(&receive(&server)).unwrap() else {panic!("resume")};
    let next=t::Welcome{context:t::Context{epoch:2,..w.context},request_nonce:resume.request_nonce,
        access_key:key(215),next_sequence:17,..w.clone()};
    let Some(Incoming::Welcome{session,player,epoch:Some(context)})=c.decode_datagram(
        &serde_json::to_vec(&t::ServerMessage::SessionWelcome(next.clone())).unwrap()).unwrap() else {panic!("new epoch")};
    assert_eq!((c.session,c.id),(Some(session),Some(player)));assert!(c.inventory_input_identity().is_none());
    assert!(crate::garen_w_live::begin_presentation_epoch(&mut state,session,context.epoch).unwrap());
    assert_eq!(state.snapshot.as_ref().unwrap().players[0].gold,s.players[0].gold);assert!(!c.ready());
    let mut changed=s.clone();changed.players[0].gold+=20.;
    let mut sender=session_wire::Sender::new(context).unwrap();frame(&mut c,&mut sender,&changed,0);
    let next_state=c.take_ready_states().pop().unwrap();assert!(!c.ready());
    commit(&mut c,&mut state,next_state,0.);assert!(c.ready());assert_eq!(c.inventory_input_identity(),Some((s.session,w.context.player,Some(2))));
    assert_eq!(state.snapshot.as_ref().unwrap().tick,s.tick);
    assert_eq!(state.snapshot.as_ref().unwrap().players[0].gold,changed.players[0].gold);
    c.send_action(Action::Stop).unwrap();
    let t::ClientMessage::Session(input)=serde_json::from_slice(&receive(&server)).unwrap() else {panic!("input")};
    assert_eq!((input.context,input.sequence),(context,17));
}

#[cfg(windows)]
#[test] fn real_effect_clock_is_validated_before_application_and_ack_uses_applied_ordinal() {
    use bevy::prelude::*;
    let (mut c,server,s,mut w)=fixture(true);w.bootstrap=t::ClockBootstrap::Paused{through_ordinal:1};
    let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut sender,&s,1);
    assert!(c.take_ready_states().is_empty());
    let owner=openleague_core::audio_replay_windows_application::Application::new().unwrap();
    let source=owner.transport().unwrap().clock_handle().unwrap();let before=source.raw_clock_sample().unwrap();
    let mut app=App::new();app.insert_resource(crate::native_effect_clock::EffectClock::with_process_clock(source.clone()));
    app.add_plugins(crate::native_effect_clock::Plugin);app.update();app.update();
    let mut clock=app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>();
    let now=clock.now;let mut pause=vec![0;14];pause[9..13].copy_from_slice(&30i32.to_le_bytes());pause[13]=1;
    let old=clock.diagnostic();
    assert!(apply_clock(&mut c,&mut clock,Some(t::Context{epoch:2,..w.context}),s.session,1,0xa1,&pause).is_err());
    assert_eq!(clock.diagnostic(),old);assert!(server.recv(&mut [0;8]).is_err());
    apply_clock(&mut c,&mut clock,Some(w.context),s.session,1,0xa1,&pause).unwrap();
    let t::ClientMessage::Session(first)=serde_json::from_slice(&receive(&server)).unwrap() else {panic!("ACK")};
    assert!(matches!(first.input,t::Input::ClockAck{ordinal:1}));assert!(clock.paused());
    let pending=c.take_ready_states();assert!(!c.ready());commit(&mut c,&mut state,pending.into_iter().next().unwrap(),clock.now);assert!(c.ready());
    let current=clock.diagnostic();
    assert!(c.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionWelcome(w.clone())).unwrap()).unwrap().is_none());
    assert_eq!(clock.diagnostic(),current,"duplicate welcome did not request reset");
    apply_clock(&mut c,&mut clock,Some(w.context),s.session,1,0xa1,&pause).unwrap();
    let t::ClientMessage::Session(second)=serde_json::from_slice(&receive(&server)).unwrap() else {panic!("fresh ACK")};
    assert!(second.sequence>first.sequence);assert!(matches!(second.input,t::Input::ClockAck{ordinal:1}));
    clock.reset_session();assert!(clock.now>=now);let after=source.raw_clock_sample().unwrap();
    assert_eq!((before.origin,before.frequency),(after.origin,after.frequency));
    assert_eq!(clock.now,current["time"].as_f64().unwrap());
}

#[test] fn explicit_ipv6_loopback_accepted_by_policy_gets_matching_source_family() {
    let peer:std::net::SocketAddr="[::1]:5896".parse::<std::net::SocketAddr>().unwrap();
    assert!(validate_endpoint(peer).is_ok());
    let local=loopback_bind_address_for_resolved_peers(&[peer]).unwrap();
    assert_eq!(local,"[::1]:0".parse::<std::net::SocketAddr>().unwrap());
    assert!(local.is_ipv6()&&local.ip().is_loopback());
    let previous:std::net::SocketAddr="127.0.0.1:0".parse::<std::net::SocketAddr>().unwrap();
    assert_ne!(previous.is_ipv6(),peer.is_ipv6());
}

#[test] fn ipv4_destinations_keep_the_existing_loopback_source_and_ephemeral_port() {
    for remote in ["127.0.0.1:5896","127.8.9.10:65535","192.0.2.1:5896","0.0.0.0:0"] {
        let peer:std::net::SocketAddr=remote.parse::<std::net::SocketAddr>().unwrap();
        let local=loopback_bind_address_for_resolved_peers(&[peer]).unwrap();
        assert_eq!(local,"127.0.0.1:0".parse::<std::net::SocketAddr>().unwrap());
        assert_eq!(local.port(),0);
    }
}

#[test] fn mixed_resolution_retains_ipv4_preference_without_rewriting_peer_order() {
    let peers:Vec<std::net::SocketAddr>=["[::1]:5896","127.0.0.1:5896","127.8.9.10:5896"]
        .into_iter().map(|s|s.parse::<std::net::SocketAddr>().unwrap()).collect();
    let before=peers.clone();
    assert_eq!(loopback_bind_address_for_resolved_peers(&peers).unwrap(),"127.0.0.1:0".parse::<std::net::SocketAddr>().unwrap());
    assert_eq!(peers,before);
    assert_eq!(loopback_bind_address_for_resolved_peers(&peers[..1]).unwrap(),"[::1]:0".parse::<std::net::SocketAddr>().unwrap());
}

#[test] fn missing_resolved_destination_cannot_select_a_socket_address() {
    assert_eq!(loopback_bind_address_for_resolved_peers(&[]),Err("No resolved server endpoint"));
}

#[test] fn choosing_a_local_family_does_not_authorize_a_private_remote_peer() {
    for remote in ["192.0.2.1:5896","0.0.0.0:5896","10.1.2.3:5896","[2001:db8::1]:5896","[::]:5896"] {
        let peer:std::net::SocketAddr=remote.parse::<std::net::SocketAddr>().unwrap();
        let local=loopback_bind_address_for_resolved_peers(&[peer]).unwrap();
        assert!(local.ip().is_loopback());assert_eq!(local.port(),0);
        assert_eq!(validate_endpoint(peer),Err("Private session endpoint is not local"));
    }
}

#[test]
fn ipv6_loopback_roundtrip_uses_candidate_source_choice() {
    let server=UdpSocket::bind("[::1]:0").expect("OS IPv6 loopback required");
    server.set_read_timeout(Some(Duration::from_secs(1))).unwrap();
    let peer=server.local_addr().unwrap();
    assert!(validate_endpoint(peer).is_ok());
    let client=UdpSocket::bind(loopback_bind_address_for_resolved_peers(&[peer]).unwrap()).unwrap();
    client.connect(peer).unwrap();client.set_read_timeout(Some(Duration::from_secs(1))).unwrap();
    assert_eq!(client.send(b"OpenLeague-family-probe").unwrap(),23);
    let mut bytes=[0u8;64];let(n,source)=server.recv_from(&mut bytes).unwrap();
    assert_eq!(&bytes[..n],b"OpenLeague-family-probe");
    assert!(source.is_ipv6()&&source.ip().is_loopback());
    server.send_to(b"reply",source).unwrap();let n=client.recv(&mut bytes).unwrap();
    assert_eq!(&bytes[..n],b"reply");
}

#[test]
fn precommit_observation_gate_preserves_link_context_and_explicit_legacy_boundaries() {
    let(mut connection,_server,snapshot,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut connection,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut connection,&mut sender,&snapshot,0);
    assert!(!connection.observation_ready(Some((w.context,1))));
    let batch=connection.take_ready_states();assert_eq!(batch.len(),1);assert!(!connection.ready());
    assert!(connection.observation_ready(Some((w.context,1))));assert!(!connection.observation_ready(None));
    connection.link.closed=true;assert!(!connection.observation_ready(Some((w.context,1))));connection.link.closed=false;
    connection.link.fatal=Some("controlled error");assert!(!connection.observation_ready(Some((w.context,1))));connection.link.fatal=None;
    connection.network_interrupted();assert!(!connection.observation_ready(Some((w.context,1))));connection.link.recover_socket=false;
    connection.id=Some(w.context.player+1);assert!(!connection.observation_ready(Some((w.context,1))));connection.id=Some(w.context.player);
    connection.session=Some(w.context.session+1);assert!(!connection.observation_ready(Some((w.context,1))));connection.session=Some(w.context.session);
    commit(&mut connection,&mut state,batch.into_iter().next().unwrap(),0.);assert!(connection.ready());
    assert!(!connection.observation_ready(Some((w.context,1))));
    let(mut legacy,_server,_s,w)=fixture(false);assert!(!legacy.observation_ready(None));
    legacy.id=Some(w.context.player);legacy.session=Some(w.context.session);assert!(legacy.observation_ready(None));
    assert!(!legacy.observation_ready(Some((w.context,1))));legacy.link.closed=true;assert!(!legacy.observation_ready(None));
}
fn oncast_fixture()->(Connection,UdpSocket,openleague_core::Simulation,u32,t::Welcome,crate::Match,crate::ezreal_r_cast_audio_state::State){
    let(connection,server,_snapshot,w)=fixture(true);
    let mut cells=Vec::new();for _ in 0..6400{cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
    let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=w.context.session;let owner=game.join("ezreal").unwrap();assert_eq!(owner,w.context.player);
    let actor=game.players.get_mut(&owner).unwrap();actor.position=openleague_core::Point{x:200.,z:300.};actor.level=6;actor.ranks[3]=1;actor.mana=2000.;
    let mut state=crate::Match::default();let mut connection=connection;welcome(&mut connection,&w,&mut state);
    let mut audio=crate::ezreal_r_cast_audio_state::State::default();audio.begin_epoch(w.context.session,w.context.epoch,owner);
    (connection,server,game,owner,w,state,audio)
}
#[test]
fn actual_olsr_empty_baselines_then_first_authoritative_r_cast_admit_before_commit_without_unlocking_input() {
    let(mut connection,_server,mut game,owner,w,mut state,mut audio)=oncast_fixture();
    let mut sender=session_wire::Sender::new(w.context).unwrap();
    // Controlled late session ticks exercise a first R after long empty history.
    // This is not a wall-clock sixteen-minute runtime or an audio playback test.
    for(tick,now)in [(0,0.),(16_000,500.),(28_800,960.)]{
        game.tick=tick;let snapshot=game.snapshot_for_atomic(owner).unwrap();assert_eq!(snapshot.ezreal_r_accepted_casts.as_ref().unwrap()["events"].as_array().unwrap().len(),0);
        frame(&mut connection,&mut sender,&snapshot,0);let incoming=connection.take_ready_states().pop().unwrap();
        let Incoming::State{snapshot,delivery}= &incoming else{panic!("state")};
        assert!(!connection.ready());assert!(connection.observation_ready(*delivery));
        audio.observe_accepted_frame(snapshot,now,connection.observation_ready(*delivery),false,*delivery).unwrap();
        assert!(audio.presentation_ready(now));assert!(audio.take(now,true,false).is_empty());
        commit(&mut connection,&mut state,incoming,now);assert!(connection.ready());
    }
    game.tick=28_801;game.command(owner,Action::CastAt{slot:3,point:openleague_core::Point{x:3000.,z:300.}}).unwrap();
    let snapshot=game.snapshot_for_atomic(owner).unwrap();frame(&mut connection,&mut sender,&snapshot,0);
    let incoming=connection.take_ready_states().pop().unwrap();let Incoming::State{snapshot,delivery}=&incoming else{panic!("state")};
    assert!(!connection.ready());assert!(connection.send_action(Action::Stop).is_err());
    let codes=crate::ezreal_r_cast_audio_diagnostics::captured(||{
        audio.observe_accepted_frame(snapshot,960.01,connection.observation_ready(*delivery),false,*delivery).unwrap();
    });
    assert_eq!(codes,vec![crate::ezreal_r_cast_audio_diagnostics::Code::EventAdmitted]);assert!(audio.has_pending());
    commit(&mut connection,&mut state,incoming,960.01);assert!(connection.ready());
    let requests=audio.take(960.01,connection.ready(),false);assert_eq!(requests.len(),1);assert_eq!(requests[0].identity.owner,owner);
    frame(&mut connection,&mut sender,&game.snapshot_for_atomic(owner).unwrap(),0);
    let incoming=connection.take_ready_states().pop().unwrap();let Incoming::State{snapshot,delivery}=&incoming else{panic!("state")};
    audio.observe_accepted_frame(snapshot,960.02,connection.observation_ready(*delivery),false,*delivery).unwrap();
    commit(&mut connection,&mut state,incoming,960.02);assert!(audio.take(960.02,connection.ready(),false).is_empty());
}
#[test]
fn all_delivered_oncast_frames_observe_revocation_before_coalescence_and_never_replay() {
    let(mut connection,_server,mut game,owner,w,mut state,mut audio)=oncast_fixture();let mut sender=session_wire::Sender::new(w.context).unwrap();
    frame(&mut connection,&mut sender,&game.snapshot_for_atomic(owner).unwrap(),0);
    let incoming=connection.take_ready_states().pop().unwrap();let Incoming::State{snapshot,delivery}=&incoming else{panic!("state")};
    audio.observe_accepted_frame(snapshot,1.,connection.observation_ready(*delivery),false,*delivery).unwrap();commit(&mut connection,&mut state,incoming,1.);
    game.command(owner,Action::CastAt{slot:3,point:openleague_core::Point{x:3000.,z:300.}}).unwrap();let snapshot=game.snapshot_for_atomic(owner).unwrap();
    let mut absent=snapshot.clone();absent.ezreal_r_accepted_casts=None;
    for snapshot in [&snapshot,&absent,&snapshot]{frame(&mut connection,&mut sender,snapshot,0);}
    let batch=connection.take_ready_states();assert_eq!(batch.len(),3);
    for(index,incoming)in batch.into_iter().enumerate(){
        let Incoming::State{snapshot,delivery}=&incoming else{panic!("state")};assert!(connection.observation_ready(*delivery));assert!(!connection.ready());
        audio.observe_accepted_frame(snapshot,1.01,connection.observation_ready(*delivery),false,*delivery).unwrap();
        if index==0{assert!(audio.has_pending());}else{assert!(!audio.has_pending());}
        commit(&mut connection,&mut state,incoming,1.01);
    }
    assert!(connection.ready());assert!(audio.take(1.01,connection.ready(),false).is_empty());
    // A true loss of connection still closes playback immediately and can never
    // be bypassed by retaining an exact old delivery tuple.
    connection.network_interrupted();assert!(!connection.ready());assert!(!connection.observation_ready(Some((w.context,4))));
    assert!(audio.take(1.02,connection.ready(),false).is_empty());
}


#[test]
fn ordinary_pause_correlates_real_secure_request_refusal_and_full_width_sequence() {
    let(mut c,server,s,mut w)=fixture(true);
    let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let mut initial_sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut initial_sender,&s,0);
    let incoming=c.take_ready_states().pop().unwrap();commit(&mut c,&mut state,incoming,0.);
    // A first Join requires epoch1; exercise full-width values through a real resume handshake.
    c.network_interrupted();c.maintain_session();
    let t::ClientMessage::ContextQuery(query)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("recovery query")};
    assert_eq!(query.expected_session,Some(s.session));
    w.context.epoch=(1u64<<53)+31;w.next_sequence=(1u64<<53)+41;
    let previous=t::Context{epoch:w.context.epoch-1,..w.context};
    let response=t::ContextResponse{request_nonce:query.request_nonce,context:previous,availability:t::Availability::Detached};
    c.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionContext(response)).unwrap()).unwrap();
    c.maintain_session();
    let t::ClientMessage::Resume(resume)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("resume request")};
    assert_eq!(resume.expected,previous);assert!(!c.ready());
    w.request_nonce=resume.request_nonce;
    welcome(&mut c,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut sender,&s,0);
    let incoming=c.take_ready_states().pop().unwrap();commit(&mut c,&mut state,incoming,0.);
    let mut pause=crate::ordinary_pause::State::default();pause.update(c.inventory_input_identity(),true,(0,false,false),10.);
    assert!(pause.request(&mut c,10.));assert!(!pause.request(&mut c,10.01),"one in-flight request only");
    let t::ClientMessage::Session(input)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("secure pause")};
    assert_eq!(input.context,w.context);assert_eq!(input.sequence,w.next_sequence);
    assert!(matches!(input.input,t::Input::PauseRequest{paused:true}));
    let rejection=t::GameplayRejection{context:w.context,sequence:input.sequence,reason:"pause disabled by local match host".into()};
    let Some(Incoming::GameplayRejected{context,sequence,reason})=c.decode_datagram(
        &serde_json::to_vec(&t::ServerMessage::SessionGameplayRejected(rejection)).unwrap()).unwrap() else{panic!("correlated refusal")};
    assert_eq!(sequence,input.sequence);pause.rejected(Some(context),Some(sequence),&reason);
    assert!(pause.request(&mut c,10.1),"refused request is resolved but only a new gesture sends again");
    let t::ClientMessage::Session(second)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("new request")};
    assert_eq!(second.sequence,input.sequence+1);assert!(matches!(second.input,t::Input::PauseRequest{paused:true}));
    pause.update(c.inventory_input_identity(),true,(1,true,false),10.2);
    assert!(pause.request(&mut c,10.3));
    let t::ClientMessage::Session(resume)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("resume")};
    assert!(matches!(resume.input,t::Input::PauseRequest{paused:false}));
    c.network_interrupted();pause.update(c.inventory_input_identity(),false,(1,true,false),10.4);
    assert!(!pause.request(&mut c,10.5));assert!(server.recv(&mut[0;16384]).is_err());
}
#[test]
fn ordinary_pause_legacy_sequence_and_refusal_keep_the_existing_packet_shape() {
    let(mut c,server,s,w)=fixture(false);c.id=Some(w.context.player);c.session=Some(s.session);c.sequence=(1u64<<53)+11;
    let mut pause=crate::ordinary_pause::State::default();pause.update(c.inventory_input_identity(),true,(0,false,false),10.);
    assert!(pause.request(&mut c,10.));
    let ClientPacket::PauseRequest{sequence,paused}=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("legacy pause")};
    assert_eq!(sequence,(1u64<<53)+12);assert!(paused);
    let bytes=serde_json::to_vec(&ServerPacket::Rejected{reason:"pause disabled by local match host".into()}).unwrap();
    let Some(Incoming::Rejected(reason))=c.decode_datagram(&bytes).unwrap() else{panic!("legacy refusal")};
    pause.rejected(None,None,&reason);assert!(pause.request(&mut c,10.1));
    let ClientPacket::PauseRequest{sequence,paused}=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("new legacy request")};
    assert_eq!(sequence,(1u64<<53)+13);assert!(paused);
}

#[cfg(windows)]
#[test]
fn ordinary_pause_tracks_real_applied_clock_ack_and_waits_for_authoritative_final_resume() {
    use bevy::prelude::*;
    let(mut c,server,s,w)=fixture(true);let mut state=crate::Match::default();welcome(&mut c,&w,&mut state);
    let mut sender=session_wire::Sender::new(w.context).unwrap();frame(&mut c,&mut sender,&s,0);
    let incoming=c.take_ready_states().pop().unwrap();commit(&mut c,&mut state,incoming,0.);
    let owner=openleague_core::audio_replay_windows_application::Application::new().unwrap();
    let mut app=App::new();app.insert_resource(crate::native_effect_clock::EffectClock::with_process_clock(
        owner.transport().unwrap().clock_handle().unwrap()));
    app.add_plugins(crate::native_effect_clock::Plugin);app.update();app.update();
    let mut clock=app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>();
    let mut pause=crate::ordinary_pause::State::default();pause.update(c.inventory_input_identity(),true,clock.pause_ui_status(),10.);
    assert!(pause.request(&mut c,10.));
    let t::ClientMessage::Session(request)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("pause")};
    assert!(matches!(request.input,t::Input::PauseRequest{paused:true}));assert!(!clock.paused());
    let mut packet=vec![0;14];packet[9..13].copy_from_slice(&30i32.to_le_bytes());packet[13]=1;
    apply_clock(&mut c,&mut clock,Some(w.context),s.session,1,0xa1,&packet).unwrap();
    let t::ClientMessage::Session(ack)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("ACK")};
    assert!(matches!(ack.input,t::Input::ClockAck{ordinal:1}));assert!(clock.paused());
    pause.update(c.inventory_input_identity(),true,clock.pause_ui_status(),10.1);
    assert!(pause.request(&mut c,10.2));
    let t::ClientMessage::Session(resume)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("resume")};
    assert!(matches!(resume.input,t::Input::PauseRequest{paused:false}));
    let mut delayed=vec![0;10];delayed[9]=1;
    apply_clock(&mut c,&mut clock,Some(w.context),s.session,2,0x0a,&delayed).unwrap();
    let t::ClientMessage::Session(ack)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("ACK")};
    assert!(matches!(ack.input,t::Input::ClockAck{ordinal:2}));
    pause.update(c.inventory_input_identity(),true,clock.pause_ui_status(),10.3);
    assert!(!pause.request(&mut c,10.4),"countdown does not send another request");
    apply_clock(&mut c,&mut clock,Some(w.context),s.session,3,0x0a,&[0;10]).unwrap();
    let t::ClientMessage::Session(ack)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("ACK")};
    assert!(matches!(ack.input,t::Input::ClockAck{ordinal:3}));assert!(!clock.paused());
    pause.update(c.inventory_input_identity(),true,clock.pause_ui_status(),10.5);
    assert!(pause.request(&mut c,10.6));
    let t::ClientMessage::Session(next)=serde_json::from_slice(&receive(&server)).unwrap() else{panic!("next pause")};
    assert!(matches!(next.input,t::Input::PauseRequest{paused:true}));assert!(next.sequence>resume.sequence);
}

#[test]
fn actual_olsr_arrival_audio_observes_precommit_then_consumes_without_unlocking_inputs(){
    let(mut connection,_server,mut game,owner,w,mut state,_r_audio)=oncast_fixture();
    game.players.get_mut(&owner).unwrap().ranks=[0,0,1,0];
    let mut audio=crate::ezreal_e_return_audio_state::State::default();audio.begin_epoch(w.context.session,w.context.epoch,owner);
    let mut sender=session_wire::Sender::new(w.context).unwrap();
    frame(&mut connection,&mut sender,&game.snapshot_for_atomic(owner).unwrap(),0);
    let incoming=connection.take_ready_states().pop().unwrap();let Incoming::State{snapshot,delivery}=&incoming else{panic!("state")};
    assert!(!connection.ready());assert!(connection.observation_ready(*delivery));
    audio.observe_accepted_frame(snapshot,1.,connection.observation_ready(*delivery),false,*delivery).unwrap();commit(&mut connection,&mut state,incoming,1.);
    assert!(connection.ready());assert!(audio.take(1.,true,false).is_empty());
    game.command(owner,Action::CastAt{slot:2,point:openleague_core::Point{x:500.,z:300.}}).unwrap();for _ in 0..8{game.advance();}
    let snapshot=game.snapshot_for_atomic(owner).unwrap();frame(&mut connection,&mut sender,&snapshot,0);
    let incoming=connection.take_ready_states().pop().unwrap();let Incoming::State{snapshot,delivery}=&incoming else{panic!("state")};
    assert!(!connection.ready());assert!(connection.send_action(Action::Stop).is_err());assert!(connection.observation_ready(*delivery));
    let mut wrong=delivery.unwrap();wrong.1+=1;assert!(!connection.observation_ready(Some(wrong)));
    audio.observe_accepted_frame(snapshot,1.01,connection.observation_ready(*delivery),false,*delivery).unwrap();commit(&mut connection,&mut state,incoming,1.01);
    assert!(connection.ready());let requests=audio.take(1.01,true,false);assert_eq!(requests.len(),1);assert_eq!(requests[0].position,game.players[&owner].position);
    let mut absent=game.snapshot_for_atomic(owner).unwrap();absent.ezreal_e_accepted_releases=None;
    for s in [&absent,&game.snapshot_for_atomic(owner).unwrap()] {frame(&mut connection,&mut sender,s,0);}
    for incoming in connection.take_ready_states(){let Incoming::State{snapshot,delivery}=&incoming else{panic!("state")};audio.observe_accepted_frame(snapshot,1.02,connection.observation_ready(*delivery),false,*delivery).unwrap();commit(&mut connection,&mut state,incoming,1.02);}
    assert!(!audio.authorizes(&requests[0]));assert!(audio.take(1.02,connection.ready(),false).is_empty());
}
