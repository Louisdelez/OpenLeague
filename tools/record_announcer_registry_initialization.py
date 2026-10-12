from pathlib import Path
import json,hashlib,re,datetime,shutil
root=Path('E:/OpenLeague')
def load(path):return json.loads(path.read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def write(path,data):
    temporary=path.with_suffix(path.suffix+'.tmp');temporary.write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(temporary);temporary.replace(path)
log=root/'logs/audio-announcer-registry-init-regression.log';text=log.read_text(encoding='utf-8-sig')
assert '633 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in text
small=root/'logs/announcer-registry-init-production-tests.log';assert '62 passed; 0 failed' in small.read_text(encoding='utf-8-sig')
executable=root/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',text)[1].replace('\\','/')
plan=load(root/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
contracts={}
for name,key,count in [('audio_announcer_outer_callbacks_contract.json','cases',40),('audio_announcer_callback_registration_contract.json','bindings',835),('audio_announcer_whole_wrapper_contract.json','cases',4752),('audio_announcer_registry_initialization_contract.json','cases',128)]:
    path=root/'data/4.20'/name;data=load(path);assert data['passed'] and len(data[key])==count;contracts[name]={'count':count,'sha256':sha(path)}
references=load(root/'docs/audio_test_fixture_loading.json')['references']
for reference in references:
    path=root/reference['fixture'];assert path.stat().st_size==reference['bytes'] and sha(path)==reference['sha256']
sources=['crates/core/src/audio_announcer_outer_callbacks.rs','crates/core/src/audio_announcer_ordered_formatter.rs','crates/core/src/audio_announcer_actor_wrapper.rs','crates/core/src/lib.rs','tools/announcer_registry_init_production_tests.rs']
sources += ['tools/qualify_announcer_outer_callbacks.py','tools/qualify_announcer_callback_registration.py','tools/qualify_announcer_registry_initialization.py']
now=datetime.datetime.now(datetime.timezone.utc)
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'audio_tests_passed':633,'filtered_tests_not_run':480,'isolated_production_tests_passed':62,'native_outer_callback_cases_ported':40,'native_actor_bindings_ported':835,'native_registration_maps':167,'native_outer_composed_formatter_cases_ported':4752,'native_registry_initialization_sequences_prepared':128,'native_registry_initialization_calls_prepared':256,'contracts':contracts,'historical_fixture_references_verified':len(references),'source_hashes':{name:sha(root/name) for name in sources},'regression_log_sha256':sha(log),'isolated_log_sha256':sha(small),'test_executable':str(executable),'test_executable_sha256':sha(executable),'behavior':['Five native source/destination/local callbacks integrated with raw context memory and local virtual ID getter.','Native src/dest/you/srctr/desttr actor bindings available across167 maps, connected to existing registry and all-family formatter.','Missing context storage and failed local getter preserve explicit errors; no substituted actor.'],'limits':['Actual first native registration loop qualifies835 actor bindings; physical strings/maps/allocation/insertion/clone/destruction supplied. Four other common callbacks and later specialized registrations remain incomplete.','Initialized actor registry snapshots compose with callbacks; actual live initialization/mutation/locking/ownership remains incomplete.','256 native initialization calls newly qualified, not yet ported. Only top-level null allocation branch qualified, not nested throwing allocation.','Announcement queues, prioritization, mixing and audible in-game playback remain incomplete; full objective unachieved.'],'next_action':'Port actual661410/664E50 registry initialization already qualified in128sequences256calls, including repeated calls, shutdown flags, null top allocation and native empty sentinel/bucket layout. Qualify registry insertion/removal/rehash/locking and lifetimes. Complete other srckeytr/destkeytr/languageLocale/dimension callbacks and specialized registration table. Connect announcement queue/priorities/admission/mixing and actual in-game playback while preserving all24domains114tasks37requirements.'}
initialization=load(root/'data/4.20/audio_announcer_registry_initialization_contract.json')
receipt['native_initialized_empty_lookup_calls_prepared']=sum(len(step['empty_lookups']) for case in initialization['cases'] for step in case['steps'])
assert receipt['native_initialized_empty_lookup_calls_prepared']==256
receipt['native_registry_initialization_sequences_ported']=receipt.pop('native_registry_initialization_sequences_prepared')
receipt['native_registry_initialization_calls_ported']=receipt.pop('native_registry_initialization_calls_prepared')
receipt['native_initialized_empty_lookup_calls_ported']=receipt.pop('native_initialized_empty_lookup_calls_prepared')
receipt['native_missing_id_owned_callback_cases_ported']=2376
receipt['source_hashes']['crates/core/src/audio_announcer_registry_init.rs']=sha(root/'crates/core/src/audio_announcer_registry_init.rs')
removal_path=root/'data/4.20/audio_announcer_registry_removal_contract.json';removal=load(removal_path)
assert removal['passed'] and len(removal['cases'])==108
assert sum(len(case['steps']) for case in removal['cases'])==918
receipt['native_registry_removal_sequences_prepared']=108
receipt['native_registry_removal_cases_prepared']=918
receipt['native_after_removal_lookup_cases_prepared']=12852
receipt['contracts']['audio_announcer_registry_removal_contract.json']={'sequences':108,'removals':918,'sha256':sha(removal_path)}
receipt['source_hashes']['tools/qualify_announcer_registry_removal.py']=sha(root/'tools/qualify_announcer_registry_removal.py')
receipt['behavior'].extend(['Original661410/664E50 lazy initialization ported with owned36byte manager,16byte sentinel and64byte initial buckets; actual state flags, repeated calls and null top allocation preserved.','Live callbacks select message ID before registry initialization, then use the owned initialized lookup.2376 native missing-ID outputs matched without actor-provider calls.'])
receipt['limits']=['Native registry initialization and callback composition integrated; insertion, rehash, live deletion, concurrency and actor lifecycle remain incomplete.','918 native removal cases and12852 subsequent lookups qualified, not yet ported. Free imports and initialized layouts supplied.','Nested null allocations produce explicit unsupported-path errors; native exception unwinding, allocator ownership and actual shutdown destructor remain unqualified.','Other common/specialized callback families, announcement queues, prioritization, mixing and audible in-game playback remain incomplete. Full24domains114tasks37requirements remain mandatory.']
receipt['next_action']='Port actual64DD60 registry removal against108 native sequences918 deletions12852 subsequent lookups, preserving bucket first/last updates, neighbor links, count-before-free and returned next iterator. Qualify insertion65E6F0/663710/6680F0, growth/rehash and live actor/context ownership. Complete shutdown6653B0, exception paths and locking, other callbacks and normal announcement queue/playback. Preserve all24domains114tasks37requirements.'
backup=root/'docs/plan_history'/('announcer-registry-init-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(root/'docs'/name,backup/name)
write(root/'docs/announcer_registry_initialization_validation.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    path=root/'docs'/name;document=load(path);document['announcer_registry_initialization_validation']=receipt
    if name!='coverage.json':document['next_action']=receipt['next_action'];document['updated_utc']=now.isoformat()
    write(path,document);assert load(path)['announcer_registry_initialization_validation']==receipt
page=root/'docs/completion_plan.html';markup=page.read_text(encoding='utf-8');section='<section id="announcer-registry-initialization-validation"><h2>Annonces : registre initialise a la demande</h2><p>Initialisation native integree : 128 sequences, 256 appels et 256 recherches dans le registre vide. Memoire possedee et callbacks relies : 2376 identifiants absents compares. 62 tests isoles et 633 tests audio reussis. Suppression native preparee : 918 operations et 12852 recherches apres suppression. Insertion, suppression vivante, verrouillage, arret et lecture des annonces restent a terminer.</p></section>';assert '</body>' in markup and 'id="announcer-registry-initialization-validation"' not in markup
temporary=page.with_suffix('.html.tmp');temporary.write_text(markup.replace('</body>',section+'</body>'),encoding='utf-8');temporary.replace(page)
shutil.copy2(Path(__file__),root/'tools/record_announcer_registry_initialization.py')
print(json.dumps({'audio_tests':633,'isolated_tests':62,'scope':scope,'complete':False}))
