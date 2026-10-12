from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '74 passed; 0 failed' in (r/'logs/fow-postprocess-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-postprocess-build.log').read_text(encoding='utf-8-sig')
gpu=load('logs/fow-postprocess-gpu.json'); assert len(gpu['cases'])==44
assert all(c['maximum_rgb_error']<=0.002 for c in gpu['cases'])
native=load('data/4.20/fow_gaussian_contract.json'); assert len(native['cases'])==20
files=['data/4.20/fow_gaussian_contract.json','crates/client/src/fow_postprocess.rs','assets/shaders/fow_postprocess.wgsl','crates/client/examples/fow_gpu_probe.rs','logs/fow-postprocess-tests.log','logs/fow-postprocess-build.log','logs/fow-postprocess-gpu.log','logs/fow-postprocess-gpu.json','target/debug/openleague-client.exe','target/debug/examples/fow_gpu_probe.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':74,'client_build_passed':True,'native_gaussian_cases':20,'gpu_diagnostic_cases':44,'pixels_per_case':64,'gpu_adapter':gpu['adapter'],'gpu_backend':gpu['backend'],'gpu_maximum_rgb_error':max(c['maximum_rgb_error'] for c in gpu['cases']),'gpu_tolerance':0.002,'diagnostic_gpu_verified':True,'live_fow_gpu_bound':False,'current_client_graphical_rerun':False,'findings':['Ported original Fade and FastSeparableGaussianBlur formulas to CPU reference and WGSL compute.','Native Gaussian constructor arithmetic executed for 20 supplied sigma/upscale cases; non-finite cases are explicitly unsupported.','Actual Vulkan GPU readback verifies 44 isolated cases over impulse, step, byte pattern and constant textures; horizontal and vertical blur and fade branches included.'],'limits':['GPU input textures are diagnostic fixtures, not live team visibility.','Original D3D shader execution and original render-target quantization are not compared.','Native 4x lookup-table upscaler, fade timing/parameters, world extent/config selection, stencil generation and live renderer integration remain open.','74 client tests and rebuilt binary do not establish a complete champion, map, or game.'],'next_actions':['Recover and port original native 4x upscaler 6B5080 and its lookup table.','Qualify source stencil generation and Map10 extent/config providers.','Bind actual team visibility textures, fade/blur stages and projected overlay to normal rendering; qualify gameplay and current client captures.'],'files_sha256':{p:sha(p) for p in files}}
save('docs/projected_fow_postprocess_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'); b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name; shutil.copy2(r/p,b/name); d=load(p); d['updated_utc']=now; d['complete']=False; d['projected_fow_postprocess_progress']=receipt
 if name=='resume_checkpoint.json':
  d['saved_utc']=now; d['state']='active'; d['last_verified']['client_tests']=74; d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=74,current_build_receipt='docs/projected_fow_postprocess_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 save(p,d)
p=r/'docs/completion_plan.html'; s=p.read_text(encoding='utf-8'); s=s.replace('</body>','<section><h2>Brouillard — fondu et flou</h2><p>74 tests client et compilation réussis. 20 cas de calcul natif du noyau ; 44 cas de pixels vérifiés sur RTX 3060 / Vulkan, erreur maximale 0,00045. Diagnostic isolé : visibilité réelle, suréchantillonnage natif, paramètres de partie et intégration restent ouverts. Aucun domaine entièrement terminé.</p><a href="projected_fow_postprocess_progress.json">Preuves, exécutables et limites</a></section></body>'); p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_postprocess.py'),r/'tools/record_fow_postprocess.py')
print(json.dumps({k:receipt[k] for k in ['client_tests_passed','client_build_passed','gpu_diagnostic_cases','gpu_maximum_rgb_error','live_fow_gpu_bound']}))
