from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def load(f):return json.loads((r/f).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
logname='logs/audio-worker-com-startup-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 561 passed; 0 failed;'in log
names=['audio_crt_worker_com_startup_matches566_original_signed_package_cache_exact122_detection_ro_initialize_cache_strict_zero_hresult_and_worker_flag_entry_banks','audio_windows_worker_com_stage_integrates_actual_package_query_or_cached_positive_gate_real_initializer_and_complete_worker_exit_in12_fresh_contexts','audio_windows_package_query_checks_typed_export_provenance_and_real_com_initializer_preserves_source_s_false_flag_separate_from_two_owned_obligations']
for n in names:assert n+' ... ok'in log,n
proofs=['docs/audio_worker_com_component_validation.json','docs/audio_actual_com_startup_hardware_validation.json']
for f in proofs:
 p=load(f);assert p['passed']
 for name,h in p['files_sha256'].items():assert sha(r/name)==h,(f,name)
assert load(proofs[0])['cases']==1132 and load(proofs[0])['native_cases']==566
assert load(proofs[1])['cases']==12 and load(proofs[1])['cold_actual_package_queries']==6
refs=load('docs/audio_test_fixture_loading.json')['references'];assert len(refs)==59
for v in refs:assert sha(r/v['fixture'])==v['sha256'],v['fixture']
plan=load('docs/completion_plan.json');assert len(plan['domains'])==24 and sum(len(d['tasks'])for d in plan['domains'])==114 and sum(len(d['additional_requirements'])for d in plan['domains'])==37
name='audio_worker_com_startup_validation';next_action='Qualify original C9C3DC worker entry/context transfer and C9C315 body/callback/SEH/return-exit dispatch; integrate normal worker entry using qualified package/COM flag producer and explicit retirement. Complete actual legacy TLS root fallback, original errno/new-handler/reentry services and full executable startup/GS/SEH. Qualify original S_FALSE source flag0 versus actual nonnegative initialization ownership at OS thread termination; no silent success reinterpretation or foreign apartment cleanup. Connect locale/time/optional-buffer/dynamic-lock producers and normal client audio dispatch/progression/physical playback. Preserve24 domains114 tasks37 requirements; whole game incomplete.'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':561,'original_worker_com_startup_cases':566,'worker_com_component_x86_x64_cases':1132,'actual_worker_com_core_cases':12,'actual_worker_com_hardware_cases':12,'cold_actual_package_hardware_queries':6,'supplied_positive_package_cache_hardware_inputs':6,'existing_fixture_hashes_preserved':59,'proofs':proofs,'test_log':logname,'next_action':next_action,
 'evidence':['Full original CABDA8 package helper and C9C384 RoInitialize helper, plus C9C439 worker COM stage through body-call boundary captured on566 configurations. Signed package cache values, missing export, exact API result122, output length, three cookies, initialization cache, module/export absence and raw HRESULT0/1/2/negative/MAX retained with every entry/final bank.',
 'Rust producers reproduce signed positive package result, cache publication, lazy combase.dll flags800 and RoInitialize encoded cache, argument1 and exact-zero flag gate. S_FALSE yields source flag0; actual runtime ownership still tracks its successful initialization independently.',
 'Named/provenance-checked full-width GetCurrentPackageId ABI and owned RoInitialize services integrated. Shared FLS/root worker constructor and COM stage run under one state/index guard; stage returns owned current record and source flag without manually setting it.12 core fresh worker stages and twelve actual x86/x64 CreateThread/ExitThread pipelines pass, with six cold actual package queries and six explicitly supplied positive cache inputs.',
 'Actual query provenance and repeated original initializer checked on fresh OS thread: first initialization flag1, second S_FALSE flag0 while two owned obligations remain. Test explicitly balances both as separate test cleanup, preserving original source behavior. Component566 cases repeated in both architectures,1132 comparisons.561 audio tests pass;59 historical fixtures and24/114/37 scope preserved.'],
 'limits':['Positive package cache1 is a supplied original input, not a claim this process has actual packaged application identity. Cold cases query actual host identity.',
 'Full original worker entry/body/SEH and legacy TLS fallback are unintegrated. Generic framework worker constructor integration is not proof original context-transfer/thread callback contract is complete.',
 'Second initialization S_FALSE case balances obligations explicitly in the test; original source flag0 omits its release. Whole normal worker terminal lifecycle for this branch remains to qualify rather than silently change the native flag.',
 'Normal client audio worker dispatch and audible output, errno/new-handler/reentry and whole executable startup remain incomplete.']}
exe=load('docs/audio_actual_worker_exit_validation.json')['test_executable'];receipt['test_executable']=exe
tool=r/'tools/record_audio_worker_com_startup.py';tool.write_text(Path(__file__).read_text(),encoding='utf-8')
files=[exe,logname,*proofs,'crates/core/src/lib.rs','data/4.20/audio_crt_worker_com_startup_preparation.json','tools/probe_native_audio_crt_worker_com_startup.py','tools/implement_audio_crt_worker_com_startup.py','tools/integrate_audio_crt_worker_com_startup.py','tools/test_audio_crt_worker_com_startup.py','tools/record_audio_worker_com_startup.py']
files+=[f'crates/core/src/{n}.rs'for n in ['audio_crt_worker_com_startup','audio_crt_worker_exit','audio_crt_windows_global_services','audio_crt_windows_shared_fls','audio_crt_windows_root_startup','audio_crt_windows_process_heap','audio_crt_windows_critical_sections']]
receipt['files_sha256']={f:sha(r/f)for f in files};(r/f'docs/{name}.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']=f'docs/{name}.json'
for f in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 d=load('docs/'+f);d[name]=summary;d['next_action']=next_action
 if f=='resume_checkpoint.json':d['saved_utc']=receipt['saved_utc']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update({v:receipt[v]for v in ['audio_tests_passed','original_worker_com_startup_cases','worker_com_component_x86_x64_cases','actual_worker_com_core_cases','actual_worker_com_hardware_cases']})
 (r/'docs'/f).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';s=html.read_text(encoding='utf-8');text='<p>Audio : producteurs originaux de dÃ©tection Windows et du drapeau COM intÃ©grÃ©s ; 566 captures natives et 1132 comparaisons 32/64 bits. Douze workers rÃ©els exÃ©cutent cette dÃ©cision puis leur sortie explicite. 561 tests audio rÃ©ussis. Drapeau natif S_FALSE distinct du bilan COM ; worker complet, TLS historique et audio normal du client restent Ã  terminer.</p>\n';assert '</body>'in s
if text not in s:html.write_text(s.replace('</body>',text+'</body>'),encoding='utf-8')
print('PASS561 audio tests; native package/COM566/component1132/actual workers12; full24/114/37 retained')
