"""Replay actual client orientation traces through full original6AB380."""
from pathlib import Path
import json,struct,math,hashlib,datetime,argparse
parser=argparse.ArgumentParser();parser.add_argument("--trace",default="logs/native-entity-yaw-live.json");parser.add_argument("--output",default="docs/native_entity_yaw_live_validation.json");args=parser.parse_args()
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_entity_yaw.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
trace=r/args.trace;doc=json.loads(trace.read_text());rows=doc['frames'];assert len(rows)==128
errors=[]
for row in rows:
 u.mem_write(frame,b'\x00'*76);u.mem_write(vector,struct.pack('<3I',*row['direction_bits']));run(0x6ab380,[vector],frame)
 actual=list(struct.unpack('<16I',u.mem_read(frame,64)));assert actual==row['matrix_bits']
 expected=[struct.unpack('<f',struct.pack('<I',b))[0] for b in actual[8:11]];length=math.sqrt(sum(v*v for v in expected));expected=[v/length for v in expected]
 x,y,z,w=row['render_quaternion'];render=[2*(x*z+y*w),2*(y*z-x*w),1-2*(x*x+y*y)];error=math.sqrt(sum((a-b)**2 for a,b in zip(expected,render)));assert error<2e-6;errors.append(error)
proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'trace_sha256':hashlib.sha256(trace.read_bytes()).hexdigest(),'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'frames':len(rows),'native_matrices_bit_exact':True,'maximum_render_forward_error':max(errors),'passed':True,'complete':False,'limits':['Actual client motion inputs replayed through full native6AB380/6BD9F0 without math adapters. Quaternion conversion checked independently against original matrixforward.','Snapshot displacement direction is reconstructed; original movement direction/cadence not yet qualified. Quantized matrix to normalizedBevy quaternion bridge has tinybasis error, not GPU pixel equivalence.','Actual motion trace validated independently; scripted player-driver acceptance failed and is not claimed. No six-client gameplay acceptance.']}
(r/args.output).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Actual client yaw validated:',len(rows),'updates;maxforwarderror',max(errors))
