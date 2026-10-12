from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.now(timezone.utc).isoformat()
a=load('data/4.20/scalar_curve_bake_contract.json');b=load('data/4.20/scalar_curve_extra_counts_contract.json')
assert a['passed'] and b['passed'] and a['native_sha256']==b['native_sha256']
assert len(a['cases'])+len(b['cases'])==98
assert sum(c['actual_count'] for c in a['cases']+b['cases'])==4518
assert a['samples']==b['samples'] and len(a['samples'])==211
assert '436 passed; 0 failed' in (r/'logs/native-scalar-curve-core-tests.log').read_text()
assert '2 passed; 0 failed' in (r/'logs/native-scalar-curve-extra-count-tests.log').read_text()
reader=load('data/4.20/scalar_field_reader_contract.json')
assert reader['passed'] and reader['native_sha256']==a['native_sha256'] and len(reader['cases'])==64
assert sum(c['name'].startswith('map:') for c in reader['cases'])==54
assert '437 passed; 0 failed' in (r/'logs/native-scalar-field-reader-core-tests.log').read_text()
receipt='docs/native_scalar_curve_progress.json'
files=['data/4.20/scalar_curve_bake_contract.json','data/4.20/scalar_curve_extra_counts_contract.json','tools/probe_native_scalar_curve_bake.py','tools/probe_native_scalar_curve_extra_counts.py','crates/core/src/native_scalar_curve.rs','crates/core/src/lib.rs','logs/native-scalar-curve-core-tests.log','logs/native-scalar-curve-extra-count-tests.log','target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
files+=['data/4.20/scalar_field_reader_contract.json','tools/probe_native_scalar_field_reader.py','logs/native-scalar-field-reader-core-tests.log']
next_action='Achever les probabilités/aléatoire 94A7F0/91B410 et les courbes vectorielles/couleurs ; qualifier la conversion lexicale/getter INIBIN et la lecture des tables en fonction de l’âge, puis intégrer les 52 groupes et 244 placements Map10. Résoudre TT_Mist_circle/fogcircle et poursuivre les 24 domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':a['native_sha256'],'bake_cases':98,'table_values':4518,'unique_direct_sample_cases':211,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'core_full_suite_passed':436,'core_full_suite_scope':'Before extending fixture coverage; production math unchanged afterwards','latest_extended_fixture_tests_passed':2,'latest_extended_fixture_tests_filtered':434,'last_client_tests_passed':364,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Scalar lower-bound interpolation and baker execute original instructions; Rust output bits match all captured cases.','Duplicate exact keys choose first duplicate, then the last duplicate becomes the lower endpoint immediately after that key.','Multi-knot tables use i/count and exclude final endpoint; constant knots always create one value, including requested count zero.'],'limits':['Finite sorted nonempty scalar knots only; f64 intermediates match captured original x87 stores, not an exhaustive IEEE-754 parity claim.','Original parser, probability curves, random values, runtime table index, vector/color arithmetic and ordinary particle rendering remain unqualified.','436 full core tests before fixture extension, then two targeted extended-fixture tests passed. No new client/GPU/visual checks; ordinary binaries predate this core module.','No map, champion kit, six-client match or domain closed.'],'next_action':next_action}
proof.update(core_full_suite_passed=437,core_full_suite_scope='Latest full suite after scalar reader source and fixture changes',scalar_field_reader_cases=64,map_scalar_field_reader_cases=54,scalar_reader_adapters=reader['adapters'])
proof['findings']+=['Original94CB60 control flow ported after decoded numeric field conversion: numbered keys start at1, first missing/incomplete pair stops reading; base/default scales numbered values; no keys returns absent, constant-only creates one knot.','Case-sensitive e-rgba normalizes authored base by native f32 factor1/255, but does not normalize the default when base is absent.']
proof['limits']=['Finite sorted scalar knots only; f64 intermediates match captured x87 output, not exhaustive IEEE parity.']+reader['limits']+['Probability/RNG, vector/color curves, age table lookup, ordinary rendering and rebuilt applications still pending.','Latest437core tests passed; no new client/GPU/visual checks; no champion kit, map, six-client match or domain closed.']
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('scalar-curve-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_scalar_curve_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,scalar_curve_bake_cases=98,scalar_curve_table_values=4518,scalar_curve_direct_cases=211)
 e.update(scalar_field_reader_cases=64,map_scalar_field_reader_cases=54)
 if name=='resume_checkpoint.json':e.update(core_tests=437);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-scalar-curve"><h2>Courbes scalaires natives</h2><p>Interpolation et construction des tables portées dans Rust : 98 cas, 4518 valeurs et 211 échantillons comparés bit à bit aux instructions originales. Suite moteur : 436 tests ; deux tests ciblés après extension des données. Lecteurs de champs, aléatoire, consommation des tables et rendu restent à intégrer et qualifier.</p><a href="native_scalar_curve_progress.json">Preuves et limites</a></section>'
section=section.replace('Suite moteur : 436 tests ; deux tests ciblés après extension des données.', 'Lecteur de champs scalaires porté après conversion numérique : 64 cas natifs, dont 54 champs des groupes Complex Map10. Suite moteur actuelle : 437 tests réussis.')
section=section.replace('Lecteurs de champs, aléatoire, consommation des tables et rendu restent à intégrer et qualifier.', 'Conversion lexicale originale, probabilités/aléatoire, consommation des tables et rendu restent à qualifier et intégrer.')
s=re.sub(r'<section id="native-scalar-curve">.*?</section>',section,s,flags=re.S) if 'id="native-scalar-curve"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=437,core_tests_passed=437,next_steps=[next_action]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt')):
 if p.exists():p.write_text(p.read_text(encoding='utf-8').replace('436 moteur','437 moteur'),encoding='utf-8')
d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');(r/'docs/goal_plan_revision.json').write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'bake_cases':98,'table_values':4518,'unique_samples':211,'complete':False}))
