from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
record=vector+0x12000;storage=0x14ae988;regions=[];calls=[];access=set();collect=True;failure='none';layout='none';tls_value=0;last_error=97;export_index=0;freed=[];allocations=[];encode_key=0x13572468;api_addresses={}
api_names=['EncodePointer','GetModuleHandleW','GetProcAddress','InitializeCriticalSectionAndSpinCount','EnterCriticalSection','LeaveCriticalSection','DeleteCriticalSection','TlsAlloc','TlsFree','TlsGetValue','TlsSetValue','GetCurrentThreadId','GetLastError','SetLastError']
for desc in pe.DIRECTORY_ENTRY_IMPORT:
 for imp in desc.imports:
  name=imp.name.decode('ascii')if imp.name else''
  if name in api_names:a=vector+0x28000+api_names.index(name)*16;w(imp.address,a);api_addresses[a]=name
u.mem_map(0,0x1000);w(0,0xffffffff)
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def emit(kind,args,result,extra=None):
 v={'kind':kind,'arguments':args,'result':result,'at_call':snapshot()}
 if extra:v.update(extra)
 calls.append(v)
def string(a,wide=False):
 if not wide:return bytes(u.mem_read(a,128)).split(b'\0')[0].decode('ascii')
 out=[]
 for j in range(64):
  c=int.from_bytes(u.mem_read(a+j*2,2),'little')
  if not c:break
  out.append(chr(c))
 return ''.join(out)
def hook(uc,a,z,user):
 global tls_value,last_error,export_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xca8673:
  count,size=read(sp+4),read(sp+8);assert count==1 and size==0x3bc;result=0 if failure=='calloc'else record;emit('calloc',[count,size],result)
  if result:allocations.append({'reference':result,'size':size});u.mem_write(result,bytes(size))
  finish(result);return
 if a==0xc98528:ref=read(sp+4);emit('free',[ref],0);freed.append(ref);finish(0);return
 name=api_addresses.get(a)
 if name:
  if name=='EncodePointer':v=read(sp+4);emit(name,[v],v^encode_key);finish(v^encode_key,4);return
  if name=='GetModuleHandleW':emit(name,[string(read(sp+4),True)],0x12340000);finish(0x12340000,4);return
  if name=='GetProcAddress':module,name_s=read(sp+4),string(read(sp+8));result=vector+0x4000+export_index*16 if layout=='all'else 0;export_index+=1;emit(name,[module,name_s],result);api_addresses[vector+0x4000+(export_index-1)*16]=name_s;finish(result,8);return
  if name.startswith('InitializeCriticalSection'):
   ref,spin=read(sp+4),read(sp+8);args=[ref,spin]+([read(sp+12)]if name.endswith('Ex')else[]);emit(name,args,1,{'supplied_storage_bytes':'5a'*24});u.mem_write(ref,bytes([0x5a])*24);finish(1,len(args)*4);return
  if name in ['EnterCriticalSection','LeaveCriticalSection','DeleteCriticalSection']:
   ref=read(sp+4);extra={'supplied_storage_bytes':'dd'*24}if name=='DeleteCriticalSection'else None;emit(name,[ref],0,extra)
   if extra:u.mem_write(ref,bytes([0xdd])*24)
   finish(0,4);return
  if name in ['TlsAlloc','FlsAlloc']:args=[]if name=='TlsAlloc'else[read(sp+4)];result=0xffffffff if failure=='slot'else 5;emit(name,args,result);finish(result,len(args)*4);return
  if name in ['TlsFree','FlsFree']:assert tls_value==0,'live FLS destructor callback requires original execution';emit(name,[read(sp+4)],1);finish(1,4);return
  if name in ['TlsGetValue','FlsGetValue']:emit(name,[read(sp+4)],tls_value);last_error=0;finish(tls_value,4);return
  if name in ['TlsSetValue','FlsSetValue']:
   index,value=read(sp+4),read(sp+8);ok=failure!='set';emit(name,[index,value],int(ok))
   if ok:tls_value=value
   finish(int(ok),8);return
  if name=='GetCurrentThreadId':emit(name,[],123);finish(123);return
  if name=='GetLastError':emit(name,[],last_error);finish(last_error);return
  if name=='SetLastError':v=read(sp+4);emit(name,[v],0);last_error=v;finish(0,4);return
  raise AssertionError(('unimplemented API',name))
 assert base<=a<base+len(image),hex(a)
def memory(uc,kind,a,z,value,user):
 if collect and base<=a<base+len(image):access.update(range(a,a+z))
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))
def run(pattern,cookie,which_layout,fail):
 global layout,failure,tls_value,last_error,export_index
 u.mem_write(base,baseline);w(0x1222ed0,cookie);u.mem_write(record,bytes([pattern])*0x3bc);u.mem_write(storage,bytes([pattern])*36*24);calls.clear();allocations.clear();freed.clear();layout=which_layout;failure=fail;tls_value=0;last_error=97;export_index=0;u.mem_write(stack-0x1000,bytes(0x1100));w(stack,end);w(0,0xffffffff);u.reg_write(UC_X86_REG_ESP,stack);before=snapshot();u.emu_start(0xca92cb,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'pattern':pattern,'cookie':cookie,'layout':layout,'failure':failure,'before':before,'after':snapshot(),'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'result':u.reg_read(UC_X86_REG_EAX),'tls_value':tls_value,'last_error':last_error,'terminal':True}
for lay,fail in itertools.product(['none','all'],['none','slot','calloc','set']):run(0,0x11223344,lay,fail)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[run(pattern,cookie,lay,fail)for pattern,cookie,lay,fail in itertools.product([0,165],[0,0x11223344,0xffffffff],['none','all'],['none','slot','calloc','set'])]
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xca92cb','cleanup':'0xca9341','regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Full original CA92CB thread-system startup executes real C9A0B9/CABDE8 global handler/API resolution, CB0378 static lock setup, actualTLS/FLS slot wrappers and CA9218 constructor. Failure cleanup CA9341/CB027B original bodies run; API boundaries only supplied. No prefilled slot index or12/13 lock pointers. Every observed canonical read/write fragment, opaque storage and thread buffer, service entry and final bank captured.','Windows module/exports/pointer encoding, opaque5A/DD critical-section bytes, slot/calloc/TLS-set outcomes explicitly supplied. Real original calloc/heap/OS providers and security-cookie bootstrap not proved. FLS free with live value would require real destructor and is explicitly excluded; only failure cleanup with NULL slot data supplied. Rust replay pending.']}
(r/'data/4.20/audio_crt_thread_system_startup_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_thread_system_startup.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'whole original thread-system startup/failure-cleanup cases;',len(regions),'canonical regions')
