from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_audio_effect_resource_parameter.py').read_text(encoding='utf-8').split('rows=[];blob=')[0]
exec(compile(setup,'parameter_setup','exec'))
regions.append((0xb254c0,0xb2562a));bank=heap+0x8000
rows=[];blob=struct.pack('<fffffBI',.2,2.5,-60.,8.,.75,255,0xdeadbeef)
for profile,existing,length,pattern in itertools.product(['success','missing','null_parameter','failure','skip'],[False,True],[0,25],[0,0xa5,0xff]):
 calls.clear();allocations.clear();next_pointer=heap+0x5000;u.mem_write(resource,bytes([0xa5])*48);put(resource+16,'II',0x11223344,old if existing else 0);u.mem_write(resource+24,bytes(24));u.mem_write(old,bytes([pattern])*32);put(old,'I',0xff36a4)
 if existing:allocations.append({'reference':old,'size':32,'freed':False})
 put(registry,'III',0x810003,0xb3e260,0 if profile=='null_parameter'else 0xb3df60);put(0x14a7abc,'II',registry,0 if profile=='missing'else 1)
 data=struct.pack('<III',100,0xffffffff if profile=='skip'else 0x810003,length)+(blob if length else b'')+bytes(3)
 u.mem_write(bank,data);before=bytes(u.mem_read(resource,48)).hex();sp=stack+0x8000;put(sp,'III',trap,bank,len(data));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,resource);u.emu_start(0xb254c0,trap,count=4000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'profile':profile,'existing':existing,'length':length,'pattern':pattern,'bank_payload':data.hex(),'before':before,'resource':bytes(u.mem_read(resource,48)).hex(),'result':u.reg_read(UC_X86_REG_EAX),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'findings':['Actual B254C0 reads plugin ID at payload4 and size8,passes payload12 to actual parameter install,then advances by declared size to subsequent tables. Plugin IDFFFFFFFF skips installation.','Empty two subsequent tables are consumed by actual reader;factory/null creator/allocation failures remain success1 and preserve old parameter through actual B253F0.'],'adapters':['Only physical parameter allocation/free boundaries;whole reader,parameter factory/Meter Init/Term execute.'],'limits':['Preparatory evidence,no Rust whole reader port yet. Empty subsequent byte-count table and u16-count RTPC table only;their allocation/entry/curve/subscription bodies remain required.','Payload has valid backing and parameter length0/25;truncation and unknown plugin classes unqualified. Full HIRC8 dispatch/resource creation and ordinary bank/device output still open.']}
(r/'data/4.20/audio_effect_resource_reader_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'whole effect resource reader with actual parameter loading cases')
