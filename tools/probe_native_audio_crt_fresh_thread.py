from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
record=vector+0x12000;last_error=97;calls=[];trail=[];tls_record=0;failure='none';unsupported=None
apis={'GetLastError':(0xfa43bc,vector+0x28000),'TlsGetValue':(0xfa43fc,vector+0x28010),'SetLastError':(0xfa4440,vector+0x28020),'TlsSetValue':(0xfa43f4,vector+0x28030),'GetCurrentThreadId':(0xfa4378,vector+0x28040)}
for name,(iat,target)in apis.items():w(iat,target)
w(0x12230cc,5);w(0x2da5308,read(0x1222ed0));w(0x2da530c,read(0x1222ed0));u.mem_map(0,0x1000);w(0,0xffffffff)
def hook(uc,a,z,user):
 global last_error,tls_record,unsupported
 trail.append(a);sp=u.reg_read(UC_X86_REG_ESP)
 if a==vector+0x28000:calls.append({'kind':'GetLastError','result':last_error});finish(last_error);return
 if a==vector+0x28010:slot=read(sp+4);assert slot==5;calls.append({'kind':'TlsGetValue','index':slot,'result':tls_record,'last_error_before':last_error});last_error=0;finish(tls_record,4);return
 if a==vector+0x28020:value=read(sp+4);calls.append({'kind':'SetLastError','value':value});last_error=value;finish(0,4);return
 if a==vector+0x28030:
  slot=read(sp+4);value=read(sp+8);assert slot==5;ok=failure!='tls';calls.append({'kind':'TlsSetValue','index':slot,'value':value,'result':int(ok)})
  if ok:tls_record=value
  finish(int(ok),8);return
 if a==vector+0x28040:calls.append({'kind':'GetCurrentThreadId','result':123});finish(123);return
 if a==0xca8673:
  count=read(sp+4);size=read(sp+8);assert count==1 and size==0x3bc;result=0 if failure=='allocation'else record;calls.append({'kind':'calloc','count':count,'size':size,'result':result})
  if result:u.mem_write(result,bytes(size))
  finish(result);return
 if a==0xc98528:calls.append({'kind':'free','reference':read(sp+4)});finish(0);return
 # Keep original constructor and locking bodies running. Imported boundaries not covered stop explicitly.
 if not(base<=a<base+len(image)):
  unsupported=a;u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for existing,failure in [(True,'none'),(False,'allocation'),(False,'tls'),(False,'none')]:
 calls.clear();trail.clear();unsupported=None;last_error=97;tls_record=record if existing else 0;u.mem_write(record,bytes([165])*0x3bc);u.mem_write(stack-0x1000,bytes(0x1100));w(stack,end);w(0,0xffffffff);u.reg_write(UC_X86_REG_ESP,stack);fault=None
 try:u.emu_start(0xca91a9,end,count=5000)
 except unicorn.UcError as e:fault=str(e)
 terminal=u.reg_read(UC_X86_REG_EIP)==end;rows.append({'existing':existing,'failure':failure,'terminal':terminal,'result':u.reg_read(UC_X86_REG_EAX)if terminal else None,'last_error':last_error,'tls_record':tls_record,'thread_record':bytes(u.mem_read(record,0x3bc)).hex(),'calls':list(calls),'fault':fault,'unsupported':unsupported,'stopped_pc':u.reg_read(UC_X86_REG_EIP),'instruction_tail':[hex(a)for a in trail[-25:]]})
p={'saved_utc':__import__('datetime').datetime.now(__import__('datetime').timezone.utc).isoformat(),'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xca91a9','required_constructor':'0xca9218','case_count':len(rows),'terminal_case_count':sum(x['terminal']for x in rows),'cases':rows,'limits':['Original get-thread-data body and fallback TLS wrappers run; calloc/free and explicit Windows imported APIs are controlled ABI boundaries, not complete native CRT allocator or actual global initialization.','Mapped zero-page supplied solely as emulated SEH chain; failures/unsupported constructor dependencies retained with program counters. Fresh-thread construction not declared complete until all original dependencies are qualified.']}
(r/'docs/audio_crt_fresh_thread_discovery.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_fresh_thread.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print(json.dumps({'terminal':p['terminal_case_count'],'cases':[{k:x[k]for k in ['existing','failure','terminal','stopped_pc','fault','unsupported']}for x in rows]}))
