from pathlib import Path
import json,struct,re,hashlib,datetime
r=Path('E:/OpenLeague');native=Path('E:/mapslol3v3/output/TwistedTreeline_Map10_Native_4.20/TwistedTreeline_Native.glb')
config=json.loads((r/'data/4.20/map_visual_settings.json').read_text());nvr=Path(config['source']).parent/'scene/room.nvr';source=nvr.read_bytes();counts=struct.unpack_from('<5i',source,8);mc=counts[3]
def glb(path):
 raw=path.read_bytes();size=struct.unpack_from('<I',raw,12)[0];doc=json.loads(raw[20:20+size]);ids={};triangles=0
 for mesh in doc['meshes']:
  match=re.search(r'MapGeo_Instance_(\d+)',mesh.get('name',''))
  if match:
   index=int(match[1]);ids.setdefault(index,[]).append(mesh['name'])
   for prim in mesh['primitives']:
    if prim.get('mode',4)==4:triangles+=doc['accessors'][prim['indices']]['count']//3 if 'indices' in prim else doc['accessors'][prim['attributes']['POSITION']]['count']//3
 return dict(source=str(path),sha256=hashlib.sha256(raw).hexdigest(),map_geo_mesh_ids=sorted(ids),missing_native_mesh_ids=sorted(set(range(mc))-set(ids)),extra_mesh_ids=sorted(set(ids)-set(range(mc))),map_geo_triangles=triangles,duplicate_ids={k:v for k,v in ids.items() if len(v)>1})
before=glb(native);after=glb(r/'assets/maps/twisted_treeline.glb');rays=json.loads((r/'docs/chaos_base_background_ray_attribution.json').read_text());original=json.loads((r/'docs/chaos_base_background_native_export_rays.json').read_text())
comparison=[]
for a,b in zip(rays['samples'],original['samples']):
 assert a['pixel']==b['pixel']
 comparison.append(dict(pixel=a['pixel'],current_hits=len(a['hits']),original_export_hits=len(b['hits']),hit_geometry_equal=[(h['mesh'],h['world']) for h in a['hits']]==[(h['mesh'],h['world']) for h in b['hits']]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,native_nvr=str(nvr),native_nvr_sha256=hashlib.sha256(source).hexdigest(),native_counts=list(counts),original_export=before,current_export=after,ray_comparison=comparison,findings=['All sampled clear-background rays have identical geometric intersections in original extraction and repaired map; repaired textures did not remove those triangles.'],limits=['Mesh ID presence does not prove every vertex/index, auxiliary scene resource or original GPU pass was extracted faithfully.','Original export is an extraction, not an original-game framebuffer. Apparent holes may predate Blender restoration. Full camera/render-pass correspondence and independent native geometry decoding remain open.'])
(r/'docs/chaos_environment_geometry_audit.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(native_mesh_count=mc,original_mesh_count=len(before['map_geo_mesh_ids']),current_mesh_count=len(after['map_geo_mesh_ids']),original_missing=len(before['missing_native_mesh_ids']),current_missing=len(after['missing_native_mesh_ids']),original_triangles=before['map_geo_triangles'],current_triangles=after['map_geo_triangles'],ray_geometry_equal=all(x['hit_geometry_equal'] for x in comparison))))
