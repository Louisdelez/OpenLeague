//! Optional base-R OnCast PCM consumer. Native resources, locally reconstructed mix.
//! No Wwise routing, native random/attenuation, audible completion or skin parity.
use bevy::{prelude::*,audio::{AudioPlayer,AudioSink,AudioSinkPlayback,PlaybackSettings,Volume}};
use openleague_core::{audio_media,Point,Snapshot};
use std::{collections::HashMap,io::Read,num::NonZeroU16,sync::Arc};
use crate::{ezreal_r_cast_audio_state::{Identity,Request,State},pcm_audio::PcmAudio};
use crate::ezreal_r_cast_audio_diagnostics::{self as diagnostic, Code, FirstSink};

const MAX_VOICES:usize=6;
const MAX_WAV_BYTES:u64=384*1024;
const ASSET_WAIT_SECONDS:f64=0.1;
const ACTIVE_WATCHDOG_MARGIN:f64=0.25;
const MAX_VOICE_SECONDS:f64=4.25;
const LOCAL_GAIN:f32=0.20;
const LOCAL_MAX_DISTANCE:f32=2400.;
pub const NATIVE_EVENT_ID:u32=11343558;
pub const NATIVE_EVENT_NAME:&str="Play_sfx_Ezreal_EzrealTrueshotBarrage_OnCast";
// These are decoded native base media; no Pulse/other-skin substitution.
const MEDIA:[(&str,usize);3]=[
    ("audio/champions/ezreal/r_cast/848418412.wav",156187),
    ("audio/champions/ezreal/r_cast/468723580.wav",155268),
    ("audio/champions/ezreal/r_cast/558467253.wav",165375),
];

#[derive(Resource,Default)]
pub(crate) struct Catalogue { sources:[Option<Handle<PcmAudio>>;3], errors:[Option<String>;3] }
fn decode(bytes:&[u8],frames:usize)->Result<PcmAudio,String> {
    if bytes.len() as u64>MAX_WAV_BYTES {return Err("R OnCast WAV exceeds local byte budget".into());}
    let pcm=audio_media::decode(bytes).map_err(|error|format!("R OnCast PCM decode: {error:?}"))?;
    if pcm.sample_rate!=44100 || pcm.channels!=1 || pcm.frames()!=frames {
        return Err("R OnCast PCM differs from recovered base resource metadata".into());
    }
    PcmAudio::new(Arc::new(pcm),NonZeroU16::new(1).unwrap()).map_err(|error|format!("R OnCast one-shot PCM: {error:?}"))
}
fn populate(assets:&mut Assets<PcmAudio>,mut read:impl FnMut(&str)->Result<Vec<u8>,String>)->Catalogue {
    let mut result=Catalogue::default();
    for (index,(path,frames)) in MEDIA.iter().enumerate() {
        match read(path).and_then(|bytes|decode(&bytes,*frames)) {
            Ok(source)=>result.sources[index]=Some(assets.add(source)),
            Err(error)=>result.errors[index]=Some(error),
        }
    }
    result
}
fn load(mut assets:ResMut<Assets<PcmAudio>>,mut catalogue:ResMut<Catalogue>) {
    let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets");
    *catalogue=populate(&mut assets,|relative| {
        let file=std::fs::File::open(root.join(relative)).map_err(|error|error.to_string())?;
        let mut bytes=Vec::new();file.take(MAX_WAV_BYTES+1).read_to_end(&mut bytes).map_err(|error|error.to_string())?;
        Ok(bytes)
    });
    for error in catalogue.errors.iter().flatten() {warn!("Optional Ezreal R OnCast audio unavailable: {error}");}
}

/// Deterministic local variation, not recovered CAkRanSeqCntr shuffle/RNG state.
fn variant(identity:Identity)->usize {
    let value=identity.session.rotate_left(17)^identity.epoch.rotate_left(29)
        ^u64::from(identity.owner).wrapping_mul(0x9e3779b97f4a7c15)^identity.order.wrapping_mul(0xbf58476d1ce4e5b9)^identity.ordinal.rotate_left(41);
    (value.wrapping_mul(0x94d049bb133111eb)%3) as usize
}
/// Camera-focus distance only; no native bus, stereo pan, falloff or LPF claim.
fn gain(position:Point,listener:Option<[f32;3]>)->Option<f32> {
    let listener=listener.filter(|p|p.iter().all(|value|value.is_finite()))?;
    if !position.finite() {return None;}
    let distance=(position.x-listener[0]).hypot(position.z-listener[2]);
    if !distance.is_finite() {return None;}
    let gain=LOCAL_GAIN*(1.-distance/LOCAL_MAX_DISTANCE).clamp(0.,1.);
    (gain>0.).then_some(gain)
}

