from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
assert '34 passed; 0 failed' in (r/'logs/annie-ready-alphaadd-tests.log').read_text(encoding='utf-8-sig')
assert '423 passed; 0 failed' in (r/'logs/annie-ready-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished' in (r/'logs/annie-ready-alphaadd-build.log').read_text(encoding='utf-8-sig')
capture=load('docs/annie_ready_alphaadd_render_capture.json');src=load('docs/annie_ready_sources.json')
assert capture['client_sha256']==sha(r/'target/debug/openleague-client.exe')
for c in capture['captures']:assert c['sha256']==sha(r/c['path'])
assert src['native_fields']==98 and src['independent_fields_equal']==98
for t in src['textures']:
 assert t['pixels_equal'] and sha(r/'assets'/t['asset'])==t['png_sha256'] and sha(t['source'])==t['source_sha256']
probe=capture['probe'];assert probe['max_quads']==10 and probe['remaining_quads']==0 and probe['remaining_particle_materials']==0
assert probe['color_blend']=='SrcAlpha/One/Add'
executables=[{'path':p,'bytes':(r/p).stat().st_size,'sha256':sha(r/p)} for p in ['target/debug/openleague-server.exe','target/debug/openleague-client.exe','launcher/src-tauri/target/debug/openleague-launcher.exe']]
limits=['Base ready1 quad consumer integrated, not a complete particle engine or Annie kit.',
 'All98 native fields recovered and4 original textures decoded pixel-exact; only base ready1 emitter rendered. Frost sphere emitters not rendered; ready2 referenced but absent in this native file.',
 'Color blend SrcAlpha/One/Add supported by community Troy identity mapping and modern engine enum; original4.20 blend-state runtime and alpha factors remain unqualified.',
 'Birth/RNG, halfextent geometry, emitter UVoffset, remaining curves, actor rotation/bind semantics, fog visibility, death rules, skin switching, soft particles and color-space fidelity still need qualification.',
 'Actual Vulkan captures use a separate level6/readiness/position fixture.10quads/one emitter observed and fully removed on Q consumption; these counts alone do not prove appearance or ordinary progression.',
 'Original alpha-blend screenshots showed a very subtle effect. Native-runtime comparison and human visual acceptance are still missing; no audible output qualification.',
 'All24domains and122full kits remain incomplete.']
receipt='docs/annie_ready_progress.json'
files=['crates/client/src/annie_ready.rs','crates/client/src/main.rs','assets/shaders/annie_ready.wgsl','data/4.20/particles/StunReady.json','docs/annie_ready_sources.json','docs/annie_ready_render_capture.json','docs/annie_ready_alphaadd_render_capture.json','logs/annie-ready-tests.log','logs/annie-ready-alphaadd-tests.log','logs/annie-ready-alphaadd-build.log','tools/references/reyengine/manifest.json']
save(receipt,{'updated_utc':now,'complete':False,'integration_checks_passed':True,'core_tests_passed':423,'client_tests_passed':34,'new_client_checks':2,'native_fields':98,'pixel_exact_textures':4,'executables':executables,'sources':'docs/annie_ready_sources.json','blend_reference':'tools/references/reyengine/manifest.json','gpu_capture':'docs/annie_ready_alphaadd_render_capture.json','visual_fidelity_qualified':False,'files_sha256':{p:sha(r/p) for p in files},'limits':limits})
for p in ['docs/coverage.json','docs/completion_plan.json']:
 d=load(p);d['updated_utc']=now;d['complete']=False
 d['current_evidence'].update(core_tests_passed=423,client_tests_passed=34,current_executables=executables,current_build_receipt=receipt)
 d['current_evidence']['annie_ready_vfx']={'receipt':receipt,'complete':False,'native_fields':98,'pixel_exact_textures':4,'gpu_fixture':'docs/annie_ready_alphaadd_render_capture.json','visual_fidelity_qualified':False,'scope':'Base ready1 emitter plus fixed-alphaUV shader and community-supported alphaadd factors; original appearance, remaining fields and frost emitters unqualified.'}
 if p.endswith('coverage.json'):
  for f in [receipt,'docs/annie_ready_sources.json','docs/annie_ready_alphaadd_render_capture.json']:
   if f not in d['evidence']:d['evidence'].append(f)
 save(p,d)
d=load('docs/resume_checkpoint.json');d['saved_utc']=now;d['state']='active';d['complete']=False;d['executables']=executables;d['last_verified'].update(core_tests=423,client_tests=34,annie_ready_native_fields=98,annie_ready_pixel_exact_textures=4)
d['build']='Annie base ready1 particle consumer: native texture/98fields recovered, fixed-alphaUV shader, community-supported alphaadd color factors;423core34client and actual Vulkan fixture capture/cleanup. Original visual fidelity and all24domains incomplete.'
d['latest_changes'].append(d['build'])
d['restart_next'].insert(0,'Qualify Annie ready1 original appearance/birth/geometry/bind/curves/fog and skin variants against native runtime; use docs/annie_ready_progress.json and archived ReyEngine Troy converter as community evidence, not original4.20 proof. Original ready2 section absent. Integrate general particle engine and other required effects before closing domain15.')
save('docs/resume_checkpoint.json',d)
for p in ['annie_ready.rs','annie_ready.wgsl','integrate_annie_ready.py','recover_annie_ready.py','fix_annie_ready_blend.py','capture_annie_ready.py','capture_annie_ready_alphaadd.py','record_annie_ready.py']:shutil.copyfile(w/p,r/'tools'/p)
print('Recorded423core34client,98nativefields,4originaltextures,GPU10->0; visual fidelity unqualified; full goal active.')
