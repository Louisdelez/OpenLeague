from pathlib import Path
import json, struct, hashlib, datetime, itertools, math
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native emulator base','exec'))
renderer=0x41000000;u.mem_map(renderer,0x30000)
owner=vector+0x9000;source=vector+0xa000;texture=vector+0xb000;device=vector+0xc000;vtable=vector+0xd000;pool=vector+0xe000
sampler=end+0x100;shader=end+0x200;constant=end+0x300
w(0x2d79078,renderer);w(renderer+0x14,device);w(renderer+0x20330,pool);w(renderer+0x2d8,0x12345678)
w(owner+4,source);w(source+0x10,0x6543210);w(texture+0x10,0x7654321)
w(device,vtable);w(vtable+0x70,sampler);w(vtable+0x90,shader);w(vtable+0x98,constant)
events=[];visited=set()
def args(sp,n):return [read(sp+4+i*4) for i in range(n)]
def floats(a,n):return list(struct.unpack('<'+'f'*n,u.mem_read(a,n*4)))
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);cx=uc.reg_read(UC_X86_REG_ECX);dx=uc.reg_read(UC_X86_REG_EDX)
 if a==0x985e50:events.append(dict(kind='acquire',owner=cx,args=args(sp,5)));finish(texture,20);return
 if a==0x984e60:events.append(dict(kind='copy',source=cx,target=dx,args=args(sp,2)));finish(0);return
 if a==0x9abee0:events.append(dict(kind='state',value=cx));finish(0);return
 if a==sampler:events.append(dict(kind='sampler',device=cx,args=args(sp,3)));finish(0,12);return
 if a==0x983cb0:events.append(dict(kind='target',owner=cx,args=args(sp,2)));finish(0,8);return
 if a==0x9805c0:events.append(dict(kind='lookup',owner=cx,name=string(read(sp+4))));finish(0,4);return
 if a==shader:events.append(dict(kind='shader',device=cx,args=args(sp,1)));finish(0,4);return
 if a==constant:
  values=args(sp,3);events.append(dict(kind='constants',device=cx,register=values[0],values=floats(values[1],values[2]*4),count=values[2]));finish(0,12);return
 if a==0x986ad0:events.append(dict(kind='draw',color=read(cx),texture=dx,rect=floats(sp+4,4),tail=read(sp+20)));finish(0);return
 if a==0x986040:events.append(dict(kind='release',owner=cx,args=args(sp,1)));finish(0,4);return
 assert 0x73d610<=a<0x73d832,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for width,height,quality,cached in itertools.product([640,1280,1920],[480,800,1080],[-2147483648,-1,0,1,2,3,2147483647],[False,True]):
 w(source+0x38,width);w(source+0x3c,height);w(source+0x24,21);w(0x2d7c4d0,int(cached));w(0x2d7c4d4,0)
 events.clear();w(stack,end);w(stack+4,quality);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x73d610,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+8
 assert events[0]==dict(kind='acquire',owner=pool,args=[width,height,21,pool,0])
 assert events[1]==dict(kind='copy',source=0x6543210,target=texture,args=[0,0])
 constants=[x for x in events if x['kind']=='constants'];assert len(constants)==2
 assert constants[0]['register']==0 and constants[0]['count']==1
 assert all(math.isclose(a,b,rel_tol=1e-6,abs_tol=1e-8) for a,b in zip(constants[0]['values'],[1/width,1/height,0,0]))
 bits=[0x3f400000,0x3f000000,0x3daa9931,0] if quality<=1 else [0x3f000000,0x3e29fbe7,0x3daa9931,0]
 expected=list(struct.unpack('<4f',struct.pack('<4I',*bits)))
 assert constants[1]['register']==1 and constants[1]['values']==expected
 assert [x['args'] for x in events if x['kind']=='sampler']==[[0,4,2],[0,5,2],[0,6,2]]
 assert [x['name'] for x in events if x['kind']=='lookup']==([] if cached else ['PS_FXAA'])
 assert next(x for x in events if x['kind']=='draw')==dict(kind='draw',color=0xffffffff,texture=0x7654321,rect=[0.,0.,float(width),float(height)],tail=0)
 assert events[-1]==dict(kind='release',owner=pool,args=[texture])
 cases.append(dict(width=width,height=height,option=quality,cached=cached,events=list(events)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x73d610',case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original FXAA orchestration instructions executed; external resource-pool, device, copy, shader lookup, quad draw and release methods recorded at call boundaries.', 'No shader instructions or actual GPU rendering executed. Resource-pool internal allocation and original multisampling remain unqualified.', 'Negative and zero qualities exercise body clamping only; ordinary caller gate rejects these values.'])
(r/'data/4.20/native_fxaa_pass_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
