from pathlib import Path
import datetime,hashlib,json,re,shutil,struct
import pefile
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def write(p,v):
 q=p.with_suffix(p.suffix+'.tmp');q.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');assert load(q)==v;q.replace(p)
core=r/'logs/core-replay-stream-transport-tests.log';build=r/'logs/client-replay-stream-transport-build.log'
core_log=core.read_text(encoding='utf-8-sig');assert '742 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in core_log
tests=['audio_replay_key_matches22_native_complete_schedules_and88_two_word_transforms','audio_replay_stream_transport_matches6_native_full_object_scalar_and_aliased_shared_lifetimes','audio_replay_stream_transport_matches24_native_complete_key_callback_configuration_and_close_profiles','audio_replay_windows_stream_transport_owns_derived_key_callback_and_rejects_repeated_or_mixed_configuration','audio_replay_windows_stream_transport_virtual_error_close_clears_key_and_application_drop_releases_all_owners']
for name in tests:assert name+' ... ok' in core_log,name
assert re.search(r'Finished `dev` profile .* target',build.read_text(encoding='utf-8-sig'))
paths=[r/'logs/client-replay-stream-transport-probe.json',r/'logs/client-replay-stream-base-regression.json',r/'logs/client-replay-stream-runtime-regression.json']
probe,base,runtime=map(load,paths)
assert probe['normal_application_attachment'] and probe['native_derived_transport_configuration'] and not probe['source_stream_opening_connected'] and not probe['replay_frame_delivery']
assert len(probe['profiles'])==2
for row,expected in zip(probe['profiles'],[0,3]):
 assert row['native_code']==expected and row['before']['workers_created']==0 and row['before']['transport']['configuration'] is None
 t=row['configured']['transport'];c=t['configuration'];d=c['stream'];assert d['interface_pointer']==c['pointer']+0xe0 and d['flag']==255 and d['extra']==0x88776655
 assert c['callback']==[0x1086078,0x44000000,0x728e20]
 if expected==0:assert c['arguments']==[0x11223344,0x55667788]
 assert c['return_code']==expected and c['host']==c['queue_count']==0
 assert t['references']==t['winsock_references']==t['timer_references']==(1 if expected==0 else 0)
 if expected==0:assert d['key_pointer']!=0 and c['uid']==0xff2199f5 and c['requested_port']==65535
 else:assert d['key_pointer']==0 and c['uid']==0
assert base['normal_application_attachment'] and base['native_transport_configuration'] and base['native_success_code']==0 and base['native_failure_code']==3 and not base['replay_frame_delivery']
assert runtime['normal_application_attachment'] and not runtime['replay_frame_delivery'] and runtime['live_service_allocations_after_close']==0
for d in [p['closed'] for p in probe['profiles']]+[base['closed'],runtime['closed']]:
 assert d['closed'] and d['transport'] is None and d['workers_created']==d['workers_closed']==1
 assert d['worker_failures']==[] and d['handle_failures']==0 and d['crt']['slot_index']==0xffffffff
 for key in ['heap_blocks','retained_mirrors','critical_sections','heap_failures','lock_failures']:assert d['crt'][key]==0,key
 assert d['crt']['heap_allocations']==d['crt']['heap_frees']==2
native='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
manifest=load(r/'data/4.20/runtime/replay_runtime_image_manifest.json');assert manifest['native_sha256']==native and sha(Path(manifest['native_source']))==native
package=(r/'data/4.20/runtime/replay_runtime_image.bin').read_bytes();assert len(package)==manifest['package_bytes']==14384 and hashlib.sha256(package).hexdigest()==manifest['package_sha256'] and len(manifest['regions'])==15
pe=pefile.PE(str(manifest['native_source']));mapped=pe.get_memory_mapped_image();mapped+=bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped));assert pe.OPTIONAL_HEADER.ImageBase==manifest['image_base']
assert package[:8]==b'OL420RT\0' and struct.unpack_from('<II',package,8)==(1,15) and package[16:48].hex()==native
for v in manifest['regions']:
 offset=v['payload_offset'];data=package[offset:offset+v['size']];a=v['address']-manifest['image_base'];assert struct.unpack_from('<III',package,offset-12)==(v['group'],v['address'],v['size']);assert data==mapped[a:a+v['size']] and hashlib.sha256(data).hexdigest()==v['sha256'],v['name']
