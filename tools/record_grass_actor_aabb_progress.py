from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '191 passed; 0 failed' in (r/'logs/grass-actor-aabb-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-actor-aabb-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_actor_aabb_contract.json');assert proof['passed'] and len(proof['cases'])==192 and len(proof['copy_cases'])==3
paths=['data/4.20/grass_actor_aabb_contract.json','crates/client/src/grass_actor_aabb.rs','crates/client/src/main.rs','logs/grass-actor-aabb-tests.log','logs/grass-actor-aabb-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=191,client_build_passed=True,native_aabb_cases=192,native_aabb_copy_cases=3,native_addresses=proof['native_addresses'],actor_aabb_calculation_ported=True,explicit_collector_source_adapter=True,live_grass_mask_integrated=False,findings=['Original6151A0 prefix writes sixfloat AABB at actor95..A9. Rustmatches192bit-exact outputs and0/4modelgetter calls, including changing fourgetter responses, scales0/negative/fractional and large/negative positions.','NativeX/Zside uses average of modelX/Zspans timesmodelscale*actorscale; minYoffset added unscaled, height scaled. No-model fallback25width/85height. Maxima are rounded minimum+span, not position+half. Inverted/degeneratebounds retained.','Native716F60 copy prefix executes3sixword vectors containing finite/extreme/subnormal/negativezero/Inf/NaN bits. This is emulated native copy evidence only; no additional Rust copy API required.'],limits=proof['limits']+['Collector source adapter accepts explicit raw gates/position/scales/model bounds; not connected to actual actor registry. Native spatial propagation and full6151A0 post-AABB side effects remain open.','NaN copy behavior observed in Unicorn, not original x87 hardware exception/rounding acceptance. No normal-match/GPU capture. All24domains incomplete.'],next_actions=['Recover actual model bounds virtual+4 getter, scale/position producers and actor calls to6151A0; qualify71A5B0 propagation/fullmethod side effects.','Qualify camera/viewport providers and connect actual actor collector into normal grass mask/WALL rendering; inspect Map10 match.','Continue full24domainplan, remainingchampionkits, sixclientvictory/results and delivery.'],files_sha256={p:sha(p) for p in paths})
save('docs/grass_actor_aabb_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('190 tests','191 tests').replace('190tests','191tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier getter des bornes du modèle, producteurs de position/échelles, appels au calcul AABB et propagation spatiale ; caméra puis collecteur et masque des buissons au rendu normal. Calcul AABB6151A0 porté et comparé à192cas natifs ; adaptateur explicite vers collecteur. 191tests et compilation réussis. Producteurs et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_actor_aabb_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=191;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=191,current_test_receipt='docs/grass_actor_aabb_progress.json',current_build_receipt='docs/grass_actor_aabb_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_grass_actor_aabb_calculation_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Calcul natif des boîtes englobantes</h2><p>192cas natifs et ordre des lectures comparés ;191tests et compilation réussis. Producteurs du modèle/position, propagation, caméra et intégration au jeu restent ouverts.</p><a href="grass_actor_aabb_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_grass_actor_aabb_progress.py',r/'tools/record_grass_actor_aabb_progress.py')
print(json.dumps(dict(client_tests=191,aabb_cases=192,copy_cases=3,complete=False)))
