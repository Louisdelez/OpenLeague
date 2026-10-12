from pathlib import Path
import json,hashlib,datetime,shutil,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import numpy as np
from PIL import Image
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
tests=(r/'logs/native-gamma-client-tests.log').read_text(encoding='utf-8-sig');assert '239 passed; 0 failed' in tests
build=(r/'logs/native-gamma-build.log').read_text(encoding='utf-8-sig');assert 'Finished `dev` profile' in build
capture=load('docs/chaos_base_native_gamma_capture.json')
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();assert binary==capture['client_sha256']
native=load('data/4.20/native_map10_gamma_contract.json')
expected=[native['lut_u8'][min(255,int(x/255*256))] for x in [34,62,84]]
im=np.asarray(Image.open(capture['capture']).convert('RGB'));crop=im[80:480,900:1220]
matches=int(np.all(crop==expected,axis=2).sum())
prior=load('docs/chaos_base_native_fog_capture.json');prior_im=np.asarray(Image.open(prior['capture']).convert('RGB'))
mask=np.all(prior_im==[34,62,84],axis=2);matched=int(np.all(im[mask]==expected,axis=1).sum())
capture.update(visual_inspected=True,native_clear_before_gamma=[34,62,84],native_clear_expected_after_gamma=expected,
 native_clear_matches_in_crop=matches,crop=[900,80,1220,480],prior_clear_pixels=int(mask.sum()),prior_clear_pixels_matching_gamma=matched,
 clear_regions_remaining_open=True)
save('docs/chaos_base_native_gamma_capture.json',capture)
receipt=dict(updated_utc=now,complete=False,product_changed=True,native_gamma_runtime_integrated=True,
 client_tests_passed=239,client_sha256=binary,gamma_sampler_cases=10,native_lut_samples=256,native_argb_samples=256,
 capture='docs/chaos_base_native_gamma_capture.json',capture_inspected=True,clear_gamma_expected=expected,clear_gamma_matches_in_crop=matches,
 chaos_base_defect_fixed=False,pending_jobs=[],
 limits=['Native code sampler wrappers qualify point/clamp. Native default enabled read from original PE; complete user-option dispatcher not qualified.',
 'Bevy postprocess placed before UI per installed source schedule. Exact original HUD/gamma pass order and whole original framebuffer equivalence remain open.',
 'Native table bytes embedded in WGSL, channel-space conversion bridges Bevy sRGB attachments; original D3D raster not executed.',
 'Native color override/death fade, user brightness/gamma settings and runtime LUT revisions not integrated.',
 'Fixed-camera screenshot under normal local server. Not an ordinary completed six-graphical-client match.',
 'Prior Nexus/tower/endgame proofs belong to old binaries and were not rerun.'])
action='Qualifier la couche native de brouillard en espace écran et la composition du fond : la passe gamma est intégrée et capturée mais ne remplit pas les régions sans géométrie. Vérifier également ordre natif HUD/gamma, surcharges et réglages. Puis audio/sbires de fin de partie, reconnexion/Continue/launcher et partie ordinaire à six clients graphiques ; poursuivre les24domaines.'
receipt['next_action']=action;save('docs/native_gamma_runtime_progress.json',receipt)
archive=r/'docs/plan_history'/('native-gamma-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,archive/name);d=load(path);d.update(updated_utc=now,complete=False,native_gamma_runtime_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
  d['last_verified'].update(client_tests=239,current_client_sha256=binary,native_gamma_runtime_integrated=True)
 else:d['current_evidence'].update(client_tests=239,current_client_sha256=binary,native_gamma_runtime_integrated=True,current_binary_endgame_runtime_requalified=False,current_binary_normal_structure_runtime_requalified=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(path,d)
p='docs/build_receipt.json';d=load(p);shutil.copy2(r/p,archive/'build_receipt.json');d['current_client_build']=dict(updated_utc=now,path='target/debug/openleague-client.exe',sha256=binary,bytes=(r/'target/debug/openleague-client.exe').stat().st_size,build_log='logs/native-gamma-build.log',client_tests=239,test_log='logs/native-gamma-client-tests.log',capture='docs/chaos_base_native_gamma_capture.json',only_client_rebuilt=True,other_top_level_receipt_values_historical=True);d['game_complete']=False;save(p,d)
for name in ['capture_chaos_gamma_scene.py','record_native_gamma_runtime.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Passe gamma intégrée au moteur Rust</h2><p>239tests client réussis et compilation vérifiée ; capture Vulkan inspectée. La table et le filtre natifs corrigent les couleurs de toute la scène. Les régions de fond Chaos demeurent ouvertes. Suite : couche de brouillard, ordre/composition et réglages.</p><a href="native_gamma_runtime_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(tests=239,binary=binary,expected_clear_after_gamma=expected,matches_in_crop=matches,complete=False)))
