from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');src=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Shaders/HLSL')
now=datetime.datetime.now(datetime.timezone.utc).isoformat();assets=[]
for name in ['FXAA.hls','FXAA_PS.ps_3_0']:
 dst=r/'data/4.20/shaders'/name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src/name,dst)
 assert dst.read_bytes()==(src/name).read_bytes()
 assets.append(dict(source=str(src/name),destination=str(dst),sha256=hashlib.sha256(dst.read_bytes()).hexdigest(),size=dst.stat().st_size))
for name in ['qualify_native_fxaa_pass.py','inspect_fxaa_targets.py','record_native_fxaa_pass.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
contract=r/'data/4.20/native_fxaa_pass_contract.json';p=json.loads(contract.read_text(encoding='utf-8'));assert p['passed'] and p['case_count']==126
receipt='native_fxaa_pass_progress.json';proof=dict(updated_utc=now,complete=False,passed=True,contract='data/4.20/native_fxaa_pass_contract.json',contract_sha256=hashlib.sha256(contract.read_bytes()).hexdigest(),native_sha256=p['native_sha256'],cases=126,source_assets=assets,native_gpu_shader_qualified=False,native_msaa_configuration_qualified=False,ordinary_renderer_changed=False,limits=p['limits'])
(r/'docs'/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Qualifier l’allocation native des textures FXAA (985E50/9882A0) et le multisampling D3D9 ; porter le shader FXAA original récupéré puis comparer son exécution GPU. Résoudre les écarts DirectX 12 et poursuivre les 24 domaines.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;data=json.loads(path.read_text(encoding='utf-8-sig'));data.update(updated_utc=now,native_fxaa_pass_progress='docs/'+receipt)
 if name=='resume_checkpoint.json':data.update(saved_utc=now,next_projected_action=next_action)
 elif name=='completion_plan.json':data['next_execution_steps'][0]=next_action
 elif name=='goal_plan_revision.json':data['next_steps']=[next_action]
 if name!='goal_plan_revision.json':
  evidence=data['last_verified'] if name=='resume_checkpoint.json' else data['current_evidence'];evidence.update(native_fxaa_pass_orchestration_cases=126,native_fxaa_source_recovered=True,native_fxaa_shader_execution_qualified=False,native_msaa_configuration_qualified=False)
 path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
import re
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S),encoding='utf-8')
for name in ['completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;data=json.loads(path.read_text(encoding='utf-8'))
 if name=='completion_plan.json':data['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8')
 else:data['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest()
 path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8')
html.write_text(text.replace('</body>','<section><h2>Passe FXAA native</h2><p>126 cas sur la routine originale : copie, sampler, shader PS_FXAA, constantes selon résolution et niveau, quadrilatère et libération. Les deux sources HLSL originales ont été récupérées et vérifiées par empreinte. Allocation des textures, multisampling et exécution du shader GPU encore à qualifier.</p><p><a href="native_fxaa_pass_progress.json">Preuves et sources</a></p></section></body>'),encoding='utf-8')
print(json.dumps(dict(cases=126,sources=assets,complete=False)))
