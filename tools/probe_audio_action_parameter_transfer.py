from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0x10000;parameters=vector+0x11000;pending=vector+0x12000
rows=[]
for fill,flag in itertools.product([0,0xcc,0xff],[0,1]):
 u.mem_write(action,bytes([fill])*176)
 payload=bytes((i*37+fill)%256 for i in range(72));u.mem_write(parameters,payload)
 before=bytes(u.mem_read(action,176))
 call(0xb1fc50,action,struct.pack('<I',parameters))
 after=bytes(u.mem_read(action,176));assert after[:64]==before[:64] and after[64:136]==payload and after[136:]==before[136:]
 w(action+0x2c,0)
 original_flag=bytes(u.mem_read(action+0x30,1))[0]
 call(0xb1fd20,action,struct.pack('<III',0,flag,pending))
 assert u.reg_read(UC_X86_REG_EAX)==1 and read(action+0xa0)==pending and read(action+0x2c)==0
 assert bytes(u.mem_read(action+0x30,1))[0]==((original_flag&~2)|(flag<<1))
 rows.append(dict(fill=fill,flag=flag,parameter_bytes=payload.hex(),pending=read(action+0xa0),flags=bytes(u.mem_read(action+0x30,1))[0]))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual B1FC50 copies exactly 72 bytes to action+40 and preserves surrounding bytes.','Actual B1FD20 stores pending at A0 and changes only flag bit1 when previous and requested associated IDs are zero.'],adapters=['Mapped action, parameter and pending buffers supplied; no intercepted native calls.'],limits=['Nonzero associated IDs require manager registration and are not qualified. Other setters and scheduling remain open.'])
(r/'data/4.20/audio_action_parameter_transfer.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'native action parameter transfer cases')
