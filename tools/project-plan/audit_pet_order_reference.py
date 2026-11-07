"""Readonly verifier of pet callbacks, exact C# method spans and bounded observations."""
import argparse,hashlib,json,pathlib,sys
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3')
sys.path.insert(0,str(R/'tools/project-plan'))
from lua51_reference import Reader
from rads_reference_membership import RadsReferenceMembership
from audit_native_community_callbacks import function_names,words,adapted_identity
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def need(ok,why):
 if not ok:raise ValueError(why)
def guard_result(f,state,order):
 """Independent interpretation restricted to the original early guard opcodes."""
 regs={0:'SUPPLIED_'+order,1:None};pc=0;steps=0;constants=f['constants'];calls=[]
 while steps<100:
  need(0<=pc<=44,'Guard escapes the independently qualified prefix')
  w=f['words'][pc];pc+=1;steps+=1;op=w&63;a=(w>>6)&255;b=(w>>23)&511;c=(w>>14)&511;bx=w>>14
  if op==5:regs[a]=('API:GetState' if constants[bx]=='GetState' else 'SUPPLIED_'+constants[bx])
  elif op==28:
   need(regs[a]=='API:GetState' and b==1 and c==2,'Unqualified guard call')
   calls.append({'api':'GetState','args':[]});regs[a]='SUPPLIED_'+state
  elif op==23:
   need(b<256 and c<256,'Unexpected constant EQ operands')
   if (regs[b]==regs[c])!=bool(a):pc+=1
  elif op==22:pc+=bx-131071
  elif op==2:
   regs[a]=bool(b)
   if c:pc+=1
  elif op==30:
   need(b in [1,2],'Unqualified guard return arity')
   return ([regs[a]] if b==2 else []),calls
  else:raise ValueError('Unqualified guard opcode')
 raise ValueError('Unbounded guard prefix')

