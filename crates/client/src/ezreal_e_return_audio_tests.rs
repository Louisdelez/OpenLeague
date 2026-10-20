use super::*;
use bevy::{audio::{Decodable,Source},ecs::system::SystemState};
use openleague_core::{Action,Navigation,Point,Simulation,session_transport::Context,ezreal_e_accepted_releases::{Phase,POLICY}};
fn game()->(Simulation,u32){
    let mut cells=Vec::new();for _ in 0..6400{cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
    let mut g=Simulation::new(nav).unwrap();g.session=7;let o=g.join("ezreal").unwrap();let p=g.players.get_mut(&o).unwrap();
    p.position=Point{x:200.,z:300.};p.level=6;p.ranks=[0,0,1,0];p.mana=2000.;(g,o)
}
fn baseline(g:&Simulation,o:u32)->State {let mut c=State::default();c.begin_epoch(g.session,9,o);observe(&mut c,&g.snapshot_for_atomic(o).unwrap(),1.,1);c}
fn observe(c:&mut State,s:&Snapshot,now:f64,frame:u64) {let(session,epoch,player)=c.context().unwrap();c.observe_accepted_frame(s,now,true,false,Some((Context{session,epoch,player},frame))).unwrap();}
fn arrival(g:&mut Simulation,o:u32)->Snapshot {g.command(o,Action::CastAt{slot:2,point:Point{x:500.,z:300.}}).unwrap();for _ in 0..8{g.advance();}let s=g.snapshot_for_atomic(o).unwrap();
    assert_eq!(openleague_core::ezreal_e_accepted_releases::decode_view(s.ezreal_e_accepted_releases.as_ref(),s.tick).unwrap().unwrap().iter().filter(|e|e.phase==Phase::Arrival).count(),1);s}
fn world()->(World,Handle<PcmAudio>){let mut world=World::new();let mut assets=Assets::<PcmAudio>::default();
    let h=assets.add(decode(include_bytes!("../../../assets/audio/champions/ezreal/e_return/452186853.wav")).unwrap());
    world.insert_resource(Catalogue{sources:std::array::from_fn(|_|Some(h.clone()))});world.insert_resource(assets);(world,h)}
fn frame(w:&mut World,c:&mut State,s:Option<&Snapshot>,f:Frame){
    let mut system=SystemState::<(Commands,Res<Catalogue>,Res<Assets<PcmAudio>>,Query<(Entity,&mut Voice,Option<&AudioSink>)>)>::new(w);
    let(mut commands,catalogue,assets,mut voices)=system.get_mut(w).unwrap();present(&mut commands,c,s,f,&catalogue,&assets,&mut voices);system.apply(w);
}
#[test]
fn exact_three_full_pcm_files_decode_all_frames_with_bounded_metadata(){
    let bytes:[&[u8];3]=[include_bytes!("../../../assets/audio/champions/ezreal/e_return/452186853.wav"),
        include_bytes!("../../../assets/audio/champions/ezreal/e_return/271942249.wav"),include_bytes!("../../../assets/audio/champions/ezreal/e_return/196438317.wav")];
    assert_ne!(bytes[0],bytes[1]);assert_ne!(bytes[1],bytes[2]);
    for wav in bytes {assert_eq!(wav.len(),WAV_BYTES);let pcm=decode(wav).unwrap();let mut d=pcm.decoder();
        assert_eq!(d.channels().get(),1);assert_eq!(d.sample_rate().get(),44100);assert_eq!(d.by_ref().count(),119803);assert_eq!(d.next(),None);
        assert!(decode(&wav[..wav.len()-2]).is_err());let mut bad=wav.to_vec();bad[24..28].copy_from_slice(&22050u32.to_le_bytes());assert!(decode(&bad).is_err());}
    assert!(decode(&vec![0;WAV_BYTES+1]).is_err());let mut a=Assets::<PcmAudio>::default();assert!(populate(&mut a,|_|Err(())).sources.iter().all(Option::is_none));
    assert_eq!(NATIVE_EVENT_ID,4134030092);assert_eq!(NATIVE_EVENT_NAME,"Play_sfx_Ezreal_EzrealArcaneShift_return");
    assert_eq!(crate::ezreal_e_return_audio_state::POLICY,"local_e_arrival_return_audio_v1");
}
#[test]
fn real_targetless_arrival_spawns_one_nonspatial_voice_and_pause_never_replays(){
    let(mut g,o)=game();let mut c=baseline(&g,o);let s=arrival(&mut g,o);observe(&mut c,&s,1.01,2);
    let(mut w,h)=world();let foreign=w.spawn((AudioPlayer::<PcmAudio>(h),PlaybackSettings::ONCE)).id();
    let f=Frame{now:1.01,ready:true,paused:false};frame(&mut w,&mut c,Some(&s),f);
    let settings=w.query::<(&Voice,&PlaybackSettings)>().iter(&w).map(|(_,s)|*s).collect::<Vec<_>>();assert_eq!(settings.len(),1);
    assert_eq!(settings[0].volume,Volume::Linear(0.10));assert_eq!(settings[0].speed,1.);assert!(!settings[0].spatial);
    frame(&mut w,&mut c,Some(&s),Frame{paused:true,..f});assert_eq!(w.query::<&Voice>().iter(&w).count(),0);
    observe(&mut c,&s,1.02,3);frame(&mut w,&mut c,Some(&s),Frame{now:1.02,..f});assert_eq!(w.query::<&Voice>().iter(&w).count(),0);
    assert!(w.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
}
#[test]
fn capacity_and_missing_assets_consume_requests_without_retry_or_foreign_cleanup(){
    for absent in [false,true] {let(g,o)=game();let mut c=baseline(&g,o);let mut s=g.snapshot_for_atomic(o).unwrap();s.tick=1;
        s.ezreal_e_accepted_releases=Some(serde_json::json!({"policy":POLICY,"events":(1..=3).map(|order|serde_json::json!({"owner":o,"order":order,"tick":1,"phase":"arrival","position":{"x":500.,"z":300.}})).collect::<Vec<_>>()}));
        observe(&mut c,&s,1.01,2);let(mut w,h)=world();let foreign=w.spawn((AudioPlayer::<PcmAudio>(h.clone()),PlaybackSettings::ONCE)).id();
        if absent {w.resource_mut::<Catalogue>().sources=Default::default();}
        let f=Frame{now:1.01,ready:true,paused:false};frame(&mut w,&mut c,Some(&s),f);assert_eq!(w.query::<&Voice>().iter(&w).count(),if absent{0}else{2});
        // Returning the asset cannot retry the consumed third or missing requests.
        w.resource_mut::<Catalogue>().sources=std::array::from_fn(|_|Some(h.clone()));observe(&mut c,&s,1.02,3);
        frame(&mut w,&mut c,Some(&s),Frame{now:1.02,..f});assert_eq!(w.query::<&Voice>().iter(&w).count(),if absent{0}else{2});
        w.resource_mut::<Assets<PcmAudio>>().remove(h.id());frame(&mut w,&mut c,Some(&s),Frame{now:1.03,..f});assert_eq!(w.query::<&Voice>().iter(&w).count(),0);
        assert!(w.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
    }
}
#[test]
fn readiness_authority_loss_and_clock_failure_retire_only_owned_voices(){
    for mode in 0..4 {let(mut g,o)=game();let mut c=baseline(&g,o);let mut s=arrival(&mut g,o);observe(&mut c,&s,1.01,2);
        let(mut w,h)=world();let foreign=w.spawn((AudioPlayer::<PcmAudio>(h),PlaybackSettings::ONCE)).id();let f=Frame{now:1.01,ready:true,paused:false};
        frame(&mut w,&mut c,Some(&s),f);assert_eq!(w.query::<&Voice>().iter(&w).count(),1);
        let broken=match mode{0=>Frame{ready:false,..f},1=>{s.ezreal_e_accepted_releases=None;observe(&mut c,&s,1.02,3);Frame{now:1.02,..f}},2=>Frame{now:f64::NAN,..f},_=>{c.begin_epoch(7,10,o);f}};
        frame(&mut w,&mut c,Some(&s),broken);assert_eq!(w.query::<&Voice>().iter(&w).count(),0);assert!(w.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
    }
}
#[test]
fn explicit_sink_watchdog_allows_full_media_and_stays_below_authorization_horizon(){
    assert!(MAX_VOICE_SECONDS+crate::ezreal_e_return_audio_state::MAX_DELAY < openleague_core::ezreal_e_accepted_releases::HORIZON as f64/openleague_core::TICK_RATE as f64);
    let mut v=Lifetime{birth:0.,observed_start:None};assert!(!v.expired(FIRST_SINK_WAIT,Some(false)));
    assert!(!v.expired(FIRST_SINK_WAIT+DURATION,Some(false)));assert!(v.expired(MAX_VOICE_SECONDS,Some(false)));
    let mut missing=Lifetime{birth:1.,observed_start:None};assert!(!missing.expired(1.24,None));assert!(missing.expired(1.26,None));
    let mut late=Lifetime{birth:1.,observed_start:None};assert!(late.expired(1.26,Some(false)));
    let mut ended=Lifetime{birth:1.,observed_start:Some(1.01)};assert!(ended.expired(1.02,Some(true)));
    let mut lost=Lifetime{birth:1.,observed_start:Some(1.01)};assert!(lost.expired(1.02,None));
}
