from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_effect_hirc_section.py').read_text(encoding='utf-8').split('\nactual=json.loads')[0];exec(compile(setup,'hirc_setup','exec'))
actual=json.loads((r/'data/4.20/audio_effect_actual_bank_contract.json').read_text(encoding='utf-8'));payloads=[bytes.fromhex(s['payload'])for s in actual['sources']]
section=lambda records:struct.pack('<I',len(records))+b''.join(bytes([tag])+struct.pack('<I',len(payload))+payload for tag,payload in records)
packets=[('consecutive_repeat',section([(19,payloads[0])])+section([(19,payloads[0])]),2),('consecutive_distinct',section([(19,payloads[0])])+section([(19,payloads[1]),(18,payloads[0])]),2)]
packets += [('short_count_'+str(n),struct.pack('<I',2)[:n],1)for n in range(4)]
packets += [('short_header_'+str(n),struct.pack('<I',1)+(bytes([19])+struct.pack('<I',40))[:n],1)for n in range(5)]
packets += [('short_unknown_skip',struct.pack('<I',1)+bytes([0])+struct.pack('<I',10)+b'abcde',1)]
rows=[]
for (packet,data,section_count),pattern,fail_nth in itertools.product(packets,[0,0xa5],range(7)):
 u.mem_write(bank,data);calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(registries,bytes(0x2600));u.mem_write(stream,bytes(40));put(stream+8,'I',len(data));put(stream+24,'I',bank);u.mem_write(holder,b'\xa5'*64);put(holder+52,'III',0,0,0);stages=[]
 def snapshot(stage,result):
  stages.append({'stage':stage,'result':result,'stream':bytes(u.mem_read(stream,40)).hex(),'holder':bytes(u.mem_read(holder,64)).hex(),'custom_count':read(registries+0x1f40+0x31c,'I')[0],'shared_count':read(registries+0x1c20+0x31c,'I')[0],'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
 for n in range(section_count):
  calls.clear();result=invoke(0xafb630,[holder,0],stream);snapshot('load'+str(n),result)
  if result!=1:break
 calls.clear();invoke(0xafc410,(),holder);snapshot('unload',0);assert all(v['freed']for v in allocations)
 rows.append({'packet':packet,'pattern':pattern,'failure_nth':fail_nth,'section_payload':data.hex(),'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'sources':actual['sources'],'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Physical allocator/free/mutex/memcpy boundaries only. Actual AFB630/AFF610 stream/read/skip,resource readers/retain and unload execute.'],'findings':['Consecutive sections reserve old capacity plus new count,copy live reference prefix and free previous reference storage;duplicates retain the same source until final ordered unload.','Short count/record headers advance only copied bytes and return56. Unknown skipped payload shorter than declared size returns7. Reservation OOM takes precedence over subsequent short header read.'],'limits':['Native extended evidence prepared;Rust replay pending. Only effects/default-null extension path in memory storage;other HIRC bodies,file IO,concurrency and audible acceptance remain required.']}
(r/'data/4.20/audio_effect_hirc_extended_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native consecutive section/live prefix/short header/skip/failure cases')
