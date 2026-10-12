from pathlib import Path
import json,hashlib,datetime,shutil,sys
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '25 passed; 0 failed' in (r/'logs/native-font-text-geometry-raster-tests.log').read_text(encoding='utf-8')
assert '320 passed; 0 failed' in (r/'logs/native-font-text-geometry-client-tests.log').read_text(encoding='utf-8')
proof=load('docs/native_font_sequence_progress.json');metrics=load('data/4.20/native_font_face_metrics_contract.json');assert metrics['passed'] and metrics['case_count']==108
proof.update(updated_utc=now,font_raster_tests_passed=25,client_source_tests_last_passed=320,native_face_metric_cases=108,native_face_metric_addresses=29,source_text_geometry_api_ported=True,source_text_bindings_exercised=154,source_geometry_first_nul_termination=True,ordinary_hud_widgets_drawn=False,application_rebuilt_after_geometry_port=False)
for p in ['data/4.20/native_font_face_metrics_contract.json','tools/qualify_native_font_face_metrics.py','crates/client/src/native_font_metrics.rs','logs/native-font-text-geometry-client-tests.log','logs/native-font-text-geometry-raster-tests.log']:
 if p not in proof['artifacts']:proof['artifacts'].append(p)
proof['hashes']={p:sha(p) for p in proof['artifacts']};proof['limits']+=metrics['limits']+['Source client API now combines real glyph metrics/cache, source descriptor sizing, atlas UV, native cell preparation/alignment/sequence/quads. Tested all154source text bindings with A-space-V-eacute/NUL and invalid binding. This is not a widget rendering or all text/locale/markup/resize acceptance test.']
proof['next_action']='Raccorder la géométrie des textes source aux matériaux GPU et aux widgets HUD réels (positions/couleurs/données), qualifier la convention viewport/half-texel et les glyphes dans le client Vulkan/DX12. Achever tous les autres domaines du plan.'
(r/'docs/native_font_text_geometry_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-font-text-geometry-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
gp=r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt';shutil.copy2(gp,history/gp.name);goal=gp.read_text(encoding='utf-8').replace('319 tests client et 24 tests FreeType réussis.','320 tests client et 25 tests FreeType réussis.').replace('quads/alignement/séquences testés séparément.','géométrie des textes source testée séparément.');assert len(goal)<=4000;gp.write_text(goal,encoding='utf-8');Path('E:/mapslol3v3/GOAL-OPENLEAGUE-ACTUALISE.txt').write_text(goal,encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_font_text_geometry_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=320,client_tests_passed=320,font_raster_tests_passed=25,client_test_source_matches_current_build=False,current_source_progress='docs/native_font_text_geometry_progress.json')
 if 'goal_plan_revision' in d:d['goal_plan_revision'].update(client_source_tests_passed=320,font_raster_tests_passed=25,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['goal_objective_proposed']=goal;d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section id="native-font-text-geometry-progress"><h2>Géométrie des textes source</h2><p>API glyphes FreeType/source vers préparation/placement/quads/UV natifs.154références texte testées,320tests client/25backend ; métriques natives108cas. Matériaux/widgets ordinaires et nouvelle application à raccorder/vérifier.</p><a href="native_font_text_geometry_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,client_source_tests_passed=320,font_raster_tests_passed=25,objective_sha256=hashlib.sha256(goal.encode()).hexdigest());p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['port_native_font_text_geometry.py','record_native_font_text_geometry_progress.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps({'source_client_tests':320,'source_font_tests':25,'source_text_bindings':154,'ordinary_hud_complete':False,'complete':False}))
