"""Execute derived duration callback gates up to native action factory boundary."""
from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
obj=vector+0x6000;boundary=0xb1f960;seen=[]
threshold=struct.unpack('<f',u.mem_read(0x1139060,4))[0]
def hook(uc,a,size,user):
 if a==boundary:seen.append(a);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for entry,state,flags,present,value in itertools.product([0xb2a230,0xb2a430],range(16),[0,0x10,0x20,0x30],[False,True],[threshold-1.,threshold,threshold+1.]):
 u.mem_write(obj,bytes(0x240));w(obj,0xff27d4);w(obj+0x200,state);w(obj+0x1fc,int(present));u.mem_write(obj+0x12d,bytes([flags]));u.mem_write(obj+0x204,b'\4')
 w(stack,end);u.mem_write(stack+4,struct.pack('<f',value));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);seen.clear()
 u.emu_start(entry,end,count=1000);reached=u.reg_read(UC_X86_REG_EIP)==boundary
 expected=(not flags&0x10 and state==4 and present) if entry==0xb2a230 else (not flags&0x30 and present and (state==5 or state in [1,2] and value>=threshold))
 assert reached==bool(expected),(hex(entry),state,flags,present,value,reached,expected)
 assert reached or u.reg_read(UC_X86_REG_EIP)==end
 rows.append(dict(entry=hex(entry),state=state,flags=flags,has_next=present,milliseconds=value,reached_action_factory=reached))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,case_count=len(rows),threshold=threshold,findings=['Virtual2C B2A230 admits state4 with next-pointer present unless flag10.','Virtual10 B2A430 admits state5 or states1/2 at or above native duration threshold, with next-pointer present and flags10/20 clear.','Actual virtual44 B29F70 executes its preexisting flag204bit4 early-return path.'],limits=['Execution stops at action factory B1F960; no action construction, scheduling or sound output qualified.','State producer and Map10 applicability unknown. Flag204bit4 supplied, so populated refresh path not covered.'])
(r/'data/4.20/audio_derived_duration_gates.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,cases=len(rows),threshold=threshold,action_frontiers=sum(c['reached_action_factory'] for c in rows))))
