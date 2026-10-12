//! PCM bridge to Bevy audio; event selection and native mixing remain upstream.
use bevy::{prelude::*,audio::{AddAudioSource,Decodable,Source,ChannelCount,SampleRate}};
use openleague_core::audio_media::{self,Pcm,Playback};
use std::{sync::Arc,num::NonZeroU16,time::Duration};
#[derive(Asset,TypePath,Clone)]
pub struct PcmAudio { pcm:Arc<Pcm>, plays:NonZeroU16, monitor:Option<Arc<TransportMonitor>>, filter:Option<FilterSettings> }
impl PcmAudio {
    pub fn new(pcm:Arc<Pcm>,plays:NonZeroU16)->Result<Self,audio_media::PlaybackError> {
        pcm.playback(plays)?;Ok(Self {pcm,plays,monitor:None,filter:None})
    }
}
/// Transport facts only: exhaustion means samples handed to the mixer, not
/// audible hardware completion or a native EndOfEvent. IDs are local decoder
/// instances within one receiver, never game-object or native playing IDs.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum TransportState { Created, Failed(&'static str), Exhausted, Seek { frame:u128 }, Dropped { exhausted:bool } }
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct TransportEvent { pub decoder:u64, pub state:TransportState }
struct TransportMonitor {
    next:std::sync::atomic::AtomicU64,
    sender:std::sync::mpsc::Sender<TransportEvent>,
}
struct DecoderMonitor { id:u64, shared:Arc<TransportMonitor> }
impl DecoderMonitor {
    fn send(&self,state:TransportState) {
        // Receiver teardown must never panic on the device thread.
        let _=self.shared.sender.send(TransportEvent {decoder:self.id,state});
    }
}
impl PcmAudio {
    /// Make an observed asset for an admitted playback. The catalogue remains
    /// unobserved; cloned assets share this receiver but each decoder gets a
    /// separate identity. No events are manufactured before decoder creation.
    pub fn observed(&self)->(Self,std::sync::mpsc::Receiver<TransportEvent>) {
        let (sender,receiver)=std::sync::mpsc::channel();
        let monitor=Arc::new(TransportMonitor {next:std::sync::atomic::AtomicU64::new(1),sender});
        (Self {pcm:Arc::clone(&self.pcm),plays:self.plays,monitor:Some(monitor),filter:self.filter.clone()},receiver)
    }
}
#[derive(Clone)]
struct FilterSettings { control:FilterControl, mode:u8, block_frames:usize }
/// One admitted voice's evaluated LPF control. Asset clones for that voice share
/// updates, while separately configured voices own separate control state.
/// A single atomic snapshot couples target and reset epoch at a PCM boundary.
#[derive(Clone)]
pub struct FilterControl(Arc<std::sync::atomic::AtomicU64>);
impl FilterControl {
    fn new(raw:f32)->Self {Self(Arc::new(std::sync::atomic::AtomicU64::new(u64::from(raw.to_bits()))))}
    pub fn set(&self,raw:f32)->Result<(),&'static str> {
        if !raw.is_finite() {return Err("invalid filter control");}
        self.0.fetch_update(std::sync::atomic::Ordering::AcqRel,std::sync::atomic::Ordering::Acquire,|s|Some((s&0xffff_ffff_0000_0000)|u64::from(raw.to_bits()))).expect("infallible target update");Ok(())
    }
    /// Native reset preserves target and dirty state, clears channel histories
    /// and makes the next active control immediate. It never edits read-ahead.
    pub fn reset(&self)->Result<(),&'static str> {
        self.0.fetch_update(std::sync::atomic::Ordering::AcqRel,std::sync::atomic::Ordering::Acquire,|s|(s>>32).checked_add(1).filter(|n|*n<=u64::from(u32::MAX)).map(|n|(n<<32)|(s&0xffff_ffff)))
            .map(|_|()).map_err(|_|"filter reset epoch exhausted")
    }
    fn snapshot(&self)->(f32,u32) {let s=self.0.load(std::sync::atomic::Ordering::Acquire);(f32::from_bits(s as u32),(s>>32) as u32)}
}
struct VoiceFilter {
    controller:openleague_core::audio_filter_transition::Controller,
    control:FilterControl, reset_epoch:u32, planar:Vec<f32>, capacity:usize,
}
impl PcmAudio {
    /// Native LPF consumer on decoded samples. The caller supplies the evaluated
    /// voice control, native mode and processing cadence; no mix defaults guessed.
    pub fn filtered(&self,control:f32,mode:u8,block_frames:usize)->Result<Self,&'static str> {
        self.controlled_filter(control,mode,block_frames).map(|(asset,_)|asset)
    }
    pub fn controlled_filter(&self,control:f32,mode:u8,block_frames:usize)->Result<(Self,FilterControl),&'static str> {
        if !control.is_finite() || block_frames==0 || block_frames>u16::MAX as usize {return Err("invalid PCM filter configuration");}
        openleague_core::audio_filter_transition::Controller::new(usize::from(self.pcm.channels),mode,self.pcm.sample_rate)?;
        let control=FilterControl::new(control);
        let mut asset=self.clone();asset.filter=Some(FilterSettings {control:control.clone(),mode,block_frames});Ok((asset,control))
    }
}
pub struct Decoder { playback:Playback<Arc<Pcm>>, channels:ChannelCount, rate:SampleRate,
    duration:Duration, buffer:Vec<f32>, position:usize, available:usize, monitor:Option<DecoderMonitor>, exhausted:bool, filter:Option<VoiceFilter>, failure:Option<&'static str> }
impl Decodable for PcmAudio {
    type Decoder=Decoder;
    fn decoder(&self)->Decoder {
        let monitor=self.monitor.as_ref().map(|shared| {
            let id=shared.next.fetch_update(std::sync::atomic::Ordering::Relaxed,std::sync::atomic::Ordering::Relaxed,|n|n.checked_add(1)).expect("decoder observation identity exhausted");
            let monitor=DecoderMonitor {id,shared:Arc::clone(shared)};
            monitor.send(TransportState::Created);monitor
        });
        let frames=self.filter.as_ref().map_or(512,|s|s.block_frames);
        let filter=self.filter.as_ref().map(|s|VoiceFilter {
            controller:openleague_core::audio_filter_transition::Controller::new(usize::from(self.pcm.channels),s.mode,self.pcm.sample_rate).expect("validated filter configuration"),
            control:s.control.clone(),reset_epoch:s.control.snapshot().1,planar:vec![0.;frames*usize::from(self.pcm.channels)],capacity:frames,
        });
        Decoder {playback:audio_media::shared_playback(Arc::clone(&self.pcm),self.plays).expect("validated immutable PCM"),
            channels:ChannelCount::new(self.pcm.channels).unwrap(),rate:SampleRate::new(self.pcm.sample_rate).unwrap(),
            duration:Duration::from_secs_f64(self.pcm.frames() as f64*f64::from(self.plays.get())/f64::from(self.pcm.sample_rate)),
            buffer:vec![0.;frames*usize::from(self.pcm.channels)],position:0,available:0,monitor,exhausted:false,filter,failure:None}
    }
}
impl Iterator for Decoder {
    type Item=f32;
    fn next(&mut self)->Option<f32> {
        if self.failure.is_some() {return None;}
        if self.position==self.available {
            let block=self.playback.read(&mut self.buffer).expect("frame aligned decoder buffer");
            self.available=block.frames*usize::from(self.channels.get());self.position=0;
            if self.available==0 {self.mark_exhausted();return None;}
            if let Some(filter)=&mut self.filter {
                let channels=usize::from(self.channels.get());
                for channel in 0..channels {for frame in 0..block.frames {
                    filter.planar[channel*filter.capacity+frame]=self.buffer[frame*channels+channel];
                }}
                let (control,reset_epoch)=filter.control.snapshot();
                if reset_epoch!=filter.reset_epoch {filter.controller.reset();filter.reset_epoch=reset_epoch;}
                if let Err(error)=filter.controller.process_voice(control,&mut filter.planar,filter.capacity,block.frames) {
                    self.failure=Some(error);self.available=0;
                    if let Some(m)=&self.monitor {m.send(TransportState::Failed(error));}
                    return None;
                }
                for channel in 0..channels {for frame in 0..block.frames {
                    self.buffer[frame*channels+channel]=filter.planar[channel*filter.capacity+frame];
                }}
            }
        }
        let sample=self.buffer[self.position];self.position+=1;
        if self.position==self.available && self.playback.finished() {self.mark_exhausted();}
        Some(sample)
    }
}
impl Decoder {
    pub fn failure(&self)->Option<&'static str> {self.failure}
    fn mark_exhausted(&mut self) {
        if !self.exhausted {
            self.exhausted=true;
            if let Some(m)=&self.monitor {m.send(TransportState::Exhausted);}
        }
    }
}
impl Drop for Decoder {
    fn drop(&mut self) {
        if let Some(m)=&self.monitor {m.send(TransportState::Dropped {exhausted:self.exhausted});}
    }
}
impl Source for Decoder {
    fn current_span_len(&self)->Option<usize> {None}
    fn channels(&self)->ChannelCount {self.channels}
    fn sample_rate(&self)->SampleRate {self.rate}
    fn total_duration(&self)->Option<Duration> {Some(self.duration)}
    fn try_seek(&mut self,pos:Duration)->Result<(),bevy::audio::SeekError> {
        // Native seek history/reset policy has not yet been qualified. Reject
        // before mutating PCM, filter history or notifications.
        if self.filter.is_some() {return Err(bevy::audio::SeekError::NotSupported {underlying_source:"native filtered PCM: seek history policy pending"});}
        // Rodio transport contract: known-duration sources clamp at the end.
        // Integer arithmetic avoids overflow and preserves frame/channel alignment.
        let frame=if pos>=self.duration{u128::MAX}else{pos.as_nanos()*u128::from(self.rate.get())/1_000_000_000};
        let channel=self.position%usize::from(self.channels.get());
        let frame=self.playback.seek_frame(frame);
        self.exhausted=false;
        if let Some(m)=&self.monitor {m.send(TransportState::Seek {frame});}
        // Invalidate read-ahead and retain the next output channel, as required
        // by the source mixer when seek occurs between interleaved samples.
        self.position=0;self.available=0;
        for _ in 0..channel{let _=self.next();}
        if self.position==self.available && self.playback.finished() {self.mark_exhausted();}
        Ok(())
    }

}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.add_audio_source::<PcmAudio>().init_resource::<AmbientPcm>().add_systems(Startup,load_ambient);}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn independent_decoders_keep_stereo_order_and_exact_end() {
        let pcm=Arc::new(Pcm {sample_rate:44100,channels:2,samples:vec![0.1,0.2,0.3,0.4]});
        let asset=PcmAudio::new(Arc::clone(&pcm),NonZeroU16::new(2).unwrap()).unwrap();
        let mut first=asset.decoder();assert_eq!(first.channels().get(),2);assert_eq!(first.sample_rate().get(),44100);
        assert_eq!(first.next(),Some(0.1));let second:Vec<_>=asset.decoder().collect();
        assert_eq!(second,vec![0.1,0.2,0.3,0.4,0.1,0.2,0.3,0.4]);
        assert_eq!(first.by_ref().collect::<Vec<_>>(),second[1..]);assert_eq!(first.next(),None);
    }
}

