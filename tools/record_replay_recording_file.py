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
core=r/'logs/core-replay-recording-tests.log';build=r/'logs/client-replay-recording-build.log';log=core.read_text(encoding='utf-8-sig')
assert '756 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in log
for name in ['audio_replay_logger_composite_matches28_native_recursive_append_clone_both_callbacks_and_destruction_lifetimes','audio_replay_recording_resource_matches24_native_file_open_failure_write_result_repeated_open_close_and_callback_lifetimes','audio_replay_windows_recording_actual_crt_truncates_once_appends_literal_bytes_and_releases_every_file','audio_replay_windows_recording_missing_parent_returns_native_open_failure_and_retires_callbacks']:
 assert name+' ... ok' in log,name
assert re.search(r'Finished `dev` profile .* target',build.read_text(encoding='utf-8-sig'))
for name,count in [('replay_logger_composite_probe.json',28),('replay_recording_file_probe.json',24),('replay_recording_path_registration_probe.json',4)]:
 d=load(r/'data/4.20'/name);assert d['passed'] and d['native_sha256']==native and len(d['cases'])==count
paths=[r/'logs'/n for n in ['client-replay-recording-probe.json','client-replay-recording-running-regression.json','client-replay-recording-opening-regression.json','client-replay-recording-transport-regression.json','client-replay-recording-base-regression.json','client-replay-recording-runtime-regression.json']]
probes=list(map(load,paths));file_probe=probes[0]
assert file_probe['normal_application_attachment'] and file_probe['native_diagnostic_file_resource']
assert not file_probe['full_stream_file_preparation'] and not file_probe['pathname_registration_singleton'] and not file_probe['replay_frame_serialization'] and not file_probe['service_manager_connected']
assert len(file_probe['profiles'])==2
disk=[]
for row in file_probe['profiles']:
 f=row['report'];yes=row['expected_file_open'];assert (f['opened'],f['opened_again'],f['closed'])==(int(yes),int(yes),1)
 assert f['files_opened']==f['files_closed']==(2 if yes else 0) and f['writes']==(5 if yes else 0) and f['remaining_files']==0
 path=Path(row['path']);assert path.is_relative_to(r/'logs')
 if yes:
  data=path.read_bytes();assert data.decode('utf-8')==row['content']
  assert data.count(b'LogOut_File: : logfile started\r\n')==2 and data.count(b'LogOut_File: : logfile stopped\r\n')==1
  for part in [b'OpenLeague source file boundary %s %n\r\n',b'Repeated open must preserve this line\r\n']:assert part in data
  assert data.count(b'\r\n')==5
  disk.append({'path':str(path),'sha256':sha(path),'bytes':len(data),'lines':5})
 else:assert not path.exists() and not path.parent.exists()
workers=0
for d in probes:
 for row in d.get('profiles',[d]):
  c=row['closed'];assert c['closed'] and c['transport'] is None and c['worker_failures']==[] and c['handle_failures']==0
  assert c['workers_created']==c['workers_closed'];workers+=c['workers_created']
  assert c['crt']['heap_allocations']==c['crt']['heap_frees']
  for k in ['heap_blocks','retained_mirrors','critical_sections','heap_failures','lock_failures']:assert c['crt'][k]==0
assert workers==8
for p in paths:assert not p.with_suffix('.stderr.log').read_text(encoding='utf-8-sig').strip()
manifest=load(r/'data/4.20/runtime/replay_runtime_image_manifest.json');package=(r/'data/4.20/runtime/replay_runtime_image.bin').read_bytes()
assert manifest['native_sha256']==native and manifest['package_sha256']==hashlib.sha256(package).hexdigest() and len(package)==14612 and len(manifest['regions'])==21
source=Path(manifest['native_source']);assert sha(source)==native;pe=pefile.PE(str(source));mapped=pe.get_memory_mapped_image();image=mapped+bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped))
for x in manifest['regions']:
 a=x['address']-pe.OPTIONAL_HEADER.ImageBase;n=x['size'];o=x['payload_offset'];assert package[o:o+n]==image[a:a+n]
