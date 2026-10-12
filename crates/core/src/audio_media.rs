//! Decoded asset transport for verified ambient WAVs, not a native mixer.
//! PCM16 conversion retains interleaved channel order and the source sample rate.
#[derive(Debug, PartialEq, Eq)]
pub enum Error { Truncated, InvalidRiff, UnsupportedFormat, DuplicateChunk, MissingChunk, InvalidAlignment }
#[derive(Debug)]
pub struct Pcm { pub sample_rate:u32, pub channels:u16, pub samples:Vec<f32> }
impl Pcm { pub fn frames(&self)->usize {self.samples.len()/usize::from(self.channels)} }
/// Finite, full-clip transport over decoded PCM. It preserves source rate and
/// interleaved channels; scheduling, partial loops and resampling belong upstream.
pub struct Playback<P:std::borrow::Borrow<Pcm>> { pcm:P, sample:usize, plays_left:u16, plays_total:u16 }
#[derive(Debug,PartialEq,Eq)]
pub enum PlaybackError { InvalidPcm, UnalignedOutput }
#[derive(Debug,PartialEq,Eq)]
pub struct ReadBlock { pub frames:usize, pub finished:bool }
impl Pcm {
    pub fn playback(&self,plays:std::num::NonZeroU16)->Result<Playback<&'_ Pcm>,PlaybackError> {
        let channels=usize::from(self.channels);
        if channels==0 || channels>8 || self.sample_rate==0 || self.samples.is_empty()
            || self.samples.len()%channels!=0 || self.samples.iter().any(|x|!x.is_finite()) {
            return Err(PlaybackError::InvalidPcm);
        }
        Ok(Playback {pcm:self,sample:0,plays_left:plays.get(),plays_total:plays.get()})
    }
}
/// Shared immutable PCM keeps decoder instances independent without copying clips.
pub fn shared_playback(pcm:std::sync::Arc<Pcm>,plays:std::num::NonZeroU16)->Result<Playback<std::sync::Arc<Pcm>>,PlaybackError> {
    pcm.playback(plays)?;
    Ok(Playback {pcm,sample:0,plays_left:plays.get(),plays_total:plays.get()})
}
impl<P:std::borrow::Borrow<Pcm>> Playback<P> {
    pub fn finished(&self)->bool {self.plays_left==0}
    /// Absolute frame cursor over finite full-clip repetitions. Device transport
    /// only: native event seek selection, marker and loop policies belong upstream.
    pub fn seek_frame(&mut self,frame:u128)->u128 {
        let pcm=self.pcm.borrow();let frames=pcm.frames() as u128;
        let total=frames*u128::from(self.plays_total);let frame=frame.min(total);
        if frame==total {self.plays_left=0;self.sample=0;}
        else {
            self.plays_left=self.plays_total-(frame/frames) as u16;
            self.sample=(frame%frames) as usize*usize::from(pcm.channels);
        }
        frame
    }
    pub fn position_frames(&self)->u128 {
        let pcm=self.pcm.borrow();
        u128::from(self.plays_total-self.plays_left)*pcm.frames() as u128+(self.sample/usize::from(pcm.channels)) as u128
    }

