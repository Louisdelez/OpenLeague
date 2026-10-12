from pathlib import Path
import json, hashlib, datetime, shutil
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc).isoformat()
receipt='docs/native_missile_position_sync_progress.json'
def load(p): return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p): return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/missile_position_sync_contract.json')
log='logs/native-missile-position-sync-tests.log'
assert a['passed'] and len(a['cases'])==36
assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Raccorder la direction, le déplacement et la pose propriétaire qualifiés au rendu normal d’Annie ; vérifier les valeurs natives de lancement, collisions et arrêt, puis poursuivre les24domaines.'
files=['data/4.20/missile_position_sync_contract.json','tools/probe_native_missile_position_sync.py','crates/core/src/native_missile_position_sync.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],native_cases=36,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Original7631C0/7648C0 execute without adapters: moving544 is copied to owner60 for zero gravity or null target span, including signed zero. Rust matches36cases.','Valid-target nonzero-gravity interpolation remains unqualified and the Rust API rejects it explicitly.'],adapters=a.get('adapters',[]),limits=a.get('limits',[])+['Core-only; live motion integration and valid-target gravity interpolation remain open.','No full-suite or client validation claimed; zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-position-sync-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name)
 d.update(updated_utc=now,native_missile_position_sync_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{})
  e.update(latest_native_execution_progress=receipt,native_missile_position_sync_cases=36,native_missile_position_sync_focused_tests=1)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name)
s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Position du propriétaire projectile</h2><p>36 exécutions originales sans adaptation : copie de position du projectile vers son propriétaire. Un test Rust ciblé passe. Interpolation avec gravité et cible valide, puis raccordement au rendu encore ouverts.</p><a href="native_missile_position_sync_progress.json">Preuves et limites</a></section></body>')
p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
