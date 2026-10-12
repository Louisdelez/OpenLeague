from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
contract=load('data/4.20/native_graphics_options_contract.json');assert contract['passed'] and contract['getter_case_count']==126
test=(r/'logs/native-graphics-options-tests.log').read_text(encoding='utf-8');assert '244 passed; 0 failed' in test
match=re.search(r'Running unittests[^\n]*\((target[^\r\n)]+\.exe)\)',test);assert match
test_exe=r/match.group(1).replace('\\','/');assert test_exe.exists()
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
binary=sha('target/debug/openleague-client.exe');assert binary=='df190492f0160a982ac7cdfab28560f1e05a6c6a3fe4b83dbd603c769a559d5c'
exclusions=load('data/4.20/map10_static_fog_exclusions.json');assert exclusions['passed'] and exclusions['selected_pixel_routes']==172
action='Qualifier le véritable getter de configuration8B1C20 et sa lecture de Game.cfg : section Performance, EnvironmentQuality, id16, défaut3 désormais vérifiés. Relier ensuite le menu et la persistance aux options Rust, actualiser les variantes/LOD/matériaux, reconstruire et vérifier les profils bas/haut en frame réelle. Les244tests des sources passent ; dernier exécutable et capture df1904 restent antérieurs à ce port. Les172routes LIT ne portent pas d’exclusion statique, Wall_of_Grass nécessite sa passe séparée, options globales NOLIGHTING/FULLBRIGHT encore ouvertes. Puis référence/rendu Chaos, cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_graphics_options_contract.json','data/4.20/map10_static_fog_exclusions.json','crates/client/src/native_graphics_options.rs','crates/client/src/native_environment_draw.rs','logs/native-graphics-options-tests.log']
receipt=dict(updated_utc=now,complete=False,native_integer_getter_cases=126,native_name_cases=100,native_default_cases=9,native_addresses=contract['native_addresses'],environment_option=contract['environment'],integer_option_read_ported=True,environment_default_consumed_in_source=True,live_user_options_bound=False,configuration_parser_qualified=False,client_source_tests_passed=244,client_tests_current_binary=False,application_binary_unchanged=True,application_binary_sha256=binary,test_executable=str(test_exe),test_executable_sha256=hashlib.sha256(test_exe.read_bytes()).hexdigest(),static_exclusions_audit=exclusions,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},limits=contract['limits'],next_action=action)
save('docs/native_graphics_options_progress.json',receipt)
archive=r/'docs/plan_history'/('native-graphics-options-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_graphics_options_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=244,client_tests_current_binary=False,native_integer_option_cases=126,native_environment_option_id=16)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Option graphique native identifiée</h2><p>Performance / EnvironmentQuality : id16, défaut3. Lecture entière Rust comparée à126cas natifs ;244tests des sources passent. Menu et lecture réelle de configuration restent ouverts, exécutable précédent conservé.172routes LIT auditées ; passe Wall_of_Grass séparée.</p><a href="native_graphics_options_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['inspect_native_graphics_options.py','inspect_graphics_option_tables.py','inspect_graphics_dispatch.py','inspect_graphics_option_entry.py','audit_map10_fog_exclusions.py','record_native_graphics_options.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(client_source_tests=244,integer_native_cases=126,game_binary_unchanged=True,live_options=False,complete=False)))
