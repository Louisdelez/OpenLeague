from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
measurement=json.loads((r/'logs/projected-render-on.json').read_text(encoding='utf-8'))
assert measurement['patch_vertices']==147 and measurement['remaining_materials']==0 and not measurement['remaining_probe_entity']
log=(r/'logs/projected-render-client.log').read_text(encoding='utf-8')
assert 'Projected diagnostic only' in log
assert 'panicked' not in log and 'Shader compilation error' not in log
capture={'checked_utc':now,'complete':False,'diagnostic_fixture':True,'native_emitter_bound':False,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'fixture_sha256':sha(r/'target/debug/examples/annie_ready_fixture.exe'),'measurement':measurement,'captures':[{'path':name,'sha256':sha(r/name)} for name in ['logs/projected-render-on.png','logs/projected-render-off.png']],'optional_startup_capture_saved':(r/'logs/projected-render-baseline.png').exists(),'visual_inspection_required':False,'visible_orange_ground_glow':True,'inspection':'Actual on/off images inspected: faint orange ground glow around Annie visible in on capture and absent in off. Source4.20 runtime comparison not performed.','harness_note':'Capture harness completed on/off and resource cleanup, then receipt construction failed on absent optional startup capture. Existing actual captures retained; recorder now uses required on/off pair. Harness finally terminated its own processes. No rerun fabricated.','limits':['Explicit diagnostic material on actual restored terrain. Native Q emitter binding/placement and lifetime not connected.','FOW1/half-size500/angle0/additive/depth/sampler/color-space reconstructed or unqualified. Native death/palette/mip shader variants and other receiving surfaces incomplete.','Separate level6/center fixture; no ordinary progression, source-native visual fidelity or full champion acceptance.']}
(r/'docs/projected_render_live_capture.json').write_text(json.dumps(capture,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof={'updated_utc':now,'complete':False,'build_passed':True,'client_tests_passed':46,'gpu_capture':'docs/projected_render_live_capture.json','diagnostic_projected_material_rendered':True,'native_annie_projected_emitter_bound':False,'cleanup_materials':0,'executables':[{'path':str(p.relative_to(r)).replace('\\','/'),'bytes':p.stat().st_size,'sha256':sha(p)} for p in [r/'target/debug/openleague-server.exe',r/'target/debug/openleague-client.exe',r/'launcher/src-tauri/target/debug/openleague-launcher.exe']],'files_sha256':{n:sha(r/n) for n in ['crates/client/src/projected_render.rs','crates/client/src/main.rs','assets/shaders/projected_terrain.wgsl','assets/particles/annie/disintegrate-light.png','logs/projected-render-tests.log','logs/projected-render-build.log','docs/projected_render_live_capture.json']},'limits':capture['limits']}
(r/'docs/projected_render_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'))
    if name=='coverage.json':
        c=d['current_evidence'];c['current_build_receipt']='docs/projected_render_progress.json';c['current_build_gpu_rerun']=True
        c['projected_material_diagnostic']={'receipt':'docs/projected_render_progress.json','actual_visible_glow':True,'native_emitter_bound':False,'cleanup_materials':0}
    elif name=='resume_checkpoint.json':
        d['saved_utc']=now;d['executables']=proof['executables'];d['last_verified']['client_tests']=46
        d.setdefault('next_actions',[]).insert(0,'ProjectedMaterial samples native disintegrate-light texture on49actual clipped terrain triangles; actual Vulkan on/off shows faint orange ground glow and material cleanup0. Diagnostic flag only, no native Annie emitter bound. Qualify native caller scale/aspect/local-orient/attachment/lifetime and receiver selection, then integrate Q Projected with full FOW/depth/sampler/death/palette policies. See docs/projected_render_progress.json; full24domain game remains incomplete.')
    else:d['latest_projection_evidence']={'receipt':'docs/projected_render_progress.json','client_checks':46,'gpu_diagnostic_visible_glow':True,'native_emitter_bound':False,'full_goal_complete':False}
    p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['capture_projected_render.py','record_projected_render.py']:
    shutil.copyfile(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps({'tests':46,'visible_diagnostic_glow':True,'material_cleanup':0,'native_emitter_bound':False}))
