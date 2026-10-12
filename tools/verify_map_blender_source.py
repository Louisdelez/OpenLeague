import bpy,json
from pathlib import Path
r=Path(__file__).resolve().parents[1];p=r/'artwork/maps/TwistedTreeline_OpenLeague.blend';bpy.ops.wm.open_mainfile(filepath=str(p));meshes=[o for o in bpy.data.objects if o.type=='MESH'];helpers=[o for o in meshes if not o.data.materials];proof=json.loads((r/'docs/map_blender_source_validation.json').read_text(encoding='utf-8'));proof['imported_render_mesh_objects']=sum(bool(o.data.materials) for o in meshes);proof['imported_render_triangles']=sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in meshes if o.data.materials);proof['generated_materialless_helpers']=[{'name':o.name,'polygons':len(o.data.polygons),'in_scene':o.name in bpy.context.scene.objects,'collections':[c.name for c in o.users_collection]} for o in helpers];proof['reopened_successfully']=True
(r/'docs/map_blender_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('BLENDER REOPEN VERIFIED',proof['imported_render_mesh_objects'],proof['imported_render_triangles'],len(helpers),flush=True)

settings=json.loads((r/'data/4.20/terrain_materials.json').read_text(encoding='utf-8'))
terrain_nodes=[]
for entry in settings['terrain_materials']:
 material=bpy.data.materials.get(entry['name']);assert material is not None
 assert abs(material['Native_half_blend_area']-settings['half_blend_area'])<1e-7
 textures=[n for n in material.node_tree.nodes if n.type=='TEX_IMAGE'];assert len(textures)==6
 assert all(n.image and n.image.packed_file for n in textures)
 terrain_nodes.append({'material':entry['name'],'nodes':len(material.node_tree.nodes),'packed_texture_nodes':len(textures),'half_blend_area':material['Native_half_blend_area']})
proof['native_terrain_node_materials']=terrain_nodes
(r/'docs/map_blender_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('BLENDER NATIVE TERRAIN NODE MATERIALS VERIFIED',len(terrain_nodes),flush=True)

fog_settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'))
fog_materials=[m for m in bpy.data.materials if m.name in fog_settings['environment_materials']]
assert len(fog_materials)==87,len(fog_materials)
assert all(m.get('Native_fog_low_layer') for m in fog_materials)
group=bpy.data.node_groups.get('Map10_Native_Opaque_Height_Fog');assert group is not None
textures=[n for n in group.nodes if n.type=='TEX_IMAGE'];assert len(textures)==1 and textures[0].image.packed_file
proof['native_low_fog_materials_verified']=len(fog_materials)
proof['native_low_fog_group_nodes']=len(group.nodes)
(r/'docs/map_blender_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('BLENDER LOW FOG MATERIALS VERIFIED',len(fog_materials),flush=True)

factors=json.loads((r/'data/4.20/environment_lighting.json').read_text())['material_factors']
for name,factor in factors.items():
 mat=bpy.data.materials.get(name);assert mat is not None
 assert mat['Native_vertex_lighting_factor']==factor
 assert any(n.type=='VERTEX_COLOR' and n.layer_name==mat['Native_vertex_control_layer'] for n in mat.node_tree.nodes)
# Blender validates the imported mesh and removes invalid or duplicate faces.
import struct,numpy as np,collections
raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();jl=struct.unpack_from('<I',raw,12)[0];g=json.loads(raw[20:20+jl]);blob=raw[28+jl:]
def read_accessor(idx):
 a=g['accessors'][idx];v=g['bufferViews'][a['bufferView']];cols={'SCALAR':1,'VEC3':3}[a['type']];typ={5126:'<f4',5125:'<u4',5123:'<u2'}[a['componentType']]
 return np.frombuffer(blob,dtype=typ,count=a['count']*cols,offset=v.get('byteOffset',0)+a.get('byteOffset',0)).reshape(a['count'],cols)
def signature(vertices):
 return tuple(sorted(tuple(round(float(x),4) for x in v) for v in vertices))
removed=[]
for mesh in g['meshes']:
 if not mesh.get('name','').startswith('MapGeo_Instance_'):continue
 obj=bpy.data.objects.get(mesh['name']);assert obj is not None
 p0=mesh['primitives'][0];ids=read_accessor(p0['indices']).reshape(-1,3)
 if len(ids)==len(obj.data.polygons):continue
 pos=read_accessor(p0['attributes']['POSITION']);native=collections.Counter(signature(v) for v in pos[ids])
 imported=collections.Counter(signature([(obj.data.vertices[i].co.x,obj.data.vertices[i].co.z,-obj.data.vertices[i].co.y) for i in poly.vertices]) for poly in obj.data.polygons)
 assert not imported-native,mesh['name']
 missing=native-imported
 for face,count in missing.items():
  v=np.array(face);degenerate=np.linalg.norm(np.cross(v[1]-v[0],v[2]-v[0]))<1e-4
  duplicate=imported[face]>0
  assert degenerate or duplicate,(mesh['name'],face)
  removed.append({'mesh':mesh['name'],'triangles':count,'degenerate':bool(degenerate),'duplicate':duplicate})
assert sum(x['triangles'] for x in removed)==62,removed
assert proof['imported_render_triangles']==1013104-62,proof['imported_render_triangles']
proof['native_glb_triangles']=1013104
proof['blender_validation_removed_faces']=removed
proof['blender_import_limit']='Blender mesh.validate removes 62 degenerate/duplicate faces; native GLB retains original native indices.'

proof['native_vertex_lighting_materials_verified']=len(factors)
(r/'docs/map_blender_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('BLENDER NATIVE VERTEX LIGHTING VERIFIED',len(factors),flush=True)
