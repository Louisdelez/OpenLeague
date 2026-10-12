from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
text=load('data/4.20/native_text_config_lookup_contract.json');typed=load('data/4.20/native_typed_config_integer_contract.json')
assert text['passed'] and text['case_count']==2859 and typed['passed'] and typed['case_count']==1260
log=(r/'logs/native-text-config-lookup-tests.log').read_text(encoding='utf-8');assert '250 passed; 0 failed' in log
action='Recherche texte native8AE0E0 et table5C6830 exécutées sur2859cas puis comportement porté en Rust ;250tests des sources client passent. Convertisseur typé8AE340 qualifié sur1260cas (priorité entier/flottant/booléen/texte), encore à porter. Porter cette conversion, qualifier stockage typé INIBIN, cache8ACEF0 et chemin utilisateur. Relier fichier utilisateur/menu/persistance puis reconstruire et vérifier profils bas/haut. Achever variantes/LOD, Wall_of_Grass/options globales, rendu Chaos, cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_text_config_lookup_contract.json','data/4.20/native_typed_config_integer_contract.json','crates/client/src/native_game_cfg_text.rs','crates/client/src/native_graphics_options.rs','logs/native-text-config-lookup-tests.log']
receipt=dict(updated_utc=now,complete=False,native_text_lookup_cases=2859,native_text_lookup_addresses=text['native_addresses'],native_hash_bucket_find_executed=True,original_default_entries=387,text_lookup_semantics_ported_to_rust=True,native_typed_integer_conversion_cases=1260,native_typed_integer_conversion_addresses=typed['native_addresses'],typed_conversion_ported_to_rust=False,typed_storage_qualified=False,configuration_cache_qualified=False,actual_user_file_loaded=False,live_user_options_bound=False,client_source_tests_passed=250,client_tests_current_binary=False,application_binary_sha256=sha('target/debug/openleague-client.exe'),artifacts=artifacts,hashes={p:sha(p) for p in artifacts},adapters=text['adapters']+typed['adapters'],limits=text['limits']+typed['limits'],next_action=action)
save('docs/native_text_config_lookup_progress.json',receipt)
archive=r/'docs/plan_history'/('native-text-config-lookup-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_text_config_lookup_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=250,client_tests_current_binary=False,native_text_lookup_cases=2859,native_typed_integer_conversion_cases=1260,text_lookup_ported=True,typed_integer_conversion_ported=False)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Recherche et conversion natives de configuration</h2><p>Recherche texte et table de hachage originales :2859cas vérifiés, comportement intégré en Rust ;250tests des sources réussis. Conversion typée native :1260cas qualifiés, port Rust encore ouvert. Cache, stockage typé, fichier utilisateur, menu et persistance restent ouverts ; nouvel exécutable de jeu non qualifié.</p><a href="native_text_config_lookup_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['record_native_text_config_lookup.py','inspect_native_text_lookup_complete.py','inspect_native_map_hash_helper.py']:shutil.copy2(Path(__file__).parent/name,r/'tools'/name)
print(json.dumps(dict(client_source_tests=250,native_text_lookup_cases=2859,native_typed_conversion_cases=1260,complete=False)))