    /// Writes complete interleaved frames and silences the unused tail.
    /// No allocation, conversion or resampling occurs in this read operation.
    pub fn read(&mut self,output:&mut [f32])->Result<ReadBlock,PlaybackError> {
        let pcm=self.pcm.borrow();
        let channels=usize::from(pcm.channels);
        if output.len()%channels!=0 {return Err(PlaybackError::UnalignedOutput);}
        let mut written=0;
        while written<output.len() && self.plays_left!=0 {
            let count=(output.len()-written).min(pcm.samples.len()-self.sample);
            output[written..written+count].copy_from_slice(&pcm.samples[self.sample..self.sample+count]);
            written+=count;self.sample+=count;
            if self.sample==pcm.samples.len() {self.sample=0;self.plays_left-=1;}
        }
        output[written..].fill(0.);
        Ok(ReadBlock {frames:written/channels,finished:self.finished()})
    }
}
fn u16le(b:&[u8])->u16 {u16::from_le_bytes(b[..2].try_into().unwrap())}
fn u32le(b:&[u8])->u32 {u32::from_le_bytes(b[..4].try_into().unwrap())}
pub fn decode(bytes:&[u8])->Result<Pcm,Error> {
    if bytes.len()<12 {return Err(Error::Truncated);}
    if &bytes[..4]!=b"RIFF" || &bytes[8..12]!=b"WAVE" {return Err(Error::InvalidRiff);}
    let end=(u32le(&bytes[4..8]) as usize).checked_add(8).ok_or(Error::Truncated)?;
    if end>bytes.len() {return Err(Error::Truncated);}
    if end!=bytes.len() || end<12 {return Err(Error::InvalidRiff);}
    let mut cursor=12usize;let mut format=None;let mut data=None;
    while cursor<end {
        if end-cursor<8 {return Err(Error::Truncated);}
        let size=u32le(&bytes[cursor+4..cursor+8]) as usize;
        let start=cursor+8;let stop=start.checked_add(size).ok_or(Error::Truncated)?;
        if stop>end {return Err(Error::Truncated);}
        let chunk=&bytes[start..stop];
        match &bytes[cursor..cursor+4] {
            b"fmt "=> {if format.replace(chunk).is_some(){return Err(Error::DuplicateChunk);}},
            b"data"=> {if data.replace(chunk).is_some(){return Err(Error::DuplicateChunk);}},
            _=>{},
        }
        cursor=stop.checked_add(size&1).ok_or(Error::Truncated)?;
        if cursor>end {return Err(Error::Truncated);}
    }
    let f=format.ok_or(Error::MissingChunk)?;let data=data.ok_or(Error::MissingChunk)?;
    if f.len()<16 {return Err(Error::Truncated);}
    let channels=u16le(&f[2..]);let rate=u32le(&f[4..]);let align=u16le(&f[12..]);
    if u16le(f)!=1 || u16le(&f[14..])!=16 || channels==0 || channels>8 || rate==0 {return Err(Error::UnsupportedFormat);}
    if align!=channels*2 || rate.checked_mul(u32::from(align))!=Some(u32le(&f[8..])) || data.len()%usize::from(align)!=0 {return Err(Error::InvalidAlignment);}
    let samples=data.chunks_exact(2).map(|b|i16::from_le_bytes([b[0],b[1]]) as f32 / 32768.).collect();
    Ok(Pcm {sample_rate:rate,channels,samples})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_verified_ambient_media_decode_with_original_frame_counts() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let m:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/ambient_audio_manifest.json")).unwrap();
        let media=m["media"].as_array().unwrap();assert_eq!(media.len(),31);
        for row in media {
            let path=root.join("assets").join(row["wav"].as_str().unwrap().replace('\\',"/"));
            let bytes=std::fs::read(path).unwrap();let pcm=decode(&bytes).unwrap();
            assert_eq!(pcm.frames() as u64,row["frames"].as_u64().unwrap());
            assert_eq!(u64::from(pcm.sample_rate),row["sample_rate"].as_u64().unwrap());
            assert_eq!(u64::from(pcm.channels),row["channels"].as_u64().unwrap());
            assert!(pcm.samples.iter().all(|v|v.is_finite() && *v>=-1. && *v<1.));
            assert!(pcm.samples.iter().any(|v|*v!=0.));
            assert_eq!(decode(&bytes[..bytes.len()-1]).unwrap_err(),Error::Truncated);
        }
    }
    fn wav()->Vec<u8> {
        let mut b=b"RIFF".to_vec();b.extend(44u32.to_le_bytes());b.extend(b"WAVEfmt ");b.extend(16u32.to_le_bytes());
        for v in [1u16,2] {b.extend(v.to_le_bytes());}b.extend(44100u32.to_le_bytes());b.extend(176400u32.to_le_bytes());
        for v in [4u16,16] {b.extend(v.to_le_bytes());}b.extend(b"data");b.extend(8u32.to_le_bytes());
        for v in [i16::MIN,i16::MAX,0,16384] {b.extend(v.to_le_bytes());}b
    }
    #[test] fn signed_endpoints_channel_order_and_malformed_headers() {
        let b=wav();let p=decode(&b).unwrap();assert_eq!(p.samples,[-1.,32767./32768.,0.,0.5]);assert_eq!(p.frames(),2);
        let mut bad=b.clone();bad[20]=3;assert_eq!(decode(&bad).unwrap_err(),Error::UnsupportedFormat);
        let mut bad=b.clone();bad[32]=2;assert_eq!(decode(&bad).unwrap_err(),Error::InvalidAlignment);
        let mut bad=b.clone();bad[40..44].copy_from_slice(&100u32.to_le_bytes());assert_eq!(decode(&bad).unwrap_err(),Error::Truncated);
        let mut bad=b;bad.push(0);assert_eq!(decode(&bad).unwrap_err(),Error::InvalidRiff);
    }
}

