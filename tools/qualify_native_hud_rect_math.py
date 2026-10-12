from pathlib import Path
import json,struct,hashlib,itertools,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD Rect native prerequisites','exec'))
obj=vector+0x8000;text=vector+0x9000;offset=vector+0xa000
scanned=[];scan_count=0;warnings=0
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def bits(x):return struct.unpack('<I',struct.pack('<f',x))[0]
def uv_hook(uc,a,size,user):
 global warnings
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x993ba0:
  assert read(sp+4)==text
  for k,x in enumerate(scanned[:max(0,scan_count)]):u.mem_write(read(sp+12+k*4),struct.pack('<f',x))
  finish(scan_count);return
 if a==0x5642d0:warnings+=1;finish(0);return
 assert 0x9a2180<=a<0x9a22ae,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,uv_hook)
cases=[]
for scan_count,coords,dims,origin in itertools.product(range(8),[(0.,0.,1.,1.),(16.,32.,96.,128.),(-4.,7.,-1.,3.)],[(256.,512.),(1024.,1024.)],[(0.,0.),(.25,-.125),(7.,11.)]):
 scanned=list(coords+dims);warnings=0;u.mem_write(obj,b'\xa5'*0x200);u.mem_write(text,b'controlled scanner boundary\0');u.mem_write(offset,struct.pack('<2f',*origin));u.mem_write(stack-0x100,b'\0'*0x100)
 w(stack,end);w(stack+4,obj);w(stack+8,text);w(stack+12,0);w(stack+16,offset);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x9a2180,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=list(struct.unpack('<4I',u.mem_read(obj+0x1c0,16)));accepted=scan_count in (4,6)
 if accepted:
  uv=list(coords)
  if scan_count==6:uv=[f32(f32(1./dims[k%2])*x) for k,x in enumerate(uv)]
  expected=[bits(f32(x+origin[k%2])) for k,x in enumerate(uv)]
 else:expected=[0xa5a5a5a5]*4
 assert actual==expected and u.reg_read(UC_X86_REG_EAX)==(16 if accepted else 0) and warnings==int(not accepted),(scan_count,actual,expected)
 cases.append(dict(scan_count=scan_count,coordinates_bits=[bits(x) for x in coords],dimensions_bits=[bits(x) for x in dims],origin_bits=[bits(x) for x in origin],output_bits=actual,result=16 if accepted else 0,warnings=warnings))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,property='Rect',entry='0x9a2180',registry_reference='0x9a1336',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Native formatted scanning boundary supplied float outputs and assignment count; original CRT scanner grammar is not qualified.','Diagnostic logger adapted; original x86 float normalization, origin addition, storage, return and failure branches execute.'],limits=['Finite positive reference dimensions only; zero/nonfinite dimensions and other FP modes remain open.','Rect property transformation only; native source parser, coordinate/layout, widget visibility, sampler and drawing remain open.'])
(r/'data/4.20/native_hud_rect_math_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),passed=True)))
