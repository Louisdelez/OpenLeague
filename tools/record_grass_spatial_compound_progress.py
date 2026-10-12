from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '195 passed; 0 failed' in (r/'logs/grass-spatial-compound-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-spatial-compound-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_spatial_compound_contract.json');assert proof['passed'] and len(proof['cases'])==4064
paths=['data/4.20/grass_spatial_compound_contract.json','crates/client/src/grass_spatial_dispatch.rs','crates/client/src/grass_spatial_bounds.rs','logs/grass-spatial-compound-tests.log','logs/grass-spatial-compound-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=195,client_build_passed=True,native_spatial_compound_cases=4064,native_addresses=proof['native_addresses'],finite_bound_calculation_connected_to_dispatch=True,downstream_parent_extents_qualified=False,live_grass_mask_integrated=False,findings=['Original71A5B0 ->actual95F370/originalCRT executes4064finite compoundcases acrossdeduplicatedAABB/cachedcenter/presentnode/parentstates,2localbounds and2integerprofiles. Only95FF10/95F060boundaries adapted.','Rustindexed-nodeadapter shares existingdispatcher andfinitebounds calculation; matches centerbitwrites, integerbounds andexactcallorder, including boundvalues visible toparent andextent callbacks afterrecenter. Unchangedcenterspreserveexistingintegerbounds; absentnode emitsnocalls.','Previously qualifiedAABBState canfeedindexeddispatch via explicitadapter. Rawactorregistry, originalboundprovider/profileproducer andlive renderer remainunconnected.'],limits=proof['limits']+['Rustprevalidates unsupported recenter arithmetic before node mutation; nonfiniteCRT behavior remainsunqualified and returns expliciterror.','Original95FF10parentreindex/95F060localextents algorithms, registration/model/camera producers andnormalmatch integration remainopen. All24domains incomplete; no newnormalGPUcapture.'],next_actions=['Qualify95F060 localextents update and95FF10 parentreindex, then actualregistration/lifecycle; useexistingcompounddispatcher/bounds.','Resolve nonfiniteCRT/profileproducers, modelbounds/camera andnormalactorcollectormask/WALL rendering; inspectMap10match.','Continue full24domainplan, allchampionkits, sixclientvictory/results and delivery.'],files_sha256={p:sha(p) for p in paths})
extents=load('data/4.20/grass_spatial_extents_contract.json');assert extents['passed'] and len(extents['cases'])==192 and all('repeat' in c for c in extents['cases'])
receipt['native_local_extents_cases']=192
receipt['native_local_extents_addresses']=extents['native_addresses']
receipt['native_local_extents_rust_ported']=False
receipt['findings'].append('Original95F060 ->95F2C0/95F370 plusoriginalsqrt/CRT executes192finiteextent/radius cases andunchangedrepeatedcalls. Onlyparent95FF10 adapted. Numericandcallorder fixtures saved fornextRustport.')
receipt['limits'].extend(extents['limits'])
receipt['files_sha256']['data/4.20/grass_spatial_extents_contract.json']=sha('data/4.20/grass_spatial_extents_contract.json')
receipt['next_actions'][0]='Port95F060/95F2C0 against192originalcases andrepeatedupdates; qualify95FF10parentreindex andactualregistration/lifecycle.'
save('docs/grass_spatial_compound_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('194 tests','195 tests').replace('194tests','195tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier mise à jour des extents95F060 et reclassement parent95FF10, registration/profils CPU, fournisseur modèle/caméra ; acteurs/masque/WALL au rendu normal. Calcul95F370 raccordé au dispatch71A5B0 et comparé à4064cas natifs composés, dont état observé par les appels suivants. 195tests et compilation réussis. Algorithmes restants, producteurs et branchement à la partie ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_spatial_compound_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=195;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=195,current_test_receipt='docs/grass_spatial_compound_progress.json',current_build_receipt='docs/grass_spatial_compound_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_spatial_bounds_connected_to_dispatch=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Chaîne spatiale et bornes raccordées</h2><p>4064cas natifs composés ;195tests et compilation réussis. Parent/extents, registration, modèle/caméra et intégration au jeu restent ouverts.</p><a href="grass_spatial_compound_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['record_grass_spatial_compound_progress.py','probe_native_grass_spatial_extents.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=195,spatial_compound_cases=4064,parent_extents_qualified=False,complete=False)))