#[derive(Component)]
pub(crate) struct Voice {
    identity:Identity, viewer:u32, position:Point, owner_entity:Entity, request:Request, lifetime:Lifetime,
    first_sink:FirstSink,
}
/// Sink creation is asynchronous. This is a bounded local transport watchdog,
/// not a native EndOfEvent or proof of hardware-audible completion.
#[derive(Clone,Copy,Debug)]
struct Lifetime { birth:f64, observed_start:Option<f64>, duration:f64 }
impl Lifetime {
    fn expired(&mut self,now:f64,sink_empty:Option<bool>)->bool {
        if !now.is_finite() || !self.duration.is_finite() || self.duration<=0.
            || self.duration>3.75 || now<self.birth || now-self.birth>=MAX_VOICE_SECONDS {return true;}
        match sink_empty {
            None=>self.observed_start.is_some() || now-self.birth>ASSET_WAIT_SECONDS,
            Some(true)=>true,
            Some(false)=>{
                if self.observed_start.is_none() && now-self.birth>ASSET_WAIT_SECONDS {return true;}
                let start=*self.observed_start.get_or_insert(now);
                now<start || now-start>self.duration+ACTIVE_WATCHDOG_MARGIN
            }
        }
    }
}
// Observation only: never called to decide expiry or mutate Lifetime. Tests
// compare this classifier against the unchanged expiry function at boundaries.
fn lifetime_reason(before:Lifetime,now:f64,sink_empty:Option<bool>)->Option<Code> {
    if !now.is_finite() || !before.duration.is_finite() || before.duration<=0.
        || before.duration>3.75 || now<before.birth {return Some(Code::RetireClockOrDuration);}
    if now-before.birth>=MAX_VOICE_SECONDS {return Some(Code::RetireHardLimit);}
    match sink_empty {
        None if before.observed_start.is_some()=>Some(Code::RetireSinkLost),
        None if now-before.birth>ASSET_WAIT_SECONDS=>Some(Code::RetireInitialSinkTimeout),
        None=>None,
        Some(true)=>Some(Code::RetireSinkEmpty),
        Some(false)=>{
            if before.observed_start.is_none() && now-before.birth>ASSET_WAIT_SECONDS {return Some(Code::RetireFirstSinkLate);}
            let start=before.observed_start.unwrap_or(now);
            if now<start {Some(Code::RetireClockOrDuration)}
            else if now-start>before.duration+ACTIVE_WATCHDOG_MARGIN {Some(Code::RetireActiveWatchdog)}
            else {None}
        }
    }
}
// Called only after gain returned None. Same expression, no gain override.
fn gain_is_zero(position:Point,listener:Option<[f32;3]>)->bool {
    let Some(listener)=listener.filter(|p|p.iter().all(|v|v.is_finite())) else{return false;};
    if !position.finite() {return false;}
    let distance=(position.x-listener[0]).hypot(position.z-listener[2]);
    distance.is_finite() && LOCAL_GAIN*(1.-distance/LOCAL_MAX_DISTANCE).clamp(0.,1.)==0.
}
#[derive(Clone,Copy)]
struct Frame { now:f64, ready:bool, paused:bool, listener:Option<[f32;3]> }
fn present(
    commands:&mut Commands,channel:&mut State,snapshot:Option<&Snapshot>,owners:&HashMap<u32,Entity>,frame:Frame,
    catalogue:&Catalogue,assets:&Assets<PcmAudio>,
    voices:&mut Query<(Entity,&mut Voice,&mut PlaybackSettings,Option<&mut AudioSink>)>,
) {
    let context=channel.context();
    let usable=frame.ready && !frame.paused && channel.presentation_ready(frame.now) && snapshot.is_some_and(|snapshot|
        context.is_some_and(|(session,_,_)|session==snapshot.session) && snapshot.winner.is_none() && snapshot.result.is_none());
    let visible=|owner:u32|snapshot.is_some_and(|snapshot|snapshot.players.iter().any(|actor|actor.id==owner && actor.champion=="ezreal" && actor.health.is_finite() && actor.health>0. && actor.position.finite()));
    let mut active=0;
    for (entity,mut voice,mut settings,sink) in voices.iter_mut() {
        let same_context=context==Some((voice.identity.session,voice.identity.epoch,voice.viewer));
        let level=gain(voice.position,frame.listener);
        // Sample the asynchronous sink exactly once, as before. The observer
        // is separate from Lifetime and cannot extend/retry/resume a voice.
        let sink_empty=sink.as_ref().map(|sink|sink.empty());
        let before=voice.lifetime;
        if let Some(code)=voice.first_sink.observe(frame.now-before.birth,sink_empty.is_some()) {diagnostic::record(code);}
        let expired=voice.lifetime.expired(frame.now,sink_empty);
        let retire=!usable || !same_context || !channel.authorizes(&voice.request) || !visible(voice.identity.owner)
            || owners.get(&voice.identity.owner)!=Some(&voice.owner_entity)
            || level.is_none() || expired;
        if retire {
            // If several conditions fail, report the first existing guard in
            // the same order; this is not an attribution of audible failure.
            let reason=if !frame.ready {Some(Code::RetireNotReady)}
                else if frame.paused {Some(Code::RetirePaused)}
                else if !channel.presentation_ready(frame.now) {Some(Code::RetireChannel)}
                else if !usable {Some(Code::RetireSnapshot)}
                else if !same_context {Some(Code::RetireContext)}
                else if !channel.authorizes(&voice.request) {Some(Code::RetireAuthorization)}
                else if !visible(voice.identity.owner) {Some(Code::RetireOwnerHidden)}
                else if owners.get(&voice.identity.owner)!=Some(&voice.owner_entity) {Some(Code::RetireOwnerChanged)}
                else if level.is_none() {Some(if gain_is_zero(voice.position,frame.listener) {Code::RetireGainZero}else{Code::RetireGainInvalid})}
                else {lifetime_reason(before,frame.now,sink_empty)};
            if let Some(code)=reason {diagnostic::record(code);}
            if let Some(sink)=sink {sink.stop();}
            commands.entity(entity).despawn();continue;
        }
        active+=1;settings.paused=false;settings.volume=Volume::Linear(level.unwrap());
        if let Some(mut sink)=sink {sink.set_volume(settings.volume);}
        // Pause retires this one-shot above; there is deliberately no resume. 
    }
    if !usable {
        if channel.has_pending() {diagnostic::record(if !frame.ready {Code::RequestNotReady}
            else if frame.paused {Code::RequestPaused}
            else if !channel.presentation_ready(frame.now) {Code::RequestChannel}else{Code::RequestSnapshot});}
        channel.suspend();return;
    }
    for request in channel.take(frame.now,frame.ready,frame.paused) {
        if active>=MAX_VOICES || !visible(request.identity.owner) {
            diagnostic::record(if active>=MAX_VOICES {Code::RequestCapacity}else{Code::RequestOwnerHidden});continue;
        }
        let Some(&owner_entity)=owners.get(&request.identity.owner) else {diagnostic::record(Code::RequestOwnerMissing);continue;};
        let index=variant(request.identity);
        let Some(handle)=catalogue.sources[index].as_ref().filter(|handle|assets.get(*handle).is_some()) else {diagnostic::record(Code::RequestAssetMissing);continue;};
        let Some(level)=gain(request.position,frame.listener) else {diagnostic::record(if gain_is_zero(request.position,frame.listener) {Code::GainZero}else{Code::GainInvalid});continue;};
        // AudioPlayer::new is hardcoded to Bevy AudioSource. The tuple is the
        // actual 0.19 API for this project's registered custom PCM source.
        commands.spawn((AudioPlayer::<PcmAudio>(handle.clone()),PlaybackSettings::ONCE.with_volume(Volume::Linear(level)),
            Voice { identity:request.identity,viewer:context.unwrap().2,position:request.position,owner_entity,
                request,lifetime:Lifetime {birth:frame.now,observed_start:None,duration:MEDIA[index].1 as f64/44100.},first_sink:FirstSink::default() }));
        diagnostic::record(Code::SpawnQueued);
        active+=1;
    }
}

