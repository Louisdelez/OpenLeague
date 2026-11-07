"""Compare pinned original native wrappers with actual compiled community getters.

This is a reference-analysis consumer. It never assigns a clip, interprets cast
flags, changes a spell, or treats the component experiment as a full client.
"""
import argparse,collections,hashlib,json,pathlib,sys

class ComparisonError(ValueError):pass

def load(p):return json.loads(pathlib.Path(p).read_bytes())
def identity(p):
 p=pathlib.Path(p);b=p.read_bytes()
 return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def require(ok,message):
 if not ok:raise ComparisonError(message)
def check_pin(pin):
 require(isinstance(pin,dict) and all(k in pin for k in ['path','bytes','sha256']),'Incomplete source identity')
 p=pathlib.Path(pin['path']);require(p.is_file(),'Missing source: '+str(p))
 actual=identity(p);require(all(actual[k]==pin[k] for k in ['bytes','sha256']),'Changed source: '+str(p))
 return actual
def index(rows):
 out={}
 for r in rows:
  key=(r['champion'],r['slot'])
  require(isinstance(key[0],str) and type(key[1]) is int and key[1] in range(1,5),'Invalid base slot')
  require(key not in out,'Duplicate base slot');out[key]=r
 require(len(out)==488 and len({k[0] for k in out})==122,'All122champions/488slots required')
 return out

def compare_documents(inputs,native,community):
 require(inputs['schema']=='openleague_native_community_animation_field_inputs/v1','Wrong inputs schema')
 require(native['execution_completed'] is True and native['invalid_access']==[],'Incomplete or invalid native execution')
 require(community['schema']=='openleague_actual_community_content_getter_execution/v1' and community['execution_completed'] is True,'Incomplete community execution')
 require(not native['historical_OS_process_launched'] and not native['current_production_sources_changed'] and not native['effective_cast_or_playback_qualified'],'Overbroad native claim')
 require(not community['original_Riot_or_historical_community_server_executed'] and not community['effective_cast_or_playback_qualified'],'Overbroad community claim')
 require(len(community['controls'])==6 and all(v is True for v in community['controls'].values()),'Community controls must pass')
 ii,nn,cc=map(index,[inputs['rows'],native['cases'],community['cases']]);require(ii.keys()==nn.keys()==cc.keys(),'Divergent slot sets')
 rows=[]
 for key,inp in ii.items():
  n,c=nn[key],cc[key];require(inp['spell_name']==n['spell_name']==c['spell_name'],'Spell identity mismatch')
  require(inp['native_source']==n['source'] and inp['community']['status']=='present' and inp['community']['source']==c['source'],'Divergent source binding')
  field=inp['native_AnimationName'];require(type(field['present']) is bool,'Nonboolean field presence')
  require((isinstance(field['value'],str) if field['present'] else field['value'] is None),'Nontext native AnimationName')
  expected=field['value'] if field['present'] else 'Attack1'
  require(inp['native_wrapper_expected']==expected==n['expected']==n['observed'],'Native default/value mismatch')
  require(n['canary_unchanged'] is True and n['stack_caller_pop20_pending'] is True,'Native output/ABI guard failed')
  raw_flags=inp['native_Flags'];require(raw_flags==n['Flags_raw'],'Native Flags source mismatch')
  require(n['Flags_native_matches_raw_integer'] is True and n['Flags_native_u32']==n['Flags_raw_integer_u32'],'Native integer mismatch')
  require(c['original_GetObject_GetString_GetInt_component_executed'] is True and c['whole_SpellData_Load_or_server_executed'] is False,'Community component scope mismatch')
  require(c['metadata_name']==inp['community']['metadata_name'],'Metadata name mismatch')
  raw=c['AnimationName_GetObject'];actual=c['AnimationName_GetString_with_Load_default']
  require(actual==(raw if raw is not None else c['metadata_name']),'Community getter/default mismatch')
  require(isinstance(actual,str) and type(c['Flags_GetInt_u32']) is int,'Invalid community output type')
  classification='absent' if not field['present'] else 'explicit_empty' if field['value']=='' else 'named'
  rows.append({'champion':key[0],'slot':key[1],'spell_name':inp['spell_name'],'presentation_task_id':inp['presentation_task_id'],'role_task_id':inp['role_task_id'],
   'native_source':n['source'],'community_source':c['source'],'native_field_state':classification,'native_field':field,'native_effective_wrapper_value':n['observed'],
   'community_named_field_present':inp['community']['named_field_present'],'community_named_field_value':inp['community']['named_field_value'],
   'community_unknown_hash_present':inp['community']['unknown_hash_present'],'community_unknown_hash_value':inp['community']['unknown_hash_value'],
   'community_GetObject':raw,'community_default':c['metadata_name'],'community_effective_getter_value':actual,'AnimationName_differs':n['observed']!=actual,
   'native_Flags_u32':n['Flags_native_u32'],'community_Flags_raw_string':c['Flags_GetObject'],'community_Flags_u32':c['Flags_GetInt_u32'],
   'Flags_differs':n['Flags_native_u32']!=c['Flags_GetInt_u32'],'community_InstantCast_label':c['community_InstantCast_bit'],'community_AlwaysSelf_label':c['community_AlwaysSelf_bit'],
   'native_cast_flag_semantics_qualified':False,'effective_clip_or_playback_qualified':False})
 return rows

