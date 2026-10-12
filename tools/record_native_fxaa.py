from pathlib import Path
import json, datetime, hashlib, shutil, re
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc).isoformat()
contract=r/'data/4.20/native_fxaa_option_contract.json'
p=json.loads(contract.read_text(encoding='utf-8'))
assert p['passed'] and len(p['consumer_cases'])==28 and len(p['defaults'])==9
for name in ['qualify_native_fxaa.py','inspect_fxaa.py','inspect_fxaa_calls.py','inspect_fxaa_consumer.py','record_native_fxaa.py']:
 shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
receipt='native_fxaa_option_progress.json'
proof=dict(updated_utc=now,complete=False,passed=True,contract='data/4.20/native_fxaa_option_contract.json',contract_sha256=hashlib.sha256(contract.read_bytes()).hexdigest(),native_sha256=p['native_sha256'],default_cases=9,consumer_cases=28,default_enabled=False,enable_condition='Stored integer value > 0 and unsigned renderer shader capability >= 0xffff0300',dispatch_immediate_callback=False,fxaa_shader_execution_qualified=False,native_msaa_configuration_qualified=False,ordinary_renderer_changed=False,limits=p['limits'])
(r/'docs'/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Tracer les cibles et le shader FXAA natifs (73D610), puis la configuration de multisampling D3D9 ; résoudre ensuite les écarts DirectX 12 sans assimiler le diagnostic sans MSAA au rendu normal. Poursuivre le rendu/audio et les 24 domaines.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;data=json.loads(path.read_text(encoding='utf-8-sig'));data.update(updated_utc=now,native_fxaa_option_progress='docs/'+receipt)
 if name=='resume_checkpoint.json':data.update(saved_utc=now,next_projected_action=next_action)
 elif name=='completion_plan.json':data['next_execution_steps'][0]=next_action
 elif name=='goal_plan_revision.json':data['next_steps']=[next_action]
 if name!='goal_plan_revision.json':
  evidence=data['last_verified'] if name=='resume_checkpoint.json' else data['current_evidence']
  evidence.update(native_fxaa_option_gate_qualified=True,native_fxaa_default=0,native_fxaa_shader_execution_qualified=False,native_msaa_configuration_qualified=False)
 path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S),encoding='utf-8')
for name in ['completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;data=json.loads(path.read_text(encoding='utf-8'))
 if name=='completion_plan.json':data['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8')
 else:data['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest()
 path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8')
html.write_text(text.replace('</body>','<section><h2>Option FXAA native</h2><p>9 cas de configuration et 28 cas de rendu exécutés sur les instructions originales : option Performance/EnableFXAA, identifiant 23, défaut 0. Activation si valeur positive et capacité shader suffisante. Le dispatcher ne déclenche aucune reconstruction immédiate pour cette option. Le shader FXAA et la configuration MSAA originale restent à qualifier ; aucun réglage du rendu normal modifié.</p><p><a href="native_fxaa_option_progress.json">Preuves et limites FXAA</a></p></section></body>'),encoding='utf-8')
print('Native FXAA gate recorded; full scope remains incomplete.')
