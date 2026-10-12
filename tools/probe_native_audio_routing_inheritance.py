"""Execute sound virtual100 AF1900 and inheritance AFF1E0; local bus getters supplied explicitly."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py')
exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
table=heap+0x8000;parameters=heap+0x9000;addresses=[heap+0x1000+i*0x1000 for i in range(4)]
u.mem_write(table,p.get_data(0xff1cd8-base,0x180))
assert read(table+0x100,'I')[0]==0xaf1900
assert read(table+0x110,'I')[0]==0xaf1700 and read(table+0x114,'I')[0]==0xaf1660
u.mem_write(trap+0x100,b'\xd9\x81\x70\x00\x00\x00\xc2\x04\x00')
u.mem_write(trap+0x110,b'\xd9\x81\x74\x00\x00\x00\xc2\x04\x00')
u.mem_write(trap+0x200,b'\xdb\xe3')
route_manager=heap+0xc000;voice=heap+0xd000;optional=heap+0xe000
trace=[]
def guard(uc,a,n,d):
 if a==0xada610:
  size,align=read(u.reg_read(UC_X86_REG_ESP)+8,'II');trace.append(dict(kind='allocate',size=size,alignment=align));ret(parameters,0);return
 if a==0xaef360:trace.append(dict(kind='routing'))
 if a==0xaf1900:
  sp=u.reg_read(UC_X86_REG_ESP);trace.append(dict(kind='inherit',node=addresses.index(u.reg_read(UC_X86_REG_ECX)),first_raw=read(sp+16,'I')[0]))
 elif a in [0xaf1700,0xaf1660]:trace.append(dict(kind='getter',node=addresses.index(u.reg_read(UC_X86_REG_ECX)),slot=0x110 if a==0xaf1700 else 0x114))
 assert any(lo<=a<hi for lo,hi in [(0xaef360,0xaef40c),(0xb15530,0xb1555d),(0xafeb10,0xafeb1b),(0xb1ad70,0xb1ade0),(0xb1aa50,0xb1aaf5),(0xaf1900,0xaf19dd),(0xaff1e0,0xaff35a),(0xaf1660,0xaf16f4),(0xaf1700,0xaf1794),(0xaff0c0,0xaff144),(0xaff150,0xaff1cf),(trap+0x100,trap+0x119),(trap+0x200,trap+0x202)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(start,args,ecx):
 sp=stack+0x8000;put(sp,'I',trap)
 for i,v in enumerate(args):put(sp+4+i*4,'I',v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(start,trap,count=20000)
def scalar_props(at,ident,value,range_entry=False):
 u.mem_write(at,bytes(24));u.mem_write(at,bytes([1,ident,0,0]));put(at+4,'f',value)
 if range_entry:put(at+8,'f',0.)
rows=[]
for bus_present,parent_present,first_raw,marker,scope,owner,volume_path,created in itertools.product([False,True],[False,True],[1],[0,17],range(4),[1,2],['absent','static','blocked'],[False,True]):
 for address in addresses:u.mem_write(address,bytes(0x1000));put(address,'I',table)
 child,parent,bus,bus_parent=addresses
 if parent_present:put(child+0x20,'I',parent)
 if bus_present:
  put(child+0x38,'I',child+0x100);put(child+0x100,'I',bus);put(child+0x24,'I',bus)
  u.mem_write(child+0x700,bytes([2,8,9,0]));put(child+0x704,'ff',-31.,40.);put(child+0x28,'I',child+0x700)
  put(bus+0x24,'I',bus_parent)
  if volume_path!='absent':
   for address,value in [(bus,-23.),(bus_parent,-12.)]:scalar_props(address+0x200,0,value);put(address+0x28,'I',address+0x200)
  if volume_path=='blocked':put(bus+0x18,'I',bus+0x600);put(bus+0x604,'I',123)
 for index,address in enumerate(addresses):
  if scope&1:
   put(address+0x14,'I',address+0x300);put(address+0x30c,'I',address+0x400);scalar_props(address+0x400,8,float(index+1),True)
  if scope&2:
   put(address+0x40,'I',address+0x500);put(address+0x500,'II',address+0x520,1);put(address+0x520,'II',1,address+0x540);put(address+0x54c,'I',address+0x560);scalar_props(address+0x560,8,float(index+1)*0.25,True)
 u.mem_write(parameters,b'\xa5'*304 if created else bytes(304));put(parameters,'I',0x12345678);put(parameters+4,'fff',13.,17.,19.);put(parameters+0x2a,'H',marker)
 initial_prefix=bytes(u.mem_read(parameters,48)).hex()
 u.mem_write(route_manager,bytes(0x100));put(route_manager+0x4d,'B',2);put(route_manager+0x10,'I',1);put(0x14a7e4c,'I',route_manager);u.mem_write(voice,bytes(0x200));put(voice+0x60,'IIII',child,0xabcdef,owner,optional);put(optional+0x128,'I',3);put(voice+0x12b,'B',5);put(voice+0x12e,'B',0x80);put(voice+0x18c,'I',0 if created else parameters)
 trace.clear();u.emu_start(trap+0x200,trap+0x202);invoke(0xaef360,[],voice)
 assert u.reg_read(UC_X86_REG_EIP)==trap and read(voice+0x18c,'I')[0]==parameters and read(voice+0x12e,'B')[0]==0xc0
 rows.append(dict(created=created,initial_prefix=initial_prefix,output_prefix=bytes(u.mem_read(parameters,48)).hex(),context_reference=parameters,bus_present=bus_present,parent_present=parent_present,first_raw=first_raw,initial_marker=marker,scope=scope,owner=owner,volume_path=volume_path,result=1,output_words=list(read(parameters+4,'III')),output_marker=read(parameters+0x2a,'H')[0],output_reference=read(parameters,'I')[0],calls=list(trace)))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),case_count=len(rows),cases=rows,adapters=['Original AEF360/B15530/AFEB10/B1AD70/B1AA50/AF1900/AFF1E0/AF1700/AF1660/AFF150/AFF0C0 execute unchanged. Only aligned allocator result supplied; no routing, inheritance or local getter result adapter.','Constructed acyclic parent/bus graphs and static/global/object property stores. RTPC flags cleared and random ranges absent, separate standalone qualifications cover them.'],limits=['Preparatory evidence for routing with bus/property hierarchy; runtime bank initialization, live RTPC/RNG and physical/device output remain open.'])
(r/'data/4.20/audio_routing_inheritance_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original routing/creation/inheritance/local getter compositions')
