from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '193 passed; 0 failed' in (r/'logs/grass-spatial-dispatch-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-spatial-dispatch-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_spatial_dispatch_contract.json');assert proof['passed'] and len(proof['cases'])==2328
paths=['data/4.20/grass_spatial_dispatch_contract.json','crates/client/src/grass_spatial_dispatch.rs','crates/client/src/main.rs','logs/grass-spatial-dispatch-tests.log','logs/grass-spatial-dispatch-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=193,client_build_passed=True,native_registered_spatial_dispatch_cases=2328,native_addresses=proof['native_addresses'],registered_spatial_dispatch_ported=True,downstream_spatial_index_qualified=False,live_grass_mask_integrated=False,findings=['Complete71A5B0 dispatcher executes2328cases from192previousAABBs plusnegativezero/NaN examples,3cachedcenters,nodeabsent/present andparentabsent/present. Actual node/spatial pointers supplied.','Rustmatchescenterfieldsbitwise and exactorderedcalls. Recenter and conditionalparentreindex occuronlyonchanged/unorderedcenter; signedzero equality preservescachedbits. Extents update alwaysoccurs forpresentnode. Lowerextents are signbit-flipped nativehalfspans, retaininginverted/degeneratevalues.','AABBState adapter connects previously qualified numericresult tooptional registered spatial dispatcher; normal actor registry remains unconnected.'],limits=proof['limits']+['Fullregistered71A5B0 dispatch qualification doesnotqualify95F370/95FF10/95F060 internal algorithms; recorded boundaries remain explicit.','Original model/provider/getter andactorregistration/camera inputs remainopen. No normal-match/GPU capture. All24domains incomplete.'],next_actions=['Qualify95F370 centerbounds recalculation,95F060 local extents and95FF10 spatial reindex; recover actualregistration/lifecycle.','Recover modelbounds provider andcamera/viewport; connect actualactorcollector tonormalmask/WALL render andinspectMap10match.','Continue full24domainplan, allchampionkits, sixclientvictory/results and delivery.'],files_sha256={p:sha(p) for p in paths})
bounds=load('data/4.20/grass_spatial_bounds_contract.json');assert bounds['passed'] and len(bounds['cases'])==20 and not bounds['runtime_adapters']
receipt['native_spatial_bounds_cases']=20
receipt['native_spatial_bounds_addresses']=bounds['native_addresses']
receipt['native_spatial_bounds_rust_ported']=False
receipt['findings'].append('Complete95F370 plus originalinternalCRT execute20finitecenter/localbounds cases withoutadapters. Negative/inverted/tinyfractional/largevalues produce originalintegerX/Zbounds. Rustportpending; otherindexmethods remainopen.')
receipt['limits'].extend(bounds['limits'])
receipt['files_sha256']['data/4.20/grass_spatial_bounds_contract.json']=sha('data/4.20/grass_spatial_bounds_contract.json')
receipt['next_actions'][0]='Port95F370 against20originalfinitecases andextendboundaryqualification; qualify95F060/95FF10 andactualregistration/lifecycle.'
save('docs/grass_spatial_dispatch_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('192 tests','193 tests').replace('192tests','193tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier les algorithmes internes de l’index spatial95F370/95F060/95FF10, registration, fournisseur des bornes et caméra ; intégrer acteurs/collecteur/masque/WALL au rendu normal. Dispatch spatial71A5B0 porté, comparé à2328cas et relié explicitement au résultat AABB. 193tests et compilation réussis. Producteurs, index interne et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_spatial_dispatch_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=193;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=193,current_test_receipt='docs/grass_spatial_dispatch_progress.json',current_build_receipt='docs/grass_spatial_dispatch_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_registered_spatial_dispatch_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Dispatch spatial avec acteur inscrit</h2><p>2328cas natifs ;193tests et compilation réussis. Appels internes de l’index, producteurs du modèle/caméra et intégration au jeu restent ouverts.</p><a href="grass_spatial_dispatch_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['record_grass_spatial_dispatch_progress.py','probe_native_grass_spatial_bounds.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=193,registered_dispatch_cases=2328,downstream_qualified=False,complete=False)))
