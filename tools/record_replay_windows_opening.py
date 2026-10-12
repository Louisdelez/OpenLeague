from pathlib import Path
import datetime,hashlib,json,re,shutil,struct
import pefile
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def write(p,v):
 q=p.with_suffix(p.suffix+'.tmp');q.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');assert load(q)==v;q.replace(p)
core=r/'logs/core-replay-opening-tests.log';build=r/'logs/client-replay-opening-build.log';core_log=core.read_text(encoding='utf-8-sig')
assert '747 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in core_log
names=['audio_replay_copy_assignment_matches576_native_publication_reference_and_mutating_disposal_cases','audio_replay_opening_matches24_native_full_stream_implementation_key_manager_state_and_cleanup_lifetimes','audio_replay_windows_opening_success_owns_two_shared_manager_references_and_retains_global_network_lifetime_after_stream_close','audio_replay_windows_opening_failure_keeps_native_state1_manager_ownership_and_virtual_close_releases_the_key','audio_replay_windows_opening_application_drop_retires_stream_manager_transport_logger_and_crt_owners']
for n in names:assert n+' ... ok' in core_log,n
assert re.search(r'Finished `dev` profile .* target',build.read_text(encoding='utf-8-sig'))
paths=[r/'logs'/n for n in ['client-replay-opening-probe.json','client-replay-opening-transport-regression.json','client-replay-opening-base-regression.json','client-replay-opening-runtime-regression.json']]
probe,derived,base,runtime=map(load,paths)
assert probe['normal_application_attachment'] and probe['source_stream_opening'] and not probe['optional_recording_resource_connected'] and not probe['service_manager_callback_connected'] and not probe['replay_frame_delivery']
assert len(probe['profiles'])==3
for row,(mode,code)in zip(probe['profiles'],[(0,0),(0,3),(1,0)]):
 assert row['mode']==mode and row['native_code']==code
 assert row['before']['transport']['stream'] is None and row['before']['workers_created']==0
 t=row['opened']['transport'];c=t['stream'];assert c['return_code']==code and c['state_id']==(3 if code==0 else 1)
 assert c['manager']==c['implementation_manager'] and c['manager'][0]!=0 and c['manager_references']==2
 assert t['configuration'] is None
 if mode==0:assert (c['key_pointer']!=0)==(code==0)
 else:assert c['key_pointer'] is None
 refs=1 if mode==0 and code==0 else 0
 assert t['references']==t['winsock_references']==t['timer_references']==refs
 c=row['stream_closed']['transport'];assert c['stream'] is None and c['references']==c['winsock_references']==c['timer_references']==refs
 assert c['engine_allocations']==(1 if mode==0 else 0)
 assert c['errors']==[]
assert derived['normal_application_attachment'] and derived['native_derived_transport_configuration'] and not derived['replay_frame_delivery']
assert [p['native_code'] for p in derived['profiles']]==[0,3]
assert base['normal_application_attachment'] and base['native_transport_configuration'] and base['native_success_code']==0 and base['native_failure_code']==3 and not base['replay_frame_delivery']
assert runtime['normal_application_attachment'] and not runtime['replay_frame_delivery'] and runtime['live_service_allocations_after_close']==0
closed=[(p['closed'],1 if p['mode']==0 else 0)for p in probe['profiles']]+[(p['closed'],1)for p in derived['profiles']]+[(base['closed'],1),(runtime['closed'],1)]
assert sum(n for _,n in closed)==6
for d,n in closed:
 assert d['closed'] and d['transport'] is None and d['workers_created']==d['workers_closed']==n
 assert d['worker_failures']==[] and d['handle_failures']==0 and d['crt']['slot_index']==0xffffffff
 for k in ['heap_blocks','retained_mirrors','critical_sections','heap_failures','lock_failures']:assert d['crt'][k]==0,k
 assert d['crt']['heap_allocations']==d['crt']['heap_frees']==n+1
for p in paths:assert p.with_suffix('.stderr.log').read_text(encoding='utf-8-sig')=='',p
native='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
manifest=load(r/'data/4.20/runtime/replay_runtime_image_manifest.json');assert manifest['native_sha256']==native and sha(Path(manifest['native_source']))==native
data=(r/'data/4.20/runtime/replay_runtime_image.bin').read_bytes();assert len(data)==manifest['package_bytes']==14560 and hashlib.sha256(data).hexdigest()==manifest['package_sha256'] and len(manifest['regions'])==20
pe=pefile.PE(str(manifest['native_source']));mapped=pe.get_memory_mapped_image();mapped+=bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped));assert pe.OPTIONAL_HEADER.ImageBase==manifest['image_base']
assert data[:8]==b'OL420RT\0' and struct.unpack_from('<II',data,8)==(1,20) and data[16:48].hex()==native
for v in manifest['regions']:
 o=v['payload_offset'];raw=data[o:o+v['size']];a=v['address']-manifest['image_base'];assert struct.unpack_from('<III',data,o-12)==(v['group'],v['address'],v['size']);assert raw==mapped[a:a+v['size']] and hashlib.sha256(raw).hexdigest()==v['sha256'],v['name']
