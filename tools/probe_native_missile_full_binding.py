from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(0,0x1000)
wrapper=vector+0x6000;effect=vector+0x7000;effect_control=vector+0x7100;provider=vector+0x8000;provider_control=vector+0x8100;old=vector+0x9000;old_control=vector+0x9100;capture=vector+0x5000;events=[]
w(effect,0x10d6db4)
def bind_hook(uc,a,size,user):
 if a==0x9286c0:
  sp=u.reg_read(UC_X86_REG_ESP);ptr=read(sp+4);ctrl=read(sp+8);assert u.reg_read(UC_X86_REG_ECX)==effect;events.append(dict(provider=hex(ptr),control=hex(ctrl)))
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,bind_hook)
cases=[]
for old_present,provider_present,effect_live,effect_old_present in itertools.product([False,True],repeat=4):
 u.mem_write(effect,b'\0'*0xd0);w(effect,0x10d6db4);w(effect+0xc8,vector+0xa000 if effect_old_present else 0);w(effect+0xcc,vector+0xa100 if effect_old_present else 0);w(vector+0xa104,3);w(vector+0xa108,3);u.mem_write(wrapper,b'\0'*0x180);w(wrapper+0x148,old if old_present else 0);w(wrapper+0x14c,old_control if old_present else 0);w(old_control+4,3);w(old_control+8,3)
 w(wrapper+0x11c,effect);w(wrapper+0x120,effect_control);w(effect_control+4,3 if effect_live else 0);w(effect_control+8,3);w(provider_control+4,3);w(provider_control+8,3)
 ptr=provider if provider_present else 0;ctrl=provider_control if provider_present else 0;w(stack,end);w(stack+4,ptr);w(stack+8,ctrl);events=[];u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,wrapper);u.emu_start(0x6c9bd0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read(wrapper+0x148)==ptr and read(wrapper+0x14c)==ctrl
 assert len(events)==int(effect_live)
 if events:assert events[0]==dict(provider=hex(ptr),control=hex(ctrl))
 assert read(effect+0xc8)==(ptr if effect_live else vector+0xa000 if effect_old_present else 0)
 assert read(effect+0xcc)==(ctrl if effect_live else vector+0xa100 if effect_old_present else 0)
 cases.append(dict(effect_old_present=effect_old_present,effect_provider=hex(read(effect+0xc8)),effect_provider_control=hex(read(effect+0xcc)),old_present=old_present,provider_present=provider_present,effect_live=effect_live,bound_provider=hex(read(wrapper+0x148)),bound_control=hex(read(wrapper+0x14c)),events=events,old_strong=read(old_control+4),provider_strong=read(provider_control+4),effect_strong=read(effect_control+4)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x6c9bd0','0x9286c0'],native_instruction_addresses=len(visited),cases=cases,adapters=['Native shared/weak assignment/acquisition/release helpers execute.','Actual effect vtable10D6DB4 virtual68/9286C0 executes; incoming provider retained at effect+C8/+CC. No virtual endpoint adapted.'],limits=['Full projectile creation/update not executed here; old references retain extra ownership so destructor branches are not exercised.','Provider construction763BDC=10B0D20 established statically, not whole live gameplay.'])
(r/'data/4.20/missile_effect_owner_full_binding_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited))))
