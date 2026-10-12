from pathlib import Path
import json,datetime,shutil,hashlib
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit=load('docs/chaos_environment_geometry_audit.json');rays=load('docs/chaos_base_background_ray_attribution.json');assert len(rays['samples'])==8
assert all(x['hit_geometry_equal'] for x in audit['ray_comparison']);assert not audit['current_export']['missing_native_mesh_ids']
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();assert binary==load('docs/native_nexus_skin_progress.json')['files_sha256']['target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,application_binary_unchanged=True,product_changed=False,native_nvr_mesh_count=2351,current_map_geo_mesh_ids=2351,original_map_geo_mesh_ids=2351,native_mesh_ids_missing=0,ray_samples=8,ray_samples_without_geometry=7,ray_geometry_equal_to_original_export=True,map_geo_triangles_original=929456,map_geo_triangles_current=929448,triangle_difference_unqualified=8,artifacts=['docs/chaos_base_background_ray_attribution.json','docs/chaos_base_background_native_export_rays.json','docs/chaos_environment_geometry_audit.json'],limits=audit['limits']+rays['limits'],next_action='Décoder indépendamment les triangles NVR aux frontières Chaos et qualifier les objets room.dsc/autres ressources de fond et les passes/caméra sur une nouvelle capture sans écran de victoire. Ne pas ajouter un sol inventé ni recolorer le fond pour masquer les lacunes.')
save('docs/chaos_geometry_progress.json',receipt)
archive=r/'docs/plan_history'/('chaos-geometry-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,chaos_geometry_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=receipt['next_action']);d['last_verified'].update(chaos_background_ray_samples=8,native_environment_mesh_ids_present=2351)
 else:d['current_evidence'].update(chaos_background_ray_samples=8,native_environment_mesh_ids_present=2351,chaos_base_visual_defect_fixed=False)
 if name=='completion_plan.json':d['next_execution_steps']=[receipt['next_action']]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['attribute_chaos_base_background.py','audit_chaos_environment_geometry.py','record_chaos_geometry_progress.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Base Chaos : attribution géométrique</h2><p>8rayons :7sans triangle,1buisson transparent. Intersections identiques dans les exports initial et restauré.2351identifiants NVR présents dans chacun ;8triangles de différence restent à qualifier. Aucun changement du jeu. Audit des triangles natifs/objets auxiliaires/passes à poursuivre.</p><a href="chaos_geometry_progress.json">Diagnostic et limites</a></section></body>'),encoding='utf-8')
print(json.dumps(dict(ray_samples=8,native_mesh_ids_present=2351,binary_unchanged=True,complete=False)))
