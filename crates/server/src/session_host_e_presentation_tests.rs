use super::*;
use openleague_core::{Action,Point,Snapshot,ezreal_e_accepted_releases as releases,ezreal_e_projectile_view as bolts};
fn game()->Simulation {
    let mut bytes=Vec::new();for _ in 0..(160*120){bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":100,"width":160,"height":120}"#,&bytes).unwrap();
    let mut game=Simulation::new(nav).unwrap();game.session=u64::MAX-7;game.enable_map10().unwrap();
    game.enable_map10_cast_ground().unwrap();game.units.clear();game
}
fn setup(game:&mut Simulation,owner:u32) {
    let target=game.join("garen").unwrap();
    for (id,x) in [(owner,5000.),(target,5900.)]{let p=game.players.get_mut(&id).unwrap();p.position=Point{x,z:7300.};p.health=10000.;p.max_health=10000.;}
    let p=game.players.get_mut(&owner).unwrap();p.level=3;p.ranks[2]=1;p.mana=2000.;
}
fn action()->Action {Action::CastAt{slot:2,point:Point{x:5475.,z:7300.}}}
fn decode(packets:&[Vec<u8>],ctx:t::Context)->t::StateEnvelope {
    let mut a=session_wire::Assembler::new(ctx).unwrap();let mut done=None;
    for p in packets{if let Some(frame)=a.push(p).unwrap(){done=Some(frame.decode().unwrap());}}done.unwrap()
}
struct Keys;
impl r::Entropy for Keys {fn access_key(&mut self)->Result<t::Secret32,r::EntropyUnavailable>{Ok(t::Secret32::from_bytes([80;32]).unwrap())}}
fn successful()->(Simulation,u32,t::Context,Snapshot) {
    let mut game=game();let owner=game.join("ezreal").unwrap();setup(&mut game,owner);
    game.command(owner,action()).unwrap();for _ in 0..8{game.advance();}
    let snapshot=game.snapshot_for_atomic(owner).unwrap();
    assert_eq!(releases::decode_view(snapshot.ezreal_e_accepted_releases.as_ref(),snapshot.tick).unwrap().unwrap().len(),2);
    assert_eq!(bolts::decode(snapshot.ezreal_e_current_bolts.as_ref().unwrap()).unwrap().len(),1);
    let context=t::Context{session:game.session,player:owner,epoch:(1u64<<53)+7};(game,owner,context,snapshot)
}
#[test]
fn actual_resumable_host_transports_successful_e_phases_and_bolt_with_pause_provenance() {
    let mut game=game();let mut host=Host::new(game.session).unwrap();let(mut delivery,mut pause)=(Delivery::default(),Pause::default());
    let peer:SocketAddr=([127,0,0,1],10021).into();
    let request=t::JoinRequest{version:t::VERSION,champion:"ezreal".into(),summoners:[None,None],
        recovery_key:t::Secret32::from_bytes([1;32]).unwrap(),request_nonce:t::RequestNonce([1;16])};
    let response=host.handle(t::ClientMessage::JoinResumable(request),peer,false,&mut game,&mut delivery,&mut pause,Duration::ZERO,true,&mut Keys).unwrap();
    let Some(t::ServerMessage::SessionWelcome(w))=response else{panic!("Welcome required")};let owner=w.context.player;setup(&mut game,owner);
    let command=t::ClientMessage::Session(t::SessionInput{version:t::VERSION,context:w.context,access_key:w.access_key,sequence:1,input:t::Input::Command(action())});
    assert!(host.handle(command,peer,false,&mut game,&mut delivery,&mut pause,Duration::ZERO,true,&mut Keys).unwrap().is_none());
    let pending=decode(&host.states(&game,&delivery).unwrap()[0].1,w.context);
    assert!(pending.snapshot.ezreal_e_current_bolts.is_none());
    assert!(releases::decode_view(pending.snapshot.ezreal_e_accepted_releases.as_ref(),0).unwrap().unwrap().is_empty());
    for _ in 0..8{game.advance();}
    let current=decode(&host.states(&game,&delivery).unwrap()[0].1,w.context);
    assert_eq!((current.context,current.frame_ordinal,current.snapshot.tick,current.clock_ordinal),(w.context,2,8,0));
    assert_eq!(current.snapshot.session,u64::MAX-7);
    assert_eq!(releases::decode_view(current.snapshot.ezreal_e_accepted_releases.as_ref(),8).unwrap().unwrap().len(),2);
    assert_eq!(bolts::decode(current.snapshot.ezreal_e_current_bolts.as_ref().unwrap()).unwrap()[0].position,Point{x:5475.,z:7300.});
    pause.request(owner,true,Duration::ZERO,&mut delivery).unwrap();assert!(pause.is_paused());
    let paused=decode(&host.states(&game,&delivery).unwrap()[0].1,w.context);
    assert_eq!(paused.snapshot.tick,8);assert!(paused.clock_ordinal>current.clock_ordinal);
    assert_eq!(paused.snapshot.ezreal_e_accepted_releases,current.snapshot.ezreal_e_accepted_releases);
    assert_eq!(paused.snapshot.ezreal_e_current_bolts,current.snapshot.ezreal_e_current_bolts);
    // Clock provenance is carried, not interpreted as client playback permission here.
    let legacy=game.snapshot_for(owner).unwrap();assert!(legacy.ezreal_e_current_bolts.is_none());assert!(legacy.ezreal_e_accepted_releases.is_none());
}
#[test]
fn e_optional_overflow_omits_whole_channels_without_spending_an_extra_frame_ordinal() {
    let(game,owner,ctx,ordinary)=successful();let before=serde_json::to_value(game.snapshot()).unwrap();
    for release in [false,true] {
        let mut oversized=ordinary.clone();let invalid=Some(serde_json::json!("x".repeat(session_wire::MAX_FRAME)));
        if release{oversized.ezreal_e_accepted_releases=invalid;}else{oversized.ezreal_e_current_bolts=invalid;}
        let mut sender=session_wire::Sender::new(ctx).unwrap();let fallback=decode(&current_state_packets(&mut sender,oversized,19).unwrap(),ctx);
        assert_eq!((fallback.frame_ordinal,fallback.clock_ordinal),(1,19));
        let mut expected=ordinary.clone();expected.ezreal_e_accepted_releases=None;expected.ezreal_e_current_bolts=None;
        expected.ezreal_r_current_heights=None;expected.ezreal_r_accepted_impacts=None;expected.ezreal_r_accepted_casts=None;
        expected.ezreal_w_current_missiles=None;expected.ezreal_w_casts.clear();expected.ezreal_e_casts.clear();
        assert_eq!(serde_json::to_value(fallback.snapshot).unwrap(),serde_json::to_value(expected).unwrap());
        let next=decode(&current_state_packets(&mut sender,ordinary.clone(),19).unwrap(),ctx);assert_eq!(next.frame_ordinal,2);
        // OLSR parses JSON once. Value stores f64, while the E row contract is f32.
        // Preserve exact row values/bits and compare the whole snapshot at the same wire stage.
        let received_rows=bolts::decode(next.snapshot.ezreal_e_current_bolts.as_ref().unwrap()).unwrap();
        let expected_rows=bolts::decode(ordinary.ezreal_e_current_bolts.as_ref().unwrap()).unwrap();
        assert_eq!(received_rows,expected_rows);
        assert_eq!(received_rows.iter().map(|r|r.y_native.to_bits()).collect::<Vec<_>>(),
            expected_rows.iter().map(|r|r.y_native.to_bits()).collect::<Vec<_>>());
        let expected_wire:Snapshot=serde_json::from_slice(&serde_json::to_vec(&ordinary).unwrap()).unwrap();
        assert_eq!(serde_json::to_value(next.snapshot).unwrap(),serde_json::to_value(expected_wire).unwrap());
        let mut too_big=ordinary.clone();too_big.attack_presentation_error=Some("x".repeat(session_wire::MAX_FRAME));
        assert!(current_state_packets(&mut sender,too_big,19).is_err());
        assert_eq!(decode(&current_state_packets(&mut sender,ordinary.clone(),19).unwrap(),ctx).frame_ordinal,3);
    }
    assert_eq!(serde_json::to_value(game.snapshot()).unwrap(),before);assert!(game.snapshot_for(owner).unwrap().ezreal_e_current_bolts.is_none());
}
#[test]
fn actual_e_frame_reordering_conflict_and_epoch_mismatch_never_mix_phase_and_current_rows() {
    let(mut game,owner,ctx,first)=successful();let mut sender=session_wire::Sender::new(ctx).unwrap();
    let old=current_state_packets(&mut sender,first.clone(),0).unwrap();game.advance();
    let second=game.snapshot_for_atomic(owner).unwrap();assert_ne!(second.ezreal_e_current_bolts,first.ezreal_e_current_bolts);
    let new=current_state_packets(&mut sender,second.clone(),1).unwrap();assert!(old.len()>1 && new.len()>1);
    let mut assembler=session_wire::Assembler::new(ctx).unwrap();assert!(assembler.push(&old[0]).unwrap().is_none());
    assert!(assembler.push(&new[0]).unwrap().is_none());
    for packet in &old[1..]{assert!(matches!(assembler.push(packet),Err(session_wire::Error::Stale)));}
    let mut done=None;for packet in new[1..].iter().rev(){if let Some(f)=assembler.push(packet).unwrap(){done=Some(f.decode().unwrap());}}
    let received=done.unwrap();assert_eq!((received.context,received.frame_ordinal,received.snapshot.tick,received.clock_ordinal),(ctx,2,9,1));
    assert_eq!(received.snapshot.ezreal_e_current_bolts,second.ezreal_e_current_bolts);
    assert_eq!(received.snapshot.ezreal_e_accepted_releases,second.ezreal_e_accepted_releases);
    let third=current_state_packets(&mut sender,second,1).unwrap();assert!(assembler.push(&third[0]).unwrap().is_none());
    let mut conflict=third[0].clone();*conflict.last_mut().unwrap()^=1;
    assert!(matches!(assembler.push(&conflict),Err(session_wire::Error::ConflictingFragment)));
    let mut wrong=session_wire::Assembler::new(t::Context{epoch:ctx.epoch+1,..ctx}).unwrap();
    assert!(wrong.push(&new[0]).is_err());
}
