from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def readlog(p):
 b=(r/p).read_bytes();return b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
logname='logs/audio-crt-thread-system-startup-tests.log';log=readlog(logname)
assert 'test result: ok. 513 passed; 0 failed;'in log
for test in [
 'audio_crt_global_dispatch_initialization_matches72_original_encoded_null_static_terminate_pointer_default_handlers_real33_export_resolver_and_all_entry_banks',
 'audio_crt_tls_slot_wrappers_matches72_original_tls_fls_cookie_dispatch_callback_drop_or_forward_raw_returns_and_canonical_banks',
 'audio_crt_tls_value_wrappers_matches144_original_encoded_tls_fls_get_set_unsigned_index_raw_pointer_bool_return_and_all_canonical_banks',
 'audio_crt_thread_system_startup_matches48_original_global_handlers_exports_static_locks_tls_fls_allocation_real_constructor_failure_cleanup_and_all_native_banks']:
 assert test+' ... ok'in log
assert 'test result: ok. 511 passed; 0 failed;'in readlog('logs/audio-crt-global-dispatch-tls-slots-tests.log')
for stem,count in [('global_dispatch_initialization',72),('tls_slot_wrappers',72),('tls_value_wrappers',144),('thread_system_startup',48),('thread_system_cleanup',72),('startup_getter',36)]:
 f=load('data/4.20/audio_crt_'+stem+'_preparation.json');assert f['passed']and f['case_count']==f['terminal_case_count']==count
host=load('docs/audio_windows_fls_error_hardware_discovery.json');assert host['passed']and len(host['cases'])==6
for v in host['cases']:assert v['setSucceeded']and v['errorBefore']==v['errorAfterSet']and v['errorAfterGet']==0 and v['value']==v['result']
contract=load('docs/audio_test_fixture_loading.json')
for v in contract['references']:assert sha(r/v['fixture'])==v['sha256']
prior=load('docs/audio_crt_windows_dispatch_resolver_validation.json');name='audio_crt_thread_system_startup_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':513,
 'native_crt_global_dispatch_initialization_cases_rust_validated':72,'native_crt_tls_slot_wrapper_cases_rust_validated':72,
 'native_crt_tls_value_wrapper_cases_rust_validated':144,'native_crt_thread_system_startup_cases_rust_validated':48,
 'native_crt_thread_system_cleanup_cases_prepared':72,'native_crt_thread_system_cleanup_cases_rust_validated':0,
 'native_crt_startup_getter_cases_prepared':36,'native_crt_startup_getter_cases_rust_validated':0,
 'actual_windows_fls_error_cases':6,'actual_windows_fls_host_architecture':host['host_architecture'],
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),
 'previous_receipt':'docs/audio_crt_windows_dispatch_resolver_validation.json',
 'evidence':[
 'Original C9A0B9 initialization now composed with actual CABDE8 resolver.72 original cases match encoded NULL/default handlers, encoded fixed terminate callback,33 export lookups and all service-entry/final canonical banks. CABC85/CABCA3 slot allocation/free replay72 cases; fallback drops callback, FLS forwards it, return words retained unchanged. Intermediate511-test suite passes.',
 'Actual CABCC2/CABCE1 get/set wrappers implemented;144 native cases match cookie decoding, fallback/extended dispatch, unsigned index, NULL/nonNULL pointers and raw returns0/5/MAX without Boolean normalization. Every entry and final canonical bank matched.',
 'Complete CA92CB startup implemented and composed from global handlers/resolver, static lock initialization, slot allocation,calloc,TLS/FLS publication and original CA9218 locale/refcount constructor.48 native startup/slot failure/calloc failure/publication failure cases match every original call, all32 canonical read/write regions, allocation/free lifetime, TLS data,LastError and returned status. No prefilled lock or TLS index. Actual CA9341/CB027B failure cleanup runs in both native and Rust comparisons.',
 'Original CA92CB publication failure does not free the allocated thread buffer; unlike CA91A9 getter failure. Rust preserves observed distinct ownership. Static lock cleanup deletes critical sections but retains pointers/storage. General dynamic two-pass cleanup implemented; additional72 native standalone cases prepared for Rust qualification.',
 'Actual current Windows FLS slot measured in6 cases: successfulFlsSetValue preserves priorLastError0/97/MAX;FlsGetValue returns stored NULL/0x1234 and resetsLastError0. Slot freed in finally. No destructor installed. Full513-test suite passes;59 retained fixture references verified unchanged.'
 ],
 'limits':[
 'Encoded pointer service is explicitly supplied XOR key, not a claimed reconstruction of actual Windows EncodePointer algorithm. Resolver exports, heap allocation and critical-section5A/DD bytes supplied at API boundaries; actual delivered OS/heap/security-cookie providers remain unfinished.',
 'Host FLS measurement X64 does not prove original32bit bootstrap, concurrency,SEH or destructor callbacks. Cleanup with live FLS value excluded until actual CA9026 destructor is qualified. Standalone dynamic cleanup branches are prepared but Rust replay still pending.',
 '36 whole original startup-then-getter TLS/FLS compositions captured with all55 canonical regions and LastError0/97/MAX, Rust replay pending. Full startup composition is a faithful core reconstruction under explicit service boundaries, not proof of normal client audio startup, normal-frame dispatch/retirement or physical playback. Full24-domain game remains incomplete.'
 ],
 'next_action':'Replay72 original CA9341/CB027B standalone cleanup cases including dynamic/non-one flags and both pass orders; integrate encoded Get/Set provider into actual context getter and replay36 full original startup-to-getter compositions with actual TLS/FLS dispatch and LastError preservation. Qualify original CA9026 live FLS destructor, actual OS/heap/security-cookie bootstrap and connect normal audio worker dispatch/progression/retirement and physical playback. Continue full24-domain114-task37-requirement scope.'}
files=[logname,'logs/audio-crt-global-dispatch-tls-slots-tests.log','docs/audio_crt_windows_dispatch_resolver_validation.json','docs/audio_windows_fls_error_hardware_discovery.json','tools/probe_windows_fls_error.ps1','crates/core/src/lib.rs','crates/core/src/audio_crt_thread_context.rs','tools/implement_audio_crt_global_dispatch_tls_slots.py','tools/implement_audio_crt_tls_value_wrappers.py','tools/implement_audio_crt_thread_system_startup.py','tools/record_audio_crt_thread_system_startup_progress.py']
for stem in ['global_dispatch_initialization','tls_slot_wrappers','tls_value_wrappers','thread_system_startup']:
 files.extend(['crates/core/src/audio_crt_'+stem+'.rs','data/4.20/audio_crt_'+stem+'_preparation.json','tools/probe_native_audio_crt_'+stem+'.py'])
files.extend(['data/4.20/audio_crt_thread_system_cleanup_preparation.json','tools/probe_native_audio_crt_thread_system_cleanup.py'])
files.extend(['data/4.20/audio_crt_startup_getter_preparation.json','tools/probe_native_audio_crt_startup_getter.py'])
receipt['files_sha256']={f:sha(r/f)for f in files}
(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('native_crt_')or k.startswith('actual_windows_fls_')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : démarrage complet du contexte original implémenté, avec gestionnaires, résolution Windows, verrous, allocation TLS/FLS et constructeur. Comparaison de 48 démarrages/échecs et 144 accès au contexte concordante ; 513 tests audio réussis. Nettoyage dynamique, destructeur FLS, fournisseurs système et intégration audio réelle restent à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS513 audio tests;72 init+72 slot+144 value+48 complete startup cases matched;72 cleanup prepared;full24/114/37 preserved')
