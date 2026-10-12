from pathlib import Path
import datetime,json,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
live=json.loads((r/'docs/projected_terrain_live_capture.json').read_text(encoding='utf-8'))
assert live['measurement']['restored_terrain_meshes']==82 and live['measurement']['source_triangles']==1163
assert live['client_sha256']==sha(r/'target/debug/openleague-client.exe')
proof={'updated_utc':now,'complete':False,'client_tests_passed':46,'build_passed':True,'gpu_client_run':True,'runtime_particle_rendered':False,'geometry_measurement':live['measurement'],'restored_map_sha256':live['restored_map_sha256'],'receipt':'docs/projected_terrain_live_capture.json','executables':[{'path':str(p.relative_to(r)).replace('\\','/'),'bytes':p.stat().st_size,'sha256':sha(p)} for p in [r/'target/debug/openleague-server.exe',r/'target/debug/openleague-client.exe',r/'launcher/src-tauri/target/debug/openleague-launcher.exe']],'files_sha256':{n:sha(r/n) for n in ['crates/client/src/projected_terrain.rs','crates/client/src/main.rs','logs/projected-terrain-tests.log','logs/projected-terrain-build.log','docs/projected_terrain_live_capture.json','logs/projected-terrain-loaded.json']},'limits':['Live client geometry cache includes the82height-blend terrain meshes with TT_Jungle1/TT_Lanes1 materials. Other floor/stair/bridge/boss-floor receiving surfaces and original type7 spatial query selection remain to qualify.','World triangles are actual restored GLB vertices transformed by actual GlobalTransforms; cache refreshes changed transforms, asset events and disappeared entities.','World-space clipped mesh/UVs/normals prepared; no live projected particle shader/material/emitter consumer yet. No visible projected effect claimed.','Explicit fixture patch dimensions used to measure geometry only; native p-scale/local-orient, bindings/depth/sampler/FOW/lifetime and texture resolver still open.','Native full renderer and complete24domain game remain unachieved.']}
(r/'docs/projected_terrain_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'))
    if name=='coverage.json':
        c=d['current_evidence'];c['client_tests_passed']=46;c['current_build_receipt']='docs/projected_terrain_progress.json';c['current_build_gpu_rerun']=True
        c['projected_terrain_geometry']={'receipt':'docs/projected_terrain_progress.json','live_meshes':82,'live_triangles':1163,'runtime_projected_particle_rendered':False}
    elif name=='resume_checkpoint.json':
        d['saved_utc']=now;d['last_verified']['client_tests']=46;d['executables']=proof['executables']
        action='Real Vulkan client caches82restored height-blend meshes/1163triangles and produces nonflat clipped patches at Annie. projected_terrain.rs prepares world-space geometry/UV/normals with native matrices; no GPU projected particle bound. Next qualify original type7 receiving-surface spatial selection, emitter p-scale/local-orient input producer, then bind material/FOW/depth/lifetime. Preserve other floors/stairs/bridges and full24domain scope. Evidence docs/projected_terrain_progress.json.'
        d.setdefault('next_actions',[]).insert(0,action)
    else:d['latest_projection_evidence']={'receipt':'docs/projected_terrain_progress.json','client_checks':46,'live_surface_meshes':82,'live_surface_triangles':1163,'runtime_projected_complete':False,'full_goal_complete':False}
    p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['record_projected_terrain.py','capture_projected_terrain.py']:
    shutil.copyfile(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps({'client_tests':46,'live_meshes':82,'live_triangles':1163,'patch_triangles':live['measurement']['clipped_triangles'],'runtime_particle_rendered':False}))
