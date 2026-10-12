from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text(encoding='utf-8').split('\nfor lay,fail in itertools.product')[0]
needle='u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))';assert needle in source;source=source.replace(needle,'u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))');exec(compile(source,'packet-setup','exec'));original_hook=hook
incoming=vector+0x14000;id_output=vector+0x29600;thread_api=vector+0x29200;w(0xfa4194,thread_api);baseline=bytes(u.mem_read(base,len(image)));phase=False;allocation_ok=True;handle=1;thread_error=0
def packet_hook(uc,a,z,user):
 global last_error
 sp=u.reg_read(UC_X86_REG_ESP)
 if phase and a==0xca8673:
  n,size=read(sp+4),read(sp+8);assert(n,size)==(1,956);result=incoming if allocation_ok else 0;emit('calloc',[n,size],result)
  if result:allocations.append({'reference':result,'size':size});u.mem_write(result,bytes(size))
  finish(result);return
 if phase and a==thread_api:
  args=[read(sp+i*4)for i in range(1,7)];assert args[2:4]==[0xc9c3dc,incoming]
  last_error=thread_error;u.mem_write(args[5],(456).to_bytes(4,'little'));emit('CreateThread',args,handle,{'supplied_thread_id':456,'supplied_last_error':thread_error});finish(handle,24);return
 original_hook(uc,a,z,user)
u.hook_add(unicorn.UC_HOOK_CODE,packet_hook)
def execute(lay,alloc,result,error,out,argument,flags):
 global phase,allocation_ok,handle,thread_error
 phase=False;run(0,0x11223344,lay,'none');allocation_ok=alloc;handle=result;thread_error=error;u.mem_write(incoming,bytes([0xa5])*956);w(id_output,0xa5a5a5a5)
 before=snapshot();calls.clear();freed.clear();allocations.clear();phase=True;w(stack,end)
 for i,value in enumerate([0,0,0x40029500,argument,flags,id_output if out else 0],1):w(stack+i*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xc9c27c,end,count=50000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=u.reg_read(UC_X86_REG_EAX);assert actual==(result if alloc else 0)
 return {'layout':lay,'allocation_ok':alloc,'handle':result,'thread_error':error,'explicit_id_output':out,'argument':argument,'flags':flags,'before':before,'after':snapshot(),'calls':list(calls),'freed':list(freed),'allocations':list(allocations),'result':actual,'last_error':last_error,'id_output':read(id_output),'terminal':True}
configs=list(itertools.product(['none','all'],[False,True],[0,0x76540000],[0,97],[False,True],[0,0xffffffff],[0,4]))
for cfg in configs:execute(*cfg)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+956),(incoming,incoming+956),(id_output,id_output+4),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[execute(*cfg)for cfg in configs]
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':0xc9c27c,'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Original beginthreadex packet producer executes allocation, parent required-context/locale capture, complete original constructor, sentinel handle field, callback/argument assignment and CreateThread. Allocator/CreateThread failures run original free and error mapping when supplied error97.','API outcomes supplied; CreateThread is not executed physically here. NonNULL callback only, default parent locale, no native exception injection, thread scheduling or worker-entry consumption. Thread-id output written at supplied API boundary even for failure as an explicitly controlled adversarial API outcome.']}
(r/'data/4.20/audio_crt_worker_packet_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_worker_packet.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'original beginthreadex packet producer cases',len(regions),'banks')
