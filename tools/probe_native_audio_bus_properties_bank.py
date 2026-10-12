"""Original Bus B043F0 property/flag prefix and B225A0 property-table reader."""
from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;payload=heap+0x3000;holder=heap+0x4000;allocated=heap+0x5000;old=heap+0x6000;calls=[];failure=False;size=0
regions=[(0xb043f0,0xb044dd),(0xb225a0,0xb2262b),(0xb009b0,0xb00a40),(0xb00c20,0xb00c85)]
def guard(uc,a,n,d):
 global size
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool,size=read(sp+4,'II');calls.append({'kind':'allocate','size':size});ret(0 if failure else allocated,0);return
 if a==0xca1ef0:
  dest,src,length=read(sp+4,'III');u.mem_write(dest,bytes(u.mem_read(src,length)));calls.append({'kind':'copy','length':length});ret(dest,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
layouts=[[],[(0,0x80000000)],[(0,0xc1f80000),(2,0x42200000),(3,0x40b00000)],[(0,0x3f800000),(0,0x3f000000),(23,0xc0e80000),(24,0x40600000)]]
rows=[]
for pattern,layout_index,flags,channels,mask_word,failure in itertools.product([0,1,2,3,0xa5,0xff],range(4),[(0,0,0,0,0,0,0),(1,1,1,1,1,1,1),(2,3,2,3,2,3,2),(255,255,255,255,255,255,255)],[0,3,0xffff],[0,0x3f,0x600,0xffff],[False,True]):
 u.mem_write(node,bytes([0xa5])*200);put(node,'I',0xff1380);put(node+0x1c,'I',0);put(node+0x28,'I',old);u.mem_write(node+0x2e,bytes([pattern,pattern]));u.mem_write(node+0xc4,bytes([pattern]));u.mem_write(allocated,b'\xa5'*128)
 items=layouts[layout_index];raw=bytes([len(items),*[key for key,value in items]])+b''.join(struct.pack('<I',value) for key,value in items)+bytes(flags[:4])+struct.pack('<H',channels)+bytes([flags[4]])+struct.pack('<HH',mask_word,0x1234)+bytes(flags[5:]);u.mem_write(payload,raw);put(holder,'II',payload,len(raw));before=bytes(u.mem_read(node,200)).hex();calls.clear();size=0;sp=stack+0x8000;put(sp,'III',trap,holder,holder+4);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb043f0,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'pattern':pattern,'layout':layout_index,'flags':flags,'channels':channels,'mask_word':mask_word,'allocation_failure':failure,'payload':raw.hex(),'before':before,'after':bytes(u.mem_read(node,200)).hex(),'result':u.reg_read(UC_X86_REG_EAX),'consumed':read(holder,'I')[0]-payload,'remaining':read(holder+4,'I')[0],'allocated_bytes':bytes(u.mem_read(allocated,size)).hex() if size and not failure else None,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Only heap allocator and standard memcpy interfaces adapted. Actual B043F0/B225A0/B009B0/B00C20 table parsing, byte/word masks and flag changes execute unchanged.','Existing group pointer1C is absent, so live group reordering/notifications are not exercised. Allocator buffer padding is explicit A5 bytes and preserved.'],'limits':['Preparatory reference for Bus properties prefix; not connected to Rust bank loader yet.','Group cache callbacks, property-table replacement/lifetime and real bank payload integration remain open.','No normal audio runtime/device acceptance.']}
(r/'data/4.20/audio_bus_properties_bank_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus property-table and flag-prefix cases')
