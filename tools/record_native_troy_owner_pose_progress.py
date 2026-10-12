from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_owner_pose_progress.json';log='logs/native-troy-owner-pose-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 506 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_owner_pose_contract.json');assert native['passed'] and len(native['cases'])==288
files=['data/4.20/troy_owner_pose_contract.json','tools/probe_native_troy_owner_pose.py','crates/core/src/native_troy_owner_pose.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Achever le reste du cycle Troy : reset200, carte audio8000, flag enfant10000, pose du second propriétaire et reset final des requêtes ; qualifier les producteurs virtuels et les paramètres natifs, raccorder le cycle complet au rendu normal des52groupes/244placements Map10, reconstruire les applications puis poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':506,'native_troy_owner_pose_cases':288,'actual_cpu_sse_operations':native['actual_cpu_sse_operations'],'actual_cpu_x87_copies':native['actual_cpu_x87_copies'],'emulator_cpu_case_disagreements':native['emulator_cpu_case_disagreements'],'owner_pose_phase_ported':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original94099A..940AEE and whole93F1A0 owner status/deferred dispatch captured in288cases. Rust matches native position/bounds/direction, matrices, source flag8, pending queue length and exact callback sequence.', 'Owner absent or eligibility byte0 skips the entire phase and preserves queued callbacks. Nonzero eligibility invokes position then direction; failed producers preserve old fields.', 'Orientation is queried only when wrapper flags10 set and20 clear. Two x87 matrix copies quiet signalingNaN; source and emitter matrix components12,13,14 reset to0.', 'Secondary owner byte queried first and saved on stack; primary virtual takes no arguments. Both bytes are passed raw to93F1A0. Config flags2/4 individually suppress owner contributions to emitter source flag8. Other bits preserved.', 'Original pending callback vector copied and cleared before callbacks; callbacks observe empty original queue. Rust uses explicit handler IDs and dispatch backend, never executes an imported code pointer.', '768actualCPU SSE operations and1536actualCPU x87 copies;41original VM discrepancies retained separately.'],'adapters':native['adapters'],'limits':native['limits']+['505previous core tests and the new property comparison pass; this does not qualify complete game/champion kits or graphical rendering.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-owner-pose-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_owner_pose_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=506,core_source_tests_passed=506,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=506,latest_native_execution_progress=receipt,troy_owner_pose_cases=288,troy_owner_pose_actual_cpu_sse_operations=768,troy_owner_pose_actual_cpu_x87_copies=1536,troy_owner_pose_ported=True,troy_owner_pose_graphical_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=506;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('505 tests moteur','506 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-owner-pose"><h2>Pose du propriétaire Troy</h2><p>Phase94099A..940AEE et statut/callbacks93F1A0 portés, comparés à288captures natives. Position/bornes, direction, orientation, flags et ordre des appels correspondent.768opérations SSE et1536copies x87 vérifiées sur processeur réel.506tests moteur passent. Producteurs virtuels, autres phases et raccordement graphique restent à qualifier.</p><a href="native_troy_owner_pose_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':506,'native_cases':288,'complete':False}))
