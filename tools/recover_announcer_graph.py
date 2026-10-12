"""Preserve selection/action contracts and verify parser fields against bank bytes."""
from pathlib import Path
import json,struct,hashlib,xml.etree.ElementTree as ET,collections,datetime
r=Path(__file__).resolve().parents[1];xmlpath=r/'docs/announcer_banks.xml';tree=ET.fromstring('<banks>'+xmlpath.read_text(encoding='utf-8')+'</banks>');manifest=json.loads((r/'data/4.20/announcer_audio_manifest.json').read_text(encoding='utf-8'));media={m['id'] for m in manifest['media']};checked=0;contracts=[];missing=[];generated=[];distributions=collections.Counter()
for bank in tree.findall('./root'):
 path=Path(bank.get('path'))/bank.get('filename');raw=path.read_bytes();registry={}
 for node in bank.findall('./object/list/object'):
  f=node.find("field[@name='ulID']")
  if f is not None:registry[int(f.get('value'))]=node
 def scalar(f):
  global checked
  assert f is not None
  typ=f.get('type');value=f.get('value');fmt={'u8':'B','s8':'b','u16':'H','s16':'h','u32':'I','s32':'i','sid':'I','tid':'I','f32':'f','f64':'d'}.get(typ)
  if typ=='uni':fmt='f' if '.' in value or 'e' in value.lower() else ('i' if value.startswith('-') else 'I')
  assert fmt and f.get('offset') is not None,(typ,value,f.attrib)
  off=int(f.get('offset'));assert off+struct.calcsize('<'+fmt)<=len(raw);v=struct.unpack_from('<'+fmt,raw,off)[0];assert v==(float(value) if fmt in ('f','d') else int(value));checked+=1;return v
 def val(node,name):return scalar(node.find(".//field[@name='%s']"%name))
 def props(node):
  values={};ranges={}
  for p in node.findall(".//object[@name='AkPropBundle']"):
   id=str(scalar(p.find("field[@name='pID']")));v=p.find("field[@name='pValue']")
   if v is not None:values[id]=scalar(v)
   else:ranges[id]={'min':scalar(p.find("field[@name='min']")),'max':scalar(p.find("field[@name='max']"))}
  return values,ranges
 result={'bank':str(path),'bank_sha256':hashlib.sha256(raw).hexdigest(),'events':[],'containers':[],'sounds':[]}
 for id,n in registry.items():
  kind=n.get('name');assert val(n,'ulID')==id
  if kind=='CAkEvent':
   actions=[]
   for f in n.findall(".//field[@name='ulActionID']"):
    aid=scalar(f);a=registry[aid];assert a.get('name')=='CAkActionPlay';type=val(a,'ulActionType');assert type==1027;target=val(a,'idExt');assert registry[target].get('name')=='CAkRanSeqCntr';p,ranges=props(a)
    actions.append({'id':aid,'target':target,'native_type':type,'probability_percent':p.get('16',100.),'transition_ms':p.get('15',0.),'properties':p,'ranges':ranges})
   result['events'].append({'id':id,'actions':actions})
  elif kind=='CAkRanSeqCntr':
   p,ranges=props(n);playlist=[]
   for item in n.findall(".//object[@name='AkPlaylistItem']"):
    sound=scalar(item.find("field[@name='ulPlayID']"));assert registry[sound].get('name')=='CAkSound';playlist.append({'sound':sound,'weight':scalar(item.find("field[@name='weight']"))})
   children=[scalar(f) for f in n.findall(".//field[@name='ulChildID']")];assert set(children)=={p['sound'] for p in playlist}
   obj={'id':id,'parent':val(n,'DirectParentID'),'mode':val(n,'eMode'),'random_mode':val(n,'eRandomMode'),'avoid_repeat':val(n,'wAvoidRepeatCount'),'global':bool(val(n,'bIsGlobal')),'continuous':bool(val(n,'bIsContinuous')),'reset_each_play_raw':bool(val(n,'bResetPlayListAtEachPlay')),'uses_weight':bool(val(n,'_bIsUsingWeight')),'loop_count':val(n,'sLoopCount'),'transition_mode':val(n,'eTransitionMode'),'properties':p,'ranges':ranges,'playlist':playlist,'child_ids':children}
   distributions[str((obj['random_mode'],obj['avoid_repeat'],len(playlist),obj['reset_each_play_raw']))]+=1;result['containers'].append(obj)
  elif kind=='CAkSound':
   p,ranges=props(n);source=val(n,'sourceID');parent=val(n,'DirectParentID');assert parent in registry
   plugin=val(n,'ulPluginID')
   if source not in media:
    if plugin==0x650002:
     assert val(n,'uFileID')==0 and val(n,'uInMemoryMediaSize')==0 and val(n,'uSize')==0
     generated.append({'bank':str(path),'sound':id,'source':source,'plugin_id':plugin,'kind':'Wwise Silence','duration_qualified':False})
    else:missing.append({'bank':str(path),'sound':id,'source':source})
   result['sounds'].append({'id':id,'source':source,'parent':parent,'plugin_id':val(n,'ulPluginID'),'stream_type':val(n,'StreamType'),'properties':p,'ranges':ranges})
 # All actions/playlists point to byte-verified objects; preserve each bank scope.
 result['event_media']=[{'event':e['id'],'sources':sorted({s['source'] for a in e['actions'] for container in result['containers'] if container['id']==a['target'] for item in container['playlist'] for s in result['sounds'] if s['id']==item['sound']})} for e in result['events']]
 contracts.append(result)
result={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'banks':contracts,'fields_byte_verified':checked,'missing_media':missing,'generated_sources':generated,'selection_distribution':dict(distributions),'parser_sha256':hashlib.sha256(Path('E:/mapslol3v3/tools/wwiser.pyz').read_bytes()).hexdigest(),'xml_sha256':hashlib.sha256(xmlpath.read_bytes()).hexdigest(),'manifest_sha256':hashlib.sha256((r/'data/4.20/announcer_audio_manifest.json').read_bytes()).hexdigest(),'passed':True,'complete':False,'limits':['All event/action/container/playlist/source links and retained scalar parameters compared with original bytes. Parent bus/effects/RTPC graph not qualified here.','Shuffle avoid-repeat and reset fields retained exactly, including one-entry avoid-repeat1 containers; existing ambient selector does not support these settings. No normalization or substitute selection.','Generated Wwise Silence source has no media; duration and runtime behavior unqualified. Native RNG/scheduling/voice limits and actual audible client playback remain incomplete. Event names are not inferred from IDs.']}
(r/'data/4.20/announcer_audio_graph.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps({'banks':len(contracts),'events':sum(len(b['events']) for b in contracts),'containers':sum(len(b['containers']) for b in contracts),'sounds':sum(len(b['sounds']) for b in contracts),'fields':checked,'missing_media':len(missing),'generated_sources':len(generated),'distribution':dict(distributions)}))
