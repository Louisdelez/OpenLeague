from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_initial_direction_progress.json';log='logs/native-missile-initial-direction-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
o=load('data/4.20/missile_initial_direction_speed_contract.json');b=load('data/4.20/missile_initial_direction_contract.json');assert o['passed'] and b['passed']
next_action='Qualifier la sélection native du projectile ciblé d’Annie et sa direction pendant le déplacement, raccorder la pose10B0D20 au rendu, puis contrôler scale/alpha/récepteurs terrain et poursuivre les24domaines.'
files=['crates/core/src/native_missile_initial_direction.rs','crates/core/src/lib.rs','logs/native-missile-initial-direction-tests-failed-v1.log','data/4.20/missile_initial_direction_speed_contract.json','data/4.20/missile_initial_direction_contract.json','tools/probe_native_missile_initial_direction.py','tools/probe_native_missile_initial_speed.py',log]
proof=dict(updated_utc=now,complete=False,native_sha256=o['native_sha256'],native_initial_direction_cases=144,native_fixed_direction_cases=96,actual_cpu_rsqrt_operations=278,focused_core_tests_passed=1,filtered_core_tests=594,full_core_suite_rerun=False,ordinary_projected_binding=False,client_rebuilt=False,artifacts_sha256={p:sha(p) for p in files},findings=['Whole75FB00 initializes direction using target minus launch origin, height augmentation,66D6E0 inverse-root correction and fixed/min travel time.','Zero fixed time executes whole75FF20 estimate and75EF50 scaling. The estimate uses integer bit square-root approximations; replacing them with exact sqrt changes outputs.','Original loader767170..769xxx identifies fields:5C4 MissileSpeed,5C8 MissileAccel,5CC MaxSpeed,5D0 MinSpeed,5D4 FixedTravelTime,5D8 MinTravelTime,574 TargetHeightAugment. Cast wrapper prefix34 explains consumer offsets. This mapping is static evidence.','96positive fixed-time cases and144fixed/speed1400 zero-acceleration cases execute. Rust matches144direction/time raw outputs.','Native75EF50 renormalizes horizontal speed when vertical direction is nonzero; initial reversed Rust branch corrected after mismatch case12. Failed test retained in separate log.','Supplied community MissileType enum names Target=1; retained as a navigation reference, not native dispatch proof.'],limits=['Zero-acceleration1400speed/min/max profile only; other speed/acceleration values, independent current position and exceptional fields remain unqualified.','Exact targeted-Annie subtype selection and movement-frame direction producer unproven; this is initialization evidence.','No ordinary game integration, client rebuild or GPU/audio acceptance.','One focused test run,594filtered; no new full core-suite result.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-owner-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_initial_direction_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_missile_initial_direction_cases=144,native_missile_initial_fixed_cases=96,native_missile_initial_focused_tests=1,native_missile_owner_live_bound=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15'] and receipt not in dom.setdefault('progress_evidence',[]):dom['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 if p.exists():s=p.read_text(encoding='utf-8');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Pose native du projectile</h2><p>Direction initiale native portée :144cas fixes/vitesse1400 à accélération nulle comparés bit à bit,278opérations RSQRTSS CPU. Un test ciblé passe,594filtrés. Sélection du projectile ciblé, déplacement et rendu normal restent ouverts.</p><a href="native_missile_effect_owner_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')

if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,complete=False,focused_tests=1)))

