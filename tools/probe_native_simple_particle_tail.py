"""Original944E20 epilogue9455F6..945616 raw timestamp and wrapping counter."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple particle tail setup','exec'))
container=heap+0x22000;instance=heap+0x23000;definition=heap+0x24000;stats=heap+0x25000;frame=stack+0x4000
cases=[]
for time,active,counter in itertools.product([0,bits(.5),0x7f800000,0x7fa01234,0x80000000,0x7f7fffff],[0,1,7,0x7fffffff,0x80000000,0xffffffff],[0,1,0x7fffffff,0xffffffff]):
 enabled=True
 for address in [container,instance,definition,stats]:u.mem_write(address,b'\0'*0x160)
 write32(container,instance);write32(instance+4,definition);write32(definition+4,stats);write32(container+4,0xdeadbeef);write32(container+0xa4,active);write32(stats+0x24,counter)
 sp=stack+0x8000;u.mem_write(sp,b'\0'*16);u.mem_write(frame,b'\0'*24);write32(frame+4,end);write32(frame+8,time);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EDI,container)
 u.emu_start(0x9455f6,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==frame+20
 cases.append({'time':time,'active':active,'counter':counter,'output_time':read32(container+4),'output_counter':read32(stats+0x24)})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'9455F6..945616','cases':cases,'adapters':[],'limits':['Actual epilogue runs from supplied caller frame. MOVSS copies time without NaN quieting; integer ADD wraps. Full particle update, terrain and resource production remain incomplete.']}
(r/'data/4.20/simple_particle_tail_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'raw_timestamp_matches':all(c['output_time']==c['time'] for c in cases),'wrapping_counter_matches':all(c['output_counter']==(c['counter']+c['active'])&0xffffffff for c in cases)}))
