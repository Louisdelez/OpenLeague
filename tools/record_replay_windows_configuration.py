from pathlib import Path
import datetime,hashlib,json,re,shutil,struct
import pefile
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def write(p,v):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');assert load(t)==v;t.replace(p)
core=r/'logs/core-replay-windows-configuration-tests.log';targeted=r/'logs/replay-windows-configuration-targeted.log';build=r/'logs/client-replay-windows-configuration-build.log';probe_path=r/'logs/client-replay-windows-configuration-probe.json';regression_path=r/'logs/client-replay-windows-runtime-regression.json'
core_log=core.read_text(encoding='utf-8-sig');targeted_log=targeted.read_text(encoding='utf-8-sig')
assert '737 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in core_log
assert '5 passed; 0 failed; 0 ignored; 0 measured; 1212 filtered out' in targeted_log
for name in ['audio_replay_windows_configuration_real_numeric_lifetimes_use_original_uid_arguments_and_retire_all_resources','audio_replay_windows_configuration_localhost_keeps_caller_socket_port_and_actual_windows_lookup','audio_replay_windows_configuration_replaces_owned_callbacks_then_crc_failure_closes_once_and_rejects_released_reuse','audio_replay_windows_configuration_invalid_hosts_ports_and_uid_release_network_and_keep_native_return_codes','audio_replay_windows_configuration_application_drop_retires_live_or_failed_configuration_and_its_crt_owner']:
 assert name+' ... ok' in core_log and name+' ... ok' in targeted_log,name
assert re.search(r'Finished `dev` profile .* target',build.read_text(encoding='utf-8-sig'))
probe=load(probe_path);regression=load(regression_path)
assert probe['normal_application_attachment'] and probe['native_transport_configuration'] and not probe['source_stream_opening_connected'] and not probe['replay_frame_delivery']
assert probe['native_success_code']==0 and probe['native_failure_code']==3
assert probe['before']['transport']['configuration'] is None and probe['before']['workers_created']==0
configured=probe['configured']['transport'];failed=probe['configuration_error']['transport']
assert configured['references']==configured['winsock_references']==configured['timer_references']==1
assert configured['configuration']['uid']==0xff2199f5 and configured['configuration']['requested_port']==65535 and configured['configuration']['address_text']==list(b'127.0.0.1')
assert configured['configuration']['host']==configured['configuration']['queue_count']==0
assert failed['references']==failed['winsock_references']==failed['timer_references']==0
assert failed['configuration']['uid']==0 and failed['configuration']['return_code']==3 and failed['configuration']['address_text']==list(b'98.24.0.44')
for d in [probe['closed'],regression['closed']]:
 assert d['closed'] and d['transport'] is None and d['workers_created']==d['workers_closed']==1
 assert d['crt']['slot_index']==0xffffffff and d['worker_failures']==[] and d['handle_failures']==0
 for key in ['heap_blocks','retained_mirrors','critical_sections','heap_failures','lock_failures']:assert d['crt'][key]==0,key
 assert d['crt']['heap_allocations']==d['crt']['heap_frees']==2
assert regression['normal_application_attachment'] and not regression['replay_frame_delivery'] and regression['live_service_allocations_after_close']==0
native='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
manifest=load(r/'data/4.20/runtime/replay_runtime_image_manifest.json');assert manifest['native_sha256']==native and sha(Path(manifest['native_source']))==native
package=(r/'data/4.20/runtime/replay_runtime_image.bin').read_bytes();assert len(package)==manifest['package_bytes']==10100 and hashlib.sha256(package).hexdigest()==manifest['package_sha256'] and len(manifest['regions'])==11
pe=pefile.PE(str(manifest['native_source']));mapped=pe.get_memory_mapped_image();mapped+=bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped));assert pe.OPTIONAL_HEADER.ImageBase==manifest['image_base']
assert package[:8]==b'OL420RT\0' and struct.unpack_from('<II',package,8)==(1,11) and package[16:48].hex()==native
for v in manifest['regions']:
 offset=v['payload_offset'];data=package[offset:offset+v['size']];a=v['address']-manifest['image_base'];assert struct.unpack_from('<III',package,offset-12)==(v['group'],v['address'],v['size']);assert data==mapped[a:a+v['size']] and hashlib.sha256(data).hexdigest()==v['sha256'],v['name']
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
key='replay_windows_configuration_validation';marker='replay-windows-configuration-validation';html_path=r/'docs/completion_plan.html';html=html_path.read_text(encoding='utf-8');assert '</body>' in html and 'id="'+marker+'"' not in html
assert not (r/'docs'/f'{key}.json').exists()
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert key not in load(r/'docs'/name)
derived=load(s/'replay_stream_derived_lifetime_probe.json');assert derived['passed'] and derived['native_sha256']==native and len(derived['cases'])==6
for source,target in [('probe_replay_stream_derived_lifetime.py','tools/probe_replay_stream_derived_lifetime.py'),('replay_stream_derived_lifetime_probe.json','data/4.20/replay_stream_derived_lifetime_probe.json'),('replay-stream-derived-lifetime-probe.log','logs/replay-stream-derived-lifetime-probe.log')]:
 assert not (r/target).exists();shutil.copy2(s/source,r/target)