def audit(evidence_root,inputs_override=None,events_override=None,orders_override=None,component_override=None,observation_override=None,roles_override=None):
 v=pathlib.Path(evidence_root).resolve(strict=True);need(v.is_relative_to(S.resolve()),'Evidence outside workspace')
 inputs=load(v/'pet-order-review-inputs.json') if inputs_override is None else inputs_override
 need(inputs['schema']=='openleague_pet_order_review_inputs/v1','Wrong review schema')
 need(all(inputs[k] is False for k in ['original_event_dispatch_or_enum_values_qualified','complete_pet_behavior_qualified','current_Rust_gameplay_executed']),'Unsupported whole behavior claim')
 identities={};tool_identities={}
 def keep(x,tool=False):
  p=pathlib.Path(x['path']).resolve(strict=True)
  roots=[R.resolve(),S.resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]
  need(any(p.is_relative_to(a) for a in roots) or tool and (p==pathlib.Path(sys.executable).resolve() or p.is_relative_to(pathlib.Path('C:/Program Files/dotnet').resolve())),'Identity outside allowed roots')
  need(all(pin(p)[k]==x[k] for k in ['bytes','sha256']),'Changed source identity')
  (tool_identities if tool else identities)[str(p).casefold()]=x
  return p
 for key in ['reference','role_inputs','event_probe','order_probe','community_component','source_correction','expectation_correction','audit_dependency','producer']:keep(inputs[key])
 roles=load(inputs['role_inputs']['path']) if roles_override is None else roles_override
 events=load(inputs['event_probe']['path']) if events_override is None else events_override
 orders=load(inputs['order_probe']['path']) if orders_override is None else orders_override
 component=load(inputs['community_component']['path']) if component_override is None else component_override
 observation=load(component['observation']['path']) if observation_override is None else observation_override
 need(roles['schema']=='openleague_pet_callback_role_source_inputs/v1' and events['schema']=='openleague_original_pet_event_requests_lua51/v1' and orders['schema']=='openleague_original_pet_order_guards_lua51/v1','Wrong evidence schema')
 keep(roles['reference']);keep(roles['community_script']);keep(roles['community_interface']);keep(roles['producer']);keep(roles['previous_unqualified_input']);keep(roles['method_extraction']);keep(roles['parser_execution'])
 need(roles['native_event_dispatch_or_engine_APIs_qualified'] is False and roles['CSharp_or_Rust_gameplay_executed'] is False,'Unsupported role equivalence')
 extracted=load(roles['method_extraction']['path']);methods=roles['selected_methods']+[roles['on_order_method']]
 need(len(methods)==7 and methods==[m for m in extracted['methods'] if m['method']!='OnOrder']+[m for m in extracted['methods'] if m['method']=='OnOrder'],'Incorrect method selection')
 for m in methods:
  p=keep(m['source']);text=p.read_bytes().decode('utf-8-sig');wide=text.encode('utf-16-le')
  for field,span,sha in [('method_text','method_span_utf16','method_sha256_utf8'),('body','body_span_utf16','body_sha256_utf8')]:
   a=m[span]['start'];end=a+m[span]['length'];actual=wide[a*2:end*2].decode('utf-16-le')
   need(actual==m[field] and hashlib.sha256(actual.encode()).hexdigest()==m[sha],'Incorrect original source span')
  need(wide[:m['method_span_utf16']['start']*2].decode('utf-16-le').count('\n')+1==m['first_line'],'Incorrect original line')
 need(next(m for m in methods if m['method']=='CanMove')['first_line']==298 and next(m for m in methods if m['method']=='CanAttack')['first_line']==325,'Uncorrected census offsets')
 correction=load(inputs['source_correction']['path']);need(correction['corrected']==inputs['role_inputs'] and correction['previous']==roles['previous_unqualified_input'],'Wrong source correction lineage')
 expected_correction=load(inputs['expectation_correction']['path']);prior_probe=expected_correction['prior_probe'];need(pin(prior_probe['path'])['sha256']==prior_probe['sha256'],'Changed failed probe source');keep(pin(prior_probe['path']))
 need(expected_correction['incorrect_expectation'] is False and expected_correction['exit_code']==1 and expected_correction['native_bytes_changed'] is False,'Missing failed expectation history')
 for record in [events,orders]:
  p=keep(record['source']);keep(record['inventory']);keep(record['producer']);adapter=keep(record['format_adapter'])
  keep(record['runtime']['python'],True);keep(record['runtime']['lua_module']);need(record['runtime']['reported_version']=='Lua 5.1','Wrong Lua runtime')
  proto=Reader(p.read_bytes()).parse()
  need(record['source']==events['source'] and len(proto['children'])==13,'Wrong original pet source')
  need(record['raw32_roundtrip_exact'] is True and record['instruction_arrays_preserved'] is True and record['instruction_array_sha256']==words(proto) and record['adapted_sha256']==adapted_identity(p.read_bytes(),adapter),'Changed original instruction arrays or adaptation')
  inventory=load(record['inventory']['path']);row=next(x for x in inventory['rows'] if x['native_source']==record['source'])
  membership=RadsReferenceMembership(R);need(membership.inspect(p.relative_to(pathlib.Path(membership.deploy)).as_posix(),p,record['source'])==row['membership'] and row['membership']['status']=='matches_selected_project_manifest','Original pet membership changed')
 names=function_names(proto);need(names[1][0]['name']=='OnOrder' and names[8][0]['name']=='OnCanMove' and names[9][0]['name']=='OnCanAttack' and names[12][0]['name']=='HaltAI','Wrong original callback bindings')
 need(events['cases_count']==len(events['cases'])==9 and events['original_selected_body_instructions']=={'OnCanMove':12,'OnCanAttack':12,'HaltAI':16},'Wrong event cases')
 need(events['selected_original_Lua_callback_arrays_executed'] is True and all(events[k] is False for k in ['original_TimerFindEnemies_body_executed','historical_game_VM_or_engine_implementation_executed','CSharp_or_Rust_gameplay_executed','integrated_into_registry']),'Unsupported event engine execution')
 profiles=[(n,s) for n in ['OnCanMove','OnCanAttack'] for s in ['SUPPLIED_HALTED','SUPPLIED_IDLE','SUPPLIED_HARDSTOP','SUPPLIED_FEARED']]+[('HaltAI','SUPPLIED_IDLE')]
 need([(c['callback'],c['supplied_state']) for c in events['cases']]==profiles,'Event profile coverage changed')
 for case in events['cases']:
  n,state=case['callback'],case['supplied_state'];index={'OnCanMove':8,'OnCanAttack':9,'HaltAI':12}[n];f=proto['children'][index]
  need(case['prototype_index']==index and case['source_code_sha256']==f['code_sha256'] and all(((w>>23)&511)==1 for w in f['words'] if w&63==30),'Event function/return shape changed')
  expected=([{'api':'StopTimer','args':[n]} for n in ['TimerScanDistance','TimerFindEnemies','TimerFeared']]+[{'api':'TurnOffAutoAttack','args':['SUPPLIED_STOP_IMMEDIATELY']},{'api':'NetSetState','args':['SUPPLIED_HALTED']}]) if n=='HaltAI' else [{'api':'GetState','args':[]}]+([] if state=='SUPPLIED_HALTED' else [{'api':'NetSetState','args':['SUPPLIED_IDLE']},{'api':'TimerFindEnemies','args':[]}])
  need(case['observed_calls']==case['expected_calls']==expected and case['returned_no_Lua_values'] is True and case['passed'] is True,'Event observation changed')
 hard=['AI_PET_HARDATTACK','AI_PET_HARDMOVE','AI_PET_HARDIDLE','AI_PET_HARDIDLE_ATTACKING','AI_PET_HARDRETURN','AI_PET_HARDSTOP'];early=['AI_HALTED','AI_TAUNTED','AI_FEARED'];mapping={'ORDER_ATTACKTO':'AttackTo','ORDER_MOVETO':'MoveTo','ORDER_ATTACKMOVE':'AttackMove','ORDER_STOP':'Stop'}
 expected_profiles=[(s,o) for s in hard+early for o in mapping];f=proto['children'][1]
 need(orders['cases_count']==36 and len(f['words'])==orders['original_OnOrder_instructions']==215 and orders['selected_prototype_index']==1 and orders['selected_prototype_code_sha256']==f['code_sha256'],'Wrong order function/case count')
 need([(c['state_name'],c['native_order_symbol']) for c in orders['cases']]==expected_profiles,'Order profiles incomplete')
 need(orders['boolean_true_cases']==24 and orders['no_return_values_cases']==12,'Wrong order return aggregate')
 need(orders['expected_basis']['hard_states']['word']==f['words'][43] and orders['expected_basis']['hard_states']['B']==1 and orders['expected_basis']['early_states']['RETURN_pcs']==[5,12],'Wrong return expectation basis')
 need(all(orders[k] is False for k in ['actual_native_event_dispatch_or_enum_numbers_qualified','native_engine_API_implementation_executed','current_Rust_or_CSharp_gameplay_executed','integrated_into_registry']),'Unsupported native order/event ABI claim')
 for c in orders['cases']:
  s,o=c['state_name'],c['native_order_symbol'];values,calls=guard_result(f,s,o)
  need(c['community_order_name']==mapping[o] and c['supplied_native_state_value']=='SUPPLIED_'+s and c['supplied_native_order_value']=='SUPPLIED_'+o and c['supplied_second_argument'] is None,'Undeclared symbolic profile mapping')
  need((c['observed_return'] is True and c['expected_return'] is True) if values else (c['observed_return'] is None and c['expected_return'] is None),'Wrong return value type')
  need(c['observed_return_count']==c['expected_return_count']==len(values) and c['observed_return']==c['expected_return']==(values[0] if values else None) and c['observed_calls']==calls and c['passed'] is True,'Native order result changed')
 need(component['method']==roles['on_order_method'] and component['source']==roles['community_script'],'Wrong compiled source method')
 keep(component['producer']);keep(component['extraction']);keep(component['observation']);keep(component['dotnet'],True);keep(component['assembly'])
 need(component['original_native_event_dispatch_qualified'] is False and component['current_Rust_gameplay_executed'] is False,'Unsupported component gameplay claim')
 for pair in component['original_enum_sources']:need(keep(pair['original']).read_bytes()==keep(pair['copy']).read_bytes(),'Enum source changed')
 host={pathlib.Path(x['path']).name:keep(x) for x in component['host_sources']}
 selected=host['SelectedMethod.cs'].read_bytes().decode('utf-8');need(selected.count(component['method']['method_text'])==1,'Compiled method modified or truncated')
 need('<clear />' in host['NuGet.Config'].read_text('utf-8') and '<TargetFramework>net8.0</TargetFramework>' in host['PetOrderComponent.csproj'].read_text('utf-8'),'Undeclared component feeds/framework')
 for group in [component['commands'],load(roles['parser_execution']['path'])['commands']]:
  need(len(group)==3 and all(c['exit_code']==0 for c in group),'Component/parser execution failed')
  for c in group:keep(c['log']);need(c['command'][0]==str(pathlib.Path('C:/Program Files/dotnet/dotnet.exe')),'Unexpected execution host')
 need(observation['schema']=='openleague_community_pet_order_component_observation/v1' and observation['cases_count']==len(observation['cases'])==36 and observation['full_community_server_executed'] is False and observation['unqualified_API_implemented'] is False,'Wrong community observation scope')
 comparisons=[]
 for native,cs in zip(orders['cases'],observation['cases'],strict=True):
  need(cs['state_name']==native['state_name'] and cs['community_order_name']==native['community_order_name'] and cs['return_value'] is True and cs['observed_calls']==['TargetUnit','GetAIState'] and cs['passed'] is True,'Changed C# guard observation')
  comparisons.append({'state':cs['state_name'],'order':cs['community_order_name'],'native_return_count':native['observed_return_count'],'native_return':native['observed_return'],'CSharp_return':cs['return_value'],'literal_shape_matches':native['observed_return_count']==1 and native['observed_return'] is cs['return_value'],'native_dispatch_meaning_qualified':False})
 need(observation['fail_fast_control']=={'state':'AI_PET_IDLE','order':'Stop','expected':'RemoveBuff refused','observed':['TargetUnit','GetAIState','REFUSED:RemoveBuff'],'passed':True},'Host fail-fast control changed')
 need(len(inputs['anchors'])==12 and len({a['role'] for a in inputs['anchors']})==12,'Missing actual consumer anchors')
 for a in inputs['anchors']:
  p=keep(a['source']);lines=p.read_text('utf-8-sig').splitlines();need(a['execution']=='source_inspection_only' and lines[a['line']-1]==a['excerpt'] and sum(a['needle'] in line for line in lines)==1 and a['needle'] in a['excerpt'],'Changed actual source anchor')
 rust=roles['current_Rust_source'];p=keep(rust['source']);lines=p.read_text('utf-8').splitlines();need(lines[rust['line']-1]==rust['excerpt'] and rust['needle'] in rust['excerpt'],'Changed current Rust source consumer')
 need('OnCanMove' not in pathlib.Path(roles['community_interface']['path']).read_text('utf-8') and 'OnCanAttack' not in pathlib.Path(roles['community_interface']['path']).read_text('utf-8'),'Interface callback-role assumption changed')
 return {'schema':'openleague_pet_order_reference_audit/v1','verified':True,'counts':{'inherited_pet_event_cases':9,'fresh_native_order_cases':36,'selected_complete_CSharp_method_cases':36,'CSharp_fail_fast_controls':1,'matching_literal_return_profiles':24,'different_literal_return_shapes':12,'native_OnOrder_instructions':215,'source_methods':7,'community_source_anchors':12,'fully_qualified_community_scripts':0},
  'source_identities':list(identities.values()),'tool_identities':list(tool_identities.values()),'comparison':comparisons,'current_consumer_evidence':[rust],
  'candidate_scripts':[{'relative_path':'AIScripts/Pet.cs','source':roles['community_script'],'git_snapshot':roles['inherited_git_snapshot'],'native_candidates':[events['source']['path']],'dispatch_qualified':False}],
  'inherited_native_experiments':[inputs['event_probe']],'fresh_native_experiments':[inputs['order_probe']],'fresh_CSharp_component_experiments':[inputs['community_component']],
  'declared_boundaries':['Symbolic native states/orders only; original numeric enums and event argument producer remain unqualified.','No original event-dispatch meaning inferred from Lua return shape; C# source consumer uses boolean Publish to reject orders.','Original TimerFindEnemies body and native engine APIs are not executed.','Exact whole C# method/real enum sources compiled on .NET8 with fail-fast stubs; not the full server or Pet class.','C# CanMove/CanAttack permission predicates are distinct from native OnCanMove/OnCanAttack state/search request callbacks.','Current Rust pet lifecycle source inspected; no new Rust gameplay execution or bridge qualification.'],
  'native_engine_API_or_original_argument_producer_qualified':False,'current_Rust_or_CSharp_gameplay_qualified':False,'historical_game_process_launched':False}

def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output');args=p.parse_args()
 try:result=audit(args.evidence_root)
 except (ValueError,OSError,KeyError,IndexError,StopIteration) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 if args.output:pathlib.Path(args.output).write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'verified':True,'counts':result['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
