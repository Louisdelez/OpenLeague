from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '187 passed; 0 failed' in (r/'logs/grass-actor-visibility-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-actor-visibility-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_actor_visibility_contract.json');assert proof['passed'] and len(proof['cases'])==2304 and len(proof['simple_cases'])==256
paths=['data/4.20/grass_actor_visibility_contract.json','crates/client/src/grass_actor_visibility.rs','crates/client/src/main.rs','logs/grass-actor-visibility-tests.log','logs/grass-actor-visibility-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=187,client_build_passed=True,native_actor_gate_cases=2304,native_simple_gate_cases=256,native_actor_gate_addresses=proof['native_addresses'],actor_gate_consumers_ported=True,live_grass_mask_integrated=False,findings=['Original617F10 calls original6B2C30 selector;2304cases qualify result and globalservice callorder, including changed second call, noncanonical AL128, override shortcircuit and actorbit0.','Native selector-1 accepts;selector-2 checks low2bits; remainingselectors use x86SHL countmod32. Rustmatchesallresults/calls.','Original647D00 gate exhaustively checked256actorbytevalues and ported.'],limits=proof['limits']+['No normal-match/GPU capture; raw inputs and service are explicit, with no synthetic class meaning inferred. All24domains remain open.'],initial_probe_failure='Name collision in inherited sampler-hook global api caused adapter assertion; gate_api renamed and entire native probe rerun successfully.',next_actions=['Qualify remaining subclass gates644E40/62DC80 and actual source/global service producers, actor AABB and camera providers.','Feed actual collector inputs into recovered grass mask/WALL normal renderer, verify actual Map10 match pixels.','Continue all24domains and six-client victory/results, champion kits, services and delivery.'],files_sha256={p:sha(p) for p in paths})
save('docs/grass_actor_visibility_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('185 tests','187 tests').replace('185tests','187tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier critères restants des sous-classes, producteurs du service/source, AABB et caméra ; intégrer collecteur, masque et WALL_OF_GRASS au rendu normal. Critères natifs617F10/6B2C30 comparés à2304cas,647D00 aux256valeurs de drapeau. 187tests et compilation réussis. Producteurs et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_actor_visibility_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=187;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=187,current_test_receipt='docs/grass_actor_visibility_progress.json',current_build_receipt='docs/grass_actor_visibility_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_grass_actor_gates_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Critères natifs des acteurs</h2><p>2304cas natifs et256drapeaux ;187tests et compilation réussis. Sous-classes restantes, producteurs et intégration au jeu restent ouverts.</p><a href="grass_actor_visibility_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_grass_actor_visibility_progress.py',r/'tools/record_grass_actor_visibility_progress.py')
print(json.dumps(dict(client_tests=187,native_cases=2304,simple_cases=256,complete=False)))
