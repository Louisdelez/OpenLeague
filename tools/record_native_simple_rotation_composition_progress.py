from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_rotation_composition_progress.json';log='logs/native-simple-rotation-composition-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert 'test result: ok. 583 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_rotation_composition_contract.json')
assert p['passed'] and len(p['cases'])==100 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
files=['crates/core/src/native_simple_rotation_list.rs','crates/core/src/lib.rs','data/4.20/simple_rotation_composition_contract.json','tools/probe_native_simple_rotation_composition.py','data/4.20/simple_rotation_transform_contract.json','tools/probe_native_simple_rotation_transform.py',log,'docs/native_simple_rotation_matrix_progress.json']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
transform=load('data/4.20/simple_rotation_transform_contract.json');assert transform['passed'] and len(transform['cases'])==100 and transform['emulator_cpu_case_disagreements']==0 and transform['adapters']==[]
e=dict(core_tests_passed=583,simple_rotation_axis_angle_native_cases=105,simple_rotation_axis_angle_qualified=True,simple_rotation_list_composition_native_cases=100,simple_rotation_list_composition_selected_qualified=True,simple_rotation_list_matrix_qualified=False,simple_rotation_transform_native_capture_cases=100,simple_rotation_transform_rust_qualified=False,latest_native_execution_progress=receipt,latest_core_test_log=log)
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=[],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=p['limits']+['Rust pre-sampled list composition matches all16matrix words, unchanged flag and complete55word RNG/cursors across100native sequences. Finite axes, empty/zero lists, multiple rotations and five probability modes supplied. Resource sampling, final transforms and ordinary game binding remain incomplete; no champion/task/domain complete.']))
h=r/'docs/plan_history'/('simple-rotation-composition-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Raccorder en Rust les transformations finales de position/vitesse à partir des 100 captures natives ; qualifier la lecture des listes de rotation et les arrondis x87 extrêmes ; intégrer producteurs, stockage, mémoire et fournisseurs de pose/terrain au cycle complet, puis au rendu/audio Map10 et Annie ; poursuivre les 24 domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
 shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_rotation_composition_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=583,core_source_tests_passed=583,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False
  v=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];v.update(e)
  if name=='resume_checkpoint.json':v['core_tests']=583;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
 save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=re.sub(r'\d+ tests moteur','583 tests moteur',path.read_text(encoding='utf-8'));text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,h/path.name);path.write_text(path.read_text(encoding='utf-8').replace('</body>','<section><h2>Composition des rotations</h2><p>100 séquences natives concordantes : matrices composées, rotations ignorées et état aléatoire complet vérifiés. 583 tests moteur passent. Lecture des ressources, transformations finales et intégration au rendu restent à terminer.</p><a href="native_simple_rotation_composition_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=583,native_cases=100,complete=False)))
