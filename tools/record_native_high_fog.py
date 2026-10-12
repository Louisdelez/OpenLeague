from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
tests=(r/'logs/native-high-fog-client-tests.log').read_text(encoding='utf-8');assert '240 passed; 0 failed' in tests
build=(r/'logs/native-high-fog-build.log').read_text(encoding='utf-8');assert 'Finished `dev` profile' in build
capture=load('docs/chaos_base_native_high_fog_capture.json')
assert capture['client_sha256']==hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert capture['capture_sha256']==hashlib.sha256(Path(capture['capture']).read_bytes()).hexdigest()
capture.update(visual_inspected=True,visual_observation='Terrain, environment and French HUD render. Cyan/blue edge gaps at Chaos base remain visible. No original-frame reference, no claim of full fidelity.')
save('docs/chaos_base_native_high_fog_capture.json',capture)
artifacts=['crates/client/src/native_high_fog.rs','crates/client/src/map_fog.rs','crates/client/src/terrain_material.rs','assets/shaders/environment_fow_vertex.wgsl','assets/shaders/terrain_fow_vertex.wgsl','assets/shaders/native_environment_fog.wgsl','assets/shaders/terrain_height_blend.wgsl','logs/native-high-fog-client-tests.log','docs/chaos_base_native_high_fog_capture.json']
action='Qualifier numériquement les nouveaux shaders de brouillard/nuages sur cas contrôlés au GPU, notamment interpolation sommet, alpha colormap, facteurs de vision, coordonnées et mipmaps. Profil courant Fog2 issu du PE ; dispatcher final des options et exclusions FULLBRIGHT/NOLIGHTING à qualifier. Vérifier les matériaux Blender correspondants et poursuivre le rendu/fond Chaos avec référence originale, sans inventer de géométrie. Ensuite cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
receipt=dict(updated_utc=now,complete=False,product_source_changed=True,client_tests_passed=240,
 native_cloud_runtime_gpu_integrated=True,native_high_fog_runtime_bound=True,
 current_profile='native PE initial Fog quality2: textured-opacity dual-layer',
 terrain_mesh_bindings=82,application_binary_sha256=capture['client_sha256'],capture=capture,
 gpu_numeric_fidelity_qualified=False,blender_high_fog_complete=False,chaos_base_background_complete=False,
 artifacts=artifacts,hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in artifacts},next_action=action,
 limits=['Native phase arithmetic executes through Rust; Bevy frame delta adapts two original clock queries. Original timing provider and phase startup/reset not fully qualified.',
 'Current implementation selects high fog profile from initial PE quality2; final option dispatch, low/vertex variants and FULLBRIGHT/NOLIGHTING exclusions remain incomplete.',
 'PNG recovery preserves base-level RGBA; full original DDS mip chain and actual original GPU sampling remain unqualified.',
 'Original shader formulas ported with vertex clamps/interpolation and cloud UV; complete numeric GPU comparison and original full-frame pass order remain open.',
 'Missing visibility data defaults to fully visible factors; initial original FoW state and all overlay modes remain incomplete.',
 'No new ordinary complete match/six graphical clients or original-frame fidelity proof. Chaos edge gaps still visible.',
 'Five old test-only FogExtension initializers updated after executable build; production code unchanged since capture.'])
save('docs/native_high_fog_progress.json',receipt)
archive=r/'docs/plan_history'/('native-high-fog-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_high_fog_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
  d['last_verified'].update(client_tests=240,client_sha256=capture['client_sha256'],native_cloud_runtime_gpu_integrated=True)
 else:d['current_evidence'].update(client_tests=240,client_sha256=capture['client_sha256'],native_cloud_runtime_gpu_integrated=True,native_high_fog_runtime_bound=True)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['integrate_native_high_fog.py','capture_native_high_fog_scene.py','record_native_high_fog.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard deux couches et nuages intégrés au moteur</h2><p>Nouveau client compilé, 240 tests réussis. Cloud2, phase Rust, opacité sommet, alpha colormap et brouillard deux couches liés aux matériaux terrain/environnement. Capture réelle inspectée : rendu fonctionnel, zones bleues au bord Chaos toujours présentes. Comparaison numérique GPU, fidélité complète, options et matériaux Blender encore ouverts.</p><a href="native_high_fog_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(client_tests=240,client_sha256=capture['client_sha256'],capture_inspected=True,high_fog_runtime=True,complete=False)))
