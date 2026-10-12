"""Record only completed current-source qualification; never launches tests."""
from pathlib import Path
import datetime, hashlib, importlib.util, json, re, shutil
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/loading_clock_integration');B=S.parent
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def save(p,v):
 p.parent.mkdir(parents=True,exist_ok=True);t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');assert load(t)==v;t.replace(p)
def result(name):
 p=R/'logs'/name;text=p.read_text(encoding='utf-8-sig')
 rows=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out',text)
 assert len(rows)==1 and tuple(map(int,rows[0][1:4]))==(0,0,0) and 'test result: FAILED' not in text,(name,rows)
 runners=re.findall(r'Running unittests .*?\(([^)]+\.exe)\)',text);assert len(runners)==1
 exe=R/runners[0].replace('\\','/')
 return {'passed':int(rows[0][0]),'failed':0,'filtered':int(rows[0][4]),'path':p.relative_to(R).as_posix(),'sha256':sha(p),'executable':exe.relative_to(R).as_posix(),'executable_sha256':sha(exe)},text
def archive():
 target=R/'docs/process_clock_sources';files={}
 groups=['loading_clock_port_agent','loading_clock_sync_agent','loading_clock_client_adapter','loading_empty_integration','loading_empty_integration_extra','process_clock_client_probe','process_clock_client_probe_retirement_fix','process_clock_verifier_retirement_fix','loading_clock_integration']
 for group in groups:
  for src in sorted((B/group).rglob('*')):
   if not src.is_file() or src.suffix not in ['.rs','.py','.json','.md','.txt','.log','.patch','.ps1']:continue
   if any(part in ['production','__pycache__'] for part in src.relative_to(B/group).parts):continue
   rel=Path(group)/src.relative_to(B/group);fixture=R/'data/4.20'/src.name
   if src.suffix=='.json' and fixture.exists() and sha(fixture)==sha(src):files[rel.as_posix()]={'fixture':fixture.relative_to(R).as_posix(),'sha256':sha(src)};continue
   dest=target/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dest);files[rel.as_posix()]={'sha256':sha(dest)}
 save(target/'index.json',{'production_partially_integrated':True,'complete':False,'files':files})
 return {'manifest':(target/'index.json').relative_to(R).as_posix(),'sha256':sha(target/'index.json')}
def archive_prepared_ui():
 src=B/'loading_standard_ui_next';manifest=src/'preparation_manifest.json'
 assert sha(manifest)=='b9d171ee87d411ae4b5d8c932f89dabb53d44c2ed157f0ef7fb1ac78fa79cb3e'
 target=R/'docs/loading_standard_ui_next';rows={}
 for p in sorted(src.rglob('*')):
  if not p.is_file() or '__pycache__' in p.parts:continue
  rel=p.relative_to(src);dest=target/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest);assert sha(p)==sha(dest)
  rows[rel.as_posix()]={'sha256':sha(dest),'bytes':dest.stat().st_size}
 save(target/'index.json',{'complete':False,'production_integrated':False,'rust_ported':False,'native_prefix_lifetimes':128,'before_resource_provider':64,'before_negative_skin_diagnostic':64,'files':rows})
 return {'manifest':(target/'index.json').relative_to(R).as_posix(),'sha256':sha(target/'index.json'),'production_integrated':False,'native_prefix_lifetimes':128,'complete':False}
def archive_shutdown_review():
 src=B/'process_clock_client_shutdown_review';target=R/'docs/process_clock_client_shutdown_review';rows={}
 manifest=src/'manifest.json';assert sha(manifest)=='2d2c9618d276b012abce874cbd0b62f61448b2f88640418244f2c97045cc4015'
 for p in sorted(src.rglob('*')):
  if not p.is_file() or '__pycache__' in p.parts:continue
  rel=p.relative_to(src);dest=target/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest);assert sha(p)==sha(dest)
  rows[rel.as_posix()]={'sha256':sha(dest),'bytes':dest.stat().st_size}
 save(target/'index.json',{'complete':False,'production_integrated':False,'rust_compiled':False,'normal_window_executed':False,'files':rows})
 return {'manifest':(target/'index.json').relative_to(R).as_posix(),'sha256':sha(target/'index.json'),'production_integrated':False,'complete':False}
