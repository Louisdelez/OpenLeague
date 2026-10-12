"""Replay live client diagnostic frame inputs through original7D2BE0, with the real original RNG."""
from pathlib import Path
import json,struct,hashlib,datetime
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_camera_random_shake.py').read_text(encoding='utf-8').split('sequences=[]')[0]
exec(compile(setup,'native shake setup','exec'))
trace_path=r/'logs/native-camera-shake-live.json';trace=json.loads(trace_path.read_text(encoding='utf-8'));assert trace['diagnostic'] and not trace['native_triggers_complete']
initial=trace['initial'];seed(initial['seed']);assert rng_state()==initial['rng']
u.mem_write(shake,struct.pack('<8I',*initial['shake_bits'])+bytes([initial['active_raw']])+b'\x00'*3)
frames=trace['frames'];assert len(frames)>100 and struct.unpack('<f',struct.pack('<I',frames[-1]['now_bits']))[0]>=26.
max_error=0.;draws=0;moved=0
for n,frame in enumerate(frames):
 u.mem_write(camera,struct.pack('<16I',*frame['initial_camera_bits']));write32(0x2d78dfc,frame['now_bits']);random_calls=0;run(0x7d2be0,[camera],ecx=shake)
 assert list(struct.unpack('<8I',u.mem_read(shake,32)))==frame['shake_bits'],n
 assert u.mem_read(shake+0x20,1)[0]==frame['active_raw'],n
 assert rng_state()==frame['rng'] and random_calls==frame['draws'],n;draws+=random_calls
 original=list(struct.unpack('<16I',u.mem_read(camera,64)));actual=frame['output_camera_bits'];assert original[3:]==actual[3:],n
 for i in range(3):
  expected=struct.unpack('<f',struct.pack('<I',original[i]))[0];value=struct.unpack('<f',struct.pack('<I',actual[i]))[0];error=abs(value-expected);max_error=max(max_error,error)
  assert error<=max(1e-5,abs(expected)*2e-7),(n,i,value,expected)
 if actual[:3]!=frame['initial_camera_bits'][:3]:moved+=1
assert draws>0 and moved>100
proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'trace_sha256':hashlib.sha256(trace_path.read_bytes()).hexdigest(),'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'frames':len(frames),'rng_draws':draws,'moved_frames':moved,'max_absolute_eye_error_native_units':max_error,'passed':True,'native_triggers_complete':False,'complete':False,'limits':['Actual Vulkan client diagnostic inputs replayed through full original7D2BE0 and actual RNG8E26A0 seeded by original8E2630. No shake/RNG math adapters.','Every captured shake state, raw active byte, RNG55word state/index and draw count matches native exactly; only camera-eye normalization permits1e-5abs/2e-7relative.','Explicit diagnostic event/seed; original spell/effect trigger routing, shared RNG seed/call ordering across other systems and full camera fidelity remain incomplete.']}
(r/'docs/native_camera_shake_live_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
