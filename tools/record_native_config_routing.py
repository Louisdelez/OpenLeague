from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
contract=load('data/4.20/native_integer_config_routing_contract.json');assert contract['passed'] and contract['case_count']==1296
log=(r/'logs/native-config-routing-tests.log').read_text(encoding='utf-8');assert '245 passed; 0 failed' in log
match=re.search(r'Running unittests[^\n]*\((target[^\r\n)]+\.exe)\)',log);assert match
test_exe=r/match.group(1).replace('\\','/');assert test_exe.exists()
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
binary=sha('target/debug/openleague-client.exe');assert binary=='df190492f0160a982ac7cdfab28560f1e05a6c6a3fe4b83dbd603c769a559d5c'
action='Qualifier le lecteur entier8AF830, ses conversions texte/typées et le cache8ACEF0/initialisation du chemin utilisateur. Ordre natif defaults Game.cfg puis fichier utilisateur, surcouche avant source principale et conservation du résultat précédent désormais exécuté sur1296cas et porté en Rust. Les245tests des sources passent ; dernier exécutable df1904 reste antérieur. Relier ensuite configuration réelle, menu/persistance, variantes/LOD/matériaux, reconstruire et vérifier profils bas/haut en frame réelle. Puis passe Wall_of_Grass/options globales, référence/rendu Chaos, cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_integer_config_routing_contract.json','crates/client/src/native_graphics_options.rs','logs/native-config-routing-tests.log']
receipt=dict(updated_utc=now,complete=False,native_routing_cases=1296,native_addresses=contract['native_addresses'],routing_ported_to_rust=True,configuration_parser_qualified=False,actual_user_file_loaded=False,live_user_options_bound=False,client_source_tests_passed=245,client_tests_current_binary=False,application_binary_unchanged=True,application_binary_sha256=binary,test_executable=str(test_exe),test_executable_sha256=hashlib.sha256(test_exe.read_bytes()).hexdigest(),artifacts=artifacts,hashes={p:sha(p) for p in artifacts},findings=contract['findings'],limits=contract['limits']+contract['adapters'],next_action=action)
save('docs/native_config_routing_progress.json',receipt)
archive=r/'docs/plan_history'/('native-config-routing-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_config_routing_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=245,client_tests_current_binary=False,native_integer_config_routing_cases=1296)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Ordre natif des configurations porté</h2><p>1296cas du getter original : configuration par défaut puis utilisateur, surcouche avant source principale, conservation du résultat précédent.245tests des sources passent. Parsing, chargement réel, menu et persistance encore ouverts ; exécutable précédent conservé.</p><a href="native_config_routing_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['inspect_native_integer_config.py','inspect_native_integer_reader.py','inspect_integer_config_tail.py','record_native_config_routing.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(client_source_tests=245,native_routing_cases=1296,game_binary_unchanged=True,complete=False)))
