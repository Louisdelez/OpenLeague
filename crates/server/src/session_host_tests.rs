//! Composition tests with actual Simulation/registry/Pause. Time and entropy
//! below are controlled inputs, not OS, UDP or graphical runtime evidence.
use super::*;
fn time(seconds:u64)->Duration{Duration::from_secs(seconds)}
fn peer(port:u16)->SocketAddr{([127,0,0,1],port).into()}
fn key(v:u8)->t::Secret32{t::Secret32::from_bytes([v;32]).unwrap()}
fn nonce(v:u8)->t::RequestNonce{t::RequestNonce([v;16])}
struct Keys(u8);
impl r::Entropy for Keys{fn access_key(&mut self)->Result<t::Secret32,r::EntropyUnavailable>{self.0+=1;Ok(key(self.0))}}
fn game()->Simulation{
 let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
 let mut s=Simulation::new(nav).unwrap();s.session=77;s
}
fn request(v:u8)->t::JoinRequest{t::JoinRequest{version:t::VERSION,champion:"garen".into(),summoners:[None,None],recovery_key:key(v),request_nonce:nonce(v)}}
fn welcome(m:Option<t::ServerMessage>)->t::Welcome{match m{Some(t::ServerMessage::SessionWelcome(w))=>w,_=>panic!("expected Welcome (message deliberately not logged)")}}
fn send(h:&mut Host,g:&mut Simulation,d:&mut Delivery,p:&mut Pause,k:&mut Keys,port:u16,seconds:u64,m:t::ClientMessage)->Option<t::ServerMessage>{h.handle(m,peer(port),false,g,d,p,time(seconds),true,k).unwrap()}
fn input(w:&t::Welcome,sequence:u64,input:t::Input)->t::ClientMessage{t::ClientMessage::Session(t::SessionInput{version:t::VERSION,context:w.context,access_key:w.access_key.clone(),sequence,input})}

