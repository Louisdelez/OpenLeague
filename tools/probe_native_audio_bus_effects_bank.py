"""Original Bus effects bank reader, cache allocation/slot updates and mask setter."""
from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;cache=heap+0x2000;allocated=heap+0x3000;payload=heap+0x4000;holder=heap+0x5000;calls=[];allocation_failure=False
regions=[(0xb04350,0xb043e6),(0xb00770,0xb007fb),(0xaffbd0,0xaffc5e),(0xafdde0,0xafde1a),(0x574170,0x574173),(0xb03740,0xb03779),(0xb0d140,0xb0d197),(0xb0d1a0,0xb0d1f4)]
put(0x14a7d5c,'I',0);put(0x14a7cfc,'I',0)
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool,size=read(sp+4,'II');assert size==36;calls.append({'kind':'allocate','size':size});ret(0 if allocation_failure else allocated,0);return
 if a==0xb03d40:calls.append({'kind':'changed'});ret(0,0);return
 if a==0xb04b80:calls.append({'kind':'slot','index':read(sp+4,'I')[0]});ret(0,4);return
 if a==0xb041b0:calls.append({'kind':'mask','args':list(read(sp+4,'II'))});ret(0,8);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
layouts=[[],[(0,0,0,0xaa)],[(0,100,0,0xaa)],[(3,1234,255,0x55)],[(0,100,1,0xaa),(2,293,2,0x55)],[(0,100,1,0xaa),(4,999,1,0x55),(1,200,1,0x33)]];rows=[]
for pattern,layout_index,existing,allocation_failure,bypass in itertools.product([0,1,0xa5,0xff],range(6),range(3),[False,True],[0,1,2,31,255]):
 u.mem_write(node,bytes([pattern])*200);put(node,'III',0xff1380,0,1234);put(node+0x18,'I',cache if existing else 0);put(node+0x24,'I',0);u.mem_write(cache,bytes([pattern])*36);u.mem_write(allocated,b'\xa5'*36)
 if existing==1:
  for i in range(4):put(cache+i*8,'BB',0,0);put(cache+i*8+4,'I',0)
  u.mem_write(cache+0x20,b'\x00')
 if existing==2:
  for i in range(4):put(cache+i*8,'BB',0,1);put(cache+i*8+4,'I',[100,200,293,1234][i])
  u.mem_write(cache+0x20,b'\xa5')
 items=layouts[layout_index];raw=bytes([len(items)])+(bytes([bypass])+b''.join(struct.pack('<BIBB',*e) for e in items) if items else b'');u.mem_write(payload,raw);put(holder,'II',payload,len(raw));before=bytes(u.mem_read(node,200)).hex();before_cache=bytes(u.mem_read(cache,36)).hex() if existing else None;calls.clear();sp=stack+0x8000;put(sp,'IIII',trap,holder,holder+4,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb04350,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 pointer=read(node+0x18,'I')[0];rows.append({'pattern':pattern,'layout':layout_index,'existing':existing,'allocation_failure':allocation_failure,'bypass':bypass,'payload':raw.hex(),'before':before,'before_cache':before_cache,'after':bytes(u.mem_read(node,200)).hex(),'after_cache':bytes(u.mem_read(pointer,36)).hex() if pointer else None,'result':u.reg_read(UC_X86_REG_EAX),'consumed':read(holder,'I')[0]-payload,'remaining':read(holder+4,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual B04350/B00770/AFFBD0/AFDDE0 effects slot parsing, allocation/constructor, unchanged-slot suppression, mask updates and result/error handling execute. Allocator and Bus callbacks virtualCC/84/DC explicitly supplied; B03740/B0D140/B0D1A0 execute with registered target arrays empty.'],'limits':['Preparatory reference; Rust effect reader and callback integration not yet ported.','Normal effect resource lookup/DSP, bank binding lifecycle and target admission remain open.','Cache18 words+4/+C/+14/+1C are effect IDs, not list counts; normalization/ownership and other readers remain separate.']}
(r/'data/4.20/audio_bus_effects_bank_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus effect bank reader/slot/cache/mask cases')
