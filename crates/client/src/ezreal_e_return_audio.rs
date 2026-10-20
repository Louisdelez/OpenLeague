//! Original base E return PCM, triggered only by accepted Arrival facts.
//! local_e_arrival_return_audio_v1: non-spatial mono, gain 0.10, speed 1,
//! deterministic playlist cycle, two owned voices. No Wwise mix/audibility claim.
use bevy::{prelude::*,audio::{AudioPlayer,AudioSink,AudioSinkPlayback,PlaybackSettings,Volume}};
use bevy::asset::AssetId;
use openleague_core::{audio_media,Snapshot};
use std::{io::Read,num::NonZeroU16,sync::Arc};
use crate::{ezreal_e_return_audio_state::{Request,State},pcm_audio::PcmAudio};

const MAX_VOICES:usize=2;
const WAV_BYTES:usize=239650;
const FRAMES:usize=119803;
const SAMPLE_RATE:u32=44100;
const DURATION:f64=FRAMES as f64/SAMPLE_RATE as f64;
// Explicit local asynchronous-backend budgets, unrelated to native callbacks.
const FIRST_SINK_WAIT:f64=0.25;
const ACTIVE_MARGIN:f64=0.25;
const MAX_VOICE_SECONDS:f64=FIRST_SINK_WAIT+DURATION+ACTIVE_MARGIN;
const LOCAL_GAIN:f32=0.10;
pub const NATIVE_EVENT_ID:u32=4134030092;
pub const NATIVE_EVENT_NAME:&str="Play_sfx_Ezreal_EzrealArcaneShift_return";
const MEDIA:[&str;3]=[
    "audio/champions/ezreal/e_return/452186853.wav",
    "audio/champions/ezreal/e_return/271942249.wav",
    "audio/champions/ezreal/e_return/196438317.wav",
];
#[derive(Resource,Default)]
pub(crate) struct Catalogue {sources:[Option<Handle<PcmAudio>>;3]}
fn decode(bytes:&[u8])->Result<PcmAudio,&'static str> {
    // Full original files are pinned by the candidate/resource ledger. Runtime
    // validation checks the bounded PCM format and full frame count, not SHA.
    if bytes.len()!=WAV_BYTES {return Err("E return WAV size differs");}
    let pcm=audio_media::decode(bytes).map_err(|_|"E return PCM invalid")?;
    if pcm.sample_rate!=SAMPLE_RATE || pcm.channels!=1 || pcm.frames()!=FRAMES {
        return Err("E return PCM metadata differs");
    }
    PcmAudio::new(Arc::new(pcm),NonZeroU16::new(1).unwrap()).map_err(|_|"E return one-shot invalid")
}
fn populate(assets:&mut Assets<PcmAudio>,mut read:impl FnMut(&str)->Result<Vec<u8>,()>)->Catalogue {
    let mut result=Catalogue::default();
    for (i,path) in MEDIA.iter().enumerate() {
        if let Some(source)=read(path).ok().and_then(|b|decode(&b).ok()) {
            result.sources[i]=Some(assets.add(source));
        }
    }
    result
}
fn load(mut assets:ResMut<Assets<PcmAudio>>,mut catalogue:ResMut<Catalogue>) {
    let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets");
    *catalogue=populate(&mut assets,|relative| {
        let file=std::fs::File::open(root.join(relative)).map_err(|_|())?;
        let mut bytes=Vec::new();file.take(WAV_BYTES as u64+1).read_to_end(&mut bytes).map_err(|_|())?;Ok(bytes)
    });
    if catalogue.sources.iter().any(Option::is_none) {warn!("Optional Ezreal E return PCM unavailable");}
}
#[derive(Clone,Copy,Debug)]
struct Lifetime {birth:f64,observed_start:Option<f64>}
impl Lifetime {
    fn expired(&mut self,now:f64,sink_empty:Option<bool>)->bool {
        if !now.is_finite() || now<self.birth || now-self.birth>=MAX_VOICE_SECONDS {return true;}
        match sink_empty {
            None=>self.observed_start.is_some() || now-self.birth>FIRST_SINK_WAIT,
            Some(true)=>true,
            Some(false)=>{
                if self.observed_start.is_none() && now-self.birth>FIRST_SINK_WAIT {return true;}
                let start=*self.observed_start.get_or_insert(now);
                now<start || now-start>DURATION+ACTIVE_MARGIN
            }
        }
    }
}
#[derive(Component)]
pub(crate) struct Voice {request:Request,source:AssetId<PcmAudio>,lifetime:Lifetime}
#[derive(Clone,Copy)]
struct Frame {now:f64,ready:bool,paused:bool}
fn present(commands:&mut Commands,channel:&mut State,snapshot:Option<&Snapshot>,frame:Frame,
    catalogue:&Catalogue,assets:&Assets<PcmAudio>,
    voices:&mut Query<(Entity,&mut Voice,Option<&AudioSink>)>) {
    let usable=frame.ready && !frame.paused && channel.presentation_ready(frame.now)
        && snapshot.is_some_and(|s|channel.context().is_some_and(|c|c.0==s.session)
            && s.winner.is_none() && s.result.is_none());
    let mut active=0;
    for (entity,mut voice,sink) in voices.iter_mut() {
        let expired=voice.lifetime.expired(frame.now,sink.map(|s|s.empty()));
        if !usable || !channel.authorizes(&voice.request) || assets.get(voice.source).is_none() || expired {
            if let Some(sink)=sink {sink.stop();}
            commands.entity(entity).despawn();
        } else {active+=1;}
    }
    if !usable {channel.suspend();return;}
    for request in channel.take(frame.now,frame.ready,frame.paused) {
        // Every request is consumed, including cap/asset failures. No retry or
        // source-actor/target lookup, position inference, or VFX queue access.
        if active>=MAX_VOICES {continue;}
        let Some(handle)=catalogue.sources.get(request.variant).and_then(Option::as_ref)
            .filter(|h|assets.get(*h).is_some()) else {continue;};
        commands.spawn((AudioPlayer::<PcmAudio>(handle.clone()),
            PlaybackSettings::ONCE.with_volume(Volume::Linear(LOCAL_GAIN)).with_speed(1.),
            Voice {request,source:handle.id(),lifetime:Lifetime {birth:frame.now,observed_start:None}}));
        active+=1;
    }
}
/// Current readiness is checked again after receive commits presented().
pub(crate) fn update(mut commands:Commands,mut state:ResMut<crate::Match>,
    clock:Res<crate::native_effect_clock::EffectClock>,connection:Res<crate::Connection>,
    catalogue:Res<Catalogue>,assets:Res<Assets<PcmAudio>>,
    mut voices:Query<(Entity,&mut Voice,Option<&AudioSink>)>) {
    let frame=Frame {now:clock.now,ready:connection.ready() && clock.presentation_ready(),paused:clock.paused()};
    let crate::Match {ezreal_e_return_sounds,snapshot,..}=&mut *state;
    present(&mut commands,ezreal_e_return_sounds,snapshot.as_ref(),frame,&catalogue,&assets,&mut voices);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Catalogue>().add_systems(Startup,load);}
}
#[cfg(test)]
#[path="ezreal_e_return_audio_tests.rs"]
mod tests;
