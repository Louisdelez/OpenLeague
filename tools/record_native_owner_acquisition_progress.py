from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_projectile_owner_acquisition_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/projectile_owner_acquisition_contract.json');assert a['passed'] and len(a['cases'])==40
a['entries']=['7172B0','6C9BD0','6C97B0','concrete provider table10B0D20'];(r/'data/4.20/projectile_owner_acquisition_contract.json').write_text(json.dumps(a,indent=2)+'\n',encoding='utf-8')
log='logs/native-projectile-owner-acquisition-tests.log';assert 'test result: ok. 2 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
files=['data/4.20/projectile_owner_acquisition_contract.json','tools/probe_native_projectile_owner_acquisition.py','crates/core/src/native_projectile_stop_dispatch.rs',log]
next_action='Raccorder les transitions natives du propriétaire et qualifier les drapeaux/statuts et l’ordonnancement de la projection d’Annie ; poursuivre les 24 domaines et 114 tâches du plan complet.'
proof=dict(updated_utc=now,complete=False,passed=True,native_sha256=a['native_sha256'],native_cases=40,native_frames=120,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=2,prior_stop_dispatch_profiles=120,full_suites_rerun=False,client_owner_acquisition_integrated=False,current_runtime_capture=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings']+['Rust wrapper gate matches the original initial gate, termination marker, returned result and guarded position-update conditions over120frames.'],adapters=a['adapters'],limits=a['limits']+['Client still supplies network disappearance as a controller-end trigger. Concrete weak-owner acquisition/loss is not yet connected to the graphical consumer.','Other bound-wrapper pose/property callbacks are not covered by this gate port.','Prior v19 graphics retain their original hashes; no new graphical build or current runtime qualification claimed.','Zero accepted domains; complete24domain114task objective preserved.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('native-owner-acquisition-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_projectile_owner_acquisition_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,native_projectile_owner_acquisition_cases=40,native_projectile_owner_acquisition_frames=120,native_projectile_owner_acquisition_focused_core_tests=2,native_projectile_owner_acquisition_client_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Acquisition du propriétaire de projection</h2><p>40 séquences et120 frames originales : la perte marque la fin pendant une mise à jour encore réussie, puis la suivante est rejetée. Port Rust et régression du dispatch contrôlés par2tests ciblés. Raccordement au client et ordonnancement encore ouverts.</p><a href="native_projectile_owner_acquisition_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt)
