from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_vector_attributes_progress.json';log='logs/native-simple-vector-attributes-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert 'test result: ok. 579 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_vector_attributes_contract.json')
assert p['passed'] and len(p['cases'])==384 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
save('data/4.20/simple_vector_attributes_contract.json',p)
files=['crates/core/src/native_simple_birth_parameters.rs','crates/core/src/native_simple_emission_lifecycle.rs','crates/core/src/lib.rs','crates/core/src/native_particle_attributes.rs','crates/core/src/native_simple_emission_count.rs','data/4.20/simple_vector_attributes_contract.json','tools/probe_native_simple_vector_attributes.py',log,'docs/native_simple_recycled_terrain_progress.json','docs/native_simple_birth_probability_progress.json','docs/native_simple_birth_vectors_progress.json','docs/native_simple_rate_source_progress.json','docs/native_particle_attribute_lookup_progress.json','docs/native_simple_rate_attribute_progress.json','docs/native_simple_life_attribute_progress.json']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
e=dict(core_tests_passed=579,simple_birth_scalar_variable_table_native_cases=40,simple_birth_scalar_constant_probability_composition_qualified=True,simple_birth_probability_native_cases=160,simple_birth_probability_source_lifecycle_qualified=True,simple_birth_vector_native_cases=160,simple_birth_scalar_vector_source_lifecycle_qualified=True,simple_emission_rate_source_native_cases=320,simple_emission_rate_and_birth_shared_rng_qualified=True,particle_attribute_lookup_native_cases=132,particle_attribute_lookup_finite_snapshot_qualified=True,simple_rate_attribute_native_cases=384,simple_rate_attribute_selected_source_qualified=True,simple_life_attribute_native_cases=384,simple_life_attribute_two_stage_source_qualified=True,simple_vector_attribute_native_cases=384,simple_position_velocity_attribute_two_stage_source_qualified=True,latest_native_execution_progress=receipt,latest_core_test_log=log)
limits=p['limits']+['Rust raw vector-weight preparation and per-birth component probabilities use augmented vectors in the native interleaved order.384 whole cases match prepared position/velocity/life, effective rate, all13arrays, emitter state and full RNG. SSE multiplications and additions remain separate.','Rotation attribute/list, x87 extremes in rate/life branches, source attribute population, memory/pose/terrain providers and ordinary graphics/audio integration remain incomplete; no champion/task/domain complete.']
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=[],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=limits))
h=r/'docs/plan_history'/('simple-vector-attributes-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Raccorder et qualifier l’attribut de rotation, les listes de rotation et les arrondis x87 extrêmes ; intégrer producteurs complets, stockage, mémoire, fournisseurs de pose/terrain puis rendu/audio Map10 et Annie ; poursuivre les24domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_vector_attributes_progress=receipt)
    if name=='goal_plan_revision.json':d.update(core_tests_passed=579,core_source_tests_passed=579,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False
        v=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];v.update(e)
        if name=='resume_checkpoint.json':v['core_tests']=579;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
    save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=re.sub(r'\d+ tests moteur','579 tests moteur',path.read_text(encoding='utf-8'))
    text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,h/path.name);path.write_text(path.read_text(encoding='utf-8').replace('</body>','<section><h2>Attributs natifs de position et de vitesse</h2><p>384émissions natives qualifiées avec attributs de position et vitesse : pondérations brutes préparées puis probabilités de composantes appliquées aux vecteurs augmentés. Préparations, taux, durée, tableaux de particules et état aléatoire concordent. Attribut/listes de rotation et arrondis x87 extrêmes restent à qualifier.579tests moteur passent. Ordre des producteurs dynamiques et intégration au jeu restent à terminer.</p><a href="native_simple_birth_parameters_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=579,native_cases=384,complete=False)))
