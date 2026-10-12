"""Compare loaded Bevy meshes with installed native GLB buffers."""
from pathlib import Path
import json,struct,numpy as np,hashlib,datetime
r=Path(__file__).resolve().parents[1];raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();n=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+n]);blob=raw[28+n:];loaded=json.loads((r/'logs/native_vertex_loaded_meshes.json').read_text())
def access(i):
 a=d['accessors'][i];v=d['bufferViews'][a['bufferView']];cols={'VEC2':2,'VEC3':3,'VEC4':4,'SCALAR':1}[a['type']];typ={5126:'<f4',5125:'<u4',5123:'<u2'}[a['componentType']]
 return np.frombuffer(blob,dtype=typ,count=a['count']*cols,offset=v.get('byteOffset',0)+a.get('byteOffset',0)).reshape(-1,cols)
root=np.diag([.05,.05,-.05,1]);root[2,3]=15398.6719/20;rows=[]
for loaded_mesh in loaded:
 mesh=next(m for m in d['meshes'] if m.get('name')==loaded_mesh['mesh']);p=mesh['primitives'][0];attrs=p['attributes'];source_pos=access(attrs['POSITION']);bevy_pos=np.array(loaded_mesh['positions']);world=np.array(loaded_mesh['world_matrix']).reshape(4,4).T;pos0=np.column_stack([source_pos,np.ones(len(source_pos))])@root.T;pos1=np.column_stack([bevy_pos,np.ones(len(bevy_pos))])@world.T
 row={'mesh':loaded_mesh['mesh'],'source_vertices':len(source_pos),'loaded_vertices':len(bevy_pos),'maximum_world_position_error':float(np.max(np.abs(pos0-pos1))),'uvs_exact_float32':np.array_equal(access(attrs['TEXCOORD_0']),np.array(loaded_mesh['uv'],dtype=np.float32)),'colors_exact_float32':np.array_equal(access(attrs['COLOR_0']),np.array(loaded_mesh['colors'],dtype=np.float32)),'indices_exact':np.array_equal(access(p['indices']).reshape(-1),loaded_mesh['indices']),'native_material_factor':loaded_mesh['native_factor'],'diagnostic_channel':loaded_mesh['diagnostic_channel']};rows.append(row)
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'map_sha256':hashlib.sha256(raw).hexdigest(),'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'samples':rows,'limits':['Loaded geometry/material comparison; GPU visibility and native renderer equivalence not established.']};(r/'docs/environment_loaded_vertex_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(rows))