#[test] fn resume_after_long_silence_keeps_exact_simulation_player_and_replaces_route(){
 let(mut g,mut d,mut p,mut k)=(game(),Delivery::default(),Pause::default(),Keys(80));let mut h=Host::new(g.session).unwrap();
 let req=request(1);let w=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,0,t::ClientMessage::JoinResumable(req.clone())));
 let player=w.context.player;
 // Deliberately prepared state distinguishes a retained player from join/reset.
 let a=g.players.get_mut(&player).unwrap();a.gold=43.;a.inventory[0]=Some(1001);a.cooldowns[0]=990;a.health=71.;
 let before=serde_json::to_value(&g.players[&player]).unwrap();
 h.poll(time(4000),false,&mut g,&mut d).unwrap();assert!(h.routes.is_empty());assert_eq!(d.issued(player),None);
 assert_eq!(h.participants(),1);assert_eq!(serde_json::to_value(&g.players[&player]).unwrap(),before);
 let resume=t::ResumeRequest{version:t::VERSION,expected:w.context,recovery_key:req.recovery_key,request_nonce:nonce(2)};
 let new=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10002,4001,t::ClientMessage::Resume(resume.clone())));
 assert_eq!(new.context.player,player);assert_eq!(new.context.epoch,2);assert_eq!(g.players.len(),1);
 assert_eq!(serde_json::to_value(&g.players[&player]).unwrap(),before);assert!(!h.routes.contains_key(&peer(10001)));assert!(h.routes.contains_key(&peer(10002)));
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,4002,input(&w,1,t::Input::Leave)),Some(t::ServerMessage::SessionRejected(_))));
 assert_eq!(g.players.len(),1);assert!(h.forbids_legacy(peer(10001)));
 let replay=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10002,4003,t::ClientMessage::Resume(resume)));
 assert_eq!(replay.context,new.context);assert_eq!(replay.access_key,new.access_key);assert_eq!(g.players.len(),1);
}
#[test] fn actual_clock_ack_freshness_does_not_extend_endpoint_on_replays(){
 let(mut g,mut d,mut p,mut k)=(game(),Delivery::default(),Pause::default(),Keys(80));let mut h=Host::new(g.session).unwrap();
 p.request(99,true,time(0),&mut d).unwrap();
 let w=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,0,t::ClientMessage::JoinResumable(request(1))));
 assert_eq!(w.bootstrap,t::ClockBootstrap::Paused{through_ordinal:1});assert_eq!(d.pending(w.context.player).count(),1);
 assert!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,1,input(&w,1,t::Input::ClockAck{ordinal:1})).is_none());
 assert_eq!(d.pending(w.context.player).count(),0);
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,29,input(&w,2,t::Input::ClockAck{ordinal:1})),Some(t::ServerMessage::SessionRejected(_))));
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,30,input(&w,1,t::Input::Heartbeat)),Some(t::ServerMessage::SessionRejected(_))));
 h.poll(time(32),false,&mut g,&mut d).unwrap();assert!(h.routes.is_empty());assert_eq!(h.participants(),1);assert_eq!(g.players.len(),1);
}
#[test] fn owner_drain_retires_offline_but_waits_for_authenticated_active_leave(){
 let(mut g,mut d,mut p,mut k)=(game(),Delivery::default(),Pause::default(),Keys(80));let mut h=Host::new(g.session).unwrap();
 let a=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,0,t::ClientMessage::JoinResumable(request(1))));
 let b=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10002,0,t::ClientMessage::JoinResumable(request(2))));
 send(&mut h,&mut g,&mut d,&mut p,&mut k,10002,20,input(&b,1,t::Input::Heartbeat));
 h.poll(time(31),true,&mut g,&mut d).unwrap();assert!(!g.players.contains_key(&a.context.player));assert!(g.players.contains_key(&b.context.player));assert_eq!(h.participants(),1);
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10003,32,t::ClientMessage::JoinResumable(request(3))),Some(t::ServerMessage::SessionRejected(t::Rejection{reason:t::RejectionCode::Closing,..}))));
 send(&mut h,&mut g,&mut d,&mut p,&mut k,10002,33,input(&b,2,t::Input::Leave));assert_eq!(h.participants(),0);assert!(g.players.is_empty());assert!(h.routes.is_empty());assert_eq!(d.issued(b.context.player),None);
 h.poll(time(34),true,&mut g,&mut d).unwrap();assert!(g.players.is_empty());
}
#[test] fn same_tick_states_use_new_frame_and_failed_join_never_adds_a_route_or_player(){
 let(mut g,mut d,mut p,mut k)=(game(),Delivery::default(),Pause::default(),Keys(80));let mut h=Host::new(g.session).unwrap();
 let mut bad=request(3);bad.champion="invalid champion".into();
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10003,0,t::ClientMessage::JoinResumable(bad)),Some(t::ServerMessage::SessionRejected(_))));
 assert!(g.players.is_empty());assert_eq!(h.participants(),0);assert!(h.routes.is_empty());
 let w=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,1,t::ClientMessage::JoinResumable(request(1))));
 fn decode(packets:Vec<Vec<u8>>,context:t::Context)->t::StateEnvelope{
  let mut a=session_wire::Assembler::new(context).unwrap();let mut done=None;
  for p in packets{if let Some(frame)=a.push(&p).unwrap(){done=Some(frame.decode().unwrap());}}done.unwrap()
 }
 let one=decode(h.states(&g,&d).unwrap().remove(0).1,w.context);g.join("annie").unwrap();
 let two=decode(h.states(&g,&d).unwrap().remove(0).1,w.context);
 assert_eq!(one.snapshot.tick,two.snapshot.tick);assert_eq!(one.frame_ordinal,1);assert_eq!(two.frame_ordinal,2);
 assert_eq!(one.snapshot.roster.len(),1);assert_eq!(two.snapshot.roster.len(),2);
}


