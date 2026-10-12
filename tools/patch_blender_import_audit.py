from pathlib import Path
r=Path('E:/OpenLeague');p=r/'tools/verify_map_blender_source.py';s=p.read_text(encoding='utf-8');s=s.replace("assert proof['imported_render_triangles']==1013104,proof['imported_render_triangles']",'''# Blender validates the imported mesh and removes invalid or duplicate faces.
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
''');p.write_text(s,encoding='utf-8')
