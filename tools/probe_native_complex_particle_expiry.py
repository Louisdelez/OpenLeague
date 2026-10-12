"""Original93AE90 expiry loop with explicit swap-removal storage adapter."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook
container=heap+0x1000;pairs=heap+0x3000;live=[];removed=[]
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def hook(uc,a,size,user):
 if a==0x937f30:
  sp=u.reg_read(UC_X86_REG_ESP);index=read32(sp+4);assert u.reg_read(UC_X86_REG_ECX)==container and index<len(live)
  removed.append({'index':index,'id':live[index]['id']});live[index]=live[-1];live.pop()
  for idx,row in enumerate(live):write32(pairs+idx*8,int(row['birth'],16));write32(pairs+idx*8+4,int(row['life'],16))
  write32(container+8,pairs+8*len(live));finish(4,0);return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(time,last,profile):
 global live,removed
 live=[{'id':index,'birth':hex(bits(birth)),'life':hex(bits(life))} for index,(birth,life) in enumerate(profile)];initial=[dict(v) for v in live];removed=[];u.mem_write(container,b'\0'*0x200);write32(container+4,pairs);write32(container+8,pairs+8*len(live));write32(container+0xa8,bits(last))
 for index,row in enumerate(live):write32(pairs+index*8,int(row['birth'],16));write32(pairs+index*8+4,int(row['life'],16))
 sp=stack+0x8000;write32(sp,end);write32(sp+4,bits(time));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.emu_start(0x93ae90,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'time':hex(bits(time)),'last_update':hex(bits(last)),'initial':initial,'removed':list(removed),'remaining_ids':[v['id'] for v in live],'stored_time_after':hex(read32(container+0xa8))}
nan=struct.unpack('<f',struct.pack('<I',0x7fc01234))[0];minimum=struct.unpack('<f',struct.pack('<I',0xff7fffff))[0];inf=float('inf')
profiles=[[],[(0.,0.)],[(0.,1.)],[(0.,-1.)],[(1.,0.)],[(0.,1.),(0.,0.),(0.,2.)],[(0.,0.),(0.,0.),(0.,0.)],[(0.,nan),(nan,1.),(0.,1.)],[(0.,inf),(inf,1.),(-inf,1.)],[(0.,.5),(1.,.1),(2.,-1.),(3.,1.)]]
cases=[run(time,last,profile) for time,last,profile in itertools.product([0.,.5,1.,2.,nan,inf],[minimum,0.,1.,nan],profiles)]
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'0x93ae90','cases':cases,'original_instruction_addresses':len(visited),'adapters':['Original whole expiry loop executes.937F30storage removal adapted to swap-last birth/life pairs with IDs; native removal/destruction of all companion arrays and ownership excluded.'],'limits':['Only original expiry selection and loop/callback order qualified; destructor, SoA companion buffers and owner release unqualified.','The function does not update stored time; frame dispatcher and ordinary graphical integration remain incomplete.']}
(r/'data/4.20/complex_particle_expiry_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'removed':sum(len(c['removed']) for c in cases),'passed':True}))
