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

controls=[];triangles=[];uvs=[];uvs1=[];materials=[];names=[]
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
   controls.append(accessor(p['attributes']['COLOR_0'])[indices] if 'COLOR_0' in p['attributes'] else np.ones((len(indices),3,4)));triangles.append(points[indices]);uvs1.append(accessor(p['attributes']['TEXCOORD_1'])[indices] if 'TEXCOORD_1' in p['attributes'] else np.zeros((len(indices),3,2)));uvs.append(accessor(p['attributes']['TEXCOORD_0'])[indices]);materials.extend([p['material']]*len(indices));names.extend([node.get('name','')]*len(indices))
 for child in node.get('children',[]):visit(child,world)
for node in d['scenes'][0]['nodes']:visit(node,root_matrix)
controls=np.concatenate(controls);triangles=np.concatenate(triangles);uvs=np.concatenate(uvs);uvs1=np.concatenate(uvs1);v0=triangles[:,0];e1=triangles[:,1]-v0;e2=triangles[:,2]-v0
spawn=json.loads((r/'data/4.20/champion_spawns_map10.json').read_text(encoding='utf-8'))[0]['point'];focus=np.array([spawn['x']/20,151.0460662841797/20,spawn['z']/20]);focus=np.array([float(x) for x in os.environ['OPENLEAGUE_RENDER_FOCUS'].split(',')]) if 'OPENLEAGUE_RENDER_FOCUS' in os.environ else focus;eye=focus+np.array([0,340,265]);forward=(focus-eye)/np.linalg.norm(focus-eye);right=np.cross(forward,[0,1,0]);right/=np.linalg.norm(right);up=np.cross(right,forward)
images={};linear_images={};results=[]
for pixel in [(x,y) for y in [140,200,260,320,380,440,500,560,620] for x in [150,250,350,450,550,650,750,850,950,1050]]:
 x,y=pixel;direction=forward+right*((2*(x+.5)/1280-1)*np.tan(np.pi/8)*1.6)+up*((1-2*(y+.5)/800)*np.tan(np.pi/8));direction/=np.linalg.norm(direction)
 h=np.cross(direction,e2);det=np.einsum('ij,ij->i',e1,h);valid=np.abs(det)>1e-8;inv=np.divide(1,det,out=np.zeros_like(det),where=valid);s=eye-v0;u=inv*np.einsum('ij,ij->i',s,h);q=np.cross(s,e1);v=inv*np.einsum('j,ij->i',direction,q);distance=inv*np.einsum('ij,ij->i',e2,q);valid&=(u>=0)&(v>=0)&(u+v<=1)&(distance>0)
 hits=[]
 for i in sorted(np.flatnonzero(valid),key=lambda i:distance[i])[:12]:
  m=d['materials'][materials[i]];coord=uvs[i,0]*(1-u[i]-v[i])+uvs[i,1]*u[i]+uvs[i,2]*v[i];coord1=uvs1[i,0]*(1-u[i]-v[i])+uvs1[i,1]*u[i]+uvs1[i,2]*v[i];texture=m['pbrMetallicRoughness']['baseColorTexture']['index'];source=d['textures'][texture]['source']
  if source not in images:
   view=d['bufferViews'][d['images'][source]['bufferView']];offset=view.get('byteOffset',0);images[source]=Image.open(io.BytesIO(binary[offset:offset+view['byteLength']])).convert('RGBA')
  image=images[source]
  if source not in linear_images:
   a=np.asarray(image,dtype=float);rgb=a[:,:,:3]/255;a[:,:,:3]=np.where(rgb<=.04045,rgb/12.92,((rgb+.055)/1.055)**2.4)*255;linear_images[source]=a
  a=linear_images[source];xy=coord*[image.width,image.height]-.5;ij=np.floor(xy).astype(int);f=xy-ij;rgba=a[ij[1]%image.height,ij[0]%image.width]*(1-f[0])*(1-f[1])+a[ij[1]%image.height,(ij[0]+1)%image.width]*f[0]*(1-f[1])+a[(ij[1]+1)%image.height,ij[0]%image.width]*(1-f[0])*f[1]+a[(ij[1]+1)%image.height,(ij[0]+1)%image.width]*f[0]*f[1];rgb=rgba[:3]/255;rgba[:3]=np.where(rgb<=.0031308,rgb*12.92,1.055*np.maximum(rgb,0)**(1/2.4)-.055)*255;rgba=rgba.tolist()
  verts=triangles[i]-eye;depth=verts@forward;projected=np.column_stack([((verts@right)/depth/(np.tan(np.pi/8)*1.6)+1)*640,(1-(verts@up)/depth/np.tan(np.pi/8))*400]);point=np.array([x+.5,y+.5]);edges=np.roll(projected,-1,axis=0)-projected;edge_dist=np.abs(edges[:,0]*(point[1]-projected[:,1])-edges[:,1]*(point[0]-projected[:,0]))/np.maximum(np.linalg.norm(edges,axis=1),1e-9)
  hits.append({'triangle_screen_edge_distance':float(edge_dist.min()),'triangle_barycentric':[float(1-u[i]-v[i]),float(u[i]),float(v[i])],'vertex_control':(controls[i,0]*(1-u[i]-v[i])+controls[i,1]*u[i]+controls[i,2]*v[i]).tolist(),'mesh':names[i],'material':m['name'],'distance':float(distance[i]),'world':(eye+direction*distance[i]).tolist(),'uv':coord.tolist(),'uv1':coord1.tolist(),'png_bilinear_rgba':rgba,'alpha_mode':m.get('alphaMode'),'alpha_cutoff':m.get('alphaCutoff',0.5)})
 results.append({'pixel':pixel,'hits':hits})


