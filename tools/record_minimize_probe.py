from pathlib import Path
import json,datetime,shutil,hashlib
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc)
receipt='docs/window_minimize_probe_progress.json'
next_action='Attendre build actif session75705 (logs/window-minimize-client-build.log), sans relancer. Puis executer tools/qualify_dx12_window_v30.py: diagnostic Bevy opt-in OPENLEAGUE_RENDER_MINIMIZE, reduction82s/restauration90s/capture98s. Si echec analyser logs et conserver preuves. DX12 v26 non resolu. Continuer plan complet.'
files=['crates/client/src/render_probe.rs','tools/qualify_dx12_window_v30.py']
d={'updated_utc':now.isoformat(),'complete':False,'build_session':75705,'render_validation_pending':True,'change':'Optional window lifecycle adds minimize/unminimize via Bevy Window requests. Ordinary play and existing lifecycle stages unchanged.','next_action':next_action,'artifacts_sha256':{f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files}}
(r/receipt).write_text(json.dumps(d,indent=2)+'\n')
h=r/'docs/plan_history'/('minimize-probe-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True)
for n in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/n;shutil.copy2(f,h/n);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=now.isoformat(),window_minimize_probe_progress=receipt)
 if n=='resume_checkpoint.json':d.update(next_projected_action=next_action,active_graphical_build={'session':75705,'log':'logs/window-minimize-client-build.log'})
 if n=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if n=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
