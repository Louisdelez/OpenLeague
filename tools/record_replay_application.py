from pathlib import Path
import datetime,hashlib,json,re,shutil,struct
import pefile
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def write(p,v):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(t);t.replace(p)
core=r/'logs/core-replay-application-tests.log';build=r/'logs/client-replay-application-build.log';probe_path=r/'logs/client-replay-application-probe.json'
core_log=core.read_text(encoding='utf-8-sig');assert '725 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in core_log
assert re.search(r'Finished `dev` profile .* target',build.read_text(encoding='utf-8-sig'))
for name in ['audio_replay_production_image_contains_original_uninitialized_banks_and_independent_owned_storage','audio_replay_production_image_rejects_foreign_identity_layout_and_truncation_without_fallback','audio_replay_windows_application_from_production_pe_bytes_starts_idle_then_runs_and_retires4_real_workers_without_fixtures','audio_replay_windows_application_drop_releases_real_heap_fls_and_locks_after_production_initialization']:
 assert name+' ... ok' in core_log
test_exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',core_log)[1].replace('\\','/')
probe=load(probe_path);assert probe['normal_application_attachment'] and not probe['replay_frame_delivery'];assert probe['live_service_allocations_after_close']==0
assert probe['before']['transport']['status']==0 and probe['before']['workers_created']==0
assert probe['running']['transport']['status']==2 and probe['running']['transport']['references']==1 and probe['running']['workers_created']==1 and probe['running']['workers_closed']==1
assert probe['closed']['closed'] and probe['closed']['transport'] is None
assert probe['closed']['crt']['slot_index']==0xffffffff
for key in ['heap_blocks','retained_mirrors','critical_sections','heap_failures','lock_failures']:assert probe['closed']['crt'][key]==0,key
assert probe['closed']['crt']['heap_allocations']==probe['closed']['crt']['heap_frees']==2
assert probe['closed']['worker_failures']==[] and probe['closed']['handle_failures']==0
native='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
manifest=load(r/'data/4.20/runtime/replay_runtime_image_manifest.json');assert manifest['native_sha256']==native and sha(Path(manifest['native_source']))==native
package=(r/'data/4.20/runtime/replay_runtime_image.bin').read_bytes();assert len(package)==manifest['package_bytes']==9924 and hashlib.sha256(package).hexdigest()==manifest['package_sha256']
pe=pefile.PE(str(manifest['native_source']));mapped=pe.get_memory_mapped_image();mapped+=bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped));assert pe.OPTIONAL_HEADER.ImageBase==manifest['image_base']
assert package[:8]==b'OL420RT\0' and package[16:48].hex()==native and len(manifest['regions'])==9
for v in manifest['regions']:
 offset=v['payload_offset'];data=package[offset:offset+v['size']];a=v['address']-manifest['image_base']
 assert struct.unpack_from('<III',package,offset-12)==(v['group'],v['address'],v['size'])
 assert data==mapped[a:a+v['size']] and hashlib.sha256(data).hexdigest()==v['sha256'],v['name']
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
shutil.copy2(s/'record_replay_application.py',r/'tools/record_replay_application.py')
now=datetime.datetime.now(datetime.timezone.utc)
next_action='Complete actual replay configuration and opening through the normal client. The client now attaches audio_replay_windows_application::Application as an owning-thread Bevy resource; it constructs real CRT/FLS/process heap/static locks and a lazy native logger transport from nine initial PE32 data banks extracted directly from the pinned4.20 executable. No qualification JSON, captured PTD, imported host pointer or initialized fixture is used by production.725 selected core tests pass; the rebuilt normal client runtime probe attaches the same Bevy owner, initializes a real worker/Winsock/timer reference, closes the configured replay service, then frees transport, logger, physical handles, CRT thread record, FLS slot and static locks. Network startup remains explicitly requested by stream configuration; the normal attachment stays idle until that source flow is connected. Port8FC230/8FC310/8FC610/8FC930/8FCA30 against60 prepared native profiles, including callback replacement, address parsing/DNS, owner224 and teardown; then8F68D0 stream/key,5BD470 assignment, metadata/callback727DE0,728E20/728FD0/728EE0 and actual replay frames. Nondefault logger members remain explicit unknown dispatcher errors. Qualify active-worker timeout/overlap and OOM/custom allocator/error cleanup; run graphical normal launch/exit after integration. Continue every other24-domain114-task37-requirement area, including map fidelity, complete champions, HUD/audio and six-client gameplay.'
sources=['crates/core/src/audio_replay_runtime_image.rs','crates/core/src/audio_replay_windows_application.rs','crates/core/src/audio_replay_windows_transport.rs','crates/core/src/audio_replay_logger.rs','crates/core/src/audio_crt_windows_root_startup.rs','crates/core/src/audio_crt_windows_engine_worker.rs','crates/core/src/lib.rs','crates/client/src/main.rs','tools/extract_replay_runtime_image.py','tools/install_replay_application.py','tools/prepare_replay_client_application.py','tools/install_replay_client_application.py','tools/record_replay_application.py']
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_source_sha256':native,'production_initial_regions':9,'production_initial_bytes':9924,'core_audio_tests_passed':725,'core_tests_filtered_not_run':480,'production_image_application_test_lifetimes':9,'production_image_real_workers_in_tests':5,'rebuilt_client_real_workers_in_probe':1,'client_executable':str(r/'target/debug/openleague-client.exe'),'client_executable_sha256':sha(r/'target/debug/openleague-client.exe'),'core_test_executable':str(test_exe),'core_test_executable_sha256':sha(test_exe),'source_hashes':{n:sha(r/n) for n in sources},'resource_hashes':{n:sha(r/n) for n in ['data/4.20/runtime/replay_runtime_image.bin','data/4.20/runtime/replay_runtime_image_manifest.json']},'log_hashes':{str(p.relative_to(r)):sha(p) for p in [core,build,probe_path,r/'logs/client-replay-application-probe.stderr.log']},'client_probe':probe,'behavior':[
 'The production provider loads9924 compiled bytes covering nine initial PE banks, with source identity and exact region layout checks. Extraction pins the original executable SHA256 and uses its actual PE32 mapped data plus loader zero-fill. Independent recording re-reads the original PE and verifies every packaged payload byte. No test fixture, emulator-mutated image, restored CRT record, host pointer or preinitialized logger feeds production.',
 'Application::new composes the existing actual process heap, security-cookie entropy, native global initialization/export registry, physical static locks, FLS allocation/root PTD, engine worker bridge and lazy logger transport. Each application owns independent mutable initial banks. Creation leaves transport status0/references0 and starts no worker or Winsock/timer reference. Canonical frame entropy remains a32-bit integer label, not a cast host pointer.',
 'Application ownership is restricted to its creating thread by a non-Send marker. Explicit close drains/releases the runtime and logger, drops the bridge, then shuts down the CRT root; Drop uses the same path. Eight explicit test lifetimes cover idle/initialized shutdown; one additional lifetime verifies Drop. Five real workers start from production image bytes and their physical heap/FLS/lock/handle resources are retired.',
 'Normal client construction inserts the Application as a Bevy non-send resource. The rebuilt executable exposes a targeted probe that calls the identical attachment helper, constructs the service from actual configuration, initializes transport, verifies status2/reference1 and one real completed/closed worker, then closes the service and runtime. The final state has no service allocations, heap blocks, retained mirrors, static locks or slot ownership; allocations/frees are2/2 and no worker or handle failures are recorded.'
 ],'limits':[
 'The headless probe runs inside the rebuilt client and uses the normal attachment helper. The graphical normal branch was rebuilt but not visually re-executed or gracefully exited in this milestone. This does not establish rendering, map fidelity or graphical shutdown acceptance.',
 'The attached runtime is deliberately idle until the native stream configuration requests initialization. The probe explicitly initializes it for qualification. Configuration/address resolution, full stream/key setup, callback bundle and replay frame delivery are still incomplete; replay_frame_delivery remains false.',
 'The extracted bytes and known pinned layouts are production data, but the resource is not a general PE loader and does not execute native x86 code. Source virtual methods continue through explicit Rust ports/dispatch boundaries. Nondefault log callbacks, custom allocators, allocation failure and pending active-worker teardown need further integration/qualification.',
 '725 selected core tests passed and480 were filtered. This milestone qualifies startup/lifetime integration only, not a full feature, game domain or whole-game completion.'
 ],'next_action':next_action}