/// Loaded sources are available PCM assets, not accepted or audible voices.
#[derive(Resource,Default)]
pub struct AmbientPcm {
    pub sources:std::collections::BTreeMap<u32,Handle<PcmAudio>>,
    pub errors:std::collections::BTreeMap<u32,String>,
}
#[derive(serde::Deserialize)]
struct MediaRow { source_id:u32,wav:String,frames:usize,sample_rate:u32,channels:u16 }
#[derive(serde::Deserialize)]
struct MediaManifest { media:Vec<MediaRow> }
fn populate(assets:&mut Assets<PcmAudio>,mut read:impl FnMut(&str)->Result<Vec<u8>,String>)->AmbientPcm {
    let manifest:MediaManifest=serde_json::from_str(include_str!("../../../data/4.20/ambient_audio_manifest.json")).expect("embedded ambient manifest");
    let mut cache=AmbientPcm::default();
    for row in manifest.media {
        let result=(|| {
            let bytes=read(&row.wav)?;
            let pcm=audio_media::decode(&bytes).map_err(|e|format!("PCM decode: {e:?}"))?;
            if pcm.frames()!=row.frames || pcm.sample_rate!=row.sample_rate || pcm.channels!=row.channels {
                return Err("PCM metadata differs from source manifest".into());
            }
            PcmAudio::new(Arc::new(pcm),NonZeroU16::new(1).unwrap()).map_err(|e|format!("PCM playback: {e:?}"))
        })();
        match result {
            Ok(source)=>{cache.sources.insert(row.source_id,assets.add(source));},
            Err(error)=>{cache.errors.insert(row.source_id,error);},
        }
    }
    cache
}
fn load_ambient(mut assets:ResMut<Assets<PcmAudio>>,mut cache:ResMut<AmbientPcm>) {
    let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets");
    *cache=populate(&mut assets,|relative|std::fs::read(root.join(relative.replace('\\',"/"))).map_err(|e|e.to_string()));
    for (id,error) in &cache.errors {warn!("Ambient source {id} unavailable: {error}");}
}
#[cfg(test)] mod catalog_tests {
    use super::*;
    fn read(relative:&str)->Result<Vec<u8>,String> {
        std::fs::read(std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets").join(relative.replace('\\',"/"))).map_err(|e|e.to_string())
    }
    #[test] fn real_catalog_reaches_bevy_decoders_with_exact_frame_counts() {
        let mut assets=Assets::<PcmAudio>::default();let cache=populate(&mut assets,read);
        assert!(cache.errors.is_empty());assert_eq!(cache.sources.len(),31);
        let manifest:MediaManifest=serde_json::from_str(include_str!("../../../data/4.20/ambient_audio_manifest.json")).unwrap();
        for row in manifest.media {
            let source=assets.get(&cache.sources[&row.source_id]).unwrap();let decoder=source.decoder();
            assert_eq!(decoder.channels().get(),row.channels);assert_eq!(decoder.sample_rate().get(),row.sample_rate);
            assert_eq!(decoder.count(),row.frames*usize::from(row.channels));
        }
    }
    #[test] fn missing_or_changed_media_never_become_ready_handles() {
        let mut assets=Assets::<PcmAudio>::default();
        let cache=populate(&mut assets,|p|if p.contains("51118002") {Err("missing".into())} else {read(p)});
        assert_eq!(cache.sources.len(),30);assert!(!cache.sources.contains_key(&51118002));assert_eq!(cache.errors[&51118002],"missing");
        let cache=populate(&mut assets,|p|{let mut bytes=read(p)?;if p.contains("51118002") {bytes[24..28].copy_from_slice(&22050u32.to_le_bytes());bytes[28..32].copy_from_slice(&44100u32.to_le_bytes());}Ok(bytes)});
        assert_eq!(cache.sources.len(),30);assert_eq!(cache.errors[&51118002],"PCM metadata differs from source manifest");
    }
}

