from pathlib import Path
import sys,json,struct,re,collections
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import numpy as np
r=Path('E:/OpenLeague');cfg=json.loads((r/'data/4.20/map_visual_settings.json').read_text());n=Path(cfg['source']).with_name('scene').joinpath('room.nvr').read_bytes();ma,vbc,ibc,mc,nc=struct.unpack_from('<5i',n,8);off=28+ma*2988;vbs=[]
for i in range(vbc):size=struct.unpack_from('<i',n,off)[0];off+=4;vbs.append((off,size));off+=size
ibs=[]
for i in range(ibc):size,fmt=struct.unpack_from('<2i',n,off);off+=8;ibs.append(np.frombuffer(n,dtype='<u2' if fmt==0x65 else '<u4',count=size//(2 if fmt==0x65 else 4),offset=off));off+=size
raw=Path('E:/mapslol3v3/output/TwistedTreeline_Map10_Native_4.20/TwistedTreeline_Native.glb').read_bytes();length=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+length]);blob=raw[28+length:]
def accessor(doc,buf,index):
 a=doc['accessors'][index];v=doc['bufferViews'][a['bufferView']];cols={'SCALAR':1,'VEC3':3}[a['type']];dtype={5126:'<f4',5123:'<u2',5125:'<u4'}[a['componentType']];size=np.dtype(dtype).itemsize
 return np.ndarray((a['count'],cols),dtype=dtype,buffer=buf,offset=v.get('byteOffset',0)+a.get('byteOffset',0),strides=(v.get('byteStride',size*cols),size)).copy()
profiles={};meshes={}
for mesh in d['meshes']:
 match=re.search(r'MapGeo_Instance_(\d+)',mesh.get('name',''))
 if not match:continue
 mi=int(match[1]);mid=struct.unpack_from('<i',n,off+mi*100+48)[0];typ,flags=struct.unpack_from('<iI',n,28+mid*2988+260);vi,sv,vc,ii,si,ic=struct.unpack_from('<6i',n,off+mi*100+52);p=mesh['primitives'][0];pos=accessor(d,blob,p['attributes']['POSITION'])
 errors=[]
 for stride in [32,36,40,44,48,52]:
  start=vbs[vi][0]+sv*stride
  if sv*stride+vc*stride>vbs[vi][1]:continue
  rows=np.ndarray((vc,3),dtype='<f4',buffer=n,offset=start,strides=(stride,4))
  error=float(np.max(np.abs(rows[:min(len(pos),16)]-pos[:min(len(pos),16)])))
  if np.isfinite(error):errors.append((error,stride))
 errors.sort();best=errors[0];assert best[0]==0,(mi,typ,flags,vc,len(pos),errors)
 meshes[mi]=dict(mid=mid,type=typ,flags=flags,stride=best[1],vi=vi,sv=sv,vc=vc,ii=ii,si=si,ic=ic)
 profiles.setdefault((typ,flags,best[1]),0);profiles[(typ,flags,best[1])]+=1
print(json.dumps({'mesh_count':len(meshes),'profiles':[[list(k),v] for k,v in profiles.items()]}))
