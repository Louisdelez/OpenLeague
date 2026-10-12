from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_birth_vectors_progress.json';log='logs/native-simple-birth-vectors-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert 'test result: ok. 574 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_birth_vectors_contract.json')
assert p['passed'] and len(p['cases'])==160 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
save('data/4.20/simple_birth_vectors_contract.json',p)
previous=load('docs/native_simple_birth_probability_progress.json')
previous.pop('simple_birth_scalar_variable_table_native_cases',None)
previous.pop('simple_birth_scalar_constant_probability_composition_qualified',None)
previous.update(simple_birth_probability_native_cases=160,simple_birth_probability_source_lifecycle_qualified=True)
save('docs/native_simple_birth_probability_progress.json',previous)
files=['crates/core/src/native_simple_birth_parameters.rs','crates/core/src/native_simple_emission_lifecycle.rs','crates/core/src/lib.rs','data/4.20/simple_birth_vectors_contract.json','tools/probe_native_simple_birth_vectors.py',log,'docs/native_simple_recycled_terrain_progress.json','docs/native_simple_birth_probability_progress.json']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
e=dict(core_tests_passed=574,simple_birth_scalar_variable_table_native_cases=40,simple_birth_scalar_constant_probability_composition_qualified=True,simple_birth_probability_native_cases=160,simple_birth_probability_source_lifecycle_qualified=True,simple_birth_vector_native_cases=160,simple_birth_scalar_vector_source_lifecycle_qualified=True,latest_native_execution_progress=receipt,latest_core_test_log=log)
limits=p['limits']+['Rust941F00 source path now samples raw scalar/vector tables and applies per-component probabilities in native interleaved order before auxiliary/insertion draws.160 whole native cases match all13arrays, emitter writes and entire RNG, including1/4 births and progress before/after authored range.','Attribute producer branches, rotation list, effective emission-rate producers and native resource binding remain unqualified; no ordinary graphics/audio or full champion/domain completion.']
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=[],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=limits))
h=r/'docs/plan_history'/('simple-birth-vectors-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Qualifier et raccorder les attributs natifs, listes de rotation et taux effectif à l’émission941F00 ; intégrer stockage, mémoire, fournisseurs de pose/terrain, puis rendu/audio Map10 et Annie ; poursuivre les24domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_birth_vectors_progress=receipt)
    if name=='goal_plan_revision.json':d.update(core_tests_passed=574,core_source_tests_passed=574,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False
        v=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];v.update(e)
        if name=='resume_checkpoint.json':v['core_tests']=574;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
    save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=re.sub(r'\d+ tests moteur','574 tests moteur',path.read_text(encoding='utf-8'))
    text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,h/path.name);path.write_text(path.read_text(encoding='utf-8').replace('</body>','<section><h2>Vecteurs natifs par naissance</h2><p>160émissions natives avec tables scalaires et vectorielles variables qualifiées. Position, vitesse, décalage et probabilités de chaque composante sont produits dans l’ordre aléatoire natif.574tests moteur passent. Ordre des producteurs dynamiques et intégration au jeu restent à terminer.</p><a href="native_simple_birth_parameters_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=574,native_cases=160,complete=False)))
