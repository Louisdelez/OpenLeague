"""Readonly source/observation verifier; no native/Lua/CSharp scenario replay."""
import argparse,copy,hashlib,json,math,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3')
sys.path.insert(0,str(R/'tools/project-plan'));sys.path.insert(0,str(R/'tools'));sys.path.insert(0,str(R/'tools/pythonlibs'))
import pefile,capstone
from native_lua import Chunk,initialization
from lua51_reference import Reader
from rads_reference_membership import RadsReferenceMembership
from audit_native_community_callbacks import function_names,words,adapted_identity
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def need(ok,why):
 if not ok:raise ValueError(why)
def same_float32(a,b):return struct.pack('<f',a)==struct.pack('<f',b)

def audit(evidence_root,inputs_override=None,init_override=None,callbacks_override=None,comparison_override=None,component_override=None,observation_override=None,bindings_override=None):
 v=pathlib.Path(evidence_root).resolve(strict=True);need(v.is_relative_to(S.resolve()),'Evidence outside workspace')
 inputs=load(v/'camp-review-inputs-v2.json') if inputs_override is None else inputs_override;need(inputs['schema']=='openleague_camp_review_inputs/v1','Wrong input schema')
 need(inputs['whole_script_or_engine_timer_anchor_qualified'] is False and inputs['current_Rust_gameplay_executed'] is False,'Unsupported whole behavior claim')
 identities={};tools={}
 def keep(x,tool=False):
  p=pathlib.Path(x['path']).resolve(strict=True);allowed=[R.resolve(),S.resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]
  need(any(p.is_relative_to(a) for a in allowed) or tool and (p==pathlib.Path(sys.executable).resolve() or p.is_relative_to(pathlib.Path('C:/Program Files/dotnet').resolve())),'Source outside allowed roots')
  need(all(pin(p)[k]==x[k] for k in ['bytes','sha256']),'Changed source identity');(tools if tool else identities)[str(p).casefold()]=x;return p
 for key in ['producer','reference','initialization_probe','source_comparison','callback_probe','community_component','binding_search','existing_static_reader','callback_reader','format_audit_dependency','native_binding_code','previous_input']:keep(inputs[key])
 reference=load(inputs['reference']['path']);need(reference['client']['version']=='4.20.0.315' and reference['client']['channel']=='PUBLIC' and reference['client']['branch']=='Releases/4.20' and reference['reference']['region']=='EUW' and reference['reference']['locale']=='en_GB','Wrong historical reference')
 init=load(inputs['initialization_probe']['path']) if init_override is None else init_override
 cb=load(inputs['callback_probe']['path']) if callbacks_override is None else callbacks_override
 comp=load(inputs['source_comparison']['path']) if comparison_override is None else comparison_override
 cs=load(inputs['community_component']['path']) if component_override is None else component_override
 obs=load(cs['observation']['path']) if observation_override is None else observation_override
 binding=load(inputs['native_binding_code']['path']) if bindings_override is None else bindings_override
 need(init['schema']=='openleague_original_map10_neutral_initialization_lua51/v1' and cb['schema']=='openleague_original_map10_neutral_callbacks_lua51/v1','Wrong native observation schema')
 need(cb['inherited_initialization_probe']==inputs['initialization_probe'] and comp['probe']==inputs['initialization_probe'],'Wrong initialization lineage')
 for record in [init,cb]:
  p=keep(record['source']);keep(record['producer']);adapter=keep(record['format_adapter']);keep(record['runtime']['python'],True);keep(record['runtime']['lua_module'])
  need(record['source']==init['source'] and record['runtime']['reported_version']=='Lua 5.1','Wrong original source/runtime')
  proto=Reader(p.read_bytes()).parse();need(record['raw32_roundtrip_exact'] is True and record['instruction_arrays_preserved'] is True and record['instruction_array_sha256']==words(proto) and record['adapted_sha256']==adapted_identity(p.read_bytes(),adapter),'Original arrays/adaptation changed')
 membership=RadsReferenceMembership(R);need(membership.inspect(p.relative_to(pathlib.Path(membership.deploy)).as_posix(),p,init['source'])==init['membership'] and init['membership']['status']=='matches_selected_project_manifest','Wrong exact manifest member')
 names=function_names(proto);need([names[i][0]['name'] for i in range(5)]==['NeutralMinionInit','CreateRespawnNeutralTimer','InitializeNeutralMinionInfo','SpawnInitialNeutralMinions','NeutralMinionDeath'],'Wrong callback bindings')
 need([len(x['words']) for x in proto['children']]==[243,4,64,77,70] and len(proto['children'][1]['children'][0]['words'])==79,'Wrong source callback bodies')
 need(init['executed_callbacks']==[{'name':names[i][0]['name'],'prototype_index':i,'code_sha256':proto['children'][i]['code_sha256'],'instructions':len(proto['children'][i]['words'])} for i in [0,2]],'Wrong original initializer selection')
 need(cb['selected_prototypes']=={'CreateRespawnNeutralTimer':1,'returned_spawn_closure':[1,0],'SpawnInitialNeutralMinions':3,'NeutralMinionDeath':4},'Wrong lifecycle prototype selection')
 need(all(init[k] is False for k in ['actual_engine_vector_API_or_camp_creation_qualified','actual_scheduler_spawn_or_death_qualified','CSharp_or_Rust_gameplay_executed','integrated_into_registry']) and all(cb[k] is False for k in ['native_engine_API_implementation_executed','native_initial_clock_anchor_qualified','actual_game_event_producer_or_duplicate_dispatch_qualified','CSharp_or_Rust_gameplay_executed','integrated_into_registry']),'Unsupported engine/clock/event qualification')
 for key in ['producer','probe','existing_native_top_level_recovery','existing_recovery_producer','current_world_config','current_separate_interaction_config','community_source']:keep(comp[key])
 prior=load(comp['existing_native_top_level_recovery']['path']);reader=Chunk(p.read_bytes());static=json.loads(json.dumps(initialization(reader.function())))
 need(prior['source_sha256']==init['source']['sha256'] and prior['globals']==static['globals'] and prior['stopped']==static['stopped']=={'pc':364,'opcode':20}==comp['prior_recovery_stopped_field'],'Prior static recovery mismatch')
 g=prior['globals'];camps=init['snapshots']['InitializeNeutralMinionInfo'];need(len(camps)==8,'Wrong native camp count')
 need(init['snapshots']['top_level']['NUMBER_OF_CAMPS']==8 and [init['snapshots']['top_level'][s] for s in ['TEAM_ORDER','TEAM_CHAOS','TEAM_NEUTRAL']]==[100,200,300],'Wrong original globals')
 literal_writes=[(proto['children'][0]['constants'][((w>>23)&511)-256],proto['children'][0]['constants'][((w>>14)&511)-256]) for w in proto['children'][0]['words'] if w&63==9 and ((w>>23)&511)>=256 and ((w>>14)&511)>=256]
 sizes=[];all_names=[];native_delays=[15]*6+[95,515];respawns=[50]*6+[90,300]
 for i,c in enumerate(camps,1):
  group=g['PredefinedCamps'][str(float([1,2,3,1,2,3,4,5][i-1]))];models=[group[str(j)] for j in range(1,len(group)+1)];size=len(models);sizes.append(size)
  need(c['Groups']==[models] and c['GroupsChance']==[100] and c['GroupDelaySpawnTime']==native_delays[i-1] and c['GroupsRespawnTime']==respawns[i-1],'Changed native camp model/chance/delay')
  for field in ['GroupsRespawnTime','GroupDelaySpawnTime','CampLevel','HealthBonus','DamageBonus','MinimapIcon','TimerType']:
   need((field,c[field]) in literal_writes,'Camp literal missing from original initializer writes')
  need(c['Team']==300 and c['AIState']==0 and c.get('GroupBuffSide')==(100 if i<=3 else 200 if i<=6 else None),'Wrong native state/team fields')
  need(c['CampLevel']==(1 if i<=6 else 3 if i==7 else 2) and c['HealthBonus']==c['DamageBonus']==0 and c['MinimapIcon']==c['TimerType']=='','Wrong native initialization fields')
  expected_positions=[{'observed_xyz':[g['CampSpawnPoints'][str(i)][str(j)][axis] for axis in ['x','y','z']]} for j in range(1,size+1)]
  expected_faces=[{'observed_xyz':[g['CampFacePoints'][str(i)][str(j)][axis] for axis in ['x','y','z']]} for j in range(1,size+1)]
  unique=[model+str(i)+'.1.'+str(j) for j,model in enumerate(models,1)];all_names.extend(unique)
  need(c['Positions']==expected_positions and c['FacePositions']==expected_faces and c['UniqueNames']==[unique] and c['AliveTracker']==[] and c['Timer']=={'original_Lua_function_not_invoked':True},'Wrong original coordinates/names/timer')
 need(sizes==[3,2,3,3,2,3,1,1] and len(all_names)==18,'Wrong original members')
 need(init['counts']=={'camps':8,'point_constructor_requests':36,'character_preload_requests':8,'create_camp_requests':8,'timer_engine_requests':0},'Wrong initialization aggregate')
 need(len(init['calls'])==52 and sum(c['api']=='Make3DPoint' and len(c['args'])==3 for c in init['calls'])==36,'Wrong point observations')
 expected_points=[tuple(point[axis] for axis in ['x','y','z']) for field in ['CampSpawnPoints','CampFacePoints'] for points in g[field].values() for point in points.values()]
 need(sorted(tuple(c['args']) for c in init['calls'] if c['api']=='Make3DPoint')==sorted(expected_points),'Changed point constructor arguments')
 before_info=copy.deepcopy(camps)
 for camp in before_info:camp.pop('Timer');camp['UniqueNames']=[]
 need(init['snapshots']['NeutralMinionInit']==before_info and init['snapshots']['top_level']['NeutralMinionCamps']==[[] for _ in range(8)],'Wrong initialization phase snapshots')
 preloads=[c['args'][0] for c in init['calls'] if c['api']=='PreloadCharacter'];need(sorted(preloads)==sorted(g['NeutralMinionNames'].values()),'Wrong preload requests')
 creates=[c for c in init['calls'] if c['api']=='CreateNeutralCamp'];need([c['args'] for c in creates]==[[camp,i] for i,camp in enumerate(camps,1)],'Wrong requested camp payload')
 need(init['returns']==[{'callback':n,'return_count':0,'return_first':None} for n in ['NeutralMinionInit','InitializeNeutralMinionInfo']],'Wrong initialization return shapes')
 profiles=[(roll,i) for roll in [1,100] for i in range(1,9)]
 need([(x['provided_random_roll'],x['camp']) for x in cb['initial_cases']]==profiles and [(x['provided_random_roll'],x['camp']) for x in cb['spawn_cases']]==profiles,'Incomplete lifecycle profiles')
 for initial,spawn in zip(cb['initial_cases'],cb['spawn_cases'],strict=True):
  i=initial['camp'];roll=initial['provided_random_roll'];size=sizes[i-1];random={'api':'math.random','args':[100],'provided_result':roll}
  need(initial['calls']==[random] and initial['return_count']==0 and initial['alive_tracker']==[True]*size and all(a is True for a in initial['alive_tracker']) and initial['engine_spawn_or_timer_requested'] is False,'Initial markers changed into engine actions')
  need(spawn['return_count']==0 and spawn['original_timer_closure_invoked'] is True and spawn['alive_tracker']==[True]*size and all(a is True for a in spawn['alive_tracker']) and len(spawn['calls'])==size+1 and spawn['calls'][0]==random,'Wrong spawn closure observation')
  for j,request in enumerate(spawn['calls'][1:],1):
   expected=copy.deepcopy(camps[i-1]);expected['Timer']={'original_timer_closure_for_camp':i};expected['AliveTracker']=[True]*(j-1)
   need(request=={'api':'SpawnNeutralMinion','args':[expected,i,1,j]},'Wrong requested spawn payload')
 expected_deaths=[]
 for i,c in enumerate(camps,1):
  for j,name in enumerate(c['UniqueNames'][0],1):expected_deaths.append((i,'ordered_member_death',name,j))
  expected_deaths.append((i,'duplicate_last_member_death',c['UniqueNames'][0][-1],None))
 expected_deaths.append((None,'unknown_member_name','UNKNOWN_MEMBER',None))
 need(len(cb['death_cases'])==27 and len(cb['bootstrap_profiles'])==2 and cb['bootstrap_profiles']==[{'provided_random_roll':roll,'preload_requests':8,'create_camp_requests':8} for roll in [1,100]],'Wrong bootstrap/death coverage')
 for case,(i,kind,name,j) in zip(cb['death_cases'],expected_deaths,strict=True):
  need(case['camp']==i and case['profile']==kind and case['name']==name and case['return_count']==0,'Wrong death profile identity')
  if i is None:need(case['calls']==[] and case['all_camps_unchanged'] is True,'Unknown name changed state');continue
  size=sizes[i-1];last=kind=='duplicate_last_member_death' or j==size
  timer=[{'api':'InitNeutralMinionTimer','args':[{'original_timer_closure_for_camp':i},'',respawns[i-1],0,False]}] if last else []
  dead=size if j is None else j;need(case['calls']==timer and case['alive_tracker']==[False]*dead+[True]*(size-dead) and all(type(a) is bool for a in case['alive_tracker']),'Wrong death/duplicate timer or alive markers')
 need(cb['counts']=={'fresh_environments':2,'initial_callback_profiles':16,'spawn_closure_profiles':16,'death_callback_profiles':27,'spawn_API_requests':36,'respawn_timer_API_requests':16,'duplicate_death_timer_requests':8},'Wrong lifecycle totals')
 need(cs['schema']=='openleague_community_map10_camp_component/v1' and obs['schema']=='openleague_community_map10_camp_component_observation/v1','Wrong CSharp component schema')
 for key in ['producer','source','method_extraction','original_enum','enum_copy','extractor','assembly','observation']:keep(cs[key])
 keep(cs['dotnet'],True);need(keep(cs['original_enum']).read_bytes()==keep(cs['enum_copy']).read_bytes(),'Modified actual TeamId enum')
 extracted=load(cs['method_extraction']['path']);methods=extracted['methods'];need([m['method'] for m in methods]==['InitializeCamps','OnUpdate','GetRespawnTimer'] and cs['compiled_methods']==[methods[0],methods[2]],'Incorrect compiled/source-only selection')
 for m in methods:
  raw_text=keep(m['source']).read_bytes().decode('utf-8-sig');wide=raw_text.encode('utf-16-le')
  for field,span,sha in [('method_text','method_span_utf16','method_sha256_utf8'),('body','body_span_utf16','body_sha256_utf8')]:
   a=m[span]['start'];end=a+m[span]['length'];fragment=wide[a*2:end*2].decode('utf-16-le');need(fragment==m[field] and hashlib.sha256(fragment.encode()).hexdigest()==m[sha],'Changed exact method/body span')
 host={pathlib.Path(x['path']).name:keep(x) for x in cs['host_sources']};selected=host['SelectedMethods.cs'].read_bytes().decode('utf-8')
 need(all(selected.count(m['method_text'])==1 for m in cs['compiled_methods']) and '<clear />' in host['NuGet.Config'].read_text() and '<TargetFramework>net8.0</TargetFramework>' in host['CampComponent.csproj'].read_text(),'Wrong full methods/feeds/framework')
 need(len(cs['commands'])==4 and all(c['exit_code']==0 and c['command'][0]==str(pathlib.Path('C:/Program Files/dotnet/dotnet.exe')) for c in cs['commands']),'Failed component execution')
 for command in cs['commands']:keep(command['log'])
 for x in extracted['roslyn']:keep(x['source'])
 need(all(cs[k] is False for k in ['native_initial_clock_anchor_qualified','whole_community_script_qualified','current_Rust_gameplay_executed']) and obs['native_engine_or_full_server_executed'] is False and obs['omitted_ai_script_default_qualified'] is False,'Unsupported whole CSharp server claim')
 need(len(obs['camps'])==8 and len(obs['observed_calls'])==26 and obs['unknown_camp_respawn_control']=={'index':99,'observed_milliseconds':50000},'Wrong CSharp camp/default profiles')
 mismatches=[];community_initial=[100]*6+[115,600]
 for i,(native,community) in enumerate(zip(camps,obs['camps'],strict=True),1):
  need(community['index']==i and community['initial_milliseconds']==community_initial[i-1]*1000 and community['respawn_milliseconds']==respawns[i-1]*1000 and community['side']==(100 if i<=3 else 200 if i<=6 else 0),'Changed CSharp timer or map-side values')
  need(len(community['members'])==sizes[i-1] and community['position']['y']==60 and community['icon']==('Camp' if i<=6 else 'HealthPack' if i==7 else 'Epic'),'Changed CSharp camp construction')
  for j,m in enumerate(community['members'],1):
   native_name=native['UniqueNames'][0][j-1];expected_name=native_name+('f' if (i,j) in [(4,2),(5,1)] else '')
   need(m['name']==expected_name and m['model']==native['Groups'][0][j-1] and m['ai_script']==('BasicJungleMonsterAI' if i<=6 else 'UNQUALIFIED_OMITTED_DEFAULT'),'Changed CSharp member/name/default observation')
   position=native['Positions'][j-1]['observed_xyz'];face=native['FacePositions'][j-1]['observed_xyz']
   need(same_float32(m['position']['x'],position[0]) and same_float32(m['position']['z'],position[2]) and all(same_float32(m['face_position'][axis],face[k]) for k,axis in enumerate(['x','y','z'])),'Changed CSharp position/face')
   if m['name']!=native_name:mismatches.append({'native_name':native_name,'community_name':m['name']})
 need(len(mismatches)==2,'Wrong unique-name discrepancy count')
 expected_calls=[]
 for camp in obs['camps']:
  expected_calls.append('CreateJungleCamp:'+str(camp['index']))
  expected_calls.extend('CreateJungleMonster:'+str(camp['index'])+':'+m['name'] for m in camp['members'])
  need(same_float32(camp['position']['x'],camp['members'][0]['position']['x']) and same_float32(camp['position']['z'],camp['members'][0]['position']['z']),'Changed CSharp camp center')
 need(obs['observed_calls']==expected_calls,'Changed CSharp creation call sequence')
 native_names={name:model for camp in camps for name,model in zip(camp['UniqueNames'][0],camp['Groups'][0],strict=True)}
 expected_mismatches=[{'community_name':m['name'],'model':m['model'],'native_names_for_model':[n for n,model in native_names.items() if model==m['model']]} for camp in obs['camps'] for m in camp['members'] if m['name'] not in native_names]
 need(comp['community_declared_names_count']==18 and comp['community_name_candidates_not_matching_original']==expected_mismatches,'Changed name discrepancy details')
 world=load(comp['current_world_config']['path']);interaction=load(comp['current_separate_interaction_config']['path']);member_rows=[];camp_rows=[]
 for i,c in enumerate(camps,1):
  if i==7:current_delay=interaction['relic_initial_seconds'];current_respawn=interaction['relic_respawn_seconds'];members=[{'definition':'TT_Relic','position':interaction['relic_position'],'height':interaction['relic_height']}]
  else:current=next(x for x in world['camps'] if x['index']==i);current_delay=current['initial_seconds'];current_respawn=current['respawn_seconds'];members=current['members']
  need(current_respawn==respawns[i-1] and current_delay-c['GroupDelaySpawnTime']==85 and len(members)==sizes[i-1],'Wrong current camp timing/member data')
  for j,(member,pos,face,model) in enumerate(zip(members,c['Positions'],c['FacePositions'],c['Groups'][0],strict=True),1):
   x,y,z=pos['observed_xyz'];fx,fy,fz=face['observed_xyz'];need(member['definition']==model and member['position']=={'x':x,'z':z} and member['height']==y,'Changed current member coordinates/model')
   if i!=7:need(math.isclose(math.atan2(fx-x,fz-z),member['facing'],rel_tol=0,abs_tol=1e-12),'Changed current source facing')
   member_rows.append({'camp':i,'member':j,'native_model':model,'native_unique_name':c['UniqueNames'][0][j-1],'position_and_height_raw_JSON_match':True,'native_position':[x,y,z],'native_face_position':[fx,fy,fz],'current_facing_matches_atan2_source_vector':i!=7,'relic_facing_current_scope':'Separate interaction; no facing claim' if i==7 else None})
  camp_rows.append({'camp':i,'native_delay_field':native_delays[i-1],'current_initial_seconds':current_delay,'literal_initial_difference':85,'native_respawn_field':respawns[i-1],'current_respawn_seconds':current_respawn,'timer_anchor_or_absolute_schedule_qualified':False,'native_team':300,'native_buff_side':c.get('GroupBuffSide')})
 need(comp['camp_rows']==camp_rows and comp['member_rows']==member_rows and comp['counts']=={'native_camps':8,'current_world_camps':7,'current_separate_relic':1,'raw_model_position_height_matches':18,'source_vector_facing_matches':17,'matching_respawn_literal_fields':8,'common_initial_literal_offset':85,'community_unique_name_differences':2},'Changed source comparison')
 need(all(comp[k] is False for k in ['native_engine_timer_anchor_qualified','whole_community_script_qualified','current_Rust_gameplay_executed','integrated_into_registry']),'Unsupported current timing/gameplay acceptance')
 need(len(comp['current_source_anchors'])==4 and len(inputs['community_anchors'])==6,'Missing actual source consumers')
 for a in comp['current_source_anchors']+inputs['community_anchors']:
  lines=keep(a['source']).read_text('utf-8-sig').splitlines();need(a['excerpt']==lines[a['line']-1] and a['needle'] in a['excerpt'] and sum(a['needle'] in l for l in lines)==1,'Changed actual source consumer')
 version=inputs['community_script_version'];need(all(pin(version['path'])[k]==version[k] for k in ['bytes','sha256']) and version['version']['exact_file_version']=='sha256:'+version['sha256'] and version['version']['head_blob_identity_not_assumed'] is True,'Wrong community snapshot/version')
 level=inputs['native_level_context'];lp=keep(level['source']);level_proto=Reader(lp.read_bytes()).parse();need(level['prototype_index']==4 and level['callback']=='OnLevelInit' and level_proto['children'][4]['code_sha256']==level['code_sha256'] and level_proto['children'][4]['constants']==level['constants'],'Changed original map context')
 need(membership.inspect('LEVELS/Map10/Scripts/LevelScript.luaobj',lp,level['source'])==level['membership'],'Wrong native map membership')
 search=load(inputs['binding_search']['path']);pe_path=keep(search['source']);pe_bytes=pe_path.read_bytes();pe=pefile.PE(data=pe_bytes);base=pe.OPTIONAL_HEADER.ImageBase
 for query in search['queries']:
  pattern=query['name'].encode(query['encoding']);found=[];at=0
  while True:
   at=pe_bytes.find(pattern,at)
   if at<0:break
   found.append(at);at+=1
  need(found==query['offsets'],'Changed bounded PE name search')
 need(binding['source']==search['source'] and binding['native_machine_code_executed'] is False and binding['historical_clock_anchor_qualified'] is False and len(binding['bindings'])==3 and len(binding['spans'])==11,'Wrong native binding scope')
 keep(binding['producer']);keep(binding['name_search'])
 for x in binding['tools']:keep(x)
 md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
 for span in binding['spans']:
  off=pe.get_offset_from_rva(span['VA']-base);data=pe_bytes[off:off+span['bytes']];decoded=[{'VA':i.address,'bytes':bytes(i.bytes).hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in md.disasm(data,span['VA'])]
  need(off==span['file_offset'] and hashlib.sha256(data).hexdigest()==span['sha256'] and decoded==span['instructions'] and sum(len(bytes.fromhex(i['bytes'])) for i in decoded)==len(data),'Changed bounded original code span')
 need([(b['name'],b['registered_function_pointer_VA']) for b in binding['bindings']]==[('InitNeutralMinionTimer',0x6a6e80),('CreateNeutralCamp',0x6a7120),('SpawnNeutralMinion',0x6a7120)] and all(b['runtime_registration_or_game_API_qualified'] is False for b in binding['bindings']),'Changed registration candidates')
 need(binding['image_base']==base,'Changed native image base')
 for candidate,(name,start,wrapper,bridge,target) in zip(binding['bindings'],[('InitNeutralMinionTimer',0x6a5895,0x6b86e0,0x6bc8c0,0x6a6e80),('CreateNeutralCamp',0x6a58b9,0x6b8600,0x6bc740,0x6a7120),('SpawnNeutralMinion',0x6a58dd,0x6b8700,0x6bc9b0,0x6a7120)],strict=True):
  string_offset=next(q for q in search['queries'] if q['name']==name and q['encoding']=='ascii')['offsets'][0]
  need(candidate=={'name':name,'string_VA':base+pe.get_rva_from_offset(string_offset),'registration_span_VA':start,'wrapper_VA':wrapper,'conversion_bridge_VA':bridge,'registered_function_pointer_VA':target,'runtime_registration_or_game_API_qualified':False},'Wrong named registration/wrapper binding')
 return {'schema':'openleague_camp_reference_audit/v1','verified':True,'counts':{**comp['counts'],**cb['counts'],'inherited_initialization_callbacks':2,'selected_CSharp_whole_methods':2,'CSharp_source_only_methods':1,'native_binding_candidates':3,'bounded_native_code_spans':11,'community_source_anchors':6,'current_Rust_source_anchors':4,'fully_qualified_community_scripts':0},
  'source_identities':list(identities.values()),'tool_identities':list(tools.values()),'comparison':{'camp_rows':camp_rows,'community_initial_seconds':community_initial,'unique_name_differences':mismatches},'current_consumer_evidence':comp['current_source_anchors'],
  'candidate_scripts':[{'relative_path':'Maps/Map10/NeutralMinionSpawn.cs','source':cs['source'],'git_snapshot':version['version'],'native_candidates':[init['source']['path']],'dispatch_qualified':False}],
  'inherited_native_experiments':[inputs['initialization_probe']],'fresh_native_experiments':[inputs['callback_probe']],'fresh_CSharp_component_experiments':[inputs['community_component']],
  'declared_boundaries':['Original initial timer anchor and absolute spawn clock remain unqualified; the observed offset85 is a data comparison.','Original Lua requests are observed; engine vector/camp creation/spawning/scheduling implementations are not executed.','Three PE registration candidates and eleven static spans are identified, without executing registration or full native APIs.','Duplicate last-member death callbacks request a timer again; actual event producer and rescheduling behavior remain unknown.','Exact CSharp initializer/respawn methods run on .NET8 with observation hosts, not the full server or AI.','Current seven world camps and separate relic consumer exist; source coordinate/facing checks do not qualify Rust runtime gameplay.'],
  'native_engine_API_or_original_argument_producer_qualified':False,'current_Rust_or_CSharp_gameplay_qualified':False,'historical_game_process_launched':False}

def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output');args=p.parse_args()
 try:result=audit(args.evidence_root)
 except (ValueError,OSError,KeyError,IndexError,StopIteration) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 if args.output:pathlib.Path(args.output).write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'verified':True,'counts':result['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
