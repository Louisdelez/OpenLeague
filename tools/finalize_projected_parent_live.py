from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc); stamp=now.isoformat(); log='logs/projected-parent-live-tests.log'
m=re.search(r'test result: ok\. (\d+) passed; 0 failed;', (r/log).read_text(encoding='utf-8-sig')); assert m
corelog='logs/projected-parent-core-tests.log'
cm=re.search(r'test result: ok\. (\d+) passed; 0 failed;', (r/corelog).read_text(encoding='utf-8-sig'));assert cm
receipt='docs/projected_parent_live_progress.json'
next_action='Attendre le build graphique actif session14705 (logs/projected-parent-client-build.log), ne pas relancer sans verifier le processus. Puis executer tools/capture_projected_core_cycle_v24_parent_dx12.py et _vulkan.py, analyser pixels et inspecter les images. Qualification camera mobile encore requise. Poursuivre le plan complet.'
files=['crates/client/src/projected_live.rs','crates/client/src/native_projected_parent.rs','crates/client/src/native_projected_cycle.rs','crates/core/src/native_troy_frame.rs',log,corelog]
p=dict(updated_utc=stamp,passed=True,complete=False,focused_client_tests=int(m[1]),focused_core_tests=int(cm[1]),parent_child_bridge=True,normal_runtime_bound=True,graphical_build_session=14705,graphical_build_current=False,findings=['Native parent gate commits actual child storage before substeps through commit_simple_gate.','Normal Lifetime now uses Parent; actual camera volume supplies gate planes/support indices. Native frame stop bit controls cleanup.','Normal lifetime camera exit/reentry test passed; unchanged pose, owner loss, scale, activation and cleanup tests also passed.'],limits=['Clock is local Bevy; engine quality3 explicitly selected until UI settings producer is bound.','Audio descriptors disabled and engine status0/root clock0 are explicit adapter inputs.','Composition test uses separately qualified native contracts; no new whole native parent-child oracle.','No new graphical executable or acceptance.'],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},next_action=next_action)

(r/receipt).write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('projected-parent-live-'+now.strftime('%Y%m%dT%H%M%SZ')); h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/name;shutil.copy2(f,h/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=stamp,projected_parent_live_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
 if name=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if name=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name);f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Cycle parent des particules</h2><p>Cycle parent branche dans la projection normale avec la camera reelle. Sept tests client passent. Build graphique en cours; captures et camera mobile restent a qualifier.</p><a href="projected_parent_live_progress.json">Preuves</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt,int(m[1]))
