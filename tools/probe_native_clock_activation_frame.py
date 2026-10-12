from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('rows=[]')[0],'setup','exec'))
qpc=vector+0xb000;w(0xfa4134,qpc);samples=[];events=[]
def observe(uc,address,size,user):
 if address==0xce298a:finish(0)
 elif address==qpc:
  value=samples.pop(0);sp=u.reg_read(UC_X86_REG_ESP);u.mem_write(read(sp+4),struct.pack('<Q',value));events.append(['qpc',value]);finish(1,4)
 elif address==0x58cb20:events.append(['frame_work']);finish(0)
 elif address==0x8c7b80:events.append(['statistics']);finish(0)
u.hook_add(unicorn.UC_HOOK_CODE,observe)
w(0x2d79078,0);u.mem_write(0x2d78e00,b'\0');w(0x2d78dc0,0)
u.mem_write(0x14bef48,struct.pack('<Q',0));u.mem_write(0x14bef50,struct.pack('<Q',10000000))
rows=[]
for initial,start,finish_counter in [(1000000,1100000,1200000),(1000000,1100000,1100100),(0,0,2500),(1234567,1400000,1600000)]:
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);samples[:]=[initial];events.clear();u.reg_write(UC_X86_REG_ESI,obj);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x58fcf9,0x58fd1f,count=300)
 assert u.reg_read(UC_X86_REG_EIP)==0x58fd1f and not samples
 assert read(0x2d791a8)==obj and u.mem_read(obj+0x38,1)==b'\1'
 assert struct.unpack('<d',u.mem_read(obj+0x10,8))[0]==1.
 drift_bits=read(obj+0x34);samples[:]=[start,finish_counter];events.clear();u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x58d550,0x58d579,count=500)
 assert u.reg_read(UC_X86_REG_EIP)==0x58d579 and not samples
 assert events[:3]==[['qpc',start],['frame_work'],['qpc',finish_counter]],events
 rows.append(dict(initial=initial,frame_start_counter=start,frame_end_counter=finish_counter,drift_bits=drift_bits,frame_start_bits=read(0x2d78dfc),delta_bits=read(0x123eeb8),game_time_bits=read(obj+0x2c),events=list(events)))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),activation_block=['0x58fcf9','0x58fd1f'],frame_block=['0x58d550','0x58d579'],cases=rows,limits=['Constructor original; allocator skipped by supplying object storage.','Frame work58CB20 and statistics8C7B80 are ABI stubs; no gameplay/render work reproduced in emulator.','OS QPC deterministic supplied; limiter disabled and optional manager null.','Only normal mode; no live integration claim.'])
(r/'data/4.20/game_clock_activation_frame_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,activation_and_frame_sequences=len(rows))))
