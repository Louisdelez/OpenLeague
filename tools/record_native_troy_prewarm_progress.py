from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_prewarm_progress.json';log='logs/native-troy-prewarm-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 515 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_reset_contract.json');assert native['passed'] and len(native['cases'])==432
files=['data/4.20/troy_prewarm_contract.json','tools/probe_native_troy_prewarm.py','crates/core/src/native_troy_prewarm.rs','data/4.20/troy_reset_caller_contract.json','tools/probe_native_troy_reset_caller.py','data/4.20/troy_reset_contract.json','tools/probe_native_troy_reset.py','crates/core/src/native_troy_reset.rs','crates/core/src/native_complex_particle_storage.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Qualifier les corps de mise à jour93F2F0, pause93EF80 et reprise93EEE0, le scratch8E2E80, les émetteurs à la mort, la carte audio8000, le flag enfant10000 et les mises à jour des émetteurs ; qualifier les corps du gestionnaire et les producteurs natifs, composer le cycle complet puis le raccorder au rendu normal des52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
caller=load('data/4.20/troy_reset_caller_contract.json');warm=load('data/4.20/troy_prewarm_contract.json');assert len(caller['cases'])==363 and len(warm['cases'])==240
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':515,'reset_cases':432,'caller_cases':363,'prewarm_cases':240,'prewarm_actual_cpu_sse_operations':392,'prewarm_actual_cpu_x87_copies':152,'reset_caller_ported':True,'prewarm_orchestration_ported':True,'prewarm_producer_bodies_qualified':False,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Caller9408E8..940938 port matches363native captures: request200 gate, x87 argument quieting, raw0.1-second rewind threshold, BH flag and local-time write; requests remain set.','Prewarm940C2B..940D19 orchestration matches240native captures: pause gate, scratch lifetime, rewind*0.1step, time-rewind initial cursor, x87 update argument, post-update stop flag, resume and scratch destruction.','No silent loop truncation: stalled positive-time progression is explicitly rejected; cleanup still executes on this unsupported error path.','Pause/resume, scratch construction/destruction and frame update are adapted endpoints in this proof. Their bodies and normal graphical/audio integration remain incomplete.'],'adapters':warm['adapters'],'limits':warm['limits']+['Death emitters and full particle frame are not qualified. No domain or champion kit complete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-prewarm-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_prewarm_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=515,core_source_tests_passed=515,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=515,latest_native_execution_progress=receipt,troy_reset_caller_cases=363,troy_prewarm_cases=240,troy_prewarm_orchestration_ported=True,troy_prewarm_producer_bodies_qualified=False,troy_prewarm_graphical_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=515;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('512 tests moteur','515 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-prewarm"><h2>Déclenchement et préchauffage des effets Troy</h2><p>Caller reset200 porté :363captures natives. Orchestration de préchauffage portée :240captures,392opérations SSE et152copies x87 sur CPU réel.515tests moteur passent. Corps des producteurs, scratch, effets à la mort et raccordement graphique/audio restent à qualifier.</p><a href="native_troy_prewarm_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':515,'caller_cases':363,'prewarm_cases':240,'complete':False}))
