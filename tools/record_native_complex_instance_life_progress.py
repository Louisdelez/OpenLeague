from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
native=load('data/4.20/complex_instance_life_contract.json');log='logs/native-complex-instance-life-core-tests.log'
assert native['passed'] and len(native['initial_cases'])==200 and len(native['end_cases'])==3600
assert '465 passed; 0 failed' in (r/log).read_text()
receipt='docs/native_complex_instance_life_progress.json';next_action='Qualifier les lecteurs e-life-scale/e-linger et leurs sources propriétaires, puis émission/période/particules vivantes et âge propre ; compléter le cycle Complex et relier les52groupes Map10 et244placements au rendu. Durée instance7C et drapeau past-end sont maintenant portés mais ne suffisent pas à clôturer un émetteur. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.'
files=['data/4.20/complex_instance_life_contract.json','tools/probe_native_complex_instance_life.py','crates/core/src/native_complex_instance_life.rs','crates/core/src/native_complex_timing.rs','crates/core/src/native_complex_age.rs','crates/core/src/lib.rs',log,'target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':465,'last_client_tests_passed':364,'instance_initialization_cases':200,'elapsed_end_flag_cases':3600,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original9331D0 copies effective config2F0life into instance7C. Nonzero config2F4 then multiplies by owner80. Rust matches200raw-bit fixtures with scale disabled/enabled, signed zero, infinity and NaN.','Original934469 subtracts ownerA8 start from current time; owner flag10 selects config33C instead of instance7C as the strict past-end comparison bound. Rust matches elapsed bits and both native flags on3600cases.','Timing::initial_instance_duration now consumes the qualified effective e-life and supplied scaling flag/owner scale. The separate EndFlag API deliberately does not remove particles or declare emitter finished.','Constructor field references statically identify config2F4 as e-life-scale and config33C as e-linger; boolean/scalar reader/clamp and owner producers remain unqualified.'],'limits':native['limits']+['465full core tests pass. Full stop/period/linger/live-particle behavior and normalized per-particle age remain incomplete.','No ordinary client rebuild/render/GPU checks; no completed domain, map/champion or six-client match.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-instance-life-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_complex_instance_life_progress=receipt)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,complex_instance_duration_cases=200,complex_end_flag_cases=3600,core_tests_passed=465,core_tests_scope='Current core source suite; ordinary graphical application not rebuilt')
 if name=='resume_checkpoint.json':e.update(core_tests=465);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-instance-life"><h2>Durée et drapeau de fin des instances Complex</h2><p>200initialisations de durée et3600comparaisons elapsed/fin originales vérifiées dans Rust.465tests moteur passent. Le drapeau ne clôture pas tout le lifecycle ; période, linger, particules vivantes et rendu restent à terminer.</p><a href="native_complex_instance_life_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-complex-instance-life">.*?</section>',section,s,flags=re.S) if 'id="native-complex-instance-life"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 if p.exists():
  text=p.read_text(encoding='utf-8-sig').replace('463 moteur','465 moteur');text=text.split('PROCHAINE ÉTAPE :')[0]+'PROCHAINE ÉTAPE : qualifier lecteurs life-scale/linger, propriétaires, période et âge propre des particules ; intégrer les52groupes et244placements Map10 au rendu. Durée instance :200cas ; drapeau de fin :3600cas vérifiés. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.\n';p.write_text(text,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=465,core_tests_passed=465,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests_passed':465,'instance_initialization_cases':200,'end_flag_cases':3600,'complete':False}))
