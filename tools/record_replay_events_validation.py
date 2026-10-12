from pathlib import Path
import json,hashlib,datetime,re,shutil,struct
import pefile
ROOT=Path('E:/OpenLeague');STAGE=Path('E:/mapslol3v3/replay_events_stage');BASE=STAGE.parent
NATIVE='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,data):
 p.parent.mkdir(parents=True,exist_ok=True);temp=p.with_suffix(p.suffix+'.tmp');temp.write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');temp.replace(p)
def tests(name,expected):
 p=ROOT/'logs'/name;t=p.read_text(encoding='utf-8');m=re.search(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out',t)
 assert m and int(m[1])==expected and int(m[2])==0,(name,m.groups() if m else t[-3000:])
 return {'passed':int(m[1]),'failed':0,'filtered':int(m[5]),'log':str(p.relative_to(ROOT)),'sha256':sha(p)}
def verify_image():
 p=ROOT/'data/4.20/runtime/replay_runtime_image.bin';manifest=load(p.with_name('replay_runtime_image_manifest.json'));raw=p.read_bytes();assert len(raw)==19450 and sha(p)==manifest['package_sha256'];assert len(manifest['regions'])==39 and manifest['native_sha256']==NATIVE
 source=Path(manifest['native_source']);assert sha(source)==NATIVE;pe=pefile.PE(str(source));mapped=pe.get_memory_mapped_image();image=mapped+bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped));cursor=48
 assert raw[:48]==b'OL420RT\0'+struct.pack('<II',1,39)+bytes.fromhex(NATIVE)
 for r in manifest['regions']:
  off=r['payload_offset'];size=r['size'];assert off==cursor+12;assert struct.unpack('<III',raw[cursor:off])==(r['group'],r['address'],size)
  data=raw[off:off+size];start=r['address']-pe.OPTIONAL_HEADER.ImageBase;assert data==image[start:start+size];assert hashlib.sha256(data).hexdigest()==r['sha256'];cursor=off+size
 assert cursor==len(raw)
 return {'regions':39,'bytes':len(raw),'sha256':sha(p),'metadata_vtable_bytes':100,'every_region_compared_to_native_pe':True}
def archive():
 dest=ROOT/'docs/replay_event_consumers_sources';manifest={}
 groups={'callback_signatures':'replay_callback_signatures_agent','integer_tree':'replay_metadata_tree_agent','text_trees':'replay_metadata_text_agent','count_overwrite':'replay_metadata_count_audit'}
 for group,folder in groups.items():
  for src in sorted((BASE/folder).iterdir()):
   if not src.is_file() or src.suffix not in ['.rs','.py','.json','.md','.txt','.log','.patch']:continue
   # Large test operands are already owned in data/4.20; preserve their exact identity there.
   installed=ROOT/'data/4.20'/src.name
   if src.suffix=='.json' and installed.exists() and sha(installed)==sha(src):
    manifest[group+'/'+src.name]={'production_fixture':str(installed.relative_to(ROOT)),'sha256':sha(installed)};continue
   target=dest/group/src.name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,target);manifest[str(target.relative_to(dest))]={'sha256':sha(target)}
 for name in ['probe_replay_event_consumers.py','installed.json','core-initial-compile.log','core-before-final-review.log']:
  src=STAGE/name;target=dest/'root'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,target);manifest[str(target.relative_to(dest))]={'sha256':sha(target)}
 save(dest/'index.json',{'native_sha256':NATIVE,'production_integrated':True,'files':manifest})
 return {'manifest':str((dest/'index.json').relative_to(ROOT)),'sha256':sha(dest/'index.json')}
def archive_next():
 source=BASE/'replay_packet_agent';dest=ROOT/'docs/replay_service_receive_preparation';files={}
 for p in sorted(source.iterdir()):
  if p.is_file() and p.suffix in ['.py','.rs','.json','.md','.txt']:
   target=dest/p.name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target);files[p.name]={'sha256':sha(target)}
 assert 'replay_service_packet_probe.json' in files and 'audio_replay_service_receive_tests.rs' in files
 proof=load(dest/'replay_service_packet_probe.json');assert proof['passed'] and proof['native_sha256']==NATIVE
 save(dest/'index.json',{'production_integrated':False,'rust_tests_run':False,'native_sha256':NATIVE,'scope':'Native receive-path audit and uncompiled Rust proposal; not part of current803 tests.','files':files})
 return {'manifest':str((dest/'index.json').relative_to(ROOT)),'sha256':sha(dest/'index.json'),'production_integrated':False,'rust_tests_run':False}
