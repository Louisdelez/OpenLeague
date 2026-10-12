from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0x10000;props=vector+0x11000
rows=[]
for delay,initial in itertools.product([0,1,1023,1024,1025,48000,0xffffffff],[0,700]):
 u.mem_write(action,bytes(176));u.mem_write(props,bytes(16));w(action+0x14,props);u.mem_write(props,b'\x01\x0e');w(props+4,initial)
 call(0xb22100,action,struct.pack('<IIII',14,delay,0,0))
 assert u.reg_read(UC_X86_REG_EAX)==1 and read(props+4)==delay and read(action+0x18)==0
 call(0xb21f10,action)
 assert u.reg_read(UC_X86_REG_EAX)==delay
 rows.append(dict(delay_bits=delay,initial=initial,readback=u.reg_read(UC_X86_REG_EAX)))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['FF1C34 virtual18 is B22100, a property setter, not action execution.','Property14 set through actual B22100/AF26D0 and read through actual B21F10 without randomization when range map absent.','B05F00 reads B21F10, splits unsigned value into 1024-unit blocks and remainder; scheduling path not executed by this probe.'],adapters=['Supplied one-entry preallocated property map; no native function intercepted.'],limits=['Map allocation, random ranges and actual scheduling/voice execution remain unqualified. Units not inferred from this property-only probe.'])
(r/'data/4.20/audio_action_delay_property.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'action delay property round trips')
