"""Whole938900 dispatcher; update/storage callbacks recorded explicitly."""
from pathlib import Path
import struct,json,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook
container=heap+0x1000;config=heap+0x2000;pairs=heap+0x3000;events=[]
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a in (0x9389d0,0x9393d0,0x939b10):
  assert u.reg_read(UC_X86_REG_ECX)==container
  kind={0x9389d0:'movement',0x9393d0:'surface',0x939b10:'color'}[a];event={'kind':kind,'time':hex(read32(sp+4))}
  if a!=0x939b10:event['flag1']=read32(sp+8)&255
  if a==0x9389d0:event['flag2']=read32(sp+12)&255
  events.append(event);finish({0x9389d0:12,0x9393d0:8,0x939b10:4}[a],0);return
 if a==0x93a550:
  assert u.reg_read(UC_X86_REG_ECX)==container
  events.append({'kind':'new','index':read32(sp+4)});finish(4,0);return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(time,last,flags,kind,count,old_count):
 global events
 events=[];u.mem_write(container,b'\0'*0x200);u.mem_write(config,b'\0'*0x300);write32(container+4,pairs);write32(container+8,pairs+8*count);write32(container+0xa0,config);write32(container+0xa8,time if False else last);write32(container+0xac,old_count);write32(config+0x10,kind);u.mem_write(config+0x2ac,bytes([flags]))
 sp=stack+0x8000;write32(sp,end);write32(sp+4,time);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.emu_start(0x938900,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'time':hex(time),'last':hex(last),'flags':flags,'kind':kind,'count':count,'old_count':old_count,'events':list(events),'new_time':hex(read32(container+0xa8)),'new_count':read32(container+0xac)}
times=[(bits(1.),bits(0.)),(bits(1.),bits(1.)),(bits(0.),0xff7fffff),(0xff7fffff,0xff7fffff),(0x80000000,0),(0x7fc01234,bits(0.)),(bits(1.),0x7fc01234),(0x7f800000,0x7f800000)]
cases=[run(time,last,flags,kind,count,old) for (time,last),flags,kind,count,old in itertools.product(times,range(8),[0,1,3,11,4],[0,1,4],[0,2])]
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'0x938900','cases':cases,'original_instruction_addresses':len(visited),'adapters':['Whole original dispatcher executes. Movement/surface/color and new-particle callbacks record native arguments and return without changing storage. Supplied legal container/configuration/counts.'],'limits':['Callback bodies, modifications to storage during callbacks and actual graphic update remain unqualified here.','Raw flags/kind producers and full outer emitter frame scheduling remain incomplete.']}
(r/'data/4.20/complex_frame_dispatch_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'passed':True}))
