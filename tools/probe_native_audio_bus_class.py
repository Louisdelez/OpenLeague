"""HIRC8 dispatch -> original bus factory/constructors and real vtable/class getter."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path(__file__).resolve().parents[1];__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
manager=heap+0x1000;bank=heap+0x2000;payload=heap+0x3000;obj=heap+0x4000;array=heap+0x6000
assert read(0xafb8dc+7*4,'I')[0]==0xafb792
assert p.get_data(0xafb799-base,1)==b'\xe8' and 0xafb79e+read(0xafb79a,'i')[0]==0xafbd40
assert p.get_data(0xafbd9e-base,1)==b'\xe8' and 0xafbda3+read(0xafbd9f,'i')[0]==0xb02680
loader=read(0xff1380+0x144,'I')[0];regions=[(0xafb630,0xafb8dc),(0xafbd40,0xafbe1b),(0xb02680,0xb026cc),(0xb02080,0xb02146),(0xafdd70,0xafddd8),(0xafd490,0xafd4ac),(0x5eb4b0,0x5eb4b6)]
put(0xfa4424,'I',trap+0x100);put(0xfa4428,'I',trap+0x200);calls=[];headers=[];failure=False

def hook(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaf7900:
  dest,size=read(sp+4,'II');raw=headers.pop(0);assert size==len(raw);u.mem_write(dest,raw);calls.append({'kind':'read','bytes':raw.hex()});ret(1,8);return
 if a==0xaff610:
  put(bank+0x34,'III',array,0,4);calls.append({'kind':'reserve'});ret(1,4);return
 if a==0xaf7940:assert read(sp+4,'I')[0]==4;ret(payload,4);return
 if a==0xaf6480:
  id,selector=read(sp+4,'II');assert selector==1;calls.append({'kind':'lookup','id':id,'selector':selector});ret(0,8);return
 if a==0xb02640:ret(0,0);return
 if a in [trap+0x100,trap+0x200]:ret(0,4);return
 if a==0xada670:
  size=read(sp+8,'I')[0];assert size==0xc8;calls.append({'kind':'allocate','size':size});ret(0 if failure else obj,0);return
 if a==0xb03530:calls.append({'kind':'initialize_interface'});ret(1,0);return
 if a==loader:
  data,size=read(sp+4,'II');assert data==payload and size==4;calls.append({'kind':'bank_loader_interface','entry':loader});ret(1,8);return
 if a==0xaf7a40:ret(0,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for ident,failure in itertools.product([0,1,1234,0x80000000,0xffffffff],[False,True]):
 u.mem_write(heap,bytes(0x7000));u.mem_write(obj,b'\xa5'*0xc8);put(payload,'I',ident);headers=[struct.pack('<I',1),struct.pack('<BI',8,4)];calls.clear();sp=stack+0x8000;put(sp,'III',trap,bank,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xafb630,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap and not headers
 result=u.reg_read(UC_X86_REG_EAX);assert result==(2 if failure else 1);snapshot=None;class_value=None
 if not failure:
  assert read(obj,'I')[0]==0xff1380 and read(obj+8,'I')[0]==ident;assert read(bank+0x38,'I')[0]==1 and read(array,'I')[0]==obj;assert read(0xff1380+0xa8,'I')[0]==0xb02a70
  snapshot=bytes(u.mem_read(obj,0xc8)).hex();put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(read(0xff1380+0x134,'I')[0],trap,count=10);class_value=u.reg_read(UC_X86_REG_EAX);assert class_value==1
 rows.append({'id':ident,'allocation_failure':failure,'result':result,'snapshot':snapshot,'class':class_value,'calls':calls.copy()})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'hirc_type':8,'dispatch':'0xafb792','handler':'0xafbd40','factory':'0xb02680','constructor':'0xb02080','vtable':'0xff1380','actor_entry':'0xb02a70','bank_loader':hex(loader),'class_getter':hex(read(0xff1380+0x134,'I')[0]),'class_value':1,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Only reader/payload/reserve/lookup/allocator/OS lock/unlock/init and bank-loader interfaces supplied. Original HIRC dispatcher8, handler, factory, bus/base constructors and class getter execute unchanged.','Original constructor sets FF1380; its actual A8=B02A70 and134 class1 proved from the bank type8 path. No guessed vtable class result.'],'limits':['Initialization B03530 and bank loader virtual144 are result interfaces, not qualified bodies. Bank resource registration, full bus actor/state/RTPC consumers and runtime ownership remain open.']}
(r/'data/4.20/audio_bus_class_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'HIRC8 native bus factory/constructor cases; FF1380 A8=B02A70 class1')
