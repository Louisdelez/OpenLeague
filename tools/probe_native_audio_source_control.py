"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;array=heap+0x2000;sources=[heap+0x6000+i*0x100 for i in range(3)];out=heap+0x3000
u.mem_write(trap+0x100,b'\xd9\x1d'+struct.pack('<I',out)+b'\xe9'+struct.pack('<i',trap-(trap+0x10b)))
regions=[(0xb1caf0,0xb1cb24),(trap+0x100,trap+0x10b)]
def guard(uc,a,n,d):assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
rows=[]
for count in [1,3]:
 for selected in range(count):
  for bits in [0xc1f80000,0,0x80000000,0x41560000,0xc1520000,0x7f7fffff]:
   u.mem_write(node,bytes(0x100));put(node+0x58,'II',array,count);entries=[]
   for i in range(count):
    put(array+i*8,'II',101+i,sources[i]);value=bits if i==selected else 0x3f800000+i;put(sources[i]+0x20,'I',value);entries.append({'id':101+i,'source':sources[i],'value_bits':value})
   sp=stack+0x8000;put(sp,'II',trap+0x100,sources[selected]);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb1caf0,trap,count=1000);assert u.reg_read(UC_X86_REG_EIP)==trap and read(out,'I')[0]==bits
   rows.append({'entries':entries,'source':sources[selected],'result_bits':read(out,'I')[0]})
proof={'complete':False,'passed':True,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions if a<trap],'adapters':['Original B1CAF0 searches node58/5C eight-byte source entries and loads selected source field20 unchanged. Trampoline only stores the x87 return as f32. No source result adapter.'],'limits':['Valid matching source pointer only. Original missing-match path reads beyond the array; safe Rust must reject unresolved sources explicitly.','Preparatory native evidence; normal bank/source binding and physical/device output remain open.']}
(r/'data/4.20/audio_source_control_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native source pointer lookup cases')
