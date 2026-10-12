from pathlib import Path
import sys,json,datetime,hashlib,shutil,html
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '175 passed; 0 failed' in (r/'logs/grass-sampler-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-sampler-build.log').read_text(encoding='utf-8-sig')
assert 'Grass mask GPU524288pixels 16384overlap pixels verified' in (r/'logs/grass-mask-native-sampler-gpu.log').read_text(encoding='utf-8-sig')
gpu=load('logs/grass-mask-gpu.json');assert gpu['passed'] and gpu['native_reset_d3d_filters']==[1,1,0]
defaults=load('data/4.20/sampler_defaults_contract.json');matrix=load('data/4.20/grass_screen_matrix_contract.json')
assert defaults['passed'] and matrix['passed'] and len(matrix['cases'])==196
raw=(r/'logs/grass-mask-gpu.rgba').read_bytes();assert len(raw)==2097152
im=Image.frombytes('RGBA',(1024,512),raw,'raw','BGRA');im.save(r/'logs/grass-mask-native-sampler.png')
a=im.getchannel('A');Image.merge('RGB',(a,a,a)).save(r/'logs/grass-mask-native-sampler-alpha.png')
receipt=dict(updated_utc=now,complete=False,client_tests_passed=175,client_build_passed=True,live_grass_mask_integrated=False,gpu=gpu,native_reset_sampler_cases=3,native_reset_sampler_submissions=384,native_reset_sampler_addresses=defaults['original_instruction_addresses'],native_screen_matrix_cases=196,native_screen_matrix_addresses=matrix['original_instruction_addresses'],native_screen_matrix_ported=False,visual_inspection_required=True,findings=['Original reset tail initializes all16stages and8keys regardlessofcache: MAG/MINpoint1,MIPnone0. Quad changes U/V addressing only in qualified call fixture; subsequent scene inheritance remains open.','Rust shared sampler requires explicit inheritedfilters[1,1,0]; rejects unqualified alternatives. BaseLOD0prevents mipselection; nearestandquadclamp shared byactualVulkanGPUprobe.','Original980DA0screenmatrix producer executes196dimension/APIcases, no consumer adapters; API0 differsfromAPI1/2includingdepthscaleandYinverseheightoffset; API3preservesmatrix. NoRustmatrixportyet.'],limits=['Reset defaults do not establish later grass draw inherited filters; inspect subsequent shader/state changes before normalintegration.','Screenmatrixfixture doesnotqualifytargetpushviewport, constantupload, transpose/clipbridge orvertexbuffers. x87CW037F explicit.','No normalmatchcapture/currentclient visualacceptance; liveactors/camera/WALL_OF_GRASS stillpending.','All24domains remainopen; no fullsixclientvictory/results.'],semantic_sources=['https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dtexturefiltertype','https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dsamplerstatetype'],next_actions=['Port native980DA0screenmatrix and qualify targetpush/restore viewport, upload and nativequadbuffers; preserve APIflag differences.','Qualify actualgrassdraw inheritedfilters and actorAABB/camera producers; integrate maskandWALL_OF_GRASS into normalMap10render and inspectpixels.','Continue complete24domainplan, sixclientvictory/results and remainingkits/services/delivery.'])
paths=['crates/client/src/grass_pass_state.rs','crates/client/examples/grass_mask_gpu_probe.rs','data/4.20/sampler_defaults_contract.json','data/4.20/grass_screen_matrix_contract.json','logs/grass-sampler-tests.log','logs/grass-sampler-build.log','logs/grass-mask-native-sampler-gpu.log','logs/grass-mask-gpu.json','logs/grass-mask-gpu.rgba','logs/grass-mask-native-sampler.png','logs/grass-mask-native-sampler-alpha.png','target/debug/openleague-client.exe','target/debug/examples/grass_mask_gpu_probe.exe']
receipt['files_sha256']={p:sha(p) for p in paths};save('docs/grass_sampler_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('174 tests','175 tests').replace('174tests','175tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : porter la matrice écran native vérifiée sur196cas ; qualifier viewport, buffers, filtrage hérité et caméra/acteurs, puis connecter WALL_OF_GRASS au rendu normal. Filtres natifs à la réinitialisation vérifiés sur384soumissions et partagés avec le contrôle GPU. 175tests et compilation réussis ; 524288pixels GPU passent. Masque non connecté à la partie. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
shutil.copy2(r/'docs/goal_objective_current_request.txt','E:/mapslol3v3/nouveau-goal-openleague-a-jour.txt')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_sampler_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=175;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=175,current_test_receipt='docs/grass_sampler_progress.json',current_build_receipt='docs/grass_sampler_progress.json',current_grass_gpu_receipt='docs/grass_sampler_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_sampler_reset_submissions=384,native_screen_matrix_cases=196,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Filtrage natif et matrice écran</h2><p>384réglages natifs contrôlés ; filtres partagés avec le contrôle GPU. 175tests client et compilation réussis, 524288pixels vérifiés. Matrice native exécutée sur196cas, port Rust restant. Filtrage hérité, viewport, buffers et branchement aux acteurs restent ouverts.</p><a href="grass_sampler_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['probe_native_sampler_defaults.py','probe_native_grass_screen_matrix.py','integrate_grass_sampler.py','record_grass_sampler_progress.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=175,gpu_pixels=524288,native_screen_matrix_cases=196,live_integrated=False,complete=False)))
