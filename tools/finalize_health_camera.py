from pathlib import Path
import json,datetime,hashlib,re,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat();log='logs/health-camera-tests.log'
assert re.search(r'test result: ok\. 14 passed; 0 failed;', (r/log).read_text(encoding='utf-8-sig'))
receipt='docs/health_camera_progress.json';next_action='Attendre le build actif session16238, logs/health-camera-client-build.log. Rejouer capture_projected_core_cycle_v28_health_dx12.py et _vulkan.py, inspecter alignement des barres de vie pendant sortie/retour et absence de captures dupliquees. Correction HUD testee (14 tests), qualification visuelle encore ouverte. DX12 ResizeBuffers/Invalid surface v26 reste a investiguer. Poursuivre le plan complet.'
files=['crates/client/src/health.rs','crates/client/src/main.rs','crates/client/src/projected_live.rs','tools/capture_projected_core_cycle_v28_health_dx12.py','tools/capture_projected_core_cycle_v28_health_vulkan.py',log]
p=dict(updated_utc=stamp,complete=False,passed=True,camera_tests=14,graphical_validation=False,active_build_session=16238,health_pose_fix_implemented=True,duplicate_diagnostic_capture_fix_implemented=True,dx12_resize_defect_open=True,scope='Health bars use TransformHelper and run PostUpdate after CameraUpdateSystems before UI Prepare; current hierarchy is read before propagation. Camera regression leaves GlobalTransform stale deliberately.',artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},next_action=next_action)
(r/receipt).write_text(json.dumps(p,indent=2)+'\n');h=r/'docs/plan_history'/('health-camera-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/name;shutil.copy2(f,h/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=stamp,health_camera_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action,active_graphical_build={'session':16238,'log':'logs/health-camera-client-build.log'})
 if name=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if name=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name);f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Barres de vie et camera</h2><p>Correction du retard de pose implementee. 14 tests passent; nouveau build en cours. Images non encore qualifiees; erreur DX12 de redimensionnement ouverte.</p><a href="health_camera_progress.json">Etat et preuves</a></section></body>'),encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt)
