"""Build source routes, preserving per-node controls before mixer aggregation."""
from pathlib import Path
import json,hashlib,struct,xml.etree.ElementTree as ET
r=Path(__file__).resolve().parents[1]
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());curves=json.loads((r/'data/4.20/audio_curve_contract.json').read_text());nodes={n['key']:n for n in c['nodes']};checked=0
bank_bytes={bank['path']:Path(bank['path']).read_bytes() for bank in c['banks']}
for bank in c['banks']:assert hashlib.sha256(bank_bytes[bank['path']]).hexdigest()==bank['sha256']
def field(e,name):
 global checked
 f=e.find("field[@name='%s']"%name);assert f is not None,name
 matches=[v for v in owner['fields'] if v.get('offset')==f.get('offset') and v['name']==name];assert len(matches)==1 and matches[0]['byte_verified']
 checked+=1;return f.get('value')
def ref(n,role):
 global checked
 found=[v['resolved_key'] for v in n['references'] if v['role']==role];assert len(found)<=1
 if found:
  f=next(f for f in n['fields'] if f['name']==role);assert f['byte_verified']
  assert struct.unpack_from('<I',bank_bytes[n['native_bank']],int(f['offset']))[0]==int(f['value'])
  target=nodes[found[0]];assert target['id']==int(f['value']);checked+=1
 return found[0] if found else None
routes=[]
for root in c['sound_roots']:
 chain=[];key=root['context_key'];seen=set()
 while key:
  assert key not in seen;seen.add(key);chain.append(nodes[key]);key=ref(nodes[key],'DirectParentID')
 bus=next((ref(n,'OverrideBusId') for n in chain if ref(n,'OverrideBusId')),None);buses=[]
 while bus:
  assert bus not in seen;seen.add(bus);buses.append(nodes[bus]);bus=ref(nodes[bus],'OverrideBusId')
 controls=[];atten=None;bus_controls=[]
 for owner in chain:
  tree=ET.fromstring(owner['schema_xml']);props={};ranges={}
  for o in tree.findall(".//object[@name='AkPropBundle']"):
   pid=field(o,'pID')
   if o.find("field[@name='pValue']") is not None:props[pid]=float(field(o,'pValue'))
   else:ranges[pid]={'min':float(field(o,'min')),'max':float(field(o,'max'))}
  controls.append({'node':owner['key'],'properties':props,'ranges':ranges})
  position=tree.find(".//field[@name='bPositioningInfoOverrideParent']")
  if atten is None and position is not None and position.get('value')=='1':
   match=[f for f in owner['fields'] if f.get('offset')==position.get('offset')];assert match[0]['byte_verified'];checked+=1
   atten=ref(owner,'uAttenuationID');assert atten
 for owner in buses:
  for o in ET.fromstring(owner['schema_xml']).findall(".//object[@name='RTPC']"):
   pid=int(field(o,'RTPCID'));assert int(field(o,'ParamID'))==4
   curve=next(x for x in curves['curves'] if x['id']==owner['key']+':bus');assert curve['parameter']==pid
   native_default=next(x for x in c['game_parameters'] if x['id']==pid)
   raw=bank_bytes[native_default['bank']]
   assert struct.unpack_from('<I',raw,native_default['id_offset'])[0]==pid
   default=native_default['default_value'];assert struct.unpack_from('<f',raw,native_default['value_offset'])[0]==default;checked+=2
   bus_controls.append({'node':owner['key'],'parameter':pid,'default':default,'curve':curve})
 assert atten;atten_curve=next(x for x in curves['curves'] if x['id']==atten+':0')
 routes.append({'event':root['event_id'],'sound':root['sound_id'],'actor_chain':[n['key'] for n in chain],'bus_chain':[n['key'] for n in buses],'controls':controls,'attenuation':atten_curve,'bus_controls':bus_controls})
assert len(routes)==42
result={'routes':routes,'source_context_sha256':hashlib.sha256((r/'data/4.20/ambient_audio_context.json').read_bytes()).hexdigest(),'curve_contract_sha256':hashlib.sha256((r/'data/4.20/audio_curve_contract.json').read_bytes()).hexdigest(),'extracted_fields_checked':checked,'limits':['Nearest explicit positioning override chosen from native flags; runtime inheritance semantics still to qualify against original Wwise code.','Per-node scalar/range controls retained separately; no guessed aggregation, gain/pitch conversion or LPF DSP.','Distance input supplied in native units; original distance metric/scaling and audible playback remain unqualified.'],'complete':False}
(r/'data/4.20/ambient_mix_routes.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Mix routes:',len(routes),'field checks:',checked)
