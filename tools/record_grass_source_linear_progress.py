from pathlib import Path
import sys,json,datetime,hashlib,shutil,html
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '182 passed; 0 failed' in (r/'logs/grass-source-collector-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-source-collector-build.log').read_text(encoding='utf-8-sig')
profiles={name:load('logs/grass-mask-'+name+'.json') for name in ['point','linear']}
paths=[]
for name,gpu in profiles.items():
 assert gpu['passed'] and gpu['pixels_checked']==524288 and gpu['filter_profile']==name
 assert gpu['max_channel_error']==(1 if name=='linear' else 0)
 assert gpu['inherited_d3d_filters']==([2,2,0] if name=='linear' else [1,1,0])
 prefix='logs/grass-mask-'+name;raw=(r/(prefix+'.rgba')).read_bytes();assert len(raw)==2097152
 im=Image.frombytes('RGBA',(1024,512),raw,'raw','BGRA');im.save(r/(prefix+'.png'))
 a=im.getchannel('A');Image.merge('RGB',(a,a,a)).save(r/(prefix+'-alpha.png'))
 paths.extend([prefix+extension for extension in ['.json','.rgba','.png','-alpha.png']]);paths.append(prefix+'-gpu.log')
order=load('data/4.20/grass_source_order_contract.json');assert order['passed'] and len(order['cases'])==8
receipt=dict(updated_utc=now,complete=False,client_tests_passed=182,client_build_passed=True,live_grass_mask_integrated=False,gpu_profiles=profiles,linear_gpu_profile_qualified=[2,2,0],original_d3d_pixels_compared=False,native_actor_gates_cases=512,native_source_order_cases=8,native_source_order_addresses=order['original_instruction_addresses'],native_source_collector_ported=True,actual_actor_eligibility_producer_qualified=False,visual_inspection_required=True,findings=['ActualVulkanoriginalbrush/inheritedlinear-no-mip profile[2,2,0]compared524288pixels toindependentbilineartexelcenter/clampreference; max8bitchannelerror1predeclared. Includesup/downsampling,fractionalsourceUV,overlapandpreservedclear. Pointprofile524288pixels exact.', 'Original73AD90collector ordering8fixtures preserve actororder,duplicates,sentinel/invertedrectangle. Raweligibility512cases ported; explicitAABB/gates/projection supplied, nosemanticactorflagsinvented.', 'Rustcollectorclears previousoutput, expandswithnative0.3margin via suppliedprojectioncallback andpreservesallreturnedrectangles. Existingnativequad/constants/viewport/filterports retained.'],limits=['LinearGPU qualification restrictedtoactualbrush, clamp, baseLOD0andVulkanRTX3060withpredeclared1byteUNORMtolerance; mipchains/aniso/othertextures andoriginalD3Dframebuffercomparison absent.', 'Shader/setup andcompiledprogramflush upstreaminheritedfilterproducer remainsopen.', 'Nativeactorregistry, eligibilitysemantic/AABB andactualcamera/viewportproviders notqualified. Collectornotyetconnectedtoliveactors/WALL_OF_GRASSnormalrenderer.', 'Currentnormalclienthasno newmatchcapture; all24domains andsixclientvictory/results remainunfinished.'],next_actions=['Qualifyactualactorregistry/eligibility/AABB and camera/viewportproviders; useportedcollector/projectiontofeedlive maskwithoutsyntheticgates.', 'Establishactualmaskdrawinheritedfilters upstream; connectmaskandWALL_OF_GRASS tonormalMap10render, inspectactualmatchpixels.', 'Continuecomplete24domainplan andsixclientvictory/results,remainingkits/services/delivery.'])
paths.extend(['crates/client/src/grass_sources.rs','crates/client/src/main.rs','crates/client/examples/grass_mask_gpu_probe.rs','data/4.20/grass_source_order_contract.json','data/4.20/grass_mask_sources_contract.json','logs/grass-source-collector-tests.log','logs/grass-source-collector-build.log','target/debug/openleague-client.exe','target/debug/examples/grass_mask_gpu_probe.exe'])
receipt['files_sha256']={p:sha(p) for p in paths};save('docs/grass_source_linear_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('180 tests','182 tests').replace('180tests','182tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier registre, éligibilité et AABB réels des acteurs et caméra/viewport ; brancher collecteur, masque et WALL_OF_GRASS au rendu normal. Collecteur porté :512cas de filtres et8listes natives. GPU point524288pixels exacts ; linéaire524288pixels avec tolérance1/255, sans mipmaps. 182tests et compilation réussis. Producteurs et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
shutil.copy2(r/'docs/goal_objective_current_request.txt','E:/mapslol3v3/nouveau-goal-openleague-a-jour.txt')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_source_linear_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=182;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=182,current_test_receipt='docs/grass_source_linear_progress.json',current_build_receipt='docs/grass_source_linear_progress.json',current_grass_gpu_receipt='docs/grass_source_linear_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_grass_source_collector_ported=True,linear_grass_gpu_qualified=True,linear_grass_gpu_profile=[2,2,0],linear_grass_gpu_tolerance=1,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Collecteur natif et filtrage GPU linéaire</h2><p>Collecteur porté :512cas de flags et8listes natives. GPU point524288pixels exacts ; linéaire524288pixels avec tolérance1/255, baseLOD0. 182tests client et compilation réussis. Producteurs des acteurs, caméra et branchement à la partie restent ouverts.</p><a href="grass_source_linear_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['extend_grass_linear_probe.py','probe_native_grass_source_order.py','integrate_grass_source_collector.py','record_grass_source_linear_progress.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=182,gpu_profiles=list(profiles),native_collector_ported=True,live_integrated=False,complete=False)))
