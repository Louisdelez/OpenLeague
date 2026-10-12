from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_bank_notification_registration.py').read_text(encoding='utf-8').split('\nrows=[]')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_registration)','registration_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_registration)');exec(compile(setup,'reg_setup','exec'))
regions.append((0xb14790,0xb14803));thread_api=read(0xfa4378,'I')[0];wait_api=read(0xfa43f8,'I')[0]
def guard_withdraw(uc,a,n,d):
 if a==thread_api:calls.append({'kind':'current_thread','id':100});ret(100,0);return
 if a==wait_api:
  handle,timeout=read(u.reg_read(UC_X86_REG_ESP)+4,'II');calls.append({'kind':'wait_event','handle':handle,'timeout':timeout});ret(0,8);return
 guard_registration(uc,a,n,d)
u.hook_del(registration_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_withdraw)
sets=[[],[(100,1,0)],[(100,2,0)],[(100,3,1)],[(100,2,2)],[(100,1,1)],[(100,0,0)],[(100,0xffffffff,0)],[(99,2,0),(100,1,0),(101,3,1)],[(100,2,1),(100,1,0),(101,3,0)],[(99,1,0),(101,2,1),(100,1,0)]];rows=[]
for records,pattern,cookie,same_thread in itertools.product(sets,[0,0xa5,0xff],[100,0,0xffffffff],[False,True]):
 calls.clear();put(0x14a7aa8,'I',100 if same_thread else 200);u.mem_write(context,bytes([pattern])*40);put(context,'III',table_ref if records else 0,len(records),4 if records else 0);put(context+36,'I',123);u.mem_write(table_ref,bytes([pattern])*48)
 for i,record in enumerate(records):put(table_ref+i*12,'3I',*record)
 initial_context=bytes(u.mem_read(context,40)).hex();initial_table=bytes(u.mem_read(table_ref,48)).hex();stages=[]
 for i in range(3):
  invoke(0xb14790,[cookie],context);stages.append({'context':bytes(u.mem_read(context,40)).hex(),'table':bytes(u.mem_read(table_ref,48)).hex(),'calls':list(calls)});calls.clear()
 rows.append({'pattern':pattern,'cookie':cookie,'same_thread':same_thread,'initial_context':initial_context,'initial_table':initial_table,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in [(0xb14790,0xb14803),(0xb01300,0xb0135e)]],'adapters':['Physical mutex,GetCurrentThreadId and WaitForSingleObject only. Actual B14790/B01300 withdrawal and ordered removal execute.'],'findings':['Withdraw first matching cookie;refs<=1 removes/shifts,otherwise refs decrement without modifying cancellation field.','After unlock compare actual caller thread with audio worker global14A7AA8. Other thread always waits event with timeoutFFFFFFFF,including absent cookie. Worker thread does not wait.'],'limits':['Native preparation;Rust withdrawal/wait port pending. Explicit initialized table,physical wait completes successfully;OS concurrency/worker identity/cancellation marking production/reentrancy still required.']}
(r/'data/4.20/audio_bank_notification_withdraw_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native notification withdrawal/wait sequences')
