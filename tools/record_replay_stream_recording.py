from pathlib import Path
import datetime,hashlib,json,re,shutil
import pefile
r=Path('E:/OpenLeague')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 with p.open('rb')as f:return hashlib.file_digest(f,'sha256').hexdigest()
def write(p,d):
 q=p.with_suffix(p.suffix+'.tmp');q.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');assert load(q)==d;q.replace(p)
native='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
core=r/'logs/core-replay-stream-recording-tests.log';build=r/'logs/client-replay-stream-recording-build.log';log=core.read_text(encoding='utf-8-sig')
assert '761 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in log
for name in ['audio_replay_recording_preparation_matches48_native_flags_path_file_failure_and_shared_resource_lifetimes','audio_replay_path_registry_matches20_native_active_registration_lifetimes','audio_replay_path_registry_default_constructor_matches4_full_native_opening_lifetimes','audio_replay_path_registry_matches34_native_gate_capacity_rotation_casefold_and_sparse_constructor_lifetimes','audio_replay_windows_recorded_stream_prepares_starts_stops_and_retires_actual_file_worker_registry_lifetimes']:
 assert name+' ... ok' in log,name
assert re.search(r'Finished `dev` profile .* target',build.read_text(encoding='utf-8-sig'))
native_fixtures=[('replay_recording_preparation_probe.json',48),('replay_parent_open_lifetime_probe.json',16),('replay_path_registry_probe.json',20),('replay_path_registry_edges_probe.json',34),('replay_recording_path_registration_probe.json',4)]
for name,count in native_fixtures:
 d=load(r/'data/4.20'/name);assert d['passed'] and d['native_sha256']==native and len(d['cases'])==count
assert sum(len(c['steps'])for name in ['replay_path_registry_probe.json','replay_path_registry_edges_probe.json']for c in load(r/'data/4.20'/name)['cases'])==234
parent=load(r/'data/4.20/replay_parent_open_lifetime_probe.json')
assert all(not c['retired_reads'] for c in parent['cases'])
names=['probe','file-regression','running-regression','opening-regression','transport-regression','base-regression','runtime-regression']
paths=[r/'logs'/('client-replay-stream-recording-'+n+'.json')for n in names]
probes=list(map(load,paths));probe=probes[0]
commands=load(r/'logs/client-replay-stream-recording-command-run.json')
assert len(commands['commands'])==7 and commands['sha256']==sha(r/'target/debug/openleague-client.exe')
assert all(c['exit_code']==0 and c['sha256']==commands['sha256'] for c in commands['commands'])
for k in ['normal_application_attachment','source_optional_stream_preparation','source_noop_implementation','pathname_registration_singleton']:assert probe[k]
for k in ['active_network_host','replay_frame_serialization','service_manager_connected']:assert not probe[k]
assert len(probe['profiles'])==3;disk=[]
for row in probe['profiles']:
 f=row['report'];profile=row['profile'];yes=profile==1
 assert [f[k]for k in ['open_code','start_code','state_after_start','state_after_stop']]==[0,0,4,3]
 assert f['resource_enabled']==int(yes) and f['resource_references']==1 and f['registry_initialized']==(profile!=0)
 assert f['files_opened']==f['files_closed']==(2 if yes else 0) and f['remaining_files']==0
 path=Path(row['path']);assert path.is_relative_to(r/'logs')
 if yes:
  data=path.read_bytes();assert data.decode('utf-8')==row['content']
  assert data.count(b'LogOut_File: : logfile started\r\n')==1 and data.endswith(b'LogOut_File: : logfile stopped\r\n')
  for part in [b'OpenLeague stream diagnostic %n %s\r\n',b'Source optional preparation and worker lifetime\r\n']:assert part in data
  assert f['writes']==data.count(b'\r\n')
  disk.append({'path':str(path),'sha256':sha(path),'bytes':len(data),'lines':data.count(b'\r\n')})
 else:
  assert f['writes']==0
  if profile==2:assert not path.exists() and not path.parent.exists()
workers=0
for d in probes:
 for row in d.get('profiles',[d]):
  c=row['closed'];assert c['closed'] and c['transport'] is None and c['worker_failures']==[] and c['handle_failures']==0
  assert c['workers_created']==c['workers_closed'];workers+=c['workers_created']
  assert c['crt']['heap_allocations']==c['crt']['heap_frees']
  for k in ['heap_blocks','retained_mirrors','critical_sections','heap_failures','lock_failures']:assert c['crt'][k]==0
assert workers==11
for p in paths:assert not p.with_suffix('.stderr.log').read_text(encoding='utf-8-sig').strip()
manifest=load(r/'data/4.20/runtime/replay_runtime_image_manifest.json');package=(r/'data/4.20/runtime/replay_runtime_image.bin').read_bytes()
assert manifest['native_sha256']==native and manifest['package_sha256']==hashlib.sha256(package).hexdigest() and len(package)==18928 and len(manifest['regions'])==24
source=Path(manifest['native_source']);assert sha(source)==native;pe=pefile.PE(str(source));mapped=pe.get_memory_mapped_image();image=mapped+bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped))
for x in manifest['regions']:
 a=x['address']-pe.OPTIONAL_HEADER.ImageBase;n=x['size'];o=x['payload_offset'];assert package[o:o+n]==image[a:a+n]
