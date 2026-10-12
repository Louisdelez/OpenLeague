"""Recover exact media dependencies while retaining native Wwise selection graph."""
from pathlib import Path
import json,struct,hashlib,datetime,xml.etree.ElementTree as ET,subprocess,wave
r=Path(__file__).resolve().parents[1];deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');banks=deploy/'DATA/Sounds/Wwise/SFX/Shared';decoder=Path('E:/mapslol3v3/tools/vgmstream/vgmstream-cli.exe');out=r/'assets/audio/ambient';out.mkdir(exist_ok=True)
particles=[]
for p in sorted((r/'data/4.20/particles').glob('*.json')):
 d=json.loads(p.read_text());system=d['sections'].get('System',{})
 for policy in ['SoundOnCreate','SoundPersistent']:
  if policy in system:particles.append({'particle':p.name,'policy':policy,'event_name':system[policy]})
roots=[('ENV_Map10_SFX',(r/'docs/ambient_env_banks.xml')),('NPC_Map10_SFX',Path('E:/mapslol3v3/output/Map_Completion/npc_map10.xml'))];graphs={};media={};bank_proofs=[]
for family,xmlpath in roots:
 xml=ET.fromstring('<banks>'+xmlpath.read_text(encoding='utf-8')+'</banks>');objects={}
 for xmlbank in xml.findall('./root'):
  native_path=Path(xmlbank.get('path'))/xmlbank.get('filename');native_bytes=native_path.read_bytes()
  for node in xmlbank.findall('./object/list/object'):
   f=node.find("field[@name='ulID']")
   if f is not None:
    # Check actual HIRC identity and dependency IDs at parser-reported byte offsets.
    checked=0
    for field in node.findall('.//field'):
     if field.get('name') in {'ulID','sourceID','ulActionID','idExt','ulChildID','ulPlayID','ulNodeID'} and field.get('offset') is not None:
      offset=int(field.get('offset'));assert offset+4<=len(native_bytes)
      assert struct.unpack_from('<I',native_bytes,offset)[0]==int(field.get('value'))
      checked+=1
    node.set('native_bank',str(native_path));node.set('dependency_ids_byte_checked',str(checked));objects[int(f.get('value'))]=node
 graphs[family]=objects
 for suffix in ['events','audio']:
  p=banks/(family+'_'+suffix+'.bnk');raw=p.read_bytes();chunks={};cursor=0
  while cursor<len(raw):
   assert cursor+8<=len(raw);tag,size=struct.unpack_from('<4sI',raw,cursor);assert cursor+8+size<=len(raw);assert tag not in chunks;chunks[tag]=raw[cursor+8:cursor+8+size];cursor+=8+size
  bank_proofs.append({'path':str(p),'sha256':hashlib.sha256(raw).hexdigest(),'version':struct.unpack_from('<I',chunks[b'BKHD'])[0],'xml':str(xmlpath),'xml_sha256':hashlib.sha256(xmlpath.read_bytes()).hexdigest()})
  if b'DIDX' in chunks:
   for id,offset,size in struct.iter_unpack('<III',chunks[b'DIDX']):
    assert offset+size<=len(chunks[b'DATA']);blob=chunks[b'DATA'][offset:offset+size]
    if id in media:assert media[id]['blob']==blob,'Conflicting media ID'
    media[id]={'bank':str(p),'blob':blob,'bank_data_offset':offset,'byte_count':size}
def fnv(name):
 h=2166136261
 for b in name.lower().encode('ascii'):h=((h*16777619)&0xffffffff)^b
 return h
edges={'ulActionID','idExt','ulChildID','ulPlayID','ulNodeID'};events=[];used=set()
for particle in particles:
 name=particle['event_name'];family='NPC_Map10_SFX' if 'shopkeeper' in name.lower() else 'ENV_Map10_SFX';objects=graphs[family];id=fnv(name);assert id in objects and objects[id].get('name')=='CAkEvent'
 nodes=[];sources=set();seen=set();missing=[]
 def visit(key):
  if key in seen:return
  seen.add(key)
  node=objects.get(key)
  if node is None:missing.append(key);return
  fields=[{k:v for k,v in f.attrib.items()} for f in node.findall('.//field')];refs=[]
  for field in fields:
   if field.get('name')=='sourceID':sources.add(int(field['value']))
   if field.get('name') in edges:refs.append(int(field['value']))
  nodes.append({'id':key,'native_type':node.get('name'),'native_bank':node.get('native_bank'),'dependency_ids_byte_checked':int(node.get('dependency_ids_byte_checked')),'fields':fields,'references':refs})
  for ref in refs:visit(ref)
 visit(id);assert sources,(name,'no media reached');used|=sources
 events.append({**particle,'event_id':id,'bank_family':family,'source_ids':sorted(sources),'native_graph':nodes,'unresolved_graph_references':sorted(set(missing)),'native_dependency_ids_verified':sum(n['dependency_ids_byte_checked'] for n in nodes),'native_graph_semantics_qualified':False})
