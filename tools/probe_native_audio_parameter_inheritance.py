"""Execute sound virtual100 AF1900 and inheritance AFF1E0; local bus getters supplied explicitly."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py')
exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
table=heap+0x8000;parameters=heap+0x9000;addresses=[heap+0x1000+i*0x1000 for i in range(4)]
u.mem_write(table,p.get_data(0xff1cd8-base,0x180))
assert read(table+0x100,'I')[0]==0xaf1900
put(table+0x110,'I',trap+0x100);put(table+0x114,'I',trap+0x110)
u.mem_write(trap+0x100,b'\xd9\x81\x70\x00\x00\x00\xc2\x04\x00')
u.mem_write(trap+0x110,b'\xd9\x81\x74\x00\x00\x00\xc2\x04\x00')
u.mem_write(trap+0x200,b'\xdb\xe3')
trace=[]
def guard(uc,a,n,d):
 if a==0xaf1900:
  sp=u.reg_read(UC_X86_REG_ESP);trace.append(dict(kind='inherit',node=addresses.index(u.reg_read(UC_X86_REG_ECX)),first_raw=read(sp+16,'I')[0]))
 elif a in [trap+0x100,trap+0x110]:trace.append(dict(kind='getter',node=addresses.index(u.reg_read(UC_X86_REG_ECX)),slot=0x110 if a==trap+0x100 else 0x114))
 assert any(lo<=a<hi for lo,hi in [(0xaf1900,0xaf19dd),(0xaff1e0,0xaff35a),(trap+0x100,trap+0x119),(trap+0x200,trap+0x202)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(start,args,ecx):
 sp=stack+0x8000;put(sp,'I',trap)
 for i,v in enumerate(args):put(sp+4+i*4,'I',v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(start,trap,count=20000)
def scalar_props(at,ident,value,range_entry=False):
 u.mem_write(at,bytes(24));u.mem_write(at,bytes([1,ident,0,0]));put(at+4,'f',value)
 if range_entry:put(at+8,'f',0.)
rows=[]
for bus_present,parent_present,first_raw,marker,scope,owner,volume_path in itertools.product([False,True],[False,True],[0,1],[0,17],range(4),[1,2],['absent','static','blocked']):
 for address in addresses:u.mem_write(address,bytes(0x1000));put(address,'I',table)
 child,parent,bus,bus_parent=addresses
 if parent_present:put(child+0x20,'I',parent)
 if bus_present:
  put(child+0x38,'I',child+0x100);put(child+0x100,'I',bus);put(child+0x24,'I',bus)
  put(child+0x70,'f',-31.);put(child+0x74,'f',40.)
  put(bus+0x24,'I',bus_parent)
  if volume_path!='absent':
   for address,value in [(bus,-23.),(bus_parent,-12.)]:scalar_props(address+0x200,0,value);put(address+0x28,'I',address+0x200)
  if volume_path=='blocked':put(bus+0x18,'I',bus+0x600);put(bus+0x604,'I',123)
 for index,address in enumerate(addresses):
  if scope&1:
   put(address+0x14,'I',address+0x300);put(address+0x30c,'I',address+0x400);scalar_props(address+0x400,8,float(index+1),True)
  if scope&2:
   put(address+0x40,'I',address+0x500);put(address+0x500,'II',address+0x520,1);put(address+0x520,'II',1,address+0x540);put(address+0x54c,'I',address+0x560);scalar_props(address+0x560,8,float(index+1)*0.25,True)
 u.mem_write(parameters,bytes(0x40));put(parameters,'I',0x12345678);put(parameters+4,'fff',13.,17.,19.);put(parameters+0x2a,'H',marker)
 trace.clear();u.emu_start(trap+0x200,trap+0x202);invoke(0xaf1900,[parameters,0,owner,first_raw],child)
 assert u.reg_read(UC_X86_REG_EIP)==trap and u.reg_read(UC_X86_REG_EAX)==1
 rows.append(dict(bus_present=bus_present,parent_present=parent_present,first_raw=first_raw,initial_marker=marker,scope=scope,owner=owner,volume_path=volume_path,result=1,output_words=list(read(parameters+4,'III')),output_marker=read(parameters+0x2a,'H')[0],output_reference=read(parameters,'I')[0],calls=list(trace)))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),entry='0xaf1900',base_inheritance='0xaff1e0',sound_vtable='0xff1cd8',case_count=len(rows),cases=rows,regions=[dict(start=hex(a),end=hex(e),sha256=hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()) for a,e in [(0xaf1900,0xaf19dd),(0xaff1e0,0xaff35a)]],adapters=['Local virtual110/114 getter return values supplied through tiny x87 machine-code adapters. Their full RTPC/random-range evaluation is not executed.','Constructed acyclic parent/bus graphs and property stores; no native graph allocation.'],limits=['Fields4/8/C preserved as raw control slots; semantic final gain/filter/pitch mapping is not inferred here.','Runtime actor/container class differences, state/RTPC aggregation and full voice admission remain open.','No PCM/device output or audible fidelity acceptance.'])
(r/'data/4.20/audio_parameter_inheritance_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('PASS',len(rows),'original parameter inheritance cases')
