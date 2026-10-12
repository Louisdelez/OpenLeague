from pathlib import Path
import json,struct,math,hashlib,datetime,bisect
# Isolated original PE image; constructors/loaders are outside this pose oracle.
exec(Path('E:/mapslol3v3/probe_native_structure_clip_periods.py').read_text().split('sources=[]')[0])
r=Path('E:/OpenLeague');sources=json.loads((r/'docs/intact_structure_animation_binding.json').read_text())['records']
for alias,m in json.loads((r/'docs/destroyed_animation_binding.json').read_text())['models'].items():sources.append(dict(alias=alias,asset=m['asset'],clip=m['source']['clip'],clip_sha256=m['source']['clip_sha256']))
clip=0x60000000;u.mem_map(clip,0x100000);context=terrain+0x1000;skeleton=terrain+0x2000;poses=terrain+0x3000;mapping=terrain+0x4000
write32(0x123ed4c,0xffffffff);write32(0x12395cc,0xffffffff)
def f32(v):return struct.unpack('<f',struct.pack('<f',v))[0]
def elf(name):
 h=0
 for c in name.lower().encode():
  h=(h<<4)+c;g=h&0xf0000000
  if g:h^=g>>24
  h&=~g
 return h&0xffffffff
def glb(path):
 b=path.read_bytes();n=struct.unpack_from('<I',b,12)[0];return json.loads(b[20:20+n]),b[28+n:]
def values(g,b,index):
 a=g['accessors'][index];v=g['bufferViews'][a['bufferView']];n={'SCALAR':1,'VEC3':3,'VEC4':4}[a['type']];assert a['componentType']==5126
 offset=v.get('byteOffset',0)+a.get('byteOffset',0);stride=v.get('byteStride',n*4)
 return [struct.unpack_from('<'+'f'*n,b,offset+i*stride) for i in range(a['count'])]
def normalized(q):
 length=math.sqrt(sum(x*x for x in q));assert length>0
 return tuple(x/length for x in q)
def slerp(a,b,t):
 a=normalized(a);b=normalized(b);dot=sum(x*y for x,y in zip(a,b))
 if dot<0:b=tuple(-x for x in b);dot=-dot
 if dot>.9995:return normalized(tuple(x+(y-x)*t for x,y in zip(a,b)))
 angle=math.acos(min(1,dot));return tuple((x*math.sin((1-t)*angle)+y*math.sin(t*angle))/math.sin(angle) for x,y in zip(a,b))
def parsed_resource(raw):
 version=struct.unpack_from('<I',raw,8)[0]
 if version==4:
  resource=raw[12:];tracks,frames=struct.unpack_from('<II',resource,0x10);step=struct.unpack_from('<f',resource,0x18)[0];offset=struct.unpack_from('<I',resource,0x30)[0]
  hashes=[struct.unpack_from('<I',resource,offset+i*12)[0] for i in range(tracks)]
  return resource,hashes,frames,step,'Original ANM v4 resource bytes, excluding the file envelope.'
 assert version==3,version
 _,tracks,frames,fps=struct.unpack_from('<4I',raw,12);step=f32(1/fps);cursor=28;data=[]
 for _ in range(tracks):
  name=raw[cursor:cursor+32].split(b'\0')[0].decode();flags=struct.unpack_from('<I',raw,cursor+32)[0];cursor+=36;keys=[]
  for frame in range(frames):keys.append(struct.unpack_from('<7f',raw,cursor));cursor+=28
  data.append((elf(name),keys))
 assert cursor==len(raw)
 vectors=[(1.,1.,1.)];rotations=[];records=[]
 for frame in range(frames):
  for h,keys in data:
   q=keys[frame][:4];translation=keys[frame][4:];vi=len(vectors);qi=len(rotations);vectors.append(translation);rotations.append(q);records.append(struct.pack('<I4H',h,vi,0,qi,0))
 vector_offset=64;quat_offset=vector_offset+len(vectors)*12;frame_offset=quat_offset+len(rotations)*16;size=frame_offset+len(records)*12
 # Header ABI has the time step at +0x18 and six relative offsets at +0x1c.
 header=struct.pack('<6I f 6I',size,0xbe0794d3,0,0,tracks,frames,step,0xffffffff,0xffffffff,0xffffffff,vector_offset,quat_offset,frame_offset)
 resource=header+bytes(vector_offset-len(header))+b''.join(struct.pack('<3f',*v) for v in vectors)+b''.join(struct.pack('<4f',*q) for q in rotations)+b''.join(records)
 assert len(resource)==size
 return resource,[h for h,_ in data],frames,step,'ANM v3 source names/quaternions/translations repacked by explicit adapter into the uncompressed v4 evaluator ABI. Original v3 loader/conversion not executed.'
