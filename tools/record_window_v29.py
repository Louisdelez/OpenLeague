from pathlib import Path
import json,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);receipt='docs/window-lifecycle-v29-dx12.json'
p=json.loads((r/receipt).read_text());assert p['passed'];assert [x['size'] for x in p['frames']]==[[1280,800],[1024,768],[1920,1080],[1280,800]]
p['visually_inspected']=['restored'];p['observation']='Restored frame shows terrain, Garen, health bar and HUD; no blank output.'
(r/receipt).write_text(json.dumps(p,indent=2)+'\n')
next_action='DX12 v29: resize1024x768, fullscreen1920x1080 et retour1280x800 passent sur exe a7cc8975; ne cloture pas v26. Tester reduction/restauration et redimensionnement pendant captures GPU pour reproduire viewport nul puis ResizeBuffers invalid surface. Utiliser les API de fenetre Bevy dans diagnostic opt-in ou outils UI autorises. Poursuivre le plan complet.'
h=r/'docs/plan_history'/('window-v29-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True)
for n in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/n;shutil.copy2(f,h/n);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=now.isoformat(),window_lifecycle_v29_progress=receipt)
 if n=='resume_checkpoint.json':d.update(next_projected_action=next_action,saved_utc=now.isoformat())
 if n=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if n=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name);f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Cycle de fenetre DX12 v29</h2><p>Redimensionnement, plein ecran et retour fenetre reussis. Defaut v26 non reproduit; reduction et captures simultanees restent a tester.</p><a href="window-lifecycle-v29-dx12.json">Preuves</a></section></body>'),encoding='utf-8')
