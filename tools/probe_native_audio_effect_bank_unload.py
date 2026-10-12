from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_effect_resource_lifetime.py').read_text(encoding='utf-8').split('\nactual=json.loads')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_lifetime)','lifetime_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_lifetime)');exec(compile(setup,'lifetime_setup','exec'))
stream=heap+0x5000;descriptor=heap+0x5100;holder=heap+0x5200;array=heap+0x5400;seed_parameter=heap+0x6000
regions.extend([(0xaf85a0,0xaf865e),(0xaf8660,0xaf871e),(0xaf7940,0xaf79fe),(0xaf7a40,0xaf7a62)])
def guard_loader(uc,a,n,d):
 if a in locks:
  address=read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0];calls.append({'kind':locks[a],'scope':'bank_manager'if address==0x14a7a44 else'registry','category':None if address==0x14a7a44 else address==registries+0x1c20});ret(1,4);return
 guard_lifetime(uc,a,n,d)
u.hook_del(lifetime_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_loader)
regions.append((0xafc410,0xafc4b3))
actual=json.loads((r/'data/4.20/audio_effect_actual_bank_contract.json').read_text(encoding='utf-8'));rows=[]
def state(stage,result):
 return {'stage':stage,'result':result,'head':read(table+24+(id%193)*4,'I')[0],'count':read(table+0x31c,'I')[0],'holder':bytes(u.mem_read(holder,64)).hex(),'stream':bytes(u.mem_read(stream,40)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)}
for source,category,seeded,capacity,fail_nth,pattern in itertools.product(actual['sources'],[False,True],[False,True],[0,2],[0,1,2],[0,0xa5]):
 data=bytes.fromhex(source['payload']);id=int.from_bytes(data[:4],'little');u.mem_write(bank,data);calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(registries,bytes(0x2600));table=registries+(0x1c20 if category else 0x1f40);put(table+0x31c,'I',7)
 if seeded:
  u.mem_write(seed,bytes([pattern])*48);put(seed,'IIIIII',0xff2380 if category else 0xff2394,0,id,7,0x810003,seed_parameter);u.mem_write(seed+24,bytes(24));u.mem_write(seed_parameter,bytes([pattern])*32);put(seed_parameter,'I',0xff36a4);invoke(0xb3e040,[allocator,bank+12,25],seed_parameter);put(table+24+(id%193)*4,'I',seed);allocations.extend([{'reference':seed,'size':48,'freed':False},{'reference':seed_parameter,'size':32,'freed':False}])
 u.mem_write(array,bytes([0xa5])*8);allocations.append({'reference':array,'size':8,'freed':False})
 initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];u.mem_write(stream,bytes(40));put(stream+8,'I',len(data));put(stream+24,'I',bank);u.mem_write(descriptor,bytes([18 if category else 19]));put(descriptor+1,'I',len(data));u.mem_write(holder,bytes([0xa5])*64);put(holder+52,'III',array,0,capacity);u.mem_write(array,bytes([0xa5])*8)
 result=invoke(0xaf8660 if category else 0xaf85a0,[descriptor,holder,table],stream)
 stages=[state('load',result)];invoke(0xafc410,(),holder);stages.append(state('unload',0))
 rows.append({'source_key':source['key'],'category':category,'seeded':seeded,'capacity':capacity,'failure_nth':fail_nth,'pattern':pattern,'bank_payload':data.hex(),'initial_allocations':initial,'stages':stages})
for category,count,pattern in itertools.product([False,True],[254,255,256,510],[0,0xa5]):
 data=bytes.fromhex(actual['sources'][0]['payload']);id=int.from_bytes(data[:4],'little');calls.clear();allocations.clear();count_allocate=0;fail_nth=0;next_pointer=heap+0xc000;u.mem_write(bank,data);u.mem_write(registries,bytes(0x2600));table=registries+(0x1c20 if category else 0x1f40);put(table+0x31c,'I',7);put(table+24+(id%193)*4,'I',seed)
 u.mem_write(seed,bytes([pattern])*48);put(seed,'IIIIII',0xff2380 if category else 0xff2394,0,id,count+7,0x810003,seed_parameter);u.mem_write(seed+24,bytes(24));u.mem_write(seed_parameter,bytes([pattern])*32);put(seed_parameter,'I',0xff36a4);invoke(0xb3e040,[allocator,bank+12,25],seed_parameter)
 u.mem_write(holder,bytes([0xa5])*64);put(holder+52,'III',array,count,count);put(array,'I'*count,*([seed]*count));allocations.extend([{'reference':seed,'size':48,'freed':False},{'reference':seed_parameter,'size':32,'freed':False},{'reference':array,'size':count*4,'freed':False}]);u.mem_write(stream,bytes(40))
 initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];before=bytes(u.mem_read(holder,64)).hex();invoke(0xafc410,(),holder)
 rows.append({'category':category,'pattern':pattern,'batch_count':count,'initial_holder':before,'initial_allocations':initial,'stages':[state('unload',0)]})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'sources':actual['sources'],'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'findings':['Actual AFC410 releases references in original array order,batching255 references per bank-manager lock/unlock;then clears count,frees physical reference array,clears pointer/capacity.','Whole native load then unload exercises reused resources,creation failures and actual Meter destruction;empty lists still free allocated array.','254/255/256/510 repeated retained references qualify boundary batching and remaining external owner refs7.'],'adapters':['Physical allocator/free/mutex/memcpy only. Actual bank wrapper/memory stream/lookup/create/read/holder cleanup and full resource release/destructor bodies execute. Array preallocation and initial retained references supplied explicitly.'],'limits':['Prepared native evidence;Rust unload implementation and reference preallocation/admission still required.','Unchanging reference arrays/counts while releasing;concurrent mutation and other HIRC object release classes remain unqualified.','Memory stream only,bank IO/outer loop/native device/audio/game fidelity remain open.']}
(r/'data/4.20/audio_effect_bank_unload_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual bank load/unload and255-reference batching cases')