/// Resolves selected actions without changing selection history or admitting voices.
/// Keep the native sound/action IDs: multiple sounds may share the same PCM source.
pub struct ResolvedAction {
    pub selection: openleague_core::audio_selection::Selection,
    pub audio: Handle<PcmAudio>,
}
#[derive(Debug,PartialEq)]
pub enum ResolveError { MissingSource(u32), UnloadedAsset(u32) }
impl AmbientPcm {
    pub fn resolve(&self, selections:&[openleague_core::audio_selection::Selection],
        assets:&Assets<PcmAudio>)->Result<Vec<ResolvedAction>,ResolveError> {
        selections.iter().map(|selection| {
            let audio=self.sources.get(&selection.source).ok_or(ResolveError::MissingSource(selection.source))?;
            if assets.get(audio).is_none() {return Err(ResolveError::UnloadedAsset(selection.source));}
            Ok(ResolvedAction {selection:selection.clone(),audio:audio.clone()})
        }).collect()
    }
}
#[cfg(test)] mod resolution_tests {
    use super::*;
    use openleague_core::audio_selection::{ambient_contract,Selection,Selector};
    fn catalog()->(Assets<PcmAudio>,AmbientPcm) {
        let mut assets=Assets::default();
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets");
        let cache=populate(&mut assets,|p|std::fs::read(root.join(p.replace('\\',"/"))).map_err(|e|e.to_string()));
        (assets,cache)
    }
    #[test] fn every_native_sound_and_event_resolves_to_its_loaded_pcm() {
        let (assets,cache)=catalog(); let contract=ambient_contract().unwrap();
        assert_eq!(contract.sounds.len(),42);
        for sound in &contract.sounds {
            let selection=Selection {action:0,container:sound.parent,sound:sound.id,source:sound.source,transition_ms:0.};
            let result=cache.resolve(&[selection.clone()],&assets).unwrap();
            assert_eq!(result[0].selection,selection);
            assert_eq!(result[0].audio,cache.sources[&sound.source]);
            assert!(assets.get(&result[0].audio).unwrap().decoder().next().is_some());
        }
        let events=contract.events.clone();let mut selector=Selector::new(contract).unwrap();
        for event in events {
            let selected=selector.event(event.id,17,||0.).unwrap();
            assert_eq!(selected.len(),event.actions.len());
            let resolved=cache.resolve(&selected,&assets).unwrap();
            assert_eq!(resolved.len(),selected.len());
            for (r,s) in resolved.iter().zip(selected) {assert_eq!(r.selection,s);}
        }
    }
    #[test] fn missing_or_removed_asset_rejects_the_batch_without_substitution() {
        let (mut assets,mut cache)=catalog();
        let contract=ambient_contract().unwrap();let mut selector=Selector::new(contract.clone()).unwrap();
        let selected=selector.event(contract.events[1].id,17,||0.).unwrap();
        assert_eq!(selected.len(),2);
        let id=selected[1].source;let handle=cache.sources.remove(&id).unwrap();
        assert_eq!(cache.resolve(&selected,&assets).err(),Some(ResolveError::MissingSource(id)));
        cache.sources.insert(id,handle.clone());assets.remove(handle.id());
        assert_eq!(cache.resolve(&selected,&assets).err(),Some(ResolveError::UnloadedAsset(id)));
        assert!(cache.resolve(&[],&assets).unwrap().is_empty());
    }
}

