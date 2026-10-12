"""Restore omitted final ANM v4 samples, preserving original GLTF data and native sources."""
from pathlib import Path
import json,struct,hashlib,datetime,numpy as np
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,d):(r/p).write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(b):return hashlib.sha256(b).hexdigest()
def elf(name):
 h=0
 for x in name.lower().encode('ascii'):
  h=((h<<4)+x)&0xffffffff;high=h&0xf0000000
  if high:h^=high>>24
  h&=~high
 return h
source=read('docs/map_ambient_source_validation.json');manifest=read('data/4.20/map_ambient_manifest.json');repairs=[]
for model in source['models']:
 path=r/'assets'/model['asset'];raw=path.read_bytes();assert sha(raw)==model['sha256']
 n=struct.unpack_from('<I',raw,12)[0];doc=json.loads(raw[20:20+n]);blob=bytearray(raw[28+n:]);changed=False
 def values(i):
  ac=doc['accessors'][i];bv=doc['bufferViews'][ac['bufferView']]
  assert ac['componentType']==5126 and not ac.get('sparse') and not bv.get('byteStride')
  dim={'SCALAR':1,'VEC3':3,'VEC4':4}[ac['type']]
  return np.frombuffer(blob,dtype='<f4',count=ac['count']*dim,offset=bv.get('byteOffset',0)+ac.get('byteOffset',0)).reshape(-1,dim).copy()
 def append(data,kind):
  data=np.asarray(data,dtype='<f4');blob.extend(b'\0'*((-len(blob))%4));offset=len(blob);payload=data.tobytes();blob.extend(payload)
  view=len(doc['bufferViews']);doc['bufferViews'].append({'buffer':0,'byteOffset':offset,'byteLength':len(payload)})
  ac={'bufferView':view,'componentType':5126,'count':len(data),'type':kind}
  if kind=='SCALAR':ac.update({'min':[float(data.min())],'max':[float(data.max())]})
  index=len(doc['accessors']);doc['accessors'].append(ac);return index
 for original in model['sources']:
  native=Path(original['path'])
  if native.suffix.lower()!='.anm':continue
  b=native.read_bytes();assert sha(b)==original['sha256']
  assert b[:8]==b'r3d2anmd' and struct.unpack_from('<I',b,8)[0]==4
  tracks,frames,step=struct.unpack_from('<IIf',b,28);vec,quat,frame_data=struct.unpack_from('<III',b,52)
  assert 12+frame_data+frames*tracks*12<=len(b)
  animation=next(a for a in doc['animations'] if a['name'].lower()==native.stem.lower())
  endpoint=float(np.float32((frames-1)*step));old_end=max(float(values(s['input']).max()) for s in animation['samplers'])
  if endpoint-old_end<1e-5:continue
  assert abs(endpoint-old_end-step)<1e-5,(native,endpoint,old_end)
  samples={}
  for frame in [frames-2,frames-1]:
   for track in range(tracks):
    h,t,s,q,_=struct.unpack_from('<I4H',b,12+frame_data+(frame*tracks+track)*12)
    rotation=np.array(struct.unpack_from('<4f',b,12+quat+q*16),dtype=np.float64)
    norm=np.linalg.norm(rotation);assert np.isfinite(norm) and norm>1e-8;rotation/=norm
    samples[(frame,h)]={'translation':np.array(struct.unpack_from('<3f',b,12+vec+t*12)),
                         'scale':np.array(struct.unpack_from('<3f',b,12+vec+s*12)), 'rotation':rotation}
  max_baseline_error=0.;max_change=0.;repaired=set()
  for channel in animation['channels']:
   sampler_id=channel['sampler'];assert sampler_id not in repaired
   sm=animation['samplers'][sampler_id];assert sm.get('interpolation','LINEAR')=='LINEAR'
   target=channel['target'];name=doc['nodes'][target['node']]['name'];kind=target['path'];h=elf(name)
   times=values(sm['input']);output=values(sm['output']);assert len(times)==len(output)==frames-1
   before=samples[(frames-2,h)][kind];final=samples[(frames-1,h)][kind]
   error=float(np.max(np.abs(output[-1]-before)))
   if kind=='rotation':
    error=min(error,float(np.max(np.abs(output[-1]+before))))
    # Equivalent quaternion sign chosen for continuous shortest-path interpolation.
    if np.dot(output[-1],final)<0:final=-final
   assert error<1e-4,(name,kind,error);max_baseline_error=max(max_baseline_error,error)
   max_change=max(max_change,float(np.max(np.abs(final-output[-1]))))
   sm['input']=append(np.concatenate([times,[[endpoint]]]),'SCALAR')
   sm['output']=append(np.vstack([output,final]),'VEC4' if kind=='rotation' else 'VEC3')
   repaired.add(sampler_id)
  assert len(repaired)==tracks*3
  repairs.append({'native_asset':model['native_asset'],'clip':animation['name'],'native_anm':str(native),'native_sha256':sha(b),
                  'original_asset_sha256':sha(raw),'source_frames':frames,'restored_channels':len(repaired),
                  'old_endpoint_seconds':old_end,'restored_endpoint_seconds':endpoint,
                  'maximum_previous_sample_error':max_baseline_error,'maximum_restored_sample_change':max_change})
  index=model['clips'].index(animation['name']);model['durations'][index]=endpoint
  manifest['assets'][model['native_asset']]['durations'][index]=endpoint
  if index==model['primary_clip']:
   model['duration']=endpoint;manifest['assets'][model['native_asset']]['duration']=endpoint
  changed=True
 if changed:
  backup=r/'artwork/maps/source_backups'/('pre_endpoint_'+path.name);backup.parent.mkdir(exist_ok=True)
  if backup.exists():assert backup.read_bytes()==raw
  else:backup.write_bytes(raw)
  doc['buffers'][0]['byteLength']=len(blob);encoded=json.dumps(doc,separators=(',',':')).encode();encoded+=b' '*((-len(encoded))%4)
  output=struct.pack('<4sII',b'glTF',2,28+len(encoded)+len(blob))+struct.pack('<II',len(encoded),0x4e4f534a)+encoded+struct.pack('<II',len(blob),0x004e4942)+blob
  # Every previously present binary byte, mesh, skin and image remains exact.
  assert bytes(blob[:len(raw)-28-n])==raw[28+n:]
  path.write_bytes(output);model['sha256']=sha(output);manifest['assets'][model['native_asset']]['sha256']=sha(output)
  for repair in repairs:
   if repair['native_asset']==model['native_asset']:repair['restored_asset_sha256']=sha(output)
write('docs/map_ambient_source_validation.json',source);write('data/4.20/map_ambient_manifest.json',manifest)
if repairs:
 write('docs/map_ambient_endpoint_repair.json',{'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'repairs':repairs,
  'passed':True,'complete':False,'limits':['Exact last source samples restored; native BLND blend/loop semantics, effects and audio still incomplete.','Runtime and Blender receipts must be refreshed after the changed asset.']})
print('RESTORED',len(repairs),'clips',sum(x['restored_channels'] for x in repairs),'native final-sample channels')
