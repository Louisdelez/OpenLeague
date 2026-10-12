from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '280 passed; 0 failed' in (r/'logs/native-hud-property-text-tests.log').read_text(encoding='utf-8')
contract=load('data/4.20/native_hud_property_text_contract.json');assert contract['passed'] and contract['case_count']==1147
assert load('docs/native_hud_atlases_build_receipt.json')['client_sha256']==sha('target/debug/openleague-client.exe')
artifacts=['data/4.20/native_hud_property_text_contract.json','crates/client/src/native_hud_property_text.rs','crates/client/src/native_hud_anchor.rs','data/4.20/native_hud_anchor_contract.json','logs/native-hud-property-text-tests.log','data/4.20/native_hud_layout_math_candidates.json']
action='280tests client passent. Lecture Rect/UV/Anchor portée et comparée sur1147cas avec scanf/conversion flottante natives ;497valeurs source uniques des32fichiers. Anchor utilisef32 ;96anciens cas sont des copies de mots32bits, non une qualification entière. Exécuter et porter la transformation9A4B30 (ancrages/échelle/aspect/arrondi), qualifier le parseur de structure et raccorder les703widgets à leurs atlas/états. Exécutable précédent279tests inchangé ; reconstruire et qualifier le runtime après intégration. Carte/zones bleues et jeu complet restent ouverts.'
proof=dict(updated_utc=now,complete=False,client_source_tests_passed=280,application_rebuilt_after_changes=False,client_test_source_matches_current_build=False,last_qualified_application_tests=279,current_binary_sha256=sha('target/debug/openleague-client.exe'),native_property_text_cases=1147,source_unique_values=contract['source_unique_values'],native_original_scanf_executes=True,native_original_float_conversion_executes=True,native_original_float_dispatch_initialization_executes=True,anchor_storage_float_corrected=True,native_property_text_ported=True,native_property_text_runtime_integrated=False,hud_layout_applied=False,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},next_action=action,limits=contract['limits']+['Source suite280tests; current production binary still the previous279tests build with qualified Vulkan/DX12 atlas loading.','Structural file parser, layout/drawing/interactions, complete map/match/game remain open.'])
(r/'docs/native_hud_property_text_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-property-text-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_property_text_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=280,client_test_source_matches_current_build=False,current_client_application_tests=279,native_hud_property_text_cases=1147,current_source_progress='docs/native_hud_property_text_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Lecture des propriétés HUD</h2><p>280tests source passent ;1147cas,497valeurs source uniques comparés au scanner/conversion flottante natifs. Anchor corrigé enf32. Application279tests inchangée ; intégration runtime et disposition encore ouvertes.</p><a href="native_hud_property_text_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(source_tests=280,native_cases=1147,source_unique_values=contract['source_unique_values'],application_rebuilt=False,complete=False)))
