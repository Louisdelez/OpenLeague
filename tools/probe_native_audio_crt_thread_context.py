from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_fresh_thread_initialized_locks.py').read_text(encoding='utf-8');exec(compile(source.split('\nu.hook_add(')[0],'setup','exec'))
original_hook=hook;accesses=set();written=set();collect=True;regions=[]
def memory_hook(uc,kind,a,z,value,user):
 if collect and base<=a<base+len(image):
  accesses.update(range(a,a+z))
  if kind==unicorn.UC_MEM_WRITE:written.update(range(a,a+z))
def snapshot_full():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def wrapped(uc,a,z,user):
 before=snapshot_full()if regions else None;n=len(calls);original_hook(uc,a,z,user)
 if len(calls)>n and before is not None:calls[-1]['at_call']=before
u.hook_add(unicorn.UC_HOOK_CODE,wrapped);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory_hook);baseline=bytes(u.mem_read(base,len(image)))
def run(existing,fail,error,pattern,counter):
 global last_error,tls_record,failure,unsupported
 u.mem_write(base,baseline);calls.clear();trail.clear();failure=fail;last_error=error;unsupported=None;tls_record=record if existing else 0;u.mem_write(record,bytes([pattern])*0x3bc)
 if counter is not None:
  for a in counters:w(a,counter)
 u.mem_write(stack-0x1000,bytes(0x1100));w(stack,end);w(0,0xffffffff);u.reg_write(UC_X86_REG_ESP,stack);before=snapshot_full();u.emu_start(0xca91a9,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'existing':existing,'failure':fail,'last_error_before':error,'pattern':pattern,'initial_refcount':counter,'before':before,'after':snapshot_full(),'result':u.reg_read(UC_X86_REG_EAX),'last_error':last_error,'tls_record':tls_record,'calls':list(calls),'terminal':True}
for existing,fail in [(True,'none'),(False,'allocation'),(False,'tls'),(False,'none')]:run(existing,fail,97,165,None)
collect=False;counters=sorted({a&~3 for a in written});addresses=sorted({a&~3 for a in accesses});intervals=[]
for a in addresses:
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
regions=[('thread_record',record,0x3bc)]+[(f'global_{a:08x}',a,b-a)for a,b in intervals]
rows=[run(existing,fail,error,pattern,counter)for (existing,fail),error,pattern,counter in itertools.product([(True,'none'),(False,'allocation'),(False,'tls'),(False,'none')],[0,97,0xffffffff],[0,165],[0,1,0xffffffff])]
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xca91a9','constructor':'0xca9218','locale_retain':'0xca8980','regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_global_written_counter_addresses':counters,'cases':rows,'limits':['Original getter/TLS wrappers/thread initializer/locale retain and lock-dispatch execute; explicit calloc/free/Windows imported boundaries and supplied initialized lock-table12/13, TLSslot5, static PE default locale. All original PE data reads/writes in four branch paths captured as canonical fragments. Every service entry bank and final bank retained.','Zero-page SEH chain and temporary stack provided; no exceptions or concurrency qualified. Capture covers static default-locale pointer layout; alternative locales, linked-counter branches, real heap/lock/TLS startup and normal game playback remain separate. Rust replay pending.']}
(r/'data/4.20/audio_crt_thread_context_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_thread_context.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'native thread contexts;',len(regions),'canonical regions; counters',*[hex(a)for a in counters])
