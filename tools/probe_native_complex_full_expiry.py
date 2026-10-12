"""Original93AE90 with entire937F30, all13buffers: no removal adapter."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_complex_particle_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nregistered_hook=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'append setup','exec'));u.hook_del(registered_hook);append_hook=hook;removed=[]
def hook(uc,a,size,user):
 if a==0x937f30:
  sp=u.reg_read(UC_X86_REG_ESP);index=read32(sp+4);assert u.reg_read(UC_X86_REG_ECX)==container
  removed.append({'index':index,'id':read32(read32(container+0x88)+index*4)})
 append_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
profiles=[[],[(0.,0.)],[(0.,1.),(0.,0.),(0.,2.)],[(0.,0.),(0.,0.),(0.,0.)],[(0.,float('nan')),(float('nan'),1.),(0.,1.)],[(0.,float('inf')),(float('inf'),1.),(-float('inf'),1.)],[(0.,.5),(1.,.1),(2.,-1.),(3.,1.)]]
cases=[]
for kind,profile,time,last_equal,slots in itertools.product([1,4,5,9],profiles,[0.,.5,1.,2.,float('nan'),float('inf')],[False,True],[0,2]):
 height=0.;initialize(32,slots,False);write32(config+0x10,kind);removed=[]
 for i,(birth,life) in enumerate(profile):
  values=payload(i,0);values[0x100//4]=bits(birth);values[0x104//4]=bits(life);values[0x110//4]=i;append(values,i)
 write32(container+0xac,len(profile));last=bits(time) if last_equal else 0xff7fffff;write32(container+0xa8,last);before=snapshot_buffers()
 sp=stack+0x8000;write32(sp,end);write32(sp+4,bits(time));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x93ae90,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append({'kind':kind,'trail_slots':slots,'time':hex(bits(time)),'last_update':hex(last),'before':before,'after':snapshot_buffers(),'removed':removed.copy(),'stored_time_after':hex(read32(container+0xa8)),'live_count':read32(container+0xac)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'93AE90 ->937F30','cases':cases,'adapters':['Original expiry, whole particle removal, buffer copy/shift, weak-null helpers all execute. Only heap/security transport adapted. Removal entry observed for index/ID, never replaced.','Explicit finite companion attributes, binary birth/life/time including NaN/infinities; null trail slots0/2; original kinds1/4/5/9.'],'limits':['Live effect virtual bodies, acquisition and death emitters remain incomplete.','Frame dispatcher stored-time update is separate; this native function leaves A8 unchanged.','Ordinary application rebuild and renderer consumer binding pending.']}
(r/'data/4.20/complex_full_expiry_contract.json').write_text(json.dumps(proof,separators=(',',':'))+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'removals':sum(len(c['removed']) for c in cases),'complete':False}))
