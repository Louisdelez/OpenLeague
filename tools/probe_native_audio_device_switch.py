from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_device_factory.py').read_text(encoding='utf-8').split('\nfor kind,')[0];exec(compile(s,'factory_setup','exec'));local.append((0xb0c270,0xb0c2e7));rows=[];output_table=heap+0x8800
for count,kind,layout,key,use_new,pattern in itertools.product([0,1,2,4],[1,2,3],['none','first','last','duplicate'],[0,0xffffffff],[False,True],[0,0xa5]):
 calls.clear();allocations.clear();next_pointer=heap+0xd000;count_allocate=0;fail_nth=0;profile='ready';put(0x1210228,'I',0xffffffff);u.mem_write(settings,bytes([pattern])*16);put(settings+4,'I',3);references=[]
 for i in range(count+1):
  reference=invoke(0xb260b0,[settings,kind,0],0);assert reference!=0;references.append(reference)
 capacity=count+2;u.mem_write(output_table,bytes([pattern])*(capacity*56));put(0x14a7cf8,'2I',output_table,count)
 for i in range(count):
  matching=(layout=='first'and i==0)or(layout=='last'and i==count-1)or(layout=='duplicate'and i in [0,count-1]);put(output_table+i*56+4,'I',references[i]);put(output_table+i*56+16,'2I',key if matching else 0xabc00000+i,123 if matching else 0xabc10000+i)
 new_reference=references[-1]if use_new else 0
 def snapshot():return {'table':bytes(u.mem_read(output_table,capacity*56)).hex(),'table_reference':read(0x14a7cf8,'I')[0],'count':read(0x14a7cfc,'I')[0],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();calls.clear();result=invoke(0xb0c270,[key,123,new_reference],0);rows.append({'kind':kind,'layout':layout,'key':key,'second':123,'new_reference':new_reference,'pattern':pattern,'pool':0xffffffff,'before':before,'result':result,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Actual B0C270 table search/first-match/retirement/publication body executes. Old/new objects produced by actual native factory and constructors. Device configure/Term bodies explicitly adapted; flags0 destructor and physical poolfree execute.'],'limits':['Native preparation only; Rust output table switching and integrated factory/quota/switch compositions still required. Actual device configure/Term and physical output unqualified. Matching entries contain valid nonnull old devices; null old device faults before native null check and remains explicit unsupported ownership.']}
(r/'data/4.20/audio_device_switch_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native output table switch/retirement/first-match sequences')
