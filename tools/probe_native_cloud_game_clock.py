from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
def f32(v):return struct.unpack('<f',struct.pack('<f',v))[0]
def put(a,v):u.mem_write(a,struct.pack('<f',v))
rows=[]
for dt,speed in itertools.product([.015625,.125,1.],[.01,-.01,0.,.5]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);w(0x2d791a8,obj);u.mem_write(obj+0x38,b'\1')
 u.mem_write(0x1224dd8,b'\1');w(0x2d78c60,1);put(0x2d78c5c,.25);put(0x2d78c58,.5);put(0x14be7d8,speed);put(0x14be7dc,speed)
 expected=[.25,.5];frames=[]
 for scale in [1.,1.,0.,0.,0.,1.]:
  u.mem_write(obj+0x10,struct.pack('<d',scale));call(0x99c5e0,obj+0x20,struct.pack('<d',dt));assert read(obj+0x38)&255
  call(0x73a710,0)
  for i in range(2):
   expected[i]=f32(expected[i]+f32(dt*scale)*f32(speed))
   if expected[i]>10.:expected[i]=f32(expected[i]-10.)
  actual=[struct.unpack('<f',u.mem_read(a,4))[0] for a in [0x2d78c5c,0x2d78c58]]
  assert actual==expected,(actual,expected)
  frames.append(dict(scale=scale,delta_bits=read(obj+0x30),phase=actual))
 assert frames[1]['phase']==frames[4]['phase']
 rows.append(dict(delta=dt,speed=speed,frames=frames))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,actual_entries=['0x99c410','0x99c5e0','0x88d240','0x6416e0','0x73a710'],findings=['Cloud phase73a710 reads actual global GameClock virtual8 twice; zero scale freezes both axes, resume advances. No clock getter hooks.'],limits=['Existing nonnull cloud texture and enabled flag; texture allocation/release and disabled setting branches excluded.','Normal clock mode with explicit initialized-valid flag+38=1; constructor alone leaves it false. Validity lifecycle and visual binding separately qualified.'])
(r/'data/4.20/cloud_game_clock_pause_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS cloud GameClock',len(rows),'sequences')
