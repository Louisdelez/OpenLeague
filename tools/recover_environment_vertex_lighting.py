"""Restore exact native geometry and vertex lighting for non-lightmapped NVR decor."""
import base64,datetime,hashlib,json,re,struct
from pathlib import Path
import numpy as np
r=Path(__file__).resolve().parents[1];native=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\LEVELS\Map10\scene\room.nvr');n=native.read_bytes();ma,vbc,ibc,mc,nc=struct.unpack_from('<5i',n,8);materials=[];off=28
for i in range(ma):
 name=n[off:off+260].split(b'\0')[0].decode();typ,flags=struct.unpack_from('<iI',n,off+260);materials.append({'name':name,'type':typ,'flags':flags});off+=268+8*340
vbs=[];ibs=[]
for i in range(vbc):size=struct.unpack_from('<i',n,off)[0];off+=4;vbs.append(off);off+=size
for i in range(ibc):
 size,fmt=struct.unpack_from('<2i',n,off);off+=8;ibs.append(np.frombuffer(n,dtype='<u2' if fmt==0x65 else '<u4',count=size//(2 if fmt==0x65 else 4),offset=off));off+=size
native_meshes={}
for mi in range(mc):
 mo=off+mi*100;mid=struct.unpack_from('<i',n,mo+48)[0];m=materials[mid]
 if m['type']!=0 or m['flags']&8:continue
 vi,sv,vc,ii,si,ic=struct.unpack_from('<6i',n,mo+52);stride=40 if m['flags']&16 else 36;start=vbs[vi]+sv*stride
 rows=np.ndarray((vc,8),dtype='<f4',buffer=n,offset=start,strides=(stride,4)).copy();primary=np.ndarray((vc,4),dtype='u1',buffer=n,offset=start+32,strides=(stride,1)).copy()[:,[2,1,0,3]]
 secondary=np.ndarray((vc,4),dtype='u1',buffer=n,offset=start+36,strides=(stride,1)).copy()[:,[2,1,0,3]] if m['flags']&16 else None
 ids=ibs[ii][si:si+ic].astype(np.uint32);ids-=ids.min();assert ids.max()<vc;native_meshes[mi]=(mid,rows,primary,secondary,ids)
p=r/'assets/maps/twisted_treeline.glb';backup=r/'assets/maps/twisted_treeline.before_vertex_lighting.glb';raw=(backup if backup.exists() else p).read_bytes();jlen=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+jlen]);blob=bytearray(raw[28+jlen:]);original_len=len(blob)
def append(array,typ,target=34962):
 array=np.asarray(array);cols={'VEC2':2,'VEC3':3,'VEC4':4,'SCALAR':1}[typ];data=array.astype('<u4' if typ=='SCALAR' else '<f4').tobytes();count=array.size//cols
 blob.extend(b'\0'*((-len(blob))%4));start=len(blob);blob.extend(data);vi=len(d['bufferViews']);d['bufferViews'].append({'buffer':0,'byteOffset':start,'byteLength':len(data),'target':target});ai=len(d['accessors']);a={'bufferView':vi,'componentType':5125 if typ=='SCALAR' else 5126,'count':count,'type':typ}
 if typ=='VEC3':a.update(min=array.min(0).astype(float).tolist(),max=array.max(0).astype(float).tolist())
 d['accessors'].append(a);return ai
