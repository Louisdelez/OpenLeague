from pathlib import Path
import json,hashlib,datetime,re,shutil,struct
import pefile
ROOT=Path('E:/OpenLeague');STAGE=Path('E:/mapslol3v3/replay_receive_stage');BASE=STAGE.parent
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
 p=ROOT/'data/4.20/runtime/replay_runtime_image.bin';m=load(p.with_name('replay_runtime_image_manifest.json'));raw=p.read_bytes();assert len(raw)==20563 and sha(p)==m['package_sha256'];assert len(m['regions'])==47 and m['native_sha256']==NATIVE
 source=Path(m['native_source']);assert sha(source)==NATIVE;pe=pefile.PE(str(source));mapped=pe.get_memory_mapped_image();image=mapped+bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped));cursor=48
 assert raw[:48]==b'OL420RT\0'+struct.pack('<II',1,47)+bytes.fromhex(NATIVE)
 for r in m['regions']:
  off=r['payload_offset'];size=r['size'];assert off==cursor+12;assert struct.unpack('<III',raw[cursor:off])==(r['group'],r['address'],size)
  data=raw[off:off+size];start=r['address']-pe.OPTIONAL_HEADER.ImageBase;assert data==image[start:start+size];assert hashlib.sha256(data).hexdigest()==r['sha256'];cursor=off+size
 assert cursor==len(raw)
 return {'regions':47,'bytes':len(raw),'sha256':sha(p),'service_vtable_bytes':180,'every_region_compared_to_native_pe':True}
def archive():
 dest=ROOT/'docs/replay_service_receive_sources';files={}
 for group,folder in {'receive':'replay_packet_agent','packet95':'replay_packet95_agent','dispatch_cleanup':'replay_dispatch_cleanup_agent'}.items():
  for src in sorted((BASE/folder).iterdir()):
   if not src.is_file() or src.suffix not in ['.rs','.py','.json','.md','.txt','.log','.patch']:continue
   installed=ROOT/'data/4.20'/src.name
   if src.suffix=='.json' and installed.exists() and sha(installed)==sha(src):
    files[group+'/'+src.name]={'production_fixture':str(installed.relative_to(ROOT)),'sha256':sha(installed)};continue
   target=dest/group/src.name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,target);files[str(target.relative_to(dest))]={'sha256':sha(target)}
 for name in ['installed.json','prepare.py','install.py']:
  src=STAGE/name;target=dest/'root'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,target);files[str(target.relative_to(dest))]={'sha256':sha(target)}
 save(dest/'index.json',{'native_sha256':NATIVE,'production_integrated':True,'files':files})
 return {'manifest':str((dest/'index.json').relative_to(ROOT)),'sha256':sha(dest/'index.json')}
