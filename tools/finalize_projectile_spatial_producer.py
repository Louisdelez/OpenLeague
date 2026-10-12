from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat()
log='logs/projectile-spatial-producer-tests.log'
assert 'test result: ok. 2 passed;' in (r/log).read_text(encoding='utf-8-sig')
receipt='docs/projectile_spatial_producer_progress.json'
next_action='Integrer la conservation des parametres NativeCamera et un registre projectile reutilisant grass_object_registry/grass_spatial_chain ; fournir les bornes group-vis natives a la requete camera et appliquer les transitions. Verifier le rendu puis poursuivre les24domaines/114taches.'
files=['tools/probe_native_projectile_spatial_bounds_producer.py','tools/probe_native_projectile_spatial_bounds.py','data/4.20/projectile_spatial_bounds_producer_contract.json','data/4.20/projectile_spatial_bounds_contract.json','crates/core/src/projectile_spatial_bounds.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=stamp,passed=True,complete=False,native_cases=192,transfer_regression_cases=144,focused_tests_passed=2,full_suites_rerun=False,client_integrated=False,findings=['Live provider copies six bounds through original9284A0 getter. Expired provider preserves prior owner/record state.','Spatial center is midpoint; changed center requests grid recomputation and attached-node update before extent setter.','Local minimum uses sign-bit XOR of half extents; signed zero and reversed finite bounds preserved.'],limits=['Native921F60 position/group-vis producer and940DF4..940E53 bounds export execute before6C9490. Bounded export omits whole-frame scheduling; finite cases only.','95F370,95FF10 and95F060 captured at entry; downstream mutations not executed.','Existing client grass_spatial_chain, grass_spatial_extents and grass_parent implement downstream contracts; reuse needs projectile composition validation.','No new graphical build or complete game acceptance.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('projectile-spatial-producer-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8-sig'));shutil.copy2(p,h/name);d.update(updated_utc=stamp,projectile_spatial_producer_progress=receipt)
 changes=dict(projectile_spatial_producer_native_cases=192,projectile_spatial_producer_rust_cases=192,projectile_spatial_bounds_client_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Limites spatiales des projectiles</h2><p>Producteur position/group-vis, export Troy et transfert spatial verifies sur 192 cas natifs ; 144 regressions du transfert passent. Integration client et rendu restent ouverts.</p><a href="projectile_spatial_producer_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
