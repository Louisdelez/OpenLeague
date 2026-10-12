from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text(encoding='utf-8').split("\nfor lay,fail in itertools.product")[0]
# Install an API callback adapter; the actual CA9026 body executes in the emulator.
needle='u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))'
assert needle in source;source=source.replace(needle,'u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))')
exec(compile(source,'original-slot-lifetime-setup','exec'));original_hook=hook;callbacks=[];pending=None;marker=vector+0x2b000
def callback_hook(uc,a,z,user):
 global pending,tls_value
 if a==marker:
  sp,data=pending;assert u.reg_read(UC_X86_REG_ESP)==sp
  callbacks[-1]['after']=snapshot();callbacks[-1]['callback_stack_delta']=8;pending=None;finish(1,4);return
 name=api_addresses.get(a)
 if name in ['TlsFree','FlsFree']:
  sp=u.reg_read(UC_X86_REG_ESP);index=read(sp+4);emit(name,[index],1);data=tls_value;tls_value=0
  if name=='FlsFree'and data!=0:
   assert pending is None;pending=(sp,data);callbacks.append({'callback':0xca9026,'slot':index,'value':data,'slot_value_at_entry':tls_value,'before':snapshot()});w(sp-8,marker);w(sp-4,data);u.reg_write(UC_X86_REG_ESP,sp-8);u.reg_write(UC_X86_REG_EIP,0xca9026);return
  finish(1,4);return
 original_hook(uc,a,z,user)
u.hook_add(unicorn.UC_HOOK_CODE,callback_hook)
def invoke(entry,args=()):
 w(stack,end)
 for j,v in enumerate(args):w(stack+4+j*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
def lifetime(pattern,cookie,lay,state):
 global pending
 callbacks.clear();pending=None;root=run(pattern,cookie,lay,'none');after_startup=snapshot();startup_calls=len(calls)
 if state=='cleared':invoke(0xcabce1,(5,0))
 elif state=='detached':invoke(0xca915b,(0,))
 before_cleanup=snapshot();tls_before=tls_value;invoke(0xca9341);assert pending is None
 return {'pattern':pattern,'cookie':cookie,'layout':lay,'state':state,'before':root['before'],'after_startup':after_startup,'before_cleanup':before_cleanup,'after':snapshot(),'startup_call_count':startup_calls,'calls':list(calls),'callbacks':[dict(v)for v in callbacks],'allocations':list(allocations),'freed':list(freed),'tls_value_before_cleanup':tls_before,'tls_value':tls_value,'last_error':last_error,'terminal':True}
for lay,state in itertools.product(['none','all'],['live','cleared','detached']):lifetime(0,0x11223344,lay,state)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged]
rows=[lifetime(pattern,cookie,lay,state)for pattern,cookie,lay,state in itertools.product([0,165],[0,0x11223344,0xffffffff],['none','all'],['live','cleared','detached'])]
for v in rows:
 assert len(v['callbacks'])==int(v['layout']=='all'and v['state']=='live')
 assert v['freed']==([record]if v['state']=='detached'or(v['layout']=='all'and v['state']=='live')else[])
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual complete CA92CB startup/CA9341 cleanup, encoded slot wrappers and actualCA9026 callback body execute. Windows FLS adapter calls originalstdcall callback for live slot data, with actual native return stack delta8 and complete entry/exit banks; then original cleanup continues. TLS fallback has no callback. Cleared/detached/live states and actual physical free identities retained.','Windows callback initiation and slot clearing are explicit API boundary outcomes, corroborated on currentX86+X64 host12actualFLSFree callback state measurements. No OS callback executing the original/Rust CRT destructor provider or concurrency/SEH proof. TLS cleanup with live data or a merely cleared slot retains the record, as original observed; not declared leak-free. Rust replay pending.']}
(r/'data/4.20/audio_crt_fls_slot_lifetime_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_fls_slot_lifetime.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'whole original slot lifetimes; actualCA9026 callback executes at FLS-free boundary;',len(regions),'canonical regions')
