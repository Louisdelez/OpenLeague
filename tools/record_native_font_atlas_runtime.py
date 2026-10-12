from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'Finished `dev` profile' in (r/'logs/native-font-atlas-update-build-retry.log').read_text(encoding='utf-8')
proof=load('docs/native_font_atlas_progress.json');assert proof['client_source_tests_passed']==317 and proof['font_raster_tests_passed']==20
captures=[]
for backend in ['vulkan','dx12']:
 p='docs/native-font-atlas-startup-'+backend+'-capture.json';c=load(p)
 assert c['font_metric_runtime_observed'] and c['persistent_face_count']==19 and c['source_text_count']==154
 assert c['client_sha256']==sha('target/debug/openleague-client.exe') and c['capture_sha256']==hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()
 # Run only after actual view_image inspection of both images.
 c.update(visual_inspected=True,visual_observation='Map visible, blue background regions remain; development text present, original HUD widgets absent. Native19font metrics/154textbindings initialized. CPU atlas methods tested, no widget runtime calls or glyph GPU drawing observed.')
 (r/p).write_text(json.dumps(c,indent=2)+'\n',encoding='utf-8');captures.append(c)
proof.update(updated_utc=now,last_qualified_application_tests=317,current_binary_sha256=sha('target/debug/openleague-client.exe'),application_rebuilt_after_changes=True,backend_captures=captures,runtime_font_metrics_startup_observed=True,glyph_atlas_widget_runtime_called=False,glyph_gpu_rendering_qualified=False,hud_widgets_drawn=False)
proof['limits']=[v for v in proof['limits'] if not v.startswith('317source tests/20backend tests')]+['317test source application rebuilt and startup inspected Vulkan/DX12.19faces/154textbindings prepared; CPU page update APIs not called by widgets. Blue map regions and full game requirements remain open.']
for artifact in ['logs/native-font-atlas-update-build.log','logs/native-font-atlas-update-build-retry.log','logs/native-font-atlas-generated-symbol-cleanup.json','data/4.20/native_font_shader_catalog.json','data/4.20/native_font_blend_state_contract.json','data/4.20/native_font_texture_creation_contract.json']:
 if artifact not in proof['artifacts']:proof['artifacts'].append(artifact)
 proof['hashes'][artifact]=sha(artifact)
proof.update(native_font_shaders_recovered=4,native_font_shader_files_preserved=8,native_blend_state_cases=4,native_texture_creation_cases=16,native_texture_pack_cases=256,native_blend_gpu_executed=False)
(r/'docs/native_font_atlas_runtime_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-font-atlas-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
gp=r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt';shutil.copy2(gp,history/gp.name);goal=gp.read_text(encoding='utf-8').replace('version à 315 tests.','version à 317 tests.');assert len(goal)<=4000;gp.write_text(goal,encoding='utf-8');Path('E:/mapslol3v3/GOAL-OPENLEAGUE-ACTUALISE.txt').write_text(goal,encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_font_atlas_runtime_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=317,client_tests_passed=317,font_raster_tests_passed=20,current_client_application_tests=317,client_tests_current_binary=317,client_test_source_matches_current_build=True,current_client_sha256=proof['current_binary_sha256'],client_binary_sha256=proof['current_binary_sha256'],pending_client_build=False,client_build_pending=False,current_source_progress='docs/native_font_atlas_runtime_progress.json')
 if 'goal_plan_revision' in d:d['goal_plan_revision'].update(last_visually_qualified_application_tests=317,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['goal_objective_proposed']=goal
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section id="native-font-atlas-runtime-progress"><h2>Client reconstruit avec atlas natifs</h2><p>317tests client et20tests FreeType ; démarrage Vulkan/DX12 inspecté. Polices19 et textes154 initialisés. Quatre shaders natifs récupérés, réglages mélange4cas et création texture16cas vérifiés. CPU atlas testé ; GPU textes/widgets et zones bleues restent ouverts.</p><a href="native_font_atlas_runtime_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
rev=load('docs/goal_plan_revision.json');rev.update(updated_utc=now,last_visually_qualified_application_tests=317,objective_sha256=hashlib.sha256(goal.encode()).hexdigest());(r/'docs/goal_plan_revision.json').write_text(json.dumps(rev,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['record_native_font_atlas_runtime.py','capture_native_font_atlas_startup.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps({'application_tests':317,'font_tests':20,'backends':2,'client_sha256':proof['current_binary_sha256'],'gpu_widgets':False,'complete':False}))
