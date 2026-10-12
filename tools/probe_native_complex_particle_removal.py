"""Whole native937F30 removal, legal null trail resources; finite attribute corpus."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_complex_particle_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'storage setup','exec'))
cases=[]
for kind,capacity,trail_count,count in itertools.product(range(12),[0,32],[0,1,4],[1,4]):
 for index in range(count):
  height=0.;initialize(capacity,trail_count,False);write32(config+0x10,kind)
  for particle in range(count):append(payload(particle,0),particle)
  # Append does not maintain the live counter: its birth caller owns that update.
  write32(container+0xac,count)
  before=snapshot_buffers()
  sp=stack+0x8000;write32(sp,end);write32(sp+4,index);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x937f30,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  after=snapshot_buffers();assert read32(container+0xac)==count-1
  cases.append({'kind':kind,'capacity':capacity,'trail_slots':trail_count,'count':count,'index':index,'before':before,'after':after,'live_count':read32(container+0xac)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'937F30','cases':cases,'adapters':['Original entire937F30,93A7E0 and all copy/shift/trail-null helpers execute. Heap/free/security transport inherited from append probe.','Live count initialized as by omitted birth caller. Configuration kinds0..11 supplied; newborn trail handles all null. Finite explicit birth payloads and globals; no invented runtime resource.'],'limits':['Live non-null trail virtual calls/refcounts, death-emitter creation and resource acquisition remain unqualified.','Finite attributes only: signaling-NaN conversion in x87 assignments requires a separate actual CPU reference before qualification.','Ordinary renderer binding and application rebuild remain pending.']}
(r/'data/4.20/complex_particle_removal_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'kinds':12,'buffers':13,'complete':False}))
