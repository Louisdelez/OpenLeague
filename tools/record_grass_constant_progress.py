from pathlib import Path
import sys,json,datetime,hashlib,shutil,html
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '179 passed; 0 failed' in (r/'logs/grass-constant-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-constant-build.log').read_text(encoding='utf-8-sig')
assert 'Grass mask GPU524288pixels 16384overlap pixels verified' in (r/'logs/grass-mask-native-constant-gpu.log').read_text(encoding='utf-8-sig')
gpu=load('logs/grass-mask-gpu.json');assert gpu['passed'] and gpu['native_constant_bytes']==112
constant=load('data/4.20/grass_constant_upload_contract.json');declaration=load('data/4.20/grass_declaration_api_contract.json')
assert constant['passed'] and declaration['passed']
raw=(r/'logs/grass-mask-gpu.rgba').read_bytes();assert len(raw)==2097152
im=Image.frombytes('RGBA',(1024,512),raw,'raw','BGRA');im.save(r/'logs/grass-mask-native-constant.png')
a=im.getchannel('A');Image.merge('RGB',(a,a,a)).save(r/'logs/grass-mask-native-constant-alpha.png')
receipt=dict(updated_utc=now,complete=False,client_tests_passed=179,client_build_passed=True,live_grass_mask_integrated=False,gpu=gpu,native_constant_cases=len(constant['cases']),native_constant_api_submissions=1152,native_sampler_api_submissions=1152,native_constant_addresses=constant['original_instruction_addresses'],native_declaration_api_cases=len(declaration['cases']),native_declaration_api_addresses=declaration['original_instruction_addresses'],native_constant_encoder_shared=True,visual_inspection_required=True,findings=['Original986760/986AD0->9C30F0->9C63C0constantupload executes288cases: c0..3matrix,c4destination,c5UV,c6color. 1152actualD3Dconstantboundary submissions recorded;112byteRustencoder sharedwithGPU.', 'Actualsamplerdispatch1152calls changesU/Vclamp3thenwrap1; inheritedMAG/MIN/MIPcache[1,1,0]and[2,2,2]preserved in scope. Thus resetpointfiltersareconditional, not universalgrassdrawfilters.', 'Originaldeclarationconversionincludingterminator reachesD3DCreateVertexDeclarationAPI3cases. Positionfloat3offset0,packedcoloroffset12,UVfloat2offset16 andD3DUNUSEDterminator17verified.'],limits=['Pixelshaderselector/texturebinding producers and otherdriverstate/buffer/drawcallbacks are recordingadapters in compoundconstantprobe; completegrassscene inheritedfilter state remainsopen.', 'CreateVertexDeclarationAPIreturns suppliedS_OK/handle; stopsbeforeCOMwrapperownership. OriginalGPUdeclarationacceptance notclaimed.', 'NativeAPI0clipconvention explicitlyselected inVulkanprobe; actualcamera/actorAABBproducers and WALL_OF_GRASSnormalintegration remainopen.', 'Currentnormalclient has no newmatchcapture; no sixclientvictory/results. All24domains unfinished.'],next_actions=['Qualify actualpixelshader/texturebinding samplerchanges and resolve inheritedfilter state atmaskdraw.', 'Resolve actualactorAABB/eligibility and camera/viewportproviders; connectmaskandWALL_OF_GRASS into normalMap10render and inspectactualmatchpixels.', 'Continue all24domains and sixclientvictory/results, remainingchampionkits/services/delivery.'])
paths=['crates/client/src/grass_constants.rs','crates/client/src/main.rs','crates/client/examples/grass_mask_gpu_probe.rs','assets/shaders/native_grass_mask.wgsl','data/4.20/grass_constant_upload_contract.json','data/4.20/grass_declaration_api_contract.json','logs/grass-constant-tests.log','logs/grass-constant-build.log','logs/grass-mask-native-constant-gpu.log','logs/grass-mask-gpu.json','logs/grass-mask-gpu.rgba','logs/grass-mask-native-constant.png','logs/grass-mask-native-constant-alpha.png','target/debug/openleague-client.exe','target/debug/examples/grass_mask_gpu_probe.exe']
receipt['files_sha256']={p:sha(p) for p in paths};save('docs/grass_constant_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('178 tests','179 tests').replace('178tests','179tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier filtrage hérité via sélection shader/texture ; résoudre caméra, AABB et éligibilité des acteurs, puis connecter WALL_OF_GRASS au rendu normal. Constantes shader portées et vérifiées sur288cas/1152soumissions ; déclaration complète vérifiée jusqu’à API sur3cas. 179tests et compilation réussis ; 524288pixels GPU passent. Masque non connecté à la partie. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
shutil.copy2(r/'docs/goal_objective_current_request.txt','E:/mapslol3v3/nouveau-goal-openleague-a-jour.txt')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_constant_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=179;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=179,current_test_receipt='docs/grass_constant_progress.json',current_build_receipt='docs/grass_constant_progress.json',current_grass_gpu_receipt='docs/grass_constant_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_constant_encoder_shared=True,native_grass_constant_api_submissions=1152,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Constantes du shader natives</h2><p>288cas et1152soumissions vérifient les constantes c0àc6, partagées avec le contrôle GPU. Déclaration complète vérifiée jusqu’à API. Les filtres sont hérités ; état final à qualifier. 179tests, compilation et524288pixels GPU réussis. Caméra, acteurs et branchement au jeu restent ouverts.</p><a href="grass_constant_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['probe_native_grass_constant_upload.py','probe_native_grass_declaration_api.py','integrate_grass_constants.py','record_grass_constant_progress.py','probe_native_grass_buffers.py','probe_native_grass_restore_viewport.py','probe_native_grass_indexed_draw.py','probe_native_grass_declaration.py','integrate_grass_viewport_buffers.py','record_grass_viewport_buffer_progress.py']:
 shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=179,gpu_pixels=524288,constant_submissions=1152,live_integrated=False,complete=False)))