def main():
 core=tests('core-replay-events-tests.log',803);client=tests('client-replay-events-tests.log',6)
 assert 'Finished' in (ROOT/'logs/client-replay-events-build.log').read_text(encoding='utf-8')
 commands=load(ROOT/'logs/client-replay-events-command-run.json');exe=ROOT/'target/debug/openleague-client.exe';digest=sha(exe)
 assert len(commands['commands'])==10 and commands['sha256']==digest
 first=commands['commands'][0];assert first['command']=='--native-replay-events-probe' and first['exit_code']==0 and first['sha256']==digest
 assert Path(first['root']).resolve()==ROOT.resolve();assert not Path(first['stderr']).read_text(encoding='utf-8').strip()
 report=load(Path(first['output']));assert report['passed'] and report['complete'] is False and report['retired']=={'allocations':0,'workers':0,'handles':0,'errors':[]}
 c=report['consumers'];assert c['passed'] and c['notifications']==4100 and c['scratch_bounded'];assert c['counts']==[2,1,41,43] and c['samples']==[17,19,23,29,31,37]
 assert c['states']=={'0':2,'7':2,'4294967295':2} and c['metadata_references']==1 and c['texts']==['restored-native-replay-metadata']*2
 assert c['decoded_event_ingress'] and not c['network_decoder_connected'] and c['complete'] is False
 # Reuse the previous independent nine-command verifier on their unchanged
 # suffixes/schema. Only the outer new-command position and count differ.
 src=(ROOT/'tools/record_replay_game_manager.py').read_text(encoding='utf-8')
 src=src.replace("assert len(commands['commands']) == 9", "assert len(commands['commands']) == 10").replace("zip(COMMANDS, commands['commands'])", "zip(COMMANDS, commands['commands'][1:])")
 ns={'__name__':'prior_replay_verifier'};exec(compile(src,'prior nine-command verifier','exec'),ns);ns['PREFIX']='client-replay-events-'
 reports,logs,workers,disk,_=ns['verify_client'](16)
 image=verify_image();sources=archive();prepared_next=archive_next()
 fixture=load(ROOT/'data/4.20/replay_event_consumers_probe.json');assert fixture['passed'] and fixture['native_sha256']==NATIVE and len(fixture['cases'])==2
 assert sum(len(x['events']) for x in fixture['cases'])==16 and sum(len(x['frames']) for x in fixture['cases'])==10 and sum(len(x['text_frames']) for x in fixture['cases'])==24
 for case in fixture['cases']:assert case['shutdown']['blocks']==[]
 state=load(BASE/'replay_metadata_tree_agent/metadata_state_receipt.json');assert state['passed'] and state['native_operation_count']==252 and state['all_parent_owned_allocations_released']
 now=datetime.datetime.now(datetime.timezone.utc);key='replay_event_consumers_validation';receipt_name='docs/'+key+'.json'
 next_action=('Connect the remaining real replay consumers: service738A3A->vtable+34->72B2D0/72B2F0 and packet588290; reuse verified audio_announcer_service_activation activate72EC40/dispatch72EEC0 where exact. Complete service72B950 events1/2, outbound729B70/729C50, actual mode producers59CFE0/59D100/59D210/59D4A0, active ENet transport, packet decoder/producer, frame recording/playback and simulation delivery. The canonical Windows runtime now executes metadata notifications event5, count/array opcode103 and text opcodes101/102 through real source wrappers and consumers, including metadata trees and reference lifetime. Unknown consumers still fail explicitly. Incoming arrays are limited to24 after the100-case native audit proved source25..48 corruption; truncated fixed fields and unterminated text are rejected before mutation. Scratch is pooled and reservation failures roll back. Current final-client10 commands,803 selected core tests and6 client tests pass;16 real worker lifetimes remain regression-qualified. Decoder/network and game simulation are not connected by this milestone. Continue all24 domains,114 tasks,37 requirements; full-game visual/audio/gameplay/network acceptance and delivery remain incomplete.')
 installed=load(STAGE/'installed.json');paths=set(installed['files'])|{'crates/core/src/audio_replay_windows_game_manager.rs','tools/run_replay_events_probes.ps1','tools/record_replay_events_validation.py','tools/record_replay_game_manager.py'}
 receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'native_sha256':NATIVE,'core_tests':core,'client_tests':client,'client_commands':10,'client_workers':workers,'client_executable_sha256':digest,'client_event_report':report,'native_consumer_lifetimes':2,'native_service_events':16,'native_array_frames':10,'native_text_frames':24,'native_integer_tree_lifetimes':20,'native_integer_tree_operations':252,'native_text_setter_calls':440,'native_text_lifetimes':18,'native_count_overwrite_profiles':100,'native_count_oracle_contracts':432,'native_callback12_contracts':96,'native_signature_contracts':336,'native_leaf_contracts':24,'production_image':image,'evidence':sources,'disk_outputs':disk,'source_hashes':{p:sha(ROOT/p) for p in sorted(paths) if not p.startswith('data/')},'resource_hashes':{p:sha(ROOT/p) for p in sorted(paths) if p.startswith('data/')},'log_hashes':{str(p.relative_to(ROOT)):sha(p) for p in [*logs,Path(first['output']),Path(first['stderr']),ROOT/core['log'],ROOT/client['log'],ROOT/'logs/client-replay-events-build.log']},'limits':['Typed wrapper ports preserve complete terminal returns; concrete C++ bool consumers define AL only. No arbitrary function pointers execute.','Ingress deliberately rejects native malformed count25..48 cases before source dispatch. The generic source copy still preserves native count re-read semantics.','Source service events1/2, payload/frame decoder, recording serialization, networking and simulation frame delivery remain unconnected. Incoming decoded metadata does not establish replay playback.','Text erase right red-sibling branch5C4847, broad allocation failure rollback/C++ exceptions, reentrancy/concurrency, repeated game sessions and game-wide fidelity remain unqualified.','803 audio-selected tests and six replay/filesystem client tests are targeted qualification, not full-game acceptance.'],'next_action':next_action}
 receipt['prepared_next_receive_path']=prepared_next
 receipt['limits'].append('The dedicated temporary-argument pool is bounded by peak simultaneous allocations and size classes. General engine allocator history remains per-lifetime; this does not prove constant memory for a complete replay stream.')
 updates={};summary={k:receipt[k] for k in ['saved_utc','passed','complete','client_commands','client_workers','client_executable_sha256','native_service_events','native_array_frames','native_text_frames']};summary.update(core_tests_passed=803,client_tests_passed=6,receipt=receipt_name)
 for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
  data=load(ROOT/'docs'/name);data[key]=summary;data['updated_utc']=now.isoformat();data['next_action']=next_action
  data['prepared_replay_service_receive']=prepared_next
  if 'prepared_replay_followup_qualification' in data:
   data['prepared_replay_followup_qualification']['production_integrated']=True
   data['prepared_replay_followup_qualification']['integration_receipt']=receipt_name
   data['prepared_replay_followup_qualification']['original_preparation_manifest_preserved']=True
  if name=='resume_checkpoint.json':data['state']='active';data['saved_utc']=now.isoformat();data.setdefault('last_verified',{}).update(replay_event_consumers_receipt=receipt_name,replay_event_consumers_selected_core_tests=803,replay_event_consumers_selected_client_tests=6)
  if name=='completion_plan.json':
   domain=next(x for x in data['domains'] if x['id']=='21')
   if receipt_name not in domain['progress_evidence']:domain['progress_evidence'].append(receipt_name)
   for task in domain['tasks']:
    if task['id'] in ['21.3','21.4'] and receipt_name not in task['evidence']:task['evidence'].append(receipt_name)
   data['next_execution_steps'][0]=next_action
  updates[name]=data
 html=ROOT/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');marker='replay-event-consumers-validation';assert marker not in text and '</body>' in text
 section=f'<section id="{marker}"><h2>Replay : consommateurs de métadonnées</h2><p>Les notifications d’état, les tableaux et les textes passent par les fonctions originales portées dans le runtime Windows. Les entrées tronquées et les dépassements de tableaux sont rejetés ; les temporaires sont réutilisés. 803 tests moteur ciblés, 6 tests client ciblés et 10 commandes du client reconstruit passent. Le décodage réseau, les trames de partie et la livraison à la simulation restent à terminer.</p></section>'
 backup=ROOT/'docs/plan_history'/('replay-events-validation-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
 for name in [*updates,'completion_plan.html']:shutil.copyfile(ROOT/'docs'/name,backup/name)
 save(ROOT/receipt_name,receipt)
 for name,data in updates.items():save(ROOT/'docs'/name,data)
 html.write_text(text.replace('</body>',section+'</body>'),encoding='utf-8')
 for group in ['source_hashes','resource_hashes','log_hashes']:
  for path,digest in receipt[group].items():assert sha(ROOT/path)==digest,path
 print(json.dumps({'passed':True,'complete':False,'core_tests':803,'client_tests':6,'client_commands':10,'client_workers':16,'receipt':receipt_name,'client_sha256':receipt['client_executable_sha256']}))
if __name__=='__main__':main()
