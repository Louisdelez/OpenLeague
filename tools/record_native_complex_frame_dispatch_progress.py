from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_frame_dispatch_progress.json';log='logs/native-complex-frame-dispatch-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 478 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/complex_frame_dispatch_contract.json');assert len(native['cases'])==1920
next_action='Achever les corps de mise à jour mouvement/surface/couleur, les transformations propriétaires et la libération des ressources ; intégrer le cycle Complex aux52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
files=['data/4.20/complex_frame_dispatch_contract.json','tools/probe_native_complex_frame_dispatch.py','crates/core/src/native_complex_frame_dispatch.rs','crates/core/src/lib.rs',log]
exe=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
if exe:files.append(str(max(exe,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':478,'native_frame_dispatch_cases':1920,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole938900dispatch matches1920native calls: ordered-equal time skip, flags/kind arguments, movement→surface→color, new particle indices and final time/count stores. NaN times retain native unordered handling.','Raw bit1 enables first bool; bit2 combines with kinds1/3/11 for movement second bool. Callback bodies remain separately qualified requirements.'],'limits':native['limits']+['478core source tests passed; no ordinary graphics rebuild or observation for current Complex ports.','No complete map, champion kit, domain, six-client match or delivery demonstrated.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-frame-dispatch-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_frame_dispatch_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=478,core_source_tests_passed=478,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=478,latest_native_execution_progress=receipt,complex_frame_dispatch_cases=1920,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=478;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('477 tests moteur','478 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-frame-dispatch"><h2>Coordination des mises à jour Complex</h2><p>1 920 appels natifs comparés : ordre des mises à jour, indicateurs, initialisation et horloge.478 tests moteur passent. Corps des mises à jour et intégration graphique restent à terminer.</p><a href="native_complex_frame_dispatch_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-frame-dispatch">.*?</section>',section,s,flags=re.S) if 'id="native-complex-frame-dispatch"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':478,'complete':False}))
