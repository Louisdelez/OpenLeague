from pathlib import Path
import json,struct,hashlib,itertools,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD UV native prerequisites','exec'))
obj=vector+0x8000;text=vector+0x9000;scanned=[];scan_count=0;warnings=0;scans=0
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def bits(x):return struct.unpack('<I',struct.pack('<f',x))[0]
def uv_hook(uc,a,size,user):
 global warnings,scans
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x993ba0:
  scans+=1;assert read(sp+4)==text
  for k,x in enumerate(scanned[:max(0,scan_count)]):u.mem_write(read(sp+12+k*4),struct.pack('<f',x))
  finish(scan_count);return
 if a==0x5642d0:warnings+=1;finish(0);return
 assert 0x9a2590<=a<0x9a2713,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,uv_hook);cases=[]
for kind,scan_count,coords,dims in itertools.product([0,1,2,3,0xffffffff],range(8),[(0.,0.,1.,1.),(16.,32.,96.,128.),(-4.,7.,-1.,3.)],[(256.,512.),(1024.,1024.)]):
 scanned=list(coords+dims);warnings=scans=0;u.mem_write(obj,b'\xa5'*0x300);w(obj+0x40,kind);u.mem_write(text,b'controlled scanner boundary\0');u.mem_write(stack-0x100,b'\0'*0x100)
 w(stack,end);w(stack+4,obj);w(stack+8,text);w(stack+12,0);w(stack+16,0);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x9a2590,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 first=list(struct.unpack('<8I',u.mem_read(obj+0x204,32)));second=list(struct.unpack('<8I',u.mem_read(obj+0x264,32)));accepted=kind in(1,2) and scan_count in(4,6)
 expected=[0xa5a5a5a5]*8
 if accepted:
  uv=list(coords)
  if scan_count==6:uv=[f32(f32(1./dims[k%2])*x) for k,x in enumerate(uv)]
  expected=[bits(x) for x in uv]*2
 assert first==(expected if kind==1 else [0xa5a5a5a5]*8) and second==(expected if kind==2 else [0xa5a5a5a5]*8)
 assert u.reg_read(UC_X86_REG_EAX)==(64 if accepted else 0) and warnings==int(not accepted) and scans==int(kind in(1,2))
 cases.append(dict(element_type=kind,scan_count=scan_count,coordinates_bits=[bits(x) for x in coords],dimensions_bits=[bits(x) for x in dims],type1_output_bits=first,type2_output_bits=second,result=64 if accepted else 0,warnings=warnings,scanner_calls=scans))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,property='UV',entry='0x9a2590',registry_reference='0x9a157b',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Native formatted scanning boundary supplied float outputs and assignment count; original CRT scanner grammar remains open.','Diagnostic logger adapted; original type guards, SSE normalization, duplicated UV storage and return/failure branches execute.'],limits=['Finite positive reference dimensions; zero/nonfinite dimensions and other FP modes remain open.','Element type construction and icon/effect association, source parser, layout and drawing remain open.'])
(r/'data/4.20/native_hud_uv_property_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),passed=True)))
