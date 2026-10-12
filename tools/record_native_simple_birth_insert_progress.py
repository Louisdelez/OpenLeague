from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re
r=Path('E:/OpenLeague'); now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_birth_insert_progress.json';log='logs/native-simple-birth-insert-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 566 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/simple_frame_particles_contract.json');pose=load('data/4.20/simple_attachment_cpu_contract.json')
for proof,count in [(native,384),(pose,112)]:assert proof['passed'] and len(proof['cases'])==count and proof['adapters']==[] and proof['emulator_cpu_case_disagreements']==0
files=['crates/core/src/'+name+'.rs' for name in ['native_simple_pose','native_simple_concrete_frame','native_simple_frame','native_simple_control','native_simple_auxiliary','native_simple_animation_policy','native_simple_finish','native_simple_particle_update','matrix_inverse','lib']]
birth=load('data/4.20/simple_birth_cpu_contract.json');assert birth['passed'] and len(birth['cases'])==48 and birth['adapters']==[] and birth['emulator_cpu_case_disagreements']==0
insertion=load('data/4.20/simple_birth_insert_contract.json');assert insertion['passed'] and len(insertion['cases'])==80 and len(insertion['adapters'])==1 and insertion['emulator_cpu_case_disagreements']==0
files+=['crates/core/src/native_scalar_parameter.rs','crates/core/src/native_probability_curve.rs']
files+=['data/4.20/simple_birth_insert_contract.json','tools/probe_native_simple_birth_insert.py']
files+=['crates/core/src/native_simple_birth_insert.rs','crates/core/src/native_simple_scalar_phase.rs','crates/core/src/native_random.rs','data/4.20/simple_birth_cpu_contract.json','tools/probe_native_simple_birth_cpu.py','docs/native_simple_concrete_frame_progress.json']
files+=['data/4.20/simple_frame_particles_contract.json','data/4.20/simple_attachment_cpu_contract.json','tools/probe_native_simple_frame_particles.py','tools/probe_native_simple_attachment_cpu.py',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action="Intégrer941F00 avec échantillonnage et allocation réels dans9437E0 ; qualifier le modificateur de pose93BBD0, les producteurs système et le fournisseur terrain ; intégrer au cycle93F2F0, puis au rendu/audio Map10 et à la projection d’Annie ; reconstruire les applications et poursuivre les24domaines."
save(receipt,dict(updated_utc=now,complete=False,native_sha256=native['native_sha256'],core_tests_passed=566,simple_pose_cpu_cases=112,simple_frame_particles_native_cases=384,simple_frame_particles_rust_qualified=True,simple_birth_cpu_cases=48,simple_birth_insertion_append_qualified=True,simple_birth_insertion_policy_qualified=True,simple_birth_insertion_native_cases=80,insertion_adapters=insertion["adapters"],real_terrain_height_provider_qualified=False,normal_emission_qualified=False,pose_modifier_qualified=False,ordinary_emitter_consumer_bound=False,ordinary_applications_rebuilt=False,artifacts_sha256={p:sha(p) for p in files},findings=['Original whole941F00 emitted48 selected burst cases with all13 arrays and RNG captured:4296 actual CPU SSE operations and zero VM/CPU differences. Native943CD0 Rust append insertion matches all arrays and caller birth draws/RNG. Rust943CD0 additionally matches80 direct native cases with first expired slot reuse, NaN age skip, null/constant/fast/generic scale probabilities and height provider X/Z/Y arguments.380 CPU SSE operations, no VM/CPU differences. Height provider controlled; real terrain source remains incomplete.','Rust943300 cold and warm owner matrices match112 native CPU cases, including previous matrix and inverse retention. Optional93BBD0 source remains an explicit callback with error propagation.','Rust9437E0 now composes actual owner pose and entire944E20 consumers, auxiliary/animation policy and final pose inverse/end state.384 warm-owner end-of-life cases match all captured particle/emitter arrays and outer call order bit for bit.','Owner previous matrix and inverse are synchronized to final owner writes for subsequent updates. State and RNG commit together after success; external source/observer effects cannot be rolled back.','Native384 fixture executes actual bodies with80672 hardware scalar SSE operations and960 conversions, no endpoint adapters and zero VM/CPU differences.'],limits=native['limits']+['Selected end-of-life profiles suppress emission; no non-null helper, modifier or animation source qualification in these384 cases.','Normal emission, actual allocation/birth production, system bone pose, terrain provider, rendered/audio acceptance and ordinary executable integration remain incomplete.','No complete champion, task or domain is claimed.']))
history=r/'docs/plan_history'/('simple-birth-insert-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
evidence=dict(core_tests_passed=566,latest_native_execution_progress=receipt,latest_core_test_log=log,simple_pose_cpu_cases=112,simple_pose_core_ported=True,simple_birth_cpu_cases=48,simple_birth_insertion_append_qualified=True,simple_birth_insertion_policy_qualified=True,simple_birth_insertion_native_cases=80,simple_frame_particles_native_cases=384,simple_frame_particles_rust_qualified=True,complete_simple_update_ported=False)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_simple_birth_insert_progress=receipt)
    if name=='goal_plan_revision.json':d.update(core_tests_passed=566,core_source_tests_passed=566,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(evidence)
        if name=='resume_checkpoint.json':e['core_tests']=566;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ['03','10','15']:domain.setdefault('progress_evidence',[]).append(receipt)
    save('docs/'+name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=path.read_text(encoding='utf-8').replace('564 tests moteur','566 tests moteur');text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,history/path.name)
text=path.read_text(encoding='utf-8').replace('</body>','<section id="native-simple-birth-insert"><h2>Insertion native des particules</h2><p>Insertion Rust qualifiée sur les13tableaux de48émissions natives et l’état aléatoire ;566tests moteur passent. Réutilisation, probabilités et appel de hauteur initiale correspondent aussi à80cas natifs ; fournisseur terrain réel et émission complète restent à intégrer. Émission normale, producteurs de pose, rendu et audio restent à intégrer et qualifier.</p><a href="native_simple_birth_insert_progress.json">Preuves et limites</a></section></body>');path.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=566,frame_cases=384,complete=False)))
