from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
flow=load('data/4.20/native_filesystem_text_flow_contract.json');archive_path=load('data/4.20/native_archive_path_normalization_contract.json')
assert flow['passed'] and flow['case_count']==60 and flow['filesystem_provider_executed']
assert archive_path['passed'] and archive_path['case_count']==188
assert '264 passed; 0 failed' in (r/'logs/native-filesystem-provider-tests.log').read_text(encoding='utf-8')
assert 'Finished' in (r/'logs/native-filesystem-provider-build.log').read_text(encoding='utf-8')
captures=load('docs/native_filesystem_profiles_capture.json');assert captures['configuration_restored'] and len(captures['captures'])==3 and not (r/'Config/Game.cfg').exists()
assert captures['client_sha256']==sha('target/debug/openleague-client.exe');assert [p['actual_environment_quality'] for p in captures['captures']]==[3,1,4]
for p in captures['captures']:
 assert p['native_text_merge_loaded'] and p['merged_entries']==387 and p['actual_layout_mode']==0
 assert hashlib.sha256(Path(p['capture']).read_bytes()).hexdigest()==p['capture_sha256']
 # Explicitly inspect all three images before invoking this recorder.
 p['visual_inspected']=True;save('docs/chaos_base_filesystem_provider_'+p['configuration_profile']+'_capture.json',p)
captures['visual_inspected']=True;save('docs/native_filesystem_profiles_capture.json',captures)
action='Fournisseur simple8B6280/8B6360 et flux8B5F90 exécutés dans60cas natifs ; port Rust connecté au chargement réel via CRT Windows hôte, lectures de fichiers réels comparées aux60cas ;264tests passent. Client reconstruit, trois captures inspectées :387entrées, mode0, profils3/1/4 ; fichier temporaire restauré. Normalisation propre aux archives8B68A0 qualifiée sur188cas, casse conservée, règles distinctes du cache et sous-écriture native observée pour sorties vides ; pas encore portée. Qualifier et porter dictionnaire/index/archives/stream décompressé puis chargeur binaire/constructeur/cache/lifetime ; intégrer rechargement/menu/persistance. Requalifier l’application après changements ; poursuivre variantes/LOD/Wall_of_Grass, rendu Chaos/zones bleues, cérémonie/audio/sbires/reconnexion/résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
build=dict(updated_utc=now,game_complete=False,scope='Client configuration/Windows CRT provider rebuild only; no server/launcher rebuild or full game acceptance.',executables=[dict(path='target/debug/openleague-client.exe',bytes=(r/'target/debug/openleague-client.exe').stat().st_size,sha256=sha('target/debug/openleague-client.exe'))],client_source_tests=264,test_log='logs/native-filesystem-provider-tests.log',build_log='logs/native-filesystem-provider-build.log',runtime_proof='docs/native_filesystem_profiles_capture.json')
save('docs/native_filesystem_provider_build_receipt.json',build)
artifacts=['data/4.20/native_filesystem_text_flow_contract.json','data/4.20/native_archive_path_normalization_contract.json','crates/client/src/native_filesystem_provider.rs','crates/client/src/native_user_settings.rs','crates/client/src/main.rs','logs/native-filesystem-provider-tests.log','logs/native-filesystem-provider-build.log','docs/native_filesystem_profiles_capture.json','docs/native_filesystem_provider_build_receipt.json']
receipt=dict(updated_utc=now,complete=False,native_filesystem_text_flow_cases=60,native_filesystem_text_flow_addresses=flow['native_addresses'],filesystem_provider_ported=True,filesystem_provider_connected_to_runtime=True,host_windows_crt_real_files_compared=True,historical_32bit_crt_abi_equivalence_qualified=False,archive_path_cases=188,archive_path_ported=False,archive_provider_complete=False,complete_cache_integrated=False,menu_and_live_persistence_complete=False,client_source_tests_passed=264,client_test_source_matches_current_build=True,client_application_rebuilt=True,application_binary_sha256=sha('target/debug/openleague-client.exe'),captures=captures,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},adapters=flow['adapters']+archive_path['adapters'],limits=flow['limits']+archive_path['limits']+['Rust port uses host Windows CRT and ASCII regular-file read scope; historical32-bit CRT internals/ABI, non-ASCII encodings, archives, negative ftell/exception/concurrent I/O paths remain open.','Three fixed diagnostic camera captures with normal local server; no original framebuffer equivalence, complete six-client match or complete map fidelity.','Inspected Chaos base still has blue uncovered regions; no repair-completion claim.'],next_action=action)
save('docs/native_filesystem_provider_progress.json',receipt)
snapshot=r/'docs/plan_history'/('native-filesystem-provider-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));snapshot.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,snapshot/name);d=load(p);d.update(updated_utc=now,complete=False,native_filesystem_provider_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=264,client_tests_current_binary=False,client_test_source_matches_current_build=True,native_filesystem_provider_runtime=True,native_filesystem_text_flow_cases=60,native_archive_path_cases=188,native_configuration_current_build_captures=3,current_client_build_receipt='docs/native_filesystem_provider_build_receipt.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8');text=text.replace('</body>','<section><h2>Fournisseur de fichiers intégré</h2><p>Fournisseur simple et flux natifs vérifiés sur60cas ; port Rust via CRT Windows connecté aux fichiers réels.264tests réussis. Client reconstruit, trois captures inspectées :387entrées, mode0, profils3/1/4. Normalisation des archives qualifiée sur188cas, non portée ; archives/cache complet/menu/persistance et jeu intégral restent ouverts.</p><a href="native_filesystem_provider_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
for name in ['record_native_filesystem_provider.py','prepare_native_filesystem_profiles.py']:shutil.copy2(Path(__file__).parent/name,r/'tools'/name)
print(json.dumps(dict(client_tests=264,application_sha256=receipt['application_binary_sha256'],captures=3,complete=False)))
