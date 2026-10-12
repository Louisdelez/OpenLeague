from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_birth_factors_progress.json';log='logs/native-simple-birth-factors-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert 'test result: ok. 588 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_birth_factors_contract.json')
assert p['passed'] and len(p['cases'])==384 and len(p['adapters'])==1 and p['emulator_cpu_case_disagreements']==0
files=['crates/core/src/native_simple_rotation_list.rs','crates/core/src/lib.rs','crates/core/src/native_simple_emission_lifecycle.rs','crates/core/src/native_simple_birth_parameters.rs','data/4.20/simple_combined_sources_contract.json','tools/probe_native_simple_combined_sources.py','data/4.20/simple_rotation_transform_contract.json','tools/probe_native_simple_rotation_transform.py',log,'docs/native_simple_offset_attribute_progress.json']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
files += ['crates/core/src/native_simple_birth_factors.rs','data/4.20/simple_birth_factors_contract.json','tools/probe_native_simple_birth_factors.py','docs/native_simple_combined_sources_progress.json']
transform=load('data/4.20/simple_rotation_transform_contract.json');assert transform['passed'] and len(transform['cases'])==100 and transform['emulator_cpu_case_disagreements']==0 and transform['adapters']==[]
e=dict(simple_birth_factors_native_cases=384,simple_birth_factors_selected_qualified=True,core_tests_passed=588,simple_rotation_axis_angle_native_cases=105,simple_rotation_axis_angle_qualified=True,simple_rotation_list_composition_native_cases=100,simple_rotation_list_composition_selected_qualified=True,simple_rotation_list_matrix_qualified=False,simple_rotation_transform_native_capture_cases=100,simple_rotation_transform_rust_qualified=True,simple_rotation_emission_native_cases=160,simple_rotation_emission_controlled_storage_qualified=True,simple_rotation_list_sampling_selected_qualified=True,simple_final_offset_attribute_native_cases=384,simple_final_offset_attribute_source_qualified=True,simple_combined_emission_sources_native_cases=384,simple_combined_emission_sources_selected_qualified=True,latest_native_execution_progress=receipt,latest_core_test_log=log)
save(receipt,dict(updated_utc=now,complete=False,**e,native_sha256=p['native_sha256'],actual_cpu_sse_operations=p['actual_cpu_sse_operations'],adapters=p['adapters'],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=p['limits']+['Rust contextual offset/bounds factors, optional life multiplier before negative fallback, offset/size attribute multipliers are composed with all previously qualified source stages and rotation lists.384 whole native emissions match prepared factors, scaled births, all13arrays, emitter state and full RNG. Selected finite profiles only; x87 extreme rounding, native allocation/source population and ordinary game binding remain incomplete; no champion/task/domain complete.']))
h=r/'docs/plan_history'/('simple-birth-factors-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
next_action='Qualifier les arrondis x87 extrêmes et fournisseurs mémoire/pose/terrain, les autres branches de naissance ; raccorder les sources généralisées au cycle complet, puis au rendu/audio Map10 et Annie ; poursuivre les 24 domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
 shutil.copy2(r/'docs'/name,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_birth_factors_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=588,core_source_tests_passed=588,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False
  v=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];v.update(e)
  if name=='resume_checkpoint.json':v['core_tests']=588;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
 save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=re.sub(r'\d+ tests moteur','588 tests moteur',path.read_text(encoding='utf-8'));text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,h/path.name);path.write_text(path.read_text(encoding='utf-8').replace('</body>','<section><h2>Facteurs natifs de naissance</h2><p>384 émissions natives concordantes avec facteurs contextuels de décalage et limites, multiplicateur de durée de vie et attributs de décalage/taille ; tous les producteurs précédents et listes de rotation sont composés. Facteurs préparés, naissances après multiplication, tableaux et état aléatoire complet vérifiés. Mémoire temporaire fournie explicitement. 588 tests moteur passent. Autres branches, fournisseurs, arrondis extrêmes et intégration au rendu restent à terminer.</p><a href="native_simple_birth_factors_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=588,native_cases=384,complete=False)))
