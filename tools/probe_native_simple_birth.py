"""Original Simple emission and particle array insertion with explicit valid storage."""
from pathlib import Path
import struct,json,datetime,itertools
r=Path('E:/OpenLeague')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')")
exec(compile(source,'native setup','exec'))
instance=heap+0x1000;definition=heap+0x2000;system=heap+0x3000;context=heap+0x4000;container=heap+0x6000;metadata=heap+0x7000
native_ranges=[(0x400000+s.VirtualAddress,0x400000+s.VirtualAddress+s.Misc_VirtualSize) for s in p.sections if s.Characteristics&0x20000000]
visited=set();calls=[]
def f(a,v):u.mem_write(a,struct.pack('<f',v))
def floats(a,n):return list(struct.unpack('<'+'f'*n,u.mem_read(a,4*n)))
def hook(uc,a,size,user):
 visited.add(a)
 if a==0x943284:
  sp=u.reg_read(UC_X86_REG_ESP)
  calls.append(dict(now=floats(sp,1)[0],life=floats(sp+4,1)[0],position=floats(read32(sp+8),3),velocity=floats(read32(sp+12),3),scalars=floats(sp+16,4)))
 assert any(lo<=a<hi for lo,hi in native_ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
matrices=[[1.,0.,0.,0.,1.,0.,0.,0.,1.],[0.,0.,-1.,0.,1.,0.,1.,0.,0.],[2.,0.,0.,0.,3.,0.,0.,0.,4.]]
for matrix,position,offset,count,life in itertools.product(matrices,[[0.,0.,0.],[400.,-100.,900.]],[[0.,0.,0.],[10.,20.,30.]],[1,2],[2.,.25]):
 for a,n in [(instance,0x200),(definition,0x410),(system,0x200),(context,0x200),(container,0x200),(metadata,0x100)]:u.mem_write(a,b'\0'*n)
 write32(instance,system);write32(instance+4,definition);write32(instance+0x140,context);write32(instance+0xc,container);write32(container,instance);write32(definition+4,metadata)
 f(instance+0x10,1.);f(instance+0xd8,10.);f(system+0xa8,10.);f(context+0xec,1.)
 for i,x in enumerate(matrix):f(instance+0x94+i*4+(i//3)*4,x)
 for i,x in enumerate(position):f(instance+0x44+i*4,x-50.);f(instance+0xc4+i*4,x)
 write32(definition+0x17c,1);f(definition+0x170,100.);f(definition+0x174,100.)
 cursor=heap+0x5000
 for off,values in [(0x74,[float(count)]),(0x88,[life]),(0xa8,[0.,0.,0.]),(0xc4,[0.]),(0xd8,[0.]),(0xec,[0.,0.,0.]),(0x108,[500.]),(0x11c,offset),(0x1a0,[1.])]:
  write32(definition+off,cursor);write32(definition+off+4,cursor+4*len(values));write32(definition+off+8,cursor+4*len(values))
  for i,x in enumerate(values):f(cursor+4*i,x)
  cursor+=0x40
 for i,off in enumerate(range(8,0x99,12)):
  a=heap+0x8000+i*0x100;write32(container+off,a);write32(container+off+4,a);write32(container+off+8,a+0x100)
 # Explicit deterministic native RNG state, not a substitute RNG implementation.
 write32(0x2d6ece4,0);write32(0x2d6ece8,0)
 for i in range(55):write32(0x2d6ec08+i*4,12345+i*13579)
 sp=stack+0x8000;write32(sp,end);f(sp+4,10.125);f(sp+8,.5)
 calls=[];u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance)
 u.emu_start(0x941f00,end,count=100000)
 assert u.reg_read(UC_X86_REG_EIP)==end
 assert len(calls)==count and u.mem_read(instance+0xd4,1)==b'\1'
 assert floats(instance+0xd8,1)==[10.125] and read32(metadata+0x28)==count
 stored=dict(birth=floats(read32(container+8),count),life=floats(read32(container+0x14),count),position=floats(read32(container+0x2c),count*3),velocity=floats(read32(container+0x38),count*3))
 first_calls=calls
 before=bytes(u.mem_read(container,0x100))
 calls=[];f(sp+4,10.25);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance)
 u.emu_start(0x941f00,end,count=100000)
 assert not calls and bytes(u.mem_read(container,0x100))==before and floats(instance+0xd8,1)==[10.125]
 cases.append(dict(matrix=matrix,position=position,offset=offset,count=count,life=life,calls=first_calls,stored=stored,latch=1,previous=10.125,subsequent_births=0))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,entry='0x941f00',passed=True,complete=False,original_instruction_addresses=len(visited),adapters=[],cases=cases,limits=['Explicit valid preallocated particle arrays, constant curve tables, owner metadata, emitter matrix and native RNG seed supplied. Surrounding constructor/reader and matrix producer not executed.','Original emission, scalar/vector sampling, RNG, particle insertion, emission time and burst latch instructions execute without adapters.','Placement matrices are fixtures; relation to authored local-orient and owner/bone attachment remains unqualified. No subsequent particle update/destruction or renderer acceptance.'])
(r/'data/4.20/simple_birth_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(cases=len(cases),instructions=len(visited),sample=cases[:2])))
