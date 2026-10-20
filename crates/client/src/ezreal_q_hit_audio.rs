//! Optional base-Q hit PCM consumer. Native resources, locally reconstructed mix.
//! No Wwise routing, native random/attenuation, audible completion or skin parity.
use bevy::{prelude::*,audio::{AudioPlayer,AudioSink,AudioSinkPlayback,PlaybackSettings,Volume}};
use openleague_core::{audio_media,Point,Snapshot};
use std::{collections::HashMap,io::Read,num::NonZeroU16,sync::Arc};
use crate::{ezreal_q_hit_audio_state::{Identity,Request,State},pcm_audio::PcmAudio};

const MAX_VOICES:usize=8;
const MAX_WAV_BYTES:u64=256*1024;
const ASSET_WAIT_SECONDS:f64=0.1;
const ACTIVE_WATCHDOG_MARGIN:f64=0.25;
const MAX_VOICE_SECONDS:f64=3.;
const LOCAL_GAIN:f32=0.25;
const LOCAL_MAX_DISTANCE:f32=2400.;
pub const NATIVE_EVENT_ID:u32=2708910406;
pub const NATIVE_EVENT_NAME:&str="Play_sfx_Ezreal_EzrealMysticShotMissile_hit";
// These are decoded native base media; no Pulse/other-skin substitution.
const MEDIA:[(&str,usize);3]=[
    ("audio/champions/ezreal/q_hit/15020222.wav",71662),
    ("audio/champions/ezreal/q_hit/338887138.wav",77175),
    ("audio/champions/ezreal/q_hit/58746038.wav",68171),
];

#[derive(Resource,Default)]
pub(crate) struct Catalogue { sources:[Option<Handle<PcmAudio>>;3], errors:[Option<String>;3] }
fn decode(bytes:&[u8],frames:usize)->Result<PcmAudio,String> {
    if bytes.len() as u64>MAX_WAV_BYTES {return Err("Q hit WAV exceeds local byte budget".into());}
    let pcm=audio_media::decode(bytes).map_err(|error|format!("Q hit PCM decode: {error:?}"))?;
    if pcm.sample_rate!=44100 || pcm.channels!=1 || pcm.frames()!=frames {
        return Err("Q hit PCM differs from recovered base resource metadata".into());
    }
    PcmAudio::new(Arc::new(pcm),NonZeroU16::new(1).unwrap()).map_err(|error|format!("Q hit one-shot PCM: {error:?}"))
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
    for error in catalogue.errors.iter().flatten() {warn!("Optional Ezreal Q hit audio unavailable: {error}");}
}

