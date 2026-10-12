from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
actor=vector+0x6000;visibility=vector+0x9000;manager=vector+0xa000;vt=vector+0xb000;stub=vector+0xc000
assert read(0x1092608+0x90)==0x617f10
w(0x2d787b8,manager);w(manager,vt);w(vt+0xb0,stub)
mode=False;helper=False;calls=[]
def hook(uc,a,size,user):
 visited.add(a)
 if a==stub:calls.append('mode');finish(int(mode));return
 if a==0x6b2c30:calls.append('helper');finish(int(helper));return
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for override,mode,field24,field2c,helper,blocked in itertools.product([False,True],repeat=6):
 u.mem_write(actor,b'\0'*0x800);u.mem_write(visibility,b'\0'*0x100)
 w(actor+0x17c,visibility);u.mem_write(0x14b1b80,bytes([int(override)]))
 u.mem_write(visibility+0x24,bytes([int(field24)]));u.mem_write(visibility+0x2c,bytes([int(field2c)]));u.mem_write(actor+0x5ea,bytes([int(blocked)]))
 calls.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x617f10,end,count=200)
 assert u.reg_read(UC_X86_REG_EIP)==end
 actual=bool(u.reg_read(UC_X86_REG_EAX)&255)
 expected=override or (not blocked and ((field24 and helper) if mode else (field24 or field2c)))
 assert actual==expected
 cases.append(dict(override=override,mode=mode,field24=field24,field2c=field2c,helper=helper,blocked=blocked,valid=actual,calls=calls.copy()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x617f10',actor_vtable='0x1092608',slot='0x90',registration='0x4ff1f0',class_name='AIHeroClient',constructor='0x63c9f0',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),cases=cases,adapters=['Global manager virtualB0 supplies mode. Helper6B2C30 supplies explicit boolean; neither provider semantics is inferred.'],limits=['Boolean inputs only; raw actor fields17C->24/2C and5EAbit1 retained without death/visibility semantic labels.','Original617F10 decision executes. Constructor/table chain checked statically, not full actor allocation or projectile lookup.','No mapping from network snapshot to native field flags; no ordinary gameplay/GPU acceptance.'])
(r/'data/4.20/actor_target_validity_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=proof['native_instruction_addresses'])))
