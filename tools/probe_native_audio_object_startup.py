"""Original factory from untouched PE startup counter and zero-filled globals."""
from pathlib import Path
import json,hashlib,struct
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py')
exec(compile(Path(__file__).read_text().split('orientation=')[0],'factory setup','exec'))
initial_counter=read(0x1224d20,'I')[0];initial_vector=list(read(0x2d773b4,'3I'))
assert initial_counter==2 and initial_vector==[0,0,0]
# Setup supplies engine readiness and heap/storage adapters, not startup globals.
put(0x2d77b20,'B',1);put(0x14bef58,'I',0)
rows=[]
for failure,enabled in [(False,True),(True,True),(False,True),(False,False),(False,True)]:
 wrapper_fail=failure;available=enabled;packets.clear();calls.clear();u.mem_write(wrapper,b'\xa5'*40)
 before=read(0x1224d20,'I')[0];result=invoke(0x7055d0,[],manager)
 row=dict(counter_before=before,allocation_failed=failure,engine_available=enabled,result_present=result!=0,next_counter=read(0x1224d20,'I')[0],packets=packets.copy())
 if result:row['object_id']=read(wrapper+4,'I')[0];row['cached_vector_words']=list(read(wrapper+8,'3I'))
 assert row['next_counter']==before+1
 if result:assert row['object_id']==before and row['cached_vector_words']==initial_vector
 rows.append(row)
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),counter_address='0x1224d20',counter_image_bytes=p.get_data(0x1224d20-base,4).hex(),counter_initial=initial_counter,cached_vector_address='0x2d773b4',cached_vector_initial_words=initial_vector,cases=rows,adapters=['Factory heap, engine availability, map insertion and registration queue adapters inherited from qualified factory probe.','No writes to counter or cached-vector globals before calls.'],limits=['Image startup state, not a claim that every game/audio subsystem has made zero allocations before ambient events.','Cached vector startup is zero-filled data; later runtime writes are not qualified by this test.','No physical playback or voice admission.'])
(r/'data/4.20/audio_object_startup_contract.json').write_text(json.dumps(proof,indent=2),encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(rows),counter_initial=initial_counter,cached_vector_initial_words=initial_vector)))