fixtures=['replay_key_probe.json','replay_stream_derived_configuration_probe.json','replay_stream_derived_lifetime_probe.json']
for name,count in zip(fixtures,[22,24,6]):
 p=load(r/'data/4.20'/name);assert p['passed'] and p['native_sha256']==native and len(p['cases'])==count,name
prepared=[('replay_pair_copy_assignment_probe.json','probe_replay_pair_copy_assignment.py','replay-pair-copy-assignment-probe.log',576),('replay_stream_opening_profiles_probe.json','probe_replay_stream_opening_profiles.py','replay-stream-opening-profiles-probe.log',24)]
for fixture,generator,log,count in prepared:
 p=load(s/fixture);assert p['passed'] and p['native_sha256']==native and len(p['cases'])==count
 for source,target in [(fixture,'data/4.20/'+fixture),(generator,'tools/'+generator),(log,'logs/'+log)]:
  if (r/target).exists():assert sha(r/target)==sha(s/source),target
  else:shutil.copy2(s/source,r/target)
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
key='replay_stream_transport_validation';marker='replay-stream-transport-validation';html_path=r/'docs/completion_plan.html';html=html_path.read_text(encoding='utf-8');assert '</body>' in html and 'id="'+marker+'"' not in html
assert not (r/'docs'/f'{key}.json').exists()
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert key not in load(r/'docs'/name)
shutil.copy2(s/'record_replay_stream_transport.py',r/'tools/record_replay_stream_transport.py')
now=datetime.datetime.now(datetime.timezone.utc)
next_action='Complete native source replay stream opening8F68D0 and resource preparation8FB650, composing the existing stream state machine and object manager with the newly ported actual2328-byte derived transport8F6D00/8F6EB0 and4184-byte key98F710. Runtime::configure_stream_transport now owns and configures the derived object through its+E0 interface using real Windows workers, locks, Winsock/address/clock/logger APIs; virtual error close8F6FA0 frees the key and network reference.7 new real Windows lifetimes qualify success, callbacks, repeated/mixed-kind rejection, null/CRC/DNS errors and explicit/Drop cleanup.22 original complete schedules/88 two-word transforms,24 original configuration/key/callback lifetimes and6 original derived/aliased-control lifetimes match Rust.15 production initial PE banks14384bytes include actual key seed/vtables, independently byte-compared against the pinned executable.742 selected core tests pass and rebuilt client derived/base/runtime probes pass with4 actual workers total. Source8F68D0 still must be wired: qualify8FB650 configuration/file-resource preparation,5BD470 copy assignment and alternate16-byte implementation10D5FEC; construct/wrap/move object manager8F8810/9019A0 into stream+6C then invoke interface8F65B0 and transition the existing state machine on result0. Share one canonical service/stream/transport bank and lifetimes rather than copying runtime addresses into unrelated storage. The generic9018C0 aliased shared-control port is verified, but the Windows configuration owner currently directly owns its derived allocation; parent stream/control ownership remains to integrate. Retain source-state1 one-shot configure and status2/reference0 reuse rejection, qualify parent retry/multi-owner behavior instead of changing globals or leaking replaced keys. Attach callback bundle727DE0,728E20/728FD0/728EE0 and actual replay frames; callback wrappers currently have no packet member dispatcher. Port packet pool8FCB90/8FCC80, active host9007F0/8FE700/8FD8A0 and auxiliary resource teardown before claiming active network/packet cleanup. Packet crypto/chaining/decryption are not implemented by the key schedule alone. Qualify actual WSA/worker failures, pending timeout/OOM/custom allocation paths, nondefault callbacks and normal graphical launch/graceful exit. Continue all24-domain114-task37-requirement work; no domain is completed by this milestone.'
next_action+=' New replay_pair_copy_assignment_probe.json has576 original5BD470 cases proving capture/increment, destination publication, then old-control disposal; existing5CC070 copy has a different publication order. Port the distinct helper before8F65B0/8F6600 implementation manager attachment. New replay_stream_opening_profiles_probe.json has24 complete original8F68D0 lifetimes with recording disabled and no metadata: derived success reaches state3/ref1, null/CRC-zero errors reach state1/ref0; mode1 no-op reaches state3/ref0. The object manager is constructed and attached even after configuration codes2/3. All destroy stream then explicitly retire surviving global reference/logger to baseline. These two prepared fixtures are not Rust opening/assignment parity yet.'
test_exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',core_log)[1].replace('\\','/')
sources=['crates/core/src/'+n for n in ['audio_replay_key.rs','audio_replay_stream_transport.rs','audio_replay_stream_transport_tests.rs','audio_replay_transport_configuration.rs','audio_replay_transport_configuration_tests.rs','audio_replay_windows_configuration.rs','audio_replay_windows_transport.rs','audio_replay_windows_configuration_tests.rs','audio_replay_windows_stream_transport_tests.rs','audio_replay_runtime_image.rs','audio_replay_windows_application.rs','lib.rs']]+['crates/client/src/main.rs']+['tools/'+n for n in ['prepare_replay_derived_windows.py','prepare_replay_derived_client.py','install_replay_stream_transport.py','probe_replay_key.py','probe_replay_stream_derived_configuration.py','probe_replay_stream_derived_lifetime.py','extract_replay_runtime_image.py','record_replay_stream_transport.py']]
resources=['data/4.20/runtime/replay_runtime_image.bin','data/4.20/runtime/replay_runtime_image_manifest.json']+['data/4.20/'+n for n in fixtures]
logs=[core,build]+paths+[p.with_suffix('.stderr.log') for p in paths]+[r/'logs'/n for n in ['replay-key-probe.log','replay-stream-derived-configuration-probe.log','replay-stream-derived-lifetime-probe.log','replay-stream-transport-tests.log','replay-stream-transport-compile.log']]
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_source_sha256':native,'core_audio_tests_passed':742,'core_tests_filtered_not_run':480,'new_tests_passed':5,'derived_windows_lifetimes':7,'native_key_schedules':22,'native_two_word_transforms':88,'native_derived_configurations':24,'native_derived_lifetimes':6,'production_initial_regions':15,'production_initial_bytes':14384,'client_probe_workers':4,'client_executable':str(r/'target/debug/openleague-client.exe'),'client_executable_sha256':sha(r/'target/debug/openleague-client.exe'),'core_test_executable':str(test_exe),'core_test_executable_sha256':sha(test_exe),'source_hashes':{n:sha(r/n) for n in sources},'resource_hashes':{n:sha(r/n) for n in resources},'log_hashes':{str(p.relative_to(r)):sha(p) for p in logs},'client_derived_probe':probe,'client_base_regression':base,'client_runtime_regression':runtime,'behavior':[
 'Native98F710 derives the complete4184-byte key from the actual4168 initial-table bytes. Positive key length clamp56, byte order, duplicated IV, P/S regeneration and98F890 two-word transform match22 original schedules and88 block transforms. Production seed data is extracted from the pinned PE, not loaded from test JSON.',
 'Native8F6D00 constructs the actual2328-byte network implementation with its224-byte base and secondary interface+E0.8F6EB0 creates the key from16 bytes and zero IV, clones/transfers callbacks and delegates to8FC610. Full key/object/callback allocations and frees match24 original profiles including source WSA startup errors and two storage fills.',
 'Close8F6FA0 releases and clears the key, flushes/destroys any supplied host through explicit boundaries, releases the transport reference and clears+C. Destructor/scalar delete8F6DD0/8F6D90 and9018C0 shared controls retain the true base while exposing base+E0. Six original lifetime profiles verify derived dispatch, storage and aliased ownership.',
 'The Windows Runtime now owns the derived implementation and calls real worker/Winsock/address/mutex/logger boundaries. Existing base API stays supported. Derived repeated configuration and switching implementation kinds are rejected before mutation; the source parent permits opening only from state1. Errors still leave an owned object for ordered destruction.',
 'Two new Windows tests cover7 real lifetimes: two successful profiles with/without callback, three virtual error-close cases and two application Drop cases. All key/callback/proxy/object/network/CRT/physical-lock resources retire. The rebuilt client uses normal Application attachment for derived success/error in separate lifetimes; base and runtime regression commands also pass.'
 ],'limits':[
 'This integrates the derived configuration API into the Windows runtime and rebuilt client diagnostic path. Source stream opening8F68D0,8FB650 resources, alternate implementation and parent/shared-control wiring are not connected yet. No replay frames, playback, active sockets or spectator feature completion are claimed.',
 'Key schedule and two-word transform are qualified; packet encryption/decryption, chaining mode and actual traffic are not. Empty source keys read unwritten native stack storage; the Rust generic API explicitly rejects empty keys, and the actual derived caller always supplies16 bytes.',
 'Auxiliary resource scalar deletion, packet callbacks/pool and active host flush/reset/destruction remain explicit unavailable boundaries. Real tests create no host and invoke no callback members. Native WSA failure profiles are supplied emulator boundaries; actual Windows worker/network failure, timeouts, OOM/custom allocators and parent retry/multi-owner integration remain to qualify.',
 '742 selected core tests passed with480 other tests filtered. New client binaries passed three diagnostic commands with4 real workers, but no graphical launch/graceful-exit or full-game acceptance was performed. All24domains114tasks37requirements remain in scope.'
 ],'next_action':next_action}
