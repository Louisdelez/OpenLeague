from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_rate_source_progress.json';log='logs/native-simple-rate-source-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert 'test result: ok. 575 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_rate_source_contract.json')
assert p['passed'] and len(p['cases'])==320 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
save('data/4.20/simple_rate_source_contract.json',p)
files=['crates/core/src/native_simple_birth_parameters.rs','crates/core/src/native_simple_emission_lifecycle.rs','crates/core/src/lib.rs','crates/core/src/native_simple_emission_count.rs','data/4.20/simple_rate_source_contract.json','tools/probe_native_simple_rate_source.py',log,'docs/native_simple_recycled_terrain_progress.json','docs/native_simple_birth_probability_progress.json','docs/native_simple_birth_vectors_progress.json']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
e=dict(core_tests_passed=575,simple_birth_scalar_variable_table_native_cases=40,simple_birth_scalar_constant_probability_composition_qualified=True,simple_birth_probability_native_cases=160,simple_birth_probability_source_lifecycle_qualified=True,simple_birth_vector_native_cases=160,simple_birth_scalar_vector_source_lifecycle_qualified=True,simple_emission_rate_source_native_cases=320,simple_emission_rate_and_birth_shared_rng_qualified=True,latest_native_execution_progress=receipt,latest_core_test_log=log)
limits=p['limits']+['Rust gates before rate RNG, rate probability then supplied context scale, and interleaved scalar/vector birth sources match320 whole native cases including zero/negative rate, single/latch/life/delay/window gates. All13arrays, emitter state and full RNG match. Rate draws commit even when count zero; early gates consume no draws.','Rate attribute3A4, other attributes and rotation-list stages remain unqualified. Real resource binding, memory/pose/terrain providers and ordinary graphics/audio integration incomplete; no champion, task or domain complete.']
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=[],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=limits))
h=r/'docs/plan_history'/('simple-rate-source-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Qualifier et raccorder les attributs natifs et listes de rotation à l’émission941F00 ; intégrer stockage, mémoire, fournisseurs de pose/terrain, puis rendu/audio Map10 et Annie ; poursuivre les24domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_rate_source_progress=receipt)
    if name=='goal_plan_revision.json':d.update(core_tests_passed=575,core_source_tests_passed=575,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False
        v=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];v.update(e)
        if name=='resume_checkpoint.json':v['core_tests']=575;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
    save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=re.sub(r'\d+ tests moteur','575 tests moteur',path.read_text(encoding='utf-8'))
    text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,h/path.name);path.write_text(path.read_text(encoding='utf-8').replace('</body>','<section><h2>Taux natif et flux aléatoire des naissances</h2><p>320émissions natives qualifiées : portes avant tirage, taux variable et facteur de contexte, puis probabilités scalaires et vectorielles avec état aléatoire partagé. Les tirages du taux sont conservés même sans naissance.575tests moteur passent. Ordre des producteurs dynamiques et intégration au jeu restent à terminer.</p><a href="native_simple_birth_parameters_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=575,native_cases=320,complete=False)))
