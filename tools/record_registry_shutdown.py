from pathlib import Path
import json,hashlib,re,datetime,shutil
r=Path('E:/OpenLeague')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,v):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(t);t.replace(p)
log=r/'logs/audio-announcer-registry-shutdown-regression.log';text=log.read_text(encoding='utf-8-sig');assert '647 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in text
small=r/'logs/announcer-registry-shutdown-tests.log';assert '76 passed; 0 failed' in small.read_text(encoding='utf-8-sig')
exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',text)[1].replace('\\','/')
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
for ref in load(r/'docs/audio_test_fixture_loading.json')['references']:
 p=r/ref['fixture'];assert p.stat().st_size==ref['bytes'] and sha(p)==ref['sha256']
contracts={}
for name,count in [('audio_announcer_registry_shutdown_contract.json',32),('audio_announcer_shutdown_routes_contract.json',12),('audio_announcer_actor_registry_composition_contract.json',288)]:
 p=r/'data/4.20'/name;v=load(p);assert v['passed'] and len(v['cases'])==count;contracts[name]={'cases':count,'sha256':sha(p)}
assert sum(len(c['steps']) for c in v['cases'])==576
now=datetime.datetime.now(datetime.timezone.utc)
sources=['crates/core/src/audio_announcer_registry_shutdown.rs','crates/core/src/lib.rs','tools/announcer_registry_shutdown_production_tests.rs','tools/qualify_registry_shutdown.py','tools/qualify_shutdown_routes.py','tools/qualify_actor_registry_composition.py']
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'audio_tests_passed':647,'filtered_tests_not_run':480,'isolated_production_tests_passed':76,'native_shutdown_calls_ported':64,'native_dynamic_free_events_ported':252,'native_actor_registry_composition_calls_prepared':576,'contracts':contracts,'regression_log_sha256':sha(log),'isolated_log_sha256':sha(small),'test_executable':str(exe),'test_executable_sha256':sha(exe),'source_hashes':{n:sha(r/n) for n in sources},'behavior':['Original6653B0/5DE550/5DEAD0 normal-return shutdown ported: buckets freed first, whole list reset before node frees, sentinel and manager freed last, null manager and initialization flag1 published even on repeated shutdown.','64 native shutdown calls matched using actual owned Rust allocations and32 lifetimes, including empty/grown tables and standard/custom free routes. Released memory is inaccessible in Rust; final manager bytes compared from pre-release capture, never use-after-free reads.','252 actual native free events matched across12 lifetimes with callbacks changing route/context. Standard node route remains cached; custom node route refreshes after callback; sentinel and manager deallocator selection remains fresh. Failed node free retains preceding bucket/list reset and published manager.'],'limits':['Normal-return free callbacks remain primitive boundaries. Native throwing unwinding, live engine allocator and actor ownership teardown are not yet qualified.','576 complete native actor registration calls newly qualified with actual primary, secondary and owner helper bodies composed, not helper-result adapters. Their unified Rust ownership composition is the next implementation.','Native virtual ID getter, physical metadata fixture fields, allocation/lock imports and returning diagnostics are supplied. Live world actor/metadata ownership, queue priorities, mixing and audible playback remain incomplete. Full game scope preserved.'],'next_action':'Implement unified actor registration sharing owned storage and actual primary/secondary/owner helpers against288 native lifetimes576 calls in audio_announcer_actor_registry_composition_contract.json. Preserve two fresh ID getters, metadata access after callbacks, prior null vs nonnull nodes, sentinel-owner skip and repeated owner-failure diagnostics. Then connect live world ownership, identity unregister/teardown, normal announcement queue, priorities, mixing and playback. Preserve24domains114tasks37requirements.'}
backup=r/'docs/plan_history'/('announcer-registry-shutdown-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/'docs/announcer_registry_shutdown_validation.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;doc=load(p);doc['announcer_registry_shutdown_validation']=receipt
 if name!='coverage.json':doc['next_action']=receipt['next_action'];doc['updated_utc']=now.isoformat()
 write(p,doc);assert load(p)['announcer_registry_shutdown_validation']==receipt
p=r/'docs/completion_plan.html';html=p.read_text(encoding='utf-8');marker='announcer-registry-shutdown-validation';assert '</body>' in html and 'id="'+marker+'"' not in html
section='<section id="'+marker+'"><h2>Annonces : destruction des registres</h2><p>Destruction Rust avec stockage possédé : 64 appels natifs et 252 libérations avec changements de callback/contextes comparés. 76 tests isolés et 647 tests audio réussis. Composition complète des helpers natifs préparée sur 576 appels ; intégration Rust avec les acteurs vivants, files et lecture audio restent à terminer.</p></section>'
t=p.with_suffix('.html.tmp');t.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');t.replace(p)
shutil.copy2(Path(__file__),r/'tools/record_registry_shutdown.py')
print(json.dumps({'audio_tests':647,'isolated_tests':76,'native_shutdown_calls':64,'native_dynamic_free_events':252,'actor_composition_calls_prepared':576,'scope':scope,'complete':False}))