shutil.copy2(s/'record_replay_windows_configuration.py',r/'tools/record_replay_windows_configuration.py')
now=datetime.datetime.now(datetime.timezone.utc)
next_action='Connect native replay stream opening8F68D0 to the now-functional Windows224-byte transport configuration owner and the normal service/client flow. Application production data now has11 original PE banks/10100bytes; Runtime::configure runs native8FC610 through real engine/CRT workers, Winsock address lookup/formatting, physical locks, clock and native logger. Configuration ownership, callback replacement, invalid-address cleanup and explicit/Drop shutdown pass15 real Windows lifetimes;737 selected core tests pass and the rebuilt client runs both configuration and runtime regression probes. Source stream opening is still not connected and replay_frame_delivery remains false. Native8F68D0 mode0 allocates0x918 bytes through8F6D00: its224-byte base is followed by interface+E0 with vtable10D6254.9018C0 publishes the+E0 interface pointer while its16-byte shared control retains the base pointer. Interface configuration8F6EB0 constructs a0x1058-byte key object98F710 from16 key bytes and delegates to8FC610 on interface-E0; base vtable10D6040 overrides close with8F6FA0. Extend ownership and virtual close/destruction for this actual derived object, and qualify the alternate16-byte10D5FEC implementation and8FB650 resource preparation. Keep canonical service/stream/transport ownership consistent when attaching callback727DE0 and members728E20/728FD0/728EE0; cloned callback descriptors currently have no packet invocation dispatcher. Port8F68D0 stream/key and5BD470 assignment, actual packet pool8FCB90/8FCC80 and active host9007F0/8FE700/8FD8A0 before active host or packet cleanup can succeed. A status2/reference0 runtime after native close explicitly rejects new configuration; qualify source parent lifecycle/retry/multi-owner behavior rather than changing native globals or fabricating network references. Caller address-frame residue is explicit, including localhost preserved port. Qualify actual startup failures/timeouts/OOM/custom allocators and nondefault callback dispatch, then source stream opening, frame delivery, normal graphical launch/exit and all24-domain114-task37-requirement work.'
test_exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',core_log)[1].replace('\\','/')
sources=['crates/core/src/audio_replay_windows_configuration.rs','crates/core/src/audio_replay_windows_configuration_tests.rs','crates/core/src/audio_replay_windows_transport.rs','crates/core/src/audio_replay_windows_application.rs','crates/core/src/audio_replay_runtime_image.rs','crates/core/src/audio_replay_transport_configuration.rs','crates/core/src/audio_replay_address.rs','crates/core/src/audio_replay_logger.rs','crates/client/src/main.rs','tools/extract_replay_runtime_image.py','tools/prepare_replay_windows_configuration.py','tools/prepare_replay_configuration_client.py','tools/install_replay_windows_configuration.py','tools/record_replay_windows_configuration.py','tools/probe_replay_stream_derived_lifetime.py']
logs=[core,targeted,build,probe_path,regression_path,r/'logs/client-replay-windows-configuration-probe.stderr.log',r/'logs/client-replay-windows-runtime-regression.stderr.log']
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_source_sha256':native,'core_audio_tests_passed':737,'core_tests_filtered_not_run':480,'new_targeted_tests_passed':5,'new_targeted_tests_filtered_not_run':1212,'production_initial_regions':11,'production_initial_bytes':10100,'configuration_windows_lifetimes_per_suite':15,'client_configuration_real_workers':1,'client_runtime_regression_real_workers':1,'client_executable':str(r/'target/debug/openleague-client.exe'),'client_executable_sha256':sha(r/'target/debug/openleague-client.exe'),'core_test_executable':str(test_exe),'core_test_executable_sha256':sha(test_exe),'source_hashes':{n:sha(r/n) for n in sources},'resource_hashes':{n:sha(r/n) for n in ['data/4.20/runtime/replay_runtime_image.bin','data/4.20/runtime/replay_runtime_image_manifest.json']},'log_hashes':{str(p.relative_to(r)):sha(p) for p in logs},'client_configuration_probe':probe,'client_runtime_regression':regression,'behavior':[
 'The production initial-data resource adds the actual10D5FA4 close/scalar-delete vtable and144-byte UID/validation scratch. All11 banks are independently re-read and byte-compared with the pinned original PE, including loader zero fill. No captured runtime state or test fixture is loaded in production.',
 'Runtime owns a constructed224-byte object and8-byte queue proxy. configure creates/transfers optional12-byte callbacks, executes the source configuration port through real thread::initialize/drain, CRT bridge, WSAStartup, address lookup/formatting, timeGetTime and physical mutexes. Address input storage is explicit; numeric parsing, low16-bit requested port, zero sockaddr port and CRC failure quirks are preserved.',
 'Configuration can replace callbacks on the existing object without another worker or network reference. Public manual reference release is rejected while configuration owns the lifetime. close_configuration and Runtime/Application shutdown close any owned reference once, destroy callback/proxy/object and then retire logger, thread controls, Winsock/timer, CRT root, FLS and locks. Explicit and Drop paths are verified.',
 'The native source retains status2 after releasing its last reference; the high-level owner rejects reconfiguration of that released runtime before mutation instead of fabricating a new reference. This is an explicit unsupported reuse path pending source parent-lifecycle qualification, not a change to the generic source port.',
 'Five tests exercise15 actual Windows lifetimes: four numeric address forms, two localhost residue profiles, callback replacement followed by CRC failure, six host/port error cases and two Drop paths. The rebuilt client probe uses the normal Application attachment, configures numeric IPv4, observes native zero-UID code3, and releases all owned resources. The existing runtime probe also passes on the same rebuilt executable.'
 ],'limits':[
 'The normal graphical application contains the Windows base-configuration API but source stream opening8F68D0 is not connected yet. Its actual network implementation allocates2328 bytes with the224-byte prefix, a second interface, shared control and key object; that derived ownership/virtual dispatch still requires implementation. Client configuration is exercised by its dedicated diagnostic command. No replay frame delivery, replay playback, active socket traffic or full spectator feature is claimed.',
 'Packet callbacks/pool8FCC80, active host flush9007F0, peer reset8FE700 and host destruction8FD8A0 return explicit unsupported errors. These operations were not reached in real Windows tests because no host/packet producer is connected. Optional configuration callback wrappers are owned and replaced, but their members are not invoked.',
 'Real Windows startup succeeded in these profiles. Actual WSA/worker failures, pending timeout ownership, constructor OOM/custom allocators and the full parent retry/multi-owner lifecycle need further qualification. Generic native error contracts from earlier milestones remain scoped evidence.',
 'The client was rebuilt and two headless probes passed. Its graphical branch was not visually rerun or gracefully exited in this milestone.737 selected core tests passed with480 other tests filtered; no full domain or whole-game completion follows.'
 ],'next_action':next_action}
