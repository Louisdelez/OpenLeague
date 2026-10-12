from pathlib import Path
import json,itertools
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text(encoding='utf-8')
exec(compile(source.split("\nfor lay,fail in itertools.product")[0],'original-thread-system-setup','exec'))
def invoke(entry,args=()):
 w(stack,end)
 for j,v in enumerate(args):w(stack+4+j*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
def lifetime(pattern,cookie,lay,explicit,saved_error):
 global last_error
 root=run(pattern,cookie,lay,'none');after_startup=snapshot();startup_calls=len(calls);last_error=saved_error
 invoke(0xca915b,(record if explicit else 0,));after_detach=snapshot();detach_calls=len(calls);detach_tls=tls_value;detach_error=last_error
 invoke(0xca9341)
 return {'pattern':pattern,'cookie':cookie,'layout':lay,'explicit_record':explicit,'saved_error':saved_error,'before':root['before'],'after_startup':after_startup,'after_detach':after_detach,'after':snapshot(),'startup_result':root['result'],'startup_call_count':startup_calls,'detach_call_count':detach_calls,'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'detach_tls_value':detach_tls,'detach_last_error':detach_error,'tls_value':tls_value,'last_error':last_error,'terminal':True}
for lay,explicit in itertools.product(['none','all'],[False,True]):lifetime(0,0x11223344,lay,explicit,97)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged]
rows=[lifetime(pattern,cookie,lay,explicit,error)for pattern,cookie,lay,explicit,error in itertools.product([0,165],[0,0x11223344,0xffffffff],['none','all'],[False,True],[0,97,0xffffffff])]
for v in rows:assert v['startup_result']==1 and v['freed']==[record]and v['tls_value']==0
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':['0xca92cb','0xca915b','0xca9341'],'destructor':'0xca9026','regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Complete original startup, thread detachment and system cleanup bodies execute. CA915B receives explicit record or resolves it through CABCC2; clears TLS/FLS through CABCE1 before actual CA9026 destructor. Destructor executes original multibyte/locale reference release, critical sections and record free. CA9341 then releases empty slot and destroys static locks. Entire service entry and both intermediate/final canonical banks captured.','Current cases use native default locale and zero-initialized constructed record, without optional heap strings/custom locales. Actual calloc/free and Windows boundaries supplied; no fake destructor callback. Windows-triggered asynchronous FLS callbacks, exceptions/concurrency and actual allocator/storage provider integration remain separate. Rust replay pending.']}
(r/'data/4.20/audio_crt_thread_lifecycle_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_thread_lifecycle.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'original complete startup/detach/destructor/system cleanup lifetimes;',len(regions),'canonical regions')
