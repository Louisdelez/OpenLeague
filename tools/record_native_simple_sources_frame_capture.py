from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load('data/4.20/simple_sources_frame_contract.json')
assert p['passed'] and len(p['cases'])==576 and p['emulator_cpu_case_disagreements']==0
receipt='docs/native_simple_sources_frame_capture.json'
files=['data/4.20/simple_sources_frame_contract.json','tools/probe_native_simple_sources_frame.py','docs/native_simple_emission_sources_progress.json']
save(receipt,dict(updated_utc=now,complete=False,native_cases=576,native_capture_passed=True,rust_full_frame_qualified=False,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=p['adapters'],limits=p['limits'],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files}))
next_action='Raccorder le coordinateur des producteurs au cycle Rust complet et comparer les 576 captures natives, puis intégrer au rendu/audio Map10 et Annie ; poursuivre les fournisseurs, arrondis et les 24 domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
 d=load('docs/'+name);d['updated_utc']=now;d['native_simple_sources_frame_capture']=receipt
 if name=='goal_plan_revision.json':d['next_steps']=[next_action]
 else:
  target=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];target.update(simple_sources_full_frame_native_cases=576,simple_sources_full_frame_native_capture=receipt,simple_sources_full_frame_rust_qualified=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':d['next_execution_steps']=[next_action]+d['next_execution_steps'][1:]
 save('docs/'+name,d)
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(native_cases=576,rust_full_frame_qualified=False,receipt=receipt)))
