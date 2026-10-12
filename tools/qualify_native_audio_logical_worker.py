"""Original persistent creation/store and release/erase worker fragments."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest()
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
heap=0x30000000;stack=0x31000000;tramp=0x32000000
for a in [heap,stack,tramp]:u.mem_map(a,0x10000)
node=heap+0x1000;record=node+0x14;manager=heap;sp=stack+0x8000;calls=[];answer=0
for slot in [0x18,0x24]:u.mem_write(tramp+slot,b'\xc3')
def ret(value=None,pop=0):
 s=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(s,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value&0xffffffff)
 u.reg_write(UC_X86_REG_ESP,s+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 s=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x564af0:
  src=struct.unpack('<I',u.mem_read(s+4,4))[0];u.mem_write(ecx,bytes(u.mem_read(src,24)));ret(pop=12);return
 if a==tramp+0x18:
  string,actor,pos,age=struct.unpack('<IIII',u.mem_read(s+4,16));length=struct.unpack('<I',u.mem_read(string+16,4))[0]
  calls.append({'kind':'create','event':bytes(u.mem_read(string,length)).decode(),'actor_id':actor,'position_bits':list(struct.unpack('<III',u.mem_read(pos,12))),'age_bits':age});ret(answer,16);return
 if a==tramp+0x24:
  backend=struct.unpack('<I',u.mem_read(s+4,4))[0];calls.append({'kind':'release','backend_reference_raw':backend});ret(pop=4);return
 if a==0x946c70:
  ptr=struct.unpack('<I',u.mem_read(s+4,4))[0];key=struct.unpack('<I',u.mem_read(ptr,4))[0];assert key==logical
  calls.append({'kind':'store','logical_id':key});ret(record,4);return
 if a==0x5c4680:
  out,entry=struct.unpack('<II',u.mem_read(s+4,8));assert entry==node
  calls.append({'kind':'erase','logical_id':logical});ret(pop=8);return
 assert 0x921600<=a<0x9217b9 or 0x921c31<=a<0x921cea,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for logical in [1,0xffffffff]:
 for actor in [0,7]:
  for answer in [-1,0,123]:
   for position in [[1.,2.,3.],[-50.,-0.,15000.]]:
    for age in [-.5,0.,2.]:
     u.mem_write(heap,b'\0'*0x10000);u.mem_write(stack,b'\0'*0x10000)
     u.mem_write(manager,struct.pack('<I',heap+0x400));u.mem_write(heap+0x400,struct.pack('<I',heap+0x500))
     for slot in [0x18,0x24]:u.mem_write(heap+0x500+slot,struct.pack('<I',tramp+slot))
     u.mem_write(node+0x10,struct.pack('<II',logical,0xffffffff));u.mem_write(node+0x18,b'event\0'+b'\0'*10+struct.pack('<II',5,15))
     u.mem_write(node+0x30,struct.pack('<IIfff',actor,0,*position));u.mem_write(node+0x44,b'\0');u.mem_write(node+0x48,struct.pack('<f',age))
     original=bytes(u.mem_read(record,56));calls.clear()
     for start,end,register in [(0x921600,0x9217b9,UC_X86_REG_EDI),(0x921c31,0x921cea,UC_X86_REG_ESI)]:
      u.mem_write(sp+0x14,struct.pack('<II',manager,manager+0x30));u.mem_write(sp+0x38,struct.pack('<I',logical))
      u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(register,node);u.emu_start(start,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
     updated=bytes(u.mem_read(record,56));assert struct.unpack('<i',updated[:4])[0]==answer and updated[4:]==original[4:]
     assert calls[1]=={'kind':'store','logical_id':logical} and calls[2]=={'kind':'release','backend_reference_raw':answer&0xffffffff} and calls[3]=={'kind':'erase','logical_id':logical}
     assert calls[0]['actor_id']==actor and calls[0]['event']=='event'
     assert calls[0]['position_bits']==list(struct.unpack('<III',struct.pack('<fff',*position))) and calls[0]['age_bits']==struct.unpack('<I',struct.pack('<f',age))[0]
     cases.append({'logical_id':logical,'actor_id':actor,'backend_return':answer,'calls':list(calls),'stored_backend':struct.unpack('<i',updated[:4])[0]})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Bounded921600..9217B9 create/store and921C31..921CEA release/erase fragments only. Surrounding lookup loops, queue clearing, boolean/position update and full lock ownership not executed.','String descriptor copy, map store lookup and erase adapted. Backend virtual+18/+24 callbacks return/record controlled raw references; no actual voice creation or audibility.','SSO string fixture event used; original long-string destruction excluded.'],'complete':False}
(r/'data/4.20/audio_logical_worker_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original logical worker72 sequences/144 fragments passed')
