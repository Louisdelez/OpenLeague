"""Original93FA10 emitter stop and conditional logical audio release."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_inactive_queue.py').read_text(encoding='utf-8').split('u.hook_add(unicorn.UC_HOOK_CODE,queue_hook)')[0]
exec(compile(source,'queue setup','exec'));base_hook=queue_hook
engine=heap+0x5000;config=heap+0x6000;audio_table=heap+0x7000;release=end+0x100;released=[]
def stop_hook(uc,a,size,user):
 if a==release:
  assert u.reg_read(UC_X86_REG_ECX)==engine+4;released.append(struct.unpack('<i',u.mem_read(u.reg_read(UC_X86_REG_ESP)+4,4))[0]);finish(4);return
 if 0x93fa10<=a<=0x93fadd:return
 base_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,stop_hook);cases=[]
for flags,config_flags,h1,h2,clock in itertools.product([0,1,16,64,65,255],[0,16],[-1,0,42],[-1,0,42],[0.,5.]):
 u.mem_write(actor,b'\0'*0x200);write32(actor,engine);write32(engine+4,audio_table);write32(audio_table+0x20,release);write32(actor+0xe8,config);u.mem_write(config+0x1bc,bytes([config_flags]));u.mem_write(actor+0x1dc,bytes([flags]));u.mem_write(actor+0x148,struct.pack('<f',999.));write32(actor+0x1ac,h1&0xffffffff);write32(actor+0x1b0,h2&0xffffffff)
 write32(engine+0xd0,vector);write32(engine+0xd4,vector);write32(engine+0xd8,vector+256);released=[]
 for repeat in range(2):
  sp=stack+0x8000;u.mem_write(sp,struct.pack('<If',end,clock));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x93fa10,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 started=not flags&64;expected=[h for h in [h1,h2] if h!=-1] if started and config_flags&16 else [];assert released==expected
 outflags=u.mem_read(actor+0x1dc,1)[0];outtime=struct.unpack('<f',u.mem_read(actor+0x148,4))[0];outhandles=[struct.unpack('<i',u.mem_read(actor+x,4))[0] for x in [0x1ac,0x1b0]];queue_count=(read32(engine+0xd4)-vector)//4;queued=[read32(vector+4*i) for i in range(queue_count)]
 assert outflags==((flags&254)|80 if started else flags);assert outtime==(clock if started else 999.);assert outhandles==([-1,-1] if started and config_flags&16 else [h1,h2]);assert queued==([actor] if started else [])
 cases.append({'flags':flags,'config_flags':config_flags,'handles':[h1,h2],'clock':clock,'final_flags':outflags,'final_time':outtime,'final_handles':outhandles,'released':released[:],'queued':queued})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Actual93FA10 plus735880/736DC0/736E10/6B6530/5ED350 queue insertion executed with spare capacity; logical release virtual20 and CRTmemmove adapted.','Stop bit40 already set makes entire method no-op; otherwise clears bit1, sets50, writes stop time, queues emitter exactly once.','Config byte1BC bit10 controls immediate release of both signed handles except -1. Without this bit handles remain for later cleanup.','Full effect update940.. and actual cleanup scheduling/audio backend consumer remain unqualified.']}
(r/'data/4.20/audio_emitter_stop_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original emitter stop {len(cases)} cases passed')
