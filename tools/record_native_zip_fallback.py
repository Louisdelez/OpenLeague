from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
testlog='logs/native-zip-fallback-tests.log';buildlog='logs/native-zip-fallback-build.log'
assert '273 passed; 0 failed' in (r/testlog).read_text(encoding='utf-8')
assert 'Finished' in (r/buildlog).read_text(encoding='utf-8')
fallback=load('data/4.20/native_zip_fallback_contract.json');assert fallback['passed'] and fallback['case_count']==20
filename=load('data/4.20/native_texture_filename_contract.json');assert filename['passed'] and filename['case_count']==608
captures=load('docs/native_zip_fallback_profiles_capture.json');assert captures['visual_inspected'] and captures['archive_restored'] and captures['user_config_unchanged'] and len(captures['captures'])==2
assert captures['client_sha256']==sha('target/debug/openleague-client.exe') and not (r/'Config/Game.cfg').exists()
assert sha('data/4.20/archives/menu/HUD.zip')==captures['archive_original_sha256']
for c in captures['captures']:
 assert c['visual_inspected'] and c['client_sha256']==captures['client_sha256'] and c['archive_entries']==1066 and c['fast_hud_bytes']==1607 and c['chat_bytes']==1773
 assert hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()==c['capture_sha256']
assert [c['missing_eocd_in_last399'] for c in captures['captures']]==[False,True]
build=dict(updated_utc=now,game_complete=False,scope='Client ZIP fallback rebuild and two diagnostic captures; no complete HUD/map/game qualification.',executables=[dict(path='target/debug/openleague-client.exe',bytes=(r/'target/debug/openleague-client.exe').stat().st_size,sha256=sha('target/debug/openleague-client.exe'))],client_source_tests=273,test_log=testlog,build_log=buildlog,runtime_proof='docs/native_zip_fallback_profiles_capture.json')
save('docs/native_zip_fallback_build_receipt.json',build)
artifacts=['data/4.20/native_zip_fallback_contract.json','data/4.20/native_zip_open_contract.json','data/4.20/native_zip_payload_contract.json','data/4.20/native_texture_filename_contract.json','crates/client/src/native_zip_archive.rs',testlog,buildlog,'docs/native_zip_fallback_profiles_capture.json','docs/native_zip_fallback_build_receipt.json']
action='Scanner ZIP natif8B9A10 porté et connecté à l’ouverture ;20cas comparés, métadonnée indéfinie remplacée par0 sans modifier l’offset de données valide.273tests passent,1066ressources comparées exactement via index central et scanner de secours. Client reconstruit ; deux captures inspectées avec HUD.zip original puis EOCD retiré,1066entrées et HUD/configurations chargés ; archive restaurée. Qualifier l’énumération native des répertoires et la résolution TGA/DDS du chargeur de textures, puis appliquer le HUD historique à partir des fichiers/atlas originaux. Achever cache/options/rechargement, carte/zones bleues, partie complète à six clients graphiques et les24domaines.'
receipt=dict(updated_utc=now,complete=False,client_source_tests_passed=273,client_application_rebuilt=True,client_test_source_matches_current_build=True,application_binary_sha256=sha('target/debug/openleague-client.exe'),native_zip_fallback_cases=20,archive_fallback_scanner_ported=True,archive_fallback_scanner_runtime_integrated=True,original_payloads_compared_through_central_and_fallback=1066,safe_undefined_local_offset_substitute=0,archive_restored=True,captures=captures,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},limits=['Native scanner’s local-offset word is undefined; safe Rust stores0, and initialized cached data offsets preserve qualified payload reads.','Short/long/malformed streams, allocation errors, descriptors and ZIP64 remain open.','Runtime fallback selected by missing-EOCD input and qualified reader; no separate internal branch trace captured.','Native directory enumeration/texture extension routing/HUD layout, cache and complete map/game remain open.','Chaos blue uncovered regions remain visible.'],next_action=action)
action=action.replace('Qualifier l’énumération native des répertoires et la résolution TGA/DDS du chargeur de textures, puis appliquer le HUD historique à partir des fichiers/atlas originaux.','Normalisation des noms de textures97D0A0 qualifiée sur608cas : trim initial espaces/tabulations, trim final espaces, NONE vide, premier .tga insensible à la casse remplacé par .dds ;16sous-écritures natives observées sur sorties vides. Porter les octets de sortie sans reproduire ces écritures invalides, raccorder les atlas HUD puis appliquer les dispositions originales. Qualifier aussi l’énumération native des répertoires et le chargeur/caches de textures.')
receipt.update(native_texture_filename_cases=608,native_texture_filename_ported=False,next_action=action)
save('docs/native_zip_fallback_progress.json',receipt)
snapshot=r/'docs/plan_history'/('native-zip-fallback-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));snapshot.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,snapshot/name);d=load(p);d.update(updated_utc=now,complete=False,native_zip_fallback_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=273,client_tests_current_binary=False,client_test_source_matches_current_build=True,native_zip_fallback_runtime=True,native_zip_fallback_cases=20,current_client_build_receipt='docs/native_zip_fallback_build_receipt.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Scanner ZIP de secours intégré</h2><p>273tests passent.20cas natifs de scanner ;1066ressources comparées exactement par les deux lecteurs. Client reconstruit, captures originale/EOCD retiré inspectées, archive restaurée. Résolution des textures, HUD historique, cache, carte complète et jeu restent ouverts.</p><a href="native_zip_fallback_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
for name in ['record_native_zip_fallback.py','inspect_native_texture_extensions.py']:
 p=Path(__file__).parent/name
 if p.resolve()!=(r/'tools'/name).resolve():shutil.copy2(p,r/'tools'/name)
print(json.dumps(dict(client_tests=273,captures=2,archive_restored=True,application_sha256=receipt['application_binary_sha256'],complete=False)))
