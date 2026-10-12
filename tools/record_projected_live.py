from pathlib import Path
import json,datetime,hashlib,shutil,re,html
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
tests=(r/'logs/projected-live-tests-v2.log').read_text(encoding='utf-8-sig');build=(r/'logs/projected-live-build-v2.log').read_text(encoding='utf-8-sig')
assert '62 passed; 0 failed' in tests and 'Finished `dev`' in build
capture=json.loads((r/'docs/projected_normal_capture_v2.json').read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert capture['client_sha256']==sha(r/'target/debug/openleague-client.exe')
for i,m in enumerate(capture['measurements'],1):assert m['spawned']==i and m['cleaned']==i and m['active_draws']==0 and m['active_effects']==0 and m['max_visible_draws']>0
for c in capture['captures']:assert sha(r/c['path'])==c['sha256']
for name in ['install_projected_live.py','record_projected_live.py','prepare_projected_capture_v2.py']:shutil.copy2(w/name,r/'tools'/name)
paths=['crates/client/src/projected_live.rs','crates/client/src/annie_q_vfx.rs','crates/client/src/main.rs','assets/shaders/projected_terrain.wgsl','docs/projected_normal_capture_v2.json','logs/projected-live-tests-v2.log','logs/projected-live-build-v2.log','target/debug/openleague-client.exe','tools/install_projected_live.py','tools/capture_projected_live_v2.py']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':62,'normal_projected_emitter_bound':True,'native_owner_binding_fully_qualified':False,'projected_current_build_vulkan_rerun':True,'current_build_all_gpu_checks_rerun':False,'server_casts':2,'max_patch_vertices':capture['measurements'][-1]['max_vertices'],'remaining_effects':0,'remaining_draws':0,'max_camera_visible_draws':capture['measurements'][-1]['max_visible_draws'],'findings':['Normal Annie Q uses the same current neck/missile anchor as Fire/Fire_Head/Embers, native Simple lifetime/owner-end logic and qualified projected arithmetic.','Two actual server casts on the current Vulkan client each create and release their own entity, mesh and material; camera-visible draw counter is nonzero; zero effects/draws remain.','Capture is delayed until the texture is loaded and camera visibility observed, at least120ms after shot creation.','Current shader/material pipeline executes with the restored real terrain, native texture and147vertices maximum; this is not original-game pixel fidelity acceptance.'],'limits':['Exact native missile interface, identity-orientation adapter and stop dispatch are reconstructed, not fully qualified.','Default scale factors1; runtime scale setters, full receiver selection, FOW, blend/depth/sampler and palette/shader variants remain unqualified.','Diagnostic server fixture seeds level6/center/readiness; ordinary progression, other skins and full Q kit remain unfinished.','Capture inspection must distinguish render presence from native fidelity; other current Q effects overlap in the framebuffer.'],'files_sha256':{p:sha(r/p) for p in paths}}
(r/'docs/projected_normal_progress.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n')
receipt['visual_review']={'current_on_off_images_inspected':True,'observation':'The loaded-texture on frame shows a subtle orange ground glow below the projectile path; the off frame no longer shows that ground glow. Fire/Embers remain visible after owner end and overlap in both captures.','native_fidelity_accepted':False,'isolated_pixel_attribution_verified':False}
(r/'docs/projected_normal_progress.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n')
next_action='Qualify original projected material state, runtime factor setters and exact missile owner provider; compare current normal projection pixels to native behavior, then continue all24domains.'
domain_state='Effets partiellement intégrés. Projection normale du Q d’Annie raccordée aux vrais projectiles avec arithmétique et durée de vie natives vérifiées ; deux casts Vulkan, visibilité caméra et nettoyage contrôlés sur le client actuel. 62 tests client réussis. Adaptateur propriétaire reconstruit ; état matériel, FOW, variantes, skins, fidélité native et autres effets restent à terminer.'
backup=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup.mkdir(parents=True,exist_ok=True)
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/filename;shutil.copy2(p,backup/p.name);d=json.loads(p.read_text(encoding='utf-8-sig'));d['updated_utc']=now;d['projected_normal_progress']=receipt
 if filename=='resume_checkpoint.json':d['last_verified']['client_tests']=62;d['next_projected_action']=next_action
 else:
  e=d['current_evidence'];e['client_tests_passed']=62;e['current_build_receipt']='docs/projected_normal_progress.json';e['current_client_sha256']=capture['client_sha256'];e['annie_projected_normal_binding']=True;e['annie_projected_native_owner_qualified']=False;e['projected_current_binary_vulkan_verified']=True
 if filename=='completion_plan.json':
  d['goal_refresh_request']['latest_test_observation']={'passed':62,'log':'logs/projected-live-tests-v2.log','scope':'Normal projected binding and visibility-gated capture; compilation and2Vulkan casts passed; full fidelity incomplete.'}
  for domain in d['domains']:
   if str(domain.get('id','')).endswith('15'):domain['current_state']=domain_state
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,backup/p.name);s=p.read_text(encoding='utf-8');pattern=r'(<section id="domain-15">[\s\S]*?<p><b>État vérifié ou enregistré :</b> ).*?(</p>)';s=re.sub(pattern,lambda m:m[1]+html.escape(domain_state)+m[2],s,count=1)
s=s.replace('</body>','<section><h2>Projection normale d’Annie — vérification actuelle</h2><p>'+html.escape(domain_state)+'</p><p><a href="projected_normal_progress.json">Preuves, limites et empreintes du client actuel</a></p></section></body>');p.write_text(s,encoding='utf-8')
summary={p.name:sha(p) for p in [r/'docs/completion_plan.json',r/'docs/completion_plan.html',r/'docs/coverage.json',r/'docs/resume_checkpoint.json']}
(r/'docs/projected_normal_plan_receipt.json').write_text(json.dumps({'updated_utc':now,'complete':False,'files_sha256':summary},indent=2)+'\n')
print(json.dumps({'client_tests':62,'normal_vulkan_casts':2,'remaining_draws':0,'goal_complete':False}))
