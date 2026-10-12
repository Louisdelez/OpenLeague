"""Execute AF1700/AF1660 getters with original static/range logic; RTPC and CRT inputs explicit."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py')
exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;props=heap+0x2000;ranges=heap+0x3000;out=heap+0x4000;rtpc_value=heap+0x4100
u.mem_write(trap+0x100,b'\xd9\x05'+struct.pack('<I',rtpc_value)+b'\xc2\x0c\x00')
u.mem_write(trap+0x200,b'\xdb\xe3');u.mem_write(trap+0x300,b'\xd9\x1d'+struct.pack('<I',out))
calls=[];draw=0
regions=[(0xaf1660,0xaf16f4),(0xaf1700,0xaf1794),(0xaff0c0,0xaff144),(0xaff150,0xaff1cf)]
def guard(uc,a,n,d):
 if a==0xb11040:
  sp=u.reg_read(UC_X86_REG_ESP);given,parameter,owner=read(sp+4,'III');assert given==node
  calls.append(dict(kind='rtpc',parameter=parameter,owner=owner));u.reg_write(UC_X86_REG_EIP,trap+0x100);return
 if a==0xc9bb7a:
  calls.append(dict(kind='rand',value=draw));ret(draw,0);return
 assert any(lo<=a<hi for lo,hi in regions+[(trap+0x100,trap+0x109),(trap+0x200,trap+0x202),(trap+0x300,trap+0x306)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(address):
 sp=stack+0x8000;put(sp,'II',trap+0x300,123);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(address,trap+0x306,count=5000)
rows=[];default8=read(0x1210128,'f')[0];factor=struct.unpack('<d',p.get_data(0xff0e78-base,8))[0]
for kind,static,enabled,rtpc,span,draw in itertools.product([8,9],[None,-31.,0.,40.,3.375],[False,True],[0.,0.375,-23.125],[None,(0.,0.),(-8.,0.),(-400.,400.),(3.25,3.25),(-12.,-2.)],[0,1,16384,32767]):
 u.mem_write(node,bytes(0x100));u.mem_write(props,bytes(32));u.mem_write(ranges,bytes(32))
 put(node,'I',0xff1380)
 if static is not None:u.mem_write(props,bytes([1,kind,0,0]));put(props+4,'f',static);put(node+0x28,'I',props)
 if enabled:put(node+0x30,'I',0x20000000 if kind==8 else 0x40000000)
 if span is not None:u.mem_write(ranges,bytes([1,kind,0,0]));put(ranges+4,'ff',*span);put(node+0x48,'I',ranges)
 put(rtpc_value,'f',rtpc);calls.clear();u.emu_start(trap+0x200,trap+0x202);invoke(read(0xff1380+(0x110 if kind==8 else 0x114),'I')[0])
 assert u.reg_read(UC_X86_REG_EIP)==trap+0x306
 rows.append(dict(kind=kind,static=static,rtpc_enabled=enabled,rtpc=rtpc,range=span,draw=draw,result_bits=read(out,'I')[0],calls=list(calls)))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),case_count=len(rows),default_property8=default8,default_property9=0.,random_multiplier=factor,random_multiplier_bits=p.get_data(0xff0e78-base,8).hex(),cases=rows,regions=[dict(start=hex(a),end=hex(e),sha256=hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()) for a,e in regions],adapters=['B11040 RTPC result supplied as explicit float; captures original parameter29/30 and owner123. Actual manager/RTPC graph evaluation not executed.','FF1380 virtual110 AFF150 and virtual114 AFF0C0 are invoked via verified vtable addresses. Range stores and CRT interface are present but these base getters ignore ranges and never draw; actual RTPC manager is an explicit supplied float interface.'],limits=['Returned slots retain raw property8/9 identities; final mixer parameter semantics and other property aggregators remain open.','Single matching property/range fixtures; table reader/format provenance separately qualified.','No actual sound admission/device output or audible acceptance.'])
(r/'data/4.20/audio_bus_parameter_getters_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('PASS',len(rows),'native FF1380 base local getters; default8',default8,'range multiplier',factor)
