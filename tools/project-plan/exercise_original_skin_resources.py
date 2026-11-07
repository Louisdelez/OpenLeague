"""Compose native alias registration, provider selection and compiled readers."""
import argparse,collections,datetime,hashlib,json,math,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from original_skin_provider_reference import OriginalSkinProvider
from original_config_reader_reference import OriginalConfigReader
from native_skin_reference import integer_identity,FIELDS
from reference_inibin import read,hashkey

def load(p):return json.loads(pathlib.Path(p).read_bytes())
def identity(p):
 p=pathlib.Path(p);raw=p.read_bytes();return {'path':str(p),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}
def bits(value):return struct.pack('<f',float(value)).hex()

def main():
 p=argparse.ArgumentParser();p.add_argument('--root',default=str(R));p.add_argument('--output',required=True);a=p.parse_args();root=pathlib.Path(a.root);out=pathlib.Path(a.output)
 if out.exists():p.error('Preserve existing evidence; choose a new output.')
 ref=load(root/'docs/reference_client_4_20.json');binary=pathlib.Path(ref['source_root'])/ref['client']['binary'];deploy=binary.parent
 provider=OriginalSkinProvider(binary);legacy_reader=OriginalConfigReader(binary);selected_reader=OriginalConfigReader(binary)
 registry_path=root/'docs/fidelity_skin_configuration_bindings_4_20.json';registry=load(registry_path);old_path=root/'docs/reference_native_skin_loader_sources/original-skin-loader-execution.json';old=load(old_path)
 catalogue=load(ref['catalogue']['local_path']);assert catalogue['version']=='4.20.1' and identity(ref['catalogue']['local_path'])['sha256']==registry['official_catalogue']['sha256']
 official={(name,int(s['num']),int(s['id'])) for name,d in catalogue['data'].items() for s in d['skins']};assert official=={(x['champion'],x['skin_num'],x['skin_id']) for x in registry['rows']}
 prior={(x['champion'],x['skin_num']):x for x in old['conditional_reference_cases']};rows=[];sources={};parses={};last_legacy=None;comparisons=collections.Counter();bit_differences=[]
 manifest_path=root/'data/4.20/animation_manifest.json';manifest=load(manifest_path)
 for index,row in enumerate(registry['rows']):
  champion,number,skin_id=row['champion'],row['skin_num'],row['skin_id'];char=deploy/'DATA/Characters'/champion;legacy=char/(champion+'.inibin');base=char/'Skins/Base/Base.inibin';folder=f'Skin{number:02}';variant=char/'Skins'/folder/(folder+'.inibin')
  physical=[legacy]+([base] if base.is_file() else [])+([variant] if number and variant.is_file() else [])
  if not legacy.is_file():raise ValueError('Missing indispensable original character config: '+str(legacy))
  paths=[x.relative_to(deploy/'DATA').as_posix() for x in physical]
  registration=provider.register_physical_files(paths);selection=provider.filename_registered(champion,number);resolved=provider.resolve_registered(selection['logical_name'])
  if not resolved['path']:raise ValueError('Original selected path is empty')
  selected=pathlib.Path(str(deploy/'DATA'/resolved['path'])+'bin')
  if selected not in physical:raise ValueError('Original provider escaped supplied config sources')
  if legacy!=last_legacy:
   legacy_logical=legacy.relative_to(deploy/'DATA').as_posix()[:-3];parsed=legacy_reader.parse(legacy_logical,legacy);parses[str(legacy)]={'source':identity(legacy),'observed':parsed};last_legacy=legacy
  section=provider.section_using_compiled_reader(champion,number,selection['dedicated'],legacy_reader)
  if selected==legacy:reader=legacy_reader
  else:
   reader=selected_reader;parsed=reader.parse(resolved['path'],selected);parses[str(selected)]={'source':identity(selected),'observed':parsed}
  raw=read(selected);fields={};classification={}
  for field in FIELDS:
   if field=='ChampionSkinID':result=reader.identity_field(section['section'],field)
   elif field in ['SkinScale','SelfIllumination']:result=reader.scalar_lookup(section['section'],field,0.)
   else:result=reader.string_field(section['section'],field)
   expected=raw.get(hashkey(section['section'],field));fields[field]=result
   if expected is None:
    if result['found']:raise ValueError('Native original getter unexpectedly found '+champion+':'+field)
    kind='absent_in_both'
   elif not result['found']:raise ValueError('Native original getter missing maintained field '+champion+':'+str(number)+':'+field)
   elif field in ['SkinScale','SelfIllumination']:
    try:value=float(expected)
    except (TypeError,ValueError):raise ValueError('Raw numeric-text interpretation not qualified: '+repr(expected))
    if not math.isclose(value,result['value'],rel_tol=2e-7,abs_tol=2e-7):raise ValueError('Original numeric field differs beyond float32 rounding: '+champion+':'+field)
    kind='same_float32' if bits(value)==result['float32_hex'] else 'native_packed_float32_rounding_differs_from_normalized_double'
    if kind!='same_float32':bit_differences.append({'champion':champion,'skin_num':number,'skin_id':skin_id,'field':field,'source':identity(selected),'section':section['section'],'normalized_reference_value':expected,'normalized_double_cast_float32_hex':bits(value),'native':result})
   elif field=='ChampionSkinID':
    if integer_identity(expected)!=integer_identity(result['value']):raise ValueError('Original identity differs')
    kind='same_explicit_identity_storage_preserved'
   else:
    if result['value']!=expected:raise ValueError('Original string field differs: '+champion+':'+field)
    kind='same_string'
   classification[field]=kind;comparisons[kind]+=1
  if integer_identity(fields['ChampionSkinID']['value'])!=skin_id:raise ValueError('Selected original compiled ID differs from official identity')
  previous=prior[(champion,number)]
  if identity(selected)!=previous['conditional_selected_source'] or section['section']!=previous['conditional_selected_section']:raise ValueError('Native provider composition differs from preceding conditional branch reference')
  for source in physical:sources[str(source)]=identity(source)
  current=None
  if number==0:
   entry=manifest.get(champion.lower());scale=fields['SkinScale'];current={'current_manifest_key':champion.lower(),'present':entry is not None,'native_scale_found':scale['found'],
    'current_cast_scope':'Read current manifest and project the statically identified float64-to-float32 cast; the ordinary Rust/game consumer was not executed.'}
   if entry is not None and scale['found']:
    current.update(current_scale=entry['scale'],current_float32_hex=bits(entry['scale']),native_scale=scale['value'],native_float32_hex=scale['float32_hex'],bits_equal=bits(entry['scale'])==scale['float32_hex'])
  rows.append({'champion':champion,'skin_num':number,'skin_id':skin_id,'task_ids':row['task_ids'],'supplied_physical_reference_subset':[str(x) for x in physical],
   'input_scope':'Exact provided character/base/requested-skin INIBIN subset; host directory/package discovery and full cache/defaults/overlay process context remain unqualified.',
   'original_registration':registration,'original_filename_selection':selection,'original_resolved_path':resolved,'original_section_selection':section,
   'selected_compiled_source':identity(selected),'selected_section':section['section'],'original_getter_fields':fields,'comparison_to_maintained_reference_reader':classification,
   'current_base_scale_consumer':current,'full_effective_historical_skin_precedence_qualified':False,'runtime_skin_dispatch_qualified':False})
  if (index+1)%100==0:print(json.dumps({'processed_identities':index+1}),flush=True)
 current_base=[dict(champion=x['champion'],skin_id=x['skin_id'],source=x['selected_compiled_source'],section=x['selected_section'],**x['current_base_scale_consumer']) for x in rows if x['skin_num']==0]
 result={'schema':'openleague_original_skin_resource_composition/v1','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,
  'counts':{'official_skin_identities':len(rows),'selected_explicit_id_matches':len(rows),'original_compiled_files_parsed':len(parses),'physical_reference_files':len(sources),'named_field_comparisons':sum(comparisons.values()),'comparison_statuses':dict(comparisons),
     'normalized_double_vs_native_float32_bit_differences':len(bit_differences),'base_current_scale_bit_differences':sum(x.get('bits_equal') is False for x in current_base)},
  'source_registry':identity(registry_path),'prior_conditional_receipt':identity(old_path),'official_catalogue':identity(ref['catalogue']['local_path']),
  'original_provider':provider.evidence(),'original_legacy_reader':legacy_reader.evidence(),'original_dedicated_reader':selected_reader.evidence(),
  'source_files':list(sources.values()),'original_parse_cases':list(parses.values()),'rows':rows,'numeric_storage_rounding_differences':bit_differences,
  'current_base_scale_comparisons':current_base,'current_consumer_sources':[identity(manifest_path),identity(root/'crates/client/src/animation.rs')],
  'producer':identity(__file__),'helpers':[identity(pathlib.Path(__file__).with_name(name)) for name in ['original_skin_provider_reference.py','original_config_reader_reference.py']],
  'python':{'version':sys.version,**identity(sys.executable)},'historical_game_process_launched':False,'original_full_cache_manager_executed':False,'original_host_directory_package_discovery_executed':False,
  'all_skin_precedence_unknowns_resolved':False,'gameplay_accepted':False,
  'remaining_research':['Qualify original host directory/package discovery and effective provider bootstrap/order; the exact physical subset remains an explicit boundary.',
   'Qualify original cache manager/defaults and override publication across the resolved .ini/.inibin resources; parser/getters are original but complete process initialization is not.',
   'Investigate current base-scale float32 differences and precise asset-role/current-consumer links without treating configuration presence as runtime skin selection.']}
 out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False)+'\n',encoding='utf-8')
 print(json.dumps({'passed':True,'counts':result['counts'],'native_provider_addresses':result['original_provider']['original_unique_addresses_exercised'],'native_legacy_reader_addresses':result['original_legacy_reader']['original_unique_addresses_exercised'],'native_dedicated_reader_addresses':result['original_dedicated_reader']['original_unique_addresses_exercised']}),flush=True)
 return 0

if __name__=='__main__':raise SystemExit(main())