# Shared native media can live in another bank; resolve IDs from DIDX without
# loading every audio bank or replacing missing clips.
missing_media=used-set(media)
for bank in sorted(banks.glob('*.bnk')):
 if not missing_media:break
 with bank.open('rb') as stream:
  size=bank.stat().st_size;index=None;data_offset=None
  while stream.tell()<size:
   header=stream.read(8);assert len(header)==8
   tag,count=struct.unpack('<4sI',header);offset=stream.tell();assert offset+count<=size
   if tag==b'DIDX':index=stream.read(count)
   elif tag==b'DATA':data_offset=offset;stream.seek(count,1)
   else:stream.seek(count,1)
  if index is None or data_offset is None:continue
  found=[]
  for id,offset,count in struct.iter_unpack('<III',index):
   if id not in missing_media:continue
   stream.seek(data_offset+offset);blob=stream.read(count);assert len(blob)==count
   media[id]={'bank':str(bank),'blob':blob,'bank_data_offset':offset,'byte_count':count};found.append(id)
  if found:
   bank_proofs.append({'path':str(bank),'sha256':hashlib.sha256(bank.read_bytes()).hexdigest(),'shared_media_ids':found,'resolution':'Exact DIDX media IDs referenced by native sound objects'})
   missing_media-=set(found)
assert not missing_media,('Unresolved native media IDs',sorted(missing_media))
clips=[]
for id in sorted(used):
 assert id in media,('missing media',id);entry=media[id];wem=out/(str(id)+'.wem');wav=out/(str(id)+'.wav');wem.write_bytes(entry['blob'])
 completed=subprocess.run([str(decoder),'-i','-o',str(wav),str(wem)],capture_output=True,text=True);assert completed.returncode==0,(id,completed.stderr)
 with wave.open(str(wav),'rb') as w:frames=w.getnframes();rate=w.getframerate();channels=w.getnchannels();width=w.getsampwidth()
 assert frames>0 and rate>0 and channels>0
 clips.append({'source_id':id,'bank':entry['bank'],'embedded_offset':entry['bank_data_offset'],'embedded_bytes':entry['byte_count'],'wem':str(wem.relative_to(r/'assets')),'wem_sha256':hashlib.sha256(wem.read_bytes()).hexdigest(),'wav':str(wav.relative_to(r/'assets')),'wav_sha256':hashlib.sha256(wav.read_bytes()).hexdigest(),'frames':frames,'sample_rate':rate,'channels':channels,'sample_width':width,'duration_seconds':frames/rate})
result={'banks':bank_proofs,'events':events,'media':clips,'decoder':str(decoder),'decoder_sha256':hashlib.sha256(decoder.read_bytes()).hexdigest(),'complete':False,'limits':['All event media dependencies recovered; no flat random clip choice replaces native Wwise selection/probability/action graph.','Native probability, timing, spatial attenuation, buses/mix/RTPC, persistent lifetime and original audible acceptance remain incomplete.','Decoded PCM preserves media content; native mixer/loop semantics are not applied to these WAVs.']}
(r/'data/4.20/ambient_audio_manifest.json').write_text(json.dumps(result,indent=2)+'\n')
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_events':len(events),'native_media':len(clips),'dependency_ids_byte_verified':sum(x['native_dependency_ids_verified'] for x in events),'recovered_pcm_frames':sum(x['frames'] for x in clips),'manifest_sha256':hashlib.sha256((r/'data/4.20/ambient_audio_manifest.json').read_bytes()).hexdigest(),'events':[{'name':x['event_name'],'event_id':x['event_id'],'source_ids':x['source_ids'],'graph_nodes':len(x['native_graph']),'unresolved_references':x['unresolved_graph_references']} for x in events],'banks':bank_proofs,'media':clips,'passed':True,'complete':False,'limits':result['limits']}
(r/'docs/map_ambient_audio_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('Recovered native ambient audio:',len(events),'events /',len(clips),'media clips')
