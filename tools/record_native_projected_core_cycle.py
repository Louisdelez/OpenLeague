from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
log='logs/native-projected-core-cycle-client-tests.log';text=(r/log).read_text(encoding='utf-8-sig')
assert 'test result: ok. 366 passed; 0 failed;' in text
assert 'native_projected_cycle::tests::core_cycle_matches_native_owner_pose_frames ... ok' in text
p=load('data/4.20/simple_projection_sources_defaults.json');assert p['passed']
receipt='docs/native_projected_core_cycle_progress.json'
files=['crates/client/src/native_projected_cycle.rs','crates/client/src/simple_projected_config.rs','crates/client/src/projected_live.rs','crates/client/src/main.rs','crates/client/src/native_endgame_ui.rs','crates/core/src/native_simple_emission_sources.rs','data/4.20/simple_projection_sources_defaults.json','tools/probe_native_simple_projection_sources.py','data/4.20/simple_owner_pose_contract.json','data/4.20/simple_owner_end_contract.json','logs/native-projected-core-cycle-before-controlled-clock-fix.log',log,'docs/native_simple_sources_full_frame_progress.json']
assert 'native_projected_cycle::tests::core_cycle_matches_fifty_native_owner_end_frames ... ok' in text
binary=max((r/'target/debug/deps').glob('openleague_client-*.exe'),key=lambda f:f.stat().st_mtime);files.append(str(binary.relative_to(r)).replace('\\','/'))
e=dict(client_tests_passed=366,annie_projection_core_frame_bound=True,annie_projection_core_frame_selected_tested=True,annie_projection_core_frame_owner_end_cases=50,annie_projection_current_graphical_binary_qualified=False,latest_projected_cycle_progress=receipt,latest_client_test_log=log)
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=['Native initial source defaults verified separately. Authored Annie rate1/life2/emitter life1/scale500 bound to core9437E0/943300/941F00/944E20 cycle, with qualified logical fresh storage.', 'Owner pose frames match positions, normalized age, active count, finish, scale500 and angle0; 50 native owner-end frames also match raw normalized ages, positions, active counts and finish; all endgame UI deadline tests use a controlled clock from initialization.', 'Missile identity/orientation, chosen logical RNG seed17, native global resource population, emitter/system render factors, FOW/depth/alpha and audible output remain unqualified. This build is a test executable; ordinary graphical application has not been rebuilt or visually accepted. No kit/task/domain complete.']))
h=r/'docs/plan_history'/('projected-core-cycle-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Reconstruire puis vérifier la projection normale dans le client graphique ; poursuivre les fournisseurs, le rendu/audio Map10 et les 24 domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
 shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_projected_core_cycle_progress=receipt)
 if name=='goal_plan_revision.json':d.update(client_tests_passed=366,next_steps=[next_action],latest_projected_cycle_progress=receipt)
 else:
  target=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];target.update(e)
  if name=='resume_checkpoint.json':target['client_tests']=366;d.pop('pending_projected_core_cycle',None);d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d['next_execution_steps'][1:]
   for domain in d['domains']:
    if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
 save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,path.read_text(encoding='utf-8'),flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
html=r/'docs/completion_plan.html';shutil.copy2(html,h/html.name);html.write_text(html.read_text(encoding='utf-8').replace('</body>','<section><h2>Projection normale et cycle moteur</h2><p>La projection d’Annie utilise le cycle complet Rust pour naissance, pose, âge et fin de vie. Sources constantes natives et taux auteur vérifiés ; 366 tests client passent. Les facteurs de rendu, le fournisseur missile et la qualification sur l’exécutable graphique restent à terminer.</p><a href="native_projected_core_cycle_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
pending=load('docs/native_projected_core_cycle_pending.json');pending.update(status='tests_passed',tests_result='366 passed;0 failed',updated_utc=now);save('docs/native_projected_core_cycle_pending.json',pending)
print(json.dumps(dict(client_tests=366,receipt=receipt,complete=False)))