/// A dispatched action keeps scheduling and owner identity even when probability
/// suppresses its sound. Resolution does not allocate a playing ID.
pub struct ResolvedExecution {
    pub execution: openleague_core::audio_action_dispatch::Execution,
    pub audio: Option<Handle<PcmAudio>>,
}
impl AmbientPcm {
    pub fn resolve_executions(&self, executions:Vec<openleague_core::audio_action_dispatch::Execution>,
        assets:&Assets<PcmAudio>)->Result<Vec<ResolvedExecution>,ResolveError> {
        executions.into_iter().map(|execution| {
            let audio=match &execution.selection {
                None=>None,
                Some(selection)=> {
                    let handle=self.sources.get(&selection.source).ok_or(ResolveError::MissingSource(selection.source))?;
                    if assets.get(handle).is_none() {return Err(ResolveError::UnloadedAsset(selection.source));}
                    Some(handle.clone())
                }
            };
            Ok(ResolvedExecution {execution,audio})
        }).collect()
    }
}
#[cfg(test)] mod dispatch_resolution_tests {
    use super::*;
    use openleague_core::{audio_action_dispatch::Dispatcher,audio_random::NativeRandom,
        audio_object_registration::{Registry,RegisterCommand},audio_selection::ambient_contract};
    #[test] fn registered_bank_dispatch_reaches_pcm_without_losing_execution_identity() {
        let mut assets=Assets::default();
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets");
        let cache=populate(&mut assets,|p|std::fs::read(root.join(p.replace('\\',"/"))).map_err(|e|e.to_string()));
        assert!(cache.errors.is_empty());
        let contract=ambient_contract().unwrap();let events=contract.events.clone();
        let mut dispatcher=Dispatcher::new(contract).unwrap();let mut rng=NativeRandom::seeded(17);
        let mut registry=Registry::default();
        assert!(registry.register(RegisterCommand {object_id:123,listener_mask:1,extra_raw:0}, |_|Some(0)));
        let mut selected_execution=None;
        for event in events {
            let executions=dispatcher.post_registered_event(&registry,123,event.id,77,9,&mut rng).unwrap();
            let resolved=cache.resolve_executions(executions,&assets).unwrap();
            assert_eq!(resolved.len(),event.actions.len());
            for (r,a) in resolved.iter().zip(&event.actions) {
                assert_eq!(r.execution.event,event.id);assert_eq!(r.execution.action,a.id);
                assert_eq!(r.execution.owner,77);assert_eq!(r.execution.remainder,0);
                if let Some(selection)=&r.execution.selection {
                    assert_eq!(r.audio.as_ref().unwrap(),&cache.sources[&selection.source]);
                    assert!(assets.get(r.audio.as_ref().unwrap()).unwrap().decoder().next().is_some());
                } else {assert!(r.audio.is_none());}
            }
            for r in resolved {if r.execution.selection.is_some() {selected_execution=Some(r.execution);}}
        }
        let silent=openleague_core::audio_action_dispatch::Execution {event:1,action:2,owner:77,remainder:511,selection:None};
        let resolved=cache.resolve_executions(vec![silent],&assets).unwrap();
        assert!(resolved[0].audio.is_none());assert_eq!(resolved[0].execution.remainder,511);
        let execution=selected_execution.expect("actual bank selected at least one sound");
        let source=execution.selection.as_ref().unwrap().source;
        let executions=vec![execution];
        assets.remove(cache.sources[&source].id());
        assert_eq!(cache.resolve_executions(executions,&assets).err(),Some(ResolveError::UnloadedAsset(source)));
    }
}

