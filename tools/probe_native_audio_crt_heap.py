from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
record=vector+0x12000;error_ptr=vector+0x14000;allocation=vector+0x15000;handler=vector+0x27000
regions=[('heap',0x14ae87c,4),('retry',0x14ae868,4),('new_mode',0x14af110,4),('encoded_handler',0x14ae620,4),('thread_errno',record+8,4),('fallback_errno',0x1222998,4),('error_argument',error_ptr,4),('error_table',0x1222830,45*8)]
api={};names={'HeapAlloc','HeapFree','GetLastError','Sleep','DecodePointer'}
for desc in pe.DIRECTORY_ENTRY_IMPORT:
 for imp in desc.imports:
  name=imp.name.decode('ascii')if imp.name else''
  if name in names:a=vector+0x28000+len(api)*16;w(imp.address,a);api[a]=name
baseline=bytes(u.mem_read(base,len(image)));calls=[];config={};alloc_index=0;handler_index=0
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def emit(kind,args,result):calls.append({'kind':kind,'arguments':args,'result':result,'at_call':snapshot()})
def hook(uc,a,z,user):
 global alloc_index,handler_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xca91a9:result=config['context'];emit('GetContext',[],result);finish(result);return
 if a==handler:
  seq=config['handler_results'];result=seq[min(handler_index,len(seq)-1)];handler_index+=1;emit('Handler',[a,read(sp+4)],result);finish(result);return
 name=api.get(a)
 if name=='HeapAlloc':
  seq=config['allocation_results'];result=allocation if seq[min(alloc_index,len(seq)-1)]else 0;alloc_index+=1;assert alloc_index<30,'unbounded supplied allocation script';emit(name,[read(sp+4),read(sp+8),read(sp+12)],result);finish(result,12);return
 if name=='HeapFree':result=config['free_result'];emit(name,[read(sp+4),read(sp+8),read(sp+12)],result);finish(result,12);return
 if name=='GetLastError':result=config['windows_error'];emit(name,[],result);finish(result);return
 if name=='Sleep':emit(name,[read(sp+4)],0);finish(0,4);return
 if name=='DecodePointer':result=config['decoded_handler'];emit(name,[read(sp+4)],result);finish(result,4);return
 assert base<=a<base+len(image),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(entry,args,context=record,retry=0,mode=0,decoded=0,handlers=(0,),outcomes=(1,),free_result=1,windows_error=0):
 global config,alloc_index,handler_index
 u.mem_write(base,baseline);w(0x14ae87c,0xabcdef01);w(0x14ae868,retry);w(0x14af110,mode);w(0x14ae620,0x87654321);w(record+8,0x11223344);w(0x1222998,0x55667788);w(error_ptr,0x12345678);calls.clear();alloc_index=handler_index=0
 config={'context':context,'retry':retry,'mode':mode,'decoded_handler':decoded,'handler_results':list(handlers),'allocation_results':list(outcomes),'free_result':free_result,'windows_error':windows_error}
 before=snapshot();w(stack,end)
 for j,arg in enumerate(args):w(stack+4+j*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,end,count=50000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_ESP)==stack+4
 return {'entry':entry,'arguments':list(args),'config':dict(config),'before':before,'after':snapshot(),'calls':list(calls),'result':u.reg_read(UC_X86_REG_EAX),'terminal':True}
rows=[]
pairs=[(1,944),(0,0),(1,0),(0,0xffffffff),(0xffffffff,0),(1,0xffffffe0),(1,0xffffffe1),(0xffffffff,2),(2,0x7ffffff0)]
for pair,context,success in itertools.product(pairs,[0,record],[0,1]):rows.append(run(0xca8673,pair,context=context,outcomes=(success,)))
for delay,outcomes in itertools.product([0,1,999,1000,2000,3000,0xffffffff],[(1,),(0,),(0,1),(0,0,1)]):
 if delay==0xffffffff and outcomes==(0,):continue
 rows.append(run(0xca8673,(1,944),retry=delay,outcomes=outcomes))
for pair,errptr,mode,decoded,outcomes,context,handlers in itertools.product([(1,944),(0,0xffffffff),(0xffffffff,2)],[0,error_ptr],[0,1],[0,handler],[(1,),(0,),(0,1)],[0,record],[(0,),(0xffffffff,0)]):rows.append(run(0xcbe04e,(*pair,errptr),mode=mode,decoded=decoded,handlers=handlers,outcomes=outcomes,context=context))
errors=sorted(set([0,1,2,5,19,36,37,188,202,203,0xffffffff]+[read(0x1222830+j*8)for j in range(45)]))
for ref,result,error,context in itertools.product([0,allocation],[0,1,0xffffffff],errors,[0,record]):rows.append(run(0xc98528,(ref,),free_result=result,windows_error=error,context=context))
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Original CA8673 wrapper/CBE04E calloc body, CBE63C Sleep helper, C98528 free, C9B780 errno selection, C9B79345entry/range error mapping and C9DC58 decoded new-handler dispatcher execute. Boundaries supply HeapAlloc/HeapFree, Windows error, Sleep, existing-or-NULL context and decoded handler results; exact call entry banks retained.','Allocation/OS services and context lookup supplied explicitly; calloc overflow/minimum-one-byte/retry/error branches qualified independently of real ownership. No actual new context/heap initialization/security-cookie/SEH or client audio integration proof. RetryMAX permanent failure is intentionally not made terminal; original unbounded wait retained as open runtime policy.']}
(r/'data/4.20/audio_crt_heap_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_heap.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8');print('Captured',len(rows),'original CRT calloc/base/free cases;',len(errors),'Windows errors')
