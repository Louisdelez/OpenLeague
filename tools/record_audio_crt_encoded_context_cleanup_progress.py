from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
logname='logs/audio-crt-encoded-context-cleanup-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 515 passed; 0 failed;'in log
for test in ['audio_crt_startup_getter_matches36_original_full_startup_then_encoded_tls_fls_lookup_error_preservation_and_all55_canonical_banks','audio_crt_thread_system_cleanup_matches72_original_tls_fls_release_two_pass_dynamic_non_one_flags_static_retention_and_complete_ownership_cases']:assert test+' ... ok'in log
for stem,count in [('startup_getter',36),('thread_system_cleanup',72),('thread_lifecycle',72),('optional_thread_buffers',126)]:
 f=load('data/4.20/audio_crt_'+stem+'_preparation.json');assert f['passed']and f['case_count']==f['terminal_case_count']==count
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
priorpath='docs/audio_crt_thread_system_startup_validation.json';prior=load(priorpath);name='audio_crt_encoded_context_cleanup_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':515,
 'native_crt_startup_getter_cases_rust_validated':36,'native_crt_thread_system_cleanup_cases_rust_validated':72,
 'native_crt_thread_lifecycle_cases_prepared':72,'native_crt_thread_lifecycle_cases_rust_validated':0,
 'native_crt_optional_thread_buffer_cases_prepared':126,'native_crt_optional_thread_buffer_cases_rust_validated':0,
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),'previous_receipt':priorpath,
 'evidence':[
 'Reusable encoded Windows provider now routes actual CRT getter/NULL-context constructor/default-power-compatible service through CABCC2/CABCE1 dispatch while forwarding allocator, locks,LastError and current-thread services.36 complete startup-then-getter comparisons match all55 canonical regions, intermediate startup, actual TLS/FLS import entry banks, no extra allocation and original LastError0/97/MAX preservation.',
 '72 original CA9341/CABCA3/CB027B cleanup comparisons match fallback/extended slot free, NULL/MAX index branches, null/static/dynamic/mixed/flag2/holes tables, all call-entry and final banks. Dynamic non-one flags deleted/freed/cleared in first pass; static flag1 nodes deleted in second pass with table pointer retention. Ownership in Rust map uses36 distinct24-byte allocations instead of mistaking contiguous canonical capture for a single heap block; dead identities match exact native frees.',
 '72 complete original CA92CB startup -> CA915B detachment -> CA9341 system cleanup lifetimes captured. Actual CA9026 destructor runs, including CA8B6F locale decrement and multibyte references; caller clears TLS/FLS before destruction and frees exactly one original thread record. Explicit-record and slot-lookup detach paths, fallbackTLS/FLS, cookies0/11223344/MAX, zero/A5 initial storage and LastError0/97/MAX covered.33 complete canonical regions plus both intermediate banks captured. Rust lifecycle replay pending.',
 '126 actual startup/detachment cases additionally capture7 optional string pointers, static/NULL/heap exception field, NULL/default/static-count1/custom0/1/2/MAX multibyte ownership and both TLS/FLS paths. Controlled intermediate field changes recorded explicitly. Native free(NULL) exception branch, wrapped decrement and static-buffer retention preserved; Rust replay pending.',
 'Full515-test audio suite passes;59 prior runtime fixture reference hashes retained unchanged.'
 ],
 'limits':[
 'Imported pointer encoding,exports,critical storage and allocator outcomes remain explicit supplied services. These reconstructed core paths do not establish actual OS/heap/security-cookie providers or actual normal client audio startup.',
 'Whole destructor lifetime and126 controlled optional-buffer cases only native prepared. Default native locale used; custom locale destruction, normal optional-buffer producers and actual OS-triggered FLS callback/concurrency/SEH remain unqualified.',
 'Normal-frame audio dispatch, voice progression/retirement and physical playback remain incomplete. No domain or task marked complete; full24/114/37 scope preserved.'
 ],
 'next_action':'Implement/replay72 complete original CA92CB -> CA915B/CA9026 -> CA9341 thread lifetimes and126 optional-buffer/multibyte ownership cases, including TLS clear before destructor, ordered strings/free(NULL), wrapped reference release and static retention; qualify custom locales and OS-triggered FLS callback. Complete actual OS/heap/security-cookie providers and connect normal audio worker startup/dispatch/progression/retirement and physical playback. Continue full24-domain114-task37-requirement scope.'}
files=[logname,priorpath,'crates/core/src/lib.rs','crates/core/src/audio_crt_encoded_thread_provider.rs','crates/core/src/audio_crt_thread_system_startup.rs','tools/integrate_audio_crt_encoded_context_cleanup.py','tools/record_audio_crt_encoded_context_cleanup_progress.py']
for stem in ['startup_getter','thread_system_cleanup','thread_lifecycle','optional_thread_buffers']:files.extend(['data/4.20/audio_crt_'+stem+'_preparation.json','tools/probe_native_audio_crt_'+stem+'.py'])
receipt['files_sha256']={f:sha(r/f)for f in files};(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('native_crt_')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : contexte TLS/FLS encodé intégré ; 36 démarrages suivis de récupération et 72 nettoyages de verrous dynamiques/statiques concordent avec le client original. Suite audio : 515 tests réussis. Cycle complet avec destructeur capturé sur 72 cas ; intégration du destructeur et des fournisseurs système à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS515 audio tests;36 complete startup/getter+72 cleanup cases matched;72 actual full lifetimes prepared;24/114/37 retained')
