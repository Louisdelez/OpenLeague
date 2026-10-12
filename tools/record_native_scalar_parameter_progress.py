from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.now(timezone.utc).isoformat()
lookup=load('data/4.20/baked_scalar_lookup_contract.json');reader=load('data/4.20/complex_scalar_parameter_contract.json')
assert lookup['passed'] and reader['passed'] and lookup['native_sha256']==reader['native_sha256']
assert len(lookup['cases'])==437 and len(reader['cases'])==60 and sum(c['name'].startswith('map:') for c in reader['cases'])==54
assert '442 passed; 0 failed' in (r/'logs/native-scalar-parameter-core-tests.log').read_text()
files=['data/4.20/baked_scalar_lookup_contract.json','data/4.20/complex_scalar_parameter_contract.json','tools/probe_native_baked_scalar_lookup.py','tools/probe_native_complex_scalar_parameter.py','crates/core/src/native_scalar_curve.rs','crates/core/src/native_scalar_parameter.rs','crates/core/src/native_probability_curve.rs','crates/core/src/lib.rs','logs/native-scalar-parameter-core-tests.log','target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
receipt='docs/native_scalar_parameter_progress.json';next_action='Qualifier et porter le lecteur vectoriel94AA60/94C150, ses courbes et variations X/Y/Z, puis intégrer les paramètres au cycle émission/naissance/pose et au rendu Map10. Qualifier le calcul de l’âge avant sélection de table. Résoudre TT_Mist_circle/fogcircle et poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':reader['native_sha256'],'baked_lookup_cases':437,'full_scalar_reader_cases':60,'native_map_scalar_cases':54,'captured_table_values':sum(len(c['table_bits']) for c in reader['cases']),'core_tests_passed':442,'last_client_tests_passed':364,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original baked table selector uses trunc(f32(count)*normalized_age), clamps valid indices, and performs no runtime interpolation. NaN/infinity/positive conversion overflow yield INT_MIN under SSE and then select index0. Empty tables unsupported.','ScalarParameter combines decoded field reader, scaled knot maximum, native256table baking, probability configuration and seeded probability consumer into a reusable Rust component.','Original94A7F0 reads XP then P into the same object; P resets XP, including when P absent. Rust preserves lookup order and final stored result. Sixty original whole-reader cases compare table/maximum/probability metadata bit for bit, including54Map10rate/life configurations.'],'limits':lookup['limits']+reader['limits']+['Rust component exists in engine core but ordinary emitter/render binding is still pending. Normalized age is supplied; its producer not qualified.','No new ordinary application builds, graphical/client tests or domain completion.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('scalar-parameter-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_scalar_parameter_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,baked_scalar_lookup_cases=437,full_scalar_reader_cases=60,map_full_scalar_reader_cases=54)
 if name=='resume_checkpoint.json':e.update(core_tests=442);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-scalar-parameter"><h2>Paramètres scalaires et tables selon âge</h2><p>Lecteur scalaire complet portés dans Rust : 60 cas natifs, dont 54 configurations Map10. Sélection des valeurs de table : 437 cas, bornes et conversions SSE comprises. Composant moteur réunissant lecture, table et variations ; 442 tests moteur réussis. Calcul de l’âge, paramètres vectoriels et raccordement au rendu restent à faire.</p><a href="native_scalar_parameter_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-scalar-parameter">.*?</section>',section,s,flags=re.S) if 'id="native-scalar-parameter"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt')):
 if p.exists():p.write_text(p.read_text(encoding='utf-8').replace('440 moteur','442 moteur'),encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=442,core_tests_passed=442,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'full_reader_cases':60,'lookup_cases':437,'core_tests_passed':442,'complete':False}))
