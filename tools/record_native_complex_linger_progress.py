from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
native=load('data/4.20/complex_linger_contract.json');log='logs/native-complex-linger-core-tests.log'
assert native['passed'] and len(native['cases'])==3052 and sum(c['name'].startswith('map:') for c in native['cases'])==27
assert '467 passed; 0 failed' in (r/log).read_text()
receipt='docs/native_complex_linger_progress.json';next_action='Qualifier e-life-scale et les sources propriétaires, puis émission/période/particules vivantes et âge propre ; compléter le cycle Complex et relier les52groupes Map10 et244placements au rendu. p-linger/e-linger sont maintenant portés avec leurs défauts et bornes natifs, composés avec le maximum p-life et les durées des27groupes Map10. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.'
catalog=load('data/4.20/map10_particle_catalog.json');files=['data/4.20/complex_linger_contract.json','data/4.20/complex_scalar_parameter_contract.json','data/4.20/complex_emitter_timing_contract.json','tools/probe_native_complex_linger.py','crates/core/src/native_complex_linger.rs','crates/core/src/native_scalar_parameter.rs','crates/core/src/native_complex_timing.rs','crates/core/src/lib.rs',log,'target/debug/deps/openleague_core-5b2a9def275dcedd.exe']+sorted({d['asset'] for d in catalog['definitions'] if any(g['declared_type']!='Simple' for g in d['groups'])})
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':467,'last_client_tests_passed':364,'native_linger_cases':3052,'actual_map_linger_groups_verified':27,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original p-linger getter default is maximum p-life+10; bound uses that same sum. Original e-linger getter default is zero inherited from prior x87 stack, with effective e-life+10 bound.','Negative authored values are replaced by bound; ordered values above bound are replaced by bound. NaN/unordered, signed zero and infinity retain original comparison behavior. Rust matches3052native cases.','Actual27Map10Complex sections parsed through Rust timing and p-life parameter readers before linger. Maximum p-life, resulting linger values and native captured outputs match.'],'limits':native['limits']+['Raw bool e-life-scale, owner producers, full lifecycle/period/live-particle decisions and per-particle age remain incomplete.','467full core tests passed. No ordinary graphical client rebuild/render/GPU check; no complete map/champion/domain or six-client match.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-linger-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_complex_linger_progress=receipt)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,complex_linger_cases=3052,actual_map_complex_linger_groups=27,core_tests_passed=467,core_tests_scope='Current core source suite; ordinary graphical application not rebuilt')
 if name=='resume_checkpoint.json':e.update(core_tests=467);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-linger"><h2>Lecteurs linger Complex</h2><p>3052cas originaux p-linger/e-linger comparés à Rust ;27groupes Map10composés avec leur maximum p-life et leurs durées.467tests moteur passent. Lifecycle complet, particules vivantes et rendu restent à terminer.</p><a href="native_complex_linger_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-complex-linger">.*?</section>',section,s,flags=re.S) if 'id="native-complex-linger"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 if p.exists():
  text=p.read_text(encoding='utf-8-sig').replace('465 moteur','467 moteur');text=text.split('PROCHAINE ÉTAPE :')[0]+'PROCHAINE ÉTAPE : qualifier life-scale, propriétaires, période et âge propre des particules ; intégrer les52groupes et244placements Map10 au rendu. Linger :3052cas natifs et27groupes composés vérifiés. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.\n';p.write_text(text,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=467,core_tests_passed=467,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests_passed':467,'native_linger_cases':3052,'actual_map_linger_groups_verified':27,'complete':False}))