#[test]
fn checked_swap_rejection_consumes_sequence_then_fresh_authoritative_retry_succeeds() {
 let(mut g,mut d,mut p,mut k)=(game(),Delivery::default(),Pause::default(),Keys(80));g.enable_map10().unwrap();
 let mut h=Host::new(g.session).unwrap();
 let w=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,0,t::ClientMessage::JoinResumable(request(1))));
 let id=w.context.player;
 for item in [1001,2003,2003] {g.command(id,openleague_core::Action::Buy{item}).unwrap();}
 let captured_inventory=g.players[&id].inventory;let captured_counts=g.players[&id].inventory_counts;
 let action=openleague_core::Action::SwapItemsChecked{from:1,to:5,expected_inventory:captured_inventory,expected_counts:captured_counts};
 g.command(id,openleague_core::Action::Buy{item:2003}).unwrap();
 let before=serde_json::to_value(&g.players[&id]).unwrap();
 // Exercise the actual secure serde envelope as well as Host/Registry/Simulation.
 let encoded=serde_json::to_vec(&input(&w,1,t::Input::Command(action.clone()))).unwrap();assert!(encoded.len()<4096);
 let decoded=serde_json::from_slice(&encoded).unwrap();
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,1,decoded),
  Some(t::ServerMessage::SessionGameplayRejected(t::GameplayRejection{context,sequence:1,reason})) if context==w.context && reason=="inventory changed"));
 assert_eq!(serde_json::to_value(&g.players[&id]).unwrap(),before);
 // Restore exactly the original counts via a real sale; stale sequence is still rejected.
 g.command(id,openleague_core::Action::Sell{slot:1}).unwrap();
 assert_eq!(g.players[&id].inventory_counts,captured_counts);
 let before=serde_json::to_value(&g.players[&id]).unwrap();
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,2,input(&w,1,t::Input::Command(action.clone()))),
  Some(t::ServerMessage::SessionRejected(t::Rejection{reason:t::RejectionCode::StaleSequence,..}))));
 assert_eq!(serde_json::to_value(&g.players[&id]).unwrap(),before);
 assert!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,3,input(&w,2,t::Input::Command(action.clone()))).is_none());
 assert_eq!(g.players[&id].inventory[5],Some(2003));assert_eq!(g.players[&id].inventory_counts[5],2);
 let after=serde_json::to_value(&g.players[&id]).unwrap();
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,4,input(&w,2,t::Input::Command(action))),
  Some(t::ServerMessage::SessionRejected(t::Rejection{reason:t::RejectionCode::StaleSequence,..}))));
 assert_eq!(serde_json::to_value(&g.players[&id]).unwrap(),after);
}

#[test]
fn checked_swap_still_requires_session_authority_and_unpaused_gameplay() {
 let(mut g,mut d,mut p,mut k)=(game(),Delivery::default(),Pause::default(),Keys(80));g.enable_map10().unwrap();
 let mut h=Host::new(g.session).unwrap();
 let w=welcome(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,0,t::ClientMessage::JoinResumable(request(1))));
 let id=w.context.player;g.command(id,openleague_core::Action::Buy{item:1001}).unwrap();
 let action=openleague_core::Action::SwapItemsChecked{from:0,to:5,expected_inventory:g.players[&id].inventory,expected_counts:g.players[&id].inventory_counts};
 let before=serde_json::to_value(&g.players[&id]).unwrap();
 let mut unauthorized=input(&w,1,t::Input::Command(action.clone()));
 let t::ClientMessage::Session(ref mut request)=unauthorized else {unreachable!()};request.access_key=key(254);
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,1,unauthorized),
  Some(t::ServerMessage::SessionRejected(t::Rejection{reason:t::RejectionCode::Unauthorized,..}))));
 assert_eq!(serde_json::to_value(&g.players[&id]).unwrap(),before);
 p.request(id,true,time(2),&mut d).unwrap();
 assert!(matches!(send(&mut h,&mut g,&mut d,&mut p,&mut k,10001,3,input(&w,1,t::Input::Command(action))),
  Some(t::ServerMessage::SessionGameplayRejected(t::GameplayRejection{sequence:1,reason,..})) if reason=="match is paused"));
 assert_eq!(serde_json::to_value(&g.players[&id]).unwrap(),before);
}
