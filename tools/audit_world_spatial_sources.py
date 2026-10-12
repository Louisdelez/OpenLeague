from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
load=lambda p:json.loads(Path(p).read_text(encoding='utf-8-sig'))
sources=['E:/mapslol3v3/output/TwistedTreeline_Animated_v3/asset_inventory.json','E:/mapslol3v3/output/Champions_4_20/import_inventory.json']
indexed={}
for source in sources:
 for row in load(source):
  name=row.get('name',row.get('asset','')).lower()
  if row.get('status')=='exported' and row.get('mesh'):indexed.setdefault(name,[]).append((source,row))
world=load(r/'data/4.20/world_animation_manifest.json');rows=[]
for name,entry in world.items():
 candidates=indexed.get(name.lower(),[])
 meshes=sorted(set(row['mesh'] for _,row in candidates))
 row=dict(name=name,render_asset=entry['asset'],render_asset_exists=(r/'assets'/entry['asset']).is_file(),render_scale=entry['scale'],mesh_candidates=meshes,source_inventories=sorted(set(source for source,_ in candidates)),ready_for_native_bounds_probe=False)
 if len(meshes)==1:
  mesh=Path(meshes[0]);row['mesh_exists']=mesh.is_file()
  if mesh.is_file():row['mesh_sha256']=hashlib.sha256(mesh.read_bytes()).hexdigest()
  configs=sorted(set(item['source_config'] for _,item in candidates if item.get('source_config')))
  # Record candidates only: selection/hierarchy and scalar reader must be qualified.
  if not configs:configs=[str(p) for p in [mesh.parent/'Skins/Base/Base.inibin',mesh.parent/(name+'.inibin')] if p.is_file()]
  row['config_candidates']=configs
  row['config_hashes']={c:hashlib.sha256(Path(c).read_bytes()).hexdigest() for c in configs if Path(c).is_file()}
  row['ready_for_native_bounds_probe']=row['mesh_exists'] and len(configs)==1 and len(row['config_hashes'])==1
 rows.append(row)
result=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,models=rows,limits=['Source association and file hashes only; no claim that model bounds, native configuration hierarchy, scale or NPC registration are implemented.','Unmatched or ambiguous assets remain unresolved. Render scale is catalog metadata, not proof of the native model scalar.'])
(r/'docs/world_spatial_source_audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(world_models=len(rows),unique_meshes=sum(len(row['mesh_candidates'])==1 for row in rows),ready_for_probe=sum(row['ready_for_native_bounds_probe'] for row in rows),unresolved=[row['name'] for row in rows if not row['ready_for_native_bounds_probe']])))
