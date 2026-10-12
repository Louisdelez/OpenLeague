from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_rotation_attribute_progress.json';log='logs/native-simple-rotation-attribute-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert 'test result: ok. 580 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_rotation_attribute_contract.json')
assert p['passed'] and len(p['cases'])==384 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
save('data/4.20/simple_rotation_attribute_contract.json',p)
files=['crates/core/src/native_simple_birth_parameters.rs','crates/core/src/native_simple_emission_lifecycle.rs','crates/core/src/lib.rs','crates/core/src/native_particle_attributes.rs','crates/core/src/native_simple_emission_count.rs','data/4.20/simple_rotation_attribute_contract.json','tools/probe_native_simple_rotation_attribute.py',log,'docs/native_simple_recycled_terrain_progress.json','docs/native_simple_birth_probability_progress.json','docs/native_simple_birth_vectors_progress.json','docs/native_simple_rate_source_progress.json','docs/native_particle_attribute_lookup_progress.json','docs/native_simple_rate_attribute_progress.json','docs/native_simple_life_attribute_progress.json','docs/native_simple_vector_attributes_progress.json']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
e=dict(core_tests_passed=580,simple_birth_scalar_variable_table_native_cases=40,simple_birth_scalar_constant_probability_composition_qualified=True,simple_birth_probability_native_cases=160,simple_birth_probability_source_lifecycle_qualified=True,simple_birth_vector_native_cases=160,simple_birth_scalar_vector_source_lifecycle_qualified=True,simple_emission_rate_source_native_cases=320,simple_emission_rate_and_birth_shared_rng_qualified=True,particle_attribute_lookup_native_cases=132,particle_attribute_lookup_finite_snapshot_qualified=True,simple_rate_attribute_native_cases=384,simple_rate_attribute_selected_source_qualified=True,simple_life_attribute_native_cases=384,simple_life_attribute_two_stage_source_qualified=True,simple_vector_attribute_native_cases=384,simple_position_velocity_attribute_two_stage_source_qualified=True,simple_rotation_attribute_native_cases=384,simple_rotation_attribute_two_stage_source_qualified=True,latest_native_execution_progress=receipt,latest_core_test_log=log)
limits=p['limits']+['Rust rotation raw-weight preparation and per-birth own/attribute probability stages now compose with rate/life/position/velocity attributes.384 whole native cases match prepared rotation/life/vectors, effective rate, all13arrays, emitter state and full RNG. Negative rotation remains signed, with no life fallback.','Rotation lists, x87 rounding extremes, source attribute population, memory/pose/terrain providers and ordinary graphics/audio integration remain incomplete; no champion/task/domain complete.']
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=[],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=limits))
h=r/'docs/plan_history'/('simple-rotation-attribute-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Qualifier et raccorder les listes de rotation et les arrondis x87 extrêmes ; intégrer producteurs, stockage, mémoire et fournisseurs de pose/terrain au cycle complet, puis au rendu/audio Map10 et Annie ; poursuivre les24domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_rotation_attribute_progress=receipt)
    if name=='goal_plan_revision.json':d.update(core_tests_passed=580,core_source_tests_passed=580,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False
        v=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];v.update(e)
        if name=='resume_checkpoint.json':v['core_tests']=580;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
    save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=re.sub(r'\d+ tests moteur','580 tests moteur',path.read_text(encoding='utf-8'))
    text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,h/path.name);path.write_text(path.read_text(encoding='utf-8').replace('</body>','<section><h2>Attribut natif de rotation</h2><p>384émissions natives qualifiées avec attribut de rotation et les autres attributs raccordés. Préparation brute puis probabilités sur la rotation augmentée, valeurs négatives conservées et ordre des tirages vérifié. Préparations, tableaux de particules et état aléatoire concordent. Listes de rotation et arrondis extrêmes restent à qualifier.580tests moteur passent. Ordre des producteurs dynamiques et intégration au jeu restent à terminer.</p><a href="native_simple_birth_parameters_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=580,native_cases=384,complete=False)))
