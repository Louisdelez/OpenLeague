from pathlib import Path
import json,hashlib,re,datetime,shutil
r=Path('E:/OpenLeague')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,v):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(t);t.replace(p)
log=r/'logs/audio-game-service-lifecycle-regression.log';text=log.read_text(encoding='utf-8-sig')
assert '680 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in text
small=r/'logs/game-service-lifecycle-tests.log';assert '109 passed; 0 failed' in small.read_text(encoding='utf-8-sig')
exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',text)[1].replace('\\','/')
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])}
assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
for ref in load(r/'docs/audio_test_fixture_loading.json')['references']:
 p=r/ref['fixture'];assert p.stat().st_size==ref['bytes'] and sha(p)==ref['sha256']
contract=r/'data/4.20/audio_game_service_lifecycle_contract.json';c=load(contract)
assert c['passed'] and len(c['member_cases'])==28 and len(c['whole_cases'])==8
assert not c['native_config_bytes_read_via_windows']
callback=r/'data/4.20/audio_game_service_callback16_contract.json';assert len(load(callback)['cases'])==64
dependency=load(Path('E:/mapslol3v3/replay_config_dependency_inventory.json'));assert sha(Path(dependency['path']))==dependency['sha256']
write(r/'docs/replay_config_dependency_inventory.json',dependency)
now=datetime.datetime.now(datetime.timezone.utc)
sources=['crates/core/src/audio_game_service_lifecycle.rs','crates/core/src/audio_game_service_lifecycle_tests.rs','crates/core/src/audio_game_service_buffers.rs','crates/core/src/audio_announcer_owner_metadata.rs','crates/core/src/audio_announcer_owner_control.rs','crates/core/src/audio_announcer_active_service.rs','crates/core/src/audio_announcer_service_teardown.rs','crates/core/src/lib.rs','tools/announcer_service_activation_production_tests.rs','tools/qualify_game_service_lifecycle.py','tools/probe_whole_announcer_startup.py','docs/replay_config_dependency_inventory.json']
next_action='Connect the new Rust72A3B0/72A530 service lifecycle to a real settings/resource provider and live frame/world ownership. Existing client modules native_user_settings, native_game_cfg_text, native_graphics_options, native_config_cache and native_config_resource_dispatch already implement portions: reuse verified code rather than duplicate. Qualify native float8AFB10/bool8AFC30 readers and complete8B20F0/8B1910/8B1C20 configuration layering. Original RiotRadsIO.dll has now been located in the supplied RADS root, SHA25660833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521; it is missing only from the startup probe search directories. Do not infer normal loading from fallback tests or blindly execute copied DLLs. Port734130 callback invocation and72C780 target with actual frame inputs, qualify populated replay streaming/ownership and allocation failures/reentrancy/custom routes. Continue metadata shared-control disposal and simulation announcements/queues/mixing/audible playback. Preserve24domains114tasks37requirements.'
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'audio_tests_passed':680,'filtered_tests_not_run':480,'isolated_production_tests_passed':109,'native_callback16_lifetimes_ported':64,'native_replay_member_lifetimes_ported':28,'native_whole_service_lifetimes_ported':8,'whole_service_storage_bytes':392,'settings_provider_ported':False,'native_config_bytes_read_via_windows':False,'direct_audible_playback_proved':False,'contract_sha256':sha(contract),'callback_contract_sha256':sha(callback),'regression_log_sha256':sha(log),'isolated_log_sha256':sha(small),'test_executable':str(exe),'test_executable_sha256':sha(exe),'isolated_executable_sha256':sha(r/'tools/game-service-lifecycle-tests.exe'),'source_hashes':{n:sha(r/n) for n in sources},'behavior':[
 'Rust7340C0 sixteen-byte callback clone and shared578010 scalar delete compare64 native lifetimes with null/non-null owner/method, extra offset words, allocator fills and flags0,1,256,257. Clone copies fresh source fields after allocation and publishes native vtable.',
 'Rust59CC60 replay member construction preserves all212 bytes including untouched padding and unaligned zero fields, performs six float/two bool queries in native order, and borrows/clones the input callback slot. Rust59CF40 destroys shared control before vector, callback and stream;28 actual native lifetimes cover nullable callbacks, vectors, supplied supported scalar-deletable stream objects and real1085F4C controls with last/shared/weak/zero counts.',
 'Rust72A3B0 full normal-return constructor composes active registries, replay member, history and curves;72A530 scalar teardown composes their actual destruction in native order and honors low flag bit. Eight native lifetimes compare all live words, allocations and frees on392-byte owned service storage. Native opaque stack byte and curve controls are explicit inputs; full Rust core regression680 and isolated production109 tests pass.'
 ],'limits':[
 'Actual native settings getters execute in the warmed missing-RADS/no-optional-export profile. Rust Settings is an explicit external provider boundary: test backend replays observed setting results and temporary allocations/frees, not an implementation of native settings getters. Configuration initialization/resource loading and their internal effects are not proved by service composition. Native Windows ReadFile does not read Game.cfg in this profile.',
 'Populated replay fields are explicit native preconditions; supported callback objects used for stream scalar-deletion tests do not establish native replay file loading or stream types. Custom allocators, allocations failing/throwing, constructor unwind, reentrant mutations, invalid callback kinds and live thread interactions need further qualification. Callback invocation734130/72C780 remains unimplemented.',
 'Service composition exists in the core as public APIs but is not wired to the delivered client frame/world lifecycle. Audio-prefixed grouping is historical; no direct audible playback proven. All24 domains, champions, maps, gameplay, delivered executable fidelity and acceptance remain incomplete.'
 ],'next_action':next_action}
backup=r/'docs/plan_history'/('game-service-lifecycle-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/'docs/game_service_lifecycle_validation.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 path=r/'docs'/name;doc=load(path);doc['game_service_lifecycle_validation']=receipt;doc['next_action']=next_action;doc['updated_utc']=now.isoformat();write(path,doc)
 assert load(path)['game_service_lifecycle_validation']==receipt
path=r/'docs/completion_plan.html';html=path.read_text(encoding='utf-8');marker='game-service-lifecycle-validation';assert '</body>' in html and 'id="'+marker+'"' not in html
section='<section id="'+marker+'"><h2>Service de jeu et replay : cycle de vie</h2><p>Assemblage Rust du constructeur et du destructeur : 64 cycles de callback, 28 de composant replay et 8 de service complet compar\u00e9s au code original. 680 tests de r\u00e9gression et 109 tests isol\u00e9s r\u00e9ussis. Le fournisseur de configuration et le branchement au client restent \u00e0 terminer ; les tests actuels utilisent des observations du profil de repli natif.</p></section>'
t=path.with_suffix('.html.tmp');t.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');t.replace(path)
shutil.copy2(Path(__file__),r/'tools/record_game_service_lifecycle.py')
print(json.dumps({'audio_tests':680,'isolated_tests':109,'native_callback_lifetimes':64,'native_replay_lifetimes':28,'native_whole_service_lifetimes':8,'scope':scope,'normal_resource_startup_complete':False}))
