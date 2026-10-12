from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_threads.py').read_text().split('\nstream=call(')[0],'thread construction prerequisites','exec'))
original_windows=transport_windows;creation_error=0
def transport_windows(dll,name,sp):
 global last_error
 if name=='CreateThread' and creation_error:last_error=creation_error;finish(eax=0,pop=24);return True
 return original_windows(dll,name,sp)
options=heap+0xe100;source_name=heap+0xf000;cases=[]
names=[b'',b'A',b'A'*15,b'A'*16,b'Enet::SystemInitThread',b'A'*31,b'A'*32,b'A'*63]
for poison,name,creation_error in itertools.product([0,165],names,[0,8]):
 u.mem_write(options,bytes(40));u.mem_write(options,b'EnetSysInit\0');write32(options+32,len(name));write32(options+36,15 if len(name)<16 else len(name)|15)
 if len(name)<16:u.mem_write(options+16,name+b'\0')
 else:u.mem_write(source_name,name+b'\0');write32(options+16,source_name)
 write32(0x2d78f04,0);write32(0x2d78f10,0);before_threads=set(threads);thread_events.clear();snapshot();baseline=set(live)
 raw=scheduled_call(0x8a8b80,0,[0x8fc100,0,options]);created=snapshot()
 fresh=[h for h in threads if h not in before_threads]
 words=[read32(raw+i*4) for i in range(20)] if raw else None
 if raw:
  assert len(fresh)==1;handle=fresh[0];packet=threads[handle]['argument'];capsule=read32(packet+0x58);capsule_words=[read32(capsule+i*4) for i in range(12)]
  run_worker(handle);worker=snapshot();call(0x5d51c0,raw,[0]);destroyed=snapshot()
 else:assert not fresh;capsule_words=None;worker=None;destroyed=None
 assert set(live)==baseline
 cases.append({'fill':poison,'name_hex':name.hex(),'creation_error':creation_error,'thread':raw,'thread_words':words,'capsule_words':capsule_words,'created':created,'after_worker':worker,'destroyed':destroyed,'thread_events':list(thread_events)})
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'limits':[
 '32 native engine8A8B80/8A9040/8A8D40/8A8F90 lifetimes cover zero/short/heap-backed string names at15/16/31/32/63-byte boundaries, fill0/A5 and supplied CreateThread error8. Original CRT packet and child callback execute using the existing logical scheduler and OS boundaries.',
 'Actual80-byte object,48-byte capsule, copied string storage, engine allocation classes and full retained words are captured before/after worker execution and direct destructor. Every case restores the allocation baseline. Constructor allocation failure, custom allocator and asynchronous races are not qualified.'
]}
assert len(cases)==32
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'cases':len(cases),'empty_name_observed':[e for e in cases[0]['thread_events'] if e['op']=='thread_name_exception'],'long_name_allocation_sizes':[a['bytes'] for a in cases[-2]['created']['allocations']]}))
