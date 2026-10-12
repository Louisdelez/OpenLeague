from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc); stamp=now.isoformat(); log='logs/projected-parent-tests.log'
m=re.search(r'test result: ok\. (\d+) passed; 0 failed;', (r/log).read_text(encoding='utf-8-sig')); assert m
corelog='logs/projected-parent-core-tests.log'
cm=re.search(r'test result: ok\. (\d+) passed; 0 failed;', (r/corelog).read_text(encoding='utf-8-sig'));assert cm
receipt='docs/projected_parent_progress.json'
next_action='Brancher native_projected_parent::Parent dans projected_live::Lifetime avec le paquet camera reel et le reglage moteur explicite. Adapter les tests de la vie complete au parent (les anciens oracles Simple restent au niveau enfant). Verifier visible/hors champ/reprise/arret, puis captures DX12/Vulkan. Le rendu normal utilise encore le cycle enfant direct.'
files=['crates/client/src/native_projected_parent.rs','crates/client/src/native_projected_cycle.rs','crates/core/src/native_troy_frame.rs',log,corelog]
p=dict(updated_utc=stamp,passed=True,complete=False,focused_client_tests=int(m[1]),focused_core_tests=int(cm[1]),parent_child_bridge=True,normal_runtime_bound=False,graphical_build_current=False,findings=['Native parent gate commits actual child storage before substeps through commit_simple_gate.','Parent drives native timing, interpolated positions, child last-step bounds flag and completion.','Test covers active particle, storage suspension, repeated hidden frame without advancing motion clock, reuse on visibility return and hidden stop.'],limits=['Explicit supplied clock/rate/flags/camera inputs; no normal runtime binding yet.','Audio descriptors disabled and engine status0/root clock0 are explicit adapter inputs.','Composition test uses separately qualified native contracts; no new whole native parent-child oracle.','No new graphical executable or acceptance.'],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},next_action=next_action)

(r/receipt).write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('projected-parent-'+now.strftime('%Y%m%dT%H%M%SZ')); h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/name;shutil.copy2(f,h/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=stamp,projected_parent_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
 if name=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if name=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name);f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Cycle parent des particules</h2><p>Cycle parent compose avec le stockage Projected: suspension, reprise et sous-etapes. Branchement dans la partie et qualification graphique encore ouverts.</p><a href="projected_parent_progress.json">Preuves</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt,int(m[1]))
