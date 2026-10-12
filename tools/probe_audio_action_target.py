from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0x10000;manager=vector+0x11000;target=vector+0x13000;collision=vector+0x14000;pending=vector+0x15000;lock=vector+0x16000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x14a7a08,manager)
def hook(uc,a,size,user):
 if a==0xaf1c50:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for key,alternate,found,chained in itertools.product([1,193,194,0xffffffff],[False,True],[False,True],[False,True]):
 for addr,size in [(action,176),(manager,0x1000),(target,64),(collision,64),(pending,64)]:u.mem_write(addr,bytes(size))
 w(action+0x1c,key);u.mem_write(action+0x22,bytes([0x40 if alternate else 0]));w(target+8,key);w(target+12,7)
 table=manager+(0x320 if alternate else 0);bucket=table+0x18+(key%193)*4
 if chained:
  w(bucket,collision);w(collision+8,(key+193)&0xffffffff);w(collision+4,target if found else 0)
 elif found:w(bucket,target)
 w(action+0x9c,1);w(pending+12,777);w(pending+0x38,0x12345678)
 w(stack,end);w(stack+4,pending);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,action);u.emu_start(0xb1f9b0,end,count=1200)
 if found:
  assert u.reg_read(UC_X86_REG_EIP)==0xaf1c50 and u.reg_read(UC_X86_REG_ECX)==target and read(target+12)==8
  sp=u.reg_read(UC_X86_REG_ESP);params=read(sp+4)
  assert read(params)==1 and read(params+8)==0x12345678 and read(params+0x74)==777
 else:
  assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==15 and read(target+12)==7
 rows.append(dict(key=key,alternate=alternate,found=found,chained=chained,stop=hex(u.reg_read(UC_X86_REG_EIP)),references=read(target+12)))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,findings=['Actual B1F9B0 -> B21EE0 -> AF6480 -> AF9530 selects manager table by action22bit40, hashes ID modulo193, follows collisions and retains found target.','Absent target returns15; found target reaches AF1C50 with copied pending owner and delay parameters.'],adapters=['Single-thread lock imports ret4. Supplied hash tables, action and pending; prior node absent, source and other reference pointers null.','Stops before AF1C50 dispatch gate, without target execution or release.'],limits=['Non-null source references, dispatch gate, virtual13C execution and cleanup remain unqualified; no playback proof.'])
(r/'data/4.20/audio_action_target.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'action target resolution cases')