#[cfg(test)] mod seek_tests {
 use super::*;
 #[test] fn seek_discards_buffered_samples_preserves_stereo_and_resumes_after_end(){
  let pcm=Arc::new(Pcm{sample_rate:4,channels:2,samples:vec![0.,1.,2.,3.,4.,5.,6.,7.]});
  let asset=PcmAudio::new(pcm,NonZeroU16::new(2).unwrap()).unwrap();let mut decoder=asset.decoder();
  assert_eq!(decoder.next(),Some(0.)); // leaves both read-ahead and half a stereo frame
  decoder.try_seek(Duration::from_millis(1250)).unwrap();assert_eq!(decoder.by_ref().collect::<Vec<_>>(),[3.,4.,5.,6.,7.]);
  decoder.try_seek(Duration::from_millis(500)).unwrap();assert_eq!(decoder.next(),Some(4.));assert_eq!(decoder.next(),Some(5.));
  decoder.try_seek(Duration::MAX).unwrap();assert_eq!(decoder.next(),None);
  decoder.try_seek(Duration::ZERO).unwrap();assert_eq!(decoder.collect::<Vec<_>>(),[0.,1.,2.,3.,4.,5.,6.,7.,0.,1.,2.,3.,4.,5.,6.,7.]);
 }
 #[test] fn seek_exact_duration_ends_even_when_duration_rounds_fractional_frame_time(){
  let pcm=Arc::new(Pcm{sample_rate:44100,channels:1,samples:vec![0.25;7]});let asset=PcmAudio::new(pcm,NonZeroU16::new(1).unwrap()).unwrap();
  let mut decoder=asset.decoder();decoder.try_seek(decoder.total_duration().unwrap()).unwrap();assert_eq!(decoder.next(),None);
  decoder.try_seek(Duration::from_nanos(1)).unwrap();assert_eq!(decoder.next(),Some(0.25));
 }
}

