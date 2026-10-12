from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
policy=load('data/4.20/native_config_cache_policy_contract.json');flow=load('data/4.20/native_config_cache_reload_flow_contract.json');ctor=load('data/4.20/native_config_constructor_contract.json')
for proof,count in [(policy,1080),(flow,3456),(ctor,256)]:assert proof['passed'] and proof['case_count']==count
assert len({p['native_sha256'] for p in [policy,flow,ctor]})==1
assert '258 passed; 0 failed' in (r/'logs/native-config-cache-reload-tests.log').read_text(encoding='utf-8')
assert sha('target/debug/openleague-client.exe')=='e7a98a4e513f5a569e2c508c5baf3d8813a58fc67ff0876c25fecdebdb391123'
action='Politique du cache portée sur1080cas ; plan des appels de rechargement/localisation porté sur3456cas natifs, constructeurs/ressources/dictionnaire adaptés ;258tests client passent. Constructeur8AD5B0 qualifié sur256cas : binaire demandé puis défaut, flags et garde de lecture texte ; pas encore porté/intégré. Cache complet/runtime/menu/persistance restent ouverts. Qualifier8AEB70 et son chargeur8AEC00, fusion texte utilisateur puis défaut et API ressource8B4EF0/8B5170, puis intégrer les fichiers/cache/options. Reconstruire le client actuel, vérifier classification/chemins/profils ; poursuivre variantes/LOD/Wall_of_Grass, rendu Chaos/zones bleues, cérémonie/audio/sbires/reconnexion/résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_config_cache_policy_contract.json','data/4.20/native_config_cache_reload_flow_contract.json','data/4.20/native_config_constructor_contract.json','crates/client/src/native_config_cache.rs','crates/client/src/native_config_cache_reload.rs','crates/client/src/main.rs','logs/native-config-cache-reload-tests.log']
receipt=dict(updated_utc=now,complete=False,native_cache_policy_cases=1080,native_cache_reload_cases=3456,native_cache_reload_addresses=flow['native_addresses'],native_constructor_cases=256,native_constructor_addresses=ctor['native_addresses'],cache_policy_ported=True,reload_call_plan_ported=True,reload_plan_connected_to_runtime=False,constructor_ported=False,complete_configuration_cache_qualified=False,localized_filename_control_flow_qualified=True,localized_resource_predicate_qualified=False,option_menu_and_live_persistence_complete=False,client_source_tests_passed=258,client_test_source_matches_current_build=False,application_rebuilt_after_cache_port=False,application_binary_sha256=sha('target/debug/openleague-client.exe'),artifacts=artifacts,hashes={p:sha(p) for p in artifacts},adapters=policy['adapters']+flow['adapters']+ctor['adapters'],limits=policy['limits']+flow['limits']+ctor['limits'],next_action=action)
save('docs/native_config_cache_progress.json',receipt)
archive=r/'docs/plan_history'/('native-config-cache-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_config_cache_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=258,client_tests_current_binary=False,client_test_source_matches_current_build=False,native_config_cache_policy_cases=1080,native_config_cache_policy_ported=True,native_config_cache_reload_cases=3456,native_config_cache_reload_plan_ported=True,native_config_constructor_cases=256,native_config_constructor_ported=False)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8');text=text.replace('</body>','<section><h2>Cache et configuration : progression vérifiée</h2><p>258tests des sources client réussis. Politique de cache portée sur1080cas ; plan de rechargement/localisation porté sur3456cas. Constructeur natif qualifié sur256cas avec chargeurs adaptés. Cache intégré, lecture des ressources, menu/persistance et fidélité complète encore ouverts. Sources plus récentes que le dernier exécutable e7a98a.</p><a href="native_config_cache_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(client_tests=258,cache_cases=1080,reload_cases=3456,constructor_cases=256,complete=False)))
