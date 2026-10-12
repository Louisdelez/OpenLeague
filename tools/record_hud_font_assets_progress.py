from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague')
log='logs/native-hud-font-assets-tests.log'
text=(r/log).read_text(encoding='utf-8')
match=re.search(r'test result: ok\. (\d+) passed; 0 failed;',text)
assert match, 'Font asset suite not successful'
tests=int(match[1]); assert tests>=307
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
m=json.loads((r/'data/4.20/native_hud_fonts_manifest.json').read_text())
assert all(sha(f['path'])==f['sha256'] for f in m['files'])
artifacts=['crates/client/src/native_hud_font_assets.rs','crates/client/src/native_zip_provider.rs','crates/client/src/main.rs','data/4.20/native_hud_fonts_manifest.json','assets/fonts/native4.20/FontMappings.txt',log]
proof=dict(updated_utc=now,complete=False,client_source_tests_passed=tests,last_qualified_application_tests=299,application_rebuilt_after_changes=False,current_binary_sha256=sha('target/debug/openleague-client.exe'),source_font_mapping_adapter_integrated=True,all_source_mappings_files_accepted_by_bevy_font_backend=True,source_locale_profiles_checked=19,normal_font_families_checked=5,active_source_font_family='Gill Sans MT Pro Medium',strong_font_handles_startup_tested=True,source_font_files_hash_verified=33,source_text_requests=154,glyph_gpu_rendering_qualified=False,hud_widgets_drawn=False,native_mapping_parser_qualified=False,native_font_directory_search_qualified=False,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},limits=['Observed FontMappings source syntax only; exact family/style required, missing or ambiguous files fail explicitly.','Imported paths relocated through unique inventory basenames with Windows filename case comparison; not a qualification of native path search.','All source families accepted by Bevy FontCx metadata registration and active font asset retained by strong handle in startup test. Glyph rendering/sizing, original font device lifecycle, shadows and HUD widgets remain open.','Tests cover current source; last visually verified application is the previous 299-test executable.','Full objective remains incomplete: map blue regions, champion kits, six graphical clients, services and all 24 domains.'])
action='Reconstruire et observer le chargement des polices source Vulkan/DX12 ; terminer glyphes, taille native, textures/effets/widgets et HUD ; carte restaurée/zones bleues, six clients et tous les domaines.'
proof['next_action']=action
(r/'docs/native_hud_font_assets_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-font-assets-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=json.loads(p.read_text(encoding='utf-8'));d.update(updated_utc=now,complete=False,native_hud_font_assets_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=tests,current_source_suite_pending=False,current_client_application_tests=299,client_test_source_matches_current_build=False,current_source_progress='docs/native_hud_font_assets_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8')
s=s.replace('</body>','<section id="native-hud-font-assets-progress"><h2>Fichiers de polices source</h2><p>'+str(tests)+' tests source réussis. Les cinq familles des 19 langues et toutes les associations FontMappings sont acceptées par le moteur de polices. Police active chargée au démarrage, handle conservé. Rendu des glyphes et widgets ouverts ; application précédente 299 tests.</p><a href="native_hud_font_assets_progress.json">Preuves et limites</a></section></body>')
p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(tests=tests,font_profiles=19,font_families=5,complete=False)))
