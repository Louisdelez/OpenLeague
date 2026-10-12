"""Restore native dual vertex control colors for non-lightmapped NVR decor."""
import base64,datetime,hashlib,json,re,struct
from pathlib import Path
import numpy as np
r=Path(__file__).resolve().parents[1];native=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\LEVELS\Map10\scene\room.nvr');n=native.read_bytes();ma,vbc,ibc,mc,nc=struct.unpack_from('<5i',n,8);materials=[];off=28
for i in range(ma):
 name=n[off:off+260].split(b'\0')[0].decode();typ,flags=struct.unpack_from('<iI',n,off+260);materials.append({'name':name,'type':typ,'flags':flags});off+=268+8*340
vbs=[]
for i in range(vbc):
 size=struct.unpack_from('<i',n,off)[0];off+=4;vbs.append(off);off+=size
ibs=[]
for i in range(ibc):
 size,fmt=struct.unpack_from('<2i',n,off);off+=8;ibs.append(np.frombuffer(n,dtype='<u2' if fmt==0x65 else '<u4',count=size//(2 if fmt==0x65 else 4),offset=off));off+=size
native_meshes={}
for mi in range(mc):
 mo=off+mi*100;mid=struct.unpack_from('<i',n,mo+48)[0];m=materials[mid]
 if m['type']!=0 or m['flags']&8:continue
 vi,sv,vc,ii,si,ic=struct.unpack_from('<6i',n,mo+52);stride=40 if m['flags']&16 else 36;start=vbs[vi]+sv*stride
 rows=np.ndarray((vc,8),dtype='<f4',buffer=n,offset=start,strides=(stride,4)).copy();primary=np.ndarray((vc,4),dtype='u1',buffer=n,offset=start+32,strides=(stride,1)).copy()[:,[2,1,0,3]]
 secondary=np.ndarray((vc,4),dtype='u1',buffer=n,offset=start+36,strides=(stride,1)).copy()[:,[2,1,0,3]] if m['flags']&16 else None
 native_indices=ibs[ii][si:si+ic];native_faces=(native_indices-native_indices.min()).reshape(-1,3);native_meshes[mi]=(mid,rows,primary,secondary,native_faces)
p=r/'assets/maps/twisted_treeline.glb';backup=r/'assets/maps/twisted_treeline.before_vertex_lighting.glb';raw=(backup if backup.exists() else p).read_bytes();jlen=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+jlen]);blob=bytearray(raw[28+jlen:]);original_len=len(blob)
def accessor(i):
 a=d['accessors'][i];v=d['bufferViews'][a['bufferView']];cols={'VEC2':2,'VEC3':3,'VEC4':4}[a['type']];assert a['componentType']==5126
 return np.ndarray((a['count'],cols),dtype='<f4',buffer=blob,offset=v.get('byteOffset',0)+a.get('byteOffset',0),strides=(v.get('byteStride',4*cols),4)).copy()
def append(data,count):
 blob.extend(b'\0'*((-len(blob))%4));start=len(blob);blob.extend(data);vi=len(d['bufferViews']);d['bufferViews'].append({'buffer':0,'byteOffset':start,'byteLength':len(data),'target':34962});ai=len(d['accessors']);d['accessors'].append({'bufferView':vi,'componentType':5126,'count':count,'type':'VEC4'});return ai

for mesh in d['meshes']:
 match=re.search(r'MapGeo_Instance_(\d+)',mesh.get('name',''))
 if not match or int(match[1]) not in native_meshes:continue
 mi=int(match[1]);mid,rows,primary,secondary,faces=native_meshes[mi]
 for p in mesh['primitives']:
  a=d['accessors'][p['indices']];v=d['bufferViews'][a['bufferView']];dtype='<u2' if a['componentType']==5123 else '<u4';indices=np.frombuffer(blob,dtype=dtype,count=a['count'],offset=v.get('byteOffset',0)+a.get('byteOffset',0));count=len(indices)//3
  if count==len(faces):continue
  points=rows[faces,:3];degen=np.linalg.norm(np.cross(points[:,1]-points[:,0],points[:,2]-points[:,0]),axis=1)<1e-6
  print(mesh['name'],'native faces',len(faces),'glb faces',count,'degenerate',int(degen.sum()))