now=datetime.datetime.now(datetime.timezone.utc);key='replay_stream_recording_validation';receipt_path='docs/'+key+'.json'
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks'])for d in plan['domains']),'additional_requirements':sum(len(d.get('additional_requirements',[]))for d in plan['domains'])};assert list(scope.values())==[24,114,37]
test_exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',log)[1].replace('\\','/')
next_action='Connect source parent replay manager and service ownership inside the canonical Windows bank:728E20/728FD0/728EE0, metadata512-byte derived object727DE0 plus10B00C4/string+1E8, callback bundle20 and factories733540/7335C0/733640/7336C0/733740/7337C0/733840. New parent7297E0 native oracle has16 complete lifetimes with actual parent/metadata/callback, allocation baseline and zero retired-resource reads in the tested parent-destruction followed by immediate logger-shutdown sequence. It clones parent+40 or builds7337C0->729370, invokes8F68D0 with literal port0 and immediately starts8F6AF0 after return0. Parent initialization service72A780 invokes72A800 first. Port this exact composition rather than splicing separate NativeReplayService0x34000000 pointers into Runtime0x39000000. Optional8FB650 recording preparation is now ported:40-byte LogOut_File, control1085F8C/901630/5D1620, move8C3480, logger readiness586220, optional file open and pathname registry8C59F0/8C5E90;48 original cases qualify flags0/1/256/257, null/non-null path and three file-open outcomes. The filename is registered even when open returns0; preparation success does not mean file enabled. Path registry8C5A50/8C8000/8C5D10/8C5DC0/8C5E50/8C5BB0 now matches58 native lifetimes including default, active registration,234 new calls, capacity boundary, hash/case behavior, signed wrap and native long-path padding. Production initial image24regions18928bytes is independently byte-compared with source. Real Windows no-op diagnostic stream qualification composes preparation, actual worker start/stop, disk writes, resource close/control release, immediate logger retirement and final singleton cleanup;4 Windows lifetimes and3 rebuilt-client profiles pass.761 selected core tests and7 final-client commands pass with11 workers. Runtime::open_stream still supplies recording0; optional recording is reached by a diagnostic no-op stream entry, not normal service gameplay. Full frame recording/playback is not implemented by this text journal. Retain safe source stop-before-destroy order and prohibit emitting through logger callbacks after resource release; parent reuse and game-wide atexit order remain unqualified. Derived active host8FD6A0/8F7060/8F75D0/8F7920, packet pool8FCB90/8FCC80, crypto/chaining/parser/producer/consumer, real callback729370 delivery and service frames remain dependencies. Qualify constructor rollback/OOM/custom allocators, worker failures/timeouts, active crash-report shutdown and graphical exit. Continue all24domains114tasks37requirements, including maps/champions/gameplay/launcher and final delivery; no domain is complete.'
sources=['crates/core/src/'+n for n in ['audio_replay_recording_resource.rs','audio_replay_recording_resource_tests.rs','audio_replay_path_registry.rs','audio_replay_path_registry_tests.rs','audio_replay_windows_opening.rs','audio_replay_windows_recording.rs','audio_replay_windows_recording_tests.rs','audio_replay_windows_transport.rs','audio_replay_runtime_image.rs','lib.rs']]+['crates/client/src/main.rs','docs/replay_parent_order_report.md']+['tools/'+n for n in ['probe_parent_order.py','probe_recording_preparation.py','probe_replay_path_registry.py','probe_replay_path_registry_edges.py','extract_replay_path_registry_tables.py','extract_replay_runtime_image.py','record_replay_stream_recording.py']]
resources=['data/4.20/'+name for name,_ in native_fixtures]+['data/4.20/replay_path_registry_tables.json','data/4.20/runtime/replay_runtime_image.bin','data/4.20/runtime/replay_runtime_image_manifest.json']
logs=[core,build,r/'logs/replay-preparation-tests.log',r/'logs/replay-path-registry-tests.log',r/'logs/replay-parent-order-probe.log']+paths+[p.with_suffix('.stderr.log')for p in paths]
logs.append(r/'logs/client-replay-stream-recording-command-run.json')
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_source_sha256':native,'core_tests_passed':761,'core_tests_filtered':480,'new_tests_passed':5,'native_preparation_lifetimes':48,'native_registry_lifetimes':58,'native_registry_new_calls':234,'prepared_native_parent_lifetimes':16,'prepared_parent_retired_resource_reads':0,'new_windows_stream_recording_lifetimes':4,'new_windows_workers':4,'client_commands':7,'client_workers':workers,'production_initial_regions':24,'production_initial_bytes':18928,'disk_outputs':disk,'client_executable':str(r/'target/debug/openleague-client.exe'),'client_executable_sha256':sha(r/'target/debug/openleague-client.exe'),'core_test_executable':str(test_exe),'core_test_executable_sha256':sha(test_exe),'source_hashes':{n:sha(r/n)for n in sources},'resource_hashes':{n:sha(r/n)for n in resources},'log_hashes':{str(p.relative_to(r)):sha(p)for p in logs},'client_stream_recording_probe':probe,'behavior':['Optional source preparation creates a shared40-byte diagnostic resource, constructs its recursive logger callback chain and moves the actual16-byte native control into stream+30. Preparation returns source logger-ready even when fopen fails; register_path still runs for nonnull path.','Diagnostic path singleton preserves selected-field initialization and original sentinel/tree/hash, signed counter wrap,512KiB capacity and fixed256-byte path rows including the native long-path padding behavior. Shutdown releases its actual tree; active crash-report service remains explicitly unavailable.','Windows source no-op stream is opened, started on a real engine/CRT worker, stopped/joined, destroyed and followed immediately by logger retirement under one launch lock. File-disabled, valid, missing-parent and empty-path profiles close handles and allocations.','Normal-client attachment exercises this dedicated probe on the same canonical runtime with actual disk output, preserving literal percent text and source timestamps. Singleton cleanup occurs at final application shutdown.'], 'limits':['Diagnostic text resource and dedicated no-op stream probe only. Normal configured service remains disconnected from parent manager, metadata and replay frame delivery. No actual replay serialization/playback, active network host, six-client graphical match or whole-game completion is claimed.','Native parent16-lifetime fixture is prepared evidence, not a Rust parent port. Derived host is explicitly supplied failure0; native worker runs at join after the stop flag in that oracle. Game-wide atexit order and repeated sessions are not qualified.','Windows open_stream still disables recording. Recorded qualification owns and immediately retires the logger chain after source resource destruction; do not allow later emissions through raw freed resource pointers.','Path registration active data structure is qualified with supplied buffer/gates; actual crash-report activation/OS service and close8C8C10/8C8D30 are not implemented. Custom callback/destructor, custom deallocation, OOM and constructor rollback remain boundaries.','Windows stdio uses installed msvcrt.dll; original CRT primitives are supplied in the native oracle. Four Windows lifetimes and seven final-client commands are targeted checks, not full test-suite, graphical/audio/fidelity acceptance.'],'next_action':next_action}
backup=r/'docs/plan_history'/('replay-stream-recording-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/receipt_path,receipt)
summary={k:receipt[k]for k in ['saved_utc','passed','complete','core_tests_passed','core_tests_filtered','native_preparation_lifetimes','native_registry_lifetimes','prepared_native_parent_lifetimes','new_windows_stream_recording_lifetimes','client_commands','client_workers','client_executable_sha256']};summary['receipt']=receipt_path
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d[key]=summary;d['updated_utc']=now.isoformat();d['next_action']=next_action
 if name=='resume_checkpoint.json':
  d['state']='active';d['saved_utc']=now.isoformat();d.setdefault('last_verified',{})['replay_stream_recording_audio_selected_core_tests']=761;d['last_verified']['replay_stream_recording_receipt']=receipt_path
 if name=='completion_plan.json':
  domain=next(x for x in d['domains']if x['id']=='21')
  if isinstance(domain.get('progress_evidence'),list)and receipt_path not in domain['progress_evidence']:domain['progress_evidence'].append(receipt_path)
  for task in domain['tasks']:
   if task['id']in ['21.3','21.4']and receipt_path not in task['evidence']:task['evidence'].append(receipt_path)
  d['next_execution_steps'][0]=next_action
 write(p,d)
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');marker='replay-stream-recording-validation';assert marker not in text and '</body>'in text
section='<section id="'+marker+'"><h2>Replay : préparation du journal et durée de vie du flux</h2><p>La préparation optionnelle et le registre natif des chemins sont portés. Le flux diagnostic est ouvert, démarré sur un thread Windows réel, arrêté et libéré avec son journal. 761 tests moteur ciblés et sept contrôles du client reconstruit passent. Le gestionnaire principal, le réseau actif et les trames de partie restent à intégrer.</p></section>'
html.write_text(text.replace('</body>',section+'</body>'),encoding='utf-8')
for group in ['source_hashes','resource_hashes','log_hashes']:
 for name,h in receipt[group].items():assert sha(r/name)==h,name
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert load(r/'docs'/name)['next_action']==next_action
print(json.dumps({'passed':True,'core_tests':761,'client_commands':7,'client_workers':11,'disk_outputs':disk,'scope':scope,'receipt':str(r/receipt_path),'client_sha256':receipt['client_executable_sha256']}))
