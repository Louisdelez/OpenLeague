"""CPU diagnostic ray attribution for the current spawn camera; not a rendering verifier."""
import json,struct,io,os
from pathlib import Path
import numpy as np
from PIL import Image
r=Path(__file__).resolve().parents[1];raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();n=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+n]);binary=raw[28+n:]
def accessor(index):
 a=d['accessors'][index];v=d['bufferViews'][a['bufferView']];dtype={5126:'<f4',5125:'<u4',5123:'<u2',5121:'u1'}[a['componentType']];dims={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4,'MAT4':16}[a['type']];size=np.dtype(dtype).itemsize
 return np.ndarray((a['count'],dims),dtype=dtype,buffer=binary,offset=v.get('byteOffset',0)+a.get('byteOffset',0),strides=(v.get('byteStride',size*dims),size)).copy()
def transform(node):
 if 'matrix' in node:return np.array(node['matrix']).reshape(4,4).T
 x,y,z,w=node.get('rotation',[0,0,0,1]);m=np.eye(4);m[:3,:3]=np.array([[1-2*(y*y+z*z),2*(x*y-z*w),2*(x*z+y*w)],[2*(x*y+z*w),1-2*(x*x+z*z),2*(y*z-x*w)],[2*(x*z-y*w),2*(y*z+x*w),1-2*(x*x+y*y)]])@np.diag(node.get('scale',[1,1,1]));m[:3,3]=node.get('translation',[0,0,0]);return m
root_matrix=np.diag([.05,.05,-.05,1.]);root_matrix[2,3]=15398.6719/20
node_world={}
def collect_world(index,parent):
 node=d['nodes'][index];world=parent@transform(node);node_world[index]=world
 for child in node.get('children',[]):collect_world(child,world)
for index in d['scenes'][0]['nodes']:collect_world(index,root_matrix)
skinned_nodes=[]
# Runtime replaces these embedded meshes with independently animated native models.
# Static CPU rays can qualify the environment-only frame, not moving ambient geometry.
assert os.environ.get('OPENLEAGUE_PROBE_ENV_ONLY')=='1', 'Use an actual environment-only frame; animated ambient occlusion is not modeled'
hidden_roots=set(json.loads((r/'data/4.20/map_ambient_manifest.json').read_text(encoding='utf-8'))['hidden_embedded_roots'])
suppressed_roots=[]

triangles=[];uvs=[];uvs1=[];materials=[];names=[]
def visit(index,parent):
 node=d['nodes'][index];world=parent@transform(node)
 if node.get('name') in hidden_roots:
  suppressed_roots.append(node['name']);return
 if 'mesh' in node:
  mesh=d['meshes'][node['mesh']]
  for p in mesh['primitives']:
   if p.get('mode',4)!=4:continue
   pos=accessor(p['attributes']['POSITION']);indices=accessor(p['indices']).reshape(-1,3) if 'indices' in p else np.arange(len(pos)).reshape(-1,3)
   points=(np.column_stack([pos,np.ones(len(pos))])@world.T)[:,:3]
   if 'skin' in node:
    skin=d['skins'][node['skin']];inverse=accessor(skin['inverseBindMatrices']).reshape(-1,4,4).transpose(0,2,1);joints=accessor(p['attributes']['JOINTS_0']).astype(int);weights=accessor(p['attributes']['WEIGHTS_0']).astype(float)
    assert not d['accessors'][p['attributes']['WEIGHTS_0']].get('normalized',False),'Implement normalized weights before qualification'
    matrices=np.array([node_world[j]@inverse[k] for k,j in enumerate(skin['joints'])]);weighted=np.einsum('nq,nqij->nij',weights,matrices[joints]);points=np.einsum('nij,nj->ni',weighted,np.column_stack([pos,np.ones(len(pos))]))[:,:3];skinned_nodes.append(node.get('name',''))
   triangles.append(points[indices]);uvs1.append(accessor(p['attributes']['TEXCOORD_1'])[indices] if 'TEXCOORD_1' in p['attributes'] else np.zeros((len(indices),3,2)));uvs.append(accessor(p['attributes']['TEXCOORD_0'])[indices]);materials.extend([p['material']]*len(indices));names.extend([node.get('name','')]*len(indices))
 for child in node.get('children',[]):visit(child,world)