def archive_service_global():
 src=B/'loading_service_global_preparation';target=R/'docs/loading_service_global_preparation';rows={}
 assert sha(src/'evidence_index.json')=='948151d1000b8e59eb11ab88d46a5282300dbffa6ee2f718f7e853b147ded36e'
 for p in sorted(src.rglob('*')):
  if not p.is_file() or '__pycache__' in p.parts:continue
  rel=p.relative_to(src);dest=target/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest);assert sha(p)==sha(dest)
  rows[rel.as_posix()]={'sha256':sha(dest),'bytes':dest.stat().st_size}
 save(target/'index.json',{'complete':False,'production_integrated':False,'static_analysis_only':True,'native_execution_run':False,'files':rows})
 return {'manifest':(target/'index.json').relative_to(R).as_posix(),'sha256':sha(target/'index.json'),'production_integrated':False,'static_analysis_only':True,'complete':False}
def archive_prefix_candidate():
 src=B/'loading_standard_prefix_port';target=R/'docs/loading_standard_prefix_port';rows={}
 assert sha(src/'preparation_manifest.json')=='0dc254ce2ed85aa29ebb16100898c9429ef6f37a8a6383d306dd6719324cfccc'
 for p in sorted(src.rglob('*')):
  if not p.is_file() or '__pycache__' in p.parts:continue
  rel=p.relative_to(src);dest=target/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest);assert sha(p)==sha(dest)
  rows[rel.as_posix()]={'sha256':sha(dest),'bytes':dest.stat().st_size}
 save(target/'index.json',{'complete':False,'production_integrated':False,'rust_compiled':False,'ready_for_integration':False,'required_repair':'Safe String24 ownership and cleanup after partial descriptor publication or host write failure; qualify separately from native success parity.','files':rows})
 return {'manifest':(target/'index.json').relative_to(R).as_posix(),'sha256':sha(target/'index.json'),'production_integrated':False,'rust_compiled':False,'ready_for_integration':False,'complete':False}
def archive_frozen_preparation(group, manifest, expected_sha256, scope):
 src=B/group;target=R/'docs'/group;rows={}
 assert sha(src/manifest)==expected_sha256,(group,manifest)
 for p in sorted(src.rglob('*')):
  if not p.is_file() or '__pycache__' in p.parts:continue
  rel=p.relative_to(src);dest=target/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest);assert sha(p)==sha(dest)
  rows[rel.as_posix()]={'sha256':sha(dest),'bytes':dest.stat().st_size}
 state={'complete':False,'production_integrated':False,**scope}
 save(target/'index.json',{**state,'files':rows})
 return {'manifest':(target/'index.json').relative_to(R).as_posix(),'sha256':sha(target/'index.json'),**state}
