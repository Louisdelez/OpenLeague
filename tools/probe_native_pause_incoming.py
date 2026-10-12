from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock_pause.py').read_text().split('\nrows=[]')[0],'setup','exec'))
packet=vector+0xe000;parent=stack-0x1000
rows=[]
for remaining,flags in itertools.product([-1,0,1,1800],[0,1,2,3]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj)
 u.mem_write(controller,b'\0'*0x50);w(controller,0x10deac4);w(controller+4,obj);w(0x2d791a4,controller);u.mem_write(controller+0x14,b'\1');u.mem_write(controller+0x18,struct.pack('<f',5.));u.mem_write(controller+0x2c,struct.pack('<f',1800.));u.mem_write(controller+0x30,struct.pack('<f',5.));w(obj+0x28,controller)
 u.mem_write(packet,b'\0'*32);u.mem_write(packet+9,struct.pack('<i',remaining));u.mem_write(packet+13,bytes([flags]));u.mem_write(parent-0x900,b'\0'*0x900);counter=10000000;calls=0
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,parent);u.reg_write(UC_X86_REG_EBX,packet);u.emu_start(0x58aef0,0x58af2e,count=500);assert u.reg_read(UC_X86_REG_EIP)==0x58af2e
 accepted=bool(u.reg_read(UC_X86_REG_EAX)&255);assert accepted==(remaining>0)
 state=snapshot('incoming_pause');assert state['paused']==int(accepted);assert u.mem_read(controller+0x17,1)[0]==((flags&1) if accepted else 0)
 u.mem_write(packet+9,bytes([flags]));u.mem_write(parent-0x900,b'\0'*0x900);counter=15000000
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,parent);u.reg_write(UC_X86_REG_EBX,packet);u.emu_start(0x58af64,0x58af82,count=500);assert u.reg_read(UC_X86_REG_EIP)==0x58af82
 after=snapshot('incoming_resume');assert after['paused']==int(accepted and flags&1!=0)
 rows.append(dict(remaining_seconds=remaining,raw_flags=flags,accepted=accepted,budget_adjustment=struct.unpack('<f',u.mem_read(controller+0x34,4))[0],pause=state,resume=after))
for opcode,target in [(0xa1,0x58aef0),(0x0a,0x58af64)]:
 u.reg_write(UC_X86_REG_ECX,opcode);u.emu_start(0x5882c6,end,count=6);assert u.reg_read(UC_X86_REG_EIP)==target
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),pause_opcode=0xa1,resume_opcode=0x0a,opcode_dispatch_verified=True,pause_handler=['0x58aef0','0x58af2e'],resume_handler=['0x58af64','0x58af82'],cases=rows,limits=['Dispatcher opcodes A1/0A executed through original remap/jump tables; payload memory supplied, envelope/authentication not qualified.','Pause actor notification828BE0 and resume828E20 after these blocks not executed.','Controller configured with native default ResumeDelay5/TotalLimit1800; no claim of effective server config.'])
(r/'data/4.20/game_clock_pause_incoming_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,sequences=len(rows))))
