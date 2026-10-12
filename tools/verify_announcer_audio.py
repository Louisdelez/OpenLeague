"""Re-read original archives and recovered clips; validate all retained records."""
from pathlib import Path
import json,hashlib,struct,wave,datetime
r=Path(__file__).resolve().parents[1];p=r/'data/4.20/announcer_audio_manifest.json';m=json.loads(p.read_text(encoding='utf-8'));raw={}
def sha(b):return hashlib.sha256(b).hexdigest()
for source in m['sources']:
 b=Path(source['path']).read_bytes();assert len(b)==source['bytes'] and sha(b)==source['sha256'];raw[source['path']]=b
objects={}
for obj in m['objects']:
 b=bytes.fromhex(obj['payload_hex']);assert raw[obj['bank']][obj['offset']:obj['offset']+len(b)]==b;assert struct.unpack_from('<I',b)[0]==obj['id'];key=(obj['bank'],obj['id']);assert key not in objects;objects[key]=obj
references=0
for event in m['events']:
 obj=objects[(event['bank'],event['id'])];assert obj['type']==4;b=bytes.fromhex(obj['payload_hex']);count=struct.unpack_from('<I',b,4)[0];assert len(b)==8+4*count and list(struct.unpack_from('<'+'I'*count,b,8))==event['action_ids']
 for id in event['action_ids']:assert objects[(event['bank'],id)]['type']==3;references+=1
frames=0;pcm_bytes=0
for clip in m['media']:
 wem=(r/'assets'/clip['wem']).read_bytes();wav=r/'assets'/clip['wav'];assert sha(wem)==clip['wem_sha256'];assert sha(wav.read_bytes())==clip['wav_sha256']
 for source in clip['sources']:assert raw[source['path']][source['offset']:source['offset']+source['bytes']]==wem
 with wave.open(str(wav),'rb') as w:
  assert (w.getnframes(),w.getframerate(),w.getnchannels(),w.getsampwidth())==(clip['frames'],clip['sample_rate'],clip['channels'],clip['sample_width']);pcm=w.readframes(w.getnframes());assert len(pcm)==w.getnframes()*w.getnchannels()*w.getsampwidth();frames+=w.getnframes();pcm_bytes+=len(pcm)
assert sha(Path(m['decoder']).read_bytes())==m['decoder_sha256']
proof={'verified_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'manifest_sha256':sha(p.read_bytes()),'sources':len(m['sources']),'media':len(m['media']),'events':len(m['events']),'objects':len(m['objects']),'event_action_references':references,'decoded_frames':frames,'pcm_bytes':pcm_bytes,'passed':True,'complete':False,'limits':m['limits']}
(r/'docs/announcer_audio_verification.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
