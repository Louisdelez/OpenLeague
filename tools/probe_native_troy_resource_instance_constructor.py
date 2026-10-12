from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(0,0x1000)
obj=vector+0x6000;config=vector+0x7000;manager=vector+0x8000;quality_stub=vector+0xb000;lock_stub=vector+0xb010;manager_vt=vector+0xa000;quality=0
w(manager,manager_vt);w(manager_vt+0xc,quality_stub);w(0xfa41a0,lock_stub)
def hook(uc,a,size,user):
 visited.add(a)
 if a==quality_stub:finish(quality)
 elif a==lock_stub:finish(1,4)
 elif a==0x564af0:
  dest=u.reg_read(UC_X86_REG_ECX);u.mem_write(dest,b'\0');w(dest+16,0);w(dest+20,15);finish(dest,12)
 elif a==0x664e50:finish(u.reg_read(UC_X86_REG_ECX),8)
 elif a==0x93e9a0:finish(0,4)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
fields={'source_flags':0x70,'scale_bc':0xbc,'scale_c0':0xc0,'scale_c4':0xc4,'flags_1dc':0x1dc,'flags_1dd':0x1dd,'maximum_child_time':0xb4,'aggregated_child_flags':0x1b4}
cases=[]
for fill,radius,quality in itertools.product([0,0xa5,0xff],[0.,2.,128.],[0,2,3,5]):
 u.mem_write(obj,bytes([fill])*0x200);u.mem_write(config,b'\0'*0x220);w(config+0x138,struct.unpack('<I',struct.pack('<f',radius))[0])
 for off,val in [(0x2d773b4,0x3f800000),(0x2d773b8,0),(0x2d773bc,0)]:w(off,val)
 u.mem_write(stack-0x300,b'\0'*0x500);w(0,0)
 for off,value in [(0,end),(4,manager),(8,config),(12,0x12345678),(16,vector),(20,0)]:w(stack+off,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x93db40,end,count=2500)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==obj
 actual={k:(bytes(u.mem_read(obj+off,1))[0] if k.startswith('flags_') else read(obj+off)) for k,off in fields.items()}
 assert actual==dict(source_flags=0,scale_bc=0x3f800000,scale_c0=0x3f800000,scale_c4=0,flags_1dc=0,flags_1dd=fill&0xfe,maximum_child_time=0,aggregated_child_flags=0)
 actual['direction_words']=[read(obj+0x9c+4*i) for i in range(3)];assert actual['direction_words']==[0x3f800000,0,0]
 actual['minimum_words']=[read(obj+0x130+4*i) for i in range(3)];actual['maximum_words']=[read(obj+0x13c+4*i) for i in range(3)]
 def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
 half=struct.unpack('<f',u.mem_read(0x1138be0,4))[0];twice=struct.unpack('<f',u.mem_read(0x1138df8,4))[0];d=f32(radius*half);lo=f32(0.-d);hi=f32(lo+f32(d*twice))
 bits=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
 assert actual['minimum_words']==[bits(lo)]*3 and actual['maximum_words']==[bits(hi)]*3
 cases.append(dict(memory_fill=fill,radius=radius,quality=quality,instance=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x93db40',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),cases=cases,findings=['Original resource instance constructor93DB40 and empty child initialization93DF20 execute to return.','Flags70 and active flags1DC start0; scalesBC/C0 start1 and C4 starts0; child timeB4/aggregate1B4 start0.','Secondary flags1DD clears only bit0; remaining allocator bytes preserved. Do not assume whole byte zero.','Direction9C..A4 copies native globals2D773B4..BC. Bounds use resource138 with original f32 arithmetic.'],adapters=['564AF0 string-substring copy adapted to empty strings only;664E50 container constructor omitted.','Critical section initialization and manager quality virtualC adapted.','93E9A0 direction-matrix initialization omitted; orientation matrix and its numeric helper not qualified here.'],limits=['Resource descriptor supplied with zero children and strings; actual resource parser/nonempty emitter initialization remains open.','Does not establish age/start-time fields absent from observed constructor writes, nor lifecycle or live renderer integration.'])
(r/'data/4.20/troy_resource_instance_constructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=proof['native_instruction_addresses'])))
