from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_owner_acquisition_consumer_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
log='logs/annie-owner-acquisition-client-tests.log';assert 'test result: ok. 5 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
files=['data/4.20/projectile_owner_acquisition_contract.json','crates/core/src/native_projectile_stop_dispatch.rs','crates/client/src/projected_live.rs',log]
next_action='Recompiler le client et qualifier deux tirs/leur nettoyage en DX12 et Vulkan avec le raccordement du propriétaire ; poursuivre statuts, drapeaux, ordonnancement et tous les 24 domaines/114 tâches.'
proof=dict(updated_utc=now,complete=False,passed=True,focused_client_tests_passed=5,native_client_owner_acquisition_frames=15,prior_owner_end_frames=50,prior_native_pose_profiles=45,client_owner_acquisition_gate_integrated=True,owner_lifetime_source='local Shot presence, not original shared/weak control lifetime',graphical_client_rebuilt=False,current_runtime_capture=False,full_suites_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Abandoned effects no longer disappear directly: missing Shot feeds qualified6C97B0 gate, retaining the last pose on loss and marking termination.','Cleanup is consumed on the next rejected update, preserving original returned-result delay.','15 original acquired/expired-owner frames checked in actual client Lifetime, plus existing clock/lifetime/pose and entity/asset release regressions.'],limits=['Local Shot presence supplies weak-owner eligibility; original concurrent lifetime/registry scheduler and status producers remain open.','Native additional bound-wrapper property callbacks and later Troy flags remain unqualified.','Current graphical binary predates this source; pending rebuild/captures.','No complete champion, gameplay, full-domain or human fidelity acceptance.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-owner-acquisition-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_owner_acquisition_consumer_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,annie_owner_acquisition_client_tests=5,annie_owner_acquisition_client_native_frames=15,annie_source_matches_graphical_binary=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Acquisition du propriétaire raccordée à Annie</h2><p>Le client conserve la dernière pose à la disparition du projectile et suit le délai natif de fin/nettoyage. 15 frames natives et4 régressions :5tests ciblés réussis. Présence locale du projectile utilisée comme source d’acquisition ; lifetime original et ordonnancement encore ouverts. Nouveau build et captures requis.</p><a href="annie_owner_acquisition_consumer_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt)