receipt['prepared_native_copy_assignment_cases_not_ported']=576
receipt['prepared_native_stream_opening_cases_not_ported']=24
for fixture,generator,log,count in prepared:
 receipt['source_hashes']['tools/'+generator]=sha(r/'tools'/generator)
 receipt['resource_hashes']['data/4.20/'+fixture]=sha(r/'data/4.20'/fixture)
 receipt['log_hashes']['logs/'+log]=sha(r/'logs'/log)
receipt['limits'].append('Prepared next-step fixtures qualify576 source copy assignments and24 complete source stream-opening lifetimes in the emulator. Their Rust ports and normal-client opening integration are not delivered by this milestone.')
backup=r/'docs/plan_history'/('replay-stream-transport-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/'docs'/f'{key}.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d[key]=receipt;d['updated_utc']=now.isoformat();d['next_action']=next_action;write(p,d);assert load(p)[key]==receipt
section='<section id="'+marker+'"><h2>Replay : clés et transport des flux</h2><p>Le transport possède désormais sa clé et ses callbacks, avec fermeture native en cas d’erreur. Comparaisons complètes avec les structures d’origine et sept parcours Windows vérifiés ; 742 tests moteur ciblés réussis. Le client reconstruit passe ses contrôles de configuration et nettoyage. L’ouverture complète des flux, leurs ressources et la lecture restent à raccorder.</p></section>'
q=html_path.with_suffix('.html.tmp');q.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');q.replace(html_path)
for group in ['source_hashes','resource_hashes','log_hashes']:
 for name,h in receipt[group].items():assert sha(r/name)==h,name
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert load(r/'docs'/name)['next_action']==next_action
assert sha(r/'target/debug/openleague-client.exe')==receipt['client_executable_sha256']
print(json.dumps({'passed':True,'core_tests':742,'derived_windows_lifetimes':7,'client_sha256':receipt['client_executable_sha256'],'scope':scope,'receipt':str(r/'docs'/f'{key}.json')}))