receipt['native_derived_lifetimes_prepared_not_ported']=6
receipt['resource_hashes']['data/4.20/replay_stream_derived_lifetime_probe.json']=sha(r/'data/4.20/replay_stream_derived_lifetime_probe.json')
receipt['log_hashes']['logs/replay-stream-derived-lifetime-probe.log']=sha(r/'logs/replay-stream-derived-lifetime-probe.log')
receipt['limits'].append('Six native2328-byte derived-object lifetimes are prepared in replay_stream_derived_lifetime_probe.json, covering two fills, scalar flags0/1 and shared-control alias/copy/release. This is original-source evidence for the next port; no Rust parity or derived-object production integration is claimed.')
backup=r/'docs/plan_history'/('replay-windows-configuration-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/'docs'/f'{key}.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d[key]=receipt;d['updated_utc']=now.isoformat();d['next_action']=next_action;write(p,d);assert load(p)[key]==receipt
section='<section id="'+marker+'"><h2>Replay : configuration sous Windows</h2><p>La configuration Rust utilise maintenant les fonctions Windows réelles et possède ses callbacks, verrous et ressources réseau. Quinze parcours de configuration et fermeture vérifiés ; 737 tests moteur ciblés réussis. Le client reconstruit passe les diagnostics de configuration et de nettoyage. Le raccordement de l’ouverture des flux et la lecture effective des replays restent à réaliser.</p></section>'
t=html_path.with_suffix('.html.tmp');t.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');t.replace(html_path)
for group in ['source_hashes','resource_hashes','log_hashes']:
 for name,h in receipt[group].items():assert sha(r/name)==h,name
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert load(r/'docs'/name)['next_action']==next_action
assert sha(r/'target/debug/openleague-client.exe')==receipt['client_executable_sha256']
print(json.dumps({'passed':True,'core_tests':737,'windows_configuration_lifetimes':15,'client_sha256':receipt['client_executable_sha256'],'scope':scope,'receipt':str(r/'docs'/f'{key}.json')}))