def execute(resource,time,indices):
 u.mem_write(clip,resource);u.mem_write(context,bytes(128));write32(context+8,poses);write32(context+0x1c,skeleton);u.mem_write(skeleton+0xe,struct.pack('<H',len(indices)))
 for i,index in enumerate(indices):write32(mapping+4*i,index&0xffffffff)
 u.mem_write(poses,bytes(40*len(indices)));write32(sp,end);write32(sp+4,context);u.mem_write(sp+8,struct.pack('<f',time));write32(sp+12,mapping)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,clip);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x893c80,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)&255==1
 return [struct.unpack('<10f',u.mem_read(poses+i*40,40)) for i in range(len(indices))]
reports=[]
for model in sources:
 raw=Path(model['clip']).read_bytes();assert hashlib.sha256(raw).hexdigest()==model['clip_sha256'];resource,hashes,frames,step,adapter=parsed_resource(raw)
 g,b=glb(r/'assets'/model['asset']);joint_nodes=g['skins'][0]['joints'];names=[g['nodes'][node]['name'] for node in joint_nodes];indices=[hashes.index(elf(name)) if elf(name) in hashes else -1 for name in names];assert all(i>=0 for i in indices),(model['alias'],'unmapped joint')
 channels=g['animations'][0]['channels'];samplers=g['animations'][0]['samplers'];tracks={}
 for channel in channels:
  sampler=samplers[channel['sampler']];node=channel['target']['node'];path=channel['target']['path'];tracks[(node,path)]=(values(g,b,sampler['input']),values(g,b,sampler['output']))
 max_frame=min(frames-1,min(len(v[0])-1 for v in tracks.values()));cases=[]
 saved_frames={0.,.125,.5,1.,max_frame*.125,max_frame*.5,max_frame*.875,float(max_frame)}
 all_errors=[]
 for frame in sorted(saved_frames|{i*.5 for i in range(2*max_frame+1)}):
  native_time=f32(frame*step);result=execute(resource,native_time,indices);errors=[]
  for node,name,pose in zip(joint_nodes,names,result):
   errors_by_path={}
   for path,native_value in [('translation',pose[:3]),('scale',pose[3:6]),('rotation',pose[6:])]:
    if (node,path) not in tracks:continue
    times,keys=tracks[(node,path)];target_time=frame*(times[-1][0]/max_frame);samples=[t[0] for t in times];lo=max(0,min(len(samples)-1,bisect.bisect_right(samples,target_time)-1));hi=min(len(samples)-1,lo+1);t=0. if lo==hi else (target_time-samples[lo])/(samples[hi]-samples[lo])
    expected=slerp(keys[lo],keys[hi],t) if path=='rotation' else tuple(a+(z-a)*t for a,z in zip(keys[lo],keys[hi]))
    if path=='rotation':
     nq=normalized(native_value);error=min(max(abs(x-y) for x,y in zip(nq,expected)),max(abs(x+y) for x,y in zip(nq,expected)))
    else:error=max(abs(x-y) for x,y in zip(native_value,expected))
    errors_by_path[path]=error
   errors.append(dict(joint=name,pose=pose,errors=errors_by_path))
  all_errors.append(errors)
  if frame in saved_frames:cases.append(dict(source_frame=frame,native_time=native_time,joints=errors))
 max_errors={path:max(j['errors'].get(path,0.) for errors in all_errors for j in errors) for path in ['translation','scale','rotation']}
 assert max_errors['translation']<1e-3 and max_errors['scale']<1e-5 and max_errors['rotation']<1e-5,(model['alias'],max_errors)
 reports.append(dict(model=model['alias'],asset=model['asset'],asset_sha256=hashlib.sha256((r/'assets'/model['asset']).read_bytes()).hexdigest(),source_clip=model['clip'],source_clip_sha256=model['clip_sha256'],resource_sha256=hashlib.sha256(resource).hexdigest(),adapter=adapter,frames=frames,step=step,joints=names,all_key_and_midpoint_samples=len(all_errors),cases=cases,max_errors=max_errors))
 print(json.dumps(dict(model=model['alias'],max_errors=max_errors)),flush=True)
report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x893c80',native_addresses=len(visited),models=reports,limits=['Actual original full uncompressed pose evaluator executed. Original v4 bytes for2models; explicitly repacked original v3 data for14models. Native legacy loader and complete BLND state selection remain open.','Joint mapping supplied using exact exported rig joint names and source ANM hashes; native skeleton loader/binding not executed.','GLTF sampling comparison uses normalized shortest-path slerp for rotations and linear translation/scale; recorded errors must be assessed, not assumed acceptable.'])
Path('E:/mapslol3v3/structure_native_pose_contract.json').write_text(json.dumps(report,indent=2)+'\n')
