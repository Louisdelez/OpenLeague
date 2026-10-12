from pathlib import Path
import json,itertools
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text(encoding='utf-8')
exec(compile(source.split("\nfor lay,fail in itertools.product")[0],'original-startup-and-destructor','exec'))
buffers=vector+0x7000;custom_mb=vector+0x10000
def optional(strings,exception,mb,lay):
 root=run(0,0x11223344,lay,'none');after_startup=snapshot();startup_calls=len(calls)
 u.mem_write(buffers,bytes([0xa5])*8*32);w(custom_mb,{'custom0':0,'custom1':1,'custom2':2,'customMAX':0xffffffff}.get(mb,0))
 for j,off in enumerate([0x24,0x2c,0x34,0x3c,0x40,0x44,0x48]):w(record+off,buffers+j*32 if strings=='all'or(strings=='alternating'and j%2==0)else 0)
 w(record+0x5c,0x106b708 if exception=='static'else 0 if exception=='null'else buffers+7*32)
 if mb=='null':w(record+0x68,0)
 elif mb=='static1':w(0x1222bb0,1)
 elif mb.startswith('custom'):w(record+0x68,custom_mb)
 before_detach=snapshot();w(stack,end);w(stack+4,record);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca915b,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'strings':strings,'exception':exception,'multibyte':mb,'layout':lay,'before':root['before'],'after_startup':after_startup,'before_detach':before_detach,'after':snapshot(),'startup_call_count':startup_calls,'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'tls_value':tls_value,'last_error':last_error,'terminal':True}
for strings,ex,mb in itertools.product(['none','all','alternating'],['static','null','heap'],['null','default','static1','custom0','custom1','custom2','customMAX']):optional(strings,ex,mb,'all')
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24),(buffers,buffers+8*32),(custom_mb,custom_mb+4)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged]
rows=[optional(strings,ex,mb,lay)for strings,ex,mb,lay in itertools.product(['none','all','alternating'],['static','null','heap'],['null','default','static1','custom0','custom1','custom2','customMAX'],['none','all'])]
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual full startup and CA915B/CA9026 detachment execute. Controlled changes between stages set7 optional strings, static/NULL/heap exception field and NULL/default/static-count1/custom0/1/2/MAX multibyte refcount. Native destructor follows exact string order, free(NULL) exception branch, wrapped decrements and static buffer retention.','Intermediate field changes explicitly supplied ownership states; no claim normal constructors allocate these optional buffers yet. Native default locale used, custom locale destructor not qualified. Allocator and Windows service effects supplied; concurrency and OS callbacks not proved. Rust replay pending.']}
(r/'data/4.20/audio_crt_optional_thread_buffers_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_optional_thread_buffers.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'actual destructor optional-buffer/multibyte ownership cases;',len(regions),'canonical regions')
