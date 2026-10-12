"""Read final GLTF samples independently and compare native ANM palettes."""
from pathlib import Path
import struct,json,hashlib,datetime,numpy as np
r=Path(__file__).resolve().parents[1]
proof=json.loads((r/'docs/map_ambient_endpoint_repair.json').read_text());source=json.loads((r/'docs/map_ambient_source_validation.json').read_text())
def elf(name):
 h=0
 for x in name.lower().encode():
  h=((h<<4)+x)&0xffffffff;g=h&0xf0000000
  if g:h^=g>>24
  h&=~g
 return h
results=[]
for repair in proof['repairs']:
 native=Path(repair['native_anm']).read_bytes();assert hashlib.sha256(native).hexdigest()==repair['native_sha256']
 tracks,frames,step=struct.unpack_from('<IIf',native,28);vec,quat,offset=struct.unpack_from('<III',native,52);expected={}
 for track in range(tracks):
  h,t,s,q,_=struct.unpack_from('<I4H',native,12+offset+((frames-1)*tracks+track)*12)
  rotation=np.array(struct.unpack_from('<4f',native,12+quat+16*q));rotation/=np.linalg.norm(rotation)
  expected[h]={'translation':np.array(struct.unpack_from('<3f',native,12+vec+12*t)), 'scale':np.array(struct.unpack_from('<3f',native,12+vec+12*s)), 'rotation':rotation}
 model=next(m for m in source['models'] if m['native_asset']==repair['native_asset']);glb=(r/'assets'/model['asset']).read_bytes();assert hashlib.sha256(glb).hexdigest()==repair['restored_asset_sha256']
 n=struct.unpack_from('<I',glb,12)[0];doc=json.loads(glb[20:20+n]);blob=glb[28+n:];animation=next(a for a in doc['animations'] if a['name']==repair['clip']);max_error=0.;count=0
 for channel in animation['channels']:
  sm=animation['samplers'][channel['sampler']];target=channel['target'];kind=target['path'];name=doc['nodes'][target['node']]['name']
  ac=doc['accessors'][sm['input']];view=doc['bufferViews'][ac['bufferView']];assert ac['count']==frames
  last_time=struct.unpack_from('<f',blob,view.get('byteOffset',0)+ac.get('byteOffset',0)+(frames-1)*4)[0];assert abs(last_time-(frames-1)*step)<1e-6
  ac=doc['accessors'][sm['output']];view=doc['bufferViews'][ac['bufferView']];dim=4 if kind=='rotation' else 3;assert ac['count']==frames
  value=np.array(struct.unpack_from('<'+str(dim)+'f',blob,view.get('byteOffset',0)+ac.get('byteOffset',0)+(frames-1)*dim*4));ref=expected[elf(name)][kind];error=float(np.max(np.abs(value-ref)))
  if kind=='rotation':error=min(error,float(np.max(np.abs(value+ref))))
  assert error<1e-6,(name,kind,error);max_error=max(max_error,error);count+=1
 assert count==tracks*3
 results.append({'clip':repair['clip'],'final_source_frame':frames-1,'channels':count,'maximum_native_final_sample_error':max_error,'endpoint_seconds':last_time,'gltf_sha256':hashlib.sha256(glb).hexdigest()})
report={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'checks':results,'passed':True,'complete':False,'scope':'Original final pose and time only; full animation blend graph/event playback incomplete.'}
(r/'docs/map_ambient_endpoint_validation.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8');print('PASS final native pose',results)
