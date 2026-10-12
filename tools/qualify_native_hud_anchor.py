from pathlib import Path
import json,struct,hashlib,itertools,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native HUD Anchor prerequisites','exec'))
obj=vector+0x8000;text=vector+0x9000;values=[];count=0;warnings=0
def anchor_hook(uc,a,size,user):
 global warnings
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x993ba0:
  assert read(sp+4)==text
  for k,x in enumerate(values[:max(0,count)]):w(read(sp+12+k*4),x)
  finish(count&0xffffffff);return
 if a==0x5642d0:warnings+=1;finish(0);return
 assert 0x9a2000<=a<0x9a2065,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,anchor_hook);cases=[]
for count,values,initial,cached in itertools.product([-1,0,1,2],[(0,0),(1,2),(-4,7),(-2147483648,2147483647)],[(0,0),(99,-88),(2147483647,-2147483648)],[(11,22),(-33,44)]):
 warnings=0;u.mem_write(obj,b'\0'*0x200);u.mem_write(text,b'controlled scanner boundary\0')
 u.mem_write(obj+0x1a8,struct.pack('<4i',*(initial+cached)));w(stack,end);w(stack+4,obj);w(stack+8,text);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x9a2000,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=list(struct.unpack('<4i',u.mem_read(obj+0x1a8,16)));expected=list(initial)
 for k,x in enumerate(values[:max(0,count)]):expected[k]=x
 expected+=list(values if count==2 else cached)
 assert actual==expected and u.reg_read(UC_X86_REG_EAX)==(8 if count==2 else 0) and warnings==int(count!=2)
 cases.append(dict(assignment_count=count,values=list(values),initial=list(initial),cached=list(cached),output=actual,result=8 if count==2 else 0,warnings=warnings))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,property='Anchor',entry='0x9a2000',registry_reference='0x9a1290',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Formatted scanner integer outputs and assignment count supplied; original scanner grammar is not qualified.','Logger adapted; original partial-write preservation, successful copy and return branches execute.'],limits=['Integer property storage only; meaning of anchors, conversion to pixels, source parser and complete widget layout remain open.'])
(r/'data/4.20/native_hud_anchor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),passed=True)))