#[cfg(test)] mod playback_tests {
    use super::*;
    use std::num::NonZeroU16;
    #[test] fn finite_transport_matches_all_qualified_media_and_repeat_lengths() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/ambient_audio_manifest.json")).unwrap();
        let native:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_vorbis_double_loop.json")).unwrap();
        for row in manifest["media"].as_array().unwrap() {
            let proof=native["cases"].as_array().unwrap().iter().find(|c|c["source_id"]==row["source_id"]).unwrap();
            assert_eq!(proof["final_status"],17);assert!(proof["max_difference_pcm16"].as_u64().unwrap()<=1);
            let pcm=decode(&std::fs::read(root.join("assets").join(row["wav"].as_str().unwrap().replace('\\',"/"))).unwrap()).unwrap();
            for plays in [1u16,2] {
                let mut playback=pcm.playback(NonZeroU16::new(plays).unwrap()).unwrap();
                let mut block=vec![9.;997*usize::from(pcm.channels)];let mut written=0;
                loop {
                    let result=playback.read(&mut block).unwrap();let count=result.frames*usize::from(pcm.channels);
                    for (i,value) in block[..count].iter().enumerate() {assert_eq!(value.to_bits(),pcm.samples[(written+i)%pcm.samples.len()].to_bits());}
                    assert!(block[count..].iter().all(|x|*x==0.));written+=count;
                    if result.finished {break;}
                }
                assert_eq!(written,pcm.samples.len()*usize::from(plays));
                assert_eq!(playback.read(&mut block).unwrap(),ReadBlock {frames:0,finished:true});assert!(block.iter().all(|x|*x==0.));
            }
        }
    }
    #[test] fn stereo_boundaries_empty_reads_and_errors_preserve_state() {
        let pcm=Pcm {sample_rate:44100,channels:2,samples:vec![0.1,0.2,0.3,0.4]};
        let mut p=pcm.playback(NonZeroU16::new(2).unwrap()).unwrap();
        assert_eq!(p.read(&mut []).unwrap(),ReadBlock {frames:0,finished:false});
        let mut bad=[7.;3];assert_eq!(p.read(&mut bad),Err(PlaybackError::UnalignedOutput));assert_eq!(bad,[7.;3]);
        let mut block=[0.;6];assert_eq!(p.read(&mut block).unwrap(),ReadBlock {frames:3,finished:false});assert_eq!(block,[0.1,0.2,0.3,0.4,0.1,0.2]);
        assert_eq!(p.read(&mut block).unwrap(),ReadBlock {frames:1,finished:true});assert_eq!(block,[0.3,0.4,0.,0.,0.,0.]);
        let invalid=Pcm {sample_rate:44100,channels:0,samples:vec![]};assert!(matches!(invalid.playback(NonZeroU16::new(1).unwrap()),Err(PlaybackError::InvalidPcm)));
    }
}

#[cfg(test)] mod seek_tests {
 use super::*;use std::{num::NonZeroU16,sync::Arc};
 #[test] fn seeking_actual_media_preserves_channels_loop_count_and_end(){
  let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
  let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/ambient_audio_manifest.json")).unwrap();
  for row in manifest["media"].as_array().unwrap(){
   let pcm=Arc::new(decode(&std::fs::read(root.join("assets").join(row["wav"].as_str().unwrap().replace('\\',"/"))).unwrap()).unwrap());
   let frames=pcm.frames() as u128;let channels=usize::from(pcm.channels);let total=frames*2;
   let mut playback=shared_playback(pcm.clone(),NonZeroU16::new(2).unwrap()).unwrap();
   for requested in [0,frames/2,frames-1,frames,frames+1,total-1,total,total+1,u128::MAX,0]{
    let start=requested.min(total);assert_eq!(playback.seek_frame(requested),start);assert_eq!(playback.position_frames(),start);
    let mut output=vec![99.;channels*3];let result=playback.read(&mut output).unwrap();let count=(total-start).min(3) as usize;
    assert_eq!(result.frames,count);assert_eq!(result.finished,start+count as u128==total);
    for frame in 0..count{for channel in 0..channels{assert_eq!(output[frame*channels+channel].to_bits(),pcm.samples[((start+frame as u128)%frames) as usize*channels+channel].to_bits());}}
    assert!(output[count*channels..].iter().all(|&x|x==0.));assert_eq!(playback.position_frames(),start+count as u128);
   }
  }
 }
 #[test] fn seek_one_shared_cursor_does_not_change_another(){
  let pcm=Arc::new(Pcm{sample_rate:3,channels:2,samples:vec![0.,1.,2.,3.,4.,5.]});
  let mut first=shared_playback(pcm.clone(),NonZeroU16::new(2).unwrap()).unwrap();let mut other=shared_playback(pcm,NonZeroU16::new(2).unwrap()).unwrap();
  first.seek_frame(4);let mut out=[0.;2];first.read(&mut out).unwrap();assert_eq!(out,[2.,3.]);other.read(&mut out).unwrap();assert_eq!(out,[0.,1.]);assert_eq!(other.position_frames(),1);
 }
}
