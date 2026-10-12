from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '194 passed; 0 failed' in (r/'logs/grass-spatial-bounds-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-spatial-bounds-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_spatial_rounding_contract.json');assert proof['passed'] and len(proof['cases'])==200
paths=['data/4.20/grass_spatial_rounding_contract.json','data/4.20/grass_spatial_bounds_contract.json','crates/client/src/grass_spatial_bounds.rs','crates/client/src/main.rs','logs/grass-spatial-bounds-tests.log','logs/grass-spatial-bounds-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=194,client_build_passed=True,native_spatial_rounding_cases=200,native_prior_spatial_bounds_cases=20,native_addresses=proof['native_addresses'],finite_spatial_bounds_ported=True,nonfinite_spatial_crt_qualified=False,live_grass_mask_integrated=False,findings=['Complete95F370 and originalCRT execute200finitecases across10coordinate inputs,5localbounds and2integer x2ceil profiles without adapters. Rustmatchesall200 plusprevious20bounds cases.','MinimumX/Z usefloor thenCVTTinvalidINT_MIN. MaximumX/Z useceil with explicitSSE orlegacyCRT conversion. At2^32 legacylowwordreturns0 whileSSEreturnsINT_MIN; profile is explicit instead ofsaturating Rustcast.','Nonfinite/overflowedsums return explicit unqualified error, withno synthetic CRT result adopted. Original CPUprofile producer and nondefaultcontrol modes remainopen.'],limits=proof['limits']+['Rustfinitebounds helper is not yet connected to registered spatialdispatch.95F060/95FF10 andactualregistration/model/camera providers remainopen.','No normal-match/GPU capture; all24domains incomplete.'],initial_native_probe_failure=proof['initial_failure'],next_actions=['Connect ported95F370 finitebounds toregistereddispatch and compare original compoundcall; qualify95F060/95FF10 andactualregistration.','Resolve nonfiniteCRT prerequisites andoriginalCPUprofile producer; recover modelbounds/camera andliveactorcollectormask/WALL integration.','Continue full24domainplan, allchampionkits, sixclientvictory/results and delivery.'],files_sha256={p:sha(p) for p in paths})
save('docs/grass_spatial_bounds_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('193 tests','194 tests').replace('193tests','194tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : relier le calcul95F370 au dispatch spatial et qualifier95F060/95FF10, registration et profils CPU ; résoudre chemin CRT non fini, fournisseur modèle et caméra ; acteurs/masque/WALL au rendu normal. Bornes finies comparées à200cas avec profils CRT/SSE, plus20cas précédents. 194tests et compilation réussis. Chemins non finis, producteurs et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_spatial_bounds_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=194;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=194,current_test_receipt='docs/grass_spatial_bounds_progress.json',current_build_receipt='docs/grass_spatial_bounds_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_finite_spatial_bounds_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Bornes spatiales et profils CRT/SSE</h2><p>200cas natifs et20précédents ;194tests et compilation réussis. Chemin non fini, branchement index et producteurs restent ouverts.</p><a href="grass_spatial_bounds_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_grass_spatial_bounds_progress.py',r/'tools/record_grass_spatial_bounds_progress.py')
print(json.dumps(dict(client_tests=194,finite_rounding_cases=200,nonfinite_qualified=False,complete=False)))
