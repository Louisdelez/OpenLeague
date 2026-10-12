import datetime,hashlib,json,pathlib,shutil,re
r=pathlib.Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p,d):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(t);t.replace(p)
log=r/'logs/audio-initialized-announcer-regression.log';text=log.read_text(encoding='utf-8-sig');match=re.search(r'test result: ok\. (\d+) passed; 0 failed;',text);assert match,text[-500:]
proof_path=r/'data/4.20/audio_initialized_announcer_namespace_contract.json';proof=load(proof_path);definitions_path=r/'data/4.20/announcement_definitions.json';definitions=load(definitions_path)
assert proof['passed'] and len(proof['cases'])==36
team_path=r/'data/4.20/audio_announcer_team_tokens_contract.json';team_proof=load(team_path);assert team_proof['passed'] and len(team_proof['cases'])==64
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'native_cases':36,'standalone_production_resolver_comparisons':36,'audio_regression_tests_passed':int(match[1]),'native_contract':str(proof_path.relative_to(r)),'native_contract_sha256':sha(proof_path),'log':str(log.relative_to(r)),'log_sha256':sha(log),'bank_confirmed_definition_paths':len(definitions['confirmed_event_names']),'unique_bank_confirmed_events':len({x['event_id'] for x in definitions['confirmed_event_names']}),'unresolved_definition_candidates':len(definitions['unresolved']),'sources':{n:sha(r/n) for n in ['crates/core/src/audio_legacy_paths.rs','crates/core/src/audio_announcer_names.rs','data/4.20/announcement_definitions.json']},'limits':proof['limits'],'next_action':'Port original announcement-template substitutions (team/player/minion/turret) and queue/priority policies; connect initialized voice namespace to normal client dispatch/admission/mixing and verify in-game audio. Preserve remaining worker CRT/COM/TLS, custom locale and full game obligations.'}
backup=r/'docs/plan_history'/('initialized-announcer-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
receipt['native_team_token_cases_prepared']=64
receipt['native_team_token_contract_sha256']=sha(team_path)
receipt['test_executable_sha256']=sha(r/'target/debug/deps/openleague_core-92fab3f20accd79c.exe')
receipt['standalone_production_comparison_log_sha256']=sha(r/'logs/initialized-announcer-production-comparison.log')
receipt['next_action']='Port original6D3630 team-token function using64 native cases; qualify template evaluator binding and player/minion/turret substitutions. '+receipt['next_action']
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
coverage_path=r/'docs/coverage.json';coverage=load(coverage_path);coverage['initialized_announcer_namespace_validation']=receipt;coverage['announcement_definitions_validation']['bank_confirmed_names']=receipt['bank_confirmed_definition_paths'];coverage['announcement_definitions_validation']['unresolved_candidates']=receipt['unresolved_definition_candidates'];coverage['announcement_definitions_validation']['artifact_sha256']=sha(definitions_path)
checkpoint_path=r/'docs/resume_checkpoint.json';checkpoint=load(checkpoint_path);checkpoint['saved_utc']=now.isoformat();checkpoint['initialized_announcer_namespace_validation']=receipt;checkpoint['next_action']=receipt['next_action']+' Preserve24 domains114 tasks37 requirements; whole game incomplete.'
write(r/'docs/initialized_announcer_namespace_validation.json',receipt);write(coverage_path,coverage);write(checkpoint_path,checkpoint)
shutil.copy2(pathlib.Path('E:/mapslol3v3/recover_announcement_definitions.py'),r/'tools/recover_announcement_definitions.py');shutil.copy2(pathlib.Path(__file__),r/'tools/record_initialized_announcer_namespace.py')
print(json.dumps({'native_cases':36,'audio_tests_passed':receipt['audio_regression_tests_passed'],'confirmed_events':receipt['unique_bank_confirmed_events']}))