for name,n in [('replay_pair_copy_assignment_probe.json',576),('replay_stream_opening_profiles_probe.json',24)]:
 p=load(r/'data/4.20'/name);assert p['passed'] and p['native_sha256']==native and len(p['cases'])==n
prepared=load(s/'replay_recording_resource_probe.json');assert prepared['passed'] and prepared['native_sha256']==native and len(prepared['cases'])==16
retired=load(s/'replay_recording_resource_reads_probe.json');assert retired['passed'] and retired['native_sha256']==native and len(retired['cases'])==16
assert sum(bool(c['retired_resource_reads'])for c in retired['cases'])==4
assert {(v['pc'],v['bytes'])for c in retired['cases']for v in c['retired_resource_reads']}=={(0x8f8ed5,1)}
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks'])for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements'])for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
key='replay_windows_opening_validation';marker='replay-windows-opening-validation';html_path=r/'docs/completion_plan.html';html=html_path.read_text(encoding='utf-8');assert '</body>' in html and 'id="'+marker+'"' not in html
assert not(r/'docs'/f'{key}.json').exists()
for name in['coverage.json','resume_checkpoint.json','completion_plan.json']:assert key not in load(r/'docs'/name)
for source,target in [('probe_replay_recording_resource.py','tools/probe_replay_recording_resource.py'),('replay_recording_resource_probe.json','data/4.20/replay_recording_resource_probe.json'),('replay-recording-resource-probe.log','logs/replay-recording-resource-probe.log')]:
 if(r/target).exists():assert sha(s/source)==sha(r/target)
 else:shutil.copy2(s/source,r/target)
for source,target in [('probe_replay_recording_resource_reads.py','tools/probe_replay_recording_resource_reads.py'),('replay_recording_resource_reads_probe.json','data/4.20/replay_recording_resource_reads_probe.json'),('replay-recording-resource-reads-probe.log','logs/replay-recording-resource-reads-probe.log')]:
 if(r/target).exists():assert sha(s/source)==sha(r/target)
 else:shutil.copy2(s/source,r/target)
