from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
testlog='logs/native-zip-provider-tests.log';buildlog='logs/native-zip-provider-build.log'
assert '272 passed; 0 failed' in (r/testlog).read_text(encoding='utf-8')
assert 'Finished' in (r/buildlog).read_text(encoding='utf-8')
proof_paths=['data/4.20/native_zip_central_directory_contract.json','data/4.20/native_zip_open_contract.json','data/4.20/native_zip_duplicate_index_contract.json','data/4.20/native_zip_payload_contract.json','data/4.20/native_zip_fallback_contract.json']
proofs=[load(p) for p in proof_paths];assert all(p['passed'] for p in proofs)
assert [p['case_count'] for p in proofs]==[20,25,72,1066,20]
payload=proofs[3];assert payload['native_codec_executed'] and payload['golden']['bytes']==48570309
assert sha(payload['golden']['path'])==payload['golden']['sha256']
for a in payload['archives']:assert sha(a['path'])==a['sha256']
capture=load('docs/chaos_base_zip_provider_capture.json');assert capture['visual_inspected'],'Inspect the actual capture before recording.'
assert capture['client_sha256']==sha('target/debug/openleague-client.exe') and capture['archive_count']==5 and capture['archive_entries']==1066 and capture['unique_archive_names']==1065
assert capture['fast_hud_bytes']==1607 and capture['chat_bytes']==1773 and capture['merged_config_entries']==387 and capture['user_config_unchanged'] and not (r/'Config/Game.cfg').exists()
assert hashlib.sha256(Path(capture['capture']).read_bytes()).hexdigest()==capture['capture_sha256']
build=dict(updated_utc=now,game_complete=False,scope='Client ZIP provider rebuild and one normal-server diagnostic capture; no complete HUD/game/six-client match qualification.',executables=[dict(path='target/debug/openleague-client.exe',bytes=(r/'target/debug/openleague-client.exe').stat().st_size,sha256=sha('target/debug/openleague-client.exe'))],client_source_tests=272,test_log=testlog,build_log=buildlog,runtime_proof='docs/chaos_base_zip_provider_capture.json')
save('docs/native_zip_provider_build_receipt.json',build)
artifacts=proof_paths+[a['path'] for a in payload['archives']]+[payload['golden']['path'],'data/4.20/native_zip_catalog.json','crates/client/Cargo.toml','Cargo.lock','crates/client/src/native_zip_archive.rs','crates/client/src/native_zip_provider.rs','crates/client/src/native_user_settings.rs','crates/client/src/main.rs',testlog,buildlog,'docs/chaos_base_zip_provider_capture.json','docs/native_zip_provider_build_receipt.json']
action='Fournisseur ZIP connecté au démarrage et aux configurations ;5archives/1066entrées/1065noms. Lecteur central20cas, ouverture25cas, doublons72cas portés ; lecture/DEFLATE d’origine vérifiée sur1066ressources/48570309octets, comparaison Rust exacte ;272tests passent. Client reconstruit et capture inspectée, HUD original lu mais disposition non appliquée. Scanner ZIP de secours qualifié sur20cas, pas encore porté ; son premier mot de métadonnées est indéfini, offset de données mis en cache valide. Porter ce scanner puis alias/résolution des extensions, ordre natif de montage et branches d’erreur ; achever cache/options/rechargement et HUD historique à partir des ressources. Poursuivre les24domaines, carte/zones bleues, partie complète à six clients graphiques et livraison.'
receipt=dict(updated_utc=now,complete=False,client_source_tests_passed=272,client_application_rebuilt=True,client_test_source_matches_current_build=True,application_binary_sha256=sha('target/debug/openleague-client.exe'),zip_archive_provider_runtime=True,zip_resource_archives=5,zip_resource_entries=1066,zip_unique_primary_names=1065,native_zip_central_directory_cases=20,native_zip_open_cases=25,native_zip_duplicate_index_cases=72,native_zip_payload_cases=1066,native_zip_decoded_bytes=48570309,native_original_inflater_executed=True,rust_payloads_match_native_byte_for_byte=True,native_hud_config_loaded=True,native_hud_layout_applied=False,complete_cache_integrated=False,archive_alias_registration_complete=False,archive_fallback_scanner_complete=False,historical_mount_enumeration_qualified=False,capture=capture,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},limits=['ZIP subset qualified on all five original archives; malformed/short streams, long names, allocation errors, vector growth and ZIP fallback scanner remain open.','Explicit recovered catalog mount order; historical enumeration, alias registration/extension resolution and native insertion/rehash ownership remain open.','HUD configuration bytes loaded, layout not yet applied; no complete HUD, full game, original framebuffer equivalence or ordinary six-client completed match.','Rendered map retains blue uncovered regions; no full map repair-completion claim.'],next_action=action)
receipt.update(native_zip_fallback_cases=20,archive_fallback_scanner_ported=False)
save('docs/native_zip_provider_progress.json',receipt)
snapshot=r/'docs/plan_history'/('native-zip-provider-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));snapshot.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,snapshot/name);d=load(p);d.update(updated_utc=now,complete=False,native_zip_provider_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=272,client_tests_current_binary=False,client_test_source_matches_current_build=True,native_zip_archive_provider_runtime=True,native_zip_payload_cases=1066,native_zip_decoded_bytes=48570309,current_client_build_receipt='docs/native_zip_provider_build_receipt.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Fournisseur ZIP intégré</h2><p>5archives,1066ressources ;48,6Mo décodés par le lecteur original et comparés exactement au port Rust.272tests passent. Client reconstruit, capture inspectée :archives/HUD/configuration chargés. Disposition HUD, alias/scanner de secours/cache complet, zones bleues et jeu intégral restent ouverts.</p><a href="native_zip_provider_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(client_tests=272,archives=5,payloads=1066,decoded_bytes=48570309,application_sha256=receipt['application_binary_sha256'],complete=False)))
