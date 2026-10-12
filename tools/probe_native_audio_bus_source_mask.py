"""Original Bus virtualDC B041B0 source mask update, including unmasked input bits."""
from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;source=heap+0x2000;regions=[(0xb041b0,0xb041cc)]
def guard(uc,a,n,d):assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for present,flags,value,mask in itertools.product([False,True],[0,1,2,31,0xa5,0xff],[0,1,2,16,31,0xffffffff],[0,1,2,16,31,255,0xffffffff,0x100]):
 u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+0x14,'I',source if present else 0);u.mem_write(source,b'\xa5'*20);u.mem_write(source+0x10,bytes([flags]));before=bytes(u.mem_read(node,200)).hex();before_source=bytes(u.mem_read(source,20)).hex();sp=stack+0x8000;put(sp,'III',trap,value,mask);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb041b0,trap,count=1000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'present':present,'flags':flags,'value':value,'mask':mask,'before':before,'after':bytes(u.mem_read(node,200)).hex(),'before_source':before_source,'after_source':bytes(u.mem_read(source,20)).hex()})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual B041B0 executes with no result adapter, valid explicit source14 or absent pointer. Source byte10 update preserves other bytes.'],'findings':['Source flag formula is (old & ~low8(mask)) | low8(value), unlike cache setter which also masks the value. Input value bits outside mask are retained.'],'limits':['Preparatory source callback evidence; Rust callback and shared storage integration pending.','Remaining virtualCC/84, normal source construction/lifetime and signal processing remain open.']}
(r/'data/4.20/audio_bus_source_mask_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus source mask callback cases')
