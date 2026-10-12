from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.now(timezone.utc).isoformat()
native=load('data/4.20/complex_vector_caller_contract.json');catalog=load('data/4.20/map10_particle_catalog.json')
assert native['passed'] and len(native['cases'])==600 and sum(c['name'].startswith('map:') for c in native['cases'])==540
assert all(c['arguments']['mode']==0 and c['arguments']['count']==256 for c in native['cases'])
assert '452 passed; 0 failed' in (r/'logs/native-complex-vectors-map-core-tests.log').read_text()
files=['data/4.20/complex_vector_caller_contract.json','data/4.20/map10_particle_catalog.json','tools/probe_native_complex_vector_callers.py','crates/core/src/native_complex_vectors.rs','crates/core/src/lib.rs','logs/native-complex-vectors-core-tests.log','logs/native-complex-vectors-map-core-tests.log','target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
files+=sorted({d['asset'] for d in catalog['definitions'] if any(g['declared_type']!='Simple' for g in d['groups'])})
receipt='docs/native_complex_vectors_progress.json';next_action='Qualifier et porter les lecteurs/courbes de couleur et la normalisation native de l’âge ; compléter la configuration Complex scalaire/lifetime et rattacher émission/naissance/pose au rendu des52groupes Map10 et244placements. Les dix champs vectoriels sont maintenant décodés avec leurs défauts/replis natifs. Résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'native_vector_caller_cases':600,'native_map_vector_caller_cases':540,'native_vector_call_sites':10,'actual_map_complex_groups_verified':27,'actual_map_vector_fields_verified':270,'core_tests_passed':452,'last_client_tests_passed':364,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Ten original Complex caller argument fragments and their complete vector readers/missing fallbacks execute on600cases: absent/constant/numbered plus27Map10groups, with zero/one-vector prior storage. All ten request mode0/count256.','Actual caller default and missing-field vector is(1,1,1)forp-scale, (0,0,0)fornineotherfields. Missing-field fallback preserves null probability pointers rather than synthesizing constant-one curves.','ComplexVectors and FieldConfig now parse decoded JSON group fields, compose native vector tables/probabilities, and expose stored birth-multiplier/frame sampling helpers. Invalid nonnumeric fields return explicit errors.','Rust matches600native caller outcomes, including accepted/absent results, table bits and axis probability metadata. A separate test reads actual Map10decoded files and compares270fields across27Complexgroups to captured native outputs.'],'limits':native['limits']+['First451full core tests passed, then latest452full suite after actual-map verification. No ordinary client/render binding or rebuilt application yet.','Color fields, native age producer, other Complex fields, graphical fidelity, complete maps/champions and six-client match remain incomplete; no domain closed.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-vectors-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_complex_vectors_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,complex_vector_caller_cases=600,actual_map_complex_vector_fields=270,complex_vector_callers_dynamically_qualified=True)
 if name=='resume_checkpoint.json':e.update(core_tests=452);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-vectors"><h2>Configuration vectorielle Complex de Map10</h2><p>600appels originaux vérifiés ; lecteur Rust des10champs avec défauts et replis natifs. Les fichiers Map10actuels passent la comparaison des270champs sur27groupes Complex.452tests moteur réussis. Couleurs, âge, autres champs et raccordement au rendu encore à terminer.</p><a href="native_complex_vectors_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-complex-vectors">.*?</section>',section,s,flags=re.S) if 'id="native-complex-vectors"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt')):
 if p.exists():p.write_text(p.read_text(encoding='utf-8').replace('450 moteur','452 moteur'),encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=452,core_tests_passed=452,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'caller_cases':600,'actual_map_vector_fields':270,'core_tests_passed':452,'complete':False}))
