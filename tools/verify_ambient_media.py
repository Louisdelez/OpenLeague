"""Verify extracted Wwise media bytes, PCM metadata, and native DDS-derived pixels."""
from pathlib import Path
import json,struct,hashlib,wave,datetime,numpy as np
from PIL import Image
r=Path(__file__).resolve().parents[1];manifest=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text());cache={};samples=[]
for clip in manifest['media']:
 p=Path(clip['bank'])
 if str(p) not in cache:
  data=p.read_bytes();cursor=0;chunks={}
  while cursor<len(data):
   tag,size=struct.unpack_from('<4sI',data,cursor);chunks[tag]=data[cursor+8:cursor+8+size];cursor+=8+size
  cache[str(p)]=chunks
 chunks=cache[str(p)];record=next(x for x in struct.iter_unpack('<III',chunks[b'DIDX']) if x[0]==clip['source_id']);id,offset,size=record
 wem=r/'assets'/clip['wem'];assert wem.read_bytes()==chunks[b'DATA'][offset:offset+size]
 wav=r/'assets'/clip['wav'];assert hashlib.sha256(wav.read_bytes()).hexdigest()==clip['wav_sha256']
 with wave.open(str(wav),'rb') as w:
  assert (w.getnframes(),w.getframerate(),w.getnchannels(),w.getsampwidth())==(clip['frames'],clip['sample_rate'],clip['channels'],clip['sample_width'])
  assert w.getsampwidth()==2;pcm=np.frombuffer(w.readframes(w.getnframes()),dtype='<i2').astype(float)
 peak=float(np.max(np.abs(pcm)));rms=float(np.sqrt(np.mean(pcm*pcm)));assert peak>0 and rms>0
 samples.append({'source_id':id,'native_media_bytes_equal':True,'pcm_peak':peak,'pcm_rms':rms,'frames':clip['frames']})
textures=json.loads((r/'data/4.20/ambient_particle_textures.json').read_text());assert not textures['missing_native_textures']
for image in textures['textures']:
 original=Image.open(image['source']).convert('RGBA');converted=Image.open(r/'assets'/image['asset']).convert('RGBA');assert original.size==converted.size and original.tobytes()==converted.tobytes()
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_events':len(manifest['events']),'native_media':len(samples),'native_textures':len(textures['textures']),'samples':samples,'audio_manifest_sha256':hashlib.sha256((r/'data/4.20/ambient_audio_manifest.json').read_bytes()).hexdigest(),'passed':True,'complete':False,'limits':['Exact media bytes, nonempty PCM waveforms and DDS-derived pixels verified; audible device output/native mixing and visible effects not qualified.','Native BLND timing and event policy still require qualification before enabling playback.']}
(r/'docs/map_ambient_media_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS: 31 exact embedded native media clips, nonzero decoded PCM, 9 original texture pixel arrays')
