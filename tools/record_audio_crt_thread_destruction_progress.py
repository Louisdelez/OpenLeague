from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
logname='logs/audio-crt-thread-destruction-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 517 passed; 0 failed;'in log
for test in ['audio_crt_thread_lifecycle_matches72_original_startup_detach_actual_destructor_locale_release_system_cleanup_all_intermediate_banks_and_physical_lifetimes','audio_crt_optional_thread_buffers_matches126_original_ordered_strings_null_exception_wrapped_multibyte_reference_static_retention_and_all_native_ownership_cases']:assert test+' ... ok'in log
for stem,count in [('thread_lifecycle',72),('optional_thread_buffers',126),('custom_locale_destruction',96)]:
 f=load('data/4.20/audio_crt_'+stem+'_preparation.json');assert f['passed']and f['case_count']==f['terminal_case_count']==count
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
priorpath='docs/audio_crt_encoded_context_cleanup_validation.json';prior=load(priorpath);name='audio_crt_thread_destruction_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':517,
 'native_crt_thread_lifecycle_cases_rust_validated':72,'native_crt_optional_thread_buffer_cases_rust_validated':126,
 'native_crt_custom_locale_destruction_cases_prepared':96,'native_crt_custom_locale_destruction_cases_rust_validated':0,
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),'previous_receipt':priorpath,
 'evidence':[
 'Actual CA915B detachment, CA9026 destruction and CA8B6F locale reference release implemented.72 original full CA92CB startup -> detach/destructor -> CA9341 cleanup lifetimes match every allocator/import entry bank, both intermediate stages and all33 final canonical regions. Getter-based detach resetsLastError through actual TLS/FLSGet; explicit record bypasses lookup. Slot clears before destruction, record freed exactly once and system cleanup subsequently releases empty slot/static locks.',
 '126 original optional-buffer cases match exact7-string order, exception default literal retention and native free(NULL) branch, NULL/static/custom multibyte refcount0/1/2/MAX wrapping and static buffer retention. Complete52-region banks and every imported/free entry matched. Distinct32byte optional payload allocations used; NULL frees observed but not marked dead; exact original nonNULL freed identities tracked.',
 '96 actual CA8A15 custom locale destruction cases captured with original CC7E5A/CC82F7/CC8564 helpers executing. Conversion NULL/static/copied-default/dynamic pointers, zero/live references, ctype original FE/80 rebasing, string group predicates and static/custom time retained. Distinct dynamic allocation identities. Only allocator free boundary supplied. Rust custom-locale replay pending.',
 'Full517-test audio suite passes;59 earlier fixture hashes retained unchanged.'
 ],
 'limits':[
 'Custom locale destruction is an explicit service currently unsupported unless provided; standalone original96 cases prepared for faithful implementation. Normal optional-buffer/custom-locale producers and actual OS-triggered FLS callback remain open.',
 'Logical reference updates preserve native wrapping/alias order but actual interlocked concurrency and SEH failure cleanup not qualified. Imported heap/OS/critical storage outcomes still explicit controlled boundaries; actual providers/security-cookie bootstrap not finished.',
 'These complete core context lifetimes are not proof of normal client audio startup/dispatch, physical playback or a complete game. All24 domains/114tasks/37requirements retained without closing domains or tasks.'
 ],
 'next_action':'Implement/replay96 actual CA8A15 custom locale destructor cases with original conversion/time helper order and interior-pointer rebasing; extend custom time payloads and compose custom locale destruction into whole thread lifecycle. Qualify OS-triggered FLS callback, actual OS/heap/security-cookie providers, then connect normal audio worker startup/dispatch/progression/retirement and physical playback. Continue full24-domain114-task37-requirement scope.'}
files=[logname,priorpath,'crates/core/src/lib.rs','crates/core/src/audio_crt_thread_context.rs','crates/core/src/audio_crt_thread_destructor.rs','crates/core/src/audio_crt_thread_system_startup.rs','tools/implement_audio_crt_thread_destruction.py','tools/record_audio_crt_thread_destruction_progress.py']
for stem in ['thread_lifecycle','optional_thread_buffers','custom_locale_destruction']:files.extend(['data/4.20/audio_crt_'+stem+'_preparation.json','tools/probe_native_audio_crt_'+stem+'.py'])
receipt['files_sha256']={f:sha(r/f)for f in files};(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('native_crt_')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : détachement et destructeur du contexte implémentés ; 72 cycles complets et 126 cas de buffers optionnels concordent avec le client original. Suite audio : 517 tests réussis. Destructeur des locales personnalisées capturé sur 96 cas ; portage et intégration système à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS517 audio tests;72 full thread lifetimes+126 optional buffer cases matched;96 custom locale prepared;24/114/37 retained')
