from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
name='audio_registry_native_callbacks_validation'
logname='logs/audio-registry-native-callbacks-qualified-tests.log'
b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 480 passed; 0 failed;'in log
case='audio_registry_native_callbacks_matches288_original_transition_creation_acquisition_progression_recursive_release_active_voice_flags_oom_and_complete_physical_lifetimes'
assert case+' ... ok'in log
receipt=json.loads((r/'docs/audio_source_acquisition_action_callback_validation.json').read_text(encoding='utf-8'))
p=json.loads((r/'data/4.20/audio_registry_native_transition_callbacks_preparation.json').read_text(encoding='utf-8'));assert p['passed']and p['case_count']==288
fixture_contract=json.loads((r/'docs/audio_test_fixture_loading.json').read_text(encoding='utf-8'))
for ref in fixture_contract['references']:assert sha(r/ref['fixture'])==ref['sha256'],ref['fixture']
receipt.update(saved_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),audio_tests_passed=480,native_registry_native_transition_callbacks_cases_rust_validated=288,test_log=logname,native_registry_selected_child_callbacks_cases_prepared=288,native_registry_selected_child_callbacks_cases_rust_validated=0)
receipt['test_executable_sha256']=sha(r/receipt['test_executable'])
files=set(receipt['files_sha256'])|{logname,'crates/core/src/audio_action_registry_value_update.rs','tools/implement_audio_registry_native_callbacks.py','tools/fix_audio_registry_native_callbacks_return.py','tools/record_audio_registry_native_callbacks_progress.py','logs/audio-registry-native-callbacks-tests.log','data/4.20/audio_registry_selected_child_callbacks_preparation.json','tools/probe_native_audio_registry_selected_child_callbacks.py'}
receipt['files_sha256']={f:sha(r/f)for f in sorted(files)}
receipt['evidence'].insert(0,'288 complete original AF6FF0/AF5490/Source98/Action0/Source9C/AF5B90/active SourceCC voice flags/B20EE0 compositions now match Rust. Actual native routines composed in one canonical bank, with only allocation/free adapters in the original oracle. Full physical snapshots compared at every transition, allocation, input/action callback, release, free, voice invalidation and progression; all per-step/final banks, returned finished low-byte, allocation identities/sizes and retired references compared. Fresh/existing input owner, property/binding/input OOM, five property types, durations0/1/97, instant flags0/1, progression31/32/35 and0/a5 prefill qualified. Required controlled callbacks reject invocation, proving actual callbacks execute.')
receipt['limits'].insert(0,'288 compositions still supply initial registry/action/packed properties/source/manager/voice structures; no selected child, notifications skipped, no parents. Actual recursive acquisition/release are composed, but this288 matrix has no parent graph. Progression is explicitly invoked per live owner; normal-frame manager dispatch, phase drain/retirement, bank/resource/startup producers, dynamic RTPC selector, callback/allocator mutations and physical audio output remain unqualified. Existing648 recursive acquisition and512 release tests remain regression evidence. No complete audio or game domain claim.')
receipt['evidence'].insert(0,'288 additional native selected-child compositions prepared: first duplicate key with NULL later child, later matching child and zero-count padding packed property, five actual selected-child float targets, fresh/existing voice, allocator failures, duration/instant and progression. Native oracle bodies execute; Rust replay not yet run for these additional288. Fixture records complete regions for replay.')
receipt['next_action']='Replay288 prepared selected-child compositions from data/4.20/audio_registry_selected_child_callbacks_preparation.json; qualify callback/allocator mutations in full registry transition/input/action/active-voice compositions. Then port dynamic B11040 retained-x87 selector/RTPC producer, resource admission AFB320/default AF7280, startup/global publishing/FP controls, registry shutdown and complete normal-frame dispatch/phase retirement/physical playback. Preserve entire24-domain/114-task/37-requirement game plan.'
# Replace obsolete pending qualifier with its explicitly retained original preparation milestone.
receipt['evidence']=[v.replace('Native preparation only;','Initially native preparation only; now288 Rust replay qualified as described above. ')for v in receipt['evidence']]
(r/('docs/'+name+'.json')).write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']='docs/'+name+'.json'
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/filename;d=json.loads(p.read_text(encoding='utf-8'));d[name]=summary;d['next_action']=receipt['next_action'];p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';h=p.read_text(encoding='utf-8');paragraph='<p>Audio : chaîne réelle de transitions, acquisition des entrées, callbacks de publication/libération, invalidation des voix actives et progression comparée à 288 compositions du client original. Toutes les banques mémoire et étapes intermédiaires concordent. Suite audio Rust : 480 tests réussis. Production des ressources, progression dans la boucle normale et sortie audio complète restent à terminer.</p>\n';assert '</body>'in h
if paragraph not in h:p.write_text(h.replace('</body>',paragraph+'</body>'),encoding='utf-8')
plan=json.loads((r/'docs/completion_plan.json').read_text(encoding='utf-8'));assert len(plan['domains'])==24 and sum(len(d['tasks'])for d in plan['domains'])==114 and sum(len(d['additional_requirements'])for d in plan['domains'])==37
for f,digest in receipt['files_sha256'].items():assert sha(r/f)==digest,f
print('PASS480 audio tests;288 complete native callback lifetime compositions now qualified;full24/114/37 objective retained')
