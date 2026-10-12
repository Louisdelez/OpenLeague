from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.now(timezone.utc).isoformat()
reader=load('data/4.20/probability_curve_contract.json');consumer=load('data/4.20/probability_random_consumer_contract.json')
assert reader['passed'] and consumer['passed'] and reader['native_sha256']==consumer['native_sha256']
assert len(reader['cases'])==191 and len(reader['samples'])==1128 and len(consumer['cases'])==96 and sum(len(c['steps']) for c in consumer['cases'])==768
assert '440 passed; 0 failed' in (r/'logs/native-probability-random-consumer-core-tests.log').read_text()
files=['data/4.20/probability_curve_contract.json','data/4.20/probability_random_consumer_contract.json','tools/probe_native_probability_curve.py','tools/probe_native_probability_random_consumer.py','crates/core/src/native_probability_curve.rs','crates/core/src/native_random.rs','crates/core/src/lib.rs','logs/native-probability-curve-core-tests.log','logs/native-probability-random-consumer-core-tests.log','target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
receipt='docs/native_probability_curve_progress.json';next_action='Achever les courbes vectorielles/couleurs et la lecture native des tables selon âge, puis connecter les lecteurs/variations au cycle émission/naissance/pose et au rendu des 52 groupes Map10. Préserver les clés descendantes des fantômes et les tirages RNG. Résoudre TT_Mist_circle/fogcircle et poursuivre les 24 domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':reader['native_sha256'],'reader_cases':191,'map_reader_cases':108,'sample_cases':1128,'consumer_cases':96,'consumer_steps':768,'core_tests_passed':440,'last_client_tests_passed':364,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'reader_original_instruction_addresses':reader['original_instruction_addresses'],'consumer_original_instruction_addresses':consumer['original_instruction_addresses'],'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original91B410 parsed-numeric reader and91B770 SSE interpolation ported and compared bit for bit. The exact two-point fast-path endpoint tolerances are captured.','Authored knot order retained, including descending p-lifeP keys in TT_Ghost and TT_Ghost2. Original generic evaluator scans for first key strictly greater than parameter; duplicate exact keys use last duplicate.','Original93C37A consumer and original RNG seed/state transitions captured. Null and constant parameters consume no draw; nonconstant curves consume one, round fraction to f32, choose fast/generic path and multiply by supplied base. Rust matches768outputs and all55words/indices after each step.'],'limits':reader['limits']+consumer['limits']+['Reader and consumer are Rust building blocks; not yet bound to ordinary Map10 rendering. No new graphical/client qualification, no ordinary binary rebuild.','No whole-map, champion kit, six-client match or domain complete.'],'next_action':next_action}
proof['limits']=[v for v in proof['limits'] if 'RNG call site, fast uniform optimization' not in v]
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('probability-curves-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_probability_curve_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,probability_reader_cases=191,probability_sample_cases=1128,probability_consumer_cases=96,probability_consumer_steps=768)
 if name=='resume_checkpoint.json':e.update(core_tests=440);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-probability-curve"><h2>Variations des particules</h2><p>Lecteurs et interpolation natifs portés dans Rust : 191 cas et 1128 échantillons. Consommateur aléatoire : 96 cas, 768 étapes comparées bit à bit, état complet du RNG vérifié. Clés descendantes des fantômes conservées. Suite moteur actuelle : 440 tests réussis. Intégration graphique, courbes vectorielles et qualification complète toujours à faire.</p><a href="native_probability_curve_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-probability-curve">.*?</section>',section,s,flags=re.S) if 'id="native-probability-curve"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt')):
 if p.exists():p.write_text(p.read_text(encoding='utf-8').replace('437 moteur','440 moteur'),encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=440,core_tests_passed=440,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'reader_cases':191,'samples':1128,'consumer_steps':768,'core_tests_passed':440,'complete':False}))
