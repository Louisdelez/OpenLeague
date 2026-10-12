from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_frame_gate_progress.json';log='logs/native-troy-frame-gate-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 521 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_reset_contract.json');assert native['passed'] and len(native['cases'])==432
files=['data/4.20/troy_frame_gate_contract.json','tools/probe_native_troy_frame_gate.py','crates/core/src/native_troy_frame_gate.rs','data/4.20/troy_visibility_contract.json','tools/probe_native_troy_visibility.py','data/4.20/troy_scratch_contract.json','tools/probe_native_troy_scratch.py','crates/core/src/native_troy_scratch.rs','data/4.20/troy_resume_contract.json','tools/probe_native_troy_resume.py','crates/core/src/native_troy_resume.rs','data/4.20/troy_pause_contract.json','tools/probe_native_troy_pause.py','data/4.20/troy_prewarm_contract.json','tools/probe_native_troy_prewarm.py','crates/core/src/native_troy_prewarm.rs','data/4.20/troy_reset_caller_contract.json','tools/probe_native_troy_reset_caller.py','data/4.20/troy_reset_contract.json','tools/probe_native_troy_reset.py','crates/core/src/native_troy_reset.rs','crates/core/src/native_complex_particle_storage.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Achever les calculs de temps et les producteurs émetteurs de93F2F0, ses écritures finales et transitions avec enfants, les producteurs des plans/selecteurs, les producteurs audio réels, les émetteurs à la mort, la carte audio8000, le flag enfant10000 et les mises à jour des émetteurs ; qualifier les corps du gestionnaire et les producteurs natifs, composer le cycle complet puis le raccorder au rendu normal des52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
caller=load('data/4.20/troy_reset_caller_contract.json');warm=load('data/4.20/troy_prewarm_contract.json');assert len(caller['cases'])==363 and len(warm['cases'])==240
paused=load('data/4.20/troy_pause_contract.json');assert len(paused['cases'])==432 and paused['passed']
resumed=load('data/4.20/troy_resume_contract.json');assert resumed['passed'] and len(resumed['cases'])==1152
scratch=load('data/4.20/troy_scratch_contract.json');assert scratch['passed'] and len(scratch['cases'])==16
visibility=load('data/4.20/troy_visibility_contract.json');assert visibility['passed'] and len(visibility['cases'])==322
gate=load('data/4.20/troy_frame_gate_contract.json');assert gate['passed'] and len(gate['cases'])==1280
proof={'updated_utc':now,'complete':False,'native_sha256':gate['native_sha256'],'core_tests_passed':521,'frame_gate_cases':1280,'actual_cpu_sse_operations':358,'frame_visibility_lifetime_transitions_ported':True,'qualified_pause_resume_composed':True,'complete_frame_ported':False,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['First93F2F0 phase compared to1280native captures with actual8E36B0visibility,93EF80pause,93EEE0resume and93ED60acquisition. Rust composes previously qualified modules; flags, handles, delay and event order match.','Native source flag40 forces in-view before flag1DCbit8 suppresses visibility. Hidden effects stop under flag10 or finite/unordered lifetime gates; preexisting stop bit bypasses transition/audio phases.','Config20 performs acquisition and audio pause with inverted visibility. Changes against stored flag1DCbit2 invoke actual pause/resume policies. Hidden unforced effects branch to skip; other active effects continue.','Engine virtual2C return stored verbatim in config-relative58. Fixture supplies99; its production semantics not qualified, regardless of internal clock label.','Captures use empty child arrays and disabled descriptors for this composition. Nonempty-child transitions and remaining skip/stop/final writes need separate qualification.'],'adapters':gate['adapters'],'limits':gate['limits']+['No domain/champion kit complete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-frame-gate-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_frame_gate_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=521,core_source_tests_passed=521,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=521,latest_native_execution_progress=receipt,troy_frame_gate_cases=1280,troy_frame_transitions_ported=True,troy_complete_frame_ported=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=521;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('520 tests moteur','521 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-frame-gate"><h2>Transitions initiales de mise à jour des effets</h2><p>Première phase93F2F0 portée et comparée à1280captures natives. Visibilité, durée, pause, reprise et acquisition composées en Rust.521tests moteur passent. Enfants non vides, calculs de temps, producteurs et écritures finales du frame restent à qualifier.</p><a href="native_troy_frame_gate_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':521,'frame_gate_cases':1280,'complete':False}))
