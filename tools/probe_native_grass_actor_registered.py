from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
s=Path('E:/mapslol3v3/probe_native_grass_spatial_chain.py').read_text(encoding='utf-8').split('previous=')[0]
exec(compile(s,'connected native spatial setup','exec'))
model=terrain+0x4500;provider=terrain+0x4800;table=terrain+0x4c00;bounds=terrain+0x8000;bounds_api=0xc9f3a8;samples=[];calls=[]
def model_boundary(uc,a,size,user):
 if a==bounds_api:
  assert u.reg_read(UC_X86_REG_ECX)==provider
  sample=samples[min(len(calls),len(samples)-1)];calls.append(sample);u.mem_write(bounds,struct.pack('<6f',*sample));s=u.reg_read(UC_X86_REG_ESP)
  u.reg_write(UC_X86_REG_EAX,bounds);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
u.hook_add(unicorn.UC_HOOK_CODE,model_boundary)
previous=json.loads((r/'data/4.20/grass_actor_aabb_contract.json').read_text(encoding='utf-8'));cases=[]
fields=[0x48,0x4c,0x354,0x358,0x35c,0x360,0x364,0x368]
for input_index,present,parent_present,int_sse,raw in itertools.product(range(len(previous['cases'])),[False,True],[False,True],[False,True],[(0.,0.),(25.,75.)]):
 c=previous['cases'][input_index];u.mem_write(actor,bytes(0x2100));u.mem_write(model,bytes(0xb0));u.mem_write(spatial,bytes(0x40))
 u.mem_write(actor+0x60,struct.pack('<3f',*c['position']));f(actor+0x740,c['actor_scale']);write32(actor+0x2068,model if c['profile'] else 0)
 write32(model+0xa4,provider);f(model+4,c['model_scale']);write32(provider,table);write32(table+4,bounds_api)
 f(actor+0x380,raw[0]);f(actor+0x37c,raw[1]);f(actor+0x48,71.);f(actor+0x4c,19.)
 write32(actor+0xcc,node if present else 0);write32(node+8,spatial);f(spatial+0xc,99.)
 local=[-.1,-.2,-.3,.4,.5,.6];u.mem_write(spatial+0x10,struct.pack('<6f',*local));write32(spatial+0x28,parent if parent_present else 0);u.mem_write(spatial+0x2c,struct.pack('<4i',101,202,303,404))
 write32(0x14ae660,int(int_sse));write32(0x2da52e8,0)
 row=dict(input_index=input_index,node_present=present,parent_present=parent_present,integer_sse=int_sse,initial_local=local,raw_shape=raw[0],raw_radius=raw[1])
 for repeat in [False,True]:
  samples=c['bounds_calls'];calls.clear();events.clear();write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
  u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
  u.emu_start(0x6151a0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
  assert list(struct.unpack('<6I',u.mem_read(actor+0x95,24)))==c['aabb_bits'];assert calls==c['bounds_calls']
  result=dict(events=list(events),final=snapshot('final'),state_bits=[read32(actor+off) for off in fields],sentinel=read32(actor+0x36c),bounds_calls=list(calls))
  if repeat:row['repeat']=result
  else:row.update(result)
 cases.append(row)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6151a0',native_addresses=len(visited),cases=cases,runtime_adapters=['Explicit original model bounds provider virtual+4 supplies inherited stable/changing arrays.','Parent95FF10 boundary only records state and returns.','Same-PC RSQRTSS estimates supplied; remaining original code executes.'],limits=['Supplied finite input/state and two integer profiles; six-client match, registry lifecycle and actual source producers not qualified.','Parent algorithm, camera and normal grass mask/WALL integration remain open.'])
(r/'data/4.20/grass_actor_registered_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),sqrt_inputs=len(inputs))))
