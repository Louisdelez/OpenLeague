from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
log_path=r/'logs/audio-action-registry-value-notifications-tests.log'
b=log_path.read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 472 passed; 0 failed;'in log
for test in ['audio_action_registry_value_update_matches720_native_first_key_low_byte_flags_notification_callback_veto_and_complete_physical_memory_cases','audio_action_registry_value_update_matches2160_native_nonempty_notification_traversal_first_all_missing_keys_low_byte_callback_veto_and_complete_physical_memory_cases','audio_registry_constructed_lifetime_matches96_native_real_registry108_pools_key_publication_source120_action44_reference_destructor_all_intermediate_physical_memory_cases']:
 assert test+' ... ok'in log,test
receipt=json.loads((r/'docs/audio_real_registry_source_lifetime_validation.json').read_text(encoding='utf-8'))
fixtures=[('audio_action_registry_value_update_preparation',720),('audio_action_registry_value_update_notifications_preparation',2160),('audio_property_owner_creation_preparation',3888),('audio_action_registry_nonempty_value_update_preparation',576)]
for name,count in fixtures:
 d=json.loads((r/('data/4.20/'+name+'.json')).read_text(encoding='utf-8'));assert d['passed']and d['case_count']==count and d['native_sha256']==receipt['native_sha256']
loading=json.loads((r/'docs/audio_test_fixture_loading.json').read_text(encoding='utf-8'))
for ref in loading['references']:assert sha(r/ref['fixture'])==ref['sha256'],ref['fixture']
receipt.update(saved_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),audio_tests_passed=472,native_registry_value_update_cases_prepared=720,native_registry_value_update_cases_rust_validated=720,native_registry_nonempty_notification_cases_prepared=2160,native_registry_nonempty_notification_cases_rust_validated=2160,native_property_owner_creation_cases_prepared=3888,native_property_owner_creation_cases_rust_validated=0,native_registry_nonempty_action_value_update_cases_prepared=576,native_registry_nonempty_action_value_update_cases_rust_validated=0)
receipt['test_log']='logs/audio-action-registry-value-notifications-tests.log'
receipt['test_executable_sha256']=sha(r/receipt['test_executable'])
files=set(receipt['files_sha256'])|{'crates/core/src/audio_action_registry_value_update.rs','crates/core/src/audio_path_source_terminal_cleanup.rs','crates/core/src/lib.rs',receipt['test_log']}
files|={'data/4.20/'+n+'.json'for n,c in fixtures}
files|={'tools/'+n+'.py'for n in ['probe_native_audio_action_registry_value_update','probe_native_audio_action_registry_value_update_notifications','probe_native_audio_property_owner_creation','probe_native_audio_action_registry_nonempty_value_update']}
receipt['files_sha256']={f:sha(r/f)for f in sorted(files)}
receipt['evidence'].insert(0,'Rust AF6FF0 current state publication, low-byte instant/skip flags, first-key lookup and callback veto matches720 native cases. Actual nonempty AF7600 three-node notification traversal matches2160 native cases; complete physical banks and every callback snapshot compared. Global callback pointer is read after notifications; selected child property storage is reread on each property iteration.')
receipt['evidence'].insert(1,'Native AF5490 fresh allocation/B20EA0 constructor/B21040 gain-clock-curve-binding setup/AFF610 growth/B212C0 destruction/queue publication/fallback prepared3888 original cases. Nonempty AF6FF0 with actual AF6A30 transition-duration lookup, AFF560, AF5670 owned update and empty-manager AF5490 fallback prepared576 original cases. These two matrices are not Rust qualified yet.')
receipt['limits'].insert(0,'720 and2160 matrices have empty action lists and supplied registry table/owners; state and notification virtual callbacks are explicit ABI adapters without mutation in these matrices. Nonempty action logic is implemented but unqualified; AF5490 constructor service and input98/action0 callbacks remain required dependencies. Fresh allocation and reuse/progression, mutable callbacks, admission/default setters, startup/shutdown/global publication and whole-frame physical playback remain open. No game domain is complete.')
receipt['next_action']='Implement and qualify AF5490 real transition producer: B20EA0 owner56 constructor, B21040 initial/target gain clock curve binding setup, AFF610 growth, B212C0 cleanup and queue publication/fallback using3888 native cases. Qualify reuse B20EE0/B21290/AF5B40 and normal property progression. Compose real transition producer with AF6FF0 nonempty actions against576 native cases, then success attachment/source98/action0 and mutable notifications/callbacks, resource admission AFB320/default AF7280, startup/global publishing, registry shutdown and complete normal-frame physical playback.'
name='audio_action_registry_value_update_validation'
(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=json.loads(p.read_text(encoding='utf-8'));d[name]=summary;d['next_action']=receipt['next_action'];p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';h=p.read_text(encoding='utf-8');paragraph='<p>Audio : mise à jour des valeurs et veto du callback comparés à 720 cas natifs ; parcours des notifications non vides comparé à 2160 cas natifs. Suite Rust : 472 tests réussis. Création réelle des transitions préparée sur 3888 cas natifs et chaîne avec actions non vides sur 576 cas ; leurs comparaisons Rust, progression, rattachement et lecture audio complète restent à réaliser.</p>\n';assert '</body>'in h
if paragraph not in h:p.write_text(h.replace('</body>',paragraph+'</body>'),encoding='utf-8')
plan=json.loads((r/'docs/completion_plan.json').read_text(encoding='utf-8'));assert len(plan['domains'])==24 and sum(len(d['tasks'])for d in plan['domains'])==114 and sum(len(d['additional_requirements'])for d in plan['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest,f
print('PASS472 audio tests;720 value update and2160 nonempty notifications Rust qualified;3888 transition producer and576 nonempty action cases native-prepared only;24/114/37 scope retained.')
