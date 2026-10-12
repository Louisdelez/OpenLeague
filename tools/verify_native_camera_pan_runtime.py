from pathlib import Path
import os,json,struct
r=Path('E:/OpenLeague');trace=r/'logs/endgame-camera-pan-runtime.jsonl';assert not trace.exists()
os.environ['OPENLEAGUE_ENDGAME_PHASE_PROBE']='1'
s=Path('E:/mapslol3v3/verify_results_framebuffer.py').read_text(encoding='utf-8').replace('match-results-visual','native-camera-pan').replace('match_results_visual_validation.json','native_camera_pan_visual_validation.json');exec(compile(s,'native-camera-pan-runtime','exec'))
rows=[json.loads(line) for line in trace.read_text().splitlines()];assert len(rows)>30
assert all(row['pan_current'] is not None for row in rows)
assert any(not row['pan_finished'] for row in rows);assert any(row['pan_finished'] for row in rows)
ns={};prefix=Path('E:/mapslol3v3/qualify_native_camera_pan.py').read_text(encoding='utf-8').split('cases=[]')[0];exec(compile(prefix,'native-pan-observation-comparison','exec'),ns)
u=ns['u'];write=ns['write'];floats=ns['floats'];call=ns['call'];errors=[]
for row in rows:
 ns['allocator'][0]=0x3200000;u.mem_write(ns['camera'],bytes(512));u.mem_write(ns['vector'],bytes(32));write(ns['controller']+4,ns['vector'],ns['vector'],ns['vector']+16);floats(ns['source'],row['pan_initial']);floats(ns['target'],row['pan_target']);floats(0x2d78dfc,[row['pan_started']]);call(0x565e00,[ns['source'],ns['target'],struct.unpack('<I',struct.pack('<f',3.))[0],1,0]);floats(0x2d78dfc,[row['pan_now']]);call(0x5663b0,[])
 actual=bytes(u.mem_read(ns['camera']+0x104,12));assert actual==struct.pack('<3f',*row['pan_current']),row
 native=struct.unpack('<3f',actual);observed=row['native_render_focus'];error=max(abs(native[i]-observed[i]) for i in [0,2]);assert error<0.01,(error,row);assert observed[1]==0.;errors.append(error)
assert all(not row['splash_visible'] for row in rows if row['age']<5.5)
finished=next(row for row in rows if row['pan_finished']);assert 3.<=finished['age']<3.4
assert len(set(struct.pack('<3f',*row['pan_current']) for row in rows if row['pan_finished']))==1
p=r/'docs/native_camera_pan_visual_validation.json';d=json.loads(p.read_text());d.update(runtime_samples=len(rows),native_controller_bit_exact_samples=len(rows),max_render_focus_error_native_units=max(errors),first_finished_age=finished['age'],stable_endpoint=True,probe=str(trace),visual_inspected=False);p.write_text(json.dumps(d,indent=2),encoding='utf-8');print(json.dumps(d))
