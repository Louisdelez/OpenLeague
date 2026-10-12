"""Original7074E0 weak association and5BD6F0 lock, native ownership operations."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [0,heap,stack,end]:u.mem_map(a,0x10000)
obj=heap;voice=heap+0x100;control=heap+0x200;array=heap+0x1000;vt=heap+0x400;out=heap+0x600;calls=[]
for a in [end+0x100,end+0x200]:u.mem_write(a,b'\xc3')
u.mem_write(vt,struct.pack('<II',end+0x100,end+0x200))
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def ret():
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0];u.reg_write(UC_X86_REG_ESP,sp+4);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 if a in [end+0x100,end+0x200]:
  assert u.reg_read(UC_X86_REG_ECX)==control;calls.append('destroy_voice' if a==end+0x100 else 'free_control');ret();return
 assert any(s<=a<e for s,e in [(0x7074e0,0x7075a3),(0x707f20,0x707f89),(0x5bde40,0x5bdea0),(0x5bd6f0,0x5bd72c),(0x5ec2a0,0x5ec2cb),(0x5ccf80,0x5ccfd7),(0x5bd3c0,0x5bd3f3)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for present,has_control,strong,weak,prior in itertools.product([False,True],[False,True],[1,2,3],[1,3],[0,2]):
 put(obj+0x1c,'3I',array,array+prior*8,array+0x100);put(control,'4I',vt,strong,weak,voice if present else 0)
 sp=stack+0x8000;put(sp,'3I',end,voice if present else 0,control if has_control else 0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);calls.clear();u.emu_start(0x7074e0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 count=(read(obj+0x20,'I')[0]-array)//8;assert count==prior+int(present)
 after_strong=strong-1 if has_control else None;after_weak=weak+int(present)-int(strong==1) if has_control else None
 if has_control:assert read(control+4,'2I')==(after_strong,after_weak)
 expected_calls=['destroy_voice'] if has_control and strong==1 else []
 if has_control and after_weak==0:expected_calls.append('free_control')
 assert calls==expected_calls
 locked=False
 if present:
  assert read(array+prior*8,'2I')==(voice,control if has_control else 0)
  entry=array+prior*8;sp=stack+0x8000;put(sp,'2I',end,out);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,entry);u.emu_start(0x5bd6f0,end,count=10000)
  locked=has_control and after_strong>0;assert read(out,'2I')==((voice,control) if locked else (0,0))
  if locked:
   assert read(control+4,'I')[0]==after_strong+1
   sp=stack+0x8000;put(sp,'I',end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,out);u.emu_start(0x5bd3c0,end,count=10000);assert read(control+4,'I')[0]==after_strong
 cases.append({'voice_present':present,'control_present':has_control,'strong_before':strong,'weak_before':weak,'prior_entries':prior,'entries_after':count,'strong_after':after_strong,'weak_after':after_weak,'locked':locked,'calls':list(calls)})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Actual7074E0 association/707F20 append/5BDE40 weak copy and5BD6F0/5EC2A0 weak lock executed with existing vector capacity.','Association consumes its passed strong reference and retains a weak entry only for non-null voice. Null control entries cannot lock. Expired references never resurrect.','Control virtual0/4 destruction/free recorded as adapters; underlying voice stop/disposal not executed. Weak vector growth excluded.','Replaces earlier705A10 association adapter assumption that object retained a strong owner; actual object association retains weak ownership.'],'complete':False}
(r/'data/4.20/audio_object_association_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original weak association/lock',len(cases),'cases passed')
