from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text().split('\nfor lay,fail in itertools.product')[0]
source=source.replace("if name=='GetCurrentThreadId':emit(name,[],123);finish(123);return","if name=='GetCurrentThreadId':emit(name,[],thread_id);finish(thread_id);return")
thread_id=123;exec(compile(source,'paired-context-setup','exec'));first=vector+0x12000;second=vector+0x13000

def invoke(entry,args=()):
 w(stack,end)
 for j,v in enumerate(args):w(stack+4+j*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,end,count=40000);assert u.reg_read(UC_X86_REG_EIP)==end
 return u.reg_read(UC_X86_REG_EAX)

def paired(pattern,cookie,lay,reverse):
 global record,tls_value,thread_id
 record=first;thread_id=123;u.mem_write(second,bytes([pattern])*0x3bc);root=run(pattern,cookie,lay,'none');after_startup=snapshot();root_calls=len(calls)
 record=second;tls_value=0;thread_id=456;assert invoke(0xca91a9)==second;after_second=snapshot();constructor_calls=len(calls)
 callbacks=[];tls_value=0
 for ref in ([second,first]if reverse else[first,second]):
  before=snapshot();start=len(calls);invoke(0xca9026,(ref,));assert u.reg_read(UC_X86_REG_ESP)==stack+8
  callbacks.append({'record':ref,'before':before,'after':snapshot(),'calls':list(calls[start:]),'stack_delta':8})
 before_cleanup=snapshot();invoke(0xca9341);assert freed==([second,first]if reverse else[first,second])
 return {'pattern':pattern,'cookie':cookie,'layout':lay,'reverse':reverse,'before':root['before'],'after_startup':after_startup,'after_second_constructor':after_second,'startup_call_count':root_calls,'constructor_call_count':constructor_calls,'callbacks':callbacks,'before_cleanup':before_cleanup,'after':snapshot(),'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'last_error':last_error,'terminal':True}
for lay,reverse in itertools.product(['none','all'],[False,True]):paired(0,0x11223344,lay,reverse)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(first,first+0x3bc),(second,second+0x3bc),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged]
rows=[paired(pattern,cookie,lay,reverse)for pattern,cookie,lay,reverse in itertools.product([0,165],[0,0x11223344,0xffffffff],['none','all'],[False,True])]
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Original CA92CB startup followed by CA91A9 second-thread context creation executes against the same PE globals, initialized lock table and slot index. Original CA9026 destructors execute in both retirement orders with actual stdcall stack delta8; every observed global/record/service-entry byte bank retained.','Thread identities, per-thread slot switching, calloc and OS lock/heap effects are supplied explicit boundaries. Callback bodies called directly, not a simultaneous original OS thread run. Actual production shared Windows slot independently qualified on x86/x64. Rust paired native intermediate bank replay pending.']}
(r/'data/4.20/audio_crt_paired_thread_lifetime_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_paired_thread_lifetime.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'paired original constructor/destructor cases;',len(regions),'regions')
