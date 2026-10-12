"""Pinned PE once/type1 mutex oracle. No production writes or compilation.

The original ConCRT queue executes for uncontended acquisition; current-context
acquisition and Win32/CRT allocation/atexit remain explicit fixture boundaries.
Outer-initializer races are deterministic schedules, not concurrent execution.
"""
from pathlib import Path
import sys, json, struct, hashlib, itertools
OUT=Path(__file__).resolve().parent
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile, unicorn, capstone
from unicorn.x86_const import *
SOURCE=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
EXPECTED='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
raw=SOURCE.read_bytes();assert hashlib.sha256(raw).hexdigest()==EXPECTED
pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(base,(pe.OPTIONAL_HEADER.SizeOfImage+4095)&~4095);u.mem_write(base,image)
H=0x30000000;STACK=0x31000000;END=0x32000000;ALLOC=0x35000000
for p,n in [(H,0x10000),(STACK,0x10000),(END,0x10000),(ALLOC,0x10000)]:u.mem_map(p,n)
INIT=END+0x100;ENTER=END+0x200;LEAVE=END+0x300;DELETE=END+0x400;TID=END+0x500;SLEEP=END+0x600;INITEX=END+0x700
CALLBACK=END+0x800;NESTED=END+0x900;CONTEXT=H+0x800;FLAG=0x2d75530;SECOND=H+0x900
GSTATE=0x14b1840;CS=0x14b1844;READY=0x14af61c;GPTR=0x14af620
regions=[('once_state',GSTATE,4),('outer_cs',CS,24),('mutex_ready',READY,1),('mutex_pointer',GPTR,4),('clock_flag',FLAG,4),('second_flag',SECOND,4),('mutex',ALLOC,44)]
active=False;ops=[];writes=[];all_seen=set();seen=set();callbacks=[];thread=17;wait_steps=0;race=False;fail_alloc=False;register_result=0;outer_depth=0;live=False;dispatch=False;inner_boundary=False
def rd(p):return struct.unpack('<I',u.mem_read(p,4))[0]
def wr(p,v):u.mem_write(p,struct.pack('<I',v&0xffffffff))
def snapshot():return {name:bytes(u.mem_read(p,n)).hex() for name,p,n in regions}
def emit(kind,args):ops.append({'kind':kind,'args':args,'at_call':snapshot()})
def ret(pop=0,result=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=rd(sp);u.reg_write(UC_X86_REG_EAX,result);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def write_hook(uc,access,address,size,value,user):
 if active and any(p<=address and address+size<=p+n for _,p,n in regions):writes.append([address,size,value&((1<<(8*size))-1)])
def hook(uc,pc,size,user):
 global wait_steps,race,outer_depth,live
 if not active:return
 all_seen.add(pc);seen.add(pc);sp=u.reg_read(UC_X86_REG_ESP)
 if race and pc==0xce5264:wr(GSTATE,2);race=False;emit('schedule_initializer_publish',[2])
 if pc in [INIT,INITEX]:
  p,spin=rd(sp+4),rd(sp+8);assert p==CS and spin==4000
  emit('InitializeCriticalSectionEx' if pc==INITEX else 'InitializeCriticalSectionAndSpinCount',[p,spin]+([rd(sp+12)] if pc==INITEX else []))
  u.mem_write(CS,b'\x5a'*24);ret(12 if pc==INITEX else 8,1);return
 if pc==ENTER:emit('EnterCriticalSection',[rd(sp+4)]);outer_depth+=1;ret(4);return
 if pc==LEAVE:emit('LeaveCriticalSection',[rd(sp+4)]);outer_depth-=1;assert outer_depth>=0;ret(4);return
 if pc==DELETE:emit('DeleteCriticalSection',[rd(sp+4)]);assert outer_depth==0;ret(4);return
 if pc==TID:emit('GetCurrentThreadId',[]);ret(result=thread);return
 if pc==SLEEP:
  emit('Sleep',[rd(sp+4)]);wait_steps-=1
  if wait_steps==0:wr(GSTATE,2)
  assert wait_steps>=0;ret(4);return
 if pc==0xca8673:
  emit('calloc',[rd(sp+4),rd(sp+8)]);assert [rd(sp+4),rd(sp+8)]==[1,44]
  if not fail_alloc:u.mem_write(ALLOC,bytes(44));live=True
  ret(result=0 if fail_alloc else ALLOC);return
 if pc==0xc98528:emit('free',[rd(sp+4)]);assert rd(sp+4)==ALLOC and live;live=False;ret();return
 if pc==0xc97e4c:emit('atexit',[rd(sp+4)]);ret(result=register_result);return
 if pc==0xcbe75b:emit('ConCRT_current_context',[]);ret(result=CONTEXT);return
 if inner_boundary and pc in [0xcbee12,0xcbeeed]:emit('inner_lock' if pc==0xcbee12 else 'inner_unlock',[u.reg_read(UC_X86_REG_ECX)]);ret();return
 if pc in [CALLBACK,NESTED]:
  emit('callback',[pc] if rd(sp)==0xce52b3 else [pc,rd(sp+4)]);callbacks.append(pc)
  if pc==NESTED or not nested:ret()
  return
 if pc==0xce13ed:emit('CRT_abort',[rd(sp+4)]);raise RuntimeError('expected CRT allocation failure')
 if pc in [0xca3722,0xcc50eb]:raise RuntimeError('unqualified dependency '+hex(pc))
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_WRITE,write_hook)
def call(entry,args=(),ecx=0):
 global active
 sp=STACK+0xe000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),END,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,0);u.reg_write(UC_X86_REG_ECX,ecx);active=True
 try:u.emu_start(entry,END,count=300000)
 finally:active=False
 assert u.reg_read(UC_X86_REG_EIP)==END,hex(u.reg_read(UC_X86_REG_EIP))
 return u.reg_read(UC_X86_REG_EAX)
