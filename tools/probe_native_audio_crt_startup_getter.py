from pathlib import Path
import json,itertools
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text(encoding='utf-8')
exec(compile(source.split("\nfor lay,fail in itertools.product")[0],'native-full-startup-setup','exec'))
def composite(pattern,cookie,lay,saved_error):
 global last_error
 root=run(pattern,cookie,lay,'none');after_startup=snapshot();startup_call_count=len(calls)
 last_error=saved_error;w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca91a9,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'pattern':pattern,'cookie':cookie,'layout':lay,'saved_error':saved_error,'before':root['before'],'after_startup':after_startup,'after':snapshot(),'startup_result':root['result'],'getter_result':u.reg_read(UC_X86_REG_EAX),'startup_call_count':startup_call_count,'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'tls_value':tls_value,'last_error':last_error,'terminal':True}
for lay in ['none','all']:composite(0,0x11223344,lay,97)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged]
rows=[composite(pattern,cookie,lay,error)for pattern,cookie,lay,error in itertools.product([0,165],[0,0x11223344,0xffffffff],['none','all'],[0,97,0xffffffff])]
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':['0xca92cb','0xca91a9'],'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual complete original successful CA92CB startup immediately followed by original CA91A9 getter. Dispatch resolved by original33 exports, initialized static lock table and real constructor; no prefilled record or TLS slot. All original service entry banks, intermediate startup bank and final bank retained.','LastError0/97/MAX supplied as controlled service state between startup/getter; actual host FLSGetValue resettingLastError corroborated separately. Both fallback TLS and resolved FLS lookup execute. Opaque Windows/heap service outcomes supplied; live FLS destructor, new thread after startup, concurrency and real normal client audio integration not proved. Rust replay pending.']}
(r/'data/4.20/audio_crt_startup_getter_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_startup_getter.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'complete startup then actual TLS/FLS getter cases;',len(regions),'canonical regions')
