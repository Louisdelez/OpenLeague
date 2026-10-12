from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_target_pose_progress.json';log='logs/native-troy-target-pose-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 507 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_target_pose_contract.json');assert native['passed'] and len(native['cases'])==608
files=['data/4.20/troy_target_pose_contract.json','tools/probe_native_troy_target_pose.py','crates/core/src/native_troy_target_pose.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Achever le reste du cycle Troy : reset200, carte audio8000, flag enfant10000, copie de sortie vers le wrapper et reset final des requêtes ; qualifier les producteurs virtuels et les paramètres natifs, raccorder le cycle complet au rendu normal des52groupes/244placements Map10, reconstruire les applications puis poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':507,'native_troy_target_pose_cases':608,'actual_cpu_sse_operations':native['actual_cpu_sse_operations'],'actual_cpu_x87_copies':native['actual_cpu_x87_copies'],'emulator_cpu_case_disagreements':native['emulator_cpu_case_disagreements'],'actual_cpu_rotation_calls':native['actual_cpu_rotation_calls'],'target_pose_phase_ported':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole second attach phase940AEE..940C15 captured in608cases. Rust matches target channels, wrapper/emitter matrices and callback order.', 'Absent target owner or eligibility0 skips the phase. Target success copies rawXYZ to emitter74/78/7C and unaligned wrapper2F/33/37; failed target query retains existing channels.', 'Rotation requires both wrapper flags10 and20 plus strictly positive squared horizontal length. NaN and zero length preserve orientation. Y axis does not enter the angle.', 'Original FPATAN angle(dx,dz) stored to f32 beforeFSIN/FCOS. Rust executes matching x87 instructions with saved/restored control word and masked nearest mode.', '1120actualCPU SSE operations,6120actualCPU x87 copies and180hardware rotation references. Original emulator captures retained separately;0case disagreements.'],'adapters':native['adapters'],'limits':native['limits']+['506previous core tests and the new property comparison pass; this does not qualify complete game/champion kits or graphical rendering.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-target-pose-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_target_pose_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=507,core_source_tests_passed=507,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=507,latest_native_execution_progress=receipt,troy_target_pose_cases=608,troy_target_pose_actual_cpu_sse_operations=1120,troy_target_pose_actual_cpu_x87_copies=6120,troy_target_pose_ported=True,troy_target_pose_graphical_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=507;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('506 tests moteur','507 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-target-pose"><h2>Second point d’attache Troy</h2><p>Phase940AEE..940C15 portée, comparée à608captures natives. Coordonnées cibles, orientation horizontale et ordre des appels correspondent.1120opérations SSE,6120copies x87 et180rotations vérifiées sur processeur réel.507tests moteur passent. Les autres phases et le raccordement graphique restent à qualifier.</p><a href="native_troy_target_pose_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':507,'native_cases':608,'complete':False}))
