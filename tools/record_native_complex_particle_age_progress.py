from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_particle_age_progress.json';log='logs/native-complex-particle-expiry-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 477 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
assert 'test result: ok. 475 passed; 0 failed;' in (r/'logs/native-complex-birth-life-probability-core-tests.log').read_text(encoding='utf-8-sig')
age=load('data/4.20/complex_particle_age_contract.json');life=load('data/4.20/complex_birth_life_probability_contract.json')
assert len(age['cases'])==560 and len(life['cases'])==1404
next_action='Achever les mises à jour mouvement/surface/couleur, la suppression des particules expirées et les sources propriétaires ; relier naissance et vie individuelle aux52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
files=['data/4.20/complex_particle_age_contract.json','data/4.20/complex_birth_life_probability_contract.json','tools/probe_native_complex_particle_age.py','tools/probe_native_complex_birth_life_probability.py','crates/core/src/native_complex_particle_age.rs','crates/core/src/native_complex_birth.rs','crates/core/src/lib.rs',log,'logs/native-complex-birth-life-probability-core-tests.log','logs/native-complex-birth-life-probability-initial-fixture-failure.log','data/4.20/complex_particle_expiry_contract.json','tools/probe_native_complex_particle_expiry.py','logs/native-complex-particle-age-core-tests.log']
exe=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
if exe:files.append(str(max(exe,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':age['native_sha256'],'core_tests_passed':477,'native_birth_life_probability_cases':1404,'actual_map_life_profiles':27,'native_particle_age_cases':560,'native_particle_age_consumers':3,'native_particle_age_outputs':1680,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['sample_birth_life connects emitter SSE age, p-life table selection, dedicated native probability draw and final modifiers.1404native calls over27Map10profiles match exact age/base/sampled/final bits and all55RNGwords.','Individual particle age is separate from emitter age. Positive life computes clamped ordered(time-birth)/life; nonpositive/unordered life yields0. NaN time/birth propagates. All1680movement/surface/color outputs match native elapsed/normalized bits.','Initial birth-life fixture stopped before the selected life store and failed Rust comparison. Corrected stop934930, recaptured1404cases and475tests passed; initial failure log retained.','Per-particle probe uses an instruction hook to enforce exact boundaries when Unicorn reuses a compiled block. No arithmetic adapter used.'],'limits':life['limits']+age['limits']+['477core source tests passed. Actual movement/color/material update, full birth RNG ordering, expiry/removal, raw owner/configuration sources and ordinary renderer still incomplete.','No ordinary graphical application rebuild or proof of a completed map, champion kit, domain, six-client match or delivery.'],'next_action':next_action}
expiry=load('data/4.20/complex_particle_expiry_contract.json');assert len(expiry['cases'])==240
proof.update(native_particle_expiry_cases=240,native_particle_removal_callbacks=178)
proof['findings'].append('Rust remove_expired matches240original93AE90outer loops and178removal callbacks: strict elapsed>life, ordered-equal frame skip, swap-last retry and remaining ID order. Whole record swap in Rust keeps companion fields together.')
proof['limits'].extend(expiry['limits'])
proof['next_action']='Achever les mises à jour mouvement/surface/couleur, la libération des ressources de particule et la coordination des horloges ; relier naissance et vie individuelle aux52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
next_action=proof['next_action']
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-particle-age-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_particle_age_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=477,core_source_tests_passed=477,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=477,latest_native_execution_progress=receipt,complex_birth_life_probability_cases=1404,actual_map_life_profiles=27,complex_particle_age_cases=560,complex_particle_age_outputs=1680,latest_core_test_log=log)
  e.update(complex_particle_expiry_cases=240,complex_particle_removal_callbacks=178)
  if name=='resume_checkpoint.json':e['core_tests']=477;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('474 tests moteur','477 tests moteur').replace('476 tests moteur','477 tests moteur')
 s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action} Durées et âges individuels portés ; intégration graphique et qualification de la partie complète restantes.',s,flags=re.S)
 p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-particle-age"><h2>Durée et âge individuels des particules</h2><p>1 404 tirages p-life sur27profils Map10 ;1 680 sorties âge/temps écoulé dans les trois chemins natifs.477 tests moteur passent. Mises à jour complètes, suppression et intégration graphique restent à terminer.</p><a href="native_complex_particle_age_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-particle-age">.*?</section>',section,s,flags=re.S) if 'id="native-complex-particle-age"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':477,'complete':False}))
