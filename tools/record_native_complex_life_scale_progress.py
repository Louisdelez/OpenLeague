from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
native=load('data/4.20/complex_life_scale_contract.json');log='logs/native-complex-life-scale-core-tests.log'
assert native['passed'] and len(native['cases'])==127 and sum(c['name'].startswith('map:') for c in native['cases'])==27
assert '469 passed; 0 failed' in (r/log).read_text()
receipt='docs/native_complex_life_scale_progress.json';next_action='Qualifier les sources propriétaires, puis émission/période/particules vivantes et âge propre ; compléter le cycle Complex et relier les52groupes Map10 et244placements au rendu. Le lecteur binaire e-life-scale est maintenant porté et lié à la durée d’instance sur les27groupes Map10. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.'
catalog=load('data/4.20/map10_particle_catalog.json');files=['data/4.20/complex_life_scale_contract.json','data/4.20/complex_instance_life_contract.json','data/4.20/complex_emitter_timing_contract.json','tools/probe_native_complex_life_scale.py','crates/core/src/native_complex_life_scale.rs','crates/core/src/native_complex_instance_life.rs','crates/core/src/native_complex_timing.rs','crates/core/src/lib.rs',log,'target/debug/deps/openleague_core-5b2a9def275dcedd.exe']+sorted({d['asset'] for d in catalog['definitions'] if any(g['declared_type']!='Simple' for g in d['groups'])})
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':469,'last_client_tests_passed':364,'native_life_scale_cases':127,'actual_map_life_scale_groups_verified':27,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original file fallback e-life-scale defaults to byte0. Full binary bool wrapper visits typed bool before typed text; bool bytes remain raw and text is true only if first byte is ASCII1.','Rust matches127native caller/binary-reader cases including disabled provider and source precedence. Actual27Map10Complex sections all lack e-life-scale and resolve to disabled.','LifeScale::initial_duration connects decoded binary flag to the qualified life copy/conditional-scale helper; currentMap10does not apply owner-scale, including when scale is NaN.'],'limits':native['limits']+['469full core tests passed. Source getter/cache/global overrides, owner producers, full lifecycle/particle update and graphical renderer remain incomplete.','No ordinary application rebuild/GPU/visual test; no map/champion/domain or six-client match complete.'],'next_action':next_action}
proof['artifacts_sha256']['logs/native-complex-life-scale-initial-fixture-failure.log']=sha('logs/native-complex-life-scale-initial-fixture-failure.log')
proof['findings'].append('Initial fixture used the wrong stack slot for the provider and was rejected by Rust comparison. Corrected to original SP+0x14 with an explicit ECX provider assertion; recapture exercises real typed reads, including raw255 precedence and text1→true. Failure log retained; latest full469suite passes.')
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-life-scale-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_complex_life_scale_progress=receipt)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,complex_life_scale_cases=127,actual_map_complex_life_scale_groups=27,core_tests_passed=469,core_tests_scope='Current core source suite; ordinary graphical application not rebuilt')
 if name=='resume_checkpoint.json':e.update(core_tests=469);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-life-scale"><h2>Lecture binaire life-scale Complex</h2><p>127cas originaux p-linger/e-linger comparÃ©s Ã  Rust ;27groupes Map10composÃ©s avec leur maximum p-life et leurs durÃ©es.469tests moteur passent. Lifecycle complet, particules vivantes et rendu restent Ã  terminer.</p><a href="native_complex_life_scale_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-complex-life-scale">.*?</section>',section,s,flags=re.S) if 'id="native-complex-life-scale"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 if p.exists():
  text=p.read_text(encoding='utf-8-sig').replace('465 moteur','469 moteur');text=text.split('PROCHAINE Ã‰TAPE :')[0]+'PROCHAINE Ã‰TAPE : qualifier life-scale, propriÃ©taires, pÃ©riode et Ã¢ge propre des particules ; intÃ©grer les52groupes et244placements Map10 au rendu. Linger :127cas natifs et27groupes composÃ©s vÃ©rifiÃ©s. Reconstruire les exÃ©cutables, rÃ©soudre TT_Mist_circle/fogcircle, vÃ©rifier six clients et poursuivre les24domaines.\n';p.write_text(text,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=469,core_tests_passed=469,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests_passed':469,'native_life_scale_cases':127,'actual_map_life_scale_groups_verified':27,'complete':False}))
