from pathlib import Path
from native_x87 import HardwareFyl2x
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_audio_effect_bank_loader.py').read_text(encoding='utf-8').split('\nactual=json.loads')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_loader)','loader_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_loader)')
exec(compile(setup,'loader_setup','exec'))
u.mem_map(heap+0x30000,0x10000)
voice=heap+0x30000;node=heap+0x31000;cache=heap+0x32000;binding=heap+0x32100;buffer=heap+0x33000;samples=heap+0x34000
put(0x121023c,'I',vt);put(0x1210228,'I',0xffffffff);put(0x12100f4,'I',48000);put(0x14a7a3c,'I',heap+0x35000)
instance_setup=(r/'tools/probe_native_audio_meter_instance.py').read_text(encoding='utf-8')
import ast
line=next(v for v in instance_setup.splitlines()if v.startswith('regions=['))
regions.extend(ast.literal_eval(line.split('=',1)[1]));regions.append((0xafc410,0xafc4b3))
hardware=HardwareFyl2x();ctx_destructor=read(0xff273c,'I')[0];finit=trap+0x600;u.mem_write(finit,b'\xdb\xe3\xc3')
def guard_pipeline(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);who=u.reg_read(UC_X86_REG_ECX)
 if a in [0xb3e570,0xb3e676,0xb3e6b7]:hardware.execute(u,a);return
 if a==ctx_destructor:calls.append({'kind':'context_destroy','reference':who});ret(who,4);return
 if a==0xb12e20:calls.append({'kind':'unsubscribe','parameter':read(sp+4,'I')[0]});ret(0,4);return
 if a in [0xae9f60,0xaeaf90]:calls.append({'kind':'register_callback'if a==0xae9f60 else'unregister_callback','callback':read(sp+4,'I')[0]});ret(0,0);return
 if a==0xb12320:
  id,bits,owner,transition,mode=read(sp+4,'5I');calls.append({'kind':'set_rtpc','manager':who,'id':id,'bits':bits,'owner':owner,'transition':list(read(transition,'2I')),'mode':mode});ret(1,20);return
 if a==0xca1d00:
  dst,value,size=read(sp+4,'3I');u.mem_write(dst,bytes([value&255])*size);calls.append({'kind':'clear','offset':dst-samples,'size':size});ret(dst,0);return
 if finit<=a<finit+3:return
 guard_loader(uc,a,n,d)
u.hook_del(loader_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_pipeline)
actual=json.loads((r/'data/4.20/audio_effect_actual_bank_contract.json').read_text(encoding='utf-8'));rows=[]
for source,category,index,pattern,fail_nth in itertools.product(actual['sources'],[False,True],range(4),[0,0xa5],range(7)):
 data=bytes.fromhex(source['payload']);id=int.from_bytes(data[:4],'little');u.mem_write(bank,data)
 calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(registries,bytes(0x2600));table=registries+(0x1c20 if category else 0x1f40);put(0x14a83c4,'I',0)
 u.mem_write(stream,bytes(40));put(stream+8,'I',len(data));put(stream+24,'I',bank);u.mem_write(descriptor,bytes([18 if category else 19]));put(descriptor+1,'I',len(data));u.mem_write(holder,bytes([0xa5])*64);put(holder+52,'III',array,0,2);u.mem_write(array,b'\xa5'*8);allocations.append({'reference':array,'size':8,'freed':False})
 u.mem_write(voice,b'\xa5'*0x500);put(voice+0x41c,'I',3);put(voice+0x470+index*20,'IIII',999,0,0,0)
 u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+24,'I',cache);u.mem_write(cache,bytes(36));put(cache+index*8,'BB',0,int(category));put(cache+index*8+4,'I',id);put(binding,'I',node)
 before=bytes(u.mem_read(voice,0x500)).hex();invoke(finit);stages=[]
 def snapshot(stage,result,processed=False):
  stages.append({'stage':stage,'result':result,'stream':bytes(u.mem_read(stream,40)).hex(),'holder':bytes(u.mem_read(holder,64)).hex(),'voice':bytes(u.mem_read(voice,0x500)).hex(),'head':read(table+24+(id%193)*4,'I')[0],'count':read(table+0x31c,'I')[0],'global_manager':read(0x14a83c4,'I')[0],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations],'calls':list(calls),'processed':processed,'buffer':bytes(u.mem_read(buffer,16)).hex()if processed else None,'samples':bytes(u.mem_read(samples,64)).hex()if processed else None})
 def process():
  plugin=read(voice+0x470+index*20+8,'I')[0]
  if not plugin:return False
  u.mem_write(samples,struct.pack('<16f',*([-0.25,.5,-1.,.125,0.,-.75,.25,1.]*2)));put(buffer,'IIIHH',samples,3,17,8,4);invoke(0xb3e400,[buffer],plugin);return True
 snapshot('load',invoke(0xaf8660 if category else 0xaf85a0,[descriptor,holder,table],stream));calls.clear()
 result=invoke(0xb270b0,[binding,index],voice);snapshot('replace',result,process()if result==1 else False);calls.clear()
 invoke(0xafc410,(),holder);snapshot('unload',0);calls.clear();snapshot('process_after_unload',1,process());calls.clear()
 invoke(0xb268e0,[index],voice);snapshot('teardown',1);calls.clear()
 if read(0x14a83c4,'I')[0]:invoke(0xb3ed30,[0])
 snapshot('update',1)
 assert all(a['freed']for a in allocations)
 rows.append({'source_key':source['key'],'category':category,'index':index,'pattern':pattern,'failure_nth':fail_nth,'bank_payload':data.hex(),'before':before,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'sources':actual['sources'],'native_sha256':hashlib.sha256(b).hexdigest(),'arithmetic_boundary':hardware.metadata(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Allocation/free/mutex/memcpy,context destructor,unsubscribe and callback registration remain boundaries. Actual bank wrapper/source creation/reader,voice retain/release,clone/Init/Reset/DSP,bank unload/source destruction,voice teardown and callback update bodies execute.'],'findings':['Source and original parameter are freed on bank unload;voice clones remain independently owned and process the same buffer afterward. All tracked objects freed after teardown/update,including allocation failures1..6.'],'limits':['Two original Meter payloads;controlled shared category,explicit holder array allocation,static non-bypass,empty subscriptions. Outer complete HIRC loop/device/scheduler/concurrency/audible acceptance remain required.']}
hardware.close();(r/'data/4.20/audio_effect_bank_voice_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'bank/voice clone/DSP/unload/teardown ownership cases')
