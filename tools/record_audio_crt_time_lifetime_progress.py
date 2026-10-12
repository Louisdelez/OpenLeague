from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
logname='logs/audio-crt-time-lifetime-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 521 passed; 0 failed;'in log
assert 'audio_crt_time_locale_lifecycle_matches8_original_full_custom_thread_lifetimes_actual87_distinct_temporal_payload_destruction_or_shared_retention ... ok'in log
for stem,count in [('time_locale_lifecycle',8),('fls_slot_lifetime',36)]:
 f=load('data/4.20/audio_crt_'+stem+'_preparation.json');assert f['passed']and f['case_count']==f['terminal_case_count']==count
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
for suffix,architecture in [('', 'X64'),('_x86','X86')]:
 h=load('docs/audio_windows_fls_callback_state'+suffix+'_hardware_discovery.json');assert h['passed']and h['host_architecture']==architecture and len(h['cases'])==6
 for v in h['cases']:assert v['setSucceeded']and v['freeSucceeded']and v['callbackCount']==int(v['value']!=0)and v['callbackValue']==v['value']and v['callbackSlotValue']==v['callbackSlotError']==0 and v['errorBefore']==v['errorAfterSet']==v['errorAfterFree']
priorpath='docs/audio_crt_locale_lifecycle_validation.json';prior=load(priorpath);name='audio_crt_time_lifetime_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':521,
 'native_crt_time_locale_lifecycle_cases_rust_validated':8,'native_crt_fls_slot_lifetime_cases_prepared':36,'native_crt_fls_slot_lifetime_cases_rust_validated':0,
 'actual_windows_fls_callback_state_cases':12,'actual_windows_fls_callback_state_x86_cases':6,'actual_windows_fls_callback_state_x64_cases':6,
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),'previous_receipt':priorpath,
 'evidence':[
 '8 original complete custom thread lifetimes with all/alternating distinct time payloads now match all68 canonical regions, every original allocator/Windows entry bank, four intermediate banks and exact allocations/free identities. Actual87-field destructor composition proven for count1 final release and count2 external-owner shared retention, TLS/FLS. Same comparison retained for prior16 custom lifetimes; no expected-value relaxation.',
 'Actual current Windows FLSFree callback state measured in12cases:6actualX64 plus6actualX86 process cases.32bit probe asserts IntPtr.Size==4 before running native APIs. NonNULL0x1234 invokes callback once with original argument; NULL invokes none. Callback sees its slot empty with LastError0 fromFlsGetValue, restores its entry error and successfulFlsFree retains caller error0/97/MAX. Slots always freed and callback rooted. No original/Rust destructor executed by these host callbacks.',
 '36 full original CA92CB startup/CA9341 cleanup slot lifetimes captured with live/cleared/detached slot states, encodedTLS/FLS dispatch, cookies0/11223344/MAX and zero/A5 initial storage. FLS API boundary dispatches actualCA9026 original code through correctstdcall callback frame; actual callback ret4 results delta8, complete callback entry/exit banks retained before original caller resumes. TLS fallback invokes no destructor callback. Every33 canonical region and actual physical free identity recorded.',
 'Native live FLS cleanup frees context; explicit detach frees context before slot cleanup; merely clearing slot or live TLS cleanup retains record and native references. These distinct native lifetimes preserved without claiming those paths leak-free. Rust callback-lifetime replay pending.',
 'Full521-test audio suite passes;59 earlier fixture reference hashes unchanged.'
 ],
 'limits':[
 'OS native callbacks measured on current32/64bit Windows with opaque values; native original destructor executed only through explicit emulated API callback adapter. Actual OS callback invoking Rust/original context destruction and actual heap/security-cookie/provider integration not yet proved.',
 '36 native slot lifetimes prepared but Rust replay pending. Normal locale/time producers, actual concurrency/SEH and normal client audio worker startup/dispatch/progression/retirement/physical playback remain open.',
 'Full24domains114tasks37requirements preserved without closing tasks or domains; game not complete.'
 ],
 'next_action':'Implement/replay36 original full TLS/FLS slot cleanup lifetimes with actual destructor callback, matching callback-entry/exit banks and live/cleared/detached physical ownership. Bind actual OS callbacks to Rust context destruction using measuredX86/X64 slot-clearing behavior; complete heap/OS/security-cookie providers and normal audio worker startup/dispatch/progression/retirement and physical playback. Normal locale producers and concurrency/SEH remain required. Continue full24-domain114-task37-requirement scope.'}
files=[logname,priorpath,'crates/core/src/audio_crt_thread_system_startup.rs','tools/qualify_audio_crt_time_lifetime.py','tools/record_audio_crt_time_lifetime_progress.py']
for stem in ['time_locale_lifecycle','fls_slot_lifetime']:files.extend(['data/4.20/audio_crt_'+stem+'_preparation.json','tools/probe_native_audio_crt_'+stem+'.py'])
for suffix in ['', '_x86']:files.extend(['docs/audio_windows_fls_callback_state'+suffix+'_hardware_discovery.json','tools/probe_windows_fls_callback_state'+suffix+'.ps1'])
receipt['files_sha256']={f:sha(r/f)for f in files};(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('native_crt_')or k.startswith('actual_windows_fls_callback_state')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : cycle complet avec données temporelles non nulles concordant, 521 tests réussis. État des callbacks FLS mesuré dans de vrais processus Windows 32 et 64 bits ; 36 cycles natifs avec callback exécutant le destructeur original capturés. Liaison au fournisseur système et fonctionnement audio réel à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS521 audio tests;8 complete nonNULL time lifetimes matched;36 original callback lifetimes prepared;12 actualX86/X64 measurements;24/114/37 retained')
