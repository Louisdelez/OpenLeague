from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '137 passed; 0 failed' in (r/'logs/search-resource-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/search-resource-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/search_resource_provider_contract.json');assert proof['passed'] and len(proof['cases'])==24
source=load('docs/native_projection_discovery.json');assert hashlib.sha256(Path(source['source']).read_bytes()).hexdigest()==proof['native_sha256']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':137,'client_build_passed':True,'native_search_cases':24,'native_addresses':proof['native_addresses'],'findings':['Original derived search-provider path/existence methods and basic map provider parent setter/delegation execute across24explicit context fixtures.','Rust preserves ordered nonempty path priority, fallback path with no contexts, and absence of fallback existence lookup with no contexts. Basic provider keeps local empty entry precedence.','All137client tests pass; actual Map10 global search context population is still unqualified and is not guessed.'],'limits':proof['limits']+['Production Map10 catalog parent remains explicitly unqualified; no new live framebuffer for this contract-only change. Prior screenshots retain their original binary hashes.','ASCII key folding qualified; nonASCII and duplicate key insertion remain explicitly rejected.','Normal dynamic fog fade/blur/overlay activation and complete game scope remain unfinished.'],'next_actions':['Qualify the original global search-context list producer and cached table enumeration for actual Map10.','Qualify logical terrain.ini configuration resolution and upscale/overlay selection, then bind native fade/blur to normal shaders.','Numerically verify GPU mask coordinates; complete six-client Map10 match and all remaining game/launcher/services domains.'],'files_sha256':{p:sha(p) for p in ['crates/client/src/map_resource_provider.rs','data/4.20/search_resource_provider_contract.json','logs/search-resource-tests.log','logs/search-resource-build.log','target/debug/openleague-client.exe']}}
save('docs/native_search_resource_provider_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_search_resource_provider_progress']=receipt
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=137;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=137,current_test_receipt='docs/native_search_resource_provider_progress.json',current_build_receipt='docs/native_search_resource_provider_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),current_binary_visibility_diagnostic_verified=False,current_binary_hud_visual_verified=False,map10_resource_catalog_runtime_verified=False,live_fow_material_bound=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Fournisseur des dossiers de recherche</h2><p>24 cas natifs portés en Rust : priorité des dossiers, chemins vides et différence entre résolution et existence.137 tests passent ; compilation réussie. Les dossiers globaux réels et le brouillard normal restent à terminer.</p><a href="native_search_resource_provider_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('136 tests réussis','137 tests réussis');p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><body><pre>'+html.escape(s)+'</pre></body></html>',encoding='utf-8')
shutil.copy2(p,Path('E:/mapslol3v3/nouveau-goal-openleague.txt'))
for name in ['probe_search_resource_provider.py','install_search_resource_provider.py','record_search_resource_provider.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps({'client_tests':137,'native_search_cases':24,'complete':False}))