/// Scheduled after receive and the existing camera listener update.
pub(crate) fn update(mut commands:Commands,mut state:ResMut<crate::Match>,clock:Res<crate::native_effect_clock::EffectClock>,
    connection:Res<crate::Connection>,
    listener:Res<crate::map_audio::NativeListener>,catalogue:Res<Catalogue>,assets:Res<Assets<PcmAudio>>,
    mut voices:Query<(Entity,&mut Voice,&mut PlaybackSettings,Option<&mut AudioSink>)>) {
    // receive can lose the connection after its entry guard. Recheck the
    // current link here before keeping or spawning any owned physical voice.
    let frame=Frame {now:clock.now,ready:connection.ready() && clock.presentation_ready(),paused:clock.paused(),listener:listener.position.current};
    let crate::Match {ezreal_r_cast_sounds,snapshot,visuals,..}=&mut *state;
    present(&mut commands,ezreal_r_cast_sounds,snapshot.as_ref(),visuals,frame,&catalogue,&assets,&mut voices);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Catalogue>().add_systems(Startup,load);}
}


#[cfg(test)]
mod tests {
    use super::*;
    use bevy::{audio::Decodable,ecs::system::SystemState};
    use openleague_core::{Action,Navigation,Simulation,session_transport::Context};
    fn game()->(Simulation,u32){
        let mut cells=Vec::new();for _ in 0..6400{cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=7;let owner=game.join("ezreal").unwrap();
        let actor=game.players.get_mut(&owner).unwrap();actor.position=Point{x:200.,z:300.};actor.level=6;actor.ranks[3]=1;actor.mana=2000.;(game,owner)
    }
    fn accepted(game:&mut Simulation,owner:u32)->Snapshot{
        game.command(owner,Action::CastAt{slot:3,point:Point{x:3000.,z:300.}}).unwrap();
        let snapshot=game.snapshot_for_atomic(owner).unwrap();assert_eq!(snapshot.ezreal_r_accepted_casts.as_ref().unwrap()["events"].as_array().unwrap().len(),1);snapshot
    }
    fn world()->(World,Handle<PcmAudio>,Entity){
        let mut world=World::new();let mut assets=Assets::<PcmAudio>::default();
        let handle=assets.add(decode(include_bytes!("../../../assets/audio/champions/ezreal/r_cast/558467253.wav"),165375).unwrap());
        world.insert_resource(Catalogue{sources:std::array::from_fn(|_|Some(handle.clone())),errors:Default::default()});world.insert_resource(assets);
        let owner=world.spawn_empty().id();(world,handle,owner)
    }
    fn frame(world:&mut World,channel:&mut State,snapshot:Option<&Snapshot>,owners:&HashMap<u32,Entity>,sample:Frame){
        let mut system=SystemState::<(Commands,Res<Catalogue>,Res<Assets<PcmAudio>>,Query<(Entity,&mut Voice,&mut PlaybackSettings,Option<&mut AudioSink>)>)>::new(world);
        let(mut commands,catalogue,assets,mut voices)=system.get_mut(world).unwrap();
        present(&mut commands,channel,snapshot,owners,sample,&catalogue,&assets,&mut voices);system.apply(world);
    }
    fn baseline(game:&Simulation,owner:u32)->State{
        let mut state=State::default();state.begin_epoch(7,9,owner);
        state.observe_accepted_frame(&game.snapshot_for_atomic(owner).unwrap(),1.,true,false,Some((Context{session:7,epoch:9,player:owner},1))).unwrap();state
    }
    fn observe(state:&mut State,snapshot:&Snapshot,now:f64,frame:u64){
        let(session,epoch,player)=state.context().unwrap();state.observe_accepted_frame(snapshot,now,true,false,Some((Context{session,epoch,player},frame))).unwrap();
    }
    #[test]
    fn all_three_long_native_oncast_pcm_fit_their_own_budget_and_decode_exact_frames(){
        let bytes:[&[u8];3]=[include_bytes!("../../../assets/audio/champions/ezreal/r_cast/848418412.wav"),
            include_bytes!("../../../assets/audio/champions/ezreal/r_cast/468723580.wav"),include_bytes!("../../../assets/audio/champions/ezreal/r_cast/558467253.wav")];
        for(index,wav)in bytes.iter().enumerate(){assert!(wav.len()>256*1024 && wav.len()<=MAX_WAV_BYTES as usize);
            let pcm=decode(wav,MEDIA[index].1).unwrap();let mut decoder=pcm.decoder();assert_eq!(decoder.by_ref().count(),MEDIA[index].1);assert_eq!(decoder.next(),None);
            assert!(MEDIA[index].1 as f64/44100.>3.);assert!(decode(wav,MEDIA[index].1+1).is_err());}
        assert!(decode(&[0;4],156187).is_err());assert!(decode(&vec![0;MAX_WAV_BYTES as usize+1],156187).is_err());
        let mut assets=Assets::<PcmAudio>::default();let absent=populate(&mut assets,|_|Err("missing".into()));
        assert!(absent.sources.iter().all(Option::is_none));assert!(absent.errors.iter().all(Option::is_some));
        assert_eq!(NATIVE_EVENT_ID,11343558);assert_eq!(NATIVE_EVENT_NAME,"Play_sfx_Ezreal_EzrealTrueshotBarrage_OnCast");
    }
    #[test]
    fn actual_accepted_cast_spawns_one_typed_voice_and_pause_retires_without_resume_or_foreign_cleanup(){
        let(mut game,owner)=game();let mut state=baseline(&game,owner);let snapshot=accepted(&mut game,owner);
        let(mut world,handle,entity)=world();let owners=HashMap::from([(owner,entity)]);
        let foreign=world.spawn((AudioPlayer::<PcmAudio>(handle.clone()),PlaybackSettings::ONCE)).id();
        observe(&mut state,&snapshot,1.01,2);let before=serde_json::to_value(&snapshot).unwrap();
        let sample=Frame{now:1.01,ready:true,paused:false,listener:Some([200.,0.,300.])};frame(&mut world,&mut state,Some(&snapshot),&owners,sample);
        let voice=world.query_filtered::<Entity,With<Voice>>().single(&world).unwrap();assert_eq!(world.get::<AudioPlayer<PcmAudio>>(voice).unwrap().0,handle);
        assert!(matches!(world.get::<PlaybackSettings>(voice).unwrap().mode,bevy::audio::PlaybackMode::Once));
        assert_eq!(world.get::<Voice>(voice).unwrap().identity.ordinal,1);
        // Pause can arrive after receive, without any new Snapshot. It is terminal
        // for this cue; the callback is not rescheduled at unpause.
        frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{paused:true,..sample});assert!(world.get::<Voice>(voice).is_none());
        assert!(world.get::<AudioPlayer<PcmAudio>>(foreign).is_some());frame(&mut world,&mut state,Some(&snapshot),&owners,sample);
        observe(&mut state,&snapshot,1.02,3);frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.02,..sample});
        assert_eq!(world.query::<&Voice>().iter(&world).count(),0);assert_eq!(serde_json::to_value(snapshot).unwrap(),before);
    }
    #[test]
    fn connection_fog_death_model_loss_or_authorization_gap_remove_only_oncast_without_replay(){
        for mode in 0..7{
            let(mut game,owner)=game();let mut state=baseline(&game,owner);let snapshot=accepted(&mut game,owner);
            let(mut world,handle,entity)=world();let mut owners=HashMap::from([(owner,entity)]);
            let foreign=world.spawn((AudioPlayer::<PcmAudio>(handle),PlaybackSettings::ONCE)).id();
            observe(&mut state,&snapshot,1.01,2);let sample=Frame{now:1.01,ready:true,paused:false,listener:Some([200.,0.,300.])};
            frame(&mut world,&mut state,Some(&snapshot),&owners,sample);let voice=world.query_filtered::<Entity,With<Voice>>().single(&world).unwrap();
            let mut broken=snapshot.clone();let mut use_snapshot=true;let mut ready=true;
            match mode{0=>ready=false,1=>broken.players.clear(),2=>broken.players[0].health=0.,3=>{owners.insert(owner,world.spawn_empty().id());},
                4=>use_snapshot=false,5=>{broken.ezreal_r_accepted_casts=None;observe(&mut state,&broken,1.01,3);observe(&mut state,&snapshot,1.01,4);},
                _=>{let _=state.observe_accepted_frame(&snapshot,1.01,true,false,None);observe(&mut state,&snapshot,1.01,4);}}
            frame(&mut world,&mut state,use_snapshot.then_some(&broken),&owners,Frame{ready,..sample});assert!(world.get::<Voice>(voice).is_none(),"mode{mode}");
            assert!(world.get::<AudioPlayer<PcmAudio>>(foreign).is_some());observe(&mut state,&snapshot,1.02,5);
            frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.02,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        }
    }
    #[test]
    fn missing_media_and_backend_consume_requests_instead_of_retrying_old_casts(){
        for missing_media in [false,true]{
            let(mut game,owner)=game();let mut state=baseline(&game,owner);let snapshot=accepted(&mut game,owner);
            let(mut world,_,entity)=world();let owners=HashMap::from([(owner,entity)]);let sources=world.resource::<Catalogue>().sources.clone();
            if missing_media{world.resource_mut::<Catalogue>().sources=Default::default();}
            observe(&mut state,&snapshot,1.01,2);let sample=Frame{now:1.01,ready:true,paused:false,listener:Some([200.,0.,300.])};
            frame(&mut world,&mut state,Some(&snapshot),&owners,sample);assert_eq!(world.query::<&Voice>().iter(&world).count(),usize::from(!missing_media));
            frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.12,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
            world.resource_mut::<Catalogue>().sources=sources;observe(&mut state,&snapshot,1.13,3);
            frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.13,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        }
    }
    #[test]
    fn real_projection_retains_authorization_for_full_long_pcm_without_late_birth(){
        let(mut game,owner)=game();let mut state=baseline(&game,owner);let initial=accepted(&mut game,owner);
        observe(&mut state,&initial,1.01,2);let request=state.take(1.01,true,false).pop().unwrap();
        // Actual CPU decoder, actual authoritative advance and projections. This
        // deliberately makes no AudioSink/hardware completion claim.
        let pcm=decode(include_bytes!("../../../assets/audio/champions/ezreal/r_cast/558467253.wav"),165375).unwrap();
        let mut decoder=pcm.decoder();let mut samples=0usize;
        let mut lifetime=Lifetime{birth:1.01,observed_start:None,duration:3.75};assert!(!lifetime.expired(1.01,Some(false)));
        for tick in 1..=150u64{
            game.advance();assert_eq!(game.tick,tick);let snapshot=game.snapshot_for_atomic(owner).unwrap();
            let now=1.01+tick as f64/30.;observe(&mut state,&snapshot,now,tick+2);
            assert!(state.take(now,true,false).is_empty(),"history/release cannot replay OnCast");
            assert_eq!(state.authorizes(&request),tick<150,"real retention at tick{tick}");
            if tick<=113{
                // 44100/30 exact CPU sample budget, final tick contains735 frames.
                let count=decoder.by_ref().take(1470).count();samples+=count;
                assert!(!lifetime.expired(now,Some(false)),"local watchdog cut long media at tick{tick}");
                if tick==60 || tick==90{assert_eq!(count,1470);assert!(state.authorizes(&request));}
            }
            if tick==100{
                let mut late=State::default();late.begin_epoch(7,10,owner);
                late.observe_accepted_frame(&snapshot,now,true,false,Some((Context{session:7,epoch:10,player:owner},1))).unwrap();
                assert!(late.take(now,true,false).is_empty(),"long retention never means late birth");
            }
        }
        assert_eq!(samples,165375);assert_eq!(decoder.next(),None);
        assert!(!state.authorizes(&request));
    }
    #[test]
    fn local_gain_variation_and_watchdog_allow_the_entire_longest_sample_without_native_claim(){
        let identity=Identity{session:u64::MAX-2,epoch:u64::MAX-1,owner:1,ordinal:(1u64<<53)+7,order:99};
        assert_eq!(variant(identity),variant(identity));assert!(variant(identity)<3);
        assert_eq!(gain(Point{x:0.,z:0.},Some([0.,100.,0.])),Some(LOCAL_GAIN));
        assert_eq!(gain(Point{x:LOCAL_MAX_DISTANCE,z:0.},Some([0.;3])),None);assert_eq!(gain(Point{x:0.,z:0.},None),None);
        let mut voice=Lifetime{birth:1.,observed_start:None,duration:3.75};assert!(!voice.expired(1.08,Some(false)));
        assert!(!voice.expired(4.0,Some(false)),"three-second hit watchdog must not cut OnCast");
        assert!(!voice.expired(4.83,Some(false)));assert!(voice.expired(5.09,Some(false)));
        let mut absent=Lifetime{birth:1.,observed_start:None,duration:3.75};assert!(absent.expired(1.101,None));
        let mut invalid=Lifetime{birth:1.,observed_start:None,duration:f64::NAN};assert!(invalid.expired(1.01,Some(false)));
        let mut short=Lifetime{birth:1.,observed_start:Some(1.02),duration:3.5208163265306123};assert!(short.expired(4.55,Some(true)));
    }
    #[test]
    fn diagnostic_lifetime_classifier_matches_unchanged_expiry_and_observer_cannot_extend_it(){
        for duration in [0.,3.5208163265306123,3.75,3.751,f64::NAN] {
            for start in [None,Some(0.05),Some(0.2)] {
                for now in [-0.01,0.,0.05,0.1,f64::from_bits(0.1f64.to_bits()+1),0.2,3.8,4.05,4.25,f64::NAN,f64::INFINITY] {
                    for sink in [None,Some(false),Some(true)] {
                        let before=Lifetime{birth:0.,observed_start:start,duration};
                        let mut untouched=before;let expected=untouched.expired(now,sink);
                        let mut observed=before;let mut observer=FirstSink::default();
                        let _=observer.observe(now-before.birth,sink.is_some());
                        assert_eq!(observed.expired(now,sink),expected);
                        assert_eq!(observed.observed_start,untouched.observed_start);
                        assert_eq!(lifetime_reason(before,now,sink).is_some(),expected);
                    }
                }
            }
        }
        let waiting=Lifetime{birth:0.,observed_start:None,duration:3.75};
        assert_eq!(lifetime_reason(waiting,0.101,None),Some(Code::RetireInitialSinkTimeout));
        assert_eq!(lifetime_reason(waiting,0.101,Some(false)),Some(Code::RetireFirstSinkLate));
        assert_eq!(lifetime_reason(waiting,0.05,Some(true)),Some(Code::RetireSinkEmpty));
        assert_eq!(lifetime_reason(Lifetime{observed_start:Some(0.05),..waiting},0.06,None),Some(Code::RetireSinkLost));
    }
    #[test]
    fn diagnostics_follow_real_cast_spawn_and_missing_sink_retirement_without_retry(){
        let(mut game,owner)=game();let mut state=baseline(&game,owner);let snapshot=accepted(&mut game,owner);
        let(mut world,handle,entity)=world();let owners=HashMap::from([(owner,entity)]);
        let foreign=world.spawn((AudioPlayer::<PcmAudio>(handle),PlaybackSettings::ONCE)).id();
        let sample=Frame{now:1.01,ready:true,paused:false,listener:Some([200.,0.,300.])};
        let codes=diagnostic::captured(|| {
            observe(&mut state,&snapshot,1.01,2);
            frame(&mut world,&mut state,Some(&snapshot),&owners,sample);
            assert_eq!(world.query::<&Voice>().iter(&world).count(),1);
            frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.05,..sample});
            assert_eq!(world.query::<&Voice>().iter(&world).count(),1);
            frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.12,..sample});
            assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
            observe(&mut state,&snapshot,1.13,3);
            frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.13,..sample});
            assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        });
        assert_eq!(codes,vec![Code::EventAdmitted,Code::SpawnQueued,Code::RetireInitialSinkTimeout]);
        assert!(world.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
    }
    #[test]
    fn diagnostic_gain_and_readiness_reasons_preserve_consumption_and_owned_cleanup(){
        for mode in 0..4 {
            let(mut game,owner)=game();let mut state=baseline(&game,owner);let snapshot=accepted(&mut game,owner);
            let(mut world,_,entity)=world();let owners=HashMap::from([(owner,entity)]);
            let sample=Frame{now:1.01,ready:mode!=2,paused:false,listener:match mode{0=>Some([2600.,0.,300.]),1=>None,_=>Some([200.,0.,300.])}};
            let codes=diagnostic::captured(|| {
                observe(&mut state,&snapshot,1.01,2);
                frame(&mut world,&mut state,Some(&snapshot),&owners,sample);
                if mode==3 {assert_eq!(world.query::<&Voice>().iter(&world).count(),1);
                    frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{ready:false,..sample});}
                assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
                observe(&mut state,&snapshot,1.02,3);
                frame(&mut world,&mut state,Some(&snapshot),&owners,Frame{now:1.02,ready:true,listener:Some([200.,0.,300.]),..sample});
                assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
            });
            let expected=match mode{0=>vec![Code::EventAdmitted,Code::GainZero],1=>vec![Code::EventAdmitted,Code::GainInvalid],
                2=>vec![Code::EventAdmitted,Code::RequestNotReady,Code::PendingRevoked],
                _=>vec![Code::EventAdmitted,Code::SpawnQueued,Code::RetireNotReady]};
            assert_eq!(codes,expected,"mode {mode}");
        }
    }

}
