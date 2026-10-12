from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '91 passed; 0 failed' in (r/'logs/fow-map10-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-map10-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_map10_occluded_contract.json');assert len(proof['cases'])==16 and len(proof['query_cases'])==54
assert proof['terrain']['heights_and_flags_byte_matches']==39474
assert proof['terrain']['sha256']=='1430e679b91a582f871ce78185bcda3db5eb7daf82beb7aba26264addcf5d9bd'
assert hashlib.sha256(Path(proof['terrain']['source']).read_bytes()).hexdigest()==proof['terrain']['sha256']
files=['data/4.20/fow_map10_occluded_contract.json','crates/client/src/fow_occluded.rs','crates/client/src/fow_terrain_ray.rs','tools/probe_fow_map10_occluded.py','assets/maps/tt_navigation_grid.cells.bin','logs/fow-map10-tests.log','logs/fow-map10-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=91,client_build_passed=True,native_map10_occluded_masks=16,native_map10_source_queries=54,original_instruction_addresses=proof['original_instruction_addresses'],source=proof['terrain'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['All39474 imported heights and flag words match original Map10 disk cells byte-for-byte. Original and archived resource copies identical; disk stride56, cells offset39, flags offset50.','Full original occluded generator executes with real Map10 cell bytes, actual nonzero origins and128cell fog grid; Rust matches16masks, rectangles, counters and flipped pixel outputs.','Original source query8F3390 executes without return adapter; Rust point/circle source-flag query matches54cases including35unit branch boundary,500unit cap and real brush cells. Map10 composed Rust cases now compute source flags through this provider.'],
 limits=proof['limits']+['The Rust provider is qualified for tested Map10 inputs. Scan budget overflow returns an explicit unsupported error rather than executing native diagnostic logging.','No ordinary graphical run was performed for this newly compiled client; all24domains remain unfinished.'],
 next_actions=['Trace native runtime terrain constructor, inverse/half-cell initialization and full world extent producer; qualify source metric/radius and owner modifiers.','Port cone composition and compare original masks on actual Map10, including boundaries and actor-derived prerequisites.','Bind actual source creation/removal/lifecycle and counted visibility to native-timed GPU upload, fade, blur and overlays; verify ordinary client gameplay.'],files_sha256={p:sha(p) for p in files})
save('docs/projected_fow_map10_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['projected_fow_map10_progress']=receipt
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=91;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=91,current_build_receipt='docs/projected_fow_map10_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard — grille originale de Map10</h2><p>91 tests client et compilation réussis. Les39474hauteurs et drapeaux importés correspondent aux données originales.16masques natifs à128cellules et54requêtes de vision comparés au port Rust. Données et origines réelles de Map10 ; requête native exécutée sans remplacement. Les acteurs, cônes, fournisseurs de dimensions/modificateurs et rendu ordinaire restent ouverts.</p><a href="projected_fow_map10_progress.json">Preuves et limites actuelles</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_map10.py'),r/'tools/record_fow_map10.py')
print(json.dumps(dict(client_tests=91,native_map10_masks=16,native_source_queries=54,matched_cells=39474,live_fow_bound=False,complete=False)))