def main():
 core,ct=result('core-process-clock-tests.log');client,cl=result('client-process-clock-tests.log')
 assert core['passed']>=854 and client['passed']>=14,(core,client)
 for name in ['audio_process_clock_actual_concurrent_backend_samples_share_once_and_retire_all_windows_owners','audio_process_clock_bad_callback_releases_once_and_rejects_reuse_before_os_sampling','audio_process_clock_shutdown_retries_mirror_retirement_without_double_heap_free','effects_pause_and_scale_do_not_modify_canonical_loading_time_and_closed_handles_fail','effect_first_frame_does_not_reset_an_origin_previously_used_by_loading']:
  assert re.search(re.escape(name)+r'.*?\.\.\. ok',ct+'\n'+cl),name
 for name in ['audio_process_clock_unadopted_mirror_retries_close_without_double_heap_free_or_lost_primary','audio_process_clock_unknown_cleanup_is_preserved_before_unadopted_mirror_retry','audio_replay_windows_loading_keeps_missing_standard_ui_and_unknown_targets_explicit','audio_replay_windows_loading_standard_matches64_empty_names_through_real_metadata','audio_replay_windows_loading_tutorial_first_names_use_real_clock_once_and_retire_with_owner']:
  assert re.search(re.escape(name)+r'.*?\.\.\. ok',ct),name
 build=R/'logs/client-process-clock-build.log';bt=build.read_text(encoding='utf-8-sig');assert re.search(r'Finished .* target',bt) and not re.search(r'^error(?:\[|:)',bt,re.M)
 spec=importlib.util.spec_from_file_location('clock_client_verifier',S/'verify_client_commands.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);actual=module.verify()
 files=load(S/'installed.json')['files'].copy();files.update(load(S/'client_probe_installed.json')['files'])
 retirement_fix=load(S/'probe_retirement_fix_installed.json')
 assert set(retirement_fix['files'])=={'crates/client/src/main.rs'}
 for rel,row in retirement_fix['files'].items():assert sha(R/rel)==row['after'],rel
 failed_attempt=retirement_fix['archived_failed_attempt']
 for row in failed_attempt.values():assert sha(R/row['path'])==row['sha256']
 repairs=[]
 for rel,row in files.items():
  assert sha(R/rel)==sha(S/'production'/rel),rel
  if sha(R/rel)!=row['after']:repairs.append({'path':rel,'installed_sha256':row['after'],'qualified_sha256':sha(R/rel)})
 # Image bytes remain pinned; final source hashes are checked separately above.
 audit=load(S/'independent_image_verification.json');assert audit['passed'],audit
 image_path=R/'data/4.20/runtime/replay_runtime_image.bin';assert sha(image_path)=='96d9e661b0f71d7c7c23975f02ac267151a936395f9ff04aa2a743d4c060739b'
 now=datetime.datetime.now(datetime.timezone.utc);key='process_clock_validation';receipt='docs/'+key+'.json'
 next_action=('Finish the normal loading-screen lifecycle and standard first-name UI. Canonical993C70/993CE0 now supplies one process origin/frequency to both loading metadata and EffectClock. Real Windows QPF/QPC, source once initialization and type1 mutex ownership are connected; OS-thread FIFO contention is an explicit host adaptation of ConCRT. Standard first empty-name cleanup and tutorial first nonempty-name timestamp run behind packet95 with real metadata providers. Normal5765F0 selection/factories, locale/global publication/shutdown producers, standard57D6FE UI/texture/profile dependencies and live visual fidelity are still required. Diagnostic recipient bindings and selected tests do not establish a finished loading screen. Continue all24 domains114 tasks37 requirements, actual frame decoding/delivery, active transport, normal simulation, maps/champions/gameplay and launcher. Preserve explicit errors for unknown handlers. This is partial technical qualification, not whole-game or human fidelity acceptance.')
 next_action += (' Before integrating the prepared standard-name prefix, repair and qualify String24 ownership after partial descriptor publication; its candidate is explicitly not ready for integration. Also qualify explicit normal-client shutdown and propagation of cleanup failures to the exit status; source-reviewed resource destruction order is already correct, but the current GUI path logs such failures without changing its exit code.')
 limits=[
  'Native clock arithmetic is qualified for x87 CW037F; arbitrary caller control words, x87 exception flags and MSVC SEH/OOM retry semantics are not claimed.',
  'ConCRT internal fiber/scheduler contention is adapted to a Windows OS-thread FIFO with actual private auto-reset events. Native noncontended bytes/order and selected ownership/error cases are checked separately.',
  'Bevy First frame scheduling still needs live comparison to native frame-work/limiter boundaries. The shared raw clock does not prove every game-time consumer is complete.',
  'Loading tests bind diagnostic recipients and initialize explicit native index storage. Normal source factories and standard first-name UI/assets remain unconnected.',
  'The final clock executable probe runs actual plugin frames and local pause/resume delivery; it does not render UI, dispatch loading packets, play clips, connect network decoding or establish complete gameplay.',
  'The runtime retains its single Shared-scope critical section until the final App and clock handle owners drop. The probe verifies report ownership falls from3 to1 with no failures; it does not directly measure Windows DeleteCriticalSection calls.',
  'Normal GUI resource destruction order is source-reviewed, not live-window tested. Cleanup errors logged from Drop do not currently change the client exit code; the explicit shutdown/error-exit proposal is prepared separately and not integrated.',
  'Selected tests, native oracles and executable probes are distinct evidence; no full-game visual/audio/network/endurance or human fidelity acceptance is claimed.'
 ]
 prep_spec=importlib.util.spec_from_file_location('prepared_integrity',S/'validate_prepared_archives.py');prep_module=importlib.util.module_from_spec(prep_spec);prep_spec.loader.exec_module(prep_module);prepared_integrity=prep_module.validate()
 evidence=archive();prepared_ui=archive_prepared_ui();shutdown_review=archive_shutdown_review();service_global=archive_service_global();prefix_candidate=archive_prefix_candidate()
 next_preparations={
  'service_lifecycle_oracle':archive_frozen_preparation('loading_service_lifecycle_oracle','qualification_manifest.json','67fdc5a7e0697fc300b66b59cb6059c6790aba388e5211e433864d86887e5bf3',{'native_cases_passed':52,'rust_compiled':False,'normal_ui_connected':False}),
  'string24_ownership':archive_frozen_preparation('loading_string24_ownership_repair','preparation_manifest.json','2a6d5c62bcf0c5eb4aaca71cf3a59fd922677f85881dd698a7df1012b622d7ff',{'rust_compiled':False,'rust_tests_run':False,'ready_for_integration':False,'required_work':'Wire typed remaining ownership and scratch lease through the caller, then compile and qualify.'}),
  'explicit_client_shutdown':archive_frozen_preparation('client_shutdown_candidate','manifest.json','df1475670bc8569713cbc496b11fdb1f3a5dc0446a89e93d6a63ce4e904da2b2',{'rust_compiled':False,'rust_tests_run':False,'ready_for_integration':False,'required_work':'Repair the premature critical_sections==0 assertion using the established Shared-scope lifetime, then compile and qualify the shutdown/error-exit integration.'}),
 }
 for group,state in prepared_integrity['groups'].items():
  for rel,row in state['files'].items():
   source=B/group/rel;dest=R/'docs'/group/rel
   assert sha(source)==sha(dest)==row['sha256'] and dest.stat().st_size==row['bytes'],(group,rel)
 value={'saved_utc':now.isoformat(),'passed':True,'complete':False,'core_tests':core,'client_tests':client,'client':actual,'evidence':evidence,'prepared_standard_ui_prefix':prepared_ui,'prepared_client_shutdown':shutdown_review,'prepared_service_global_lifecycle':service_global,'prepared_standard_prefix_candidate':prefix_candidate,
  'image':{'regions':61,'bytes':image_path.stat().st_size,'sha256':sha(image_path),'independent_audit':'docs/process_clock_sources/loading_clock_integration/independent_image_verification.json'},
  'native_clock_sequences':253,'native_clock_calls':349,'native_clock_events':3387,'physical_x87_outputs':277,'native_once_noncontended_cycles':64,'native_once_boundary_cycles':64,'native_outer_once_cases':34,'native_mutex_allocation_cases':8,
  'native_standard_empty_name_lifetimes':16,'native_standard_empty_name_calls':64,'windows_tutorial_nonempty_packets':4,'windows_concurrent_clock_samples':256,
  'windows_clock_connected':True,'client_effect_clock_shares_origin':True,'standard_empty_first_name_connected':True,'tutorial_nonempty_first_name_connected':True,'normal_screen_factory_connected':False,'standard_first_ui_connected':False,'normal_service_global_publication_connected':False,
  'source_hashes':{rel:sha(R/rel) for rel in files if not rel.startswith('data/')},'resource_hashes':{rel:sha(R/rel) for rel in files if rel.startswith('data/')},'qualified_repairs':repairs,
  'build_log':{'path':build.relative_to(R).as_posix(),'sha256':sha(build)},'limits':limits,'next_action':next_action,'prepared_next_evidence':next_preparations,'prepared_archive_integrity':{key:item for key,item in prepared_integrity.items() if key!='groups'},
  'qualification_history':{
   'first_core_attempt':{'path':'logs/core-process-clock-tests-attempt1.log','sha256':sha(R/'logs/core-process-clock-tests-attempt1.log'),'passed':849,'failed':3,'cause':'First-name tests omitted the explicitly required diagnostic service-global binding. Final tests publish the actual constructed service, verify its native vtable slots, then restore the original global before destruction. No normal application publication is claimed.'},
   'first_clock_command':{'exit_code':101,'exit_code_source':'Observed original runner failure output; the runner stopped before creating command-run.json.','executable_sha256':retirement_fix['previous_executable_sha256'],'archives':failed_attempt,'exercise_passed':True,'cleanup_assertion_passed':False,'cause':'The diagnostic incorrectly required zero Shared-scope sections before its retained App/clock owners dropped. The repaired probe records the source-required single section, explicitly drops the last owners, then observes report3->1 and no failures.'},
   'probe_only_repair':{'files':retirement_fix['files'],'selected_tests_precede_probe_only_repair':True,'core_and_effect_implementation_unchanged_by_repair':True,'final_probe_rebuilt_and_executed':True,'final_main_sha256':sha(R/'crates/client/src/main.rs')},
  },
  'windows_contract_references':['https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancefrequency','https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-waitforsingleobject','https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-createeventa']}
 summary={'saved_utc':now.isoformat(),'passed':True,'complete':False,'receipt':receipt,'core_tests_passed':core['passed'],'client_tests_passed':client['passed'],'client_commands':actual['commands'],'client_workers':actual['workers'],'client_executable_sha256':actual['executable_sha256'],'shared_process_clock_connected':True,'normal_loading_screen_complete':False,'qualification_sequence':'Core and client tests passed before the diagnostic-only final-drop correction; unchanged runtime/effect implementation, then final client rebuilt and all11 commands verified.'}
 docs={}
 for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
  doc=load(R/'docs'/name);doc[key]=summary;doc['updated_utc']=now.isoformat();doc['next_action']=next_action;doc['prepared_standard_ui_prefix']=prepared_ui;doc['prepared_client_shutdown']=shutdown_review;doc['prepared_service_global_lifecycle']=service_global;doc['prepared_standard_prefix_candidate']=prefix_candidate;doc['prepared_next_evidence']=next_preparations
  if name=='resume_checkpoint.json':
   doc['saved_utc']=now.isoformat();doc['state']='active';doc.pop('in_progress',None);doc.setdefault('last_verified',{}).update(process_clock_receipt=receipt,process_clock_selected_core_tests=core['passed'],process_clock_selected_client_tests=client['passed'])
  for prep in doc.get('prepared_loading_next',{}).values():
   if 'clock' in prep.get('manifest','') or 'empty' in prep.get('manifest',''):prep.update(production_partially_integrated=True,integration_receipt=receipt,complete=False)
  if name=='completion_plan.json':
   domain=next(d for d in doc['domains'] if d['id']=='21');domain.setdefault('progress_evidence',[])
   if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
   for task in domain['tasks']:
    if task['id'] in ['21.3','21.4'] and receipt not in task['evidence']:task['evidence'].append(receipt)
   doc['next_execution_steps'][0]=next_action
  docs[name]=doc
 html=R/'docs/completion_plan.html';body=html.read_text(encoding='utf-8');marker='process-clock-validation';assert marker not in body
 section=f'<section id="{marker}"><h2>Horloge commune au chargement et aux animations</h2><p>Une seule origine et fréquence du processus alimentent le chargement et EffectClock. Les premiers noms tutoriels et les noms standard vides sont traités. {core["passed"]} tests moteur ciblés et {client["passed"]} tests client passent. Le contrôle de destruction finale a ensuite été corrigé dans le seul diagnostic, sans modifier le moteur ni les effets ; les {actual["commands"]} commandes passent sur le client reconstruit après cette correction. Les contrôles couvrent la pause/reprise, la contention et le nettoyage. Le rendu UI standard et les factories normales restent à intégrer et à vérifier ; le jeu complet reste en cours.</p></section>'
 backup=R/'docs/plan_history'/('process-clock-validation-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
 for name in [*docs,'completion_plan.html']:shutil.copyfile(R/'docs'/name,backup/name)
 save(R/receipt,value)
 for name,doc in docs.items():save(R/'docs'/name,doc)
 html.write_text(body.replace('</body>',section+'</body>'),encoding='utf-8')
 for group in ['source_hashes','resource_hashes']:
  for rel,digest in value[group].items():assert sha(R/rel)==digest,rel
 print(json.dumps(summary))
if __name__=='__main__':main()
