from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();pending='--pending' in sys.argv
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
tests=285 if pending else 287;log='logs/native-hud-integer-properties-tests.log' if pending else 'logs/native-hud-property-apply-tests.log'
assert f'{tests} passed; 0 failed' in (r/log).read_text(encoding='utf-8')
contracts={'native_hud_property_driver_contract.json':216,'native_hud_integer_properties_contract.json':1476,'native_hud_string_properties_contract.json':1200}
for name,count in contracts.items():p=load('data/4.20/'+name);assert p['passed'] and p['case_count']==count
registry=load('data/4.20/native_hud_property_registry_contract.json');assert registry['passed'] and registry['property_count']==28
assert load('docs/native_hud_atlases_build_receipt.json')['client_sha256']==sha('target/debug/openleague-client.exe')
artifacts=['data/4.20/'+n for n in contracts]+['data/4.20/native_hud_property_registry_contract.json','data/4.20/native_hud_remaining_properties_candidates.json','crates/client/src/native_hud_property_driver.rs','crates/client/src/native_hud_integer_properties.rs','crates/client/src/native_hud_string_properties.rs','crates/client/src/native_hud_property_apply.rs','crates/client/src/native_hud_element_storage.rs',log]
remaining=['LeftAnchor','Color','PerPixelUVsX','MinUV','EffectParams0','EffectColor0','EffectColor1','Align']
action='Qualifier et porter les8propriétés restantes : '+', '.join(remaining)+'. Qualifier ensuite inversions UV9A1D10, boucle de fichier9A3080/BaseOffset/aspect et résolution des ressources/fontes/effets ; raccorder les703widgets et états. Reconstruire puis inspecter Vulkan/DX12. Carte/zones bleues, six clients graphiques et jeu complet restent ouverts.'
proof=dict(updated_utc=now,complete=False,client_source_tests_passed=tests,current_source_suite_pending=pending,application_rebuilt_after_changes=False,client_test_source_matches_current_build=False,last_qualified_application_tests=279,current_binary_sha256=sha('target/debug/openleague-client.exe'),native_property_driver_cases=216,registered_properties=28,native_integer_property_cases=1476,native_string_property_cases=1200,native_numeric_property_cases=1147,ported_property_callbacks=20,remaining_registered_property_callbacks=remaining,numeric_storage_application_tested=not pending,hud_file_loader_complete=False,hud_runtime_integrated=False,hud_widgets_drawn=False,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},next_action=action,limits=['Property driver control flow tested with supplied string/lookup/callback boundaries; original container behavior is not qualified.','Registry28associations executed with adapted insertion helpers; container allocation/hash collisions/lifetime open.','12integer and5string callbacks native execution compared; numeric Anchor/Rect/UV use existing1147case contract.','Eight registered callbacks remain explicit unsupported errors; post-validation flips, complete file loader/owner settings/handle resolution and runtime drawing/interactions remain open.','Current source suite pending.' if pending else 'Current source suite287passed; application remains previous279test qualified build.','No complete map, champion kit, six graphical clients match or full-game claim.'])
(r/'docs/native_hud_property_apply_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-property-apply-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_property_apply_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=tests,current_source_suite_pending=pending,client_test_source_matches_current_build=False,current_client_application_tests=279,native_hud_property_driver_cases=216,native_hud_integer_property_cases=1476,native_hud_string_property_cases=1200,native_hud_property_callbacks_ported=20,current_source_progress='docs/native_hud_property_apply_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[dict(session_id=4680,command='cargo test -p openleague-client --bin openleague-client -j1',log='logs/native-hud-property-apply-tests.log',state='verified_live_when_checkpoint_written')] if pending else [])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-property-apply-progress">'
if marker in s:
 start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+s[end:]
section=f'{marker}<h2>Application des propriétés HUD</h2><p>{tests}tests source réussis.20propriétés portées sur28 ; parcours216cas, entiers1476cas, chaînes1200cas, lecture numérique1147cas. Application279tests inchangée ;8propriétés, chargeur complet, ressources, affichage et interactions restent ouverts.</p><a href="native_hud_property_apply_progress.json">Preuves et limites</a></section>'
p.write_text(s.replace('</body>',section+'</body>'),encoding='utf-8')
for name in ['record_native_hud_property_apply_progress.py','port_native_hud_integer_properties.py','port_native_hud_string_and_apply.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps(dict(source_tests=tests,source_suite_pending=pending,callbacks_ported=20,callbacks_remaining=8,application_rebuilt=False,complete=False)))