def reset(fill=0,mode=False,flag=0):
 global ops,writes,seen,callbacks,thread,wait_steps,race,fail_alloc,register_result,outer_depth,live,dispatch,nested,inner_boundary
 ops=[];writes=[];seen=set();callbacks=[];thread=17;wait_steps=0;race=False;fail_alloc=False;register_result=0;outer_depth=0;live=False;dispatch=mode;nested=False;inner_boundary=False
 u.mem_write(H,bytes([fill])*0x10000);u.mem_write(STACK,bytes([fill])*0x10000);u.mem_write(ALLOC,bytes([fill])*44)
 for _,p,n in regions:
  if p!=ALLOC:u.mem_write(p,bytes(n))
 wr(FLAG,flag);wr(0x1222ed0,0x12345678);wr(0x2da5310,0x12345678^(INITEX if mode else 0))
 for p,v in [(0xfa4270,INIT),(0xfa4424,ENTER),(0xfa4428,LEAVE),(0xfa41bc,DELETE),(0xfa4378,TID),(0xfa43c8,SLEEP)]:wr(p,v)
 # Supplied callback invokes a different once flag recursively when requested.
 code=b'\x68'+struct.pack('<I',0x76543210)+b'\x68'+struct.pack('<I',NESTED)+b'\x68'+struct.pack('<I',SECOND)+b'\xb8'+struct.pack('<I',0xce298a)+b'\xff\xd0\x83\xc4\x0c\xc3'
 u.mem_write(CALLBACK,code)
def capture(before,result=None):
 global ops,writes,seen
 row={'before':before,'after':snapshot(),'calls':ops,'writes':writes,'result':result,'executed':sorted(seen)};ops=[];writes=[];seen=set();return row
cases=[];boundary_cases=[]
for abstracted,fill,mode,flag,nest,registered in itertools.product([False,True],[0,165],[False,True],[0,1,0x80000000,0xffffffff],[False,True],[0,0xffffffff]):
 reset(fill,mode,flag);nested=nest;register_result=registered;inner_boundary=abstracted;steps=[]
 for i in range(3):
  if i==2:thread=99
  before=snapshot();call(0xce298a,[FLAG,CALLBACK,0x11223344]);steps.append(capture(before))
 assert rd(FLAG)==(1 if flag==0 else flag) and rd(ALLOC+0x24)==0xffffffff and rd(ALLOC+0x28)==0 and outer_depth==0
 assert len(callbacks)==(2 if nest else 1) if flag==0 else len(callbacks)==0
 before=snapshot();call(0xce2955);call(0xce52c1);shutdown=capture(before);assert not live and outer_depth==0
 (boundary_cases if abstracted else cases).append({'fill':fill,'dispatch_ex':mode,'initial_flag':flag,'nested':nest,'atexit_result':registered,'steps':steps,'shutdown':shutdown})
