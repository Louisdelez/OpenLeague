from pathlib import Path
import sys,json,datetime,hashlib,shutil,html
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '176 passed; 0 failed' in (r/'logs/grass-screen-matrix-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-screen-matrix-build.log').read_text(encoding='utf-8-sig')
assert 'Grass mask GPU524288pixels 16384overlap pixels verified' in (r/'logs/grass-mask-native-matrix-gpu.log').read_text(encoding='utf-8-sig')
gpu=load('logs/grass-mask-gpu.json');assert gpu['passed'] and gpu['native_screen_matrix_api']==0
viewport=load('data/4.20/grass_target_viewport_contract.json');assert viewport['passed'] and len(viewport['cases'])==180
raw=(r/'logs/grass-mask-gpu.rgba').read_bytes();assert len(raw)==2097152
im=Image.frombytes('RGBA',(1024,512),raw,'raw','BGRA');im.save(r/'logs/grass-mask-native-matrix.png')
a=im.getchannel('A');Image.merge('RGB',(a,a,a)).save(r/'logs/grass-mask-native-matrix-alpha.png')
receipt=dict(updated_utc=now,complete=False,client_tests_passed=176,client_build_passed=True,live_grass_mask_integrated=False,gpu=gpu,native_screen_matrix_ported=True,native_screen_matrix_cases=196,native_target_viewport_cases=180,native_target_viewport_addresses=viewport['original_instruction_addresses'],native_target_viewport_submissions=45,visual_inspection_required=True,findings=['Native980DA0matrix port matches196bitfixtures including unsigned dimensions, zeroIEEE outputs and unsupportedAPIpreservation. API1/2useinverseheight forX/Ytranslations; valuesnot silentlynormalized toAPI0.','GPUuses sharednativeAPI0matrix producer ratherthanmanualmatrix; currentCPU/GPU expectedpixels524288pass. APIflagselection/clipbridge remains explicit.','Original9888702Dtargetpush reaches980DA0->982AC0->9C3820->9C74C0->D3DSetViewport. 180cases/45viewportsubmissions prove texturepresent+slot0updatesdimensions/matrix/viewport0,0,w,h,0,1; missingtexture/slot1preserveexistingstate.'],limits=['x87CW037F supplied, fullhistoricalFPUinitialization notqualified. Nativezeros produce infinities; notvalidGPUdimensionacceptance.','2Dtarget binding/depthsurface virtualC8/D0are recordingadapters. Cubemaps/restore and actualsurfacebind remainopen.','GPUusesnativeAPI0matrix with explicitVulkanbridge; nativequadvertex/indexbuffer, shaderconstantupload and filteredsceneinheritance remainopen.','Liveactors/camera/WALL_OF_GRASSintegration and normalmatchvisualacceptance stillpending. All24domains remainunfinished.'],next_actions=['Port target activation/restore viewport state and qualify nativequadvertex/indexbuffers and shaderconstantupload.','Qualify inheritedgrassfilters and actualactorAABB/cameraproviders; connectmaskandWALL_OF_GRASS into normalMap10and capturepixels.','Continue complete24domainplan and sixclientvictory/results; remainingchampionkits/services/delivery remainopen.'])
paths=['crates/client/src/grass_screen_matrix.rs','crates/client/src/grass_pass_state.rs','crates/client/src/main.rs','crates/client/examples/grass_mask_gpu_probe.rs','assets/shaders/native_grass_mask.wgsl','data/4.20/grass_screen_matrix_contract.json','data/4.20/grass_target_viewport_contract.json','logs/grass-screen-matrix-tests.log','logs/grass-screen-matrix-build.log','logs/grass-mask-native-matrix-gpu.log','logs/grass-mask-gpu.json','logs/grass-mask-gpu.rgba','logs/grass-mask-native-matrix.png','logs/grass-mask-native-matrix-alpha.png','target/debug/openleague-client.exe','target/debug/examples/grass_mask_gpu_probe.exe']
receipt['files_sha256']={p:sha(p) for p in paths};save('docs/grass_matrix_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('175 tests','176 tests').replace('175tests','176tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : porter activation/restauration du viewport, qualifier buffers et constantes natifs, filtrage hérité et caméra/acteurs, puis connecter WALL_OF_GRASS au rendu normal. Matrice écran portée et vérifiée sur196cas ; activation native2Dqualifiée sur180cas. 176tests et compilation réussis ; 524288pixels GPU passent avec la matrice nativeAPI0. Masque non connecté à la partie. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
shutil.copy2(r/'docs/goal_objective_current_request.txt','E:/mapslol3v3/nouveau-goal-openleague-a-jour.txt')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_matrix_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=176;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=176,current_test_receipt='docs/grass_matrix_progress.json',current_build_receipt='docs/grass_matrix_progress.json',current_grass_gpu_receipt='docs/grass_matrix_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_screen_matrix_ported=True,native_target_viewport_cases=180,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Matrice écran native portée</h2><p>196cas binaires natifs correspondent au port Rust. Activation viewport2Dqualifiée sur180cas. 176tests client, compilation et524288pixels GPU passent avec la matrice nativeAPI0. Buffers, restauration, acteurs et branchement au jeu restent ouverts.</p><a href="grass_matrix_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['integrate_grass_screen_matrix.py','probe_native_grass_target_viewport.py','record_grass_matrix_progress.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=176,gpu_pixels=524288,native_target_viewport_cases=180,live_integrated=False,complete=False)))