shutil.copy2(s/'record_replay_windows_opening.py',r/'tools/record_replay_windows_opening.py')
now=datetime.datetime.now(datetime.timezone.utc)
next_action='Connect the actual replay game manager728E20/728FD0/728EE0, callback bundle and metadata727DE0 to the normal configured service/client using the canonical Windows bank. Native8F68D0 opening (recording disabled) is now a Rust composition matching24 full original lifetimes;5BD470 copy assignment matches576 reference/publication/mutating-disposal profiles. Runtime::open_stream constructs/owns source stream120, actual2328-byte derived or16-byte no-op implementation, aliased shared control and48-byte dual-tree manager in the same bank.8F65B0/8F6600 attach a second shared manager reference; source errors2/3 still construct/attach manager and remain state1, success transitions to state3. Native stream destruction releases stream/implementation/manager but intentionally leaves any successful global transport reference until Runtime/Application shutdown.16 new Windows lifetimes with10 actual workers and747 selected core tests pass; rebuilt client opening probe and three transport regressions pass with6 workers. Production resource now has20 original PE data regions14560bytes, byte-compared with source. The normal application owns this opening API, exercised by dedicated command; NativeReplayService still has separate configuration storage and does not invoke the parent game manager, real stream request, packet callback members or frame delivery. Do not splice raw pointers from its separate0x34000000 bank into the0x39000000 runtime; migrate/combine actual ownership and share configuration access. Finish8FB650 optional recording preparation: new replay_recording_resource_probe.json contains16 original whole opening/destruction profiles with low-byte recording flags0/1/256/257 and null file path; actual8F8E10 resource construction registers logger callback8F8ED0 via8F9380, close8F8F90 and control901630 lifecycle run to allocation baseline. Port/qualify these resource/logger ownership paths, non-null filename8F8F10 and actual CRT file I/O before allowing recording. Generic opening returns an explicit boundary error if recording requested; Windows API currently uses recording0. Existing parent initialization fixture has two complete32-allocation lifetimes to port. Qualify source callbacks/factories733540/7335C0/733640/7336C0/733740 and729A50/729AE0, metadata containers727DE0, then actual manager open/start/stop and service734130/72C780 event delivery. One-shot Windows opening rejects parent reuse instead of faking status2/reference0 readiness; generic source state gate preserves no-op return0 outside state1. Packet pool8FCB90/8FCC80, active hosts9007F0/8FE700/8FD8A0, encryption/chaining/frame parsers and auxiliary resource teardown remain explicit dependencies. Qualify actual startup failures, active worker/timeouts/OOM/custom allocators and graphical graceful exit; continue all24domains114tasks37requirements with maps/champions/gameplay/launcher fidelity unchanged in scope.'
next_action+=' Recording qualification found a caller-order hazard: the supplied sequence destroys a merely opened state3 stream then manually calls global8FC500;4 of16 instrumented profiles read the already-freed40-byte resource at8F8ED5. Allocation baseline alone does not prove lifetime validity. This is not evidence that the complete original game uses that order. Qualify actual start8F6AF0 (state3 to4 via8FB780 and implementation methods) and stop8F6BC0 before enabling recording; its secondary-interface thunk901C44 subtractsE0 then jumps8F6FA0, closing the key/global reference while the recording resource is still alive. Preserve or establish the real parent stop-before-destroy order. Logger registration8F9380 builds a composite via9014F0/9016C0 and vtable10D5F64 (delete901860, clone901750, invoke901840), which invokes both children; do not replace it by a single callback. Native file modes at10D4BF0/10D4BEC are wc/ac, and8F8ED0 writes format%s.'
test_exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',core_log)[1].replace('\\','/')
sources=['crates/core/src/'+n for n in ['audio_replay_opening.rs','audio_replay_opening_tests.rs','audio_replay_shared_pair.rs','audio_replay_pair_move_tests.rs','audio_replay_stream_transport_tests.rs','audio_replay_transport_configuration_tests.rs','audio_replay_windows_opening.rs','audio_replay_windows_opening_tests.rs','audio_replay_windows_transport.rs','audio_replay_windows_configuration.rs','audio_replay_windows_application.rs','audio_replay_runtime_image.rs','audio_replay_stream.rs','audio_replay_stream_transport.rs','lib.rs']]+['crates/client/src/main.rs','crates/client/src/native_replay_service.rs']+['tools/'+n for n in ['prepare_replay_opening.py','prepare_replay_windows_opening.py','prepare_replay_opening_client.py','install_replay_opening.py','extract_replay_runtime_image.py','extract_replay_opening_tables.py','probe_replay_recording_resource.py','record_replay_windows_opening.py']]
resources=['data/4.20/runtime/replay_runtime_image.bin','data/4.20/runtime/replay_runtime_image_manifest.json']+['data/4.20/'+n for n in ['replay_opening_tables.json','replay_pair_copy_assignment_probe.json','replay_stream_opening_profiles_probe.json','replay_recording_resource_probe.json']]
logs=[core,build]+paths+[p.with_suffix('.stderr.log')for p in paths]+[r/'logs'/n for n in ['replay-opening-compile.log','replay-opening-tests.log','replay-recording-resource-probe.log']]
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_source_sha256':native,'core_audio_tests_passed':747,'core_tests_filtered_not_run':480,'new_tests_passed':5,'native_opening_lifetimes':24,'native_copy_assignments':576,'windows_opening_lifetimes':16,'windows_opening_workers':10,'production_initial_regions':20,'production_initial_bytes':14560,'rebuilt_client_commands':4,'rebuilt_client_workers':6,'prepared_recording_lifetimes_not_ported':16,'client_executable':str(r/'target/debug/openleague-client.exe'),'client_executable_sha256':sha(r/'target/debug/openleague-client.exe'),'core_test_executable':str(test_exe),'core_test_executable_sha256':sha(test_exe),'source_hashes':{n:sha(r/n)for n in sources},'resource_hashes':{n:sha(r/n)for n in resources},'log_hashes':{str(p.relative_to(r)):sha(p)for p in logs},'client_opening_probe':probe,'client_derived_regression':derived,'client_base_regression':base,'client_runtime_regression':runtime,'behavior':[
 'Native5BD470 is distinct from5CC070: capture source/increment its control, publish destination control/object, then dispose the former control.576 cases match original counter wrapping, self-assignment and disposal callbacks mutating source/destination.',
 'Native8F68D0 selects actual derived2328 or no-op16 implementation according to the low mode byte, clones/configures the callback, constructs/wraps/moves the dual-tree object manager even for configuration failure, copies/consumes its argument through8F65B0/8F6600 and dispatches state event0 only for result0.24 complete lifetimes match all scoped allocations, memory words and frees against original functions; the generic test supplies the separately qualified startup-worker boundary.',
 'Runtime now owns the stream and composes source opening inside the same canonical bank as transport, shared controls, manager, real critical sections and Windows worker/logger/network. Successful startup reaches state3, failures2/3 retain state1 with an attached manager, and the manager has two strong owners. Standalone configuration and independent release are rejected while the stream owns the lifetime.',
 'Stream close destroys its source objects and shared references while retaining the separately owned successful global network reference. Final Runtime/Application close then releases network/timer, logger, worker controls, CRT heap/FLS and physical locks.16 real Windows lifetimes cover6 successful mode/callback variants,6 error/callback cases and4 Drop cases; mode257 confirms low-byte selection.',
 'The rebuilt normal-attachment client probe exercises derived success, CRC failure and no-op success, closes the stream, verifies retained global state, then fully closes application resources. Existing derived/base/runtime probes also pass on this same binary.'
 ],'limits':[
 'The normal app contains the source opening API and diagnostic command, but configured NativeReplayService is not yet connected through the actual parent game-manager lifecycle and callbacks. Its separate bank cannot be treated as canonical runtime ownership. No frame delivery, replay playback, socket traffic, spectator completion or complete game is claimed.',
 'Optional8FB650 recording/file preparation is an explicit unsupported boundary; the Windows opening API currently supplies recording0. Sixteen new native recording-resource profiles with null file path are prepared for the next port. Filename open, CRT file writes and logger-resource callback ownership remain to integrate.',
 'Generic opening preserves the source state gate, while the owning Windows API currently rejects repeated attempts pending parent reopen/retry ownership. No source status reset or invented reference is used. OOM/constructor rollback, custom allocators, actual worker failures/timeouts and additional shared owners need qualification.',
 'Packet callbacks, active host operations, packet allocation/pool, crypto/chaining and parser/producer/consumer paths remain unavailable dependencies. The no-op implementation intentionally does not start a network worker and must not be described as replay playback.',
 '747 selected core tests passed with480 filtered; no full-suite, graphical launch/graceful-exit or human fidelity acceptance was performed. No domain or whole-game completion follows.'
 ],'next_action':next_action}
