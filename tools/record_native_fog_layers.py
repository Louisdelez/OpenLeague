from pathlib import Path
import json,datetime,shutil,hashlib
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
macros=load('data/4.20/native_fog_macros_contract.json');cloud=load('data/4.20/native_cloud_opacity_contract.json')
assert macros['passed'] and len(macros['cases'])==12 and cloud['passed'] and cloud['rgba_pixels_exact']
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert binary=='d802f486c1f1318cab03f6f838c49961f2c1a11cb73c9654253bbda4a13153d2'
archive=r/'docs/plan_history'/('native-fog-layers-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
p='data/4.20/map_fog_settings.json';shutil.copy2(r/p,archive/'map_fog_settings.json');d=load(p)
d['policy']='Opaque far-height fog integrated. Native top-layer opacity is not identically zero: at opacity1 it equals1-heightFog for Map10 radial coefficients. Native PE initial fog quality2 selects dual-layer textured-opacity fog; clouds/high layer still pending runtime integration.'
d['native_macro_contract']='data/4.20/native_fog_macros_contract.json';d['native_cloud_contract']='data/4.20/native_cloud_opacity_contract.json';save(p,d)
p=r/'tools/recover_native_fog.py';shutil.copy2(p,archive/'recover_native_fog.py');s=p.read_text(encoding='utf-8')
old='Apply native opaque-height fog layer to environment/terrain; top-layer opacity is identically zero for this native Map10 radial configuration.'
assert old in s;s=s.replace(old,d['policy']);p.write_text(s,encoding='utf-8')
receipt=dict(updated_utc=now,complete=False,runtime_rendering_changed=False,application_binary_unchanged=True,application_binary_sha256=binary,
 native_fog_macro_cases=12,initial_pe_fog_quality=2,cloud_native_config_requests=3,cloud_texture_dimensions=cloud['dimensions'],cloud_texture_rgba_exact=True,
 artifacts=['data/4.20/native_fog_macros_contract.json','data/4.20/native_cloud_opacity_contract.json','assets/maps/terrain_native/cloudOpacityMap.png'],
 findings=['Separate native fog quality selects vertex/single-layer/dual-layer routes. Macro constructor uses unsigned comparison for textured-opacity quality>=2.',
 'Native-loaded Map10 clouds config consumer confirms Tile2000 and SpeedU/SpeedV0.01. Original Cloud2 DDS recovered and PNG pixels preserved in converter.',
 'Previous claim of identically zero top fog corrected in settings policy and generator. Rendering shader still only applies far-height layer.'],
 limits=macros['limits']+cloud['limits']+['No new client build or screenshot; previous inspected gamma/UTF8 capture retained. Required background rendering remains open.','Blender packed source has not been regenerated with the cloud/high fog layer.'])
action='Qualifier le producteur de coordonnées/temps des nuages0x73a850, les états de sampler s7 et la fusion des macros globales de brouillard. Puis intégrer le brouillard à deux couches et la texture native Cloud2 dans les shaders terrain/environnement, en respectant interpolation sommet, colormap alpha et couplage vision ; compiler et inspecter une nouvelle capture. Zones de fond Chaos toujours ouvertes. Ensuite cérémonie/audio/sbires, reconnexion/launcher et six clients graphiques ; poursuivre les24domaines.'
receipt['next_action']=action;save('docs/native_fog_layers_progress.json',receipt)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_fog_layers_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
  d['last_verified'].update(native_fog_macro_cases=12,native_cloud_config_fields=3,native_cloud_texture_recovered=True)
 else:d['current_evidence'].update(native_fog_macro_cases=12,native_cloud_config_fields=3,native_cloud_texture_recovered=True,native_high_fog_runtime_integrated=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['qualify_native_fog_macros.py','inspect_native_fog_quality.py','locate_native_fog_macros.py','inspect_cloud_configuration.py','recover_native_cloud_opacity.py','record_native_fog_layers.py','inspect_environment_fog_routes.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Variantes de brouillard et texture de nuages retrouvées</h2><p>12cas natifs de sélection vérifiés ; qualité initiale2. Paramètres Tile2000, SpeedU/SpeedV0.01 chargés par le consommateur original. Texture Cloud2 récupérée, 1024×1024 pixels RGBA préservés. Couche haute, temps/UV et sampler encore à intégrer et qualifier. Jeu incomplet.</p><a href="native_fog_layers_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(macro_cases=12,config_fields=3,cloud_dimensions=cloud['dimensions'],binary_unchanged=True,complete=False)))
