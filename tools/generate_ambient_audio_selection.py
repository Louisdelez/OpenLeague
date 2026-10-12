from pathlib import Path
import json,hashlib,struct,xml.etree.ElementTree as E
r=Path(__file__).resolve().parents[1]
m=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text())
registry={}; banks={}
for b in m['banks']:
 if 'xml' not in b:continue
 for root in E.fromstring('<banks>'+Path(b['xml']).read_text()+'</banks>').findall('./root'):
  path=str(Path(root.get('path'))/root.get('filename'))
  banks[path]=Path(path).read_bytes()
  for n in root.findall('./object/list/object'):
   f=n.find("field[@name='ulID']")
   if f is not None:registry[int(f.get('value'))]=(n,path)
checked=[]
def val(n,name):
 f=n.find(".//field[@name='%s']"%name);assert f is not None,name
 return scalar(f,n)
def scalar(f,n):
 typ=f.get('type');s=f.get('value');fmt={'u8':'B','u16':'H','u32':'I','s32':'i','sid':'I','tid':'I','f32':'f'}.get(typ)
 if typ=='uni':fmt='f' if '.' in s or 'e' in s.lower() else ('i' if s.startswith('-') else 'I')
 assert fmt,(typ,s)
 off=int(f.get('offset'));ident=int(n.find("field[@name='ulID']").get('value'));bank=registry[ident][1]
 raw=banks[bank][off:off+struct.calcsize('<'+fmt)];v=struct.unpack('<'+fmt,raw)[0]
 assert v==(float(s) if fmt=='f' else int(s))
 checked.append({'node':ident,'field':f.get('name'),'offset':off,'bank':bank,'bytes':raw.hex()})
 return v
def props(n):
 out={};ranges={}
 for p in n.findall(".//object[@name='AkPropBundle']"):
  i=scalar(p.find("field[@name='pID']"),n)
  v=p.find("field[@name='pValue']")
  if v is not None:out[str(i)]=scalar(v,n)
  else:ranges[str(i)]={'min':scalar(p.find("field[@name='min']"),n),'max':scalar(p.find("field[@name='max']"),n)}
 return out,ranges
result={'schema':1,'events':[],'containers':[],'sounds':[],'limits':['Selection semantics reconstructed from native parameters and Audiokinetic documentation; native RNG stream and reset flag behavior not qualified.','This contract preserves ranges, action fades and inheritance IDs; no mixer, spatial attenuation or voice-lifecycle implementation is implied.']}
ids=set()
for event in m['events']:
 n,_=registry[event['event_id']];actions=[]
 for f in n.findall(".//field[@name='ulActionID']"):
  aid=scalar(f,n);a,_=registry[aid];assert val(a,'ulActionType')==1027
  p,ranges=props(a);assert not ranges and set(p)<=set(['15','16'])
  actions.append({'id':aid,'target':val(a,'idExt'),'probability_percent':p.get('16',100.0),'transition_ms':p.get('15',0.0),'properties':p})
 result['events'].append({'id':event['event_id'],'name':event['event_name'],'policy':event['policy'],'actions':actions})
 for item in event['native_graph']:
  ident=item['id']
  if ident in ids:continue
  ids.add(ident);n,_=registry[ident]
  if item['native_type']=='CAkRanSeqCntr':
   p,ranges=props(n);playlist=[]
   for x in n.findall(".//object[@name='AkPlaylistItem']"):
    playlist.append({'sound':scalar(x.find("field[@name='ulPlayID']"),n),'weight':scalar(x.find("field[@name='weight']"),n)})
   result['containers'].append({'id':ident,'mode':val(n,'eMode'),'random_mode':val(n,'eRandomMode'),'avoid_repeat':val(n,'wAvoidRepeatCount'),'global':bool(val(n,'bIsGlobal')),'continuous':bool(val(n,'bIsContinuous')),'reset_each_play_raw':bool(val(n,'bResetPlayListAtEachPlay')),'uses_weight':bool(val(n,'_bIsUsingWeight')),'loop_count':val(n,'sLoopCount'),'transition_mode':val(n,'eTransitionMode'),'properties':p,'ranges':ranges,'playlist':playlist})
  elif item['native_type']=='CAkSound':
   p,ranges=props(n)
   result['sounds'].append({'id':ident,'source':val(n,'sourceID'),'parent':val(n,'DirectParentID'),'properties':p,'ranges':ranges})
assert len(result['events'])==5 and len(result['containers'])==8 and len(result['sounds'])==42
for c in result['containers']:
 assert c['mode']==0 and not c['continuous'] and c['loop_count']==1 and c['transition_mode']==0
 assert {p['sound'] for p in c['playlist']} <= {s['id'] for s in result['sounds']}
result['provenance']={'manifest_sha256':hashlib.sha256((r/'data/4.20/ambient_audio_manifest.json').read_bytes()).hexdigest(),'banks':{p:hashlib.sha256(raw).hexdigest() for p,raw in banks.items()}}
(r/'data/4.20/ambient_audio_selection.json').write_text(json.dumps(result,indent=2)+'\n')
receipt={'passed':True,'events':5,'actions':sum(len(e['actions']) for e in result['events']),'containers':8,'sound_nodes':42,'fields_byte_checked':len(checked),'checks':checked,'limits':result['limits']}
(r/'docs/map_ambient_audio_selection_validation.json').write_text(json.dumps(receipt,indent=2)+'\n')
print({k:v for k,v in receipt.items() if k not in ['checks','limits']})
