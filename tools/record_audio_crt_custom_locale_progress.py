from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
logname='logs/audio-crt-custom-locale-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 518 passed; 0 failed;'in log
assert 'audio_crt_custom_locale_destruction_matches96_original_three_nested_helpers_conversion_defaults_ctype_rebasing_string_groups_time_null_frees_and_all_physical_lifetimes ... ok'in log
for stem,count in [('custom_locale_destruction',96),('custom_locale_lifecycle',16),('time_payload_destruction',4)]:
 f=load('data/4.20/audio_crt_'+stem+'_preparation.json');assert f['passed']and f['case_count']==f['terminal_case_count']==count
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
hardware=load('docs/audio_windows_fls_callback_hardware_discovery.json');assert hardware['passed']and len(hardware['cases'])==6
for v in hardware['cases']:assert v['setSucceeded']and v['freeSucceeded']and v['callbackCount']==int(v['value']!=0)and v['callbackValue']==v['value']and v['errorBefore']==v['errorAfterSet']==v['errorAfterFree']
priorpath='docs/audio_crt_thread_destruction_validation.json';prior=load(priorpath);name='audio_crt_custom_locale_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':518,
 'native_crt_custom_locale_destruction_cases_rust_validated':96,
 'native_crt_custom_locale_lifecycle_cases_prepared':16,'native_crt_custom_locale_lifecycle_cases_rust_validated':0,
 'native_crt_time_payload_destruction_cases_prepared':4,'native_crt_time_payload_destruction_cases_rust_validated':0,
 'actual_windows_fls_callback_cases':6,'actual_windows_fls_callback_host_architecture':hardware['host_architecture'],
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),'previous_receipt':priorpath,
 'evidence':[
 'Actual CA8A15 custom locale destructor implemented, including CC7E5A numeric13fields,CC82F7 monetary5fields and CC8564 time87fields in actual instruction order. Native instruction-derived field lists retained in reproducible implementation tool.96 original cases match every free entry/full canonical bank, final7regions and allNULL/distinct dynamic freed identities.',
 'Original conversion-pointer NULL/static predicates, comparisons to static default field values, refcount0/1 branches, ctype FE/80 interior pointer rebasing, 6 string groups and static/custom time guards preserved. Thread destructor invokes actual Rust custom locale destructor directly instead of unsupported service. Original caller predicate selecting custom destruction retained.',
 '16 complete original startup -> old default locale release -> controlled custom locale installation -> actual detach/custom destructor -> system cleanup lifetimes captured. Count1 destroys custom locale; count2 retains externally shared locale. NULL/static/copied-default/dynamic conversion, TLS/FLS and all67 canonical regions with4 intermediate stages recorded. Old reference released by actual CA8B6F. Rust integration comparison pending.',
 '4 original CC8564 helper cases captureNULL record, NULL/all/alternating distinct payload pointers. All87 original field identities/order observed, excludingAC/B0. Full89-slot payload storage retained including lastfield160. Rust explicit nonNULL payload comparison pending.',
 '6 actual current Windows FLS allocation/set/free cases invoke a rooted Winapi callback: nonNULL value0x1234 invokes exactly once with that argument; NULL value invokes no callback. LastError0/97/MAX preserved across successfulSet/Free in these cases. Every temporary slot freed; callback does not dereference opaque value or execute CRT destructor. Host architecture recorded separately.',
 'Full518-test audio suite passes;59 prior fixture reference hashes unchanged.'
 ],
 'limits':[
 '96 qualified custom locale cases haveNULL time payload fields. Native4cases with distinct time payloads and16 complete custom thread lifetimes prepared but Rust replay pending; integration wiring is not yet a complete custom lifecycle proof.',
 'Custom locale structures supplied explicitly; original locale creation/update producers, actual heap/OS/security-cookie providers, OS-triggered FLS callback executing actual CRT destructor, interlocked concurrency and SEH remain unfinished.6 actual host callback measurements do not prove original32bit CRT or fiber/thread teardown.',
 'Normal audio worker startup/dispatch/progression/retirement and physical playback remain open. Full24-domain114-task37-requirement game not complete; no tasks or domains closed.'
 ],
 'next_action':'Replay16 original complete custom-locale thread lifetimes and4 original CC8564 distinct-payload helper cases; integrate nonNULL time payloads into custom locale lifecycle. Qualify normal locale producers, OS-triggered FLS callback and actual OS/heap/security-cookie providers; connect normal audio worker startup/dispatch/progression/retirement and physical playback. Continue full24-domain114-task37-requirement scope.'}
files=[logname,priorpath,'crates/core/src/lib.rs','crates/core/src/audio_crt_custom_locale_destructor.rs','crates/core/src/audio_crt_thread_destructor.rs','tools/implement_audio_crt_custom_locale_destructor.py','tools/record_audio_crt_custom_locale_progress.py','docs/audio_windows_fls_callback_hardware_discovery.json','tools/probe_windows_fls_callbacks.ps1']
for stem in ['custom_locale_destruction','custom_locale_lifecycle','time_payload_destruction']:files.extend(['data/4.20/audio_crt_'+stem+'_preparation.json','tools/probe_native_audio_crt_'+stem+'.py'])
receipt['files_sha256']={f:sha(r/f)for f in files};(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('native_crt_')or k.startswith('actual_windows_fls_callback_')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : destructeur des locales personnalisées implémenté et relié au contexte ; 96 comparaisons concordent avec le client original. Suite audio : 518 tests réussis. Cycles complets personnalisés et données temporelles à pointeurs distincts capturés ; comparaisons intégrées et fournisseurs système à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS518 audio tests;96 custom locale cases matched;16 complete custom lifetimes+4 time payload cases prepared;24/114/37 retained')