#[cfg(test)] mod transport_notification_tests {
 use super::*;
 fn source()->PcmAudio {PcmAudio::new(Arc::new(Pcm {sample_rate:4,channels:2,samples:vec![0.,1.,2.,3.]}),NonZeroU16::new(2).unwrap()).unwrap()}
 #[test] fn read_ahead_does_not_signal_end_before_last_interleaved_sample() {
  let (asset,rx)=source().observed();assert!(rx.try_recv().is_err());
  let mut decoder=asset.decoder();assert_eq!(rx.recv().unwrap(),TransportEvent {decoder:1,state:TransportState::Created});
  for expected in [0.,1.,2.,3.,0.,1.,2.] {assert_eq!(decoder.next(),Some(expected));assert!(rx.try_recv().is_err());}
  assert_eq!(decoder.next(),Some(3.));assert_eq!(rx.recv().unwrap().state,TransportState::Exhausted);
  assert_eq!(decoder.next(),None);assert_eq!(decoder.next(),None);assert!(rx.try_recv().is_err());
  drop(decoder);assert_eq!(rx.recv().unwrap().state,TransportState::Dropped {exhausted:true});assert!(rx.try_recv().is_err());
 }
 #[test] fn cloned_assets_have_distinct_decoder_lifetimes_across_threads() {
  let (asset,rx)=source().observed();let mut first=asset.decoder();assert_eq!(first.next(),Some(0.));
  let cloned=asset.clone();std::thread::spawn(move ||assert_eq!(cloned.decoder().count(),8)).join().unwrap();
  drop(first);
  let events:Vec<_>=rx.try_iter().collect();
  assert_eq!(events,vec![TransportEvent {decoder:1,state:TransportState::Created},TransportEvent {decoder:2,state:TransportState::Created},TransportEvent {decoder:2,state:TransportState::Exhausted},TransportEvent {decoder:2,state:TransportState::Dropped {exhausted:true}},TransportEvent {decoder:1,state:TransportState::Dropped {exhausted:false}}]);
 }
 #[test] fn seek_rearms_exhaustion_and_disconnected_receiver_is_safe() {
  let (asset,rx)=source().observed();let mut decoder=asset.decoder();rx.recv().unwrap();
  decoder.try_seek(Duration::MAX).unwrap();
  assert_eq!(rx.recv().unwrap().state,TransportState::Seek {frame:4});assert_eq!(rx.recv().unwrap().state,TransportState::Exhausted);
  decoder.try_seek(Duration::ZERO).unwrap();assert_eq!(rx.recv().unwrap().state,TransportState::Seek {frame:0});
  assert_eq!(decoder.by_ref().count(),8);assert_eq!(rx.recv().unwrap().state,TransportState::Exhausted);
  drop(rx);decoder.try_seek(Duration::ZERO).unwrap();assert_eq!(decoder.next(),Some(0.));drop(decoder);
 }
}

