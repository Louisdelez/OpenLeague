from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_device_factory.py').read_text(encoding='utf-8').split('\nfor kind,')[0];s=s.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_factory)','factory_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_factory)');exec(compile(s,'factory_setup','exec'))
local.extend([(0xb262f0,0xb263cf),(0xb263e0,0xb26429),(0xb26580,0xb265b5),(0xb2f310,0xb2f357),(0x5eb4b0,0x5eb4b6)]);device=heap+0x9400;buffer=0x33000000;u.mem_map(buffer,0x40000);output=heap+0x7810;recorder_reference=heap+0x9600;stream_reference=heap+0x9800;stream_vtable=heap+0x9a00;stream_write=heap+0x15000;stream_close=heap+0x15010;tick_api=read(0xfa4338,'I')[0];rows=[]
u.hook_del(factory_hook)
def guard_fallback(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
 if a==tick_api:calls.append({'kind':'tick','value':clock_tick});ret(clock_tick,0);return
 if a==0xada610:
  pool,size,alignment=read(sp+4,'3I');reference=0 if allocation_failure else buffer;calls.append({'kind':'allocate','method':'aligned','allocator':pool,'size':size,'alignment':alignment,'reference':reference})
  if reference:
   if size:u.mem_write(reference,bytes([pattern])*size)
   allocations.append({'reference':reference,'size':size,'freed':False})
  ret(reference,0);return
 if a==0xca1d00:
  reference,value,size=read(sp+4,'3I');assert value==0
  if size:u.mem_write(reference,bytes(size))
  calls.append({'kind':'zero_buffer','reference':reference,'size':size});ret(reference,0);return
 if a==stream_write:
  reference=read(sp+4,'I')[0];calls.append({'kind':'recording_write','stream':this,'reference':reference,'status':record_status});ret(record_status,4);return
 if a==stream_close:calls.append({'kind':'recording_close','stream':this});ret(0,0);return
 if any(lo<=a<hi for lo,hi in local):return
 guard_factory(uc,a,n,d)
u.hook_add(unicorn.UC_HOOK_CODE,guard_fallback)
def seed():
 calls.clear();allocations.clear();u.mem_write(device,bytes([pattern])*44);put(device,'4I',0xff25b0,0,0,0);put(device+0x1c,'I',3);put(0x1210228,'I',0xffffffff);put(0x12100dc,'I',0xffffffff);put(output,'I',0xa5a5a5a5)
def snapshot():return {'device':bytes(u.mem_read(device,44)).hex(),'output':read(output,'I')[0],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
for mask,rate,clock_tick,pattern,allocation_failure in itertools.product([0,1,3,7,0x80000000,0xffffffff],[24000,44100,48000,96000,192000],[0,12345,0xffffffff],[0,0xa5],[False,True]):
 seed();put(0x12100f4,'I',rate);before=snapshot();result=invoke(0xb262f0,[mask],device);init=invoke(0x5eb4b0,[],device);rows.append({'operation':'configure','pattern':pattern,'mask':mask,'rate':rate,'clock':clock_tick,'allocation_failure':allocation_failure,'before':before,'result':result,'init_result':init,'after':snapshot(),'calls':list(calls)})
for period,previous_tick,offset,pattern in itertools.product([0,1,5,10,21,42,100,0xffffffff],[0,1000,0xffffffff],['same','one','below','period','above','multiple','zero'],[0,0xa5]):
 clock_tick={'same':previous_tick,'one':(previous_tick+1)&0xffffffff,'below':(previous_tick+period-1)&0xffffffff,'period':(previous_tick+period)&0xffffffff,'above':(previous_tick+period+1)&0xffffffff,'multiple':(previous_tick+period*2+3)&0xffffffff,'zero':0}[offset];seed();put(device+32,'2I',previous_tick,period);before=snapshot();fault=False
 try:result=invoke(0xb263e0,[output],device)
 except (unicorn.UcError,AssertionError) as error:
  assert period==0 and clock_tick>=previous_tick
  if isinstance(error,unicorn.UcError):assert error.errno==unicorn.UC_ERR_EXCEPTION
  else:assert u.reg_read(UC_X86_REG_EIP)==0xb26411
  fault=True;result=None
 rows.append({'operation':'quota','pattern':pattern,'period':period,'previous_tick':previous_tick,'clock':clock_tick,'offset':offset,'native_arithmetic_fault':fault,'before':before,'result':result,'after':snapshot(),'calls':list(calls)})
for buffer_present,recording,record_status,data_size,pattern in itertools.product([False,True],['none','empty','live'],[1,52],[0,12345,0xffffffff],[0,0xa5]):
 seed()
 if buffer_present:put(device+12,'I',buffer);u.mem_write(buffer,bytes([pattern])*256);allocations.append({'reference':buffer,'size':256,'freed':False})
 if recording!='none':
  put(device+4,'I',recorder_reference);u.mem_write(recorder_reference,bytes([pattern])*56);put(recorder_reference+48,'2I',data_size,stream_reference if recording=='live'else 0);allocations.append({'reference':recorder_reference,'size':56,'freed':False})
  if recording=='live':u.mem_write(stream_reference,bytes([pattern])*4);put(stream_reference,'I',stream_vtable);u.mem_write(stream_vtable,bytes(16));put(stream_vtable+4,'I',stream_write);put(stream_vtable+12,'I',stream_close);allocations.append({'reference':stream_reference,'size':4,'freed':False})
 before=snapshot();steps=[]
 for step in range(2):
  calls.clear();invoke(0xb26580,[],device);steps.append({'after':snapshot(),'calls':list(calls)})
 rows.append({'operation':'term','pattern':pattern,'buffer_present':buffer_present,'recording':recording,'record_status':record_status,'data_size':data_size,'before':before,'steps':steps})
proof={'passed':True,'complete':False,'case_count':len(rows),'counts':{op:sum(row['operation']==op for row in rows)for op in ['configure','quota','term']},'native_arithmetic_fault_cases':sum(row.get('native_arithmetic_fault',False)for row in rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Actual fallback configure/Init/quota/Term and B2F310 recorder header/close/release control bodies execute. Only physical tick/aligned allocation/zero-byte memory/poolfree and mandatory recording stream write/close transport adapted. No fallback or recorder logical result shim.'],'limits':['Controlled valid44-byte devices,56-byte recorder descriptors and4-byte stream handles. Recording stream transport bodies/OS file output are not qualified. Native period0 arithmetic faults are retained explicitly and require Rust errors; physical audio output, actual hardware devices and whole factory/frame producer still required.']}
(r/'data/4.20/audio_fallback_device_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),proof['counts'],'faults',proof['native_arithmetic_fault_cases'],'native fallback configure/quota/Term/recording sequences')
