"""Original Bus virtualCC gain/cache refresh with active descendant gates."""
from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000,heap+0x2000,heap+0x2100];effect_caches=[heap+0x3000,heap+0x3100,heap+0x3200];groups=[heap+0x4000,heap+0x4100,heap+0x4200];array=heap+0x5000;value=heap+0x7000;calls=[];gain_profile=0
u.mem_write(trap+0x100,b'\xd9\x05'+struct.pack('<I',value)+b'\xc2\x08\x00');u.mem_write(trap+0x200,b'\xdb\xe3')
regions=[(0xb03d40,0xb03e21),(0xb04bc0,0xb04c36),(0x574170,0x574173),(trap+0x100,trap+0x109),(trap+0x200,trap+0x202)]
def guard(uc,a,n,d):
 if a==0xb02ce0:
  who=u.reg_read(UC_X86_REG_ECX);args=read(u.reg_read(UC_X86_REG_ESP)+4,'II');bits=struct.unpack('<I',struct.pack('<f',[0.,1.,-2.5][gain_profile]+nodes.index(who)*0.25+args[0]*0.5))[0];put(value,'I',bits);calls.append({'kind':'gain','node':who,'args':list(args),'bits':bits});u.reg_write(UC_X86_REG_EIP,trap+0x100);return
 if a in [0xb0ec10,0xb0ebb0]:
  args=read(u.reg_read(UC_X86_REG_ESP)+4,'II');calls.append({'kind':'root_gain' if a==0xb0ec10 else 'bus_gain','args':list(args)});ret(0,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[];effect_profiles=[0,1,2,7];active_profiles=[[(0,0),(0,0)],[(1,0),(0,0)],[(0,0),(0,0xffff)]]
for effect_profile,metadata,flags,linked,pattern,group_present,active_profile,gain_profile in itertools.product(range(4),[0,0x600],[0,4,8,12],[False,True],[0,0xa5,0xff],[False,True],range(3),range(3)):
 for i,node in enumerate(nodes):
  u.mem_write(node,b'\xa5'*200);put(node,'III',0xff1380,0,100+i);put(node+0x18,'I',effect_caches[i]);put(node+0x1c,'I',groups[i] if i or group_present else 0);put(node+0x24,'I',(heap+0x6000 if linked else 0) if i==0 else nodes[0]);put(node+0x60,'I',metadata);u.mem_write(node+0x2f,bytes([flags]));u.mem_write(node+0xc4,bytes([pattern]));u.mem_write(effect_caches[i],bytes(36));put(effect_caches[i]+4,'I',777 if effect_profiles[effect_profile]&(1<<i) else 0);u.mem_write(groups[i],bytes(52));
  if i:put(groups[i]+0x30,'HH',*active_profiles[active_profile][i-1])
 put(groups[0]+0x24,'II',array,2)
 for i,node in enumerate(nodes[1:]):put(array+i*4,'I',node)
 before=[bytes(u.mem_read(node,200)).hex()for node in nodes];calls.clear();u.emu_start(trap+0x200,trap+0x202);sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xb03d40,trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'effect_profile':effect_profile,'metadata':metadata,'flags':flags,'linked':linked,'pattern':pattern,'group_present':group_present,'active_profile':active_profile,'active':active_profiles[active_profile],'gain_profile':gain_profile,'before':before,'after':[bytes(u.mem_read(node,200)).hex()for node in nodes],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions if a<trap],'adapters':['Actual B03D40/B04BC0 cache refresh and child virtualCC recursion execute with actual Bus virtual38. B02CE0 gain evaluation and B0EC10/B0EBB0 gain application are mandatory explicit interfaces; their bodies do not execute.','Constructed acyclic group child arrays with active words30/32 gate recursion; cache effect IDs and metadata/flags/root-parent conditions exercised.'],'limits':['Preparatory reference; Rust gain/cache/hierarchy consumer and gain/application dependencies not yet qualified here.','Normal group cache/voice ownership, gain aggregation, DSP and audible output remain open.']}
(r/'data/4.20/audio_bus_effects_changed_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus effect changed/gain cache/hierarchy cases')
