from pathlib import Path
import datetime,hashlib,json,re,shutil,struct
import pefile
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 with p.open('rb')as f:return hashlib.file_digest(f,'sha256').hexdigest()
def write(p,d):
 q=p.with_suffix(p.suffix+'.tmp');q.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');assert load(q)==d;q.replace(p)
native='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
core=r/'logs/core-replay-running-tests.log';build=r/'logs/client-replay-running-build.log'
log=core.read_text(encoding='utf-8-sig');m=re.search(r'test result: ok\. (\d+) passed; 0 failed; 0 ignored; 0 measured; (\d+) filtered out',log);assert m
assert (int(m[1]),int(m[2]))==(752,480)
for name in ['audio_replay_stream_running_matches192_native_start_state_gates_callback_arguments_and_failure_states','audio_replay_stream_worker_matches_native_pause_and_stop_flag_order_including_one_last_poll','audio_replay_windows_running_starts_restarts_and_joins_actual_source_stream_workers','audio_replay_windows_running_application_close_stops_a_live_stream_before_freeing_its_bank','audio_replay_windows_running_unsupported_host_does_not_start_an_orphan_worker_or_change_state']:
 assert name+' ... ok' in log,name
assert re.search(r'Finished `dev` profile .* target',build.read_text(encoding='utf-8-sig'))
full=load(r/'data/4.20/replay_stream_start_stop_probe.json');contract=load(r/'data/4.20/replay_stream_running_contract.json')
assert full['passed'] and contract['passed'] and full['native_sha256']==contract['native_sha256']==native
assert len(full['cases'])==32 and len(contract['cases'])==192 and len(contract['workers'])==4
for c in full['cases']:
 assert not c['retired_resource_reads'] and c['start_code']==(6 if c['mode']==0 else 0) and c['repeat_code']==8
 assert c['started_state']['state_id']==4
 assert len(c['host_creation_failure_boundary'])==(1 if c['mode']==0 else 0)
 if c['stop_explicitly']:assert c['stopped_state']['state_id']==3 and c['stopped_state']['references']==0
 else:assert c['stopped'] is None
 assert any(x['function']==0x8fb7b0 for x in c['native_entries'])
paths=[r/'logs'/n for n in ['client-replay-running-probe.json','client-replay-running-opening-regression.json','client-replay-running-transport-regression.json','client-replay-running-base-regression.json','client-replay-running-runtime-regression.json']]
running,opening,derived,base,runtime=map(load,paths)
assert running['normal_application_attachment'] and running['source_stream_worker']
assert running['implementation']=='native_no_op' and not running['active_network_host_connected'] and not running['recording_file_connected'] and not running['replay_frame_delivery']
assert len(running['profiles'])==2
for row in running['profiles']:
 assert row['before']['state_id']==3 and row['active_workers']==1
 if row['explicit_stop']:assert row['stopped']['state_id']==3
 else:assert row['stopped'] is None
for d in [running,opening,derived,base,runtime]:
 rows=d.get('profiles',[d])
 for row in rows:
  closed=row['closed'];assert closed['closed'] and closed['transport'] is None
  assert closed['workers_created']==closed['workers_closed'] and closed['worker_failures']==[] and closed['handle_failures']==0
  assert closed['crt']['heap_allocations']==closed['crt']['heap_frees']
  for k in ['heap_blocks','retained_mirrors','critical_sections','heap_failures','lock_failures']:assert closed['crt'][k]==0
workers=sum(row['closed']['workers_created']for d in [running,opening,derived,base,runtime]for row in d.get('profiles',[d]));assert workers==8
for p in paths:assert p.with_suffix('.stderr.log').read_text(encoding='utf-8-sig').strip()==''
manifest=load(r/'data/4.20/runtime/replay_runtime_image_manifest.json');package=(r/'data/4.20/runtime/replay_runtime_image.bin').read_bytes()
assert manifest['native_sha256']==native and manifest['package_sha256']==hashlib.sha256(package).hexdigest() and len(package)==14588
source=Path(manifest['native_source']);assert sha(source)==native
pe=pefile.PE(str(source));mapped=pe.get_memory_mapped_image();image=mapped+bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped))
for region in manifest['regions']:
 a=region['address']-pe.OPTIONAL_HEADER.ImageBase;n=region['size'];o=region['payload_offset']
 assert package[o:o+n]==image[a:a+n]
