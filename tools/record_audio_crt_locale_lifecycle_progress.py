from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
logname='logs/audio-crt-locale-lifecycle-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 520 passed; 0 failed;'in log
for test in ['audio_crt_time_payload_destruction_matches4_original_null_record_and87_distinct_null_alternating_field_identities_order_and_complete_storage','audio_crt_custom_locale_lifecycle_matches16_original_full_startup_old_locale_release_custom_installation_nested_destruction_shared_retention_and_system_cleanup']:assert test+' ... ok'in log
for stem,count in [('custom_locale_lifecycle',16),('time_payload_destruction',4),('time_locale_lifecycle',8)]:
 f=load('data/4.20/audio_crt_'+stem+'_preparation.json');assert f['passed']and f['case_count']==f['terminal_case_count']==count
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
priorpath='docs/audio_crt_custom_locale_validation.json';prior=load(priorpath);name='audio_crt_locale_lifecycle_validation'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':520,
 'native_crt_custom_locale_lifecycle_cases_rust_validated':16,'native_crt_time_payload_destruction_cases_rust_validated':4,
 'native_crt_time_locale_lifecycle_cases_prepared':8,'native_crt_time_locale_lifecycle_cases_rust_validated':0,
 'test_log':logname,'test_executable':prior['test_executable'],'test_executable_sha256':sha(r/prior['test_executable']),'previous_receipt':priorpath,
 'evidence':[
 'Original CC8564 time payload helper extracted and integrated into CA8A15.4 original NULL record/NULL-all/nonnull-all/alternating pointer cases match all87 field identities in original order, every allocator entry/full bank, complete89 payload slots and exact nonNULL freed identities. Previous96 custom locale tests retained.',
 '16 original entire startup -> old default locale reference release -> supplied custom installation -> thread detach/nested locale destruction -> system cleanup lifetimes now match all67 canonical regions, every original allocator/Windows/lock service entry, four intermediate banks and final storage. Count1 destroys locale; count2 retains external-owner shared locale. Custom structures and allocation identities are explicit inputs with old native default references released, not silently overwritten.',
 '8 full original custom thread lifetimes with nonNULL all/alternating distinct time payloads captured; actual CA9026/CA8A15/CC8564 and system cleanup bodies execute. Count1 vs count2 and TLS/FLS covered, all68 canonical regions and all89 physical time payload slots retained. Rust full nonNULL-time composition replay pending.',
 'Full520-test audio suite passes;59 earlier fixture hashes retained unchanged.'
 ],
 'limits':[
 'Standalone87-field nonNULL time helper and whole custom thread lifetimes with NULL time payloads qualified; whole custom thread lifetimes with nonNULL time payloads8cases prepared but not Rust-qualified yet.',
 'Custom locale/time structures supplied at explicit input boundaries. Normal native locale producers, actual heap/OS/security-cookie provider, OS callback invoking Rust CRT destruction, interlocked concurrency and SEH remain unqualified.',
 'No normal client audio worker startup/dispatch/progression/retirement or physical playback completion claim. Full24 domains/114tasks/37requirements retained without closing tasks/domains.'
 ],
 'next_action':'Replay8 entire original custom thread lifetimes with distinct nonNULL time payloads. Then qualify OS-triggered FLS callback invoking actual context destructor and actual OS/heap/security-cookie providers; connect normal audio worker startup/dispatch/progression/retirement and physical playback. Normal locale producers and concurrency/SEH remain required. Continue full24-domain114-task37-requirement scope.'}
files=[logname,priorpath,'crates/core/src/audio_crt_custom_locale_destructor.rs','crates/core/src/audio_crt_thread_system_startup.rs','tools/qualify_audio_crt_locale_lifecycle.py','tools/record_audio_crt_locale_lifecycle_progress.py']
for stem in ['custom_locale_lifecycle','time_payload_destruction','time_locale_lifecycle']:files.extend(['data/4.20/audio_crt_'+stem+'_preparation.json','tools/probe_native_audio_crt_'+stem+'.py'])
receipt['files_sha256']={f:sha(r/f)for f in files};(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
metrics={k:v for k,v in receipt.items()if k=='audio_tests_passed'or k.startswith('native_crt_')}
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=load('docs/'+filename);d[name]=summary;d['next_action']=receipt['next_action']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update(metrics)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');v='<p>Audio : 16 cycles complets de contexte avec locale personnalisée et les 87 libérations temporelles à pointeurs distincts concordent avec le client original. Suite audio : 520 tests réussis. Composition complète avec données temporelles non nulles capturée sur 8 cas ; intégration système et fonctionnement audio réel à poursuivre.</p>\n';assert '</body>'in s
if v not in s:p.write_text(s.replace('</body>',v+'</body>'),encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(x['tasks'])for x in p['domains'])==114 and sum(len(x['additional_requirements'])for x in p['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest
print('PASS520 audio tests;16 custom thread lifetimes+4 distinct temporal payload cases matched;8 full time lifetimes prepared;24/114/37 retained')
