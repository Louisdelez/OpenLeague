from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_birth_parameters_progress.json';log='logs/native-simple-birth-parameters-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert 'test result: ok. 572 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_birth_parameters_contract.json')
assert p['passed'] and len(p['cases'])==40 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
p['limits'][0]='Actual whole emission with four variable scalar tables and constant probability7. Base948FB0 reads ignore probability;941F00 applies probabilities per birth. Rate74 uses948EE0.'
save('data/4.20/simple_birth_parameters_contract.json',p)
files=['crates/core/src/native_simple_birth_parameters.rs','crates/core/src/native_simple_emission_lifecycle.rs','crates/core/src/lib.rs','data/4.20/simple_birth_parameters_contract.json','tools/probe_native_simple_birth_parameters.py',log,'docs/native_simple_recycled_terrain_progress.json']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
e=dict(core_tests_passed=572,simple_birth_scalar_variable_table_native_cases=40,simple_birth_scalar_constant_probability_composition_qualified=True,latest_native_execution_progress=receipt,latest_core_test_log=log)
limits=['Selected whole emission profiles use variable four-element life/scalar/scale/rotation tables and constant probability7; all13arrays, emitter writes and RNG match. No rate, vector or attribute source generalization claimed.','Base948FB0 ignores descriptor probability;941F00 applies it per birth later. Source staging must preserve intervening vector/attribute RNG order. Helpers do not yet schedule general emission.','Negative birth life maps to MAX at942B99; authored scale/rotation/scalar negatives preserved.','Memory backend, actual terrain provider, generalized source production and ordinary renderer/audio integration remain incomplete. No completed champion, task or domain.']
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=[],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=limits))
h=r/'docs/plan_history'/('simple-birth-parameters-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Raccorder les paramètres natifs de naissance et leurs probabilités par particule à l’émission941F00 en préservant l’ordre RNG des vecteurs et attributs ; intégrer le stockage, qualifier mémoire, fournisseurs de pose/terrain, puis rendu/audio Map10 et Annie ; poursuivre les24domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_birth_parameters_progress=receipt)
    if name=='goal_plan_revision.json':d.update(core_tests_passed=572,core_source_tests_passed=572,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False
        v=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];v.update(e)
        if name=='resume_checkpoint.json':v['core_tests']=572;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
    save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=path.read_text(encoding='utf-8').replace('571 tests moteur','572 tests moteur')
    text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,h/path.name);path.write_text(path.read_text(encoding='utf-8').replace('</body>','<section><h2>Paramètres natifs de naissance</h2><p>40émissions natives avec tables variables et probabilités constantes qualifiées. Lecture des tables puis probabilités par particule et traitement des durées négatives portés.572tests moteur passent. Ordre des producteurs dynamiques et intégration au jeu restent à terminer.</p><a href="native_simple_birth_parameters_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=572,native_cases=40,complete=False)))
