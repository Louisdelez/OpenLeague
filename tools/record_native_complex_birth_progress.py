from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_birth_progress.json';log='logs/native-complex-birth-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 474 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/complex_birth_timing_life_contract.json')
assert len(native['schedule_cases'])==300 and len(native['life_cases'])==495
next_action='Relier le tirage p-life à la naissance, achever les attributs/transformations et le cycle individuel des particules ; intégrer les52groupes et244placements Map10 au rendu, reconstruire les applications et poursuivre les24domaines.'
files=['data/4.20/complex_birth_timing_life_contract.json','tools/probe_native_complex_birth_timing_life.py','crates/core/src/native_complex_birth.rs','crates/core/src/lib.rs',log]
exe=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
if exe:files.append(str(max(exe,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':474,'native_birth_schedule_cases':300,'native_birth_lifetime_cases':495,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Birth index increments before sampling: first fraction1/count, last1. Exact stored-MAX start sentinel resolves to current time. Timing and pre-transform positions match300native samples.','Lifetime owner-scale multiplication precedes negative-to-MAX sentinel. Velocity coefficient offsets use X/Y/Z symmetry mask and a separate negative-to-zero clamp;495native results match, including signed zero, infinity and NaN payloads.'],'limits':native['limits']+['474core source tests passed. Full birth execution, p-life probability draw ordering, live storage/counters, per-particle age and update still incomplete.','No ordinary graphical rebuild/observation, completed map, champion kit, domain or six-client match demonstrated.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-birth-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_birth_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=474,core_source_tests_passed=474,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=474,latest_native_execution_progress=receipt,complex_birth_schedule_cases=300,complex_birth_lifetime_cases=495,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=474;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('472 tests moteur','474 tests moteur');p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-birth"><h2>Naissance des particules Complex</h2><p>300 répartitions temporelles et positions avant transformation,495 durées finales comparées au client natif.474 tests moteur passent. Naissance entière, cycle individuel et intégration graphique restent à terminer.</p><a href="native_complex_birth_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-birth">.*?</section>',section,s,flags=re.S) if 'id="native-complex-birth"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':474,'complete':False}))
