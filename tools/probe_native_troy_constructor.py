from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(0,0x1000)
obj=vector+0x6000;nameptr=vector+0x7000
calls=[]
def hook(uc,a,size,user):
 visited.add(a)
 if a==0x564c20:
  sp=u.reg_read(UC_X86_REG_ESP);src=read(sp+4);length=read(sp+8);dest=u.reg_read(UC_X86_REG_ECX)
  assert length<=15
  u.mem_write(dest,bytes(u.mem_read(src,length))+b'\0');w(dest+16,length);w(dest+20,15)
  calls.append('short-string-assign');finish(dest,8)
 elif a==0x664e50:
  calls.append('container-initialization');finish(u.reg_read(UC_X86_REG_ECX),8)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
fields={'flags24':0x24,'dirty144':0x144,'scalar148':0x148,'scalar5c':0x5c,'scalar3c':0x3c,'scalar58':0x58}
cases=[]
for fill,name,argument8,argument10 in itertools.product([0,0xa5,0xff],['','Base.troy','AnnieQ.troy'],[0,0x12345678],[0,0x87654321]):
 u.mem_write(obj,bytes([fill])*0x180);u.mem_write(nameptr,name.encode()+b'\0');u.mem_write(stack-0x100,b'\0'*0x300);w(0,0)
 for offset,value in [(0,end),(4,argument8),(8,nameptr),(12,argument10)]:w(stack+offset,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);calls.clear();u.emu_start(0x93fd60,end,count=1500)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==obj and read(0)==0
 actual={k:read(obj+off) for k,off in fields.items()};actual['matrix_words']=[read(obj+0x88+4*i) for i in range(16)];actual['position_words']=[read(obj+0x40+4*i) for i in range(3)]
 assert actual==dict(flags24=0,dirty144=0x2000,scalar148=0,scalar5c=0x3f800000,scalar3c=0x3f800000,scalar58=0x3f800000,matrix_words=[0x3f800000 if i in [0,5,10,15] else 0 for i in range(16)],position_words=[0,0,0])
 assert read(obj)==0x10d6db4 and read(obj+4)==argument10 and read(obj+0x158)==argument8
 assert calls==['short-string-assign','container-initialization']
 cases.append(dict(memory_fill=fill,resource_name=name,argument8=argument8,argument10=argument10,troy=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x93fd60',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),cases=cases,adapters=['564C20 short ASCII string assignment only; names limited to15bytes.','664E50 internal container initialization omitted; container120..143 not qualified or consumed.'],findings=['Whole93FD60 returns native Troy pointer; original8DE480 and716810 matrix constructors both execute.','Flags24=0; dirty144=0x2000; scalar3C/58/5C=1; scalar148=0; position40..48=0; matrix88 identity independently of prefilled memory.','Previous factory tests used supplied flags80 and zero scalars; those are explicit test inputs, not original constructor defaults.'],limits=['Constructor alone: resource manager/loading can subsequently change flags; actual projectile after-load flags remain unqualified.','No live rendering, lifecycle, container, long-string allocation or full-game qualification.'])
(r/'data/4.20/troy_constructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=proof['native_instruction_addresses'])))
