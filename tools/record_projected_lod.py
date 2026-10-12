from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert '66 passed; 0 failed' in (r/'logs/projected-lod-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/projected-lod-build.log').read_text(encoding='utf-8-sig')
c=json.loads((r/'docs/projected_normal_capture_v4.json').read_text(encoding='utf-8'));assert c['client_sha256']==sha(r/'target/debug/openleague-client.exe')
for i,m in enumerate(c['measurements'],1):assert m['spawned']==i and m['cleaned']==i and m['active_draws']==0 and m['active_effects']==0 and m['max_visible_draws']>0
for image in c['captures']:assert sha(r/image['path'])==image['sha256']
for name in ['install_projected_lod.py','record_projected_lod.py']:shutil.copy2(w/name,r/'tools'/name)
paths=['data/4.20/particle_filter_contract.json','crates/client/src/terrain_material.rs','crates/client/src/projected_live.rs','crates/client/src/projected_render.rs','docs/projected_normal_capture_v4.json','logs/projected-lod-tests.log','logs/projected-lod-build.log','target/debug/openleague-client.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':66,'projected_current_build_vulkan_rerun':True,'current_build_all_gpu_checks_rerun':False,'server_casts':2,'remaining_draws':0,'findings':['Projected texture loader now enforces LOD min/max0, preserving native MIPFILTER NONE even if multilevel assets are loaded later.','U/V clamp and linear min/mag filters remain linked to original D3D state traces; generic terrain and other image settings preserved.','66tests and build passed; two real server casts on current Vulkan executable produce camera-visible projected geometry and clean all owned draws.'],'limits':['Native owner adapter, global alpha operation/depth comparison/culling, FOW, later pixelate/skin overrides and native visual fidelity remain open.','Diagnostic fixture seeds level6/position/readiness; not full ordinary-game acceptance.'],'files_sha256':{p:sha(r/p) for p in paths}}
(r/'docs/projected_lod_progress.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Qualify authored pixelate overrides, global depth/alpha state and exact missile owner; finish FOW/material variants, then continue all24domains.'
backup=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;shutil.copy2(p,backup/name);d=json.loads(p.read_text(encoding='utf-8-sig'));d['updated_utc']=now;d['projected_lod_progress']=receipt
 if name=='resume_checkpoint.json':d['last_verified']['client_tests']=66;d['next_projected_action']=next_action
 else:d['current_evidence']['client_tests_passed']=66;d['current_evidence']['current_build_receipt']='docs/projected_lod_progress.json';d['current_evidence']['current_client_sha256']=c['client_sha256'];d['current_evidence']['projected_current_binary_vulkan_verified']=True
 if name=='completion_plan.json':
  d['goal_refresh_request']['next_actions']=[next_action,'Continue all24domains.']
  d['goal_refresh_request']['latest_test_observation']={'passed':66,'log':'logs/projected-lod-tests.log','scope':'Projected LOD0 enforced, build and two current Vulkan casts passed; full fidelity incomplete.'}
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,backup/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projection — mipmaps</h2><p>LOD0 explicitement appliqué au chargeur des textures projetées ; filtrage linéaire et adressage aux bords conservés. 66 tests, compilation et deux casts Vulkan sur le client actuel réussis, aucun dessin restant. Propriétaire natif, profondeur, alpha hérité, FOW et variantes restent à terminer.</p><p><a href="projected_lod_progress.json">Preuves et limites actuelles</a></p></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps({'tests':66,'vulkan_casts':2,'remaining_draws':0,'game_complete':False}))