import datetime,hashlib
vertex_mode=os.environ.get('OPENLEAGUE_VERIFY_VERTEX')=='1'
settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'));frame=r/('logs/environment-only-native-render.png' if vertex_mode and os.environ.get('OPENLEAGUE_PROBE_ENV_ONLY')=='1' else 'logs/terrain-native-center-render.png' if vertex_mode else 'logs/native-fog-low-render.png');screen=Image.open(frame).convert('RGB');a=np.asarray(Image.open(r/'assets'/settings['fog_lighting']).convert('RGBA'),dtype=float);h,w=a.shape[:2]
def fog_sample(uv):
 xy=np.asarray(uv)*[w,h]-.5;ij=np.floor(xy).astype(int);f=xy-ij
 def pix(dx,dy):return a[np.clip(ij[1]+dy,0,h-1),np.clip(ij[0]+dx,0,w-1),:3]
 return pix(0,0)*(1-f[0])*(1-f[1])+pix(1,0)*f[0]*(1-f[1])+pix(0,1)*(1-f[0])*f[1]+pix(1,1)*f[0]*f[1]
factors=json.loads((r/'data/4.20/environment_lighting.json').read_text())['material_factors']
checks=[];excluded=[]
for row in results:
 x,y=row['pixel'];observed_ui=screen.getpixel((x,y))
 # Exact overlay colours and flat horizontal span from health.rs (48 by 5 px).
 if observed_ui in [(38,217,64),(242,184,38),(230,46,46),(20,20,20)] and any(all(screen.getpixel((x+dx,y))==observed_ui for dx in side) for side in [[-12,-8,-4],[4,8,12]]):
  excluded.append({'pixel':row['pixel'],'reason':'Screen-space health bar: source colour and horizontal span match health.rs'});continue
 visible=next((h for h in row['hits'] if h['alpha_mode']!='MASK' or h['png_bilinear_rgba'][3]/255>=h['alpha_cutoff']),None)
 if not visible:continue
 if visible['material'] not in settings['environment_materials']:
  excluded.append({'pixel':row['pixel'],'reason':'Visible non-NVR surface; static skinning applied before ray attribution','mesh':visible['mesh'],'material':visible['material'],'distance':visible['distance'],'static_skinned':visible['mesh'] in skinned_nodes,'predicted_visible_diffuse_rgb':visible['png_bilinear_rgba'][:3],'observed_rgb':screen.getpixel(tuple(row['pixel']))});continue
 world=visible['world'];native_y=world[1]*20.;amount=float(np.clip(native_y*settings['fog_data1'][1]+settings['fog_data1'][2],0,1))
 if vertex_mode:
  if visible['material'] not in factors:continue
 elif amount<.02:continue
 overlays=[h for h in row['hits'] if h['alpha_mode']=='BLEND' and h['distance']<=visible['distance']+.00001 and h['png_bilinear_rgba'][3]>0]
 if overlays or visible['alpha_mode']=='BLEND':
  excluded.append({'pixel':row['pixel'],'reason':'Blend overlay or blended foreground'});continue
 if visible['material'] in ['NVRMaterial_TT_Jungle1','NVRMaterial_TT_Lanes1']:continue
 mat=next(m for m in d['materials'] if m.get('name')==visible['material']);assert mat['pbrMetallicRoughness'].get('baseColorFactor',[1,1,1,1])==[1,1,1,1]
 uv=[world[0]*20./settings['spatial_denominator'],(settings['native_z_mirror_origin']-world[2]*20.)/settings['spatial_denominator']];fog=fog_sample(uv);base=np.array(visible['png_bilinear_rgba'][:3]);factor=factors.get(visible['material'],0);base=np.clip(base*np.array(visible['vertex_control'][:3])*factor,0,255) if factor else base;pred=base*(1-amount)+fog*amount;observed=screen.getpixel(tuple(row['pixel']));error=float(np.max(np.abs(pred-observed)));checks.append({'candidate_hits':row['hits'],'pixel':row['pixel'],'material':visible['material'],'native_y':native_y,'fog_amount':amount,'fog_uv':uv,'base_rgb':base.tolist(),'vertex_control':visible['vertex_control'],'vertex_lighting_factor':factor,'fog_rgb':fog.tolist(),'predicted_rgb':pred.tolist(),'observed_rgb':observed,'maximum_rgb_error':error})
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'frame':str(frame),'frame_sha256':hashlib.sha256(frame.read_bytes()).hexdigest(),'map_sha256':hashlib.sha256(raw).hexdigest(),'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'diagnostic_actors_hidden':os.environ.get('OPENLEAGUE_PROBE_ENV_ONLY')=='1','diagnostic_msaa_disabled':os.environ.get('OPENLEAGUE_PROBE_NO_MSAA')=='1','static_skinned_nodes_modeled':skinned_nodes,'suppressed_embedded_roots':suppressed_roots,'diagnostic_ambient_hidden':True,'samples':checks,'excluded_samples':excluded,'camera_focus':focus.tolist(),'limits':['CPU ray/texture calculation ignores actor occlusion, animation and MSAA edge effects.','Verifies integrated native vertex-control/fog math and texture binding, not original renderer fidelity.','Original native FOG_OF_WAR_PARAMS transform, top-layer variants, actor fog and full fog of war remain incomplete.']}
assert len(checks)>=3, len(checks)
proof['maximum_rgb_error']=max(x['maximum_rgb_error'] for x in checks);proof['passed']=proof['maximum_rgb_error']<=3
(r/('docs/environment_vertex_render_validation.json' if vertex_mode else 'docs/native_fog_render_validation.json')).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'fog_pixels':len(checks),'maximum_rgb_error':proof['maximum_rgb_error'],'passed':proof['passed']}));assert proof['passed']
