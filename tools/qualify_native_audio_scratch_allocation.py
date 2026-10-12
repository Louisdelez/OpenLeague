"""Original706600 scratch allocation/registration; factory and allocator adapted."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [heap,stack,end]:u.mem_map(a,0x10000)
engine=heap;obj=heap+0x1000;scratch=heap+0x2000;array=heap+0x3000;linked=heap+0x4000;calls=[]
u.mem_write(end+0x100,b'\xc3')
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==end+0x100:calls.append('object_factory');ret(obj if object_ok else 0);return
 if a==0x5b47e0:calls.append('initialize_scratch_subsystem');ret();return
 if a==0xc9f39b:
  assert struct.unpack('<I',u.mem_read(sp+4,4))[0]==16;calls.append('allocate_scratch16');ret(scratch if scratch_ok else 0);return
 assert 0x706600<=a<0x70669d or 0x5bdc40<=a<0x5bdd20,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for object_ok,scratch_ok,has_link,initialized in itertools.product([False,True],repeat=4):
 u.mem_write(heap,b'\0'*0x10000);u.mem_write(engine,struct.pack('<I',heap+0x5000));u.mem_write(heap+0x5028,struct.pack('<I',end+0x100));u.mem_write(engine+0x3c,struct.pack('<III',array,array,array+0x100));u.mem_write(scratch,b'\xa5'*16)
 u.mem_write(0x14bef58,b'\0'*4);u.mem_write(0x2d77b20,bytes([int(initialized)]))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,linked if has_link else 0));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,engine);calls.clear();u.emu_start(0x706600,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);finish=struct.unpack('<I',u.mem_read(engine+0x40,4))[0];registered=(finish-array)//4;success=object_ok and scratch_ok
 assert result==(scratch if success else 0) and registered==int(success)
 expected=['object_factory']
 if object_ok:
  if not initialized:expected.append('initialize_scratch_subsystem')
  expected.append('allocate_scratch16')
 assert calls==expected
 fields=None
 if success:
  o,owner,l=struct.unpack('<III',u.mem_read(scratch,12));retired=u.mem_read(scratch+12,1)[0];assert (o,owner,l,retired)==(obj,engine,linked if has_link else 0,0);assert struct.unpack('<I',u.mem_read(array,4))[0]==scratch
  fields={'object_present':True,'engine_preserved':True,'linked_present':has_link,'retired':retired}
 cases.append({'object_created':object_ok,'scratch_allocated':scratch_ok,'linked_present':has_link,'initialized_before':initialized,'initialized_after':bool(u.mem_read(0x2d77b20,1)[0]),'registered':success,'fields':fields,'calls':list(calls)})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Original706600 and native vector append5BDC40 executed with capacity. Game object factory, scratch heap allocator and once-only initializer adapted. Alternative configured allocator branch excluded.','When object creation succeeds but scratch allocation fails, original returns0 without object disposal. No invented rollback/release; native orphan ownership must remain explicit.','Actual factory object registration/resource cleanup and physical voice launch remain separate integration.'],'complete':False}
(r/'data/4.20/audio_scratch_allocation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original scratch allocation16 cases passed')
