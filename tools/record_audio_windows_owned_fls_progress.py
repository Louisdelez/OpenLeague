from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
logname='logs/audio-windows-owned-fls-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 525 passed; 0 failed;'in log
for name in ['audio_windows_owned_fls_matches12_actual_os_callbacks_production_context_native_service_entry_banks_order_free_identities_and_empty_slots','audio_windows_owned_fls_drop_releases_context_once_and_busy_state_reports_failure_without_deadlock','audio_windows_owned_fls_backend_errors_and_panics_remain_reported_without_unwinding_native_callback']:assert name+' ... ok'in log
component=load('docs/audio_windows_owned_fls_component_hardware_discovery.json');assert component['passed']and component['actual_windows_owned_fls_component_cases']==24 and {v['pointer_width']for v in component['runs']}=={32,64}
shared=load('docs/audio_windows_shared_fls_hardware_discovery.json');assert shared['passed']and shared['actual_callbacks']==8 and {v['pointer_width']for v in shared['runs']}=={32,64}
for receipt in [component,shared]:
 for path,digest in receipt['files_sha256'].items():assert sha(r/path)==digest
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
priorpath='docs/audio_crt_fls_callback_validation.json';prior=load(priorpath);name='audio_windows_owned_fls_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':525,
 'actual_windows_owned_fls_core_cases':12,'actual_windows_owned_fls_component_cases':24,'actual_windows_owned_fls_failure_checks':2,'actual_windows_owned_fls_ownership_checks':1,
 'actual_windows_shared_fls_callbacks':8,'actual_windows_shared_fls_architectures':[32,64],
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),'previous_receipt':priorpath,
 'evidence':[
 'Production core Windows OwnedSlot component now allocates/binds/gets/frees actualFLS slot and dispatches registered Rust CRT destructor. Slot is thread-affine and its OS callback owns transferredBox. Explicit close is idempotent, Drop frees slot, callback attempts/completions/failures remain observable, and native ABI contains panics. Preinitialized canonical context is shared throughArcMutex; callback try_lock reports busy/poison without deadlocking.',
 'Full core Windows tests exercise12 original live/cleared native contexts through actualOS callbacks, comparing every original destructor lock/free service-entry bank, final canonical storage and exact freed identities. Separate core tests qualify Drop single-release, held-context busy failure, backend failure and panic containment with slot closure/no false completion. No source-native SEH equivalence claimed.',
 'Unchanged production OwnedSlot module also compiled in actualX86/X64 isolated executables and verifies12 cases each:24actual component cases. Same original native banks/order/final bytes/free identities matched. Isolated type/service facades retained only in standalone probes; full core checks use actual crate types.',
 'Actual shared global FLS index measured inX86/X64 processes with2 worker threads percase. Natural thread exit invokes each callback on that worker. Freeing one global slot while both workers live invokes both callbacks synchronously on freeing caller, and later worker exit does not duplicate callbacks.8total actualcallbacks. This changes normal-provider integration requirement: share the original single CRT slot across workers and synchronize contexts for callbacks potentially running on a different thread.',
 'Full525-test audio suite passes;59 earlier runtime fixture hashes unchanged;24domains114tasks37requirements preserved.'
 ],
 'limits':[
 'OwnedSlot is a core ownership component, not yet the original shared global CRT-slot provider or connected normal client audio worker. Canonical contexts preinitialized from native captures; actual normal startup/heap/lock/security-cookie providers remain unfinished.',
 'Shared-slot thread-affinity measurements only record opaque values/identity; source destructor with shared worker contexts and teardown must be integrated/qualified next. Arbitrary fiber rebinding, normal locale producers and full concurrency/SEH still open.',
 'Core OS callbacks still use explicit lock/CRT heap boundary services in these tests. Normal audio dispatch/progression/retirement/physical playback and fullgame not complete; no domains/tasks closed.'
 ],
 'next_action':'Implement the original shared global CRT FLS slot provider across workers using measured callback affinity, preserving one global index and per-thread record ownership. Qualify worker teardown and owner-close callbacks executing actual Rust destructor with synchronization/error propagation. Complete real lock/heap/security-cookie/startup services and connect normal audio worker dispatch/progression/retirement/physical playback. Normal locale producers and concurrency/SEH remain required. Continue full24-domain114-task37-requirement scope.'}
files=[logname,priorpath,'crates/core/src/lib.rs','crates/core/src/audio_crt_windows_fls_slot.rs','crates/core/src/audio_crt_thread_system_startup.rs','tools/implement_audio_windows_owned_fls.py','tools/probe_windows_owned_fls_component.py','tools/probe_windows_shared_fls.py','docs/audio_windows_owned_fls_component_hardware_discovery.json','docs/audio_windows_shared_fls_hardware_discovery.json','tools/record_audio_windows_owned_fls_progress.py']
receipt['files_sha256']={f:sha(r/f)for f in files};(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('actual_windows_')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : composant FLS Windows de production intégré au moteur, possession/libération et erreurs vérifiées ; 525 tests réussis. Composant exécuté en 32 et 64 bits ; affinité des callbacks d’un slot partagé entre workers mesurée. Fournisseur global et intégration audio normale à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS525 audio tests;production FLS core ownership/error checks;24actualX86/X64 component cases;8 shared callbacks;24/114/37 retained')
