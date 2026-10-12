from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_lookup.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];exec(compile(s,'setup','exec'))
extra=[(0xb29100,0xb291a0)];regions.extend(extra);rows=[];obj=heap+0x7400;indirect=heap+0x7600
for kind,pattern,a,b_arg,c in itertools.product(['extended','standard','base'],[0,0xa5],[0,0xffffffff],[0,123],[0,0xffffffff]):
 size={'extended':28,'standard':24,'base':20}[kind];address={'extended':0xb29100,'standard':0xb29140,'base':0xb29170}[kind]
 calls.clear();allocations.clear();u.mem_write(obj,bytes([pattern])*size);put(indirect,'I',c);before=bytes(u.mem_read(obj,size)).hex();args={'extended':[a,b_arg,indirect],'standard':[a,b_arg],'base':[a]}[kind];result=invoke(address,args,obj);assert result==obj and not calls
 rows.append({'kind':kind,'reference':obj,'a':a,'b':b_arg,'indirect_value':c,'before':before,'result':result,'raw':bytes(u.mem_read(obj,size)).hex()})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in extra],'adapters':['Actual native context constructors execute; no logical constructor substitution. Inherited physical hooks unused by these constructors.'],'limits':['Constructors on caller-owned allocations only. Actual allocation producer, record acquisition/array growth/destruction, plugin binding and nonempty voice unloading remain required.']}
(r/'data/4.20/audio_plugin_context_constructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native plugin context constructor cases')
