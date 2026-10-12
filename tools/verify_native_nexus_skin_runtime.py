from pathlib import Path
import os,json,struct
r=Path('E:/OpenLeague');trace=r/'logs/native-nexus-skin-runtime.jsonl';animation=r/'logs/native-nexus-skin-animation.jsonl'
assert not trace.exists() and not animation.exists()
os.environ['OPENLEAGUE_NEXUS_SKIN_PROBE']=str(trace)
os.environ['OPENLEAGUE_DESTRUCTION_ANIMATION_PROBE']=str(animation)
s=Path('E:/mapslol3v3/verify_results_framebuffer.py').read_text(encoding='utf-8').replace('match-results-visual','native-nexus-skin').replace('match_results_visual_validation.json','native_nexus_skin_visual_validation.json');exec(compile(s,'native-nexus-skin-runtime','exec'))
rows=[json.loads(line) for line in trace.read_text().splitlines()];assert len(rows)>30
before=[row for row in rows if row['age']<3.5];after=[row for row in rows if row['age']>=3.5]
assert before and after;assert all(row['destroyed'] is False for row in before),before[:3]
assert all(row['destroyed'] is True for row in after),after[:3]
loaded_before=[row for row in before if row['loaded_model']];loaded_after=[row for row in after if row['loaded_model']]
assert loaded_before and loaded_after
assert all(not row['loaded_model'].endswith('_destroyed') for row in loaded_before)
assert all(row['loaded_model'].endswith('_destroyed') for row in loaded_after)
first=after[0];assert 3.5<=first['age']<3.8
assert len({row['tick'] for row in rows})==1
assert len({row['entity'] for row in before})==1 and len({row['entity'] for row in after})==1
assert before[0]['entity']!=after[0]['entity']
clips=[json.loads(line) for line in animation.read_text().splitlines()]
actors=[actor for row in clips for actor in row['actors'] if actor['id']==rows[0]['id']]
assert actors and all(actor['role']=='idle' for actor in actors)
assert any(actor['model'].endswith('_destroyed') for actor in actors)
ns={};prefix=Path('E:/mapslol3v3/qualify_native_camera_pan.py').read_text(encoding='utf-8').split('cases=[]')[0];exec(compile(prefix,'native-pan-current-nexus-build','exec'),ns)
u=ns['u'];write=ns['write'];floats=ns['floats'];call=ns['call'];errors=[]
for row in rows:
 assert row['pan_current'] is not None
 ns['allocator'][0]=0x3200000;u.mem_write(ns['camera'],bytes(512));u.mem_write(ns['vector'],bytes(32));write(ns['controller']+4,ns['vector'],ns['vector'],ns['vector']+16);floats(ns['source'],row['pan_initial']);floats(ns['target'],row['pan_target']);floats(0x2d78dfc,[row['pan_started']]);call(0x565e00,[ns['source'],ns['target'],struct.unpack('<I',struct.pack('<f',3.))[0],1,0]);floats(0x2d78dfc,[row['pan_now']]);call(0x5663b0,[])
 actual=bytes(u.mem_read(ns['camera']+0x104,12));assert actual==struct.pack('<3f',*row['pan_current']),row
 native=struct.unpack('<3f',actual);observed=row['native_render_focus'];error=max(abs(native[i]-observed[i]) for i in [0,2]);assert error<0.01,(error,row);assert observed[1]==0.;errors.append(error)
p=r/'docs/native_nexus_skin_visual_validation.json';d=json.loads(p.read_text());d.update(runtime_samples=len(rows),first_swap_age=first['age'],frozen_tick=rows[0]['tick'],single_entity_replacement=True,native_nexus_idle_actor_observations=len(actors),native_camera_bit_exact_samples=len(rows),max_render_focus_error_native_units=max(errors),probe=str(trace),animation_probe=str(animation),visual_inspected=False);p.write_text(json.dumps(d,indent=2),encoding='utf-8');print(json.dumps(d))
