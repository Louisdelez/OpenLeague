from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
logs={name:(r/('logs/'+name)).read_text(encoding='utf-8-sig') for name in ['native-glyph-raster-tests.log','native-glyph-cache-client-tests.log']}
assert '7 passed; 0 failed' in logs['native-glyph-raster-tests.log']
assert '314 passed; 0 failed' in logs['native-glyph-cache-client-tests.log']
assert all('test result: FAILED' not in log for log in logs.values())
old=load('docs/native_font_metrics_progress.json');assert old['current_binary_sha256']==sha('target/debug/openleague-client.exe')
composition=load('data/4.20/native_glyph_composite_contract.json');assert composition['passed'] and composition['case_count']==1350
artifacts=['crates/font-raster/src/native_glyph.rs','crates/font-raster/src/lib.rs','crates/font-raster/bridge.c','crates/client/src/native_font_metrics.rs','data/4.20/native_glyph_loading_contract.json','logs/native-glyph-raster-tests.log','logs/native-glyph-cache-client-tests.log']
proof={'updated_utc':now,'complete':False,'client_source_tests_passed':314,'font_raster_tests_passed':7,'last_qualified_application_tests':313,'current_binary_sha256':sha('target/debug/openleague-client.exe'),'application_rebuilt_after_changes':False,'native_glyph_metrics_rust_cases':54,'native_rgba_copy_rust_cases':36,'source_family_two_phase_loading_tests':5,'native_metrics_load_flags':0,'native_bitmap_load_flags':4,'source_text_cache_binding_count':154,'source_logical_face_count':19,'cache_resize_heights_tested':[800,1080,768],'cache_key':'UTF16 code unit','engine_cache_lazy_loading_integrated':True,'native_cache_ownership_ported':False,'gpu_glyph_rendering_qualified':False,'hud_widgets_drawn':False,'artifacts':artifacts,'hashes':{p:sha(p) for p in artifacts},'next_action':'Qualifier l’atlas et les chemins de dessin natifs, intégrer les glyphes au rendu GPU et reconstruire le client ; widgets et interactions HUD, zones bleues de la carte puis tous les domaines du plan.','limits':['Original metrics and bitmap-copy cases use supplied successful FT providers; original compile patches/hinting and native bitmap equality remain open.','Backend uses official FreeType2.4.8, preserves source charmaps including valid NUL mappings and index0 results. GPU/text shaping, kerning, shadows and other glyph paths remain open.','Whole-rectangle/source bounds guards are explicit engine safety behavior; native clipping/error behavior is not claimed.','Cache is engine-owned and lazy; native cache lifetime/refcounts are not ported. No runtime widget caller or GPU glyph drawing qualified.','Current application remains the preceding313-test version; new314-test source has not been rebuilt/visually observed. No full champion kit, map, six-client match or delivery closure.']}
(r/'docs/native_glyph_cache_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof.update(native_clipped_glyph_composition_cases=1350,native_clipped_glyph_composition_rust_ported=False)
proof['artifacts'].append('data/4.20/native_glyph_composite_contract.json');proof['hashes']['data/4.20/native_glyph_composite_contract.json']=sha('data/4.20/native_glyph_composite_contract.json')
proof['next_action']='Porter la composition native et son clipping (1350cas), qualifier kerning/layout et atlas ; intégrer le rendu GPU des textes et reconstruire le client ; widgets et interactions HUD, zones bleues de la carte puis tous les domaines.'
(r/'docs/native_glyph_cache_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-glyph-cache-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
goal_path=r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt';goal=goal_path.read_text(encoding='utf-8')
goal=goal.replace('313 tests client et 3 tests FreeType réussis.','314 tests client et 7 tests FreeType réussis.').replace('Glyphes GPU et HUD interactif ouverts.','Métriques/copie et cache des glyphes testés ; nouveau client à reconstruire. Glyphes GPU et HUD interactif ouverts.')
assert len(goal)<=4000
goal_path.write_text(goal,encoding='utf-8');Path('E:/mapslol3v3/GOAL-OPENLEAGUE-ACTUALISE.txt').write_text(goal,encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_glyph_cache_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
 e.update(client_tests=314,client_tests_passed=314,font_raster_tests_passed=7,current_client_application_tests=313,client_test_source_matches_current_build=False,current_source_progress='docs/native_glyph_cache_progress.json',pending_client_build=True,client_build_pending=True)
 if 'goal_plan_revision' in d:d['goal_plan_revision'].update(client_source_tests_passed=314,font_raster_tests_passed=7,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:];d['goal_objective_proposed']=goal
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=re.sub(r'<section id="native-glyph-cache-progress">.*?</section>','',s,flags=re.S)
section='<section id="native-glyph-cache-progress"><h2>Glyphes et cache des textes source</h2><p>314 tests client et 7 tests FreeType réussis. Métriques comparées sur 54 cas et copies RGBA sur 36 cas ; chargement natif en deux étapes (flags0/4) depuis les cinq familles originales. Cache par code UTF16 raccordé aux 154 textes, réutilisation et invalidation au redimensionnement vérifiées. Application précédente313tests ; reconstruction, atlas GPU, glyphes dessinés, widgets et défauts de carte restent ouverts.</p><a href="native_glyph_cache_progress.json">Preuves et limites</a></section>'
s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
revision=load('docs/goal_plan_revision.json');revision.update(updated_utc=now,client_source_tests_passed=314,font_raster_tests_passed=7,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
(r/'docs/goal_plan_revision.json').write_text(json.dumps(revision,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['port_native_glyph.py','port_native_glyph_cache.py','record_native_glyph_cache_progress.py','qualify_native_glyph_composite.py','inspect_native_glyph_atlas.py','inspect_native_glyph_composite.py']:
 src=Path('E:/mapslol3v3')/name;dst=r/'tools'/name
 if src.resolve()!=dst.resolve():shutil.copy2(src,dst)
print(json.dumps({'source_client_tests':314,'font_tests':7,'metrics_cases':54,'copy_cases':36,'source_text_bindings':154,'application_tests':313,'complete':False}))
