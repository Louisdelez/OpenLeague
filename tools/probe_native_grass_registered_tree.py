from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
s=Path('E:/mapslol3v3/probe_native_grass_object_growth.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(s,'registered native setup','exec'))
estimates.update(dict(tuple(map(int,line.split())) for line in Path('E:/mapslol3v3/chain-rsqrt-estimates.txt').read_text(encoding='utf-8-sig').splitlines()))
u.mem_map(terrain+0x10000,0x10000)
actor=terrain+0x10000;model=terrain+0x13000;provider=terrain+0x14000;table=terrain+0x14100;bounds=terrain+0x15000;bounds_api=0xc9f3a8;samples=[];calls=[]
def additional(uc,a,size,user):
 if a==bounds_api:
  assert u.reg_read(UC_X86_REG_ECX)==provider
  sample=samples[min(len(calls),len(samples)-1)];calls.append(sample);u.mem_write(bounds,struct.pack('<6f',*sample));stack=u.reg_read(UC_X86_REG_ESP)
  u.reg_write(UC_X86_REG_EAX,bounds);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
 elif a==0x95ff10:events.append(snapshot('parent'))
 elif a==0x95f060:events.append(snapshot('extents'))
u.hook_add(unicorn.UC_HOOK_CODE,additional)
previous=json.loads((r/'data/4.20/grass_actor_aabb_contract.json').read_text(encoding='utf-8'));cases=[];fields=[0x48,0x4c,0x354,0x358,0x35c,0x360,0x364,0x368]
for input_index,sse,narrow,raw in itertools.product(range(len(previous['cases'])),[False,True],[False,True],[(0.,0.),(25.,75.)]):
 c=previous['cases'][input_index];cursor=terrain+0x8000
 for a in [0x14bef40,0x2d712ac,0x2d712a8,0x2d712b0]:write32(a,0)
 call(0x95ea20,tree_wrapper,[0,0]);service=read32(tree_wrapper);root=read32(service+4)
 if narrow:u.mem_write(root+0x10,struct.pack('<4i',-10,-10,10,10));u.mem_write(root+8,bytes(8))
 write32(wrapper,tree_wrapper);write32(wrapper+8,0)
 write32(0x2d712b4,object_pool);write32(0x2d712b8,object_pool);write32(0x2d712bc,object_pool+128)
 write32(0x2d712a8,node_pool);write32(0x2d712ac,node_pool);write32(0x2d712b0,node_pool+128);write32(0x14ae660,int(sse));write32(0x2da52e8,0)
 u.mem_write(position,bytes(12));u.mem_write(lower,struct.pack('<3f',-5.,-7.,-9.));u.mem_write(upper,struct.pack('<3f',5.,7.,9.));call(0x95ee90,wrapper,[position,lower,upper])
 initial=snapshot('initial');initial_vertical=list(struct.unpack('<4I',u.mem_read(root+0x20,16)))
 u.mem_write(actor,bytes(0x2100));u.mem_write(model,bytes(0xb0));u.mem_write(actor+0x60,struct.pack('<3f',*c['position']));f(actor+0x740,c['actor_scale']);write32(actor+0x2068,model if c['profile'] else 0)
 write32(model+0xa4,provider);f(model+4,c['model_scale']);write32(provider,table);write32(table+4,bounds_api);write32(actor+0xcc,wrapper)
 f(actor+0x380,raw[0]);f(actor+0x37c,raw[1]);f(actor+0x48,71.);f(actor+0x4c,19.)
 row=dict(input_index=input_index,integer_sse=sse,narrow=narrow,raw_shape=raw[0],raw_radius=raw[1],initial=initial,initial_vertical_bits=initial_vertical)
 for repeat in [False,True]:
  samples=c['bounds_calls'];calls.clear();events.clear();call(0x6151a0,actor)
  assert list(struct.unpack('<6I',u.mem_read(actor+0x95,24)))==c['aabb_bits'];assert calls==c['bounds_calls']
  result=dict(events=list(events),final=snapshot('final'),state_bits=[read32(actor+off) for off in fields],sentinel=read32(actor+0x36c),bounds_calls=list(calls),root_vertical_bits=list(struct.unpack('<4I',u.mem_read(root+0x20,16))),root_members=read32(root+0x48),parent_is_root=read32(object_pointer+0x28)==root)
  if repeat:row['repeat']=result
  else:row.update(result)
 cases.append(row)
proof=dict(passed=True,complete=False,updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,entry='0x6151a0',native_addresses=len(visited),cases=cases,runtime_adapters=['Model bounds virtual+4 supplies inherited explicit arrays; heap allocation/free adapted; same-PC RSQRTSS estimates supplied. Actual actor/AABB/dispatch/parent/reinsertion execute.'],limits=['Finite supplied models, one object in a default or narrow root, two integer profiles. Deep children, allocator failure, real actor/model/camera producers and live mask/WALL rendering remain unqualified.'])
(r/'data/4.20/grass_registered_tree_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
