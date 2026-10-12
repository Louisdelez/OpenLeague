from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text().split('\nfor lay,fail in itertools.product')[0]
needle='u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))'
assert needle in source;source=source.replace(needle,'u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))')
exec(compile(source,'native-worker-exit-setup','exec'));original_hook=hook
extra={0xfa42d4:('LoadLibraryExW',vector+0x29000),0xfa42e8:('DecodePointer',vector+0x29010),0xfa42d8:('ExitThread',vector+0x29020)}
for iat,(name,a)in extra.items():w(iat,a);api_addresses[a]=name
baseline=bytes(u.mem_read(base,len(image)));ro=vector+0x29100;phase=False;terminal=False;com_available=True;module_result=0x76540000
def worker_hook(uc,a,z,user):
 global terminal
 sp=u.reg_read(UC_X86_REG_ESP);name=api_addresses.get(a)
 if phase:
  if name=='LoadLibraryExW':args=[string(read(sp+4),True),read(sp+8),read(sp+12)];assert args==['combase.dll',0,0x800];emit(name,args,module_result);finish(module_result,12);return
  if name=='GetProcAddress':args=[read(sp+4),string(read(sp+8))];assert args==[module_result,'RoUninitialize'];value=ro if com_available and module_result else 0;emit(name,args,value);finish(value,8);return
  if name=='EncodePointer':value=read(sp+4);emit(name,[value],value^encode_key);finish(value^encode_key,4);return
  if name=='DecodePointer':value=read(sp+4);emit(name,[value],value^encode_key);finish(value^encode_key,4);return
  if a==ro:emit('RoUninitialize',[],0);finish(0);return
  if name=='ExitThread':emit(name,[read(sp+4)],0);terminal=True;u.emu_stop();return
 original_hook(uc,a,z,user)
u.hook_add(unicorn.UC_HOOK_CODE,worker_hook)
def execute(lay,com,cached,available,code,state,module):
 global phase,terminal,com_available,tls_value,failure,module_result
 phase=False;terminal=False;com_available=available;module_result=module;root=run(0,0x11223344,lay,'none')
 w(record+0x3b4,com);w(0x14ae604,cached);w(0x14ae600,ro^encode_key)
 if state=='null_failure':tls_value=0;failure='calloc'
 if state=='fresh':tls_value=0
 before=snapshot();calls.clear();freed.clear();allocations.clear();phase=True;w(stack,end);w(stack+4,code);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xc9c356,end,count=30000);assert terminal and api_addresses.get(u.reg_read(UC_X86_REG_EIP))=='ExitThread'
 return {'layout':lay,'com':com,'cached':cached,'available':available,'module':module,'exit_code':code,'state':state,'before':before,'after':snapshot(),'calls':list(calls),'freed':list(freed),'allocations':list(allocations),'tls_value':tls_value,'last_error':last_error,'terminal':True}
configs=list(itertools.product(['none','all'],[0,1,0xffffffff],[0,1,0xffffffff],[False,True],[0,97,0xffffffff],['existing']))
configs+=list(itertools.product(['none','all'],[0],[0],[True],[0,0xffffffff],['null_failure','fresh']))
configs=[(*v,0x76540000)for v in configs]+list(itertools.product(['none','all'],[1,0xffffffff],[0],[False],[0,0xffffffff],['existing'],[0]))
for args in configs:execute(*args)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda pair:pair[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[execute(*args)for args in configs]
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':0xc9c356,'com_release':0xc9c459,'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Entire original worker exit executes getter, conditional original COM release helper, original explicit detach/destructor and imported ExitThread boundary. All service-entry and final canonical banks captured.','Windows/heap/COM import outcomes supplied. ExitThread is a terminal emulation boundary, not actual OS termination; cached COM pointer supplied. Fresh lookup allocation uses the single controlled canonical record. No real TLS/COM worker integration or SEH proof.']}
(r/'data/4.20/audio_crt_worker_exit_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_worker_exit.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Captured',len(rows),'original full worker-exit cases with',len(regions),'canonical banks')
