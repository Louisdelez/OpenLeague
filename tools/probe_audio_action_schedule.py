from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0x10000;props=vector+0x11000;pending=vector+0x12000;manager=vector+0x13000;entry=vector+0x14000;lock=vector+0x15000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x14a7a08,manager)
def hook(uc,a,size,user):
 if a in [0xb05f47,0xb06b10,0xb05fdd]:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for delay,lead,tick in itertools.product([0,1,1023,1024,1025,2048,48000],[0,1,2],[0,100,0xffffffff]):
 for addr,size in [(action,176),(props,16),(pending,64),(manager,256),(entry,12)]:u.mem_write(addr,bytes(size))
 w(action,0xff1c34);w(action+12,2);w(action+0x14,props);u.mem_write(action+0x20,struct.pack('<H',0x503));u.mem_write(props,b'\x01\x0e');w(props+4,delay)
 w(pending+4,action);w(manager+0x7c,tick);w(manager+0x44+8,entry);w(0x14a79e8,lead)
 w(stack,end);w(stack+4,pending);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb05f00,end,count=1000)
 stop=u.reg_read(UC_X86_REG_EIP);blocks=delay>>10;remaining=max(0,blocks-lead)
 expected_stop=0xb05f47 if blocks==0 else (0xb06b10 if remaining==0 else 0xb05fdd)
 assert stop==expected_stop,(delay,lead,tick,hex(stop))
 assert read(action+12)==3
 assert read(pending+12)==delay-(remaining<<10)
 target=(tick+remaining)&0xffffffff;assert read(pending+8)==target
 if remaining:
  assert read(manager+0x44)==entry and read(manager+0x48)==entry and read(manager+0x4c)==0
  assert read(entry)==0 and read(entry+4)==target and read(entry+8)==pending and read(manager+0x58)==1
 rows.append(dict(delay=delay,lead=lead,tick=tick,target=target,remainder=read(pending+12),stop=hex(stop),queued=bool(remaining)))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual B05F00 retains action via B21CC0, reads property via B21F10 and schedules through actual B06140 on an empty queue.','Action503 subtracts min(blocks,global14A79E8); retained remainder includes the subtracted blocks. Tick addition wraps32bit.'],adapters=['Windows lock imports replaced by ret4 in single-thread emulator. Supplied property map, one free queue node, zero playingID.','Stop before immediate execution B05F47/B06B10 or after queue insertion B05FDD.'],limits=['No execution, cleanup, populated queue ordering or allocation failure proof; no audible output.'])
(r/'data/4.20/audio_action_schedule.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'native schedule cases;',sum(x['queued'] for x in rows),'queued')
