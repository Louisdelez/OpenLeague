from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
capture=load('docs/map10_view_startup_capture.json');receipt=load('docs/native_view_caller_progress.json')
assert capture['client_sha256']==receipt['files_sha256']['target/debug/openleague-client.exe']==sha('target/debug/openleague-client.exe')
assert capture['client_alive_at_capture'] and not capture['server_connected']
assert capture['capture_sha256']==sha('logs/map10-view-startup-127.png')
capture.update(visual_inspection_required=False,visual_inspection={'observed':'Map10 terrain, lane, fountain architecture, vegetation and blue lighting visible in actual1280x800 framebuffer; connection label shown and no champion present.','limits':'One camera viewpoint, standalone client only. No full-map material acceptance, missing-content audit or gameplay/fog verification.'});save('docs/map10_view_startup_capture.json',capture)
receipt.update(updated_utc=now,map10_startup_view_runtime_verified=True,current_client_graphical_rerun=True,current_startup_capture_receipt='docs/map10_view_startup_capture.json')
receipt['findings'].append('Current executable launched on Vulkan and stayed alive until actual framebuffer capture; restored Map10 architecture/terrain/vegetation visible. Startup path reached renderer without panic. No server connected or gameplay vision source processed.')
receipt['limits']=[s for s in receipt['limits'] if not s.startswith('Current executable has not been launched')]
receipt['limits'].append('Current graphical rerun covers standalone startup and one restored-map camera view only; no live fog masks, authoritative visibility or six-client gameplay acceptance.')
receipt['next_actions']=['Qualify resource lookup, camera/configuration producers and ordinary gameplay source creation.','Connect normal entity sources to registered views, authoritative visibility and GPU rendering.','Verify restored Map10 through a current six-client match and continue all completion-plan domains.']
receipt['files_sha256'].update({p:sha(p) for p in ['logs/map10-view-startup-127.png','logs/map10-view-startup-127.log']});save('docs/native_view_caller_progress.json',receipt)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;d=load(p);d['updated_utc']=now;d['native_view_caller_progress']=receipt
 if name=='resume_checkpoint.json':d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(current_startup_render_receipt='docs/map10_view_startup_capture.json',map10_startup_view_runtime_verified=True)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Contrôle du démarrage actuel</h2><p>Le client actuel a rendu Map10 sur Vulkan. Capture1280×800 inspectée : terrain, architecture de fontaine et végétation visibles. Aucun serveur connecté ; vision en partie et validation complète de la carte restent ouvertes.</p><a href="map10_view_startup_capture.json">Preuve de lancement</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['capture_map10_view_startup.py','record_view_startup_capture.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps(dict(client_tests=127,actual_startup_capture=True,gameplay_vision_complete=False,complete=False)))
