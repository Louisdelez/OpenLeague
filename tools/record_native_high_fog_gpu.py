from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
blend=load('logs/native-high-fog-arithmetic-gpu.json');vertex=load('logs/native-high-fog-vertex-gpu.json')
assert blend['passed'] and blend['cases']==1080 and vertex['passed'] and vertex['cases']==360
for name in ['native_high_fog_gpu_cases.json','native_high_fog_vertex_gpu_cases.json']:
 for p,digest in load('data/4.20/'+name)['production_shader_hashes'].items():assert hashlib.sha256((r/p).read_bytes()).hexdigest()==digest
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();assert binary=='37de22a9aac32ce4c77ffdee498fc6019e4169ebd1dfebaa7074b556ccbb1f32'
action='Qualifier le filtrage réel Cloud2 BC1/mipmaps et l’interpolation perspective des valeurs de brouillard sur triangles rasterisés, avec cas contrôlés. Les1080cas de mélange et360cas de sommet des deux shaders passent Vulkan ; textureSample est adapté dans ces sondes. Profil/options finaux, exclusions FULLBRIGHT/NOLIGHTING, matériaux Blender et référence de rendu Chaos restent ouverts. Puis cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_high_fog_gpu_cases.json','data/4.20/native_high_fog_vertex_gpu_cases.json','logs/native-high-fog-arithmetic-probe.wgsl','logs/native-high-fog-vertex-probe.wgsl','logs/native-high-fog-arithmetic-gpu.json','logs/native-high-fog-vertex-gpu.json']
receipt=dict(updated_utc=now,complete=False,passed=True,production_shader_body_gpu_arithmetic_qualified=True,
 blend_gpu_cases=1080,vertex_gpu_cases=360,total_channels_checked=11520,blend=blend,vertex=vertex,
 production_runtime_source_changed=False,application_binary_unchanged=True,application_binary_sha256=binary,
 physical_cloud_filter_qualified=False,perspective_interpolation_qualified=False,
 artifacts=artifacts,hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in artifacts},limits=blend['limits']+vertex['limits'],next_action=action)
save('docs/native_high_fog_gpu_progress.json',receipt)
archive=r/'docs/plan_history'/('native-high-fog-gpu-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_high_fog_gpu_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[]);d['last_verified'].update(high_fog_blend_gpu_cases=1080,high_fog_vertex_gpu_cases=360)
 else:d['current_evidence'].update(high_fog_blend_gpu_cases=1080,high_fog_vertex_gpu_cases=360)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['prepare_high_fog_gpu_probe.py','prepare_high_fog_vertex_gpu_probe.py','high_fog_arithmetic_gpu.rs','record_native_high_fog_gpu.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Calculs du brouillard vérifiés sur Vulkan</h2><p>1 080 cas de mélange et 360 cas de sommet, pour les chemins terrain/environnement extraits des shaders de production. Écarts maximaux : 2,09e-7 et 4,77e-7, sous tolérance 2e-6. Données de texture et positions contrôlées ; filtrage réel, projection et interpolation perspective encore à qualifier. Le jeu complet reste inachevé.</p><a href="native_high_fog_gpu_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(blend_cases=1080,vertex_cases=360,channels=11520,passed=True,complete=False)))
