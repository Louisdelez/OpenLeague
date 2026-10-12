"""Bounded original persistent-release fragments; not full particle destruction."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes()
assert hashlib.sha256(raw).hexdigest()=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
heap=0x30000000;stack=0x31000000;tramp=0x32000000
for a in [heap,stack,tramp]:u.mem_map(a,0x10000)
u.mem_write(tramp,b'\xc3');calls=[]
def hook(uc,a,size,user):
 if a==tramp:
  sp=u.reg_read(UC_X86_REG_ESP);target,key=struct.unpack('<II',u.mem_read(sp,8));calls.append(key)
  assert u.reg_read(UC_X86_REG_ECX)==heap+0x404
  u.reg_write(UC_X86_REG_ESP,sp+8);u.reg_write(UC_X86_REG_EIP,target);return
 assert 0x93e588<=a<0x93e5c8 or 0x93e6fb<=a<0x93e73b,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for start,end in [(0x93e588,0x93e5c8),(0x93e6fb,0x93e73b)]:
 for primary in [-1,0,1,-2147483648]:
  for secondary in [-1,0,1,-2147483648]:
   u.mem_write(heap,b'\0'*0x10000);u.mem_write(heap,struct.pack('<I',heap+0x400));u.mem_write(heap+0x404,struct.pack('<I',heap+0x500));u.mem_write(heap+0x520,struct.pack('<I',tramp));u.mem_write(heap+0x1ac,struct.pack('<ii',primary,secondary))
   calls.clear()
   for repeat in range(2):
    u.reg_write(UC_X86_REG_ESP,stack+0x8000);u.reg_write(UC_X86_REG_ESI,heap);u.emu_start(start,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
   expected=[x&0xffffffff for x in [primary,secondary] if x!=-1];assert calls==expected
   handles=list(struct.unpack('<ii',u.mem_read(heap+0x1ac,8)));assert handles==[-1,-1]
   cases.append({'start':hex(start),'primary':primary,'secondary':secondary,'release_calls':list(calls),'final_handles':handles,'repeats':2})
result={'passed':True,'cases':cases,'native_sha256':hashlib.sha256(raw).hexdigest(),'limits':['Original93E588..93E5C8 cleanup and93E6FB..93E73B reset release fragments executed; surrounding full particle cleanup/reset excluded.','Virtual+0x20 callback adapted to record keys; its actual native release queue separately qualified.','Secondary persistent field tested in native fragments; absent from five ambient particle configurations.','Animation event-end callback5B5440 only marks emitter +124/+12C; full lifecycle timing before destructor remains unqualified.'],'complete':False}
(r/'data/4.20/audio_particle_release_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Original persistent-release32 cases/64 fragment runs passed')
