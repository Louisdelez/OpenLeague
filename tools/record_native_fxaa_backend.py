from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
contracts=['native_fxaa_backend_contract.json','native_presentation_descriptor_contract.json'];data=[json.loads((r/'data/4.20'/n).read_text(encoding='utf-8')) for n in contracts];assert all(p['passed'] for p in data)
for n in ['qualify_native_fxaa_backend.py','inspect_native_texture_tables.py','inspect_native_presentation_calls.py','inspect_native_presentation_builder.py','inspect_native_presentation_inputs.py','qualify_native_presentation_descriptor.py','record_native_fxaa_backend.py']:shutil.copy2(Path('E:/mapslol3v3')/n,r/'tools'/n)
receipt='native_fxaa_backend_progress.json';proof=dict(updated_utc=now,passed=True,complete=False,contracts=[dict(path='data/4.20/'+n,sha256=hashlib.sha256((r/'data/4.20'/n).read_bytes()).hexdigest(),cases=p['case_count']) for n,p in zip(contracts,data)],native_sha256=data[0]['native_sha256'],texture_conversion_cases=6144,presentation_conversion_cases=288,native_msaa_selected_default_qualified=False,actual_gpu_allocation_qualified=False,native_shader_gpu_integrated=False,ordinary_renderer_changed=False,limits=[v for p in data for v in p['limits']])
(r/'docs'/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Retrouver et exécuter les producteurs du descripteur de présentation : indices MSAA et qualité aux offsets10/14 avant 9C46B0. Porter le shader FXAA récupéré et comparer son exécution GPU ; poursuivre le rendu/audio et les 24 domaines.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;p=json.loads(path.read_text(encoding='utf-8-sig'));p.update(updated_utc=now,native_fxaa_backend_progress='docs/'+receipt)
 if name=='resume_checkpoint.json':p.update(saved_utc=now,next_projected_action=next_action)
 elif name=='completion_plan.json':p['next_execution_steps'][0]=next_action
 elif name=='goal_plan_revision.json':p['next_steps']=[next_action]
 if name!='goal_plan_revision.json':
  evidence=p['last_verified'] if name=='resume_checkpoint.json' else p['current_evidence'];evidence.update(native_fxaa_backend_cases=6144,native_presentation_descriptor_cases=288,native_msaa_configuration_qualified=False,native_fxaa_gpu_integrated=False)
 path.write_text(json.dumps(p,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S),encoding='utf-8')
for name in ['completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;p=json.loads(path.read_text(encoding='utf-8'))
 if name=='completion_plan.json':p['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8')
 else:p['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest()
 path.write_text(json.dumps(p,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');html.write_text(text.replace('</body>','<section><h2>Relais FXAA et présentation Direct3D</h2><p>6144 cas de conversion de texture et 288 cas de conversion de présentation passés. Table MSAA native vérifiée pour les huit indices fournis : 0, 2, 4, 4, 5, 6, 3, 1. La valeur réellement sélectionnée par le jeu reste à retrouver ; aucun changement du MSAA de la caméra ordinaire.</p><p><a href="native_fxaa_backend_progress.json">Contrats et limites</a></p></section></body>'),encoding='utf-8')
print('6144 backend and 288 presentation conversion cases recorded; native MSAA default still unqualified.')
