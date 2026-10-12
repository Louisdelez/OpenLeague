from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
pending='--pending' in sys.argv
tests=282 if pending else 283
test_log='logs/native-hud-element-storage-tests.log' if pending else 'logs/native-hud-record-header-tests.log'
assert f'{tests} passed; 0 failed' in (r/test_log).read_text(encoding='utf-8')
contracts={'native_hud_layout_math_contract.json':576,'native_hud_element_storage_contract.json':72,'native_hud_record_header_contract.json':722}
for file,count in contracts.items():
 p=load('data/4.20/'+file);assert p['passed'] and p['case_count']==count
build=load('docs/native_hud_atlases_build_receipt.json');assert build['client_sha256']==sha('target/debug/openleague-client.exe')
artifacts=['data/4.20/'+file for file in contracts]+['crates/client/src/native_hud_layout.rs','crates/client/src/native_hud_element_storage.rs','crates/client/src/native_hud_record_header.rs','data/4.20/native_hud_property_driver_candidates.json',test_log]
action='Qualifier le lecteur de propriétés9A1A60 et la boucle de fichier9A3080 : BaseOffset, commentaires/lignes vides, initialisation aspect1, ordre des propriétés et états. Raccorder ensuite les703widgets, atlas et interactions ; reconstruire et qualifier visuellement le runtime Vulkan/DX12. Carte/zones bleues, partie six clients graphiques et tous les autres domaines restent ouverts.'
proof=dict(updated_utc=now,complete=False,client_source_tests_passed=tests,header_source_suite_pending=pending,application_rebuilt_after_changes=False,client_test_source_matches_current_build=False,last_qualified_application_tests=279,current_binary_sha256=sha('target/debug/openleague-client.exe'),native_layout_math_cases=576,native_storage_cases=72,native_header_cases=722,original_source_headers=703,native_element_storage_ported=True,native_record_header_ported=True,hud_structural_parser_complete=False,hud_runtime_integrated=False,hud_widgets_drawn=False,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},next_action=action,limits=['Layout math assumes supplied finite inputs and floating point context; producers remain open.','Storage defaults qualified for successful adapted pools and original byte/dword memset; allocation lifetime/failure and CPU startup detection remain open.','Header reader qualified on703source headers and19ASCII edges; outer loop/BaseOffset/property application/registration/texture and widget state bindings remain open.','Current application still previous279test build; source changes do not prove runtime integration or visual fidelity.'])
(r/'docs/native_hud_structure_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-structure-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_structure_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=tests,client_test_source_matches_current_build=False,current_client_application_tests=279,native_hud_layout_math_cases=576,native_hud_element_storage_cases=72,native_hud_record_header_cases=722,current_source_progress='docs/native_hud_structure_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[dict(session_id=96370,command='cargo test -p openleague-client --bin openleague-client -j1',log='logs/native-hud-record-header-tests.log',state='verified_live_when_checkpoint_written')] if pending else [])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-structure-progress">'
if marker in s:
 start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+s[end:]
section=f'{marker}<h2>Structure HUD : progression source</h2><p>{tests} tests source réussis ; transformation native576cas, valeurs initiales72cas et en-têtes722cas (703source). Application279tests inchangée. Parseur complet, application des propriétés et affichage/interactions encore ouverts.</p><a href="native_hud_structure_progress.json">Preuves et limites</a></section>'
p.write_text(s.replace('</body>',section+'</body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
shutil.copy2(Path('E:/mapslol3v3/locate_native_hud_property_driver.py'),r/'tools/locate_native_hud_property_driver.py')
print(json.dumps(dict(source_tests=tests,native_layout_cases=576,native_storage_cases=72,native_header_cases=722,header_suite_pending=pending,application_rebuilt=False,complete=False)))