now=datetime.datetime.now(datetime.timezone.utc);key='replay_recording_file_validation';receipt_path='docs/'+key+'.json'
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks'])for d in plan['domains']),'additional_requirements':sum(len(d.get('additional_requirements',[]))for d in plan['domains'])};assert list(scope.values())==[24,114,37]
test_exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',log)[1].replace('\\','/')
next_action='Finish native8FB650 optional stream file preparation and the actual parent replay manager, preserving full scope. Logger now ports composite9014F0/9016C0/901750/901840/901860 and8F9380 append, including recursive deep clones and both callbacks without short-circuiting;28 original composite lifetimes match. Diagnostic LogOut_File resource8F8E10/8F8F10/8F8ED0/8F8F90/5F9D70 is ported, matching24 complete native file-state/callback/cleanup lifetimes with explicit primitive CRT outcomes. Windows Backend now routes resource callbacks to real msvcrt.dll fopen/fprintf/fclose with canonical FILE labels, wc/ac modes and literal%s formatting. Runtime::probe_recording_file on the normal canonical bank verifies actual file output and missing-parent failure;756 selected core tests and6 rebuilt-client commands pass. This is a diagnostic-file resource qualification, not full stream preparation, replay frame serialization or normal service manager integration. Source8FB650 with nonnull path must also invoke8C59F0/8C5E90: new replay_recording_path_registration_probe.json has4 complete original opening/start/active-destruction lifetimes with that default singleton constructor8C5A50/8C8000 and teardown8C5BB0. Port its canonical global flag2D8BAB4, object2D8BAC0 size10A8, tree at2D8CB50 from5C73C0, shutdownFA08B0, path gate10A0/10A4 and default destruction8C5AE0; qualify populated/active paths before claiming them. Add resource control vtable1085F8C (dispose5D6340,release5D5B40,scalar5D6840),901630/5D1620 wrapping and8C3480 move into stream+30; implement source close_resource and optional preparation using caller scratch. Source5F9D70/5D6340 does not close files or unregister the logger callback: caller must close first and must emit no message after resource destruction until logger chain retirement. Preserve the qualified state4 stop-before-destroy order; simply destroying an opened derived state3 recording stream then releasing global transport retains the earlier demonstrated retired-read hazard. Do not enable that unsafe partial lifecycle or reuse logger chains holding a retired resource. Source8FB650 ignores file-open return and returns its logger-ready byte; expose native file-enabled state separately. NativeReplayService still uses separate0x34000000 memory; integrate parent728E20/728FD0/728EE0, factories733540/7335C0/733640/7336C0/733740,729A50/729AE0 and metadata727DE0 into Runtime canonical0x39000000 bank instead of splicing pointers. Implement8FD6A0/8F7060/8F75D0/8F7920 active host, packet pool/crypto/parser/producer/consumer and service frame delivery. Qualify construction rollback/OOM/custom allocators, worker failures/timeouts and normal graphical exit. Continue all24domains114tasks37requirements, complete champions/maps/gameplay/launcher and delivery; no domain is complete.'
sources=['crates/core/src/'+n for n in ['audio_replay_logger.rs','audio_replay_logger_tests.rs','audio_replay_recording_resource.rs','audio_replay_recording_resource_tests.rs','audio_replay_windows_recording.rs','audio_replay_windows_recording_tests.rs','audio_replay_windows_transport.rs','audio_replay_windows_application.rs','audio_replay_runtime_image.rs','lib.rs']]+['crates/client/src/main.rs']+['tools/'+n for n in ['probe_replay_logger_composite.py','probe_replay_recording_file.py','probe_replay_recording_path_registration.py','extract_replay_runtime_image.py','record_replay_recording_file.py']]
resources=['data/4.20/'+n for n in ['replay_logger_composite_probe.json','replay_recording_file_probe.json','replay_recording_path_registration_probe.json','runtime/replay_runtime_image.bin','runtime/replay_runtime_image_manifest.json']]
logs=[core,build,r/'logs/replay-recording-path-registration.log']+paths+[p.with_suffix('.stderr.log')for p in paths]
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_source_sha256':native,'core_tests_passed':756,'core_tests_filtered':480,'new_tests_passed':4,'native_composite_lifetimes':28,'native_file_resource_lifetimes':24,'prepared_full_filename_lifetimes_not_ported':4,'new_windows_file_lifetimes':2,'client_commands':6,'client_workers':workers,'production_initial_regions':21,'production_initial_bytes':14612,'disk_outputs':disk,'host_file_crt':{'module':'C:/Windows/System32/msvcrt.dll','sha256':sha(Path('C:/Windows/System32/msvcrt.dll')),'api':'fopen/fprintf/fclose from that same DLL; opaque host FILE pointers mapped to canonical labels, no PE32 FILE pointer reinterpretation'},'client_executable':str(r/'target/debug/openleague-client.exe'),'client_executable_sha256':sha(r/'target/debug/openleague-client.exe'),'core_test_executable':str(test_exe),'core_test_executable_sha256':sha(test_exe),'source_hashes':{n:sha(r/n)for n in sources},'resource_hashes':{n:sha(r/n)for n in resources},'log_hashes':{str(p.relative_to(r)):sha(p)for p in logs},'client_file_probe':file_probe,'behavior':['Composite callbacks clone each child recursively, publish the replacement before disposing old wrappers, invoke both children even when the first returns0, and destroy second then first.','Source file resource opens wc, closes that handle, opens ac, then logs started. Repeated open leaves existing data intact and logs started again; close logs stopped before closing and clearing state. Numeric fprintf/fclose failures are ignored by the source; unavailable boundaries still return explicit errors.','Native null/disabled message gates and narrow byte formatting are preserved. Windows tests verify real truncation, literal percent data, raw non-UTF8 bytes, CRLF, embedded-NUL truncation, repeated open/close and missing-directory failure without auto-creating a folder.','Normal client Application attachment uses the same canonical runtime for this diagnostic qualification. Its rebuilt probe produces a five-line disk file and retires all file labels, source callbacks, physical locks, engine allocations and CRT application resources.'], 'limits':['Runtime::probe_recording_file is a qualification entry point, not the8FB650 full stream file-preparation path. Windows open_stream still supplies recording0. Native pathname-registration singleton, shared stream resource control and parent manager must be connected before enabling source file preparation.','This resource logs diagnostic text. Replay frame recording/playback, live socket traffic, parent manager and metadata, packet producer/consumer and service delivery remain unimplemented dependencies.','The host file boundary uses installed Windows msvcrt.dll, not execution or a wholesale port of the original bundled4.20 CRT stdio internals. Native probes use explicit supplied primitive CRT results; actual Windows output is independently verified.','Constructor exception rollback, allocation failure/custom allocator, null-child invocation and concurrent callback replacement remain unqualified. Source destruction does not unregister resource pointers from the logger; the full caller lifetime must enforce safe ordering.','756 audio-selected core tests and six rebuilt-client diagnostics, not the entire test suite, graphical gameplay, six-client match or human fidelity acceptance. No domain or whole-game completion follows.'],'next_action':next_action}
backup=r/'docs/plan_history'/('replay-recording-file-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/receipt_path,receipt)
summary={k:receipt[k]for k in ['saved_utc','passed','complete','core_tests_passed','core_tests_filtered','native_composite_lifetimes','native_file_resource_lifetimes','prepared_full_filename_lifetimes_not_ported','new_windows_file_lifetimes','client_commands','client_workers','client_executable_sha256']};summary['receipt']=receipt_path
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d[key]=summary;d['updated_utc']=now.isoformat();d['next_action']=next_action
 if name=='resume_checkpoint.json':
  d['state']='active';d['saved_utc']=now.isoformat();d.setdefault('last_verified',{})['replay_recording_file_audio_selected_core_tests']=756;d['last_verified']['replay_recording_file_receipt']=receipt_path
 if name=='completion_plan.json':
  domain=next(x for x in d['domains']if x['id']=='21')
  if isinstance(domain.get('progress_evidence'),list)and receipt_path not in domain['progress_evidence']:domain['progress_evidence'].append(receipt_path)
  for task in domain['tasks']:
   if task['id']in ['21.3','21.4']and receipt_path not in task['evidence']:task['evidence'].append(receipt_path)
  d['next_execution_steps'][0]=next_action
 write(p,d)
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');marker='replay-recording-file-validation';assert marker not in text and '</body>'in text
section='<section id="'+marker+'"><h2>Replay : journal de diagnostic sur disque</h2><p>Le chaînage natif des messages et la ressource de fichier sont portés. L’écriture réelle sous Windows et la fermeture des fichiers sont vérifiées ; 756 tests moteur ciblés et six contrôles du client reconstruit passent. La préparation complète du flux, les trames de partie et le gestionnaire principal restent à raccorder.</p></section>'
html.write_text(text.replace('</body>',section+'</body>'),encoding='utf-8')
for group in ['source_hashes','resource_hashes','log_hashes']:
 for name,h in receipt[group].items():assert sha(r/name)==h,name
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert load(r/'docs'/name)['next_action']==next_action
for f in disk:assert sha(Path(f['path']))==f['sha256']
print(json.dumps({'passed':True,'core_tests':756,'client_commands':6,'disk_outputs':disk,'scope':scope,'receipt':str(r/receipt_path),'client_sha256':receipt['client_executable_sha256']}))