outer=[]
for initial,byte,mode in itertools.product([0,1,2,3],[0,1,128,255],[False,True]):
 reset(165,mode);wr(GSTATE,initial);u.mem_write(READY,bytes([byte]));wait_steps=2 if initial in [1,3] else 0
 before=snapshot();call(0xce5247,[READY,NESTED]);outer.append({'initial_state':initial,'initial_byte':byte,'dispatch_ex':mode,'race':False,'execution':capture(before)})
for mode in [False,True]:
 reset(165,mode);race=True;before=snapshot();call(0xce5247,[READY,NESTED]);outer.append({'initial_state':0,'initial_byte':0,'dispatch_ex':mode,'race':True,'execution':capture(before)})
allocations=[]
for fill,kind,failed in itertools.product([0,165],[1,0x101],[False,True]):
 reset(fill);fail_alloc=failed;wr(GPTR,0xdeadbeef);before=snapshot();value=call(0xce28cf,[GPTR,kind]);allocation=capture(before,value)
 if not failed:
  before=snapshot();call(0xce289e,[GPTR]);cleanup=capture(before)
 else:cleanup=None
 allocations.append({'fill':fill,'type':kind,'failed':failed,'allocation':allocation,'cleanup':cleanup})
specs=[('clock_once',0xce298a,0x42),('outer_once',0xce5247,0x7a),('outer_cleanup',0xce52c1,12),('once_mutex_initializer',0xce2961,0x29),('mutex_allocate',0xce28cf,0x3c),('mutex_lock',0xce290b,0x11),('type1_dispatch',0xce2702,0x164),('mutex_unlock',0xce2934,0x21),('mutex_cleanup_callback',0xce2955,12),('mutex_destroy',0xce289e,0x24),('inner_destroy',0x5642d0,1),('inner_initialize',0xcbe86c,0x20),('inner_lock',0xcbee12,0x30),('inner_unlock',0xcbeeed,0x71),('context_getter',0xcbe75b,0x22),('queue_node_construct',0xcbe789,0xce),('queue_acquire',0xcbeb45,0xa1),('queue_transfer',0xcbed6d,0x4d),('queue_wake',0xcbea36,0x23),('queue_flags',0xcbea59,0x51),('queue_wait_link',0xcbeaac,0x2d),('queue_wait_context',0xcbe8f3,0x88),('queue_node_retire',0xcbe97b,0x1e),('queue_node_cancel',0xcbea11,0x25),('critical_dispatch',0xcabd7a,0x2e),('sleep',0xcbe63c,0xe)]
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);source_rows=[];text=[]
for name,p,n in specs:
 data=image[p-base:p-base+n];source_rows.append({'name':name,'address':p,'size':n,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
 text.append(f'; {name} {p:08x}+{n:x}\n'+'\n'.join(f'{x.address:08x} {x.bytes.hex():24} {x.mnemonic} {x.op_str}' for x in decoder.disasm(data,p)))
(OUT/'clock_sync_disassembly.txt').write_text('\n\n'.join(text)+'\n',encoding='utf-8')
proof={'passed':True,'complete':False,'native_sha256':EXPECTED,'source':str(SOURCE),'cases':cases,'boundary_cases':boundary_cases,'outer_cases':outer,'allocation_cases':allocations,'source_regions':source_rows,'regions':[{'name':n,'address':p,'size':z} for n,p,z in regions],'executed_instruction_addresses':sorted(all_seen),'limits':['Original CE298A/CE5247/type1 mutex and actual uncontended ConCRT queue bodies execute unchanged in cases. Context acquisition returns explicit fixture pointer; scheduler/TLS is not qualified.','boundary_cases isolates CBEE12/CBEEED as explicit unchanged-byte fixture callbacks to qualify the outer/type1 port without claiming a ConCRT implementation. Production must supply a working qualified synchronization adapter.','Win32 CS initialization/enter/leave/delete, thread ID, Sleep, calloc/free and atexit are deterministic boundaries; no real concurrency/OS lock availability is claimed.','Outer state races are deterministic instruction-level schedules. Inner queue contention, scheduler block/unblock and arbitrary reentrant same-flag callback are not executed.','Native 5642D0 is RET. Tests destroy only retired/unowned mutexes; native destruction does not prove safety while other users remain.','Callback errors, host rollback and native exception unwinding need distinct qualification. No QPC/frequency or clock arithmetic is tested here.']}
(OUT/'clock_sync_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'lifetimes':len(cases),'boundary_lifetimes':len(boundary_cases),'outer_cases':len(outer),'allocation_cases':len(allocations),'instructions':len(all_seen),'source_regions':len(source_rows)}))
