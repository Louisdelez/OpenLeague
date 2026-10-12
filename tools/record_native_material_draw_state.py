from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof=load('data/4.20/material_draw_state_contract.json');assert proof['passed'] and len(proof['cases'])==81920 and proof['native_addresses']==344
proof['runtime_adapters'].append('Security cookie checker C975F5 adapted to return; it does not supply material/render-state outcomes.')
save('data/4.20/material_draw_state_contract.json',proof)
receipt={'updated_utc':now,'complete':False,'implemented_in_client':False,'native_cases':81920,'native_addresses':344,'native_sha256':proof['native_sha256'],'findings':proof['findings'],'limits':proof['limits'],'next_actions':['Recover native quality global12258D8 producer/configuration and verify current Map10 material profiles against this routing.','Implement qualified color/separate-alpha blend factors and depth writing in the client, then compare actual GPU pixels; retain alpha-state persistence limit until whole world path is qualified.','Continue shader variants, shadows, moving vision and the full completion plan.'],'proof_sha256':hashlib.sha256((r/'data/4.20/material_draw_state_contract.json').read_bytes()).hexdigest()}
quality=load('data/4.20/environment_quality_contract.json');assert quality['passed'] and len(quality['cases'])==980
receipt['native_quality_producer_cases']=980;receipt['native_quality_producer_addresses']=quality['native_addresses'];receipt['quality_findings']=quality['findings'];receipt['quality_limits']=quality['limits']
receipt['next_actions'][0]='Complete native user/configuration quality retrieval835080 and surrounding dispatch; suffix clamp/revision verified on980cases. Verify current Map10 profiles against native material routing.'
save('docs/native_material_draw_state_progress.json',receipt)
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,history/name);d=load(p);d.update(updated_utc=now,complete=False,native_material_draw_state_progress=receipt)
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(native_material_draw_state_cases=81920,native_material_draw_state_integrated=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
for name in ['probe_native_material_draw_state.py','inspect_native_world_render_state.py','probe_native_environment_quality.py','record_native_material_draw_state.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps({'native_cases':81920,'implemented':False,'complete':False}))