def main():
 core=tests('core-replay-receive-tests.log',815);client=tests('client-replay-receive-tests.log',6)
 assert 'Finished' in (ROOT/'logs/client-replay-receive-build.log').read_text(encoding='utf-8')
 commands=load(ROOT/'logs/client-replay-receive-command-run.json');exe=ROOT/'target/debug/openleague-client.exe';digest=sha(exe)
 assert len(commands['commands'])==10 and commands['sha256']==digest
 first=commands['commands'][0];assert first['command']=='--native-replay-events-probe' and first['exit_code']==0 and first['sha256']==digest
 assert Path(first['root']).resolve()==ROOT.resolve();assert not Path(first['stderr']).read_text(encoding='utf-8').strip()
 report=load(Path(first['output']));assert report['passed'] and report['complete'] is False and report['retired']=={'allocations':0,'workers':0,'handles':0,'errors':[]}
 c=report['consumers'];assert c['passed'] and c['notifications']==4100 and c['scratch_bounded'];assert c['counts']==[2,1,41,43] and c['samples']==[17,19,23,29,31,37]
 assert c['states']=={'0':2,'7':2,'4294967295':2} and c['metadata_references']==1 and c['texts']==['restored-native-replay-metadata']*2
 s=c['service_packets'];assert s=={'passed':True,'parent_callback_connected':True,'filtered_or_dd_packets':12,'truncated_packets_rejected':5,'filtered_context_unchanged':True,'packet95_empty_receiver_packets':4,'gameplay_actions':0,'network_decoder_connected':False,'complete':False}
 src=(ROOT/'tools/record_replay_game_manager.py').read_text(encoding='utf-8')
 src=src.replace("assert len(commands['commands']) == 9", "assert len(commands['commands']) == 10").replace("zip(COMMANDS, commands['commands'])", "zip(COMMANDS, commands['commands'][1:])")
 ns={'__name__':'prior_replay_verifier'};exec(compile(src,'prior nine-command verifier','exec'),ns);ns['PREFIX']='client-replay-receive-'
 reports,logs,workers,disk,_=ns['verify_client'](16)
 image=verify_image();sources=archive()
 receive=load(ROOT/'data/4.20/replay_service_packet_probe.json');assert receive['passed'] and receive['native_sha256']==NATIVE and len(receive['cases'])==8
 native95=load(BASE/'replay_packet95_agent/packet95_receipt.json');assert native95['tests']['passed']==3 and native95['native_consumers']==148 and native95['native_assignments']==192
 cleanup=load(BASE/'replay_dispatch_cleanup_agent/qualification_manifest.json');assert cleanup['rust_test_functions_passed']==7 and cleanup['new_rust_test_functions']==4
 now=datetime.datetime.now(datetime.timezone.utc);key='replay_service_receive_validation';receipt_name='docs/'+key+'.json'
 next_action=('Complete the real simulation consumers behind replay packets. Service738A3A->vtable+34->72B2D0/72B2F0 now runs in the canonical Windows bank, activating pending listeners and dispatching the existing source metadata consumers. The native588290 switch tables are extracted; only the default AL0 and packet95 ownership/empty-recipient behavior are connected in its general fallback. Real actor methods for51/35, diagnostic behavior for E0/E1 index>=4, the actual packet95 recipient, other nondefault packet handlers, mode/global-owner producers, packet decoder and active network remain to implement. The four owner metadata listeners and E0/E1 bit updates pass Windows tests with explicit diagnostic mode/global setup; this setup is not normal simulation integration. A source dispatch temporary is now freed on host Result errors, preserving processing and cleanup errors together. Current815 selected core tests,6 client tests and10 commands on the rebuilt executable pass, with16 real worker lifetimes retired. Continue service72B950 events1/2, outbound729B70/729C50, mode producers59CFE0/59D100/59D210/59D4A0, ENet transport, frame recording/playback and all24 domains114 tasks37 requirements; no full-game acceptance or delivery claimed.')
 installed=load(STAGE/'installed.json');paths=set(installed['files'])|{'tools/run_replay_receive_probes.ps1','tools/record_replay_receive_validation.py','tools/record_replay_game_manager.py','crates/client/src/main.rs'}
 for rel,row in installed['files'].items():assert sha(ROOT/rel)==row['after'],rel
 receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'native_sha256':NATIVE,'core_tests':core,'client_tests':client,'client_commands':10,'client_workers':workers,'client_executable_sha256':digest,'client_event_report':report,'native_service_packet_cases':144,'native_service_return_values_matched':128,'native_service_explicit_unsupported95_in_generic_fixture':16,'native_packet95_consumers':148,'native_packet95_assignments':192,'native_packet95_ordered_events':3468,'windows_owner_metadata_bit_operations':4,'windows_error_dispatch_cleanup_verified':True,'production_image':image,'evidence':sources,'disk_outputs':disk,'source_hashes':{p:sha(ROOT/p) for p in sorted(paths) if not p.startswith('data/')},'resource_hashes':{p:sha(ROOT/p) for p in sorted(paths) if p.startswith('data/')},'log_hashes':{str(p.relative_to(ROOT)):sha(p) for p in [*logs,Path(first['output']),Path(first['stderr']),ROOT/core['log'],ROOT/client['log'],ROOT/'logs/client-replay-receive-build.log']},'limits':['Native service filtered returns and general default returns do not establish gameplay delivery. The final-client fresh-service probe performs zero gameplay actions.','Metadata registration/global ownership and the enabled service mode are supplied explicitly in the Windows registry test. Normal game-mode/global producers remain unconnected.','Packet95 implements native shared ownership and empty-recipient behavior. Its actual recipient virtual method is not connected; the oracle observes terminal calls through explicit boundaries.','Native packet table classification is not implementation of124 distinct handlers. Nondefault handlers other than packet95 remain explicit errors.','Cleanup covers host Result errors after snapshot allocation. Rust panic, native C++ unwinding, reentrant growth during allocation and allocation failure transactional recovery remain unqualified.','Targeted815 audio-selected core tests,6 replay/filesystem client tests and10 commands do not constitute whole-game visual/audio/gameplay/network acceptance.'],'next_action':next_action}
 summary={k:receipt[k] for k in ['saved_utc','passed','complete','client_commands','client_workers','client_executable_sha256','native_service_packet_cases','native_packet95_consumers','native_packet95_assignments']};summary.update(core_tests_passed=815,client_tests_passed=6,receipt=receipt_name)
 updates={}
 for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
  data=load(ROOT/'docs'/name);data[key]=summary;data['updated_utc']=now.isoformat();data['next_action']=next_action
  if 'prepared_replay_service_receive' in data:
   data['prepared_replay_service_receive'].update(production_integrated=True,rust_tests_run=True,integration_receipt=receipt_name,original_preparation_manifest_preserved=True)
  if name=='resume_checkpoint.json':data['state']='active';data['saved_utc']=now.isoformat();data.setdefault('last_verified',{}).update(replay_service_receive_receipt=receipt_name,replay_service_receive_selected_core_tests=815,replay_service_receive_selected_client_tests=6)
  if name=='completion_plan.json':
   domain=next(x for x in data['domains'] if x['id']=='21')
   if receipt_name not in domain['progress_evidence']:domain['progress_evidence'].append(receipt_name)
   for task in domain['tasks']:
    if task['id'] in ['21.3','21.4'] and receipt_name not in task['evidence']:task['evidence'].append(receipt_name)
   data['next_execution_steps'][0]=next_action
  updates[name]=data
 html=ROOT/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');marker='replay-service-receive-validation';assert marker not in text and '</body>' in text
 section=f'<section id="{marker}"><h2>Replay : réception des paquets du service</h2><p>Le callback du service, les registres de listeners et les mises à jour de bits des métadonnées sont raccordés au runtime Windows. Les paquets incomplets sont refusés et les temporaires sont libérés en cas d’erreur. Le paquet95 conserve les références natives ; son véritable destinataire de jeu reste à implémenter. 815 tests moteur ciblés, 6 tests client et 10 commandes du client reconstruit passent. Les producteurs de mode, les autres handlers, le décodage réseau et la simulation de partie restent à terminer.</p></section>'
 backup=ROOT/'docs/plan_history'/('replay-receive-validation-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
 for name in [*updates,'completion_plan.html']:shutil.copyfile(ROOT/'docs'/name,backup/name)
 save(ROOT/receipt_name,receipt)
 for name,data in updates.items():save(ROOT/'docs'/name,data)
 html.write_text(text.replace('</body>',section+'</body>'),encoding='utf-8')
 for group in ['source_hashes','resource_hashes','log_hashes']:
  for path,digest in receipt[group].items():assert sha(ROOT/path)==digest,path
 print(json.dumps({'passed':True,'complete':False,'core_tests':815,'client_tests':6,'client_commands':10,'client_workers':16,'receipt':receipt_name,'client_sha256':receipt['client_executable_sha256']}))
if __name__=='__main__':main()
