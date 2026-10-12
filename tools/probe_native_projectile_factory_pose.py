from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(0,4096)
wrapper=vector+0x6000;troy=vector+0x8000;control=vector+0x9000;nameptr=vector+0xa000;posptr=vector+0xa100;live=True;events=[];trace=[]
def hook(uc,a,size,user):
 if a<base:raise RuntimeError('unexpected low code target '+hex(a)+' prior '+str([hex(x) for x in trace[-20:]]))
 trace.append(a);sp=u.reg_read(UC_X86_REG_ESP);obj=u.reg_read(UC_X86_REG_ECX)
 if a==0x718a70:events.append('wrapper-allocation');finish(wrapper+4);return
 if a==0x6c9490:events.append('entity-bounds-update');finish(0);return
 if a==0x5fa170:events.append('missing-resource-log');finish(0);return
 if a==0x564c20:
  src=read(sp+4);length=read(sp+8);assert length<=15
  u.mem_write(obj,bytes(u.mem_read(src,length))+b'\0');w(obj+16,length);w(obj+20,15);finish(obj,8);return
 if a==0x664e50:finish(obj,8);return
 if a==0x6ceee0:
  events.append('resource-acquisition');w(obj,troy);w(obj+4,control);w(control+4,3 if live else 0);w(control+8,3);finish(obj);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(entry,obj,args,edx=0):
 u.mem_write(stack-0x1000,b'\0'*0x2000);w(0,0);w(stack,end)
 for i,arg in enumerate(args):w(stack+4+i*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_EDX,edx);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 try:u.emu_start(entry,end,count=20000)
 except Exception:print('FAULT',hex(u.reg_read(UC_X86_REG_EIP)),hex(entry),'TRACE',[hex(a) for a in trace[-35:]]);raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 return u.reg_read(UC_X86_REG_EAX)
def words(a,n):return list(struct.unpack('<'+'I'*n,u.mem_read(a,n*4)))
def state():return dict(wrapper_position=words(wrapper+0x60,3),wrapper_type=read(wrapper+0xb0),ended=read(wrapper+0x124),troy_flags=read(troy+0x24),troy_requests=read(troy+0x144),troy_position=words(troy+0x40,3),troy_matrix=words(troy+0x88,16),events=events.copy())
rows=[]
for factory_flags,position,pending,live in itertools.product([0,1,0x40,0x41],[[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.]],[0,1,2,4,7],[False,True]):
 events=[];u.mem_write(wrapper,b'\0'*0x200);u.mem_write(troy,b'\0'*0x180);u.mem_write(control,b'\0'*0x20);u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',*position))
 assert run(0x93fd60,troy,[0,nameptr,0])==troy
 w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(wrapper+0x144,pending);w(0x2d628c0,0)
 assert run(0x7172b0,0,[0,posptr,factory_flags,0,0],nameptr)==wrapper
 after_load=state()
 result=run(0x6c97b0,wrapper,[0])
 rows.append(dict(factory_flags=factory_flags,position=position,pending_flags=pending,live=live,after_load=after_load,after_update=state(),update_return=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['93FD60','7172B0','6C8E30','6C96F0','6C97B0'],findings=['Actual projectile7172B0 flags0 do not set Troy orientation bit10; pending wrapper144 controls mapping1->10,2->2,4->20 through original6C96F0.','Source flags and matrix are measured after native load and first wrapper update; flags0/pending0 retain constructor identity orientation.','Source position initially receives MAX_FLOAT sentinel at native load; first wrapper update transmits entity position.'],adapters=['718A70 supplies a zero-initialized wrapper with verified10A4960 table and base type212; full wrapper allocator/base constructor unqualified.','6CEEE0 resource acquisition supplies original93FD60-constructed Troy and live/expired weak control; actual resource manager/parser remains open.','6C9490 entity-bounds update omitted; its collision bookkeeping is separate from Troy pose setters.','5FA170 missing-resource logging omitted; resource failure branches otherwise execute.','564C20 short ASCII string assign and664E50 container initialization adapted; native shared/weak helpers and concrete Troy virtual bodies execute.','Global registry2D628C0 absent: original717970 returns without registration. Wrapper providers148/150 null; no owner callback tested here.'],limits=['Initial construction/load/first wrapper update with supplied resource availability; subsequent projectile provider binding and owner phase need composition.','Native wrapper allocation, resource parser, registry/collision scheduling, long strings and concurrent ownership remain unqualified.','No live rendering or complete champion/game acceptance.'])
(r/'data/4.20/projectile_factory_pose_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_instruction_addresses=proof['native_instruction_addresses'])))
