from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert '36 passed; 0 failed' in (r/'logs/annie-q-culling-tests.log').read_text(encoding='utf-8-sig')
capture=load('docs/annie_q_culling_render_capture.json');assert capture['client_sha256']==sha(r/'target/debug/openleague-client.exe')
assert capture['q_probe']['remaining_materials']==capture['q_probe']['remaining_quads']==0
assert sha(r/capture['q_capture']['path'])==capture['q_capture']['sha256']
old=load('logs/annie-q-visibility-views.json')['frames'];new=load('logs/annie-q-culling-views.json')['frames']
def stats(frames):
 samples=[s for f in frames for s in f['samples'] if s['view_visible'] and s['screen']]
 return {'frames':len(frames),'max_in_view':max(f['visible_in_view'] for f in frames),'samples':len(samples),'back_facing_samples':sum(s['normal_to_camera_dot']<0 for s in samples),'max_local_global_distance':max(sum((a-b)**2 for a,b in zip(s['local'],s['global']))**.5 for s in samples)}
before=stats(old);after=stats(new);assert after['max_in_view']>0 and after['max_local_global_distance']<1e-3
text=(r/'crates/client/src/main.rs').read_text(encoding='utf-8');assert 'Ã' not in text and 'â€' not in text
now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_q_culling_progress.json'
ex=[{'path':p,'bytes':(r/p).stat().st_size,'sha256':sha(r/p)} for p in ['target/debug/openleague-server.exe','target/debug/openleague-client.exe','launcher/src-tauri/target/debug/openleague-launcher.exe']]
save(receipt,{'updated_utc':now,'complete':False,'client_tests_passed':36,'executables':ex,'before_visibility':before,'after_visibility':after,'gpu_capture':'docs/annie_q_culling_render_capture.json','community_reference':'tools/references/reyengine/VfxParticleRenderer.cs:370','changes':['Disable particle-quad face culling according to referenced community renderer; original4.20 state remains unqualified.','Move Q update into Update before transform propagation so current local/global positions agree at camera visibility check.','Restore UTF8 HUD text corrupted by diagnostic edit.'],'limits':['View visibility counts do not alone establish rasterization; inspect captured framebuffer separately.','Only Fire/Fire_Head Q groups integrated; Glow/Embers/Projected/skins/birth RNG/curve/bind/orbit/pass/linger/FOW/original runtime fidelity still incomplete.','ActualGPU captures use separate seeded fixture; no ordinary progression or human/native-fidelity acceptance.','Core423 last recorded unchanged, not rerun; all24domains and122fullkits incomplete.'],'files_sha256':{p:sha(r/p) for p in ['crates/client/src/annie_q_vfx.rs','crates/client/src/annie_ready.rs','crates/client/src/main.rs','logs/annie-q-culling-views.json','logs/annie-q-culling-tests.log','logs/annie-q-culling-build.log','tools/references/reyengine/VfxParticleRenderer.cs']}})
for p in ['docs/coverage.json','docs/completion_plan.json']:
 d=load(p);d['updated_utc']=now;d['complete']=False;d['current_evidence'].update(client_tests_passed=36,current_executables=ex,current_build_receipt=receipt);d['current_evidence']['annie_q_culling']={'receipt':receipt,'complete':False,'local_global_lag_corrected':True,'native_fidelity_qualified':False}
 if p.endswith('coverage.json'):
  for f in [receipt,'docs/annie_q_culling_render_capture.json']:
   if f not in d['evidence']:d['evidence'].append(f)
 save(p,d)
d=load('docs/resume_checkpoint.json');d['saved_utc']=now;d['state']='active';d['executables']=ex;d['complete']=False;d['last_verified']['client_tests']=36;d['latest_changes'].append('Q diagnostic showed in-view quads mostly back-facing and up to5.6worldunits of local/global lag. Particle cull disabled per communityrenderer, Q updated before transform propagation; corrected-capture actualview local/global alignment and36client checks, cleanup0. Original runtime fidelity and remaining Qgroups unfinished. UTF8HUD restored.');d['restart_next'].insert(0,'Inspect corrected Q framebuffer, then finish fullnativeQ groups/UV/attachment/bind/forces/projection/pass/skins and qualify original4.20 particle draw conventions. Sources/diagnostics docs/annie_q_culling_progress.json; visibility counts alone are not screenshot acceptance.');save('docs/resume_checkpoint.json',d)
for f in ['annie_q_vfx.rs','annie_ready.rs']:shutil.copyfile(r/'crates/client/src'/f,w/f);shutil.copyfile(w/f,r/'tools'/f)
for f in ['capture_annie_q_visibility.py','capture_annie_q_culling.py','record_annie_q_culling.py']:shutil.copyfile(w/f,r/'tools'/f)
print(json.dumps({'before':before,'after':after}));print('Recorded culling/scheduling/UTF8 fix and actualGPU evidence; completefalse.')
