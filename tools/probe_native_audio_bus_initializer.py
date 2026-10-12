"""Original FF1380 Bus B03530 initializer and AFE420 registry insertion."""
from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;manager=heap+0x2000;put(0x14a7a08,'I',manager);put(0xfa4424,'I',trap+0x100);put(0xfa4428,'I',trap+0x110)
regions=[(0xb03530,0xb03609),(0xafe420,0xafe47f),(0xaf6430,0xaf6445),(0x574170,0x574173)];calls=[]
def guard(uc,a,n,d):
 if a in [trap+0x100,trap+0x110]:
  given=read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0];calls.append({'kind':'lock' if a==trap+0x100 else 'unlock','registry':given});ret(0,4);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
rows=[]
for ident,flags,head,count in itertools.product([0,1,192,193,1234,0xffffffff],[0,1,2,3,0xa5,0xff],[0,heap+0x4000,heap+0x4100,heap+0x4200],[0,1,0xffffffff]):
 u.mem_write(node,bytes([0xa5])*0xc8);put(node,'I',0xff1380);put(node+8,'I',ident);u.mem_write(node+0x2f,bytes([flags]));before=bytes(u.mem_read(node,0xc8)).hex()
 u.mem_write(manager,bytes(0x1000));bucket=ident%193;put(manager+0x18+bucket*4,'I',heap+0x4300);put(manager+0x31c,'I',7);put(manager+0x320+0x18+bucket*4,'I',head);put(manager+0x320+0x31c,'I',count)
 calls.clear();sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb03530,trap,count=2000);assert u.reg_read(UC_X86_REG_EIP)==trap and u.reg_read(UC_X86_REG_EAX)==1
 rows.append({'id':ident,'flags':flags,'head':head,'count':count,'before':before,'after':bytes(u.mem_read(node,0xc8)).hex(),'registry_bucket':read(manager+0x320+0x18+bucket*4,'I')[0],'registry_count':read(manager+0x320+0x31c,'I')[0],'other_bucket':read(manager+0x18+bucket*4,'I')[0],'other_count':read(manager+0x31c,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Only OS lock/unlock interfaces adapted. Actual FF1380 virtual38 574170, B03530 defaults/flag selection, AFE420 registry hashing/insertion and AF6430 registry selection execute native instructions.','Verified raw node layout and manager registry tables constructed; prior bucket nodes are linked but not traversed.'],'limits':['Preparatory native initializer evidence; Rust initializer/registry integration and virtual144 bank loading remain to port/qualify.','Physical audio runtime, live control ownership and device output remain open.']}
(r/'data/4.20/audio_bus_initializer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual native Bus initializer and registry insertion cases')
