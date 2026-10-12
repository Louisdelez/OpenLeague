from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '185 passed; 0 failed' in (r/'logs/grass-terrain-budget-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-terrain-budget-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_terrain_budget_contract.json');assert proof['passed'] and len(proof['cases'])==420
paths=['data/4.20/grass_terrain_budget_contract.json','data/4.20/grass_actor_map10_contract.json','crates/client/src/fow_terrain_ray.rs','crates/client/src/grass_actor_cache.rs','logs/grass-terrain-budget-tests.log','logs/grass-terrain-budget-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=185,client_build_passed=True,native_terrain_cases=420,native_terrain_addresses=proof['native_addresses'],native_exhausted_budget_cases=sum(bool(c['budget_log_calls']) for c in proof['cases']),native_map10_actor_cache_cases=12,native_terrain_query_port_corrected=True,live_grass_mask_integrated=False,findings=['Original8F3390 executes420cases across5flags patterns,3cell sizes,4positions and7radius inputs. Includes35boundary,500cap,NaN/infinity and75exhausted-budgetcases.','PreviousRustqueryrejectedboundingboxes>1000cells; correctedtooriginal1000counter decrement per examined column or skipped row, retaining partial-scan count-based result. Shared normal CPU fog uses this query.','Rustsource_flagmatches420originalresults; actualMap10cache/provider/query compound12scenarios x2frames compares result, argumentbits, cachefields and no-call repeat.'],limits=proof['limits']+['Actor field producers, eligibility90/AABB/camera and grass mask/WALL normal renderer integration remain open. No new normal-match/GPU capture. All24domains unfinished.'],next_actions=['Qualify remaining actual actor eligibility gates/AABB and camera providers; feed recovered collector and mask into normal renderer.','Verify actual grass mask/WALL output on normal Map10 match and original inherited filters.','Continue all24domains, champion kits, fullsixclientvictory/results and delivery.'],files_sha256={p:sha(p) for p in paths})
save('docs/grass_terrain_budget_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('183 tests','185 tests').replace('183tests','185tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier les producteurs réels des acteurs, leurs autres critères et AABB, puis caméra ; intégrer collecteur, masque et WALL_OF_GRASS au rendu normal. Requête terrain partagée corrigée et comparée à420cas natifs, dont75scans au budget épuisé ; cache et terrain Map10 comparés sur12scénarios répétés. 185tests client et compilation réussis. Branchement à la partie restant ouvert. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_terrain_budget_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=185;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=185,current_test_receipt='docs/grass_terrain_budget_progress.json',current_build_receipt='docs/grass_terrain_budget_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_grass_terrain_budget_corrected=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Requête terrain et budget natifs</h2><p>420cas natifs, dont75limites de budget ; cache+terrain Map10 sur12scénarios répétés. 185tests et compilation réussis. Producteurs et masque de rendu encore ouverts.</p><a href="grass_terrain_budget_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_grass_terrain_budget_progress.py',r/'tools/record_grass_terrain_budget_progress.py')
print(json.dumps(dict(client_tests=185,native_cases=420,budget_cases=75,complete=False)))