changes=[];controls={};factors={};restored_triangles=0
for mesh in d['meshes']:
 match=re.search(r'MapGeo_Instance_(\d+)',mesh.get('name',''))
 if not match or int(match[1]) not in native_meshes:continue
 mi=int(match[1]);mid,rows,primary,secondary,ids=native_meshes[mi];source=materials[mid];factor=8 if secondary is not None else 4;assert len(mesh['primitives'])==1
 prim=mesh['primitives'][0];old_count=d['accessors'][prim['indices']]['count']//3;count=len(ids)//3;restored_triangles+=count-old_count;control=primary.astype(np.float32)/255.
 if secondary is not None:control[:,:3]*=secondary[:,:3].astype(np.float32)/255.
 assert np.all((control>=0)&(control<=1));assert np.all(primary[:,3]==255)
 normals=rows[:,3:6].copy();length=np.linalg.norm(normals,axis=1);normals=np.divide(normals,length[:,None],out=np.zeros_like(normals),where=length[:,None]>1e-8)
 prim['attributes']={'POSITION':append(rows[:,:3],'VEC3'),'NORMAL':append(normals,'VEC3'),'TEXCOORD_0':append(rows[:,6:8],'VEC2'),'COLOR_0':append(control,'VEC4')};prim['indices']=append(ids,'SCALAR',34963)
 name=d['materials'][prim['material']]['name'];assert name not in factors or factors[name]==factor;factors[name]=factor
 controls[mesh['name']]={'native_mesh':mi,'native_material':source,'primary_rgba':base64.b64encode(primary.tobytes()).decode(),'secondary_rgba':base64.b64encode(secondary.tobytes()).decode() if secondary is not None else None,'factor':factor,'vertices':len(rows)}
 changes.append({'mesh':mesh['name'],'native_mesh':mi,'material':name,'vertices':len(rows),'factor':factor,'native_triangles':count,'previous_triangles':old_count,'restored_triangles':count-old_count,'control_rgb_mean':control[:,:3].mean(0).tolist()})
assert len(changes)==1971 and restored_triangles==62
if not backup.exists():backup.write_bytes(raw)
d['buffers'][0]['byteLength']=len(blob);encoded=json.dumps(d,separators=(',',':')).encode();encoded+=b' '*((-len(encoded))%4);blob.extend(b'\0'*((-len(blob))%4));result=struct.pack('<4sII',b'glTF',2,28+len(encoded)+len(blob))+struct.pack('<II',len(encoded),0x4e4f534a)+encoded+struct.pack('<II',len(blob),0x004e4942)+blob
assert blob[:original_len]==raw[28+jlen:];p.write_bytes(result)
settings={'material_factors':factors,'policy':'Native LIT_VS DUAL_COLOR then LIT_PS MOD2X_COLORMAP: primary RGB * secondary RGB * 8; primary-only factor 4. Native BGRA reordered to RGBA.','lightmapped_policy':'Native flag 8 materials retained with existing diffuse rendering; their baked/lighting shader variant still unqualified.','limits':['Native MOD2X_COLORMAP/DUAL_COLOR math used with shadows disabled; original shader variant/emissive/lighting/gamma still unqualified.','Combined control stores primary*secondary at each native vertex before interpolation, matching vertex shader order.','Native normals normalized for glTF; exact historical normal/light shader behavior not qualified.','Full map/game remains incomplete.']}
(r/'data/4.20/environment_lighting.json').write_text(json.dumps(settings,indent=2)+'\n',encoding='utf-8');(r/'data/4.20/environment_vertex_controls.json').write_text(json.dumps(controls,separators=(',',':'))+'\n',encoding='utf-8')
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_nvr':str(native),'native_nvr_sha256':hashlib.sha256(n).hexdigest(),'native_vertex_meshes':changes,'mesh_count':len(changes),'vertices':sum(x['vertices'] for x in changes),'material_count':len(factors),'restored_triangles':restored_triangles,'map_before_sha256':hashlib.sha256(raw).hexdigest(),'map_after_sha256':hashlib.sha256(result).hexdigest(),'existing_binary_bytes_preserved':True,'native_control_sidecar':'data/4.20/environment_vertex_controls.json','shader_sources':[{'path':str(native.parents[3]/'DATA/Shaders/HLSL/Environment'/name),'sha256':hashlib.sha256((native.parents[3]/'DATA/Shaders/HLSL/Environment'/name).read_bytes()).hexdigest()} for name in ['LIT_VS.vs_2_0','LIT_PS.ps_2_0']],'limits':settings['limits']+[settings['lightmapped_policy']]};(r/'docs/environment_vertex_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'meshes':len(changes),'vertices':proof['vertices'],'materials':len(factors),'restored_triangles':restored_triangles,'map_sha256':proof['map_after_sha256']}))
