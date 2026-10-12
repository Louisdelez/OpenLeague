from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
tests=(r/'logs/native-font-metrics-tests.log').read_text();assert '313 passed; 0 failed' in tests and '3 passed; 0 failed' in tests
assert 'Finished `dev` profile' in (r/'logs/native-font-metrics-build.log').read_text()
captures=[]
for backend in ['vulkan','dx12']:
 c=load('docs/native-font-metrics-'+backend+'-capture.json')
 assert c['font_metric_runtime_observed'] and c['persistent_face_count']==19 and c['source_text_count']==154
 assert c['client_sha256']==sha('target/debug/openleague-client.exe')
 assert c['capture_sha256']==hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()
 # Run only after viewing both actual images.
 c['visual_inspected']=True
 c['visual_observation']='Map scene visible with blue regions still present; native HUD widgets absent. FreeType metrics and persistent faces observed in logs, not visible glyph GPU rendering.'
 (r/('docs/native-font-metrics-'+backend+'-capture.json')).write_text(json.dumps(c,indent=2)+'\n',encoding='utf-8');captures.append(c)
probe=load('docs/native_font_source_glyph_probe.json');assert probe['source_hashes_verified'] and probe['glyph_bitmaps']==10
probe['visual_inspected']=True
(r/'docs/native_font_source_glyph_probe.json').write_text(json.dumps(probe,indent=2)+'\n',encoding='utf-8')
glyph=load('data/4.20/native_glyph_loading_contract.json');assert glyph['passed'] and glyph['constructor_case_count']==54 and glyph['copy_case_count']==36
artifacts=['crates/font-raster/Cargo.toml','crates/font-raster/build.rs','crates/font-raster/bridge.c','crates/font-raster/src/lib.rs','crates/client/src/native_font_metrics.rs','crates/client/src/native_hud_font_creation.rs','crates/client/src/main.rs','crates/client/Cargo.toml','Cargo.toml','Cargo.lock','data/4.20/native_freetype_version_contract.json','data/4.20/native_font_dpi_contract.json','data/4.20/native_font_face_sizing_contract.json','data/4.20/native_glyph_loading_contract.json','docs/freetype_248_source_import.json','docs/THIRD-PARTY-FREETYPE.txt','logs/native-font-metrics-tests.log','logs/native-font-metrics-build.log','docs/native_font_source_glyph_probe.json']
proof={'updated_utc':now,'complete':False,'client_source_tests_passed':313,'font_raster_tests_passed':3,'last_qualified_application_tests':313,'application_rebuilt_after_changes':True,'current_binary_sha256':sha('target/debug/openleague-client.exe'),'native_matching_freetype_version':'2.4.8','native_freetype_source_files':657,'native_face_sizing_adjustment_rust_cases':384,'native_dpi_branch_cases':32,'persistent_font_faces_runtime_observed':19,'source_texts_runtime_observed':154,'native_glyph_constructor_cases':54,'native_glyph_copy_cases':36,'native_glyph_provider_adapted':True,'native_glyph_copy_rust_ported':False,'cpu_glyph_preview':probe,'backend_captures':captures,'glyph_gpu_rendering_qualified':False,'hud_widgets_drawn':False,'artifacts':artifacts,'hashes':{p:sha(p) for p in artifacts},'next_action':'Porter les métriques et copies RGBA natives des glyphes (54/36cas), qualifier le chargement/rendering flags4 et l’atlas GPU ; achever widgets et interactions HUD, corriger les zones bleues de la carte puis tous les domaines du plan.','limits':['FreeType version2.4.8 matches native version fields, but native compiler patches, hinting configuration and original bitmap equality remain unqualified.','Persistent engine-owned faces use original font bytes and ported metric adjustment; native cache allocation/destruction and device context producer remain open.','CPU preview uses explicit flags0/render_mode0/DPI96; native bitmap paths load flags4. Qualifier uses supplied successful FT providers and does not prove native original bitmaps.','Vulkan/DX12 startup and 19 persistent faces observed; no GPU glyph drawing or original HUD widgets. Blue map regions remain visible.','No champion kit, full six graphical clients match or delivery closure achieved.']}
goal_path=r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt';goal_text=goal_path.read_text(encoding='utf-8')
goal_text=goal_text.replace('Dernière application visuellement qualifiée : version à 311 tests, Vulkan/DX12. Nouveau backend FreeType 2.4.8 et métriques de 19 polices intégrés au code et testés ; reconstruction et observation de cette nouvelle application restent à faire.','Application reconstruite et observée Vulkan/DX12 : version à 313 tests. Backend FreeType 2.4.8 et métriques de 19 polices intégrés et observés ; aperçu CPU des cinq familles originales inspecté.')
goal_path.write_text(goal_text,encoding='utf-8')
Path('E:/mapslol3v3/GOAL-OPENLEAGUE-ACTUALISE.txt').write_text(goal_text,encoding='utf-8')
(r/'docs/native_font_metrics_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-font-metrics-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_font_metrics_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
 e.update(client_tests=313,client_tests_passed=313,font_raster_tests_passed=3,current_client_application_tests=313,client_test_source_matches_current_build=True,current_source_progress='docs/native_font_metrics_progress.json',current_client_sha256=proof['current_binary_sha256'],client_binary_sha256=proof['current_binary_sha256'],client_tests_current_binary=313,pending_client_build=False,client_build_pending=False)
 if 'goal_plan_revision' in d:
  d['goal_plan_revision'].update(last_visually_qualified_application_tests=313,new_font_metrics_application_build_and_observation_pending=False,objective_sha256=hashlib.sha256(goal_text.encode()).hexdigest())
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:];d['goal_objective_proposed']=goal_text
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=re.sub(r'<section id="native-font-metrics-progress">.*?</section>','',s,flags=re.S)
section='<section id="native-font-metrics-progress"><h2>Métriques des polices originales</h2><p>313 tests client et 3 tests FreeType réussis ; application reconstruite et observée Vulkan/DX12. FreeType 2.4.8 : 19 faces conservées pour 154 textes, boucle de taille comparée sur 384 cas. Aperçu CPU des cinq familles originales inspecté. Chargement et copie des glyphes natifs qualifiés sur 54/36 cas avec providers fournis ; port RGBA, GPU, widgets et zones bleues ouverts.</p><a href="native_font_metrics_progress.json">Preuves et limites</a></section>'
s=s.replace('</body>',section+'</body>');s=s.replace('Dernière application inspectée : version à 311 tests. Reconstruction et observation du nouveau backend de polices, glyphes GPU','Dernière application inspectée : version à 313 tests avec FreeType 2.4.8. Glyphes GPU')
p.write_text(s,encoding='utf-8')
revision=load('docs/goal_plan_revision.json');revision.update(updated_utc=now,last_visually_qualified_application_tests=313,new_font_metrics_application_build_and_observation_pending=False,objective_sha256=hashlib.sha256(goal_text.encode()).hexdigest())
(r/'docs/goal_plan_revision.json').write_text(json.dumps(revision,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
dst=r/'tools'/Path(__file__).name
if dst.resolve()!=Path(__file__).resolve():shutil.copy2(__file__,dst)
print(json.dumps({'client_tests':313,'font_tests':3,'backends':2,'faces':19,'client_sha256':proof['current_binary_sha256'],'complete':False}))