def audit(evidence_root):
 v=pathlib.Path(evidence_root).resolve()
 paths={k:v/p for k,p in {'inputs':'animation-field-comparison-inputs.json','native':'native-animation-fields-all-slots.json','community':'community-content-getters-all-slots-v2.json','component':'community-component-build-receipt-v2-qualified.json','native_execution':'native-animation-fields-all-slots-execution.json','native_source':'native-animation-dispatch-source.json'}.items()}
 docs={k:load(p) for k,p in paths.items()};component=docs['component'];native=docs['native'];inputs=docs['inputs']
 require(component['execution']['exit_code']==0 and component['build']['exit_code']==0 and component['restore']['exit_code']==0,'Component operation failed')
 require(docs['native_execution']['exit_code']==0,'Native operation failed')
 require(component['output']==identity(paths['community']),'Wrong component output receipt')
 require(component['whole_SpellData_Load_executed'] is False and component['original_community_sources_changed'] is False,'Wrong component scope')
 require(len(component['compiled_community_sources'])==3 and len(component['inspected_community_sources'])==5,'Compiled and inspected sources must remain distinct')
 check_pin(component['raw_build_receipt'])
 for name in ['restore','build','execution']:check_pin(component[name]['log'])
 require(component['first_failure']['exit_code']!=0,'First failure must remain recorded')
 for pin in component['preserved_first_attempt']:check_pin(pin)
 check_pin(component['first_failure']['log'])
 require(native['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong original game binary')
 pins=[native['binary'],native['producer'],native['source_contract'],inputs['prior_audit'],inputs['source_contract'],*inputs['community_code_sources'],*component['project_sources'],*component['runtime_files'],component['producer'],component['dependency_copy']]
 pins += [r['native_source'] for r in inputs['rows']]+[r['community']['source'] for r in inputs['rows']]
 unique={str(pathlib.Path(p['path']).resolve()).casefold():p for p in pins}
 verified=[check_pin(p) for p in unique.values()]
 require(docs['community']['json_dependency']['sha256']==component['dependency_copy']['sha256']==component['dependency_original']['sha256'],'JSON dependency bytes mismatch')
 rows=compare_documents(inputs,native,docs['community'])
 counts={'base_champions':122,'base_slots':len(rows),'native_field_states':dict(collections.Counter(r['native_field_state'] for r in rows)),
  'AnimationName_differences':sum(r['AnimationName_differs'] for r in rows),'Flags_differences':sum(r['Flags_differs'] for r in rows),
  'distinct_original_instruction_addresses':len(native['original_instruction_addresses']),'freshly_rehashed_unique_inputs':len(verified)}
 return {'schema':'openleague_native_community_spell_field_comparison/v1','counts':counts,'rows':rows,'evidence_files':{k:identity(p) for k,p in paths.items()},'verified_sources':verified,
  'native_wrapper_scope':{'AnimationName':'0x8B0630 called with original loader default literal Attack1 at0x1097B50; caller0x767504.','Flags':'0x8B1A80 exact integer wrapper; caller0x76836A.','adapters':native['declared_adapters'],'original_game_binary':native['binary'],'full_loader_or_cast_executed':False},
  'community_component_scope':{'runtime':docs['community']['runtime'],'JSON_assembly':docs['community']['json_assembly_identity'],'whole_SpellData_Load_executed':False,'source_call_context':docs['community']['declared_call_context']},
  'reference_decision':'For this declared wrapper/call-context comparison, retain native values. Record community divergences separately; never use them to remap a clip or qualify cast/gameplay behavior.',
  'all_Goal_objectives_completed':False,'production_game_modified':False,'historical_OS_process_launched':False,'effective_cast_clip_or_playback_qualified':False}

def main():
 parser=argparse.ArgumentParser();parser.add_argument('--evidence-root',required=True);parser.add_argument('--output',required=True);args=parser.parse_args()
 try:
  out=pathlib.Path(args.output);require(not out.exists(),'Preserve previous output');result=audit(args.evidence_root)
  out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts'],ensure_ascii=False));return 0
 except (OSError,ValueError,KeyError,TypeError) as e:print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1
if __name__=='__main__':raise SystemExit(main())
