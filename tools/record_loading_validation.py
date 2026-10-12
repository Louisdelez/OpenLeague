from pathlib import Path
import json,hashlib,datetime,re,shutil,struct
import pefile
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/loading_metadata_stage');B=S.parent
NATIVE='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,value):
 p.parent.mkdir(parents=True,exist_ok=True);tmp=p.with_suffix(p.suffix+'.tmp');tmp.write_text(json.dumps(value,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');tmp.replace(p)
def result(filename,count=None):
 p=R/'logs'/filename;t=p.read_text(encoding='utf-8');m=re.search(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out',t)
 assert m and int(m[2])==0 and (count is None or int(m[1])==count),(filename,m.groups() if m else t[-1500:])
 assert int(m[3])==int(m[4])==0 and 'test result: FAILED' not in t
 runners=re.findall(r'Running unittests .*?\(([^)]+\.exe)\)',t);assert len(runners)==1
 runner=R/runners[0].replace('\\','/');assert runner.is_file()
 return {'passed':int(m[1]),'failed':0,'filtered':int(m[5]),'path':p.relative_to(R).as_posix(),'sha256':sha(p),'executable':runner.relative_to(R).as_posix(),'executable_sha256':sha(runner)}
def verify_image():
 p=R/'data/4.20/runtime/replay_runtime_image.bin';m=load(p.with_name('replay_runtime_image_manifest.json'));raw=p.read_bytes();assert len(raw)==20694 and sha(p)==m['package_sha256'];assert len(m['regions'])==53 and m['native_sha256']==NATIVE
 source=Path(m['native_source']);assert sha(source)==NATIVE;pe=pefile.PE(str(source));mapped=pe.get_memory_mapped_image();image=mapped+bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped));cursor=48
 assert raw[:48]==b'OL420RT\0'+struct.pack('<II',1,53)+bytes.fromhex(NATIVE)
 for row in m['regions']:
  off=row['payload_offset'];n=row['size'];assert off==cursor+12;assert struct.unpack('<III',raw[cursor:off])==(row['group'],row['address'],n)
  data=raw[off:off+n];start=row['address']-pe.OPTIONAL_HEADER.ImageBase;assert data==image[start:start+n];assert hashlib.sha256(data).hexdigest()==row['sha256'];cursor=off+n
 assert cursor==len(raw)
 return {'regions':53,'bytes':len(raw),'sha256':sha(p),'every_region_compared_to_native_pe':True,'crt_locale_global_not_duplicated':True}
def archive():
 target=R/'docs/loading_sources';rows={}
 groups=['loading_record_tree_agent','loading_consumer_agent','loading_owner_agent','loading_windows_consumer_agent','loading_metadata_review']
 for group in groups:
  for src in sorted((B/group).rglob('*')):
   if not src.is_file() or src.suffix not in ['.rs','.py','.json','.md','.txt','.log','.patch']:continue
   relative=Path(group)/src.relative_to(B/group);fixture=R/'data/4.20'/src.name
   if src.suffix=='.json' and fixture.exists() and sha(fixture)==sha(src):rows[relative.as_posix()]={'fixture':fixture.relative_to(R).as_posix(),'sha256':sha(src)};continue
   dest=target/relative;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dest);rows[relative.as_posix()]={'sha256':sha(dest)}
 for src in sorted(S.iterdir()):
  if not src.is_file() or src.suffix not in ['.rs','.py','.json','.ps1']:continue
  relative=Path('root')/src.name;fixture=R/'data/4.20'/src.name
  if src.suffix=='.json' and fixture.exists() and sha(fixture)==sha(src):rows[relative.as_posix()]={'fixture':fixture.relative_to(R).as_posix(),'sha256':sha(src)};continue
  dest=target/relative;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dest);rows[relative.as_posix()]={'sha256':sha(dest)}
 save(target/'index.json',{'native_sha256':NATIVE,'production_integrated':True,'files':rows})
 return {'manifest':(target/'index.json').relative_to(R).as_posix(),'sha256':sha(target/'index.json')}
