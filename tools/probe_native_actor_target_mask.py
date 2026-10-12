from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
actor=vector+0x6000;visibility=vector+0x9000;manager=vector+0xa000;vt=vector+0xb000;stub=vector+0xc000
assert read(0x1092608+0x90)==0x617f10
w(0x2d787b8,manager);w(manager,vt);w(vt+0xb0,stub)
mode=False;helper_mode=False;calls=[];mode_calls=0
def hook(uc,a,size,user):
 global mode_calls
 visited.add(a)
 if a==stub:
  value=mode if mode_calls==0 else helper_mode;mode_calls+=1;calls.append(value);finish(int(value));return
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for flags,selector,mask in itertools.product(itertools.product([False,True],repeat=6),[-2,-1,0,1,2,31,32],[0,1,2,3,4,8,0x80000000,0xffffffff]):
 override,mode,field24,field2c,blocked,helper_mode=flags
 u.mem_write(actor,b'\0'*0x800);u.mem_write(visibility,b'\0'*0x100)
 w(actor+0x17c,visibility);w(visibility+0x28,mask);w(0x1223ebc,selector&0xffffffff)
 u.mem_write(0x14b1b80,bytes([int(override)]));u.mem_write(visibility+0x24,bytes([int(field24)]));u.mem_write(visibility+0x2c,bytes([int(field2c)]));u.mem_write(actor+0x5ea,bytes([int(blocked)]))
 calls.clear();mode_calls=0;w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x617f10,end,count=400)
 assert u.reg_read(UC_X86_REG_EIP)==end
 actual=bool(u.reg_read(UC_X86_REG_EAX)&255)
 mask_ok=not helper_mode or selector==-1 or (bool(mask&3) if selector==-2 else bool(mask&(1<<(selector&31))))
 expected=override or (not blocked and ((field24 and mask_ok) if mode else (field24 or field2c)))
 assert actual==expected,(flags,selector,mask,actual,expected)
 cases.append(dict(override=override,mode=mode,field24=field24,field2c=field2c,blocked=blocked,helper_mode=helper_mode,selector=selector,mask=mask,valid=actual,mode_calls=calls.copy()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x617f10','0x6b2c30'],native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),cases=cases,adapters=['Manager virtualB0 supplies two explicit boolean results for outer and nested calls; original6B2C30 executes without substitution.'],limits=['Boolean actor fields; selectors-2/-1/0/1/2/31/32 and eight masks. Names/roles of global selector and flags remain unqualified.','No mapping from live network state to native fields, no client or GPU acceptance.'])
(r/'data/4.20/actor_target_mask_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=proof['native_instruction_addresses'])))
