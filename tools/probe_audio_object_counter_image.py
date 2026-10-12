"""Exercise native audio factory using its executable-image counter value."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_audio_object_registration.py').read_text().split('orientation=[0x3f000000')[0],'registration_setup','exec'))
initial=read(0x1224d20,'I')[0]
assert initial==2
orientation=[0x3f000000,0xbf400000,0x3f800000]
rows=[]
for expected in [2,3,4]:
 u.mem_write(heap,b'\0'*0x6000);put(0x2d77b20,'B',1);put(0x14bef58,'I',0)
 put(0x2d773b4,'3I',*orientation);packets.clear();calls.clear()
 result=invoke(0x7055d0,[],manager)
 assert result==wrapper and read(wrapper+4,'I')[0]==expected
 assert read(0x1224d20,'I')[0]==expected+1
 assert packets==[{'type':11,'object_id':expected,'listener_mask':1,'extra_raw':0}]
 rows.append({'object_id':expected,'next_counter':expected+1,'packets':packets.copy()})
refs=[]
needle=struct.pack('<I',0x1224d20)
for sec in p.sections:
 if not sec.Characteristics&0x20000000:continue
 data=sec.get_data();start=0
 while True:
  at=data.find(needle,start)
  if at<0:break
  refs.append(hex(base+sec.VirtualAddress+at));start=at+4
assert refs==['0x70565c','0x7070aa']
proof={'passed':True,'native_sha256':hashlib.sha256(b).hexdigest(),'counter_address':'0x1224d20','image_initial_value':initial,'absolute_operand_candidates':refs,'sequences':rows,'limits':['Uses executable image state, not a captured fully initialized game process.','Absolute operand scan does not exclude indirect writes.','Allocator, wrapper index insertion, availability and command enqueue are adapted by the existing registration harness.','Orientation supplied explicitly; startup orientation and client runtime integration remain open.']}
(r/'data/4.20/audio_object_counter_image.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(proof))
