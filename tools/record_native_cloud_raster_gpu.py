from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
filter=load('logs/native-cloud-filter-gpu.json');raster=load('logs/native-high-fog-raster-gpu.json')
assert filter['passed'] and filter['cases']==128 and raster['passed'] and raster['rasterized_cases']==85
assert raster['actual_map_triangle_cases']==64 and raster['perspective_cases']==14
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();assert binary=='37de22a9aac32ce4c77ffdee498fc6019e4169ebd1dfebaa7074b556ccbb1f32'
cases=load('data/4.20/native_cloud_filter_gpu_cases.json');assert cases['asset_sha256']==hashlib.sha256((r/cases['asset']).read_bytes()).hexdigest()
action='Répercuter le brouillard haut et Cloud2 dans les matériaux Blender de la carte restaurée, puis qualifier le producteur des options Fog/profile et les exclusions FULLBRIGHT/NOLIGHTING du rendu. Les128cas de filtrage GPU BC1 explicite et85cas raster de brouillard passent ; dérivées de mip, caméra réelle, état complet des samplers et référence originale de la base Chaos restent ouverts. Poursuivre cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et tous les24domaines.'
artifacts=['data/4.20/native_cloud_filter_gpu_cases.json','data/4.20/native_high_fog_raster_cases.json','logs/native-cloud-filter-gpu.json','logs/native-high-fog-raster-gpu.json']
receipt=dict(updated_utc=now,complete=False,passed=True,cloud_filter_gpu_cases=128,high_fog_raster_cases=85,
 actual_map_height_triangle_cases=64,perspective_triangle_cases=14,
 controlled_explicit_lod_filter_qualified=True,controlled_vertex_fragment_interpolation_qualified=True,
 implicit_lod_full_frame_qualified=False,original_frame_fidelity_qualified=False,
 filter=filter,raster=raster,production_runtime_source_changed=False,application_binary_unchanged=True,application_binary_sha256=binary,
 artifacts=artifacts,hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in artifacts},limits=filter['limits']+raster['limits'],next_action=action)
save('docs/native_cloud_raster_gpu_progress.json',receipt)
archive=r/'docs/plan_history'/('native-cloud-raster-gpu-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_cloud_raster_gpu_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[]);d['last_verified'].update(cloud_filter_gpu_cases=128,high_fog_raster_cases=85)
 else:d['current_evidence'].update(cloud_filter_gpu_cases=128,high_fog_raster_cases=85)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['prepare_cloud_filter_gpu_probe.py','cloud_filter_gpu.rs','prepare_high_fog_raster_probe.py','high_fog_raster_gpu.rs','record_native_cloud_raster_gpu.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Filtrage Cloud2 et interpolation du brouillard vérifiés</h2><p>128 cas de filtrage BC1 et 11 mipmaps sur Vulkan : écart maximal 1/255, tolérance 2/255. 85 triangles rasterisés dont 64 triples de hauteurs de la carte et 14 perspectives : écart maximal 8,35e-7. Ces sondes contrôlées ne valident pas les dérivées de la frame normale, le profil final ni le jeu complet.</p><a href="native_cloud_raster_gpu_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(filter_cases=128,raster_cases=85,passed=True,binary_unchanged=True,complete=False)))