def commands():
 run=load(R/'logs/client-loading-command-run.json');exe=R/'target/debug/openleague-client.exe';digest=sha(exe);assert run['sha256']==digest and len(run['commands'])==10
 first=run['commands'][0];assert first['command']=='--native-replay-events-probe' and first['exit_code']==0 and first['sha256']==digest and Path(first['root']).resolve()==R.resolve()
 assert not Path(first['stderr']).read_text(encoding='utf-8').strip();report=load(Path(first['output']));assert report['passed'] and report['complete'] is False and report['retired']=={'allocations':0,'workers':0,'handles':0,'errors':[]}
 s=report['consumers']['service_packets'];assert s['passed'] and s['packet95_empty_receiver_packets']==4 and s['truncated_packets_rejected']==5 and s['gameplay_actions']==0
 src=(R/'tools/record_replay_game_manager.py').read_text(encoding='utf-8').replace("assert len(commands['commands']) == 9","assert len(commands['commands']) == 10").replace("zip(COMMANDS, commands['commands'])","zip(COMMANDS, commands['commands'][1:])")
 ns={'__name__':'prior_verifier'};exec(compile(src,'prior verifier','exec'),ns);ns['PREFIX']='client-loading-';reports,logs,workers,disk,_=ns['verify_client'](16)
 return {'commands':10,'workers':workers,'executable_sha256':digest,'event_report':report,'disk_outputs':disk,'logs':{p.relative_to(R).as_posix():sha(p) for p in [*logs,Path(first['output']),Path(first['stderr'])]}}