#[cfg(test)] mod filtered_transport_tests {
 use super::*;
 #[test] fn native_first_blocks_reach_interleaved_decoder_without_channel_crosstalk() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_filter_retarget_contract.json")).unwrap();let mut checked=0;
  for case in proof["cases"].as_array().unwrap() {
   let step=&case["steps"][0];let frames=step["frames"].as_u64().unwrap() as usize;assert_eq!(frames,3);
   let capacity=step["capacity"].as_u64().unwrap() as usize;
   let input:Vec<f32>=(0..frames).flat_map(|f|(0..2).map(move |ch|step["input"][ch*capacity+f].as_f64().unwrap() as f32)).collect();
   let expected:Vec<f32>=(0..frames).flat_map(|f|(0..2).map(move |ch|step["output"][ch*capacity+f].as_f64().unwrap() as f32)).collect();
   let asset=PcmAudio::new(Arc::new(Pcm {sample_rate:case["sample_rate"].as_u64().unwrap() as u32,channels:2,samples:input}),NonZeroU16::new(1).unwrap()).unwrap();
   let filtered=asset.filtered(step["raw_control"].as_f64().unwrap() as f32,case["initial"]["mode_raw"].as_u64().unwrap() as u8,capacity).unwrap();
   let mut decoder=filtered.decoder();let actual:Vec<_>=decoder.by_ref().collect();
   assert_eq!(actual.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected.iter().map(|v|v.to_bits()).collect::<Vec<_>>());assert_eq!(decoder.failure(),None);checked+=1;
  }
  assert!(checked>0);
 }
 #[test] fn filter_histories_are_per_decoder_and_seek_rejection_preserves_playback() {
  let asset=PcmAudio::new(Arc::new(Pcm {sample_rate:44100,channels:2,samples:(0..1030).map(|n|if n%2==0 {0.25}else{-0.5}).collect()}),NonZeroU16::new(2).unwrap()).unwrap().filtered(40.,0,128).unwrap();
  let reference:Vec<_>=asset.decoder().collect();assert_eq!(reference.len(),2060);
  let mut a=asset.decoder();let mut b=asset.decoder();assert_eq!(a.next(),Some(reference[0]));assert!(a.try_seek(Duration::ZERO).unwrap_err().source_intact());
  assert_eq!(a.collect::<Vec<_>>(),reference[1..]);assert_eq!(b.by_ref().collect::<Vec<_>>(),reference);assert_eq!(b.failure(),None);
  assert!(asset.filtered(f32::NAN,0,128).is_err());assert!(asset.filtered(0.,0,0).is_err());
 }
}

