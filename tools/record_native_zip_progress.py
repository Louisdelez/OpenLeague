from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
log='logs/native-zip-local-header-tests.log'
assert '267 passed; 0 failed' in (r/log).read_text(encoding='utf-8')
paths=['data/4.20/native_archive_index_lookup_contract.json','data/4.20/native_zip_local_header_contract.json','data/4.20/native_zip_original_headers_contract.json']
proofs=[load(p) for p in paths];assert all(p['passed'] for p in proofs)
assert [p['case_count'] for p in proofs]==[720,216,1066]
artifacts=paths+['crates/client/src/native_archive_index.rs','crates/client/src/native_zip_local_header.rs',log]
action='267 tests client passent. Index d’archives porté sur720cas, normalisation sur188cas ; offsets ZIP portés sur216cas, vérifiés nativement sur1066entrées des5archives originales. Intégrer montage/indexation natifs, lecture stockée et DEFLATE, puis fournisseur ZIP et cache complet au runtime. Reconstituer le client après intégration et qualifier ressources/HUD/rendu. Poursuivre les24domaines, partie complète à six clients graphiques et livraison.'
receipt=dict(updated_utc=now,complete=False,client_source_tests_passed=267,archive_index_cases=720,archive_path_cases=188,zip_local_header_cases=216,original_zip_header_cases=1066,original_archives=5,archive_index_ported=True,zip_local_header_ported=True,archive_provider_runtime_integrated=False,client_application_rebuilt=False,client_test_source_matches_current_build=False,artifacts=artifacts,hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in artifacts},limits=['Source tests only; production executable/captures still correspond to prior264-test source.','Archive index input tables supplied; native mounting/insertion/duplicate handling not qualified.','Original ZIP headers qualified; stored/DEFLATE payload loading, resource routing, complete HUD and game remain open.'],next_action=action)
save('docs/native_zip_progress.json',receipt)
snapshot=r/'docs/plan_history'/('native-zip-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));snapshot.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,snapshot/name);d=load(p);d.update(updated_utc=now,complete=False,native_zip_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
 evidence.update(client_tests=267,client_tests_current_binary=False,client_test_source_matches_current_build=False,native_archive_index_cases=720,native_zip_local_header_cases=216,native_zip_original_header_cases=1066,current_client_source_test_receipt='docs/native_zip_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8');text=text.replace('</body>','<section><h2>Archives ZIP : index et offsets</h2><p>267tests source passent. Index720cas, normalisation188cas ; offsets216cas,1066en-têtes originaux vérifiés dans5archives. Fournisseur ZIP, décompression et intégration runtime restent ouverts. Application précédente encore qualifiée sur264tests.</p><a href="native_zip_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(client_source_tests=267,production_rebuilt=False,complete=False)))
