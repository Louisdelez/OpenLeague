from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def load(f):return json.loads((r/f).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
logname='logs/audio-actual-worker-exit-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 558 passed; 0 failed;'in log
for n in ['audio_windows_owned_com_exports_balance_actual_nested_ro_initialize_on_current_thread_and_reject_unowned_invalid_module_kind_and_codec_inputs','audio_windows_original_worker_exit_uses_actual_com_services_clears_fls_and_retires_fresh_heap_without_duplicate_os_callback']:
 assert n+' ... ok'in log,n
proofs=['docs/audio_actual_worker_exit_hardware_validation.json','docs/audio_crt_worker_exit_component_validation.json']
for f in proofs:
 p=load(f);assert p['passed']
 for name,h in p['files_sha256'].items():assert sha(r/name)==h,(f,name)
assert load(proofs[0])['cases']==12 and load(proofs[0])['actual_com_initialized_workers']==6
assert load(proofs[1])['cases']==248
refs=load('docs/audio_test_fixture_loading.json')['references'];assert len(refs)==59
for v in refs:assert sha(r/v['fixture'])==v['sha256'],v['fixture']
plan=load('docs/completion_plan.json');assert len(plan['domains'])==24 and sum(len(d['tasks'])for d in plan['domains'])==114 and sum(len(d['additional_requirements'])for d in plan['domains'])==37
name='audio_actual_worker_exit_validation';next_action='Qualify and integrate original CABDA8 package detection/C9C384 strict-zero RoInitialize flag producer and full C9C3DC/C9C315 worker entry/body; then complete actual legacy TLS root and explicit worker detachment. Preserve distinction between source strict-zero flag and all nonnegative HRESULT initialization obligations; qualify native S_FALSE/failed/foreign apartment cases and malformed/partial cleanup failures. Finish errno/new-handler/reentry, whole executable startup/GS/SEH and optional export ABIs. Connect locale/time/optional-buffer/dynamic-lock producers and normal client audio worker dispatch/progression/physical playback. Preserve full24 domains114 tasks37 requirements; game incomplete.'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':558,'actual_worker_exit_core_cases':12,'actual_worker_exit_hardware_cases':12,'actual_com_initialized_hardware_workers':6,'actual_exit_codes':[0,97,4294967295],'original_worker_exit_component_cases':248,'existing_fixture_hashes_preserved':59,'proofs':proofs,'test_log':logname,'next_action':next_action,
 'evidence':['Owned actual LoadLibraryExW combase.dll flags800, full-width registered/name/module-checked RoInitialize/RoUninitialize system ABI and pointer codec integrated. Every successful nonnegative HRESULT creates an obligation owned by that exact OS thread; excess/foreign/invalid release rejected. Modules stay live while obligations remain; post-drop report records DLL releases and unresolved ownership failures.',
 'Original worker exit preparation now runs with CurrentProvider on shared FLS/root context. It clears OS FLS payload before original CA915B/CA9026 destruction and owned mirror retirement. Core12 fresh worker cases use real Windows/heap/locks and optionally actual COM initialization/release; no duplicate callback on worker exit, main record still receives one cleanup callback. DLL/init/release counts checked after root/context drop.',
 'Standalone actual CreateThread executes original preparation and real ExitThread after all Rust-owned capsule/locals are dropped.12 x86/x64 workers use codes0/97/MAX, verified through WaitForSingleObject/GetExitCodeThread.6 workers own actual RoInitialize/RoUninitialize calls. Original nonopaque root banks normalized/compared, main and worker heap blocks retired, no restored records.',
 'Original124-case preparation comparison rerun in both architectures,248 component cases; full558 audio tests pass.59 historical fixtures and24/114/37 scope unchanged.'],
 'limits':['Original package detection/COM flag producer and full worker start body are still unintegrated; actual tests explicitly supply flag1 after actual successful RoInitialize. Strict-zero native flag handling and S_FALSE ownership must remain separately qualified.',
 'Real FLS root only; legacy TLS fallback, SEH, physical resource exhaustion and malformed/partial destructor/COM retirement failure paths remain unqualified.',
 'Native module unload timing is host adapter ownership cleanup; original code retains lazy loaded modules. Pending initialization causes visible failure/retention, never uninitialization on another thread. Normal client audible playback and whole game remain incomplete.'],
 'api_references':['https://learn.microsoft.com/windows/win32/api/roapi/nf-roapi-roinitialize','https://learn.microsoft.com/en-us/windows/win32/api/roapi/nf-roapi-rouninitialize']}
exe=load('docs/audio_crt_worker_exit_validation.json')['test_executable'];receipt['test_executable']=exe
tool=r/'tools/record_audio_actual_worker_exit.py';tool.write_text(Path(__file__).read_text(),encoding='utf-8')
files=[exe,logname,*proofs,'crates/core/src/lib.rs','tools/integrate_audio_worker_exit.py','tools/test_audio_actual_worker_exit.py','tools/report_audio_com_ownership.py','tools/record_audio_actual_worker_exit.py','docs/audio_crt_worker_com_initialization_discovery.json']
files+=[f'crates/core/src/{n}.rs'for n in ['audio_crt_worker_exit','audio_crt_windows_global_services','audio_crt_windows_shared_fls','audio_crt_windows_root_startup','audio_crt_windows_process_heap','audio_crt_windows_critical_sections']]
receipt['files_sha256']={f:sha(r/f)for f in files};(r/f'docs/{name}.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action','api_references']};summary['receipt']=f'docs/{name}.json'
for f in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 d=load('docs/'+f);d[name]=summary;d['next_action']=next_action
 if f=='resume_checkpoint.json':d['saved_utc']=receipt['saved_utc']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update({v:receipt[v]for v in ['audio_tests_passed','actual_worker_exit_core_cases','actual_worker_exit_hardware_cases','actual_com_initialized_hardware_workers']})
 (r/'docs'/f).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';s=html.read_text(encoding='utf-8');text='<p>Audio : sortie explicite du worker intÃ©grÃ©e au contexte Windows rÃ©el ; douze sorties natives ExitThread vÃ©rifiÃ©es en 32 et 64 bits, six avec initialisation/libÃ©ration COM rÃ©elle. Contexte et tas libÃ©rÃ©s sans double callback FLS ; bilan de DLL contrÃ´lÃ©. 558 tests audio rÃ©ussis. Producteur original du drapeau COM, worker complet, mode TLS historique et audio normal du client encore Ã  terminer.</p>\n';assert '</body>'in s
if text not in s:html.write_text(s.replace('</body>',text+'</body>'),encoding='utf-8')
print('PASS558 audio tests; real worker exits12/core12/COM6; physical ExitThread verified; full24/114/37 retained')
