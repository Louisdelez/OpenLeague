"""Recover every announcer WPK/DIDX media; preserve original event objects."""
from pathlib import Path
import json,struct,hashlib,subprocess,wave,datetime
r=Path(__file__).resolve().parents[1];c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text(encoding='utf-8'));deploy=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy');sources=sorted((deploy/'DATA/Sounds/Wwise').rglob('*Announcer*'));out=r/'assets/audio/announcer';out.mkdir(parents=True,exist_ok=True);decoder=Path('E:/mapslol3v3/tools/vgmstream/vgmstream-cli.exe');assert decoder.is_file()
def sha(b):return hashlib.sha256(b).hexdigest()
source_proofs=[];media={};objects=[];events=[]
def add_media(id,blob,source,offset):
 entry=media.setdefault(id,{'blob':blob,'sources':[]});assert entry['blob']==blob,('conflicting media',id)
 entry['sources'].append({'path':str(source),'offset':offset,'bytes':len(blob)})
for p in sources:
 if not p.is_file():continue
 b=p.read_bytes();source_proofs.append({'path':str(p),'sha256':sha(b),'bytes':len(b)})
 if p.suffix=='.wpk':
  magic,version,count=struct.unpack_from('<4sII',b);assert magic==b'r3d2' and version==1;assert 12+4*count<=len(b)
  for a in struct.unpack_from('<'+'I'*count,b,12):
   assert a+12<=len(b);offset,size,n=struct.unpack_from('<III',b,a);assert a+12+2*n<=len(b);name=b[a+12:a+12+2*n].decode('utf-16-le').rstrip('\0');assert name.endswith('.wem') and name[:-4].isdigit();assert offset+size<=len(b)
   add_media(int(name[:-4]),b[offset:offset+size],p,offset)
 elif p.suffix=='.bnk':
  chunks={};cursor=0
  while cursor<len(b):
   assert cursor+8<=len(b);tag,size=struct.unpack_from('<4sI',b,cursor);assert cursor+8+size<=len(b) and tag not in chunks;chunks[tag]=(cursor+8,b[cursor+8:cursor+8+size]);cursor+=8+size
  assert struct.unpack_from('<I',chunks[b'BKHD'][1])[0]==88
  if b'DIDX' in chunks:
   data_offset,data=chunks[b'DATA']
   for id,offset,size in struct.iter_unpack('<III',chunks[b'DIDX'][1]):assert offset+size<=len(data);add_media(id,data[offset:offset+size],p,data_offset+offset)
  if b'HIRC' in chunks:
   base,data=chunks[b'HIRC'];count=struct.unpack_from('<I',data)[0];cursor=4
   for _ in range(count):
    type,size=struct.unpack_from('<BI',data,cursor);assert size>=4 and cursor+5+size<=len(data);payload=data[cursor+5:cursor+5+size];id=struct.unpack_from('<I',payload)[0];objects.append({'id':id,'type':type,'bank':str(p),'offset':base+cursor+5,'payload_hex':payload.hex()})
    if type==4:
     n=struct.unpack_from('<I',payload,4)[0];assert len(payload)==8+4*n;actions=list(struct.unpack_from('<'+'I'*n,payload,8));events.append({'id':id,'bank':str(p),'action_ids':actions})
    cursor+=5+size
   assert cursor==len(data)
clips=[]
for index,(id,entry) in enumerate(sorted(media.items()),1):
 wem=out/f'{id}.wem';wav=out/f'{id}.wav';wem.write_bytes(entry['blob'])
 result=subprocess.run([str(decoder),'-i','-o',str(wav),str(wem)],capture_output=True,text=True);assert result.returncode==0,(id,result.stderr)
 with wave.open(str(wav),'rb') as w:frames=w.getnframes();rate=w.getframerate();channels=w.getnchannels();width=w.getsampwidth()
 assert frames>0 and rate>0 and channels>0
 clips.append({'id':id,'sources':entry['sources'],'wem':str(wem.relative_to(r/'assets')),'wem_sha256':sha(entry['blob']),'wav':str(wav.relative_to(r/'assets')),'wav_sha256':sha(wav.read_bytes()),'frames':frames,'sample_rate':rate,'channels':channels,'sample_width':width,'duration_seconds':frames/rate})
 if index%25==0:print(f'Decoded {index}/{len(media)} announcer clips',flush=True)
manifest={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'sources':source_proofs,'events':events,'objects':objects,'media':clips,'decoder':str(decoder),'decoder_sha256':sha(decoder.read_bytes()),'passed':True,'complete':False,'limits':['All matching announcer archives present in supplied en_US client recovered; no absent languages invented.','Exact event identities/actions and opaque original HIRC payloads retained; dependency semantics, scheduling and selection remain unqualified.','PCM decoding verified; event-name correspondence, actual client mixer and audible playback still incomplete.']}
(r/'data/4.20/announcer_audio_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8');print(f'Recovered {len(clips)} clips / {len(events)} events / {len(objects)} HIRC objects from {len(source_proofs)} sources',flush=True)
