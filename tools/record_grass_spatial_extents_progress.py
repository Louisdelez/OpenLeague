from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert '196 passed; 0 failed' in (r/'logs/grass-spatial-extents-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-spatial-extents-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_spatial_extents_hardware_contract.json');assert proof['passed'] and len(proof['cases'])==288
paths=['data/4.20/grass_spatial_extents_hardware_contract.json','data/4.20/grass_spatial_extents_precise_contract.json','crates/client/src/grass_spatial_extents.rs','crates/client/src/main.rs','logs/grass-spatial-extents-tests.log','logs/grass-spatial-extents-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=196,client_build_passed=True,native_extents_hardware_cases=288,native_addresses=proof['native_addresses'],finite_local_extents_radius_ported=True,parent_reindex_qualified=False,live_grass_mask_integrated=False,findings=['Native95F060/95F2C0 and actual95F370/CRT execute288cases plusrepeats, includingasymmetricbounds. Actualsame-PC RSQRTSS estimates supply original5FA7C0 refinement, not exactsqrt replacement.','Rustmatcheslocal/radiusbits,integerbounds andorderedbounds/parentcalls forfirst/repeatedupdates. Parentalgorithm remainsadapted. Originalunrounded sum comparedtooldf32radius beforestore; repeatedasymmetricupdates canrecalculateunchangedroundedradius.','Portuses actualx86_64 RSQRTSS intrinsic, originalf32 refinementorder and widened sum of returnedf32sqrt androundedhalfdiagonal. SameCPU estimates explicitly checked.'],limits=proof['limits']+['Finite/defaultcontrol/sameCPU profile only; broader x87sum rounding, nonfinite, otherarchitectures/CPUs remainunqualified and unsupported paths returnexpliciterrors.','PortupdatesIndexedNode butnormalactorregistry/fullspatialeventchain notyetconnected. Parentreindex, model/camera andlive grassrender remainopen. All24domains unfinished.'],next_actions=['Connect localextent/radius port tofullspatialchain; qualify original95FF10 parentreindex andregistration/lifecycle.','Recover modelbounds/camera/profile producers andresolve nonfinitepaths; actualactors/collectormask/WALL render andMap10match inspection.','Continue complete24domainplan, allchampionkits, sixclientvictory/results anddelivery.'],files_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths})
save('docs/grass_spatial_extents_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('195 tests','196 tests').replace('195tests','196tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : relier dimensions locales/rayon à la chaîne spatiale complète ; qualifier parent95FF10 et registration, fournisseur modèle/caméra et profils/non-finis ; acteurs/masque/WALL au rendu normal. Dimensions95F060/95F2C0 portées avec RSQRTSS réel,288cas matériels et répétitions comparés. 196tests et compilation réussis. Parent, producteurs et branchement à la partie ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_spatial_extents_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=' '.join(receipt['next_actions']));d['last_verified']['client_tests']=196
 else:d['current_evidence'].update(client_tests_passed=196,current_test_receipt='docs/grass_spatial_extents_progress.json',current_build_receipt='docs/grass_spatial_extents_progress.json',current_client_sha256=receipt['files_sha256']['target/debug/openleague-client.exe'],native_spatial_local_extents_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Dimensions locales et rayon avec RSQRTSS</h2><p>288cas matériels natifs et répétitions ;196tests et compilation réussis. Parent, chaîne complète et producteurs/rendu restent ouverts.</p><a href="grass_spatial_extents_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_grass_spatial_extents_progress.py',r/'tools/record_grass_spatial_extents_progress.py')
print(json.dumps(dict(client_tests=196,hardware_cases=288,complete=False)))
