from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '133 passed; 0 failed' in (r/'logs/visibility-texture-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/visibility-texture-build.log').read_text(encoding='utf-8-sig')
runtime=load('docs/visibility_texture_runtime_capture.json');assert runtime['client_sha256']==sha('target/debug/openleague-client.exe') and runtime['measurement']['error'] is None
runtime['visual_inspection_required']=False
runtime['visual_inspection']={'observed':['Actual Vulkan framebuffer displays textured blue base, champion and health bars. French HUD accents remain corrupted.'],'limits':['Texture diagnostics report Image asset updates; screenshot does not show dynamic fog because material sampling is not bound.']}
save('docs/visibility_texture_runtime_capture.json',runtime)
receipt={'updated_utc':now,'complete':False,'client_tests_passed':133,'client_build_passed':True,'runtime':runtime,'material_bound':False,'gpu_readback_verified':False,'findings':['Qualified native128-to512expansion connected to persistent Bevy R8Unorm Image asset updates. Native strict>0.2supload cadence reused.','Session/team change clears previous visibility; invalid buffers/clocks are rejected before mutation.','Actual local server/Vulkan client probe observes repeated nonzero texture updates.'],'limits':['Raw mask only; native fade/blur, original texture initialization/sampler/device producers remain open.','Zero allocation and Bevy sampler are explicit transport adapters. No dynamic fog shader binding or GPU readback acceptance.','Source identity/eligibility and camera/config producers remain adapters; wards, stealth, spectator and six-client match pending.'],'next_actions':['Qualify native fog render target/sampler/fade/blur integration and original overlay/edge parameter producers.','Bind actual visibility/overlay factors to terrain, structures and projected effect shaders; verify GPU readback and rendered positions/edges.','Fix observed HUD accent corruption and continue all completion-plan domains.'],'files_sha256':{p:sha(p) for p in ['crates/client/src/fow_visibility_texture.rs','crates/client/src/main.rs','logs/visibility-texture-tests.log','logs/visibility-texture-build.log','logs/visibility-texture-133.png','target/debug/openleague-client.exe']}}
save('docs/native_visibility_texture_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_visibility_texture_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=133;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=133,current_test_receipt='docs/native_visibility_texture_progress.json',current_build_receipt='docs/native_visibility_texture_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False,raw_visibility_image_updates_verified=True,live_fow_material_bound=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Texture de visibilité</h2><p>133 tests et compilation réussis. Masques natifs128→512 raccordés à une Image Bevy et mises à jour observées dans le client Vulkan. Fade, flou, matériaux et lecture GPU restent ouverts.</p><a href="native_visibility_texture_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('132 tests réussis','133 tests réussis');p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><body><pre>'+html.escape(s)+'</pre></body></html>',encoding='utf-8')
for name in ['prepare_visibility_texture.py','capture_visibility_texture.py','record_visibility_texture.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps({'client_tests':133,'raw_image_updates':True,'material_bound':False,'complete':False}))
