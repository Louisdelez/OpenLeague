from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
assert '36 passed; 0 failed' in (r/'logs/annie-q-vfx-tests.log').read_text(encoding='utf-8-sig')
proof=load('docs/annie_q_vfx_render_capture.json');assert proof['client_sha256']==sha(r/'target/debug/openleague-client.exe')
q=proof['q_probe'];assert q['shots_seen']>=1 and q['captured'] and q['max_visible_quads']>0 and q['remaining_quads']==0 and q['remaining_materials']==0
assert proof['q_capture']['sha256']==sha(r/proof['q_capture']['path'])
ex=[{'path':p,'bytes':(r/p).stat().st_size,'sha256':sha(r/p)} for p in ['target/debug/openleague-server.exe','target/debug/openleague-client.exe','launcher/src-tauri/target/debug/openleague-launcher.exe']]
receipt='docs/annie_q_vfx_progress.json'
files=['crates/client/src/annie_q_vfx.rs','crates/client/src/main.rs','data/4.20/particles/annie/Annie_Q_mis.json','docs/annie_q_vfx_binding_contract.json','docs/annie_spell_vfx_sources.json','docs/annie_q_vfx_render_capture.json','logs/annie-q-vfx-tests.log','logs/annie-q-vfx-build.log']
limits=['Only Fire/Fire_Head consumers active; native Fire_Glow path ambiguity, Embers lookup/atlas/forcefields, Projected depth/ground projection and skin meshes/variants remain to implement.',
 'Launch uses actual imported Neck GlobalTransform; target augmentation100 recovered native. Initial packet observation clock, homing visual interpolation, random distribution, curve/integration and coordinate conventions are reconstructed, not original-runtime-qualified.',
 'Native e-rotation/orbit/UV birth offsets/pass ordering, partial-bind trajectory/history and particle-linger semantics not fully consumed or qualified. Max-linger2 cleanup is a reconstruction.',
 'Screenshot comes from actual Vulkan client and separate fixture seeded level6/position/readiness, not ordinary progression or native-runtime fidelity proof.',
 'Impact/after effects not inferred from projectile disappearance; native HaveHitEffect/HaveAfterEffect0 despite names. No audible playback qualification.',
 'Current client36 tests; core423 last recorded and unchanged in this integration, not rerun. All24domains and122fullchampionkits incomplete.']
save(receipt,{'updated_utc':now,'complete':False,'integration_checks_passed':True,'client_tests_passed':36,'new_client_tests':2,'core_last_recorded_tests':423,'core_tests_rerun':False,'rendered_groups':['Fire','Fire_Head'],'executables':ex,'gpu':'docs/annie_q_vfx_render_capture.json','files_sha256':{p:sha(r/p) for p in files},'visual_fidelity_qualified':False,'limits':limits})
for p in ['docs/coverage.json','docs/completion_plan.json']:
 d=load(p);d['updated_utc']=now;d['complete']=False
 d['current_evidence'].update(client_tests_passed=36,current_executables=ex,current_build_receipt=receipt)
 d['current_evidence']['annie_q_vfx']={'receipt':receipt,'complete':False,'rendered_groups':['Fire','Fire_Head'],'gpu_fixture':'docs/annie_q_vfx_render_capture.json','visual_fidelity_qualified':False}
 if p.endswith('coverage.json'):
  for f in [receipt,'docs/annie_q_vfx_render_capture.json']:
   if f not in d['evidence']:d['evidence'].append(f)
 save(p,d)
d=load('docs/resume_checkpoint.json');d['saved_utc']=now;d['state']='active';d['complete']=False;d['executables']=ex;d['last_verified']['client_tests']=36
d['latest_changes'].append('Native Q Fire/Fire_Head quad consumers integrated with actual importedNeck attachment,targetheight100,bounded pools, nativeRGBA/probability/UV curves and explicit reconstructed trajectory/random/drag/linger.36client checks and realVulkan fixture flight/cleanup capture. Remaining native groups/skinmesh/FOW/rotation/pass/impact/audio and original visual fidelity open;423corelastrecorded unchanged.')
d['restart_next'].insert(0,'Complete Annie_Q_mis Fire_Glow/Embers/Projected consumers and remaining native transformations/curve/bind/orbit/birth/pass/linger/skin semantics. Use docs/annie_q_vfx_progress.json; qualify original runtime screenshot/trajectory/FOW, do not call two rendered groups full Q VFX.')
save('docs/resume_checkpoint.json',d)
shutil.copyfile(r/'crates/client/src/annie_q_vfx.rs',w/'annie_q_vfx.rs');shutil.copyfile(w/'annie_q_vfx.rs',r/'tools/annie_q_vfx.rs')
for p in ['capture_annie_q_vfx.py','record_annie_q_vfx.py']:shutil.copyfile(w/p,r/'tools'/p)
print('Recorded36client tests and actual native-Q fixture capture/cleanup; fullVFX incomplete.')