for node in d['scenes'][0]['nodes']:visit(node,root_matrix)
triangles=np.concatenate(triangles);uvs=np.concatenate(uvs);uvs1=np.concatenate(uvs1);v0=triangles[:,0];e1=triangles[:,1]-v0;e2=triangles[:,2]-v0
spawn=json.loads((r/'data/4.20/champion_spawns_map10.json').read_text(encoding='utf-8'))[0]['point'];focus=np.array([spawn['x']/20,151.0460662841797/20,spawn['z']/20]);focus=np.array([float(x) for x in os.environ.get('OPENLEAGUE_RENDER_FOCUS','370,5,385').split(',')]);eye=focus+np.array([0,340,265]);forward=(focus-eye)/np.linalg.norm(focus-eye);right=np.cross(forward,[0,1,0]);right/=np.linalg.norm(right);up=np.cross(right,forward)
images={};results=[]
for pixel in [(x,y) for y in [350,450,550] for x in [150,300,450,600,750,900,1050]]:
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

import datetime,hashlib
frame=r/('logs/environment-only-native-render.png' if os.environ.get('OPENLEAGUE_PROBE_ENV_ONLY')=='1' else 'logs/terrain-native-center-render.png');image=Image.open(frame).convert('RGB')
config=json.loads((r/'data/4.20/terrain_materials.json').read_text(encoding='utf-8'));native_images={}
def sample(path,uv,tiled):
 if path not in native_images:native_images[path]=np.asarray(Image.open(r/'assets'/path).convert('RGBA'),dtype=float)/255
 a=native_images[path];h,w=a.shape[:2];xy=np.asarray(uv)*[w,h]-.5;ij=np.floor(xy).astype(int);f=xy-ij
 def pix(dx,dy):
  x=ij[0]+dx;y=ij[1]+dy
  return a[y%h,x%w] if tiled else a[np.clip(y,0,h-1),np.clip(x,0,w-1)]
 return pix(0,0)*(1-f[0])*(1-f[1])+pix(1,0)*f[0]*(1-f[1])+pix(0,1)*(1-f[0])*f[1]+pix(1,1)*f[0]*f[1]
fog_settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'));qualified=[];occluded=[]
for row in results:
 visible=next((h for h in row['hits'] if h['alpha_mode']!='MASK' or h['png_bilinear_rgba'][3]/255>=h['alpha_cutoff']),None)
 if not visible:continue
 entry=next((m for m in config['terrain_materials'] if m['name']==visible['material']),None)
 if entry is None:continue
 overlays=[h for h in row['hits'] if h['alpha_mode']=='BLEND' and h['distance']<=visible['distance']+.00001 and h['png_bilinear_rgba'][3]>0]
 if overlays:
  occluded.append({'pixel':row['pixel'],'reason':'Coplanar or foreground blend decal masks terrain shader','overlays':overlays})
  continue
 colors=np.array([sample(p,visible['uv'],True) for p in entry['layers']]);height=colors[:,3]*sample(config['height_map'],visible['uv1'],False)*config['layer_scales'];weights=np.clip(height-height.max()+config['half_blend_area'],0,1)*np.clip(height*32,0,1);weights=weights/weights.sum() if weights.sum()>1e-6 else np.array([1,0,0,0]);detail=weights@colors[:,:3];base=np.clip(detail*sample(config['colormap'],visible['uv1'],False)[:3]*4,0,1);amount=float(np.clip(visible['world'][1]*20*fog_settings['fog_data1'][1]+fog_settings['fog_data1'][2],0,1));pred=(base*(1-amount)+sample(fog_settings['fog_lighting'],visible['uv1'],False)[:3]*amount)*255;observed=image.getpixel(tuple(row['pixel']));err=float(np.max(np.abs(pred-observed)));qualified.append({'pixel':row['pixel'],'material':visible['material'],'uv':visible['uv'],'spatial_uv':visible['uv1'],'weights':weights.tolist(),'native_low_fog_amount':amount,'predicted_rgb':pred.tolist(),'observed_rgb':observed,'maximum_channel_error':err})
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'map_sha256':hashlib.sha256(raw).hexdigest(),'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'diagnostic_actors_hidden':os.environ.get('OPENLEAGUE_PROBE_ENV_ONLY')=='1','frame':str(frame),'frame_sha256':hashlib.sha256(frame.read_bytes()).hexdigest(),'static_skinned_nodes_modeled':skinned_nodes,'suppressed_embedded_roots':suppressed_roots,'diagnostic_ambient_hidden':True,'samples':qualified,'excluded_occluded_samples':occluded,'camera_focus':focus.tolist(),'limits':['CPU static ray uses fixed diagnostic camera; actor occlusion/animation and MSAA edge samples not modeled.','Checks the implemented shader math and binding; not native runtime visual equivalence.','Spatial transform and lighting variant remain unqualified.']}
assert len(qualified)>=3, len(qualified)
proof['maximum_channel_error']=max(x['maximum_channel_error'] for x in qualified);proof['passed']=proof['maximum_channel_error']<=8
(r/'docs/terrain_native_render_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'terrain_samples':len(qualified),'max_error':proof['maximum_channel_error'],'passed':proof['passed']}))
assert proof['passed']
