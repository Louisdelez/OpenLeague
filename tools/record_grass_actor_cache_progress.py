from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '183 passed; 0 failed' in (r/'logs/grass-actor-cache-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-actor-cache-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_actor_cache_contract.json');assert proof['passed'] and len(proof['cases'])==300
map10=load('data/4.20/grass_actor_map10_contract.json');assert map10['passed'] and len(map10['cases'])==12 and map10['runtime_adapters']==[]
paths=['data/4.20/grass_actor_cache_contract.json','crates/client/src/grass_actor_cache.rs','crates/client/src/main.rs','logs/grass-actor-cache-tests.log','logs/grass-actor-cache-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=183,client_build_passed=True,native_actor_cache_cases=300,native_actor_cache_addresses=proof['native_addresses'],native_actor_cache_ported=True,live_grass_mask_integrated=False,terrain_query_qualified=False,findings=['Executed original6197B0 and actual5FFFD0 position getter across300 cases, including unchanged/moved positions, ignored Y, radius override/fallback, threshold boundary, NaN/infinity and arbitrary noncanonical result bytes.','Rust cache matches query argument bits, call/no-call decisions, result byte and final cache fields in every native case. Radius refresh uses >=epsilon or unordered; position refresh uses >epsilon or unordered.'],limits=proof['limits']+['No new full-match rendering, gameplay or GPU verification in this change; previous GPU receipts remain separately scoped. All24domains remain open.'],next_actions=['Qualify terrain predicate8F3390 against original Map10 grid and connect actor eligibility, AABB and camera providers.','Integrate recovered grass mask/WALL_OF_GRASS into normal renderer and inspect actual match output.','Continue full24domain plan and six-client victory/results qualification.'],files_sha256={p:sha(p) for p in paths})
receipt['native_map10_cache_cases']=12
receipt['native_map10_cache_addresses']=map10['native_addresses']
receipt['terrain_query_qualified']=True
receipt['terrain_query_qualification_scope']='12 original Map10 positions/radii, each initial query and unchanged repeat; not exhaustive or a Rust terrain-query port.'
receipt['findings'].append('Original6197B0 ->5FFFD0 ->8F3390 executed without adapters against verified original Map10 packed cell grid:12 scenarios, repeated unchanged call reuses cache. Radius0/34/35/64 at flag1 sampled centers returns1; radius500/501 returns0 at same selected center. No bit-only synthetic predicate substituted.')
receipt['limits'].extend(map10['limits'])
receipt['files_sha256']['data/4.20/grass_actor_map10_contract.json']=sha('data/4.20/grass_actor_map10_contract.json')
receipt['next_actions'][0]='Port terrain predicate8F3390 with additional native boundary cases and original Map10 data; connect actual actor eligibility/AABB and camera providers.'
save('docs/grass_actor_cache_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('176 tests','183 tests').replace('182 tests','183 tests').replace('182tests','183tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier la requête terrain native8F3390, les producteurs des acteurs/AABB et caméra ; intégrer le masque des buissons et WALL_OF_GRASS au rendu normal. Collecteur et cache des acteurs portés ; cache comparé à300cas natifs. 183tests client et compilation réussis. Entrées complètes et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_actor_cache_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=183;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=183,current_test_receipt='docs/grass_actor_cache_progress.json',current_build_receipt='docs/grass_actor_cache_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_grass_actor_cache_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Cache natif des acteurs</h2><p>300cas natifs comparés ; 183tests client et compilation réussis. Requête terrain, producteurs et intégration au jeu restent ouverts.</p><a href="grass_actor_cache_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['record_grass_actor_cache_progress.py','probe_native_grass_actor_map10.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=183,native_cases=300,complete=False)))
