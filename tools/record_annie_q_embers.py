from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert '37 passed; 0 failed' in (r/'logs/annie-q-embers-tests.log').read_text(encoding='utf-8-sig')
c=load('docs/annie_q_embers_render_capture.json');q=c['q_probe'];assert c['client_sha256']==sha(r/'target/debug/openleague-client.exe')
assert q['max_quads']==518 and q['remaining_materials']==q['remaining_quads']==0
assert q['rendered_groups']==['Fire','Fire_Head','Embers'] and c['q_capture']['sha256']==sha(r/c['q_capture']['path'])
views=load('logs/annie-q-embers-views.json')['frames'];ember_max=max(f['ember_in_view'] for f in views);assert ember_max>0
native=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Shaders/HLSL/ParticleSystem')
ex=[{'path':p,'bytes':(r/p).stat().st_size,'sha256':sha(r/p)} for p in ['target/debug/openleague-server.exe','target/debug/openleague-client.exe','launcher/src-tauri/target/debug/openleague-launcher.exe']]
now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_q_embers_progress.json'
limits=['Fire/Fire_Head/Embers active; Fire_Glow asset precedence ambiguous and Projected ground/depth consumer unfinished. Skin-specific mesh/quad emitters absent.',
 'Native common.hls atlas transform and QUAD_PS texel*vertexColor*lookup formula ported; original input lookup UV mapping/RNG/color-space/alpha-target factors still reconstructed or unqualified.',
 'Ember normalizedageU/randomV lookup coordinates inferred, not recovered original4.20 enum semantics. Native colortype retained in JSON, not silently declared qualified.',
 'Random birth/frame/life/velocity distribution, quad size/bind/drag/orbit/forces/emitter-local rotations/UVoffset/pass/linger and snapshot clock still incomplete or reconstructed.',
 'Mode0 color ADD represented by shader premultiply/outputalpha1 under SrcAlpha/One color factors; native framebuffer-alpha factors not qualified. sparks_BW native alpha is uniformly255.',
 'Pools retain until every sampled particle expires and at least current2sec linger reconstruction elapsed; original destruction/linger contract remains unqualified.',
 'ActualVulkan fixture seeds level6/positions/readiness, not ordinary progression or human/native visual acceptance. Core423lastrecorded unchanged, not rerun; full24domain goal incomplete.']
files=['crates/client/src/annie_q_vfx.rs','assets/shaders/annie_q_particles.wgsl','logs/annie-q-embers-tests.log','logs/annie-q-embers-build.log','logs/annie-q-embers-views.json','docs/annie_q_embers_render_capture.json','assets/particles/annie/sparks_BW.png','assets/particles/annie/Annie_Embers_RGB.png']
save(receipt,{'updated_utc':now,'complete':False,'client_tests_passed':37,'new_client_checks':1,'executables':ex,'native_shader_sources':[{'path':str(native/n),'sha256':sha(native/n)} for n in ['QUAD_PS.ps_2_0','common.hls']],'rendered_groups':q['rendered_groups'],'capacity_Embers':391,'total_capacity':518,'actual_ember_max_in_camera':ember_max,'gpu_capture':'docs/annie_q_embers_render_capture.json','visual_fidelity_qualified':False,'files_sha256':{p:sha(r/p) for p in files},'limits':limits})
for p in ['docs/coverage.json','docs/completion_plan.json']:
 d=load(p);d['updated_utc']=now;d['complete']=False;d['current_evidence'].update(client_tests_passed=37,current_executables=ex,current_build_receipt=receipt);d['current_evidence']['annie_q_embers']={'receipt':receipt,'complete':False,'actual_ember_max_in_camera':ember_max,'native_fidelity_qualified':False}
 if p.endswith('coverage.json'):
  for f in [receipt,'docs/annie_q_embers_render_capture.json']:
   if f not in d['evidence']:d['evidence'].append(f)
 save(p,d)
d=load('docs/resume_checkpoint.json');d['saved_utc']=now;d['state']='active';d['complete']=False;d['executables']=ex;d['last_verified']['client_tests']=37;d['latest_changes'].append('QEmbers integrated with nativeBWatlas2x2/randomframe, original256x8lookup and recovered lifespan/velocity/offset curves, camera/velocity orientation and stretch.37client tests plusVulkanfixture518quads and distinctEmber camera count; materials/quads cleanup0. Native lookupcoordinate/RNG/orbit/bind/forces/pass/linger/fidelity and remainingGlow/Projected/skins open.');d['restart_next'].insert(0,'Inspect Ember framebuffer then complete Q Fire_Glow resolution and Projected ground/depth consumer; qualify original lookupUV,colortype/RNG/atlas/velocity alignment/orbit/forces/rotation/bind/UVoffset/pass/linger/skins/FOW/audio. Latest docs/annie_q_embers_progress.json; no fullQ VFX acceptance.');save('docs/resume_checkpoint.json',d)
shutil.copyfile(r/'crates/client/src/annie_q_vfx.rs',w/'annie_q_vfx.rs');shutil.copyfile(w/'annie_q_vfx.rs',r/'tools/annie_q_vfx.rs')
for f in ['annie_q_particles.wgsl','integrate_annie_q_embers.py','capture_annie_q_embers.py','record_annie_q_embers.py']:shutil.copyfile(w/f,r/'tools'/f)
print(json.dumps({'client_tests':37,'pool_capacity':518,'Embers_in_camera_max':ember_max,'cleanup_quads':0,'cleanup_materials':0,'complete':False}))
