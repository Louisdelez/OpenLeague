from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
node=vector+0x10000;params=vector+0x11000;state=vector+0x12000;props=vector+0x13000;factory=vector+0x14000;table=vector+0x15000
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:uc.emu_stop() if a==0xaf3cff else None)
rows=[]
for priority,mode in itertools.product([25.,50.,75.],[0,1,9]):
 for addr,size in [(node,128),(params,176),(state,64),(props,16),(factory,32),(table,32)]:u.mem_write(addr,bytes(size))
 u.mem_write(state+0x38,b"\x01");w(node,0xff1cd8);w(node+0x1c,state);w(node+0x28,props);u.mem_write(props,b'\x01\x05');u.mem_write(props+4,struct.pack('<f',priority));w(params,mode);w(params+4,factory);w(factory,table)
 for a in [0x14a79d8,0x14a7d3c]:u.mem_write(a,struct.pack('<f',1.))
 w(0x14a7a70,0);w(0x14a7a6c,0);u.mem_write(0x12100ec,struct.pack('<H',128))
 w(stack,end);w(stack+4,params);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb228e0,end,count=4000)
 assert u.reg_read(UC_X86_REG_EIP)==0xaf3cff
 sp=u.reg_read(UC_X86_REG_ESP);args=[read(sp+i*4) for i in range(6)]
 assert args[:3]==[node,node+0x58,params] and u.reg_read(UC_X86_REG_ECX)==factory
 assert struct.unpack('<f',u.mem_read(args[3],4))[0]==priority
 assert struct.unpack('<H',u.mem_read(state+0x30,2))[0]==1 and struct.unpack('<H',u.mem_read(state+0x34,2))[0]==1
 rows.append(dict(priority=priority,mode=mode,factory_arguments=args,priority_bytes=bytes(u.mem_read(args[3],16)).hex()))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual B228E0/AF3BD0 composes native priority, admission, virtual88 AF1E00, AFFAB0/AFF9B0 and reaches factoryvirtual10 with correct node/source/params/priority.','Native state counters30/34 increment once.'],adapters=['Supplied existing state, no parent/attenuation/RTPC, capacity128 and pressure thresholds1.','Stop before factoryvirtual10; no native function replaced.'],limits=['Factory and produced voice not executed; reader has not returned; no playback proof.'])
(r/'data/4.20/audio_reader_to_factory.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native reader to factory cases')

