"""Check every installed native vertex-control byte against the recovered sidecar."""
from pathlib import Path
import base64,hashlib,json,struct,datetime
import numpy as np
r=Path(__file__).resolve().parents[1];raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();length=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+length]);blob=raw[28+length:]
source=json.loads((r/'docs/environment_vertex_source_validation.json').read_text());controls=json.loads((r/'data/4.20/environment_vertex_controls.json').read_text());factors=json.loads((r/'data/4.20/environment_lighting.json').read_text())['material_factors'];checked=vertices=0
assert hashlib.sha256(Path(source['native_nvr']).read_bytes()).hexdigest()==source['native_nvr_sha256']
assert hashlib.sha256(raw).hexdigest()==source['map_after_sha256']
for mesh in d['meshes']:
 if mesh.get('name') not in controls:continue
 c=controls[mesh['name']];p=mesh['primitives'][0];a=d['accessors'][p['attributes']['COLOR_0']];v=d['bufferViews'][a['bufferView']]
 installed=np.frombuffer(blob,dtype='<f4',count=a['count']*4,offset=v.get('byteOffset',0)+a.get('byteOffset',0)).reshape(-1,4)
 expected=np.frombuffer(base64.b64decode(c['primary_rgba']),dtype='u1').reshape(-1,4).astype(np.float32)/255.
 if c['secondary_rgba'] is not None:expected[:,:3]*=np.frombuffer(base64.b64decode(c['secondary_rgba']),dtype='u1').reshape(-1,4)[:,:3].astype(np.float32)/255.
 assert np.array_equal(installed,expected),mesh['name']
 assert factors[d['materials'][p['material']]['name']]==c['factor']
 assert a['count']==c['vertices'];checked+=1;vertices+=a['count']
assert checked==len(controls)==1971 and vertices==854890
proof={'passed':True,'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'map_sha256':hashlib.sha256(raw).hexdigest(),'native_nvr_sha256':source['native_nvr_sha256'],'control_sidecar_sha256':hashlib.sha256((r/'data/4.20/environment_vertex_controls.json').read_bytes()).hexdigest(),'meshes_checked':checked,'vertices_checked':vertices,'all_float32_controls_exact':True,'materials_checked':len(factors),'limits':['Exact installed controls and routing, not visual fidelity or full lighting shader qualification.','Sidecar extraction source is separately traced in environment_vertex_source_validation.json.']}
(r/'docs/environment_vertex_control_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(proof))
