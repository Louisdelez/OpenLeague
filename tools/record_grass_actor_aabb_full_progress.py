from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '192 passed; 0 failed' in (r/'logs/grass-actor-aabb-full-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-actor-aabb-full-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_actor_aabb_full_contract.json');assert proof['passed'] and len(proof['cases'])==2304
paths=['data/4.20/grass_actor_aabb_full_contract.json','data/4.20/grass_actor_aabb_contract.json','crates/client/src/grass_actor_aabb.rs','logs/grass-actor-aabb-full-tests.log','logs/grass-actor-aabb-full-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=192,client_build_passed=True,native_full_aabb_cases=2304,native_addresses=proof['native_addresses'],actor_aabb_derived_fields_ported=True,registered_spatial_propagation_qualified=False,model_bounds_getter_qualified=False,live_grass_mask_integrated=False,findings=['Complete6151A0 executes with original71A5B0 no-node path, rather than stopping before post-AABB metric updates.2304cases combine192previousAABBinputs with12rawshape/radiusconditions.','Rustmatchesbitwise AABB, eightderived/metricfields, FFFFFFFF sentinel and modelgettercalls. Positive/unordered rawmetrics preserve resolvedheight/radius; otherwise heightfromroundedAABBspan/radius100. Native0.52factor multipliesradius successively.','Getter discovery remains unresolved. Initial readonlyRTTIcandidate script lacked bounded invalid-string handling and produced excessive output; stopped, corrected bound/filter and rerun. No candidate adopted without provenance.'],limits=proof['limits']+['Fullmethod qualification is restrictedtoactor+CCnull; original registered spatial index update not yet executed/ported.','Modelprovider still supplied at virtual+4. No live actors/camera/mask/WALL integration or new normal-match/GPU capture. All24domains incomplete.'],next_actions=['Recover original model bounds getter/provider and position/scale/raw metric producers; qualify registered71A5B0 spatial propagation and actualactorcalls.','Qualify camera/viewport and connect actual actor collector to normal grass mask/WALL renderer; inspect real Map10 match.','Continue full24domainplan, remainingkits/services, sixclientvictory/results and delivery.'],files_sha256={p:sha(p) for p in paths})
save('docs/grass_actor_aabb_full_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('191 tests','192 tests').replace('191tests','192tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : identifier le getter natif des bornes du modèle et les producteurs position/échelles/métriques ; qualifier propagation spatiale enregistrée, caméra, puis brancher acteurs/masque/WALL au rendu normal. Méthode6151A0 complète sans nœud spatial comparée à2304cas, métriques dérivées portées. 192tests et compilation réussis. Producteurs et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_actor_aabb_full_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=192;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=192,current_test_receipt='docs/grass_actor_aabb_full_progress.json',current_build_receipt='docs/grass_actor_aabb_full_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_grass_aabb_derived_fields_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Méthode AABB et métriques dérivées</h2><p>2304cas natifs complets sans nœud spatial ;192tests et compilation réussis. Getter du modèle, producteurs, index spatial et intégration au jeu restent ouverts.</p><a href="grass_actor_aabb_full_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_grass_actor_aabb_full_progress.py',r/'tools/record_grass_actor_aabb_full_progress.py')
print(json.dumps(dict(client_tests=192,full_aabb_cases=2304,model_getter_qualified=False,complete=False)))
