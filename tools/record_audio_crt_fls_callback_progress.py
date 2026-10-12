from pathlib import Path
import json,hashlib,datetime,subprocess
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def readlog(p):
 b=(r/p).read_bytes();return b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
logname='logs/audio-crt-fls-callback-qualified-tests.log';log=readlog(logname);assert 'test result: ok. 522 passed; 0 failed;'in log
assert 'audio_crt_fls_slot_lifetime_matches36_original_full_tls_fls_live_cleared_detached_slot_cleanup_actual_destructor_callbacks_banks_and_allocation_lifetimes ... ok'in log
assert 'error[E0061]'in readlog('logs/audio-crt-fls-callback-tests.log')
f=load('data/4.20/audio_crt_fls_slot_lifetime_preparation.json');assert f['passed']and f['case_count']==f['terminal_case_count']==36
for suffix,width in [('',64),('_x86',32)]:
 h=load('docs/audio_windows_fls_rust_destructor'+suffix+'_hardware_discovery.json');assert h['passed']and h['host_pointer_width']==width and h['actual_windows_fls_rust_destructor_cases']==12
 for path,digest in h['files_sha256'].items():assert sha(r/path)==digest
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
installed=subprocess.run(['C:/Users/loicd/.cargo/bin/rustup.exe','target','list','--installed'],capture_output=True,text=True);assert installed.returncode==0 and 'i686-pc-windows-msvc'in installed.stdout
compiler=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','-vV'],capture_output=True,text=True);assert compiler.returncode==0
priorpath='docs/audio_crt_time_lifetime_validation.json';prior=load(priorpath);name='audio_crt_fls_callback_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':522,
 'native_crt_fls_slot_lifetime_cases_rust_validated':36,'actual_windows_fls_rust_destructor_cases':24,'actual_windows_fls_rust_destructor_x86_cases':12,'actual_windows_fls_rust_destructor_x64_cases':12,
 'rust_installed_targets':installed.stdout.splitlines(),'rust_compiler':compiler.stdout,
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),'previous_receipt':priorpath,
 'evidence':[
 'RegisteredCA9026 FLS dispatch implemented and calls actual Rust thread destructor.36 original complete live/cleared/detached TLS/FLS cleanup lifetimes match all33 canonical regions, every import/free entry, callback identity/entry/exit banks and exact physical ownership. FLS-free clears slot before invoking registered destructor; TLS has no callback. Original native callback stack delta8 asserted separately, without pretending logical Rust dispatch proves native ABI.',
 'First full build failedE0061 because callback provider argument omitted in comparison service. Provider corrected, failed log retained; final522-test suite passes. No expected native outcomes or bank comparisons relaxed.',
 'Actual WindowsFlsAlloc/FlsSetValue/FlsFree now invoke externsystem Rust callback in isolated probes compiling unchanged production callback/thread destructor/custom locale modules and original foundation functions.24cases total:12actualX64 +12actualX86, each6live contexts and6empty slots. Every native destructor lock/free service-entry bank, order, final canonical storage and freed identities match. Callback observes cleared slot; panic containment present; callback payloadBox physically allocated/dropped byRust; observer retains passive canonical memory for comparison.',
 'Official Rust i686-pc-windows-msvc standard library installed through rustup. Actual32bit executable prints pointer_width32 and runs successfully against same native data. Isolated probe initial unused-import compilation failure retained in probe-initial-build.log; unnecessary import removed only from extracted probe foundation prefix, original function code unchanged.',
 'LiveTLS cleanup and merely clearedFLS data retain original record; liveFLS callback or explicitdetach frees it. Distinct native lifetimes preserved, not claimed all leak-free.59 earlier fixture references unchanged; full24/114/37 retained.'
 ],
 'limits':[
 'OS callback probes use Memory/Error type facades, canonical native contexts and explicit lock/CRT heap service boundaries. They are actual OS-to-production-algorithm proofs, not full core crate/normal client provider, actual original heap or normal worker startup proofs.',
 'Callback adapter maps actual boxedOS payload to32bit canonical record identity. Normal thread/fiber termination/reentrancy/concurrency/SEH and actual heap/lock/security-cookie providers remain unqualified.',
 'Normal locale producers, audio worker startup/dispatch/progression/retirement/physical playback and fullgame remain incomplete. No task/domain closed.'
 ],
 'next_action':'Promote actual OS FLS callback bridge from isolated probe into normal core/client provider with real slot ownership and error propagation. Qualify real Windows lock/heap services and security-cookie/bootstrap, thread/fiber teardown/concurrency/SEH, then connect normal audio worker startup/dispatch/progression/retirement and physical playback. Normal locale producers remain required. Continue full24-domain114-task37-requirement scope.'}
files=[logname,'logs/audio-crt-fls-callback-tests.log',priorpath,'crates/core/src/lib.rs','crates/core/src/audio_crt_fls_callback.rs','crates/core/src/audio_crt_thread_system_startup.rs','tools/integrate_audio_crt_fls_callback.py','tools/fix_audio_crt_callback_provider.py','tools/record_audio_crt_fls_callback_progress.py','data/4.20/audio_crt_fls_slot_lifetime_preparation.json','tools/probe_native_audio_crt_fls_slot_lifetime.py','tools/probe_os_fls_rust_destructor.py','tools/probe_os_fls_rust_destructor_x86.py','tools/hardware/fls_rust_destructor/probe-initial-build.log']
for suffix in ['', '_x86']:files.append('docs/audio_windows_fls_rust_destructor'+suffix+'_hardware_discovery.json')
receipt['files_sha256']={f:sha(r/f)for f in files};(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action','rust_compiler']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('native_crt_')or k.startswith('actual_windows_fls_rust_destructor')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : callback FLS relié au destructeur Rust ; 36 cycles natifs concordants, 522 tests réussis. Windows a déclenché le code du destructeur sur 24 cas dans de vrais exécutables Rust 32 et 64 bits. Fournisseurs complets de verrous/tas et intégration au fonctionnement audio normal à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS522 audio tests;36 callback lifetimes matched;24 actualWindows -> Rust destructor cases X86/X64;24/114/37 retained')
