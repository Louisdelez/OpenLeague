from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.now(timezone.utc).isoformat()
curve=load('data/4.20/vector_curve_contract.json');parameter=load('data/4.20/vector_parameter_contract.json')
assert curve['passed'] and parameter['passed'] and curve['native_sha256']==parameter['native_sha256']
assert len(curve['field_cases'])==62 and len(curve['bake_cases'])==66 and len(curve['samples'])==151 and len(parameter['cases'])==65
assert '446 passed; 0 failed' in (r/'logs/native-vector-parameter-core-tests.log').read_text()
files=['data/4.20/vector_curve_contract.json','data/4.20/vector_parameter_contract.json','tools/probe_native_vector_curve.py','tools/probe_native_vector_parameter.py','crates/core/src/native_vector_curve.rs','crates/core/src/native_vector_parameter.rs','crates/core/src/lib.rs','logs/native-vector-curve-core-tests.log','logs/native-vector-parameter-core-tests.log','target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
receipt='docs/native_vector_parameter_progress.json';next_action='Qualifier et porter le mode de conversion des rotations94D6B0 et les consommateurs vectoriels avec leur ordre RNG X/Y/Z. Qualifier le calcul de l’âge, raccorder les paramètres aux émissions/naissances/poses et au rendu des52groupes Map10. Résoudre TT_Mist_circle/fogcircle et poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':curve['native_sha256'],'vector_field_cases':62,'vector_bake_cases':66,'vector_sample_cases':151,'baked_vectors':sum(v['actual_count'] for v in curve['bake_cases']),'full_vector_reader_cases':65,'full_vector_reader_map_cases':54,'full_reader_baked_vectors':sum(c['actual_count'] for c in parameter['cases']),'core_tests_passed':446,'last_client_tests_passed':364,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'curve_original_instruction_addresses':curve['original_instruction_addresses'],'full_reader_original_instruction_addresses':parameter['original_instruction_addresses'],'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original vector interpolation uses SSE f32 at every arithmetic step, with first-duplicate lower_bound selection. Port matches151samples and all2836baked vectors bit for bit.','Vector fields use three base components and four numbered components(time,X,Y,Z); missing/incomplete numbered keys stop reading and values scale component-wise. A scalar base is not silently expanded to a vector.','Original full94AA60 nonrotation reader composes vector tables and separate XP/YP/ZP probability objects. Requested vector table count is at least256 except constant curves use one value. Rust matches65whole-reader cases, including54Map10scale/postoffset fixtures and requested16/256/512.'],'limits':curve['limits']+parameter['limits']+['445core tests passed for curve port, then446full core tests passed after whole-reader integration. No new ordinary executable builds, client/graphics checks or complete domain.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('vector-parameter-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_vector_parameter_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,vector_field_cases=62,vector_bake_cases=66,vector_sample_cases=151,full_vector_reader_cases=65)
 if name=='resume_checkpoint.json':e.update(core_tests=446);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-vector-parameter"><h2>Paramètres vectoriels des particules</h2><p>Lecture et courbes vectorielles portées dans Rust : 62 lectures, 66 tables, 151 échantillons. Lecteur complet avec variations X/Y/Z : 65 configurations natives, dont54Map10. Comparaisons bit à bit, suite moteur actuelle446tests réussis. Mode de rotation, consommateur vectoriel, calcul de l’âge et raccordement graphique encore à faire.</p><a href="native_vector_parameter_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-vector-parameter">.*?</section>',section,s,flags=re.S) if 'id="native-vector-parameter"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt')):
 if p.exists():p.write_text(p.read_text(encoding='utf-8').replace('442 moteur','446 moteur'),encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=446,core_tests_passed=446,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'curve_bakes':66,'full_reader_cases':65,'core_tests_passed':446,'complete':False}))
