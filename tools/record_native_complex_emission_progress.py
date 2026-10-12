from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
log='logs/native-complex-full-count-core-tests.log'
testlog=(r/log).read_text(encoding='utf-8-sig')
assert 'test result: ok. 472 passed; 0 failed;' in testlog
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
receipt='docs/native_complex_emission_progress.json'
files=['data/4.20/complex_emission_gate_contract.json','data/4.20/complex_emission_count_contract.json','tools/probe_native_complex_emission_gate.py','tools/probe_native_complex_emission_count.py','crates/core/src/native_complex_emission_gate.rs','crates/core/src/native_complex_emission_count.rs','crates/core/src/lib.rs',log,'data/4.20/complex_full_count_contract.json','tools/probe_native_complex_full_count.py']
native=load(files[0]);count=load(files[1])
assert len(native['cases'])==1173 and len(count['cases'])==2142
exe=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
if exe: files.append(str(max(exe,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Achever les branches du taux par mouvement et attribut propriétaire, la naissance complète, les particules vivantes et leur âge individuel ; intégrer les52groupes et244placements Map10 au rendu normal, reconstruire les applications et poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'native_gate_cases':1173,'native_count_cases':2142,'core_tests_passed':472,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original emission gates include strict activity threshold and phase-counter reset; count and birth callbacks receive absolute time. Rust matches1173captured decisions and callback arguments.','Count finalizer934763..93485D matches2142native results:763positive,1101zero,278negative. Period start, stored emission time, owner/type scale, burst cap, flags and remaining-count limit retained.','CVTTSS2SI invalid/out-of-range returns INT_MIN; integer wrap and signed comparisons preserved, including negative results and counter overflow.'],'limits':native['limits']+count['limits']+['472core source tests passed; ordinary graphical executable has not been rebuilt for these modules.','No complete map, champion kit, domain, six-client match or delivery demonstrated.'],'next_action':next_action}
full=load('data/4.20/complex_full_count_contract.json');assert len(full['cases'])==648
proof.update(native_full_count_cases=648,actual_map_rate_profiles=27)
proof['findings'].append('Entire9345F0stationary/no-attribute-rate path matches648native calls over27Map10e-rateprofiles, including exact age/rate bits and all55RNGwords. ScalarParameter sampling is connected to the count finalizer. Count-age uses x87 intermediate operations distinct from birth-age SSE.')
proof['limits'].extend(full['limits'])
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-emission-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_emission_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=472,core_source_tests_passed=472,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=472,latest_native_execution_progress=receipt,complex_emission_gate_cases=1173,complex_emission_count_cases=2142,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=472;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('470 tests moteur','472 tests moteur').replace('471 tests moteur','472 tests moteur');p.write_text(s,encoding='utf-8')
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;d=load('docs/'+name);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(complex_full_count_cases=648,actual_map_rate_profiles=27)
 if name=='completion_plan.json':d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-emission"><h2>Émission des particules Complex</h2><p>1 173 cas natifs de conditions et 2 142 calculs de nombre comparés à Rust. 472 tests moteur passent. Production du taux, naissance complète, cycle des particules et intégration graphique restent à terminer.</p><a href="native_complex_emission_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-emission">.*?</section>',section,s,flags=re.S) if 'id="native-complex-emission"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':472,'complete':False}))
