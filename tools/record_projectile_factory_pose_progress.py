from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_projectile_factory_pose_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/projectile_factory_pose_contract.json');assert a['passed'] and len(a['cases'])==120
log='logs/native-projectile-factory-pose-tests.log';assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
files=['data/4.20/projectile_factory_pose_contract.json','tools/probe_native_projectile_factory_pose.py','crates/core/src/native_projectile_factory_pose.rs','crates/core/src/lib.rs',log]
next_action='Composer les champs de création native du projectile avec son fournisseur de pose10B0D20, raccorder cette pose à Annie puis vérifier le client graphique ; poursuivre les 24 domaines.'
proof=dict(updated_utc=now,complete=False,passed=True,native_sha256=a['native_sha256'],native_cases=120,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,full_core_suite_rerun=False,live_client_integration=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings'],adapters=a['adapters'],limits=a['limits']+['Rust port covers measured initial wrapper/Troy pose fields and request bits; remaining properties, resource construction, references and callbacks remain separate.','First native update tested with null providers; no claim about later bound-owner flag mutations or complete normal gameplay.','Current v18 graphical client retains its previously verified stop dispatch; new factory pose core port is not yet consumed there.','No domain closed; all 24 domains and 114 tasks remain in scope.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('projectile-factory-pose-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_projectile_factory_pose_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,native_projectile_factory_pose_cases=120,native_projectile_factory_pose_focused_core_tests=1)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Pose initiale du projectile natif</h2><p>120 profils exécutent création7172B0, chargement6C8E30 et première mise à jour6C97B0 avec Troy93FD60. Drapeaux, position sentinelle, transmission de position et matrice comparés au port Rust. Raccordement au fournisseur et au client encore ouverts.</p><a href="native_projectile_factory_pose_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
