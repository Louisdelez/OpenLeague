from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_frame_finish_progress.json';log='logs/native-troy-frame-finish-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 525 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_reset_contract.json');assert native['passed'] and len(native['cases'])==432
files=['data/4.20/troy_frame_finish_contract.json','tools/probe_native_troy_frame_finish.py','crates/core/src/native_troy_frame_finish.rs','data/4.20/troy_substeps_contract.json','tools/probe_native_troy_substeps.py','crates/core/src/native_troy_substeps.rs','data/4.20/troy_frame_timing_contract.json','tools/probe_native_troy_frame_timing.py','crates/core/src/native_troy_frame_timing.rs','data/4.20/troy_frame_gate_contract.json','tools/probe_native_troy_frame_gate.py','crates/core/src/native_troy_frame_gate.rs','data/4.20/troy_visibility_contract.json','tools/probe_native_troy_visibility.py','data/4.20/troy_scratch_contract.json','tools/probe_native_troy_scratch.py','crates/core/src/native_troy_scratch.rs','data/4.20/troy_resume_contract.json','tools/probe_native_troy_resume.py','crates/core/src/native_troy_resume.rs','data/4.20/troy_pause_contract.json','tools/probe_native_troy_pause.py','data/4.20/troy_prewarm_contract.json','tools/probe_native_troy_prewarm.py','crates/core/src/native_troy_prewarm.rs','data/4.20/troy_reset_caller_contract.json','tools/probe_native_troy_reset_caller.py','data/4.20/troy_reset_contract.json','tools/probe_native_troy_reset.py','crates/core/src/native_troy_reset.rs','crates/core/src/native_complex_particle_storage.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Qualifier les producteurs934340/9437E0, le profilage et les descripteurs audio actifs de93EE30 ; composer les phases de93F2F0 et les transitions avec enfants, qualifier les plans/selecteurs et les producteurs audio réels, puis raccorder le cycle au rendu normal des52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
caller=load('data/4.20/troy_reset_caller_contract.json');warm=load('data/4.20/troy_prewarm_contract.json');assert len(caller['cases'])==363 and len(warm['cases'])==240
paused=load('data/4.20/troy_pause_contract.json');assert len(paused['cases'])==432 and paused['passed']
resumed=load('data/4.20/troy_resume_contract.json');assert resumed['passed'] and len(resumed['cases'])==1152
scratch=load('data/4.20/troy_scratch_contract.json');assert scratch['passed'] and len(scratch['cases'])==16
visibility=load('data/4.20/troy_visibility_contract.json');assert visibility['passed'] and len(visibility['cases'])==322
gate=load('data/4.20/troy_frame_gate_contract.json');assert gate['passed'] and len(gate['cases'])==1280
timing=load('data/4.20/troy_frame_timing_contract.json');assert timing['passed'] and len(timing['cases'])==1040
substeps=load('data/4.20/troy_substeps_contract.json');assert substeps['passed'] and len(substeps['cases'])==648
tail=load('data/4.20/troy_frame_finish_contract.json');assert tail['passed'] and len(tail['cases'])==2048
proof={'updated_utc':now,'complete':False,'native_sha256':tail['native_sha256'],'core_tests_passed':525,'frame_finish_cases':2048,'actual_cpu_sse_operations':256,'emulator_cpu_case_disagreements':0,'frame_finish_disabled_audio_ported':True,'enabled_one_shot_audio_supported':False,'complete_frame_ported':False,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Native93F9BD..93FA0B tail and disabled-descriptor93EE30 match2048captures: all256flag bytes, visibility, emit/stopped paths, raw time words and counter wrap.','Stopped tail skips input-time/visibility writes and one-shot call. Both tails apply stop-bit policy and wrapping context14 increment.','Enabled one-shot audio descriptors explicitly rejected before mutation when the helper would be called. Stopped tails skip those descriptors.','256actual CPU scalar operations; no VM/CPU differences. No graphical or real-audio integration claimed.'],'adapters':tail['adapters'],'limits':tail['limits']+['No domain/champion kit complete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-frame-finish-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_frame_finish_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=525,core_source_tests_passed=525,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=525,latest_native_execution_progress=receipt,troy_frame_finish_cases=2048,troy_frame_finish_disabled_audio_ported=True,troy_child_producers_qualified=False,troy_complete_frame_ported=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=525;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('523 tests moteur','525 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-frame-finish"><h2>Écritures finales du cycle des particules</h2><p>Port93F9BD..93FA0B :2048captures natives,256opérations SSE sur CPU réel. Temps brut, visibilité, arrêt et compteur correspondent.525tests moteur passent. Descripteurs audio actifs, producteurs et intégration restent à qualifier.</p><a href="native_troy_frame_finish_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':525,'frame_finish_cases':2048,'complete':False}))
