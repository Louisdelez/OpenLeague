from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_audio_crt_worker_exit.py').read_text().split('\nconfigs=')[0]
source=source.replace('u.hook_add(unicorn.UC_HOOK_CODE,worker_hook)','')
exec(compile(source,'worker-body-setup','exec'))
callback=vector+0x29200;callback_result=0;callback_argument=0;seh_observations=[]
def body_hook(uc,a,z,user):
 if phase and a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+4)==callback_argument
  seh_observations.append({'boundary':'callback','fs_head':read(0),'frame':bytes(u.mem_read(read(0),16)).hex()})
  emit('worker_callback',[callback_argument],callback_result);finish(callback_result,4);return
 if phase and api_addresses.get(a)=='ExitThread':
  seh_observations.append({'boundary':'ExitThread','fs_head':read(0),'frame':bytes(u.mem_read(read(0),16)).hex()})
 worker_hook(uc,a,z,user)
u.hook_add(unicorn.UC_HOOK_CODE,body_hook)
def body(lay,code,arg,cookie):
 global phase,terminal,com_available,module_result,callback_result,callback_argument
 phase=False;terminal=False;com_available=True;module_result=0x76540000;run(0,cookie,lay,'none')
 w(record+0x54,callback);w(record+0x58,arg);w(record+0x3b4,0)
 callback_result=code;callback_argument=arg;seh_observations.clear()
 before=snapshot();calls.clear();freed.clear();allocations.clear();phase=True
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xc9c315,end,count=30000)
 assert terminal and freed==[record] and tls_value==0
 assert calls[-1]['kind']=='ExitThread'and calls[-1]['arguments']==[code]
 assert len(seh_observations)==2 and all(v['fs_head']!=0xffffffff for v in seh_observations)
 return {'layout':lay,'code':code,'argument':arg,'cookie':cookie,'before':before,'after':snapshot(),'calls':list(calls),'freed':list(freed),'tls_value':tls_value,'last_error':last_error,'seh_observations':list(seh_observations),'terminal':True}
configs=list(itertools.product(['none','all'],[0,97,0xffffffff],[0,0x40029600,0xffffffff],[0,0x11223344,0xffffffff]))
for cfg in configs:body(*cfg)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+956),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[body(*cfg)for cfg in configs]
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':0xc9c315,'callback_convention':'x86 stdcall one u32 argument; callee pops4','regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Complete original normal worker body runs actual SEH prolog CA2A30, required context CA9191, supplied callback and original worker-exit preparation C9C356 through imported ExitThread. Callback return passed unchanged as exit code. FS registration captured at callback and terminal boundary.','Imported Windows APIs, callback behavior and allocator outcomes supplied. No injected exception, filter CB27A1, fatal context, handler dispatch, OS exception/physical thread qualification. COM flag0 only; optional COM producer/release separately qualified.']}
(r/'data/4.20/audio_crt_worker_body_preparation.json').write_text(json.dumps(p,indent=2)+'\n')
(r/'tools/probe_native_audio_crt_worker_body.py').write_text(Path(__file__).read_text())
print('Captured',len(rows),'complete original normal worker bodies and SEH registration boundaries')
