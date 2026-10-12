from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof=load('data/4.20/selector7_depth_phase_contract.json');assert proof['passed'] and len(proof['cases'])==256 and proof['quantized_reference_byte']==229
receipt={'updated_utc':now,'complete':False,'integrated':False,'native_cases':256,'native_addresses':proof['native_addresses'],'findings':proof['findings'],'limits':proof['limits'],'proof_sha256':hashlib.sha256((r/'data/4.20/selector7_depth_phase_contract.json').read_bytes()).hexdigest(),'next_actions':['Qualify nonempty selector7 batch state persistence through95AFC0 and95B140; integrate native depth-only threshold229 then alpha-disabled blended phase for six flag4materials.','Qualify grass type2 selector3/4 shader/state and current material route, complete historical quality settings and full world draw ordering.','Continue shadows, moving vision, six-client victory/results and all remaining requirements of the full plan.']};save('docs/native_selector7_depth_phase_progress.json',receipt)
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,history/name);d=load(p);d.update(updated_utc=now,complete=False,native_selector7_depth_phase_progress=receipt)
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(native_selector7_depth_phase_cases=256,native_selector7_depth_phase_integrated=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
for name in ['probe_native_selector7_depth_phase.py','record_native_selector7_depth_phase.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps({'cases':256,'depth_only_reference':229,'integrated':False,'complete':False}))
