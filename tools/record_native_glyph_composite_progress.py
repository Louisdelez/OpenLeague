from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '11 passed; 0 failed' in (r/'logs/native-glyph-composite-tests.log').read_text()
assert '315 passed; 0 failed' in (r/'logs/native-glyph-composite-client-tests.log').read_text()
probe=load('docs/native_glyph_composite_source_probe.json');assert probe['source_hashes_verified'] and probe['panels']==10
assert probe['preview_sha256']==sha(probe['preview'])
# Invoke only after inspecting the actual generated image.
probe['visual_inspected']=True
(r/'docs/native_glyph_composite_source_probe.json').write_text(json.dumps(probe,indent=2)+'\n',encoding='utf-8')
old=load('docs/native_glyph_cache_progress.json');assert old['current_binary_sha256']==sha('target/debug/openleague-client.exe')
artifacts=['crates/font-raster/src/native_glyph.rs','crates/font-raster/src/lib.rs','crates/font-raster/bridge.c','crates/font-raster/examples/source_native_composite.rs','crates/client/src/native_font_metrics.rs','data/4.20/native_glyph_composite_contract.json','data/4.20/native_glyph_kerning_contract.json','logs/native-glyph-composite-tests.log','logs/native-glyph-composite-client-tests.log','docs/native_glyph_composite_source_probe.json']
proof={'updated_utc':now,'complete':False,'client_source_tests_passed':315,'font_raster_tests_passed':11,'last_qualified_application_tests':313,'current_binary_sha256':sha('target/debug/openleague-client.exe'),'application_rebuilt_after_changes':False,'native_clipped_glyph_composition_rust_cases':1350,'native_kerning_method_rust_cases':128,'native_clipped_glyph_composition_rust_ported':True,'native_kerning_mode':0,'source_family_probes':5,'source_text_binding_count':154,'cpu_probe':probe,'gpu_glyph_rendering_qualified':False,'hud_widgets_drawn':False,'artifacts':artifacts,'hashes':{p:sha(p) for p in artifacts},'next_action':'Qualifier et porter le layout natif des textes et leur atlas/dessin GPU ; reconstruire le client et vérifier les widgets et interactions HUD. Corriger les zones bleues de la carte puis poursuivre tous les domaines du plan.','limits':['1350 original composition cases use supplied cached bitmaps; 128 original kerning cases use explicit successful FT provider. Whole native text layout, native errors and original glyph pixel equality remain unqualified.','Actual source-font two-phase loading, clipping, composition and kerning supported by official FreeType2.4.8 backend. Native compiler patches/hinting configuration remain open.','Bounds/range guards and lazy engine-owned cache are explicit integration choices; native device ownership/cache destruction not fully ported.','Diagnostic preview contains actual source glyphs in normal and clipped positions, not original-game reference comparison, GPU text drawing or HUD widgets.','315-test source not rebuilt or runtime-observed yet; last qualified application remains313-test build. Map blue regions, full champions, six graphical clients match and delivery still open.']}
(r/'docs/native_glyph_composite_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-glyph-composite-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
goal_path=r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt';goal=goal_path.read_text(encoding='utf-8').replace('314 tests client et 7 tests FreeType réussis.','315 tests client et 11 tests FreeType réussis.')
assert len(goal)<=4000;goal_path.write_text(goal,encoding='utf-8');Path('E:/mapslol3v3/GOAL-OPENLEAGUE-ACTUALISE.txt').write_text(goal,encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_glyph_composite_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
 e.update(client_tests=315,client_tests_passed=315,font_raster_tests_passed=11,current_client_application_tests=313,client_test_source_matches_current_build=False,current_source_progress='docs/native_glyph_composite_progress.json',pending_client_build=True,client_build_pending=True)
 if 'goal_plan_revision' in d:d['goal_plan_revision'].update(client_source_tests_passed=315,font_raster_tests_passed=11,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:];d['goal_objective_proposed']=goal
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=re.sub(r'<section id="native-glyph-composite-progress">.*?</section>','',s,flags=re.S)
section='<section id="native-glyph-composite-progress"><h2>Composition et crénage natifs des glyphes</h2><p>315 tests client et 11 tests FreeType réussis. 1350 compositions avec clipping et 128 cas de crénage comparés aux fonctions originales ; APIs raccordées aux 154 textes. Aperçu CPU des cinq polices originales inspecté. Dernière application qualifiée :313tests ; layout, atlas et dessin GPU, widgets et défauts de carte restent ouverts.</p><a href="native_glyph_composite_progress.json">Preuves et limites</a></section>'
s=s.replace('</body>',section+'</body>');s=s.replace('Derniers tests : 313 client et 3 FreeType réussis.','Derniers tests : 315 client et 11 FreeType réussis.');p.write_text(s,encoding='utf-8')
revision=load('docs/goal_plan_revision.json');revision.update(updated_utc=now,client_source_tests_passed=315,font_raster_tests_passed=11,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
(r/'docs/goal_plan_revision.json').write_text(json.dumps(revision,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['port_native_glyph_composite.py','port_native_glyph_composite_client.py','qualify_native_glyph_kerning.py','render_native_composite_probe.py','record_native_glyph_composite_progress.py','inspect_native_font_layout.py']:
 src=Path('E:/mapslol3v3')/name;dst=r/'tools'/name
 if src.resolve()!=dst.resolve():shutil.copy2(src,dst)
print(json.dumps({'source_client_tests':315,'font_tests':11,'composition_cases':1350,'kerning_cases':128,'text_bindings':154,'application_tests':313,'complete':False}))
