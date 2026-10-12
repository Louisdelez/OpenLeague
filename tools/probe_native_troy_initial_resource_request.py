from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(0,0x1000)
obj=vector+0x6000;resource=vector+0x7000;config=vector+0x8000;manager=vector+0x9000
requests=[];loaded=False
def hook(uc,a,size,user):
 visited.add(a)
 if a==0x9406db:u.emu_stop();return
 if a==0x564c20:
  sp=u.reg_read(UC_X86_REG_ESP);length=read(sp+8);assert length==0
  dest=u.reg_read(UC_X86_REG_ECX);u.mem_write(dest,b'\0');w(dest+16,0);w(dest+20,15);finish(dest,8)
 elif a==0x92be90:
  sp=u.reg_read(UC_X86_REG_ESP);requests.append(dict(package=read(sp+8),troy=read(sp+12),source=read(sp+20),scalar_words=read(sp+24)))
  finish(resource if loaded else 0,24)
 elif a==0xc975f5:finish(u.reg_read(UC_X86_REG_EAX))
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for dirty,flags,loaded in itertools.product([0,0x2000,0x2004,0x2800],[0,0x10,0x20,0x80,0x30,0xffffffff],[False,True]):
 for addr,size in [(obj,0x180),(resource,0x200),(config,0x220),(manager,0x30)]:u.mem_write(addr,b'\0'*size)
 w(obj+0x144,dirty);w(obj+0x24,flags);w(obj+0x1c,15);w(obj+4,0xface0000);w(obj+0x158,manager)
 w(manager+8,manager+0x20);w(resource+0xe8,config);w(obj+0x114,resource if loaded else 0)
 u.mem_write(stack-0x300,b'\0'*0x500);w(stack,end);w(0,0);requests.clear();u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj)
 u.emu_start(0x940570,end,count=2000)
 assert u.reg_read(UC_X86_REG_EIP)==0x9406db
 assert read(obj+0x24)==flags and read(obj+0x144)==dirty&~0x2000 and read(obj+0x114)==(resource if loaded else 0)
 assert len(requests)==int(bool(dirty&0x2000))
 if requests:assert requests[0]==dict(package=0xface0000,troy=obj,source=0,scalar_words=0)
 cases.append(dict(initial_dirty=dirty,initial_flags=flags,resource_available=loaded,final_dirty=read(obj+0x144),final_flags=read(obj+0x24),request_count=len(requests)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x940570',stop='0x9406db',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),cases=cases,findings=['Troy manager vtable10D6C70 slot4 resolves92BD30; it queues93FD60 constructor results.','First update940570 requests resource92BE90 only when dirty144 bit2000 set; clears that bit even on resource failure.','Original940F40 and941340 execute for supplied empty resource without owners; flags24 remain unchanged in all48cases.'],adapters=['564C20 empty short-string assignment; C975F5 security-cookie validation omitted while preservingEAX.','92BE90 resource allocation/loading returns supplied available or null pointer; actual parser and resource initialization not qualified.'],limits=['Empty resource collections and absent owner providers only; nonempty external bindings and owner resource scaling remain open.','Stops before full frame processing, dirty propagation, owner pose and lifecycle.','Does not justify enabling orientation bit10 for projectiles or assume real resource flags.'])
(r/'data/4.20/troy_initial_resource_request_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=proof['native_instruction_addresses'])))