backup=r/'docs/plan_history'/('replay-application-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/'docs/replay_application_validation.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d['replay_application_validation']=receipt;d['updated_utc']=now.isoformat();d['next_action']=next_action;write(p,d);assert load(p)['replay_application_validation']==receipt
p=r/'docs/completion_plan.html';html=p.read_text(encoding='utf-8');marker='replay-application-validation';assert '</body>' in html and 'id="'+marker+'"' not in html
section='<section id="'+marker+'"><h2>Replay : contexte original dans le client Rust</h2><p>Le client possède désormais le contexte Windows du replay, créé depuis neuf banques initiales extraites de l’exécutable 4.20. Le client reconstruit vérifie le lancement d’un worker réel puis la libération du service, du journal, des verrous, du FLS et de la mémoire. 725 tests moteur ciblés réussis. Le contexte reste au repos tant que la configuration native du flux n’est pas raccordée ; la livraison des images du replay et la vérification graphique restent à réaliser.</p></section>'
t=p.with_suffix('.html.tmp');t.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');t.replace(p)
for n,h in receipt['source_hashes'].items():assert sha(r/n)==h,n
for n,h in receipt['resource_hashes'].items():assert sha(r/n)==h,n
print(json.dumps({'passed':True,'core_tests':725,'initial_regions':9,'client_real_workers':1,'client_sha256':receipt['client_executable_sha256'],'scope':scope,'receipt':str(r/'docs/replay_application_validation.json')}))
