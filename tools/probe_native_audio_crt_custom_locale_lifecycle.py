from pathlib import Path
import json,itertools
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text(encoding='utf-8')
exec(compile(source.split("\nfor lay,fail in itertools.product")[0],'root-startup-setup','exec'))
locale=vector+0x6000;conv=vector+0x6100;time=vector+0x7000;counters=vector+0x8000;payload=vector+0x9000
def ref(j):return payload+j*0x200
def counter(j):return counters+j*32
custom=[(locale,0xb8),(conv,0x60),(time,0x200)]+[(counter(j),32)for j in range(22)]+[(ref(j),512 if j in[22,23,24]else 32)for j in range(31)]
setup=(r/'tools/probe_native_audio_crt_custom_locale_destruction.py').read_text(encoding='utf-8').split('\ndef run(conversion,count,strings,ctype,custom_time):\n')[1].split('\n calls.clear()')[0]
exec('def populate(conversion,count,strings,ctype,custom_time):\n'+setup)
def invoke(entry,args=()):
 w(stack,end)
 for j,v in enumerate(args):w(stack+4+j*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
def lifetime(conversion,count,lay):
 for a,z in custom:u.mem_write(a,bytes(z))
 root=run(0,0x11223344,lay,'none');after_startup=snapshot();startup_calls=len(calls)
 old_locale=read(record+0x6c);invoke(0xca8b6f,(old_locale,));after_release_old=snapshot()
 populate(conversion,count,'all',True,True);w(locale,count);w(record+0x6c,locale)
 supplied=[{'reference':a,'size':z,'raw':bytes(u.mem_read(a,z)).hex()}for a,z in custom];before_detach=snapshot()
 invoke(0xca915b,(0,));after_detach=snapshot();detach_calls=len(calls);invoke(0xca9341)
 return {'conversion':conversion,'count':count,'layout':lay,'before':root['before'],'after_startup':after_startup,'after_release_old':after_release_old,'before_detach':before_detach,'after_detach':after_detach,'after':snapshot(),'old_locale':old_locale,'supplied_custom_allocations':supplied,'startup_call_count':startup_calls,'detach_call_count':detach_calls,'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'tls_value':tls_value,'last_error':last_error,'terminal':True}
for args in itertools.product(['null','static','defaults','heap'],[1,2],['none','all']):lifetime(*args)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24)]+[(a,a+z)for a,z in custom]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[lifetime(*args)for args in itertools.product(['null','static','defaults','heap'],[1,2],['none','all'])]
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':__import__('hashlib').sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Entire original startup, old locale reference release, controlled custom locale installation, actual CA915B/CA9026/CA8A15 destruction and system cleanup execute. Count1 triggers nested locale free helpers; count2 retains locale shared with an external owner. NULL/static/copied-default/dynamic conversion and TLS/FLS qualified. All4 intermediate/final banks and every imported/free entry captured.','Custom locale ownership structures installed explicitly; original normal locale creation/update producer not proved. Old default locale released through actual CA8B6F, without silently leaking its references. Custom time payload fields NULL; Windows/allocator outcomes supplied. No actual OS-triggered callback/concurrency proof. Rust replay pending.']}
(r/'data/4.20/audio_crt_custom_locale_lifecycle_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_custom_locale_lifecycle.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'whole original custom-locale thread lifetimes;',len(regions),'canonical regions')
