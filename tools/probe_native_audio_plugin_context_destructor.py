from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_release.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];exec(compile(s,'setup','exec'))
extra=[(0xb291a0,0xb29280)];regions.extend(extra);rows=[];obj=heap+0x7400;records=heap+0x7600
for kind,pattern,count,skip in itertools.product(['extended','standard','base'],[0,0xa5],[0,1,3],['null_media','sentinel_key']):
 size={'extended':28,'standard':24,'base':20}[kind];ctor={'extended':0xb29100,'standard':0xb29140,'base':0xb29170}[kind];regions.append((ctor,ctor+0x40))
 calls.clear();allocations.clear();u.mem_write(obj,bytes([pattern])*size);put(heap+0x7800,'I',9);args={'extended':[7,8,heap+0x7800],'standard':[7,8],'base':[7]}[kind];invoke(ctor,args,obj)
 u.mem_write(records,bytes([pattern])*60);put(obj+8,'III',records,count,3)
 for i in range(count):put(records+i*20,'5I',i,0 if skip=='null_media'else heap+0x9000,100,0 if skip=='null_media'else 0xffffffff,heap+0x6000)
 allocations.append({'reference':records,'size':60,'freed':False});before={'context':bytes(u.mem_read(obj,size)).hex(),'records':bytes(u.mem_read(records,60)).hex()};calls.clear();result=invoke(0xb29250 if kind=='base'else 0xb29220,[0],obj);assert result==obj and allocations[0]['freed']
 rows.append({'kind':kind,'count':count,'skip':skip,'reference':obj,'before':before,'result':result,'context':bytes(u.mem_read(obj,size)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in extra],'adapters':['Actual B29220/B29250 and B291A0 execute. Physical pool free is adapted; no logical destructor or record scan substitution.'],'limits':['Caller-owned context with controlled records; null media or sentinel key intentionally bypasses media/holder release. Valid acquired descriptors, deleting destructor, owned record producer and full nonempty bank scan remain required.']}
(r/'data/4.20/audio_plugin_context_destructor_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native context record scan/owned-array destructor preparation cases')
