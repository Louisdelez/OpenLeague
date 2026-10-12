from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_bank_notification_registration.py').read_text(encoding='utf-8').split('\nrows=[]')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_registration)','registration_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_registration)');exec(compile(setup,'setup','exec'))
regions.append((0xb14520,0xb1455d));initialize=read(0xfa41a0,'I')[0];create_event=read(0xfa4340,'I')[0]
def guard_construct(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==initialize:
  reference=read(sp+4,'I')[0];u.mem_write(reference,mutex_bytes);calls.append({'kind':'initialize_critical_section','reference':reference,'published':mutex_bytes.hex()});ret(0,4);return
 if a==create_event:
  args=list(read(sp+4,'4I'));calls.append({'kind':'create_event','fields':args,'handle':event_result});ret(event_result,16);return
 guard_registration(uc,a,n,d)
u.hook_del(registration_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_construct);rows=[]
for pattern,mutex_pattern,event_result in itertools.product([0,0xa5,0xff],[0x12,0xe3],[0,123,0xffffffff]):
 calls.clear();allocations.clear();mutex_bytes=bytes([mutex_pattern])*24;u.mem_write(context,bytes([pattern])*40);before=bytes(u.mem_read(context,40)).hex();result=invoke(0xb14520,(),context);assert result==context
 stages=[{'stage':'construct','context':bytes(u.mem_read(context,40)).hex(),'calls':list(calls)}];calls.clear();invoke(0xb14560,(),context);stages.append({'stage':'destroy','context':bytes(u.mem_read(context,40)).hex(),'calls':list(calls)});assert not allocations
 rows.append({'pattern':pattern,'mutex_bytes':mutex_bytes.hex(),'event_result':event_result,'before':before,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in [(0xb14520,0xb1455d),(0xb14560,0xb145a6)]],'adapters':['Physical InitializeCriticalSection publication of controlled24 bytes,CreateEventW handle result,CloseHandle,DeleteCriticalSection. Actual B14520 constructor/B14560 destructor execute.'],'findings':['Constructor zeros table pointer/count/capacity,initializes mutex at+12,sets handle0 before CreateEventW(null attributes,manual-reset1,initially-signaled0,null name),publishes returned handle including0.','Constructor preserves physical mutex publication. Empty-table destructor closes nonzero event handle,always deletes mutex and preserves raw handle.'],'limits':['Native preparation;Rust constructor pending. Controlled OS boundary bytes do not qualify real Windows mutex/event behavior,concurrency or initialization exceptions.']}
(r/'data/4.20/audio_bank_notification_constructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native notification constructor/empty destructor cases')
