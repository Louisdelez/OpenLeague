from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'running contract prerequisites','exec'))
before_running=types.FunctionType(boundary.__code__,globals());calls=[];sleep_calls=[];stream=0;first=0;second=0;worker_profile=None
def current():return read32(read32(stream+0x44)+12)
def running_boundary(uc,address,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if address==0x8a8b80:
  f,p,options=[read32(sp+i)for i in [4,8,12]];assert (f,p)==(0x8fb860,stream)
  name=options+16 if read32(options+36)<16 else read32(options+16)
  calls.append({'op':'launch','callback':f,'tag':bytes(u.mem_read(options,16)).hex(),'name':cbytes(name).decode(),'state':current(),'flags':list(u.mem_read(stream+4,3))})
  finish(eax=0);return
 if address in [0x8f7060,0x8f75d0]:
  count=2 if address==0x8f7060 else 4
  calls.append({'op':'implementation','method':address,'args':[read32(sp+4+i*4)for i in range(count)],'state':current(),'flags':list(u.mem_read(stream+4,3))})
  finish(eax=first if count==2 else second,pop=count*4);return
 return before_running(uc,address,size,user)
boundary.__code__=running_boundary.__code__
before_sleep=transport_windows
def transport_windows(dll,name,sp):
 if name=='Sleep' and worker_profile is not None:
  ms=read32(sp+4);sleep_calls.append(ms)
  if worker_profile=='three_polls':
   assert ms==1000
   if len(sleep_calls)==3:u.mem_write(stream+5,b'\0')
  elif worker_profile=='stop_while_paused':
   if len(sleep_calls)==1:assert ms==100;u.mem_write(stream+5,b'\0')
   elif len(sleep_calls)==2:assert ms==100;u.mem_write(stream+6,b'\0')
   else:assert sleep_calls==[100,100,1000]
  else:raise AssertionError(worker_profile)
  finish(pop=4);return True
 return before_sleep(dll,name,sp)
cases=[];workers=[]
try:
 for poison,state_id,first,second in itertools.product([0,165],range(6),[0,1,256,257],[0,1,256,257]):
  calls.clear();stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[])
  if state_id<5:node=read32(stream+0x50+state_id*4)
  else:
   node=heap+0xe500;u.mem_write(node,bytes(20));parent=read32(stream+0x5c)
   write32(node+12,99);write32(node+16,parent)
   for off in [0,4,8]:write32(node+off,read32(parent+off))
  write32(stream+0x44,node);implementation=heap+0xe100;write32(implementation,0x10d6254);write32(stream+0x64,implementation)
  args=[0x12345678,0x87654321,42,19,20,21]
  code=call(0x8f6af0,stream,args)
  cases.append({'fill':poison,'state_before':state_id,'first_return':first,'second_return':second,'arguments':args,'return_code':code,'state_after':current(),'flags':list(u.mem_read(stream+4,3)),'calls':list(calls)})
  # No join against supplied null worker. Restore inactive source fields before
  # ordinary destruction; this is a start contract, not a full worker lifetime.
  write32(stream+0x44,read32(stream+0x54));write32(stream+0x64,0);u.mem_write(stream+4,b'\1\0')
  call(0x8f67c0,stream,[1]);snapshot()
 for poison,worker_profile in itertools.product([0,165],['three_polls','stop_while_paused']):
  sleep_calls.clear();stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[])
  implementation=heap+0xe100;write32(implementation,0x10d5fec);write32(stream+0x64,implementation)
  u.mem_write(stream+5,bytes([1,worker_profile=='stop_while_paused']))
  call(0x8fb7b0,stream,[])
  workers.append({'fill':poison,'profile':worker_profile,'sleep_calls':list(sleep_calls),'flags':list(u.mem_read(stream+4,3))})
  write32(stream+0x64,0);call(0x8f67c0,stream,[1]);snapshot()
 proof={'passed':True,'native_sha256':digest,'cases':cases,'workers':workers,'limits':['192 native start contracts with supplied null thread-creation return and supplied implementation return words. Only low AL is consumed. Ancestor state3 includes a custom child state99. Source state transitions, allocation and pair factory are actual PE code.','Four worker-body traces use real no-op implementation and supplied Sleep boundaries that mutate run/pause flags. They prove polling order and pause semantics, not concurrent native scheduling or connection success. Full stream/CRT lifetimes have separate probes.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','workers','limits']}))
if not proof['passed']:sys.exit(1)
