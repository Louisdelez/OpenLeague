from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0x10000;props=vector+0x11000;rows=[]
c=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text())
for event in c['events']:
 for a in event['actions']:
  properties=a['properties'];assert '14' not in properties
  keys=sorted(int(k) for k in properties);offset=(len(keys)+4)&~3
  u.mem_write(action,bytes(64));u.mem_write(props,bytes(64));w(action+0x14,props)
  u.mem_write(props,bytes([len(keys)]+keys))
  for index,key in enumerate(keys):u.mem_write(props+offset+index*4,struct.pack('<f' if key==16 else '<I',properties[str(key)]))
  call(0xb21f10,action);assert u.reg_read(UC_X86_REG_EAX)==0
  rows.append(dict(action=a['id'],properties=properties,delay=0))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb21f10',cases=rows,limits=['Property maps reconstructed from byte-verified ambient action properties. No random ranges present.','Getter only; all actual ambient actions have absent14 and return0 despite transition15=100.'])
(r/'data/4.20/audio_ambient_default_delay.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,actions=len(rows))))
