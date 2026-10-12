from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=load('data/4.20/native_game_cfg_parser_contract.json')
assert proof['passed'] and proof['case_count']==260 and len(proof['actual_game_cfg']['result']['entries'])==387
log=(r/'logs/native-game-cfg-parser-tests.log').read_text(encoding='utf-8')
assert '249 passed; 0 failed' in log
binary=sha('target/debug/openleague-client.exe')
action='Parseur texte natif porté et confronté à260cas ainsi qu’aux387entrées Game.cfg ; les249tests des sources client passent. Démarrage source relié au fichier original embarqué, pas encore au fichier utilisateur réel. Qualifier cache8ACEF0, lookup8AE0E0/8AE340 et initialisation du chemin utilisateur ; relier fichiers/menu/persistance puis reconstruire et inspecter profils bas/haut. Achever variantes/LOD, Wall_of_Grass/options globales ; poursuivre rendu Chaos, cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_game_cfg_parser_contract.json','data/4.20/configuration/defaults/Game.cfg','crates/client/src/native_game_cfg_text.rs','crates/client/src/native_graphics_options.rs','logs/native-game-cfg-parser-tests.log']
receipt=dict(updated_utc=now,complete=False,parser_loop_ported=True,native_parser_cases=260,native_addresses=proof['native_addresses'],original_default_entries=387,default_source_sha256=proof['actual_game_cfg']['sha256'],default_embedded_in_source=True,actual_user_file_loaded=False,configuration_cache_qualified=False,live_user_options_bound=False,client_source_tests_passed=249,client_tests_current_binary=False,application_binary_sha256=binary,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},adapters=proof['adapters'],limits=proof['limits']+['Rust startup uses original embedded defaults. Actual user file/cache/menu/persistence and application rebuild/runtime capture remain open.'],next_action=action)
save('docs/native_game_cfg_parser_progress.json',receipt)
archive=r/'docs/plan_history'/('native-game-cfg-parser-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_game_cfg_parser_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=249,client_tests_current_binary=False,native_game_cfg_parser_cases=260,native_game_cfg_default_entries=387,native_game_cfg_parser_ported=True,native_default_cfg_embedded_in_source=True)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8');text=text.replace('</body>','<section><h2>Parseur natif Game.cfg porté</h2><p>260cas natifs et387entrées du fichier original comparés au parseur Rust ;249tests des sources passent. Les valeurs par défaut originales sont désormais parsées au démarrage dans les sources. Cache, fichier utilisateur réel, menu, persistance et qualification du nouvel exécutable restent ouverts.</p><a href="native_game_cfg_parser_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(client_source_tests=249,native_parser_cases=260,actual_default_entries=387,complete=False)))
