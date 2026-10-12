from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'Finished `dev` profile' in (r/'logs/native-glyph-composite-build.log').read_text()
proof=load('docs/native_glyph_composite_progress.json');assert proof['client_source_tests_passed']==315
captures=[]
for backend in ['vulkan','dx12']:
 p='docs/native-glyph-composite-startup-'+backend+'-capture.json';c=load(p)
 assert c['font_metric_runtime_observed'] and c['persistent_face_count']==19 and c['source_text_count']==154
 assert c['client_sha256']==sha('target/debug/openleague-client.exe') and c['capture_sha256']==hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()
 # Invoke only after inspecting both actual images.
 c.update(visual_inspected=True,visual_observation='Map scene visible with persistent blue background regions and development text; original HUD widgets absent. Font metrics startup observed; new glyph composition/kerning widget callers and GPU text drawing not observed.')
 (r/p).write_text(json.dumps(c,indent=2)+'\n',encoding='utf-8');captures.append(c)
proof.update(updated_utc=now,last_qualified_application_tests=315,current_binary_sha256=sha('target/debug/openleague-client.exe'),application_rebuilt_after_changes=True,backend_captures=captures,runtime_font_metrics_startup_observed=True,glyph_composition_widget_runtime_called=False,glyph_gpu_rendering_qualified=False,hud_widgets_drawn=False)
proof['artifacts'].append('logs/native-glyph-composite-build.log');proof['hashes']['logs/native-glyph-composite-build.log']=sha('logs/native-glyph-composite-build.log')
for backend in ['vulkan','dx12']:
 log='logs/native-glyph-composite-startup-'+backend+'.client.log';proof['artifacts'].append(log);proof['hashes'][log]=sha(log)
proof['environment_observation']='Vulkan loader reports a missing external TikTok LIVE Studio overlay JSON; NVIDIA Vulkan adapter and rendering still initialize. No unrelated system/software configuration modified.'
proof['limits']=[v for v in proof['limits'] if not v.startswith('315-test source not rebuilt')]+['315-test application rebuilt and startup observed Vulkan/DX12. Composition/kerning APIs verified in tests; widgets do not yet call them at runtime. Blue map regions and full-game requirements remain open.']
(r/'docs/native_glyph_composite_runtime_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-glyph-composite-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
goalpath=r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt';goal=goalpath.read_text(encoding='utf-8').replace('version à 313 tests.','version à 315 tests.').replace('Métriques/copie et cache des glyphes testés ; nouveau client à reconstruire.','Métriques/copie, cache et composition des glyphes testés ; widgets à raccorder.')
assert len(goal)<=4000;goalpath.write_text(goal,encoding='utf-8');Path('E:/mapslol3v3/GOAL-OPENLEAGUE-ACTUALISE.txt').write_text(goal,encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_glyph_composite_runtime_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
 e.update(client_tests=315,current_client_application_tests=315,client_tests_current_binary=315,client_test_source_matches_current_build=True,current_client_sha256=proof['current_binary_sha256'],client_binary_sha256=proof['current_binary_sha256'],pending_client_build=False,client_build_pending=False,current_source_progress='docs/native_glyph_composite_runtime_progress.json')
 if 'goal_plan_revision' in d:d['goal_plan_revision'].update(last_visually_qualified_application_tests=315,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['goal_objective_proposed']=goal
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');section='<section id="native-glyph-composite-runtime-progress"><h2>Client reconstruit avec composition/crénage</h2><p>315 tests client et 11 tests FreeType. Application reconstruite et démarrage inspecté Vulkan/DX12 :19 polices/154 associations de textes préparées. APIs de composition et crénage vérifiées par tests ; widgets appelants et dessin GPU non implémentés. Zones bleues toujours visibles.</p><a href="native_glyph_composite_runtime_progress.json">Preuves et limites</a></section>'
s=s.replace('</body>',section+'</body>').replace('Dernière application inspectée : version à 313 tests avec FreeType 2.4.8.','Dernière application inspectée : version à 315 tests avec FreeType 2.4.8.');p.write_text(s,encoding='utf-8')
rev=load('docs/goal_plan_revision.json');rev.update(updated_utc=now,last_visually_qualified_application_tests=315,objective_sha256=hashlib.sha256(goal.encode()).hexdigest());(r/'docs/goal_plan_revision.json').write_text(json.dumps(rev,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
dst=r/'tools'/Path(__file__).name
if dst.resolve()!=Path(__file__).resolve():shutil.copy2(__file__,dst)
print(json.dumps({'application_tests':315,'source_tests':315,'backends':2,'client_sha256':proof['current_binary_sha256'],'gpu_widgets':False,'complete':False}))
