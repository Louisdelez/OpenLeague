from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
test=(r/'logs/native-fog-profile-binding-tests.log').read_text(encoding='utf-8');assert '242 passed; 0 failed' in test
build=(r/'logs/native-fog-profile-binding-build.log').read_text(encoding='utf-8');assert 'Finished' in build and 'error:' not in build
gpu=load('logs/native-fog-profile-gpu.json');assert gpu['passed'] and gpu['cases']==864
capture=load('docs/chaos_base_native_fog_profile_capture.json');assert capture['visual_inspected']
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert sha('target/debug/openleague-client.exe')==capture['client_sha256']
artifacts=['crates/client/src/native_high_fog.rs','crates/client/src/map_fog.rs','crates/client/src/terrain_material.rs','assets/shaders/native_environment_fog.wgsl','assets/shaders/terrain_height_blend.wgsl','data/4.20/native_fog_profile_gpu_cases.json','logs/native-fog-profile-gpu.json','logs/native-fog-profile-binding-tests.log','logs/native-fog-profile-binding-build.log','target/debug/openleague-client.exe']
action='Qualifier identité et récupération de l’option835080, menu, mises à jour des variantes et exclusions FULLBRIGHT/NOLIGHTING. Profil Fog1/Fog2 lié aux shaders et matériaux ;242tests client et864cas GPU passent, exécutable reconstruit et aperçu Chaos inspecté au profil3. Qualité basse en frame complète, états de sampler, référence native et toutes les variantes restent ouverts. Puis cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
receipt=dict(updated_utc=now,complete=False,client_source_tests_passed=242,client_build_passed=True,profile_bound_to_materials=True,live_user_options_bound=False,default_profile=3,gpu=gpu,runtime=capture,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},limits=gpu['limits']+['Material synchronization test covers existing environment assets and future catalog; terrain synchronization is compiled and exercised at startup profile3 in the capture, no complete low-profile frame proved.','Profile enabled derives native Map10 config; complete initialization and option retrieval, callbacks, dynamic material routing/LOD/shadows and FULLBRIGHT/NOLIGHTING exclusions remain open.','Cloud phase timing preserved from prior adaptation; original clock/gating and whole-frame fidelity not proved.'],next_action=action)
save('docs/native_fog_profile_binding_progress.json',receipt)
archive=r/'docs/plan_history'/('native-fog-profile-bound-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_fog_profile_binding_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
 evidence.update(client_tests=242,client_sha256=capture['client_sha256'],client_tests_current_binary=True,native_fog_profile_bound_to_materials=True,native_fog_profile_gpu_cases=864)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Profils Fog1/Fog2 intégrés au rendu</h2><p>242 tests client et 864 cas GPU passent. Exécutable reconstruit et aperçu Chaos inspecté au profil natif3. Menu et variantes complètes restent à qualifier ; jeu incomplet.</p><a href="native_fog_profile_binding_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['bind_native_fog_profile.py','fix_fog_profile_binding_test.py','capture_native_fog_profile_scene.py','record_native_fog_profile_binding.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(client_tests=242,gpu_cases=864,client_sha256=capture['client_sha256'],complete=False)))