#[cfg(test)] mod filter_control_transport_tests {
 use super::*;
 #[test] fn native_retarget_reset_and_bypass_sequences_reach_decoder() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_filter_retarget_contract.json")).unwrap();let mut blocks=0;
  for case in proof["cases"].as_array().unwrap().iter().filter(|c|c["alignment_bytes"]==0) {
   let mut samples=Vec::new();
   for step in case["steps"].as_array().unwrap() {let frames=step["frames"].as_u64().unwrap() as usize;let cap=step["capacity"].as_u64().unwrap() as usize;for frame in 0..frames {for ch in 0..2 {samples.push(step["input"][ch*cap+frame].as_f64().unwrap() as f32);}}}
   let source=PcmAudio::new(Arc::new(Pcm {sample_rate:case["sample_rate"].as_u64().unwrap() as u32,channels:2,samples}),NonZeroU16::new(1).unwrap()).unwrap();
   let (asset,control)=source.controlled_filter(0.,1,6).unwrap();let mut decoder=asset.decoder();
   for step in case["steps"].as_array().unwrap() {
    let frames=step["frames"].as_u64().unwrap() as usize;let cap=step["capacity"].as_u64().unwrap() as usize;
    control.set(step["raw_control"].as_f64().unwrap() as f32).unwrap();if step["reset"].as_bool().unwrap() {control.reset().unwrap();}
    // Native fixtures vary buffer geometry each pass; drive the real decoder
    // with that geometry, retaining the same transport and filter ownership.
    assert_eq!(decoder.position,decoder.available);
    decoder.buffer.resize(frames*2,0.);let filter=decoder.filter.as_mut().unwrap();filter.capacity=cap;filter.planar.resize(cap*2,0.);
    if frames==0 {continue;}
    let actual:Vec<_>=decoder.by_ref().take(frames*2).collect();assert_eq!(actual.len(),frames*2);
    let expected:Vec<f32>=(0..frames).flat_map(|f|(0..2).map(move |ch|step["output"][ch*cap+f].as_f64().unwrap() as f32)).collect();
    assert_eq!(actual.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),"native frame count {frames}");
    assert_eq!(decoder.failure(),None);let filter=decoder.filter.as_ref().unwrap();
    let state:openleague_core::audio_filter_transition::State=serde_json::from_value(step["state"].clone()).unwrap();assert_eq!(filter.controller.state(),state);
    let expected_history:Vec<f32>=step["history"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect();
    assert_eq!(filter.controller.history().iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_history.iter().map(|v|v.to_bits()).collect::<Vec<_>>());blocks+=1;
   }
  }
  assert_eq!(blocks,51);
 }
 #[test] fn cross_thread_updates_preserve_read_ahead_and_separate_voice_controls() {
  let source=PcmAudio::new(Arc::new(Pcm {sample_rate:44100,channels:2,samples:vec![0.25,-0.5,0.5,-0.25,0.75,-0.75]}),NonZeroU16::new(1).unwrap()).unwrap();
  let (asset,control)=source.controlled_filter(0.,0,2).unwrap();let mut decoder=asset.decoder();assert_eq!(decoder.next(),Some(0.25));
  let writer=control.clone();std::thread::spawn(move ||{writer.set(80.).unwrap();writer.reset().unwrap();}).join().unwrap();
  for expected in [-0.5,0.5,-0.25] {assert_eq!(decoder.next(),Some(expected));}
  assert_ne!(decoder.next(),Some(0.75));assert_eq!(decoder.filter.as_ref().unwrap().controller.state().current,80.);
  assert!(control.set(f32::NAN).is_err());assert_eq!(control.snapshot(),(80.,1));
  let (other,other_control)=source.controlled_filter(0.,0,2).unwrap();assert_eq!(other_control.snapshot(),(0.,0));assert_eq!(other.decoder().collect::<Vec<_>>(),source.decoder().collect::<Vec<_>>());
 }
}