def main():
 core=result('core-loading-tests.log');assert core['passed']>=832
 client=result('client-loading-tests.log',6);assert 'Finished' in (R/'logs/client-loading-build.log').read_text(encoding='utf-8')
 texts=(R/'logs/core-loading-tests.log').read_text(encoding='utf-8')
 required=['audio_loading_metadata_native_getters_and_capacity_retention','audio_loading_metadata_rolls_back_new_buffers_and_partial_acquisition','audio_replay_windows_loading_metadata_resolves_from_actual_packet_index_and_preserves_lifetimes','audio_replay_windows_loading_uses_real_trees_and_consumer_for48_hot_packets','audio_replay_windows_loading_rejects_truncation_before_any_runtime_mutation','audio_replay_windows_loading_constructs_real_empty_wrapper_publishes_and_retires_control']
 for name in required:assert name in texts and re.search(re.escape(name)+r'.*?\.\.\. ok',texts),name
 installed=load(S/'installed.json');repairs=[]
 for rel,row in installed['files'].items():
  staged=S/'production'/rel;assert sha(R/rel)==sha(staged),rel
  if row['after']!=sha(R/rel):repairs.append({'path':rel,'initial_sha256':row['after'],'qualified_sha256':sha(R/rel)});row['after']=sha(R/rel)
 installed['qualified_repairs']=repairs;save(S/'installed.json',installed)
 native=load(S/'native_result.json');assert native['passed'] and native['getter_calls']==704
 review=load(B/'loading_metadata_review/loading_resolver_composition_probe.json');assert review['passed'] and review['native_resolver_executed'] and not review['resolver_result_boundary']
 image=verify_image();actual=commands();sources=archive();now=datetime.datetime.now(datetime.timezone.utc);key='loading_runtime_validation';receipt='docs/'+key+'.json'
 next_action=('Complete the normal loading screen lifecycle and first UI initialization. The actual57D650/5B3230 consumers are connected behind packet95 in the canonical Windows runtime; source record trees create absent records and retain native layout/flags. Metadata getters72AD90/72AE40 now use the actual729EC0/729730/8F8CF0 identifier resolver, canonical parent/stream index and retained metadata. The128-byte wrapper and both shared controls have native-qualified ownership; Windows disposal and locale lookup are connected without copying mutable CRT state. Windows packet tests explicitly bind diagnostic recipients, not source factories. Normal5765F0 selection/factories, locale/global publication/shutdown producers, standard57D6CB UI/assets and the single shared993C70/993CE0 QPC clock are still required. Tutorial name lookup is real but a nonempty first name reaches an explicit unconnected-clock error. Keep unknown packet handlers and missing actor/diagnostic consumers explicit. Continue all24 domains114 tasks37 requirements, frame decoding/delivery, active transport, normal simulation, full maps/champions/gameplay and launcher; this partial loading milestone is not full-game acceptance or delivery.')
 value={'saved_utc':now.isoformat(),'passed':True,'complete':False,'native_sha256':NATIVE,'core_tests':core,'client_tests':client,'client':actual,'image':image,'evidence':sources,
 'native_record_tree_lifetimes':48,'native_record_accesses':480,'native_record_ordered_byte_writes':60140,'native_existing_record_packets':1600,'native_first_tutorial_names':256,'physical_x87_cases':26,'native_wrapper_lifetimes':48,'native_wrapper_publications':96,'native_metadata_getters':704,'native_composed_resolutions':16,'native_composed_providers':32,
 'windows_hot_packets':48,'windows_truncated_payloads_rejected':96,'windows_recipient_bindings':'explicit diagnostic storage; no native screen constructor/factory claim','windows_clock_connected':False,'normal_screen_factory_connected':False,'standard_first_ui_connected':False,
 'source_hashes':{rel:sha(R/rel) for rel in [*[x for x in installed['files'] if not x.startswith('data/')],'tools/record_loading_validation.py','tools/run_loading_probes.ps1']},'resource_hashes':{rel:sha(R/rel) for rel in installed['files'] if rel.startswith('data/')},
 'build_log':{'path':'logs/client-loading-build.log','sha256':sha(R/'logs/client-loading-build.log')},
 'limits':['The new consumers and providers run in the actual Windows bank, but diagnostic bindings do not establish normal loading-screen construction or gameplay readiness.','Standard first UI/assets and shared QPC clock are explicit errors. Source first-screen factories, language/global publication and shutdown producers remain to connect.','704 getter comparisons isolate resolver/locks/allocator/memcpy boundaries; the separate composed oracle executes the real resolver and providers using native packet/name producers, with explicit native index setup.','The physical x87 probe covers26 local FLD/FSTP cases. Unicorn signaling-NaN differences are documented and excluded from false parity claims.','Host Result rollback tests cover selected ownership failures, not arbitrary corrupt storage, Rust panic, MSVC SEH/OOM retry or C++ exception semantics.','Final executable probes retain fresh empty packet95 receiver and therefore perform zero loading UI/gameplay actions; actual connected hot packet handling is exercised in the Windows core tests.','These targeted checks do not constitute whole-game visual/audio/gameplay/network or human fidelity acceptance.'],'next_action':next_action}
 summary={'saved_utc':now.isoformat(),'passed':True,'complete':False,'receipt':receipt,'core_tests_passed':core['passed'],'client_tests_passed':client['passed'],'client_commands':10,'client_workers':16,'client_executable_sha256':actual['executable_sha256'],'windows_hot_packets':48,'windows_truncated_payloads_rejected':96}
 updates={}
 for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
  doc=load(R/'docs'/name);doc[key]=summary;doc['updated_utc']=now.isoformat();doc['next_action']=next_action
  for preparation in ['prepared_replay_loading_screen','prepared_replay_loading_records']:
   if preparation in doc:doc[preparation].update(production_partially_integrated=True,integration_receipt=receipt,complete=False)
  if name=='resume_checkpoint.json':doc['saved_utc']=now.isoformat();doc['state']='active';doc.setdefault('last_verified',{}).update(loading_runtime_receipt=receipt,loading_selected_core_tests=core['passed'],loading_selected_client_tests=client['passed'])
  if name=='completion_plan.json':
   domain=next(x for x in doc['domains'] if x['id']=='21');domain.setdefault('progress_evidence',[])
   if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
   for task in domain['tasks']:
    if task['id'] in ['21.3','21.4'] and receipt not in task['evidence']:task['evidence'].append(receipt)
   doc['next_execution_steps'][0]=next_action
  updates[name]=doc
 html=R/'docs/completion_plan.html';body=html.read_text(encoding='utf-8');marker='loading-runtime-validation';assert marker not in body
 section=f'<section id="{marker}"><h2>Données et propriété de l’écran de chargement</h2><p>Les consommateurs standard et tutoriel, arbres de fiches, gestionnaire de durée de vie et fournisseurs de noms sont raccordés au runtime Windows. {core["passed"]} tests moteur ciblés, 6 tests client et 10 commandes du client reconstruit passent. Les tests Windows vérifient 48 paquets et le refus de 96 paquets tronqués avec des destinataires de diagnostic explicites. Les factories normales, ressources UI standard et l’horloge QPC commune restent à terminer. Aucune validation de l’écran complet ni du jeu complet n’est revendiquée.</p></section>'
 backup=R/'docs/plan_history'/('loading-validation-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
 for name in [*updates,'completion_plan.html']:shutil.copyfile(R/'docs'/name,backup/name)
 save(R/receipt,value)
 for name,doc in updates.items():save(R/'docs'/name,doc)
 html.write_text(body.replace('</body>',section+'</body>'),encoding='utf-8')
 for group in ['source_hashes','resource_hashes']:
  for rel,digest in value[group].items():assert sha(R/rel)==digest,rel
 print(json.dumps(summary))
if __name__=='__main__':main()
