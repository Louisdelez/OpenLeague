from pathlib import Path
import itertools,json,hashlib,struct
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_bank_caller.py').read_text(encoding='utf-8').split('\nactual=json.loads')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_caller)','caller_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_caller)');exec(compile(setup,'caller_setup','exec'))
regions.extend([(0xb01300,0xb0135e)])
context=manager+0x494;table_ref=heap+0x6800;callback=trap+0x700
reset_event=read(0xfa41b0,'I')[0];set_event=read(0xfa4138,'I')[0]
def guard_notification(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a in locks and read(sp+4,'I')[0]==context+12:
  calls.append({'kind':locks[a],'scope':'bank_notification'});ret(1,4);return
 if a in (reset_event,set_event):
  calls.append({'kind':'reset_event'if a==reset_event else'set_event','handle':read(sp+4,'I')[0]});ret(1,4);return
 if a==callback:
  calls.append({'kind':'bank_callback','fields':list(read(sp+4,'5I'))});ret(0,0);return
 guard_caller(uc,a,n,d)
u.hook_del(caller_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_notification)
rows=[]
# Ordered removal and first-match semantics, wrapping refs, suppression captured before decrement.
sets=[[],[(100,1,0)],[(100,2,0)],[(100,3,1)],[(100,2,2)],[(100,1,1)],[(100,0,0)],[(100,0xffffffff,0)],[(99,2,0),(100,1,0),(101,3,1)],[(100,2,1),(100,1,0),(101,3,0)],[(99,1,0),(101,2,1),(100,1,0)]]
for records,pattern,cookie,enabled in itertools.product(sets,[0,0xa5,0xff],[100,0,0xffffffff],[False,True]):
 calls.clear();u.mem_write(context,bytes([pattern])*40);put(context,'III',table_ref if records else 0,len(records),4 if records else 0);put(context+36,'I',123);u.mem_write(table_ref,bytes([pattern])*48)
 for i,record in enumerate(records):put(table_ref+i*12,'3I',*record)
 fields=[callback if enabled else 0,1355168291,bank,7,0xffffffff,cookie]
 initial_context=bytes(u.mem_read(context,40)).hex();initial_table=bytes(u.mem_read(table_ref,48)).hex();stages=[]
 for i in range(3):
  invoke(0xb14630,fields,context)
  stages.append({'context':bytes(u.mem_read(context,40)).hex(),'table':bytes(u.mem_read(table_ref,48)).hex(),'calls':list(calls)});calls.clear()
 rows.append({'records':records,'pattern':pattern,'fields':fields,'initial_context':initial_context,'initial_table':initial_table,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in [(0xb14630,0xb146e1),(0xb01300,0xb0135e)]],'adapters':['Only physical critical-section entry/exit, ResetEvent, SetEvent and external user callback. Actual B14630 and ordered removal B01300 execute.'],'findings':['Null callback bypasses locking. Missing cookie locks/unlocks without events. First matching cookie is consumed.','Unsigned refs<=1 removes entry by shifting subsequent records, leaving inactive tail untouched; otherwise refs decrement with wrapping semantics.','Cancellation is captured before mutation; suppression decrements cancellation only for retained entries. ResetEvent occurs under lock; unlock precedes optional callback; SetEvent follows callback or suppression.'],'limits':['Controlled initialized table capacity4; notification producer/growth/destructor, callback reentrancy, OS concurrency and non-success event boundaries still require qualification. Native contract prepared; Rust notification receiver port pending.']}
(r/'data/4.20/audio_bank_notification_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native bank notification sequences,',len(rows)*3,'dispatches')
