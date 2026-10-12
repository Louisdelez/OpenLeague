from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
merge=load('data/4.20/native_config_text_merge_contract.json');flow=load('data/4.20/native_config_text_file_flow_contract.json');dispatch=load('data/4.20/native_config_resource_dispatch_contract.json')
for proof,count in [(merge,60),(flow,60),(dispatch,7695)]:assert proof['passed'] and proof['case_count']==count
assert '260 passed; 0 failed' in (r/'logs/native-config-text-file-flow-tests.log').read_text(encoding='utf-8')
assert 'Finished' in (r/'logs/native-config-text-flow-build.log').read_text(encoding='utf-8')
captures=load('docs/native_config_text_profiles_capture.json');assert captures['configuration_restored'] and len(captures['captures'])==3 and not (r/'Config/Game.cfg').exists()
assert captures['client_sha256']==sha('target/debug/openleague-client.exe');assert [p['actual_environment_quality'] for p in captures['captures']]==[3,1,4]
for p in captures['captures']:
 assert p['native_text_merge_loaded'] and p['merged_entries']==387 and p['actual_layout_mode']==0
 assert Path(p['capture']).is_file() and hashlib.sha256(Path(p['capture']).read_bytes()).hexdigest()==p['capture_sha256']
 # All three frames inspected explicitly before invoking this recorder.
 p['visual_inspected']=True
 save('docs/chaos_base_config_text_flow_'+p['configuration_profile']+'_capture.json',p)
captures['visual_inspected']=True;save('docs/native_config_text_profiles_capture.json',captures)
action='Fusion native utilisateur(flag0) puis défaut(flag1) et statut des fichiers vides portés dans le chargement réel ;260tests client passent. Client reconstruit et trois captures inspectées : mode0/scores[2,0,1],387entrées, profils3/1/4 ; configuration temporaire restaurée. Ressources natives : dispatch8B4EF0/8B5170 qualifié sur7695cas, fournisseurs encore adaptés/non portés. Porter les fournisseurs/path resolver/constructeur et le cache complet ; intégrer rechargement/menu/persistance/overlays, puis variantes/LOD/Wall_of_Grass et options globales. Poursuivre rendu Chaos/zones bleues avec références natives, cérémonie/audio/sbires/reconnexion/résultats/retour launcher, partie ordinaire à six clients graphiques et les24domaines.'
build=dict(updated_utc=now,game_complete=False,scope='Client configuration rebuild only; no server/launcher rebuild or full game acceptance.',executables=[dict(path='target/debug/openleague-client.exe',bytes=(r/'target/debug/openleague-client.exe').stat().st_size,sha256=sha('target/debug/openleague-client.exe'))],client_source_tests=260,test_log='logs/native-config-text-file-flow-tests.log',build_log='logs/native-config-text-flow-build.log',runtime_proof='docs/native_config_text_profiles_capture.json')
save('docs/native_config_text_flow_build_receipt.json',build)
artifacts=['data/4.20/native_config_text_merge_contract.json','data/4.20/native_config_text_file_flow_contract.json','data/4.20/native_config_resource_dispatch_contract.json','crates/client/src/native_game_cfg_text.rs','crates/client/src/native_user_settings.rs','crates/client/src/native_config_layout.rs','crates/client/src/main.rs','logs/native-config-text-file-flow-tests.log','logs/native-config-text-flow-build.log','docs/native_config_text_profiles_capture.json','docs/native_config_text_flow_build_receipt.json']
receipt=dict(updated_utc=now,complete=False,native_text_merge_cases=60,native_file_flow_cases=60,native_resource_dispatch_cases=7695,native_text_merge_ported=True,text_file_status_ported=True,merged_table_connected_to_runtime=True,resource_dispatch_ported=False,complete_resource_providers_qualified=False,complete_cache_integrated=False,menu_and_live_persistence_complete=False,client_source_tests_passed=260,client_test_source_matches_current_build=True,client_application_rebuilt=True,application_binary_sha256=sha('target/debug/openleague-client.exe'),captures=captures,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},adapters=merge['adapters']+flow['adapters']+dispatch['adapters'],limits=merge['limits']+flow['limits']+dispatch['limits']+['Source test executable and rebuilt app share current source; graphical startup/configuration captures only, not full production-game regression acceptance.','Three fixed diagnostic camera captures with normal server; no original framebuffer equivalence or completed six-client match.'],next_action=action)
save('docs/native_config_text_flow_progress.json',receipt)
receipt['limits'].append('Inspected frames still show blue uncovered regions at the Chaos base; no whole-map visual fidelity or gap repair completion claim.')
save('docs/native_config_text_flow_progress.json',receipt)
archive=r/'docs/plan_history'/('native-config-text-flow-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_config_text_flow_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=260,client_tests_current_binary=False,client_test_source_matches_current_build=True,native_text_merge_cases=60,native_file_flow_cases=60,native_resource_dispatch_cases=7695,native_text_merge_runtime=True,native_configuration_current_build_captures=3,current_client_build_receipt='docs/native_config_text_flow_build_receipt.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8');text=text.replace('</body>','<section><h2>Lecture des configurations intégrée</h2><p>Fusion utilisateur puis défaut et statut natif des fichiers vides intégrés au lecteur réel. 260tests réussis ; application reconstruite, trois captures inspectées : mode0,387entrées, profils3/1/4. Dispatch ressources qualifié sur7695cas avec fournisseurs adaptés. Cache complet, menu/persistance et qualification intégrale du jeu restent ouverts.</p><a href="native_config_text_flow_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
for name in ['record_native_config_text_flow.py','inspect_native_config_resource_open.py','prepare_native_config_text_profiles.py']:shutil.copy2(Path(__file__).parent/name,r/'tools'/name)
print(json.dumps(dict(client_tests=260,application_sha256=receipt['application_binary_sha256'],captures=3,complete=False)))
