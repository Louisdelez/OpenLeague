from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.now(timezone.utc).isoformat()
consumer=load('data/4.20/vector_instance_consumer_contract.json');rotation=load('data/4.20/vector_rotation_bake_contract.json')
assert consumer['passed'] and rotation['passed'] and consumer['native_sha256']==rotation['native_sha256']
assert len(consumer['cases'])==136 and sum(len(c['steps']) for c in consumer['cases'])==1088 and len(consumer['updates'])==56 and len(rotation['cases'])==36
assert '448 passed; 0 failed' in (r/'logs/native-vector-instance-core-tests.log').read_text()
last=load('docs/native_particle_class_progress.json');assert sha('target/debug/openleague-client.exe')==last['artifacts_sha256']['target/debug/openleague-client.exe']
files=['data/4.20/vector_instance_consumer_contract.json','data/4.20/vector_rotation_bake_contract.json','tools/probe_native_vector_instance_consumer.py','tools/probe_native_vector_rotation_bake.py','crates/core/src/native_vector_parameter.rs','crates/core/src/native_probability_curve.rs','crates/core/src/native_random.rs','logs/native-vector-instance-core-tests.log','target/debug/deps/openleague_core-5b2a9def275dcedd.exe','target/debug/openleague-client.exe']
receipt='docs/native_vector_instance_progress.json';next_action='Porter le mode rotation/intégration94D6B0, capturé sur36cas, avec ses coefficients et calculs SSE exacts. Qualifier la normalisation de l’âge, les défauts aux appels, puis raccorder les composants natifs au cycle émission/naissance/pose et au rendu Map10. Conserver les variations X/Y/Z tirées à la création et stockées, sans nouveau tirage en mise à jour. Résoudre TT_Mist_circle/fogcircle et poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':consumer['native_sha256'],'vector_birth_cases':136,'vector_birth_steps':1088,'vector_update_cases':56,'rotation_bake_capture_cases':36,'rotation_bake_capture_vectors':sum(c['actual_count'] for c in rotation['cases']),'rotation_bake_rust_ported':False,'core_tests_passed':448,'last_client_tests_passed':364,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original9492F0 consumes independent X/Y/Z probability fields in axis order, skipping RNG draws for null/constant axes. Rust matches1088birth outputs and all55words/indices after each step across17profiles, including actualMap10probabilities.','Original93C21F..93C2BA selects the baked vector by supplied normalized age and multiplies by stored birth factors. It consumes no new RNG draw. Rust matches56frame updates.','VectorParameter now exposes separate create_instance_multiplier and sample_instance_age operations so construction randomness is retained rather than rerolled each frame.','Original94D6B0 mode1 coefficient/table generation executed on36fixtures. It retains requested count for constant knots and accumulates values, unlike mode0. Output references captured; Rust implementation pending.'],'limits':consumer['limits']+rotation['limits']+['448latest full core tests passed. Existing ordinary client executable verified unchanged; no new renderer/client/visual qualification.','No full map, champion kit, six-client match or domain closed.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('vector-instance-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_vector_instance_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,vector_birth_cases=136,vector_birth_steps=1088,vector_update_cases=56,rotation_capture_cases=36)
 if name=='resume_checkpoint.json':e.update(core_tests=448);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-vector-instance"><h2>Variations vectorielles des instances</h2><p>Consommateurs portés dans Rust :136cas et1088créations, état RNG complet comparé ;56mises à jour sans nouveau tirage.448tests moteur réussis. Mode de rotation capturé sur36cas mais portage encore à faire, puis normalisation de l’âge et raccordement graphique.</p><a href="native_vector_instance_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-vector-instance">.*?</section>',section,s,flags=re.S) if 'id="native-vector-instance"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt')):
 if p.exists():p.write_text(p.read_text(encoding='utf-8').replace('446 moteur','448 moteur'),encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=448,core_tests_passed=448,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'birth_steps':1088,'updates':56,'rotation_captures':36,'core_tests_passed':448,'complete':False}))
