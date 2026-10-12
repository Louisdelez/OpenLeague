from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_lookup.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];exec(compile(s,'setup','exec'))
local=[(0xae9f60,0xae9fce),(0xaeaf90,0xaeaff1),(0xaff610,0xaff67a)];regions.extend(local);header=0x14a7a5c;storage=heap+0x9400;rows=[]
for operation,pattern,count,spare,key,layout,failure in itertools.product(['register','unregister'],[0,0xa5],[0,1,2,4,8],[0,2],[0,0xb3ed30,0xffffffff],['unique','first','last','duplicate'],[0,1]):
 if operation=='unregister'and failure:continue
 calls.clear();allocations.clear();next_pointer=heap+0xa000;count_allocate=0;fail_nth=failure;capacity=count+spare;put(header,'3I',storage if capacity else 0,count,capacity)
 if capacity:
  u.mem_write(storage,bytes([pattern])*(capacity*4));allocations.append({'reference':storage,'size':capacity*4,'freed':False})
  for i in range(count):put(storage+i*4,'I',key if (layout=='first'and i==0)or(layout=='last'and i==count-1)or(layout=='duplicate'and i in [0,count-1])else 0x11110000+i)
 def snapshot():return {'header':bytes(u.mem_read(header,12)).hex(),'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();result=invoke(0xae9f60 if operation=='register'else 0xaeaf90,[key],0);after=snapshot();rows.append({'operation':operation,'pattern':pattern,'count':count,'spare':spare,'key':key,'layout':layout,'failure_nth':failure,'before':before,'result':result,'after':after,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'counts':{op:sum(row['operation']==op for row in rows)for op in ['register','unregister']},'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Only physical pool allocate/free transport adapted. Actual AE9F60 append/growth/AFF610 copy/free and AEAF90 first-match removal/shift/status bodies execute. No callback registry logical shim.'],'limits':['Controlled owned callback vector;normal Meter construction/composition/frame dispatch and OS scheduling/concurrency remain separate. Function0 is accepted by storage body;invocation of null or arbitrary callback is not qualified.']}
(r/'data/4.20/audio_callback_registry_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',proof['case_count'],proof['counts'],'native callback registration/unregistration sequences')
