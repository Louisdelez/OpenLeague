from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
contract=r/'data/4.20/native_fxaa_allocation_contract.json';c=json.loads(contract.read_text(encoding='utf-8'));assert c['passed'] and c['case_count']==18
log=r/'logs/native-fxaa-pass-tests.log';text=log.read_text(encoding='utf-8-sig');assert '2 passed; 0 failed' in text and '366 filtered out' in text
for name in ['qualify_native_fxaa_allocation.py','inspect_fxaa_allocation.py','inspect_native_d3d_imports.py','inspect_native_d3d_factory.py','inspect_native_texture_backend.py','inspect_native_texture_bridge.py','discover_fxaa_backend.py','record_native_fxaa_allocation.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
shutil.copy2(Path('E:/mapslol3v3/native_fxaa_backend_candidates.json'),r/'data/4.20/native_fxaa_backend_candidates.json')
receipt='native_fxaa_allocation_progress.json';source=r/'crates/client/src/native_fxaa_pass.rs';testexe=r/'target/debug/deps/openleague_client-bbd510cc6bf5bf73.exe'
p=dict(updated_utc=now,complete=False,passed=True,contract='data/4.20/native_fxaa_allocation_contract.json',native_allocation_cases=18,rust_tests_passed=2,rust_cases_compared=154,unrun_client_tests=366,test_log='logs/native-fxaa-pass-tests.log',test_log_sha256=hashlib.sha256(log.read_bytes()).hexdigest(),rust_source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),test_executable_sha256=hashlib.sha256(testexe.read_bytes()).hexdigest(),native_shader_gpu_integrated=False,native_msaa_configuration_qualified=False,backend_candidates='data/4.20/native_fxaa_backend_candidates.json',limits=c['limits']+['Two focused Rust tests pass; the remaining 366 client tests were filtered out, and no ordinary client executable or graphical runtime rebuild is claimed.','Rust pass parameters registered as a module; shader and actual frame graph integration remain open.'])
(r/'docs'/receipt).write_text(json.dumps(p,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Exécuter le pont FXAA de l’interface 10E2F30/slot60 (9C2D40) vers CreateTexture (9C6070), qualifier les conversions de format et usage puis retrouver le MSAA global ; porter et comparer le shader FXAA GPU. Poursuivre le rendu/audio et les 24 domaines.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;data=json.loads(path.read_text(encoding='utf-8-sig'));data.update(updated_utc=now,native_fxaa_allocation_progress='docs/'+receipt)
 if name=='resume_checkpoint.json':data.update(saved_utc=now,next_projected_action=next_action)
 elif name=='completion_plan.json':data['next_execution_steps'][0]=next_action
 elif name=='goal_plan_revision.json':data['next_steps']=[next_action]
 if name!='goal_plan_revision.json':
  evidence=data['last_verified'] if name=='resume_checkpoint.json' else data['current_evidence'];evidence.update(native_fxaa_allocation_cases=18,native_fxaa_rust_focused_tests=2,native_fxaa_gpu_integrated=False)
 path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S),encoding='utf-8')
for name in ['completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;data=json.loads(path.read_text(encoding='utf-8'))
 if name=='completion_plan.json':data['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8')
 else:data['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest()
 path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');html.write_text(text.replace('</body>','<section><h2>Allocation et port Rust FXAA</h2><p>18 cas natifs de création de texture qualifiés jusqu’à l’interface de rendu. Port Rust des constantes et de la condition d’activation : deux tests réussis comparant 154 cas natifs ; 366 autres tests non exécutés. Pont D3D retrouvé statiquement, conversions et shader GPU encore à qualifier.</p><p><a href="native_fxaa_allocation_progress.json">Preuves et limites</a></p></section></body>'),encoding='utf-8')
print('18 native allocation cases and 2 Rust tests recorded; full scope incomplete.')
