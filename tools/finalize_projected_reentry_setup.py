from pathlib import Path
import json,datetime,hashlib,re,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat();log='logs/projected-reentry-camera-tests.log'
assert re.search(r'test result: ok\. 13 passed; 0 failed;', (r/log).read_text(encoding='utf-8-sig'))
receipt='docs/projected_reentry_setup_progress.json';next_action='Attendre le build actif session38378, logs/projected-reentry-client-build.log; ne pas relancer sans verifier. Executer ensuite capture_projected_core_cycle_v25_reentry_dx12.py et _vulkan.py. Exiger horloge immobile/stockage0 hors champ puis particules actives au retour et inspecter les trois images. Ancienne preuve graphique v24 reste camera fixe.'
files=['crates/client/src/main.rs','crates/client/src/projected_live.rs','tools/capture_projected_core_cycle_v25_reentry_dx12.py','tools/capture_projected_core_cycle_v25_reentry_vulkan.py',log]
p=dict(updated_utc=stamp,complete=False,passed=True,camera_tests=13,graphical_validation=False,active_build_session=38378,diagnostic_scope='Opt-in camera movement through normal native camera pose/culling. Ordinary gameplay unchanged when environment flag absent.',artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},next_action=next_action)
(r/receipt).write_text(json.dumps(p,indent=2)+'\n');h=r/'docs/plan_history'/('projected-reentry-setup-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/name;shutil.copy2(f,h/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=stamp,projected_reentry_setup_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action,active_graphical_build={'session':38378,'log':'logs/projected-reentry-client-build.log'})
 if name=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if name=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name);f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Camera mobile</h2><p>Scenario de sortie/retour et traces preparees. 13 tests passent; nouveau build en cours. Images non encore qualifiees.</p><a href="projected_reentry_setup_progress.json">Etat et preuves</a></section></body>'),encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt)
