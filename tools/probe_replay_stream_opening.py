from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');prelude=(r/'tools/qualify_replay_stream_initialization.py').read_text().split('\ncases=[]')[0]
results=[]
for implementation_flag in [1,0]:
 exec(compile(prelude,'stream opening prerequisites','exec'))
 reset(0,False);callbacks.clear()
 # The enabled transport reaches CRT synchronization and diagnostics. Execute
 # their actual static-lock and low-I/O startup, keeping their allocations live.
 assert call(0xcb0378,0,[])==1;assert call(0xcaff53,0,[])==0
 prerequisites=stream_state();baseline=set(live)
 stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[]);initial=stream_state()
 key=heap+0xd000;address=heap+0xd100;u.mem_write(key,bytes(16));u.mem_write(address,b'127.0.0.1\0')
 args=[0,1,0,key,address,12345,implementation_flag,0,0,0,0]
 entered=[];recent=[];invalid_access=[]
 def observe_open(uc,pc,size,user):
  if pc in [0x8fb650,0x8f6650,0x8f6d00,0x8f6eb0,0x98f710,0x8fc610,0x8fc380,0x8fc480,0x8fc930,0x8fca30]:entered.append(hex(pc))
  if pc in [0xca86bb,0xc9f39b,0x8a9040]:
   sp=u.reg_read(UC_X86_REG_ESP);recent.append({'pc':hex(pc),'stack':hex(sp),'return':hex(read32(sp))});del recent[:-24]
 def invalid(uc,access,pointer,size,value,user):
  invalid_access.append({'kind':access,'address':hex(pointer),'bytes':size,'pc':hex(u.reg_read(UC_X86_REG_EIP)),'stack':hex(u.reg_read(UC_X86_REG_ESP))});return False
 u.hook_add(unicorn.UC_HOOK_CODE,observe_open)
 u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)
 result={'implementation_flag':implementation_flag,'stream':stream,'arguments':args,'prerequisites':prerequisites,'initial':initial}
 try:
  code=call(0x8f68d0,stream,args);opened=stream_state()
  result.update({'returned':True,'return_code':code,'state_id':read32(read32(stream+0x44)+12),'implementation_pair':pair_words(stream+0x64),'object_pair':pair_words(stream+0x6c),'opened':opened})
  call(0x8f67c0,stream,[1]);result['destroyed']=stream_state();result['new_allocations_remaining']=[p for p in live if p not in baseline]
 except Exception as error:
  result.update({'returned':False,'error':str(error),'failure_pc':hex(u.reg_read(UC_X86_REG_EIP)),'exception_type':type(error).__name__,'last_calls':recent,'invalid_access':invalid_access,'last_windows_calls':windows_calls[-12:]})
 result['entered']=entered;results.append(result)
 print(json.dumps({k:v for k,v in result.items() if k not in ['prerequisites','initial','opened','destroyed']}),flush=True)
proof={'native_sha256':digest,'complete':False,'cases':results,'limits':[
 'Read-only native client code executes in emulated memory. The 16-byte key is zero and address is loopback with port12345; these are explicit configuration inputs, not a recorded match or a connection proof. No host network operations are issued.',
 'implementation_flag1 selects the native16-byte no-op implementation (configure8F6650 discards its callback and returns0). A successful no-op configuration must not be presented as actual replay playback. Flag0 constructs the native0x918-byte implementation and its configured parser/transport state.',
 'Inherited memory, mutex and Windows prerequisites are supplied; unprovided imports raise rather than fabricating stream setup success. This probe does not implement the Rust opening path or prove file/network event delivery.'
]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
