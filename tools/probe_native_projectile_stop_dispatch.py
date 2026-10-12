from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(0,4096)
body=vector+0x6000;controller=body+0x578;helper=vector+0x7000;wrapper=vector+0x8000;troy=vector+0x9000
helper_control=vector+0xa000;troy_control=vector+0xa100;table=vector+0xb000;control_table=vector+0xb200
getter=vector+0xc000;destroy=vector+0xc010;dispose=vector+0xc020
events=[];finished=False;update_continues=False
def hook(uc,a,size,user):
 global update_continues
 if a==getter:finish(int(finished));return
 if a in [destroy,dispose]:events.append('destroy' if a==destroy else 'dispose');finish(0);return
 if a==0x6c9824:update_continues=True;u.emu_stop();return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(entry,obj,arg=None):
 w(0,0);u.mem_write(stack-0x1000,b'\0'*0x2000);w(stack,end)
 if arg is not None:w(stack+4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(entry,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP) in [end,0x6c9824],hex(u.reg_read(UC_X86_REG_EIP))
 return u.reg_read(UC_X86_REG_EAX)
def snapshot():return dict(ended=read(wrapper+0x124),requests=read(troy+0x144),wrapper_link=bool(read(wrapper+0x11c)),wrapper_control=bool(read(wrapper+0x120)),helper_strong=read(helper_control+4),helper_weak=read(helper_control+8),troy_strong=read(troy_control+4),troy_weak=read(troy_control+8),events=events.copy())
rows=[]
for helper_state,troy_state,initial_ended,requests in itertools.product(['alive','expired','absent','null'],['alive','expired','absent'],[0,9],[0,0x400,0x2000,0x80000401,0xffffffff]):
 for obj,size in [(body,0x600),(helper,0x40),(wrapper,0x200),(troy,0x200),(helper_control,0x20),(troy_control,0x20),(table,0x200),(control_table,0x40)]:u.mem_write(obj,b'\0'*size)
 events=[];w(controller+0x14,helper)
 w(helper+8,0 if helper_state=='null' else wrapper);w(helper+0xc,0 if helper_state=='absent' else helper_control);w(helper+0x10,wrapper)
 w(helper_control,control_table);w(helper_control+4,0 if helper_state=='expired' else 1);w(helper_control+8,2)
 w(wrapper+0x11c,troy);w(wrapper+0x120,0 if troy_state=='absent' else troy_control);w(wrapper+0x124,initial_ended)
 w(troy_control,control_table);w(troy_control+4,0 if troy_state=='expired' else 1);w(troy_control+8,2)
 w(control_table,destroy);w(control_table+4,dispose);w(troy,table);w(table+0xa0,0x9289b0);w(table+0x14,getter);w(troy+0x144,requests)
 stages=[]
 for _ in range(2):assert run(0x763240,body)==1;stages.append(snapshot())
 finished=False;update_continues=False;result=run(0x6c97b0,wrapper,0)
 update=dict(continues=update_continues,returned=None if update_continues else result)
 for _ in range(2):assert run(0x6c9360,wrapper)==1;stages.append(snapshot())
 rows.append(dict(helper_state=helper_state,troy_state=troy_state,initial_ended=initial_ended,initial_requests=requests,stages=stages,update=update))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=len([a for a in visited if base<=a<base+len(image)]),findings=['Projectile vtable10B2B5C slot48 is763240; controller578 stop763CF0 locks helper weak reference and marks wrapper124=1 when lock yields a nonnull object.','Wrapper6C97B0 returns false for marked effects; non-marked effects continue past6C9824, where this probe stops.','Wrapper virtual48 at6C9360 calls concrete Troy virtualA0/9289B0: requests144 |=400, then clears its weak link. Repeated cleanup does not call stop again.','Original5BD6F0/5EC2A0/5CCF80 execute weak lock and temporary reference release; supplied live/expired/absent/null profiles distinguish eligibility.'],adapters=['Troy finished query virtual14 returns false. Control block virtual destroy/dispose callbacks record events; their bodies are not qualified.','Controller optional collectionC is empty; wrapper registry188 is empty; supplied ownership objects and counters.'],limits=['Live registry decides when wrapper cleanup is invoked; that scheduler and network projectile removal semantics are not yet qualified.','Non-marked wrapper pose update body, nonempty controller collections, registry removal and concurrent ownership remain open.','Client integration, original audio stop, GPU lifetime and complete Annie kit remain incomplete.'])
(r/'data/4.20/projectile_stop_dispatch_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_instruction_addresses=proof['native_instruction_addresses'])))
