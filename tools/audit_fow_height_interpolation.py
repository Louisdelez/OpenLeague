from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague');raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();length=struct.unpack_from('<I',raw,12)[0];g=json.loads(raw[20:20+length]);blob=raw[28+length:]
allowed=set(json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'))['environment_materials']);rows=[];checked=0;differs=0;maximum=0.
fade=lambda y:max(0.,min(1.,y*struct.unpack('<f',struct.pack('<I',0x3c23d70a))[0]+10.))
for mesh in g['meshes']:
 for p in mesh['primitives']:
  material=g['materials'][p['material']].get('name','')
  if material not in allowed or p.get('mode',4)!=4:continue
  a=g['accessors'][p['attributes']['POSITION']];v=g['bufferViews'][a['bufferView']];o=v.get('byteOffset',0)+a.get('byteOffset',0);stride=v.get('byteStride',12);ys=[struct.unpack_from('<f',blob,o+i*stride+4)[0] for i in range(a['count'])]
  a=g['accessors'][p['indices']];v=g['bufferViews'][a['bufferView']];o=v.get('byteOffset',0)+a.get('byteOffset',0);fmt={5121:'B',5123:'H',5125:'I'}[a['componentType']];stride=struct.calcsize('<'+fmt);ids=struct.unpack_from('<'+fmt*a['count'],blob,o)
  for i in range(0,len(ids),3):
   y=[ys[k] for k in ids[i:i+3]];vertex_then_interpolate=sum(map(fade,y))/3;fragment_then_clamp=fade(sum(y)/3);delta=abs(vertex_then_interpolate-fragment_then_clamp);checked+=1
   if delta>1e-6:
    differs+=1;maximum=max(maximum,delta)
    if len(rows)<8:rows.append({'mesh':mesh.get('name'),'material':material,'triangle':i//3,'native_vertex_y':y,'centroid_original_vertex_fade':vertex_then_interpolate,'centroid_current_fragment_fade':fragment_then_clamp,'difference':delta})
native=r/'data/4.20/shaders/FogOfWar/FogOfWar_VS.hls';source=native.read_text(encoding='utf-8');assert 'result.w = saturate(worldPosition.y * FOG_OF_WAR_ALWAYS_BELOW_Y.z + FOG_OF_WAR_ALWAYS_BELOW_Y.w);' in source
proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'map_sha256':hashlib.sha256(raw).hexdigest(),'native_shader_sha256':hashlib.sha256(native.read_bytes()).hexdigest(),'checked_triangles':checked,'centroid_difference_triangles':differs,'maximum_centroid_factor_difference':maximum,'examples':rows,'finding':'Original vertex shader clamps height factor before interpolation; current fragment reconstruction clamps interpolated world height. Straddling triangles differ.','next_action':'Transmit native clamped height factors through vertex outputs rather than recomputing clamp in fragment shaders. Actor base factors do not consume height.','limits':['Analytical barycentric centroid audit of actual routed position/index buffers; no framebuffer attribution or original D3D execution.']}
(r/'docs/fow_height_interpolation_audit.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k!='examples'}))