receipt['prepared_recording_manual_close_order_retired_read_cases']=4
receipt['source_hashes']['tools/probe_replay_recording_resource_reads.py']=sha(r/'tools/probe_replay_recording_resource_reads.py')
receipt['resource_hashes']['data/4.20/replay_recording_resource_reads_probe.json']=sha(r/'data/4.20/replay_recording_resource_reads_probe.json')
receipt['log_hashes']['logs/replay-recording-resource-reads-probe.log']=sha(r/'logs/replay-recording-resource-reads-probe.log')
receipt['limits'].append('Recording-source allocation checks restore baseline, but an additional memory-read probe finds4 retired-resource reads at8F8ED5 in the supplied partial lifecycle: destroy a state3 stream then manually release its global transport. The complete native parent lifecycle is not exercised by that order. Recording stays unavailable in production; qualify start/state4 stop and its901C44-to8F6FA0 close before adding recording. The currently integrated recording0 profiles do not have this resource/callback hazard.')
backup=r/'docs/plan_history'/('replay-windows-opening-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/'docs'/f'{key}.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d[key]=receipt;d['updated_utc']=now.isoformat();d['next_action']=next_action;write(p,d);assert load(p)[key]==receipt
section='<section id="'+marker+'"><h2>Replay : ouverture et possession des flux</h2><p>L’ouverture initiale possède maintenant le flux, son transport et le gestionnaire d’objets dans le même moteur. Seize parcours Windows vérifiés ; 747 tests moteur ciblés réussis. Le client reconstruit passe les diagnostics d’ouverture et de fermeture. Le raccordement au gestionnaire principal, les fichiers et la lecture des trames restent à réaliser.</p></section>'
q=html_path.with_suffix('.html.tmp');q.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');q.replace(html_path)
for group in ['source_hashes','resource_hashes','log_hashes']:
 for name,h in receipt[group].items():assert sha(r/name)==h,name
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert load(r/'docs'/name)['next_action']==next_action
assert sha(r/'target/debug/openleague-client.exe')==receipt['client_executable_sha256']
print(json.dumps({'passed':True,'core_tests':747,'windows_lifetimes':16,'client_workers':6,'client_sha256':receipt['client_executable_sha256'],'scope':scope,'receipt':str(r/'docs'/f'{key}.json')}))