assert len(manifest['regions'])==20
now=datetime.datetime.now(datetime.timezone.utc);key='replay_stream_running_validation';receipt_path='docs/'+key+'.json'
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(x['tasks'])for x in plan['domains']),'additional_requirements':sum(len(x.get('additional_requirements',[]))for x in plan['domains'])};assert list(scope.values())==[24,114,37]
test_exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',log)[1].replace('\\','/')
sources=['crates/core/src/'+n for n in ['audio_replay_stream_running.rs','audio_replay_stream_running_tests.rs','audio_replay_stream_tests.rs','audio_replay_windows_opening.rs','audio_replay_windows_opening_tests.rs','audio_replay_windows_transport.rs','audio_replay_transport_thread.rs','audio_replay_runtime_image.rs','audio_replay_stream.rs','lib.rs']]+['crates/client/src/main.rs']+['tools/'+n for n in ['probe_replay_stream_start_stop.py','probe_replay_stream_running_contract.py','extract_replay_runtime_image.py','record_replay_stream_running.py']]
resources=['data/4.20/'+n for n in ['replay_stream_start_stop_probe.json','replay_stream_running_contract.json','runtime/replay_runtime_image.bin','runtime/replay_runtime_image_manifest.json']]
logs=[core,build]+paths+[p.with_suffix('.stderr.log')for p in paths]
next_action='Finish the real replay parent manager/service lifecycle and optional recording, not just the no-op worker. Source8F6AF0/8FB580/8FB860/8FB7B0 is now ported: state3 gate, thread publication, event1 before implementation methods, failure6/7 retaining state4, pause loop and run flag.192 native start contracts and4 loop traces agree.32 full original lifetimes now qualify both explicit stop and active scalar destruction with recording flags0/1/256/257: derived host creation is an explicitly supplied failure0, not a working socket; source stop901C44->8F6FA0 releases key/global reference before recording resource destruction, with zero observed retired-resource reads throughout destruction and logger shutdown. Windows Runtime::start_stream/stop_stream and automatic shutdown run the actual native no-op implementation through real CRT/Windows workers; restart, live close and Drop are tested. Derived active host start remains explicitly unavailable before any state mutation.752 selected core tests pass,5 rebuilt-client commands pass with8 workers; no frame recording/playback or normal parent service integration is claimed. Port logger composite9014F0/9016C0/901750/901840/901860 and8FB650 recording resource8F8E10/8F8F10/8F8F90, native wc/ac file modes and%s writes, with qualified parent stop-before-destroy order before enabling recording. Integrate parent728E20/728FD0/728EE0, callback factories733540/7335C0/733640/7336C0/733740,729A50/729AE0 and metadata727DE0 into the canonical0x39000000 Runtime bank; do not splice pointers from NativeReplayService separate0x34000000 bank. Then implement actual8FD6A0 host creation,8F7060/8F75D0 connect,8F7920 polling, packet pool/crypto/parser/producer/consumer and real service frame delivery. Qualify worker failure/timeouts/OOM/custom allocator and normal graphical exit; all24domains114tasks37requirements including champions/maps/gameplay/launcher remain required.'
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_source_sha256':native,'core_tests_passed':752,'core_tests_filtered':480,'new_tests':5,'native_start_contracts':192,'native_worker_traces':4,'native_full_start_stop_lifetimes':32,'native_retired_resource_reads':0,'new_windows_lifetimes':5,'new_windows_workers':7,'client_probe_commands':5,'client_probe_workers':workers,'production_initial_bytes':len(package),'production_initial_regions':20,'client_executable':str(r/'target/debug/openleague-client.exe'),'client_executable_sha256':sha(r/'target/debug/openleague-client.exe'),'core_test_executable':str(test_exe),'core_test_executable_sha256':sha(test_exe),'source_hashes':{n:sha(r/n)for n in sources},'resource_hashes':{n:sha(r/n)for n in resources},'log_hashes':{str(p.relative_to(r)):sha(p)for p in logs},'client_running_probe':running,'behavior':['Source launch publishes a thread pair at the owning stream instead of the global transport pair. Restart replaces and retires the previous thread control with the native publication order.','Stop signals the run flag and joins before stream ownership is destroyed. Application shutdown now stops an active stream before checking whether its resources can be freed. A still-active worker prevents release of its storage.','Normal source worker loops preserve pause semantics: clearing the run flag while paused does not bypass the pause loop, and one poll follows pause release before the outer flag is checked again.','No-op implementation uses its real source methods and a real Windows worker. Derived host start is rejected explicitly before launch until its creation/connect/poll methods are ported.'], 'limits':['This does not implement replay frame recording, playback, active network traffic, parent game manager callbacks or metadata integration. Optional file resource remains disabled.','Full native lifetime probe schedules stream worker at its stop/join and supplies derived host-creation failure. Separate loop traces supply Sleep outcomes. Neither proves native concurrent host success.','Windows tests cover actual no-op source workers and safe preflight rejection of unavailable derived host. Real connection success, worker creation failures/timeouts, constructor rollback/OOM and recording file I/O remain to qualify.','752 audio-selected core tests, not the full project suite. Rebuilt client diagnostics use the normal Application attachment but do not launch a graphical game, run six clients or prove human fidelity. No domain or whole-game completion is claimed.'],'next_action':next_action}
backup=r/'docs/plan_history'/('replay-stream-running-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/receipt_path,receipt)
summary={k:receipt[k]for k in ['saved_utc','passed','complete','core_tests_passed','core_tests_filtered','native_start_contracts','native_worker_traces','native_full_start_stop_lifetimes','native_retired_resource_reads','new_windows_lifetimes','new_windows_workers','client_probe_commands','client_probe_workers','client_executable_sha256']};summary['receipt']=receipt_path
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d[key]=summary;d['updated_utc']=now.isoformat();d['next_action']=next_action
 if name=='resume_checkpoint.json':
  d['state']='active';d['saved_utc']=now.isoformat()
  d.setdefault('last_verified',{})['replay_stream_running_audio_selected_core_tests']=752
  d['last_verified']['replay_stream_running_receipt']=receipt_path
 if name=='completion_plan.json':
  domain=next(x for x in d['domains']if x['id']=='21');domain.setdefault('progress_evidence',[])
  if isinstance(domain['progress_evidence'],list) and receipt_path not in domain['progress_evidence']:domain['progress_evidence'].append(receipt_path)
  for task in domain['tasks']:
   if task['id'] in ['21.3','21.4'] and receipt_path not in task['evidence']:task['evidence'].append(receipt_path)
  d['next_execution_steps'][0]=next_action
 write(p,d)
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');marker='replay-stream-running-validation';assert marker not in text and '</body>' in text
section='<section id="'+marker+'"><h2>Replay : démarrage et arrêt du flux</h2><p>Le cycle du flux est porté et testé : démarrage, attente, arrêt et fermeture avec un thread Windows actif. 752 tests moteur ciblés réussis. Les essais natifs confirment la fermeture de la connexion avant la destruction de la ressource de fichier. La connexion active, les fichiers et la livraison des trames restent à intégrer au gestionnaire de partie.</p></section>'
html.write_text(text.replace('</body>',section+'</body>'),encoding='utf-8')
for group in ['source_hashes','resource_hashes','log_hashes']:
 for name,h in receipt[group].items():assert sha(r/name)==h,name
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:assert load(r/'docs'/name)['next_action']==next_action
print(json.dumps({'passed':True,'core_tests':752,'native_full_lifetimes':32,'new_windows_workers':7,'client_workers':workers,'scope':scope,'receipt':str(r/receipt_path),'client_sha256':receipt['client_executable_sha256']}))
