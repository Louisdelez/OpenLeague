"""CPU diagnostic ray attribution for the current spawn camera; not a rendering verifier."""
import json,struct,io
from pathlib import Path
import numpy as np
from PIL import Image
r=Path(__file__).resolve().parents[1];raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();n=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+n]);binary=raw[28+n:]
def accessor(index):
 a=d['accessors'][index];v=d['bufferViews'][a['bufferView']];dtype={5126:'<f4',5125:'<u4',5123:'<u2',5121:'u1'}[a['componentType']];dims={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4}[a['type']];size=np.dtype(dtype).itemsize
 return np.ndarray((a['count'],dims),dtype=dtype,buffer=binary,offset=v.get('byteOffset',0)+a.get('byteOffset',0),strides=(v.get('byteStride',size*dims),size)).copy()
def transform(node):
 if 'matrix' in node:return np.array(node['matrix']).reshape(4,4).T
 x,y,z,w=node.get('rotation',[0,0,0,1]);m=np.eye(4);m[:3,:3]=np.array([[1-2*(y*y+z*z),2*(x*y-z*w),2*(x*z+y*w)],[2*(x*y+z*w),1-2*(x*x+z*z),2*(y*z-x*w)],[2*(x*z-y*w),2*(y*z+x*w),1-2*(x*x+y*y)]])@np.diag(node.get('scale',[1,1,1]));m[:3,3]=node.get('translation',[0,0,0]);return m
root_matrix=np.diag([.05,.05,-.05,1.]);root_matrix[2,3]=15398.6719/20
triangles=[];uvs=[];materials=[];names=[]
def visit(index,parent):
 node=d['nodes'][index];world=parent@transform(node)
 if 'mesh' in node:
  mesh=d['meshes'][node['mesh']]
  for p in mesh['primitives']:
   if p.get('mode',4)!=4:continue
   pos=accessor(p['attributes']['POSITION']);indices=accessor(p['indices']).reshape(-1,3) if 'indices' in p else np.arange(len(pos)).reshape(-1,3)
   points=(np.column_stack([pos,np.ones(len(pos))])@world.T)[:,:3]
   triangles.append(points[indices]);uvs.append(accessor(p['attributes']['TEXCOORD_0'])[indices]);materials.extend([p['material']]*len(indices));names.extend([node.get('name','')]*len(indices))
 for child in node.get('children',[]):visit(child,world)
for node in d['scenes'][0]['nodes']:visit(node,root_matrix)
triangles=np.concatenate(triangles);uvs=np.concatenate(uvs);v0=triangles[:,0];e1=triangles[:,1]-v0;e2=triangles[:,2]-v0
spawn=json.loads((r/'data/4.20/champion_spawns_map10.json').read_text(encoding='utf-8'))[0]['point'];focus=np.array([spawn['x']/20,151.0460662841797/20,spawn['z']/20]);eye=focus+np.array([0,340,265]);forward=(focus-eye)/np.linalg.norm(focus-eye);right=np.cross(forward,[0,1,0]);right/=np.linalg.norm(right);up=np.cross(right,forward)
images={};results=[]
for pixel in [(1190,180),(1120,200),(1220,160),(1230,260),(1100,160),(650,440)]:
 x,y=pixel;direction=forward+right*((2*(x+.5)/1280-1)*np.tan(np.pi/8)*1.6)+up*((1-2*(y+.5)/800)*np.tan(np.pi/8));direction/=np.linalg.norm(direction)
 h=np.cross(direction,e2);det=np.einsum('ij,ij->i',e1,h);valid=np.abs(det)>1e-8;inv=np.divide(1,det,out=np.zeros_like(det),where=valid);s=eye-v0;u=inv*np.einsum('ij,ij->i',s,h);q=np.cross(s,e1);v=inv*np.einsum('j,ij->i',direction,q);distance=inv*np.einsum('ij,ij->i',e2,q);valid&=(u>=0)&(v>=0)&(u+v<=1)&(distance>0)
 hits=[]
 for i in sorted(np.flatnonzero(valid),key=lambda i:distance[i])[:12]:
  m=d['materials'][materials[i]];coord=uvs[i,0]*(1-u[i]-v[i])+uvs[i,1]*u[i]+uvs[i,2]*v[i];texture=m['pbrMetallicRoughness']['baseColorTexture']['index'];source=d['textures'][texture]['source']
  if source not in images:
   view=d['bufferViews'][d['images'][source]['bufferView']];offset=view.get('byteOffset',0);images[source]=Image.open(io.BytesIO(binary[offset:offset+view['byteLength']])).convert('RGBA')
  image=images[source];rgba=image.getpixel((int((coord[0]%1)*image.width)%image.width,int((coord[1]%1)*image.height)%image.height))
  hits.append({'mesh':names[i],'material':m['name'],'distance':float(distance[i]),'uv':coord.tolist(),'png_nearest_rgba':rgba,'alpha_mode':m.get('alphaMode'),'alpha_cutoff':m.get('alphaCutoff',0.5)})
 results.append({'pixel':pixel,'hits':hits})
import datetime,hashlib
frame=r/'logs/exhaust-render.png';image=Image.open(frame).convert('RGB')
for row in results:
    row['observed_rgb']=image.getpixel(tuple(row['pixel']))
    visible=next((h for h in row['hits'] if h['alpha_mode']!='MASK' or h['png_nearest_rgba'][3]/255>=h['alpha_cutoff']),None)
    if visible:
        row['closest_visible_material']=visible['material']
        row['rgb_sample_error']=max(abs(a-b) for a,b in zip(visible['png_nearest_rgba'][:3],row['observed_rgb']))
proof={'triangles':len(triangles),'diagnostic':results,'map_sha256':hashlib.sha256(raw).hexdigest(),'frame':str(frame),'frame_sha256':hashlib.sha256(frame.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'bright_geometry_diagnosis':'Native foreground spider webs, not missing branch textures.','limits':['CPU static ray attribution assumes current initial spawn camera and ignores actors/animated emitters.','Frame predates decal/fog repair; attributed foreground web geometry/UVs/textures are unchanged.','Nearest texture samples within three RGB units of frame are diagnostic corroboration, not a pixel-perfect renderer acceptance.']}
assert all(row.get('rgb_sample_error',999)<=3 for row in results)
(r/'docs/map_web_geometry_diagnostic.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'triangles':len(triangles),'matched_samples':len(results),'maximum_nearest_rgb_error':max(row['rgb_sample_error'] for row in results)}))
