from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
atoi=load('data/4.20/native_config_atoi_contract.json');reader=load('data/4.20/native_integer_value_reader_contract.json');config=load('docs/native_game_config_recovery.json')
assert atoi['passed'] and atoi['case_count']==1962 and reader['passed'] and reader['case_count']==1440 and config['byte_exact']
log=(r/'logs/native-integer-value-reader-tests.log').read_text(encoding='utf-8');assert '247 passed; 0 failed' in log
match=re.search(r'Running unittests[^\n]*\((target[^\r\n)]+\.exe)\)',log);assert match
test_exe=r/match.group(1).replace('\\','/');assert test_exe.exists()
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
binary=sha('target/debug/openleague-client.exe');assert binary=='df190492f0160a982ac7cdfab28560f1e05a6c6a3fe4b83dbd603c769a559d5c'
action='Qualifier le parseur texte et le cache de configuration8ACEF0, initialisation du chemin utilisateur et lookup8AE0E0/8AE340. Game.cfg original récupéré byte-exact :14789octets, Performance/EnvironmentQuality=3 en source brute ; pas encore chargé au runtime. Conversion CRT1962cas et lecteur entier1440cas portés en Rust ;247tests des sources passent, exécutable df1904 antérieur. Relier ensuite fichiers réels, menu/persistance, variantes/LOD/matériaux ; reconstruire et vérifier profils bas/haut en frame. Puis passe Wall_of_Grass/options globales, référence/rendu Chaos, cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_config_atoi_contract.json','data/4.20/native_integer_value_reader_contract.json','data/4.20/configuration/defaults/Game.cfg','docs/native_game_config_recovery.json','crates/client/src/native_graphics_options.rs','logs/native-config-atoi-tests.log','logs/native-integer-value-reader-tests.log']
receipt=dict(updated_utc=now,complete=False,native_atoi_cases=1962,native_atoi_addresses=atoi['native_addresses'],native_value_reader_cases=1440,native_value_reader_addresses=reader['native_addresses'],integer_numeric_and_reader_ported_to_rust=True,configuration_text_parser_qualified=False,actual_user_file_loaded=False,live_user_options_bound=False,native_game_config_recovery=config,client_source_tests_passed=247,client_tests_current_binary=False,application_binary_unchanged=True,application_binary_sha256=binary,test_executable=str(test_exe),test_executable_sha256=hashlib.sha256(test_exe.read_bytes()).hexdigest(),artifacts=artifacts,hashes={p:sha(p) for p in artifacts},findings=atoi['findings']+reader['findings'],limits=atoi['limits']+reader['limits'],adapters=atoi['adapters']+reader['adapters'],next_action=action)
save('docs/native_integer_value_reader_progress.json',receipt)
archive=r/'docs/plan_history'/('native-integer-value-reader-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_integer_value_reader_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=247,client_tests_current_binary=False,native_atoi_cases=1962,native_integer_value_reader_cases=1440,native_default_game_cfg_byte_exact=True)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Conversion et lecteur entier natifs portés</h2><p>1962cas CRT et1440cas de lecteur typé/texte vérifiés ;247tests des sources passent. Game.cfg original récupéré sans modification. Parsing, cache, chargement utilisateur, menu et persistance restent ouverts ; exécutable précédent conservé.</p><a href="native_integer_value_reader_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['inspect_native_atoi.py','inspect_native_atoi_locale.py','inspect_native_config_string_helpers.py','inspect_native_text_lookup_abi.py','locate_native_game_config.py','record_native_integer_value_reader.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(client_source_tests=247,native_atoi_cases=1962,native_integer_reader_cases=1440,native_default_config_recovered=True,game_binary_unchanged=True,complete=False)))
