from pathlib import Path
import json,hashlib,re,datetime,shutil
root=Path('E:/OpenLeague')
def load(path):return json.loads(path.read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def write(path,data):
    temporary=path.with_suffix(path.suffix+'.tmp');temporary.write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(temporary);temporary.replace(path)
log=root/'logs/audio-announcer-outer-callbacks-regression.log';text=log.read_text(encoding='utf-8-sig')
assert '629 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in text
small=root/'logs/announcer-outer-callbacks-production-tests.log';assert '58 passed; 0 failed' in small.read_text(encoding='utf-8-sig')
executable=root/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',text)[1].replace('\\','/')
plan=load(root/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
contracts={}
for name,key,count in [('audio_announcer_outer_callbacks_contract.json','cases',40),('audio_announcer_callback_registration_contract.json','bindings',835),('audio_announcer_whole_wrapper_contract.json','cases',4752),('audio_announcer_registry_initialization_contract.json','cases',128)]:
    path=root/'data/4.20'/name;data=load(path);assert data['passed'] and len(data[key])==count;contracts[name]={'count':count,'sha256':sha(path)}
references=load(root/'docs/audio_test_fixture_loading.json')['references']
for reference in references:
    path=root/reference['fixture'];assert path.stat().st_size==reference['bytes'] and sha(path)==reference['sha256']
sources=['crates/core/src/audio_announcer_outer_callbacks.rs','crates/core/src/audio_announcer_ordered_formatter.rs','crates/core/src/audio_announcer_actor_wrapper.rs','crates/core/src/lib.rs','tools/announcer_outer_callbacks_production_tests.rs']
sources += ['tools/qualify_announcer_outer_callbacks.py','tools/qualify_announcer_callback_registration.py','tools/qualify_announcer_registry_initialization.py']
now=datetime.datetime.now(datetime.timezone.utc)
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'audio_tests_passed':629,'filtered_tests_not_run':480,'isolated_production_tests_passed':58,'native_outer_callback_cases_ported':40,'native_actor_bindings_ported':835,'native_registration_maps':167,'native_outer_composed_formatter_cases_ported':4752,'native_registry_initialization_sequences_prepared':128,'native_registry_initialization_calls_prepared':256,'contracts':contracts,'historical_fixture_references_verified':len(references),'source_hashes':{name:sha(root/name) for name in sources},'regression_log_sha256':sha(log),'isolated_log_sha256':sha(small),'test_executable':str(executable),'test_executable_sha256':sha(executable),'behavior':['Five native source/destination/local callbacks integrated with raw context memory and local virtual ID getter.','Native src/dest/you/srctr/desttr actor bindings available across167 maps, connected to existing registry and all-family formatter.','Missing context storage and failed local getter preserve explicit errors; no substituted actor.'],'limits':['Actual first native registration loop qualifies835 actor bindings; physical strings/maps/allocation/insertion/clone/destruction supplied. Four other common callbacks and later specialized registrations remain incomplete.','Initialized actor registry snapshots compose with callbacks; actual live initialization/mutation/locking/ownership remains incomplete.','256 native initialization calls newly qualified, not yet ported. Only top-level null allocation branch qualified, not nested throwing allocation.','Announcement queues, prioritization, mixing and audible in-game playback remain incomplete; full objective unachieved.'],'next_action':'Port actual661410/664E50 registry initialization already qualified in128sequences256calls, including repeated calls, shutdown flags, null top allocation and native empty sentinel/bucket layout. Qualify registry insertion/removal/rehash/locking and lifetimes. Complete other srckeytr/destkeytr/languageLocale/dimension callbacks and specialized registration table. Connect announcement queue/priorities/admission/mixing and actual in-game playback while preserving all24domains114tasks37requirements.'}
initialization=load(root/'data/4.20/audio_announcer_registry_initialization_contract.json')
receipt['native_initialized_empty_lookup_calls_prepared']=sum(len(step['empty_lookups']) for case in initialization['cases'] for step in case['steps'])
assert receipt['native_initialized_empty_lookup_calls_prepared']==256
backup=root/'docs/plan_history'/('announcer-outer-callbacks-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(root/'docs'/name,backup/name)
write(root/'docs/announcer_outer_callbacks_validation.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    path=root/'docs'/name;document=load(path);document['announcer_outer_callbacks_validation']=receipt
    if name!='coverage.json':document['next_action']=receipt['next_action'];document['updated_utc']=now.isoformat()
    write(path,document);assert load(path)['announcer_outer_callbacks_validation']==receipt
page=root/'docs/completion_plan.html';markup=page.read_text(encoding='utf-8');section='<section id="announcer-outer-callbacks-validation"><h2>Annonces : selection des acteurs et callbacks</h2><p>Cinq callbacks integres : src, dest, you, srctr et desttr. 40 contextes natifs, 835 enregistrements sur 167 tables et 4752 compositions verifies. 58 tests isoles et 629 tests audio reussis. Initialisation native du registre preparee : 128 sequences, 256 appels. Gestion du registre vivant, autres callbacks et lecture en partie restent incompletes.</p></section>';assert '</body>' in markup and 'id="announcer-outer-callbacks-validation"' not in markup
temporary=page.with_suffix('.html.tmp');temporary.write_text(markup.replace('</body>',section+'</body>'),encoding='utf-8');temporary.replace(page)
shutil.copy2(Path(__file__),root/'tools/record_announcer_outer_callbacks.py')
print(json.dumps({'audio_tests':629,'isolated_tests':58,'scope':scope,'complete':False}))
