from pathlib import Path
import json,hashlib,re,datetime,shutil
root=Path('E:/OpenLeague')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,v):
 temp=p.with_suffix(p.suffix+'.tmp');temp.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(temp);temp.replace(p)
log=root/'logs/audio-announcer-secondary-registry-regression.log';text=log.read_text(encoding='utf-8-sig');assert '644 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in text
small=root/'logs/announcer-secondary-registry-tests.log';assert '73 passed; 0 failed' in small.read_text(encoding='utf-8-sig')
exe=root/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',text)[1].replace('\\','/')
plan=load(root/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
for ref in load(root/'docs/audio_test_fixture_loading.json')['references']:
 p=root/ref['fixture'];assert p.stat().st_size==ref['bytes'] and sha(p)==ref['sha256']
contracts={};calls=0
for name,count in [('audio_announcer_secondary_owner_registries_contract.json',144),('audio_announcer_secondary_growth_contract.json',8)]:
 p=root/'data/4.20'/name;v=load(p);assert v['passed'] and len(v['cases'])==count;calls+=sum(len(c['steps']) for c in v['cases']);contracts[name]={'cases':count,'sha256':sha(p)}
assert calls==672 and len(v['thresholds'])==48
shutdown=root/'data/4.20/audio_announcer_registry_shutdown_contract.json';sv=load(shutdown);assert sv['passed'] and len(sv['cases'])==32 and sum(len(c['steps']) for c in sv['cases'])==64
contracts[shutdown.name]={'cases':32,'shutdown_calls_prepared':64,'sha256':sha(shutdown)}
now=datetime.datetime.now(datetime.timezone.utc)
sources=['crates/core/src/audio_announcer_secondary_registries.rs','crates/core/src/audio_announcer_object_lookup.rs','crates/core/src/audio_announcer_registry_init.rs','crates/core/src/audio_announcer_registry_insert.rs','crates/core/src/lib.rs','tools/announcer_secondary_registries_production_tests.rs','tools/qualify_secondary_growth.py']
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'audio_tests_passed':644,'filtered_tests_not_run':480,'isolated_production_tests_passed':73,'native_secondary_owner_registrations_ported':672,'native_count_threshold_queries_ported':48,'contracts':contracts,'regression_log_sha256':sha(log),'isolated_log_sha256':sha(small),'test_executable':str(exe),'test_executable_sha256':sha(exe),'source_hashes':{n:sha(root/n) for n in sources},'behavior':['Actual secondary and owner normal-return helpers ported as core APIs: raw unsigned identity hashing, node lookup distinct from null stored actor, null actor diagnostic before lookup, paired lock callbacks, pointer-vector append/growth, owner-specific allocator boundary and low-byte return.','Legacy primary hash retained. Identity hash propagated through insertion, sorting and full bucket rehash.664E50 fixed-address constructor reused by existing lazy initialization.','Compared672 registrations across152 native lifetimes, including zero actor repetitions, existing-zero and existing-nonzero entries, high unsigned collision keys, table8-to64 rehash and48-element pointer vectors.48 native count-threshold queries matched for9999,10000,10001 present/missing keys.'],'limits':['Lock primitives, returning diagnostics and owner engine allocator5CC6B0 remain explicit supplied boundaries. Tests prove callback order and storage, not live Windows synchronization or engine heap behavior.','Source-alias pointer-vector append and native exception unwinding not qualified. Early errors retain preceding mutation and do not claim native cleanup.','Actor-registration provider still requires runtime ownership composition. Live world metadata/actor storage, removal and shutdown, normal announcement queues, priorities, mixing and audible playback remain incomplete. Full game scope remains unchanged.'],'next_action':'Connect complete actor-registration orchestration to the actual secondary/owner registry APIs with owned actor/metadata storage; qualify identity table removal, owner-array allocator and shutdown. Integrate normal announcement event queue, priorities, mixing and playback. Preserve24domains114tasks37requirements.'}
backup=root/'docs/plan_history'/('announcer-secondary-registry-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
receipt['native_shutdown_calls_prepared']=64
receipt['limits'].append('Actual primary registry shutdown/destruction qualified in32 lifetimes64 calls, including grown tables, repeat shutdown and custom/standard free callbacks. Rust shutdown implementation remains open.')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(root/'docs'/name,backup/name)
write(root/'docs/announcer_secondary_registry_validation.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=root/'docs'/name;doc=load(p);doc['announcer_secondary_registry_validation']=receipt
 if name!='coverage.json':doc['next_action']=receipt['next_action'];doc['updated_utc']=now.isoformat()
 write(p,doc);assert load(p)['announcer_secondary_registry_validation']==receipt
p=root/'docs/completion_plan.html';html=p.read_text(encoding='utf-8');marker='announcer-secondary-registry-validation';assert '</body>' in html and 'id="'+marker+'"' not in html
section='<section id="'+marker+'"><h2>Annonces : registres secondaires et propriétaires</h2><p>Helpers Rust intégrés et comparés à 672 enregistrements natifs et 48 recherches de seuil : hachage brut, valeurs nulles, verrous, listes, agrandissement et rehash. 73 tests isolés et 644 tests audio réussis. Composition avec les acteurs vivants, allocation moteur, destruction, files et lecture audio restent à terminer.</p></section>'
temp=p.with_suffix('.html.tmp');temp.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');temp.replace(p)
shutil.copy2(Path(__file__),root/'tools/record_secondary_registries.py')
shutil.copy2(Path('E:/mapslol3v3/qualify_registry_shutdown.py'),root/'tools/qualify_registry_shutdown.py')
print(json.dumps({'audio_tests':644,'isolated_tests':73,'native_registrations':672,'threshold_queries':48,'scope':scope,'complete':False}))
