import datetime,hashlib,json,pathlib,re,shutil
r=pathlib.Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc)
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,d):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(t);t.replace(p)
log=r/'logs/audio-announcer-team-regression.log';text=log.read_text(encoding='utf-8-sig');m=re.search(r'test result: ok\. (\d+) passed; 0 failed;',text);assert m,text[-500:]
proofs={}
for name,count in [('audio_announcer_team_tokens_contract.json',64),('audio_announcer_team_binding_contract.json',256),('audio_announcer_actor_tokens_contract.json',648)]:
 p=r/'data/4.20'/name;d=load(p);assert d['passed'] and len(d['cases'])==count;proofs[name]={'cases':count,'sha256':sha(p)}
definitions_path=r/'data/4.20/announcement_definitions.json';definitions=load(definitions_path)
fixtures=load(r/'docs/audio_test_fixture_loading.json')['references']
for entry in fixtures:
 p=r/entry['fixture'];assert p.stat().st_size==entry['bytes'] and sha(p)==entry['sha256'],entry['fixture']
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'native_team_cases':64,'native_binding_cases':256,'production_rust_output_and_call_trace_comparisons':320,'actor_class_cases_prepared_not_ported':648,'audio_regression_tests_passed':int(m[1]),'contracts':proofs,'log':str(log.relative_to(r)),'log_sha256':sha(log),'production_comparison_log_sha256':sha(r/'logs/announcer-team-production-comparison.log'),'test_executable_sha256':sha(r/'target/debug/deps/openleague_core-92fab3f20accd79c.exe'),'source_sha256':sha(r/'crates/core/src/audio_announcer_team_tokens.rs'),'bank_confirmed_definition_paths':len(definitions['confirmed_event_names']),'unique_bank_confirmed_events':len({x['event_id'] for x in definitions['confirmed_event_names']}),'unresolved_definition_candidates':len(definitions['unresolved']),'limits':['Native team output and case-insensitive binding ported, preserving virtual getter ordering.','Outer source/destination selection and full template scanner remain unqualified.','648 original actor class cases are preparatory evidence; actor class Rust port and live flags remain work.','Bank identity correspondence does not prove event trigger, queue/priority policy, voice admission, mixing or audible playback.'],'next_action':'Port6D3240 actor-class token using648 native cases (identity local/actor, raw flags1C, getter call order, blueHero/purpleHero/redHero when no local). Qualify6D4C22 actor-token binding and outer6D49xx source/destination template scanner. Then import announcement queue/priority policies and connect names to normal client events/admission/mixing; verify audible in-game playback. Preserve CRT/COM/TLS/custom-locale obligations and full24domains114tasks37requirements.'}
backup=r/'docs/plan_history'/('announcer-team-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
receipt['historical_fixture_references_hash_verified']=len(fixtures)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
coverage_path=r/'docs/coverage.json';coverage=load(coverage_path);coverage['announcer_team_tokens_validation']=receipt
coverage['announcement_definitions_validation'].update({'bank_confirmed_names':receipt['bank_confirmed_definition_paths'],'unresolved_candidates':receipt['unresolved_definition_candidates'],'artifact_sha256':sha(definitions_path),'limits':definitions['limits']})
checkpoint_path=r/'docs/resume_checkpoint.json';checkpoint=load(checkpoint_path);checkpoint['saved_utc']=now.isoformat();checkpoint['announcer_team_tokens_validation']=receipt;checkpoint['next_action']=receipt['next_action']+' Whole game incomplete.'
write(r/'docs/announcer_team_tokens_validation.json',receipt);write(coverage_path,coverage);write(checkpoint_path,checkpoint)
shutil.copy2(pathlib.Path('E:/mapslol3v3/recover_announcement_definitions.py'),r/'tools/recover_announcement_definitions.py');shutil.copy2(pathlib.Path(__file__),r/'tools/record_announcer_team_tokens.py')
print(json.dumps({'audio_tests':int(m[1]),'native_comparisons':320,'confirmed_events':receipt['unique_bank_confirmed_events']}))
