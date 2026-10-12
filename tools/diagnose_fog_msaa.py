"""CPU diagnostic ray attribution for the current spawn camera; not a rendering verifier."""
import json,struct,io,os
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
triangles=[];uvs=[];uvs1=[];materials=[];names=[]
def visit(index,parent):
 node=d['nodes'][index];world=parent@transform(node)
 if 'mesh' in node:
  mesh=d['meshes'][node['mesh']]
  for p in mesh['primitives']:
   if p.get('mode',4)!=4:continue
   pos=accessor(p['attributes']['POSITION']);indices=accessor(p['indices']).reshape(-1,3) if 'indices' in p else np.arange(len(pos)).reshape(-1,3)
   points=(np.column_stack([pos,np.ones(len(pos))])@world.T)[:,:3]
   triangles.append(points[indices]);uvs1.append(accessor(p['attributes']['TEXCOORD_1'])[indices] if 'TEXCOORD_1' in p['attributes'] else np.zeros((len(indices),3,2)));uvs.append(accessor(p['attributes']['TEXCOORD_0'])[indices]);materials.extend([p['material']]*len(indices));names.extend([node.get('name','')]*len(indices))
 for child in node.get('children',[]):visit(child,world)
for node in d['scenes'][0]['nodes']:visit(node,root_matrix)
triangles=np.concatenate(triangles);uvs=np.concatenate(uvs);uvs1=np.concatenate(uvs1);v0=triangles[:,0];e1=triangles[:,1]-v0;e2=triangles[:,2]-v0
spawn=json.loads((r/'data/4.20/champion_spawns_map10.json').read_text(encoding='utf-8'))[0]['point'];focus=np.array([spawn['x']/20,151.0460662841797/20,spawn['z']/20]);focus=np.array([float(x) for x in os.environ['OPENLEAGUE_RENDER_FOCUS'].split(',')]) if 'OPENLEAGUE_RENDER_FOCUS' in os.environ else focus;eye=focus+np.array([0,340,265]);forward=(focus-eye)/np.linalg.norm(focus-eye);right=np.cross(forward,[0,1,0]);right/=np.linalg.norm(right);up=np.cross(right,forward)
images={};results=[]
for pixel in [(750+dx-.5,320+dy-.5) for dx,dy in [(.375,.125),(.875,.375),(.125,.625),(.625,.875)]]:
 x,y=pixel;direction=forward+right*((2*(x+.5)/1280-1)*np.tan(np.pi/8)*1.6)+up*((1-2*(y+.5)/800)*np.tan(np.pi/8));direction/=np.linalg.norm(direction)
 h=np.cross(direction,e2);det=np.einsum('ij,ij->i',e1,h);valid=np.abs(det)>1e-8;inv=np.divide(1,det,out=np.zeros_like(det),where=valid);s=eye-v0;u=inv*np.einsum('ij,ij->i',s,h);q=np.cross(s,e1);v=inv*np.einsum('j,ij->i',direction,q);distance=inv*np.einsum('ij,ij->i',e2,q);valid&=(u>=0)&(v>=0)&(u+v<=1)&(distance>0)
 hits=[]
 for i in sorted(np.flatnonzero(valid),key=lambda i:distance[i])[:12]:
  m=d['materials'][materials[i]];coord=uvs[i,0]*(1-u[i]-v[i])+uvs[i,1]*u[i]+uvs[i,2]*v[i];coord1=uvs1[i,0]*(1-u[i]-v[i])+uvs1[i,1]*u[i]+uvs1[i,2]*v[i];texture=m['pbrMetallicRoughness']['baseColorTexture']['index'];source=d['textures'][texture]['source']
  if source not in images:
   view=d['bufferViews'][d['images'][source]['bufferView']];offset=view.get('byteOffset',0);images[source]=Image.open(io.BytesIO(binary[offset:offset+view['byteLength']])).convert('RGBA')
  image=images[source];a=np.asarray(image,dtype=float);xy=coord*[image.width,image.height]-.5;ij=np.floor(xy).astype(int);f=xy-ij;rgba=a[ij[1]%image.height,ij[0]%image.width]*(1-f[0])*(1-f[1])+a[ij[1]%image.height,(ij[0]+1)%image.width]*f[0]*(1-f[1])+a[(ij[1]+1)%image.height,ij[0]%image.width]*(1-f[0])*f[1]+a[(ij[1]+1)%image.height,(ij[0]+1)%image.width]*f[0]*f[1];rgba=rgba.tolist()
  hits.append({'mesh':names[i],'material':m['name'],'distance':float(distance[i]),'world':(eye+direction*distance[i]).tolist(),'uv':coord.tolist(),'uv1':coord1.tolist(),'png_bilinear_rgba':rgba,'alpha_mode':m.get('alphaMode'),'alpha_cutoff':m.get('alphaCutoff',0.5)})
 results.append({'pixel':pixel,'hits':hits})



for row in results:
 print('MSAA_SUBPIXEL',row['pixel'],[(h['material'],h['distance'],h['world'][1]*20,h['png_bilinear_rgba']) for h in row['hits'][:5]])
