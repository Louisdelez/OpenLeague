from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
native=load('data/4.20/complex_emitter_timing_contract.json');log='logs/native-complex-timing-core-tests.log'
assert native['passed'] and len(native['cases'])==71 and sum(c['name'].startswith('map:') for c in native['cases'])==27
assert '463 passed; 0 failed' in (r/log).read_text()
receipt='docs/native_complex_timing_progress.json';next_action='Qualifier le producteur de durée instance7C, l’âge propre et les mises à jour couleur/pose de chaque particule ; compléter le cycle Complex et relier les52groupes Map10 et244placements au rendu. Les quatre paramètres temporels natifs sont maintenant lus dans Rust sur les27groupes Complex et raccordés au calcul d’âge émetteur. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.'
catalog=load('data/4.20/map10_particle_catalog.json')
files=['data/4.20/complex_emitter_timing_contract.json','tools/probe_native_complex_timing.py','crates/core/src/native_complex_timing.rs','crates/core/src/native_complex_age.rs','crates/core/src/lib.rs',log,'target/debug/deps/openleague_core-5b2a9def275dcedd.exe']+sorted({d['asset'] for d in catalog['definitions'] if any(g['declared_type']!='Simple' for g in d['groups'])})
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':463,'last_client_tests_passed':364,'native_timing_cases':71,'actual_map_timing_groups_verified':27,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original caller getter defaults checked dynamically: e-timeoffset=0, e-period/e-active=maximum finite f32, Hacks/default-e-life=-1; negative effective e-life becomes maximum finite.','Period/active/timeoffset keep authored signed zero, infinity and NaN; no invented clamp or period-1 default. Global life fallback is overridden by authored life.','Timing::from_group reads decoded scalar fields and rejects unsupported types. Timing::emitter_age_input maps period→config308, active→config30C, timeoffset→config2EC into the qualified native-age producer.','71cases match original caller output bits, including27actual Map10Complex sections read directly from current files.'],'limits':native['limits']+['Instance7C lifetime producer, per-particle age and full stop/loop/render lifecycle still unqualified.','463full core tests passed. No new ordinary client build/render/GPU verification. No champion/map/domain or six-client match closed.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-timing-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_complex_timing_progress=receipt)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,complex_timing_cases=71,actual_map_complex_timing_groups=27,core_tests_passed=463,core_tests_scope='Current core source suite; ordinary graphical application not rebuilt')
 if name=='resume_checkpoint.json':e.update(core_tests=463);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-timing"><h2>Paramètres temporels Complex de Map10</h2><p>e-timeoffset/e-life/e-active/e-period portés dans Rust :71appels originaux et27groupes Map10vérifiés. Les durées alimentent le calcul d’âge émetteur.463tests moteur réussis. Âge propre des particules et raccordement graphique restent à terminer.</p><a href="native_complex_timing_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-complex-timing">.*?</section>',section,s,flags=re.S) if 'id="native-complex-timing"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 if p.exists():
  text=p.read_text(encoding='utf-8-sig').replace('461 moteur','463 moteur');text=text.split('PROCHAINE ÉTAPE :')[0]+'PROCHAINE ÉTAPE : qualifier durée instance7C, âge propre et mise à jour des particules ; intégrer les52groupes et244placements Map10 au rendu. Paramètres temporels :71cas natifs,27groupes vérifiés et raccordés au calcul d’âge. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.\n';p.write_text(text,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=463,core_tests_passed=463,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests_passed':463,'actual_map_timing_groups_verified':27,'complete':False}))
