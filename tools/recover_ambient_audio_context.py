"""Recover Wwise ancestors/buses/attenuation/DSP with byte-verified fields."""
from pathlib import Path
import json,struct,hashlib,datetime,xml.etree.ElementTree as ET,math
r=Path(__file__).resolve().parents[1]
manifest=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text())
inputs=[('ENV_Map10_SFX',r/'docs/ambient_env_banks.xml'),('NPC_Map10_SFX',Path('E:/mapslol3v3/output/Map_Completion/npc_map10.xml')),('Init',r/'docs/ambient_init_bank.xml')]
registry={};bank_bytes={};bank_receipts={};settings=[]
for family,path in inputs:
 tree=ET.fromstring('<banks>'+path.read_text(encoding='utf-8')+'</banks>')
 for bank in tree.findall('./root'):
  native=Path(bank.get('path'))/bank.get('filename');raw=native.read_bytes();bank_bytes[str(native)]=raw
  bank_receipts[str(native)]={'path':str(native),'sha256':hashlib.sha256(raw).hexdigest(),'xml':str(path),'xml_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'version':bank.get('version')}
  for node in bank.findall('./object/list/object'):
   f=node.find("field[@name='ulID']")
   if f is not None:
    key=(family,int(f.get('value')))
    assert key not in registry,key
    registry[key]=(node,str(native))
  if family=='Init':
   for obj in bank.findall('./object'):
    if obj.get('name') in ['STMG','GlobalSettings','GlobalSettingsChunk','EnvSettingsChunk']:
     settings.append({'bank':str(native),'xml':ET.tostring(obj,encoding='unicode')})
formats={'u8':'B','s8':'b','u16':'H','s16':'h','u32':'I','s32':'i','u64':'Q','s64':'q','sid':'I','tid':'I','f32':'f','f64':'d'}
checked=0;bits_checked=0;skipped=[]
def fields_verified(node,bank):
 global checked,bits_checked
 raw=bank_bytes[bank];fields=[]
 def walk(element,scope='',parent_field=None):
  global checked,bits_checked
  for child in element:
   name=child.get('name','');path=scope+'/'+name
   if child.tag=='field':
    field=dict(child.attrib);field['scope']=scope
    typ=field.get('type');value=field.get('value');offset=field.get('offset');ok=False
    if value is not None and offset is not None:
     off=int(offset);fmt=formats.get(typ)
     if typ=='uni':fmt='f' if any(x in value.lower() for x in ['.','e']) else ('i' if value.startswith('-') else 'I')
     if fmt:
      size=struct.calcsize('<'+fmt);assert off+size<=len(raw)
      actual=struct.unpack_from('<'+fmt,raw,off)[0];expected=float(value) if fmt in ['f','d'] else int(value)
      assert actual==expected or (isinstance(actual,float) and math.isnan(actual) and math.isnan(expected)),(bank,name,typ,off,actual,expected)
      field['raw_bytes']=raw[off:off+size].hex();field['byte_verified']=True;checked+=1;ok=True
    if typ and typ.startswith('bit') and parent_field and parent_field.get('offset'):
     bit=int(typ[3:]);off=int(parent_field['offset']);assert ((raw[off]>>bit)&1)==int(value)
     field.update({'parent_byte_offset':off,'byte_verified':True});bits_checked+=1;ok=True
    if not ok:field['byte_verified']=False;skipped.append({'bank':bank,'field':name,'type':typ,'offset':offset,'scope':scope})
    fields.append(field);walk(child,path,field)
   else:walk(child,path,None)
 walk(node,node.get('name',''))
 return fields
context={};unresolved=[]
def resolve(family,id):
 if (family,id) in registry:return family,id
 if ('Init',id) in registry:return 'Init',id
 candidates=[key for key in registry if key[1]==id]
 assert len(candidates)<=1,('Ambiguous shared object',id,candidates)
 return candidates[0] if candidates else None

def visit(key):
 if key in context:return
 node,bank=registry[key];fields=fields_verified(node,bank);references=[]
 for field in node.findall('.//field'):
  if field.get('name') in ['DirectParentID','OverrideBusId','uAttenuationID']:
   target=int(field.get('value'));name=field.get('name')
   if target:references.append((name,target))
 for chunk in node.findall(".//object[@name='FXChunk']"):
  for field in chunk.findall("field[@name='fxID']"):
   target=int(field.get('value'))
   if target:references.append(('BusFxID',target))
 identity=f'{key[0]}:{key[1]}';off=int(node.find("field[@name='ulID']").get('offset'));size=int(node.find("field[@name='dwSectionSize']").get('value'))
 assert off+size<=len(bank_bytes[bank])
 context[key]={'key':identity,'id':key[1],'family':key[0],'native_type':node.get('name'),'native_bank':bank,'hirc_payload_sha256':hashlib.sha256(bank_bytes[bank][off:off+size]).hexdigest(),'fields':fields,'schema_xml':ET.tostring(node,encoding='unicode'),'references':[]}
 for role,id in references:
  target=resolve(key[0],id)
  context[key]['references'].append({'role':role,'id':id,'resolved_key':None if target is None else f'{target[0]}:{target[1]}'})
  if target is None:unresolved.append({'owner':identity,'role':role,'id':id})
  else:visit(target)
roots=[]
for event in manifest['events']:
 for graph_node in event['native_graph']:
  if graph_node['native_type']!='CAkSound':continue
  key=resolve(event['bank_family'],graph_node['id']);assert key is not None;visit(key)
  roots.append({'event_name':event['event_name'],'event_id':event['event_id'],'sound_id':graph_node['id'],'context_key':f'{key[0]}:{key[1]}'})
assert not unresolved,unresolved
# Capture all inherited native curve data in its original nested schema.
attenuations=[];plugins=[]
for key,entry in context.items():
 node,bank=registry[key]
 if entry['native_type']=='CAkAttenuation':
  curves=[]
  for curve in node.findall(".//object[@name='CAkConversionTable']"):
   scaling=curve.find("field[@name='eScaling']");points=[]
   for point in curve.findall(".//object[@name='AkRTPCGraphPoint']"):
    points.append({f.get('name'):float(f.get('value')) if f.get('type')=='f32' else int(f.get('value')) for f in point.findall('field')})
   curves.append({'scaling_raw':int(scaling.get('value')),'points':points})
  attenuations.append({'key':entry['key'],'curves':curves,'semantics_qualified':False})
 if entry['native_type'] in ['CAkFxCustom','CAkFxShareSet']:
  f=node.find(".//object[@name='FxBaseInitialValues']/field[@name='fxID']")
  plugins.append({'key':entry['key'],'plugin_id':int(f.get('value')),'parser_label':f.get('valuefmt'),'semantics_qualified':False})
game_parameters=[]
for setting in settings:
    tree=ET.fromstring(setting['xml']);setting['fields']=fields_verified(tree,setting['bank'])
    for obj in tree.iter('object'):
        key=obj.find("field[@name='RTPC_ID']");value=obj.find("field[@name='fValue']")
        if key is not None and value is not None:
            game_parameters.append({'id':int(key.get('value')),'default_value':float(value.get('value')),'native_hashname':key.get('hashname'),'bank':setting['bank'],'id_offset':int(key.get('offset')),'value_offset':int(value.get('offset'))})
result={'banks':list(bank_receipts.values()),'sound_roots':roots,'nodes':list(context.values()),'attenuations':attenuations,'plugins':plugins,'global_settings':settings,'game_parameters':game_parameters,'complete':False,'limits':['Native ancestor/bus/attenuation/DSP hierarchy recovered; raw fields verified at original bank offsets.','Mixer/RTPC scaling/interpolation, spatial/listener rules, voice limits and sound lifecycle still need implementation/qualification. Parsed STMG switch-curve To labels are not semantic qualification; preserve original bytes.','No unqualified fallback audio playback enabled; full 24-domain goal remains open.']}
output=r/'data/4.20/ambient_audio_context.json';output.write_text(json.dumps(result,indent=2)+'\n')
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'manifest_sha256':hashlib.sha256(output.read_bytes()).hexdigest(),'nodes':len(context),'sound_roots':len(roots),'field_values_byte_verified':checked,'derived_bits_byte_verified':bits_checked,'unverified_fields':skipped,'attenuation_objects':len(attenuations),'fx_plugins':plugins,'game_parameter_defaults':len(game_parameters),'unresolved_references':unresolved,'banks':list(bank_receipts.values()),'passed':True,'complete':False,'limits':result['limits']}
(r/'docs/map_ambient_audio_context_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS native inherited audio context:',len(context),'nodes;',checked,'byte-verified fields;',bits_checked,'bits;',len(attenuations),'attenuation objects;',len(plugins),'plugins')
