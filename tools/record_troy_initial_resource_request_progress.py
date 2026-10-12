from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_troy_initial_resource_request_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/troy_initial_resource_request_contract.json');assert a['passed'] and len(a['cases'])==48

next_action='Qualifier l’instance de ressource créée par 93DB40 et ses drapeaux, puis terminer âge, fin de vie et pose du projectile d’Annie ; poursuivre les 24 domaines.'
files=['data/4.20/troy_initial_resource_request_contract.json','tools/probe_native_troy_initial_resource_request.py']
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],native_cases=48,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=0,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings'],adapters=a['adapters'],limits=a['limits']+['Native probe only; no Rust or client source changed in this step.','Full objective remains incomplete, zero domains accepted.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('troy-initial-resource-request-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_initial_resource_request_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,native_troy_initial_resource_request_cases=48)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Première requête de ressource Troy</h2><p>48 exécutions natives : requête conditionnée par le bit 2000, bit acquitté même sur échec, drapeaux conservés. Parser, collections non vides et cycle de vie restent ouverts.</p><a href="native_troy_initial_resource_request_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)

