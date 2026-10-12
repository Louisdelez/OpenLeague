"""Original emitter matrix producer and particle bind/local-orient consumers."""
from pathlib import Path
import struct,json,datetime,itertools
r=Path('E:/OpenLeague')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')")
exec(compile(source,'native setup','exec'))
instance=heap+0x1000;definition=heap+0x2000;system=heap+0x3000;container=heap+0x4000;births=heap+0x5000;ages=heap+0x5100;positions=heap+0x5200
native_ranges=[(0x400000+s.VirtualAddress,0x400000+s.VirtualAddress+s.Misc_VirtualSize) for s in p.sections if s.Characteristics&0x20000000]
visited=set()
def hook(uc,a,size,user):
 visited.add(a);assert any(lo<=a<hi for lo,hi in native_ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def f(a,v):u.mem_write(a,struct.pack('<f',v))
def floats(a,n):return list(struct.unpack('<'+'f'*n,u.mem_read(a,4*n)))
def call(entry,args=[]):
 sp=stack+0x8000;write32(sp,end)
 for i,x in enumerate(args):f(sp+4+i*4,x)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance if entry==0x943300 else container)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
yaw90=[0.,0.,-1.,0.,0.,1.,0.,0.,1.,0.,0.,0.,0.,0.,0.,1.]
cases=[];normalized_ages=[0.,.000001,.0001,.25,.5,.99,1.,1.1]
for emitter_local,particle_local,pair,matrix,stick in itertools.product([0,1],[0,1],[[0.,0.],[1.,1.],[0.,1.],[1.,0.],[.5,.5],[.5,1.],[-1.,1.]],[identity,yaw90],[0,1]):
 for a,n in [(instance,0x200),(definition,0x410),(system,0x200),(container,0x200)]:u.mem_write(a,b'\0'*n)
 write32(instance,system);write32(instance+4,definition);write32(container,instance)
 u.mem_write(definition+0x150,bytes([emitter_local,particle_local]));u.mem_write(definition+0x160,bytes([stick]));f(definition+0x158,pair[0]);f(definition+0x15c,pair[1])
 for i,x in enumerate(identity):f(system+0xf0+4*i,x)
 for i,x in enumerate([100.,200.,300.]):f(system+0x90+4*i,x)
 call(0x943300,[10.,.5])
 initial=floats(instance+0x14,16);inverse=floats(instance+0x54,16)
 for i,x in enumerate([100.,200.,300.]):f(instance+0x44+4*i,x)
 u.mem_write(instance+0xd4,b'\1')
 for i,x in enumerate(matrix):f(system+0xf0+4*i,x)
 for i,x in enumerate([110.,220.,330.]):f(system+0x90+4*i,x)
 call(0x943300,[10.125,.5])
 assert floats(instance+0x14,16)==initial and floats(instance+0x54,16)==inverse
 write32(container+8,births);write32(container+0xc,births+4*len(normalized_ages));write32(container+0x20,ages);write32(container+0x24,ages+4*len(normalized_ages));write32(container+0x2c,positions)
 for i,x in enumerate(normalized_ages):f(ages+4*i,x)
 before=[400.,500.,600.]*len(normalized_ages)
 for i,x in enumerate(before):f(positions+4*i,x)
 call(0x944600);after_bind=floats(positions,len(before))
 call(0x944760);after_local=floats(positions,len(before))
 cases.append(dict(emitter_local=emitter_local,particle_local=particle_local,pair=pair,stick=stick,ages=normalized_ages,system_matrix=matrix,initial=initial,inverse=inverse,current=floats(instance+0x94,16),current_position=floats(instance+0xc4,3),before=before,after_bind=after_bind,after_local=after_local))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,entries=['0x943300','0x944600','0x944760'],original_instruction_addresses=len(visited),adapters=[],bind_age_threshold=floats(0x1138a10,1)[0],bind_range_epsilon=struct.unpack('<d',u.mem_read(0x1138c08,8))[0],cases=cases,limits=['Valid emitter/system matrices, previous/current positions, constant normalized ages and particle arrays explicitly supplied.','Original matrix copy/inverse, bind-weight position update and local-orient matrix application execute without adapters.','Native upstream system matrix/bone producer, normalized-age producer and update ordering remain unqualified. No owner destruction or visual acceptance.'])
(r/'data/4.20/simple_attachment_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(cases=len(cases),instructions=len(visited),threshold=proof['bind_age_threshold'],epsilon=proof['bind_range_epsilon'])))
