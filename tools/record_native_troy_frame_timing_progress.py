from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_frame_timing_progress.json';log='logs/native-troy-frame-timing-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 522 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_reset_contract.json');assert native['passed'] and len(native['cases'])==432
files=['data/4.20/troy_frame_timing_contract.json','tools/probe_native_troy_frame_timing.py','crates/core/src/native_troy_frame_timing.rs','data/4.20/troy_frame_gate_contract.json','tools/probe_native_troy_frame_gate.py','crates/core/src/native_troy_frame_gate.rs','data/4.20/troy_visibility_contract.json','tools/probe_native_troy_visibility.py','data/4.20/troy_scratch_contract.json','tools/probe_native_troy_scratch.py','crates/core/src/native_troy_scratch.rs','data/4.20/troy_resume_contract.json','tools/probe_native_troy_resume.py','crates/core/src/native_troy_resume.rs','data/4.20/troy_pause_contract.json','tools/probe_native_troy_pause.py','data/4.20/troy_prewarm_contract.json','tools/probe_native_troy_prewarm.py','crates/core/src/native_troy_prewarm.rs','data/4.20/troy_reset_caller_contract.json','tools/probe_native_troy_reset_caller.py','data/4.20/troy_reset_contract.json','tools/probe_native_troy_reset.py','crates/core/src/native_troy_reset.rs','crates/core/src/native_complex_particle_storage.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Qualifier les producteurs émetteurs de93F2F0 et le déroulement des sous-pas, ses écritures finales et transitions avec enfants, les producteurs des plans/selecteurs, les producteurs audio réels, les émetteurs à la mort, la carte audio8000, le flag enfant10000 et les mises à jour des émetteurs ; qualifier les corps du gestionnaire et les producteurs natifs, composer le cycle complet puis le raccorder au rendu normal des52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
caller=load('data/4.20/troy_reset_caller_contract.json');warm=load('data/4.20/troy_prewarm_contract.json');assert len(caller['cases'])==363 and len(warm['cases'])==240
paused=load('data/4.20/troy_pause_contract.json');assert len(paused['cases'])==432 and paused['passed']
resumed=load('data/4.20/troy_resume_contract.json');assert resumed['passed'] and len(resumed['cases'])==1152
scratch=load('data/4.20/troy_scratch_contract.json');assert scratch['passed'] and len(scratch['cases'])==16
visibility=load('data/4.20/troy_visibility_contract.json');assert visibility['passed'] and len(visibility['cases'])==322
gate=load('data/4.20/troy_frame_gate_contract.json');assert gate['passed'] and len(gate['cases'])==1280
timing=load('data/4.20/troy_frame_timing_contract.json');assert timing['passed'] and len(timing['cases'])==1040
proof={'updated_utc':now,'complete':False,'native_sha256':timing['native_sha256'],'core_tests_passed':522,'frame_timing_cases':1040,'actual_cpu_sse_operations':7183,'actual_cpu_conversions':1100,'frame_timing_ported':True,'complete_frame_ported':False,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole93F45B..93F5C0 port matches1040native CPU captures: effective time, compensating offset, signed iteration count, step and status call order.7183actual CPU scalar operations and1100conversions recorded.','Cap uses config1C0 only above0.5; otherwise binary fallback0.5. Excess delta clamps effective time to last+cap and writes effective-current compensation.','Iteration count uses native truncating conversion(delta*engineE8), with80000000 on invalid conversion; step begins1/rate. Configbit8, engine statusbit1 or sourcebit4 force one step. Configbit40 forces one step only for zero count.','Counts above20 are converted to f32 then halved while step doubles until <=20; final count truncates. Negative/invalid counts are preserved in this qualified arithmetic phase.','Real engine rate/status producers, subsequent emitters and final frame writes remain incomplete.'],'adapters':timing['adapters'],'limits':timing['limits']+['No domain/champion kit complete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-frame-timing-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_frame_timing_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=522,core_source_tests_passed=522,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=522,latest_native_execution_progress=receipt,troy_frame_timing_cases=1040,troy_frame_timing_ported=True,troy_complete_frame_ported=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=522;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('521 tests moteur','522 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-frame-timing"><h2>Pas de simulation des effets</h2><p>Calculs93F45B..93F5C0 portés :1040captures,7183opérations SSE et1100conversions sur CPU réel. Compensation, nombre de pas, pas forcés et rattrapage correspondent.522tests moteur passent. Producteurs, déroulement des pas, écritures finales et rendu/audio restent à qualifier.</p><a href="native_troy_frame_timing_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':522,'frame_timing_cases':1040,'complete':False}))
