from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_release.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];exec(compile(s,'setup','exec'))
extra=[(0xb291a0,0xb29280)];regions.extend(extra);rows=[];obj=heap+0x7400;records=heap+0x7600
for kind,pattern,count,bank_refs in itertools.product(['extended','standard','base'],[0,0xa5],[1,3],[1,5]):
 skip='acquired_media'
 size={'extended':28,'standard':24,'base':20}[kind];ctor={'extended':0xb29100,'standard':0xb29140,'base':0xb29170}[kind];regions.append((ctor,ctor+0x40))
 calls.clear();allocations.clear();u.mem_write(obj,bytes([pattern])*size);put(heap+0x7800,'I',9);args={'extended':[7,8,heap+0x7800],'standard':[7,8],'base':[7]}[kind];invoke(ctor,args,obj)
 u.mem_write(records,bytes([pattern])*60);put(obj+8,'III',records,count,3)
 u.mem_write(manager,bytes(0x500));put(manager+0x80,'I',42);put(manager+0x84,'I',node);put(manager+0x388,'I',1);u.mem_write(holders[0],bytes(80));put(holders[0]+64,'I',bank_refs);put(node,'8I',0,0,0,100,array,1,1,0);put(array,'3I',holders[0],heap+0x9000,100)
 allocations.extend([{'reference':node,'size':32,'freed':False},{'reference':array,'size':12,'freed':False}])
 for i in range(count):
  put(owner_out,'I',0);invoke(0xaf94a0,[out,0,owner_out],manager);media,length=read(out,'2I');assert media==heap+0x9000;put(records+i*20,'5I',i,media,length,0,read(owner_out,'I')[0])

 allocations.append({'reference':records,'size':60,'freed':False});before={'context':bytes(u.mem_read(obj,size)).hex(),'records':bytes(u.mem_read(records,60)).hex(),'manager':bytes(u.mem_read(manager,0x500)).hex(),'holder':bytes(u.mem_read(holders[0],80)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations]};calls.clear();result=invoke(0xb29250 if kind=='base'else 0xb29220,[0],obj);assert result==obj and all(v['freed']for v in allocations) and read(holders[0]+64,'I')[0]==bank_refs
 rows.append({'kind':kind,'count':count,'skip':skip,'reference':obj,'before':before,'bank_refs':bank_refs,'holder_after':bytes(u.mem_read(holders[0],80)).hex(),'manager_after':bytes(u.mem_read(manager,0x500)).hex(),'result':result,'context':bytes(u.mem_read(obj,size)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in extra],'adapters':['Actual AF94A0 acquisition, B29220/B29250/B291A0 record destruction, AFC0D0 media release and AFBFD0 retained holder decrement execute. Only physical mutex, pool free and atomic operations are adapted; no logical acquisition/destructor/release substitution.'],'limits':['Caller-owned context records populated by actual native media lookup. Actual descriptor registration/DIDX DATA, deleting destructor, record producer, full nonempty bank scan and Rust replay remain required.']}
(r/'data/4.20/audio_plugin_context_acquired_destructor_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native context record scan/owned-array destructor preparation cases')
