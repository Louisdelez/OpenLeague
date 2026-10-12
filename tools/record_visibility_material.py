from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));from PIL import Image
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.datetime.now(datetime.timezone.utc).isoformat()
assert '133 passed; 0 failed' in (r/'logs/visibility-material-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/visibility-material-build.log').read_text(encoding='utf-8-sig')
runtime=load('docs/visibility_material_runtime_capture.json');assert runtime['client_sha256']==sha('target/debug/openleague-client.exe')
log=(r/'logs/visibility-material-client.log').read_text(encoding='utf-8',errors='replace');assert 'Shader compilation error' not in log and 'Validation Error' not in log
pixels=list(Image.open(r/'logs/visibility-material-133.png').convert('RGB').crop((0,0,1280,650)).getdata())
stats={'dark':sum(max(p)<5 for p in pixels),'white':sum(min(p)>250 for p in pixels),'grey':sum(max(p)-min(p)<=2 and 10<min(p)<245 for p in pixels)}
assert stats['dark']>1000 and stats['white']>1000 and stats['grey']>100,stats
runtime.update(diagnostic_only=True,visual_inspection_required=False,focus=[280,0,250],mask_display_pixel_counts=stats,diagnostic_material_sampling_observed=True,normal_dynamic_fog_bound=False)
runtime['visual_inspection']={'observed':['Real framebuffer displays black hidden regions, white visible terrain/decor and graded transition around the allied bottom front turret.'],'limits':['Explicit grayscale mask diagnostic; not full game fog colors/density/fade/blur.','Qualifies visible GPU sampling, not a numerical world-to-pixel comparison or GPU texture readback.']}
save('docs/visibility_material_runtime_capture.json',runtime)
receipt={'updated_utc':now,'complete':False,'client_tests_passed':133,'client_build_passed':True,'runtime':runtime,'findings':['Real visibility Image handle attached to existing native terrain/environment material variants. Verified c230 reciprocal/invertedZ coordinate factors bridged from native units to world units.','Actual Vulkan grayscale diagnostic shows nonuniform visible/hidden regions and graded boundaries; compiled shaders used original expanded masks.'],'limits':['Normal gameplay dynamic fog factors remain disabled; overlay selection, edge parameters and full fade/blur pipeline remain incomplete.','No numerical position-to-pixel acceptance or GPU readback. Only existing terrain/environment variants; actors/projected effects remaining.','Source/clock/config/initialization/sampler adapters remain explicit. HUD accent corruption remains open.'],'next_actions':['Qualify actual Map10 overlay selection/property reader, texture path resolver and edge-parameter producer.','Complete native fade/blur and apply native fog factors to ordinary terrain/environment/projected rendering, then compare sampled world positions to GPU pixels.','Avoid repeatedly marking unchanged materials dirty; verify runtime performance. Fix HUD text encoding. Continue all completion-plan domains.'],'files_sha256':{p:sha(p) for p in ['crates/client/src/fow_visibility_texture.rs','crates/client/src/map_fog.rs','crates/client/src/terrain_material.rs','crates/client/src/main.rs','assets/shaders/native_environment_fog.wgsl','assets/shaders/terrain_height_blend.wgsl','logs/visibility-material-tests.log','logs/visibility-material-build.log','logs/visibility-material-133.png','target/debug/openleague-client.exe']}}
save('docs/native_visibility_material_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_visibility_material_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=133;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=133,current_test_receipt='docs/native_visibility_material_progress.json',current_build_receipt='docs/native_visibility_material_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False,diagnostic_visibility_material_sampling_observed=True,live_fow_material_bound=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Masque de vision — diagnostic GPU</h2><p>133 tests et compilation réussis. Capture Vulkan : masque réel échantillonné sur le terrain et le décor, avec frontières visibles. Brouillard normal, overlay, fondu/flou et vérification numérique restent ouverts.</p><a href="native_visibility_material_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['prepare_visibility_material_probe.py','capture_visibility_material.py','record_visibility_material.py','inspect_fow_map_descriptor.py','inspect_fow_overlay_resources.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps({'client_tests':133,'diagnostic_gpu_sampling':True,'pixel_counts':stats,'normal_fog_bound':False,'complete':False}))