/// Deterministic local variation, not recovered CAkRanSeqCntr shuffle/RNG state.
fn variant(identity:Identity)->usize {
    let value=identity.session.rotate_left(17)^identity.epoch.rotate_left(29)
        ^u64::from(identity.owner).wrapping_mul(0x9e3779b97f4a7c15)^identity.order.wrapping_mul(0xbf58476d1ce4e5b9);
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
}
/// Sink creation is asynchronous. This is a bounded local transport watchdog,
/// not a native EndOfEvent or proof of hardware-audible completion.
#[derive(Clone,Copy,Debug)]
struct Lifetime { birth:f64, observed_start:Option<f64>, duration:f64 }
impl Lifetime {
    fn expired(&mut self,now:f64,sink_empty:Option<bool>)->bool {
        if !now.is_finite() || now<self.birth || now-self.birth>=MAX_VOICE_SECONDS {return true;}
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
#[derive(Clone,Copy)]
struct Frame { now:f64, ready:bool, paused:bool, listener:Option<[f32;3]> }
fn present(
    commands:&mut Commands,channel:&mut State,snapshot:Option<&Snapshot>,owners:&HashMap<u32,Entity>,frame:Frame,
    catalogue:&Catalogue,assets:&Assets<PcmAudio>,
    voices:&mut Query<(Entity,&mut Voice,&mut PlaybackSettings,Option<&mut AudioSink>)>,
) {
    let context=channel.context();
    let usable=frame.ready && channel.presentation_ready(frame.now) && snapshot.is_some_and(|snapshot|
        context.is_some_and(|(session,_,_)|session==snapshot.session) && snapshot.winner.is_none() && snapshot.result.is_none());
    let visible=|owner:u32|snapshot.is_some_and(|snapshot|snapshot.players.iter().any(|actor|actor.id==owner && actor.champion=="ezreal"));
    let mut active=0;
    for (entity,mut voice,mut settings,sink) in voices.iter_mut() {
        let same_context=context==Some((voice.identity.session,voice.identity.epoch,voice.viewer));
        let level=gain(voice.position,frame.listener);
        let expired=voice.lifetime.expired(frame.now,sink.as_ref().map(|sink|sink.empty()));
        let retire=!usable || !same_context || !channel.authorizes(&voice.request) || !visible(voice.identity.owner)
            || owners.get(&voice.identity.owner)!=Some(&voice.owner_entity)
            || level.is_none() || expired;
        if retire {
            if let Some(sink)=sink {sink.stop();}
            commands.entity(entity).despawn();continue;
        }
        active+=1;settings.paused=frame.paused;settings.volume=Volume::Linear(level.unwrap());
        if let Some(mut sink)=sink {
            sink.set_volume(settings.volume);
            if frame.paused {sink.pause();} else {sink.play();}
        }
    }
    if !usable {channel.suspend();return;}
    for request in channel.take(frame.now,frame.ready,frame.paused) {
        if active>=MAX_VOICES || !visible(request.identity.owner) {continue;}
        let Some(&owner_entity)=owners.get(&request.identity.owner) else {continue;};
        let index=variant(request.identity);
        let Some(handle)=catalogue.sources[index].as_ref().filter(|handle|assets.get(*handle).is_some()) else {continue;};
        let Some(level)=gain(request.position,frame.listener) else {continue;};
        // AudioPlayer::new is hardcoded to Bevy AudioSource. The tuple is the
        // actual 0.19 API for this project's registered custom PCM source.
        commands.spawn((AudioPlayer::<PcmAudio>(handle.clone()),PlaybackSettings::ONCE.with_volume(Volume::Linear(level)),
            Voice { identity:request.identity,viewer:context.unwrap().2,position:request.position,owner_entity,
                request,lifetime:Lifetime {birth:frame.now,observed_start:None,duration:MEDIA[index].1 as f64/44100.} }));
        active+=1;
    }
}

/// Scheduled after receive and the existing camera listener update.
pub(crate) fn update(mut commands:Commands,mut state:ResMut<crate::Match>,clock:Res<crate::native_effect_clock::EffectClock>,
    listener:Res<crate::map_audio::NativeListener>,catalogue:Res<Catalogue>,assets:Res<Assets<PcmAudio>>,
    mut voices:Query<(Entity,&mut Voice,&mut PlaybackSettings,Option<&mut AudioSink>)>) {
    let frame=Frame {now:clock.now,ready:clock.presentation_ready(),paused:clock.paused(),listener:listener.position.current};
    let crate::Match {ezreal_q_hit_sounds,snapshot,visuals,..}=&mut *state;
    present(&mut commands,ezreal_q_hit_sounds,snapshot.as_ref(),visuals,frame,&catalogue,&assets,&mut voices);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Catalogue>().add_systems(Startup,load);}
}

#[cfg(test)]
mod tests {
    use super::*;
    use bevy::{audio::Decodable,ecs::system::SystemState};
    use openleague_core::{Navigation,Simulation};
    fn fixture()->(Snapshot,u32) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=7;game.tick=100;let owner=game.join("ezreal").unwrap();
        let mut snapshot=game.snapshot();snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));(snapshot,owner)
    }
    fn accepted(snapshot:&mut Snapshot,owner:u32,order:u64,tick:u64) {
        snapshot.tick=tick;snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[{
            "owner":owner,"target":900,"order":order,"tick":tick,
            "projectile_center":{"x":200.,"z":300.},"target_center":{"x":220.,"z":300.}}]}));
    }
    fn frame(world:&mut World,channel:&mut State,snapshot:Option<&Snapshot>,owners:&HashMap<u32,Entity>,sample:Frame) {
        let mut system=SystemState::<(Commands,Res<Catalogue>,Res<Assets<PcmAudio>>,Query<(Entity,&mut Voice,&mut PlaybackSettings,Option<&mut AudioSink>)>)>::new(world);
        let (mut commands,catalogue,assets,mut voices)=system.get_mut(world).expect("Q audio test system resources");
        present(&mut commands,channel,snapshot,owners,sample,&catalogue,&assets,&mut voices);system.apply(world);
    }
    #[test]
    fn actual_pcm_typed_player_is_one_shot_bounded_and_owned_cleanup_preserves_foreign_audio() {
        let mut world=World::new();let mut assets=Assets::<PcmAudio>::default();
        let bytes=include_bytes!("../../../assets/audio/champions/ezreal/q_hit/15020222.wav");
        let handle=assets.add(decode(bytes,71662).unwrap());
        world.insert_resource(Catalogue {sources:std::array::from_fn(|_|Some(handle.clone())),errors:Default::default()});world.insert_resource(assets);
        let owner_entity=world.spawn_empty().id();let foreign=world.spawn((AudioPlayer::<PcmAudio>(handle.clone()),PlaybackSettings::ONCE)).id();
        let (mut snapshot,owner)=fixture();let owners=HashMap::from([(owner,owner_entity)]);let mut channel=State::default();channel.reset(7,owner);
        channel.observe_accepted(&snapshot,1.,true,false).unwrap();
        for order in 1..=12 {
            let mut ring=snapshot.ezreal_q_accepted_impacts.as_ref().unwrap()["events"].as_array().unwrap().clone();
            accepted(&mut snapshot,owner,order,101);ring.push(snapshot.ezreal_q_accepted_impacts.as_ref().unwrap()["events"][0].clone());
            snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["events"]=serde_json::Value::Array(ring);
            channel.observe_accepted(&snapshot,1.01,true,false).unwrap();
        }
        let sample=Frame {now:1.01,ready:true,paused:false,listener:Some([220.,0.,300.])};
        frame(&mut world,&mut channel,Some(&snapshot),&owners,sample);
        assert_eq!(world.query::<&Voice>().iter(&world).count(),MAX_VOICES);
        let voice_entity=world.query_filtered::<Entity,With<Voice>>().iter(&world).next().unwrap();
        let player=world.get::<AudioPlayer<PcmAudio>>(voice_entity).unwrap();assert_eq!(player.0,handle);
        assert!(matches!(world.get::<PlaybackSettings>(voice_entity).unwrap().mode,bevy::audio::PlaybackMode::Once));
        frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {paused:true,..sample});
        assert!(world.get::<PlaybackSettings>(voice_entity).unwrap().paused);
        let authorized_projection=snapshot.ezreal_q_accepted_impacts.clone();snapshot.tick=102;
        snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));
        channel.observe_accepted(&snapshot,1.01,true,true).unwrap();frame(&mut world,&mut channel,Some(&snapshot),&owners,sample);
        assert_eq!(world.query::<&Voice>().iter(&world).count(),0);assert!(world.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
        snapshot.tick=103;snapshot.ezreal_q_accepted_impacts=authorized_projection;
        channel.observe_accepted(&snapshot,1.01,true,false).unwrap();frame(&mut world,&mut channel,Some(&snapshot),&owners,sample);
        assert_eq!(world.query::<&Voice>().iter(&world).count(),0); // reveal never restarts old one-shots
        frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {ready:false,..sample});
        assert_eq!(world.query::<&Voice>().iter(&world).count(),0);assert!(world.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
        channel.observe_accepted(&snapshot,1.02,true,false).unwrap();frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.02,..sample});
        assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        // An already released Q can hit after its owner dies. Death alone must
        // not silence an accepted fact while the same scene remains visible.
        snapshot.players.iter_mut().find(|actor|actor.id==owner).unwrap().health=0.;
        accepted(&mut snapshot,owner,13,104);channel.observe_accepted(&snapshot,1.03,true,false).unwrap();
        frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.03,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),1);
        let replacement=HashMap::from([(owner,world.spawn_empty().id())]);
        frame(&mut world,&mut channel,Some(&snapshot),&replacement,Frame {now:1.04,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        accepted(&mut snapshot,owner,14,105);channel.observe_accepted(&snapshot,1.05,true,false).unwrap();frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.05,..sample});
        snapshot.players.clear();frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.06,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        snapshot.players=fixture().0.players;accepted(&mut snapshot,owner,15,106);channel.observe_accepted(&snapshot,1.07,true,false).unwrap();
        // The latest accepted packet had a missing owner: no return replay.
        // The per-packet observer, rather than only this frame, sees that gap.
        let mut absent=snapshot.clone();absent.tick=107;absent.players.clear();absent.ezreal_q_accepted_impacts=None;
        channel.observe_accepted(&absent,1.07,true,false).unwrap();accepted(&mut snapshot,owner,16,108);
        channel.observe_accepted(&snapshot,1.08,true,false).unwrap();frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.08,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        accepted(&mut snapshot,owner,17,109);channel.observe_accepted(&snapshot,1.09,true,false).unwrap();
        let saved=world.resource::<Catalogue>().sources.clone();world.resource_mut::<Catalogue>().sources=Default::default();
        frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.09,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        world.resource_mut::<Catalogue>().sources=saved;channel.observe_accepted(&snapshot,1.10,true,false).unwrap();
        frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.10,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        accepted(&mut snapshot,owner,18,110);channel.observe_accepted(&snapshot,1.11,true,false).unwrap();frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.11,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),1);
        // This CPU test installs no AudioPlugin/device: an unavailable sink is
        // retired, rather than starting the queued AudioPlayer much later.
        frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.22,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        accepted(&mut snapshot,owner,19,111);channel.observe_accepted(&snapshot,1.23,true,false).unwrap();frame(&mut world,&mut channel,Some(&snapshot),&owners,Frame {now:1.23,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),1);
        frame(&mut world,&mut channel,None,&owners,Frame {now:1.24,..sample});assert_eq!(world.query::<&Voice>().iter(&world).count(),0);
        assert!(world.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
        // Existing real PCM players must not survive an authorization episode
        // gap followed by an identical reveal BEFORE a single present pass.
        for gap in 0..4 {
            let (mut projected,owner)=fixture();let mut scoped=State::default();scoped.reset(7,owner);
            scoped.observe_accepted(&projected,3.,true,false).unwrap();
            accepted(&mut projected,owner,1,101);let first=projected.ezreal_q_accepted_impacts.as_ref().unwrap()["events"][0].clone();
            accepted(&mut projected,owner,2,102);projected.ezreal_q_accepted_impacts.as_mut().unwrap()["events"].as_array_mut().unwrap().insert(0,first);
            scoped.observe_accepted(&projected,3.01,true,false).unwrap();
            let same_clock=Frame {now:3.01,..sample};frame(&mut world,&mut scoped,Some(&projected),&owners,same_clock);
            let first_voice=world.query::<(Entity,&Voice)>().iter(&world).find(|(_,voice)|voice.identity.order==1).unwrap().0;
            let continuous=world.query::<(Entity,&Voice)>().iter(&world).find(|(_,voice)|voice.identity.order==2).unwrap().0;
            let full=projected.ezreal_q_accepted_impacts.clone();projected.tick=103;
            projected.ezreal_q_accepted_impacts=match gap {
                0=>Some(serde_json::json!({"version":1,"events":[]})),1=>None,
                2=>Some(serde_json::json!({"version":999,"events":[]})),
                _=>Some(serde_json::json!({"version":1,"events":[full.as_ref().unwrap()["events"][1].clone()]})),
            };
            let result=scoped.observe_accepted(&projected,3.01,true,false);assert_eq!(result.is_err(),gap==2);
            projected.tick=104;projected.ezreal_q_accepted_impacts=full;
            scoped.observe_accepted(&projected,3.01,true,false).unwrap();
            frame(&mut world,&mut scoped,Some(&projected),&owners,same_clock);
            assert!(world.get::<Voice>(first_voice).is_none());
            assert_eq!(world.get::<Voice>(continuous).is_some(),gap==3);
            assert_eq!(world.query::<&Voice>().iter(&world).count(),usize::from(gap==3));
            assert!(world.get::<AudioPlayer<PcmAudio>>(foreign).is_some());
            frame(&mut world,&mut scoped,None,&owners,same_clock);
        }
    }
    #[test]
    fn all_three_original_pcm_variants_decode_once_and_optional_failures_do_not_fallback() {
        let bytes:[&[u8];3]=[
            include_bytes!("../../../assets/audio/champions/ezreal/q_hit/15020222.wav"),
            include_bytes!("../../../assets/audio/champions/ezreal/q_hit/338887138.wav"),
            include_bytes!("../../../assets/audio/champions/ezreal/q_hit/58746038.wav"),
        ];
        for (index,wav) in bytes.iter().enumerate() {
            let asset=decode(wav,MEDIA[index].1).unwrap();let mut decoder=asset.decoder();
            assert_eq!(decoder.by_ref().count(),MEDIA[index].1);assert_eq!(decoder.next(),None);
            assert!(decode(wav,MEDIA[index].1+1).is_err());
        }
        let mut assets=Assets::<PcmAudio>::default();let catalogue=populate(&mut assets,|_|Err("missing".into()));
        assert!(catalogue.sources.iter().all(Option::is_none));assert!(catalogue.errors.iter().all(Option::is_some));
        assert!(decode(&[0;4],71662).is_err());assert!(decode(&vec![0;MAX_WAV_BYTES as usize+1],71662).is_err());
    }
    #[test]
    fn local_selection_and_distance_are_finite_bounded_and_explicitly_non_native() {
        let id=Identity {session:1,epoch:2,owner:3,order:4};assert_eq!(variant(id),variant(id));
        let selected:std::collections::BTreeSet<_>=(1..=32).map(|order|variant(Identity {order,..id})).collect();assert_eq!(selected.len(),3);
        assert_eq!(gain(Point{x:0.,z:0.},Some([0.,500.,0.])),Some(LOCAL_GAIN));
        assert_eq!(gain(Point{x:2400.,z:0.},Some([0.,500.,0.])),None);
        assert_eq!(gain(Point{x:0.,z:0.},None),None);assert_eq!(gain(Point{x:f32::NAN,z:0.},Some([0.;3])),None);
    }
    #[test]
    fn delayed_sink_start_uses_active_observation_pause_clock_and_independent_deadlines() {
        let mut delayed=Lifetime {birth:1.,observed_start:None,duration:1.};
        assert!(!delayed.expired(1.05,None));assert!(!delayed.expired(1.08,Some(false)));
        assert_eq!(delayed.observed_start,Some(1.08));
        // EffectClock remains at this exact sample while its pause control is on.
        for _ in 0..20 {assert!(!delayed.expired(1.08,Some(false)));}
        assert!(!delayed.expired(2.,Some(false))); // previous birth+duration cutoff
        assert!(!delayed.expired(2.08,Some(false)));assert!(delayed.expired(2.09,Some(true)));
        let mut no_backend=Lifetime {birth:1.,observed_start:None,duration:1.};assert!(no_backend.expired(1.101,None));
        let mut late=Lifetime {birth:1.,observed_start:None,duration:1.};assert!(late.expired(1.101,Some(false)));
        let mut stuck=Lifetime {birth:1.,observed_start:None,duration:1.};assert!(!stuck.expired(1.08,Some(false)));
        assert!(stuck.expired(2.34,Some(false))); // bounded active watchdog, not birth deadline
        let mut corrupt=Lifetime {birth:1.,observed_start:Some(1.08),duration:f64::INFINITY};assert!(corrupt.expired(4.01,Some(false)));
    }
}
