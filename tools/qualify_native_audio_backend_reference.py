"""Original6CE0E0 backend reference registration; actual voice factory adapted."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000;u.mem_map(0,4096)
for a in [heap,stack,end]:u.mem_map(a,0x10000)
manager=heap;entry=heap+0x1000;voice=heap+0x2000;control=heap+0x2100;actor_object=heap+0x3000;events=[]
u.mem_write(end+0x30,b'\xc3')
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value&0xffffffff)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==end+0x30:
  key=struct.unpack('<I',u.mem_read(sp+4,4))[0];events.append({'kind':'resolve_actor','actor_id':key});ret(actor_object if resolved else 0,4);return
 if a==0x6f79d0:
  args=list(struct.unpack('<IIIII',u.mem_read(sp+4,20)));assert u.reg_read(UC_X86_REG_EDX)==heap+0x4000
  assert args==[actor_object if actor and resolved else 0,heap+0x4100,1,0,struct.unpack('<I',struct.pack('<f',-.5))[0]]
  events.append({'kind':'create_voice','actor_resolved':bool(actor and resolved),'position_bits':[0x3f800000,0x40000000,0x40400000],'age_bits':args[-1]})
  u.mem_write(ecx,struct.pack('<II',voice if success else 0,control if success else 0));ret(ecx);return
 if a==0x6e3300:
  ptr=struct.unpack('<I',u.mem_read(sp+4,4))[0];key=struct.unpack('<I',u.mem_read(ptr,4))[0];assert key==seed
  events.append({'kind':'map_entry','key':key});ret(entry,4);return
 if a==0x64b870:
  ptr=struct.unpack('<I',u.mem_read(sp+4,4))[0];v,ctrl=struct.unpack('<II',u.mem_read(ptr,8));assert v==voice and ctrl==control
  u.mem_write(ecx,struct.pack('<II',v,ctrl));count=struct.unpack('<I',u.mem_read(ctrl+4,4))[0];u.mem_write(ctrl+4,struct.pack('<I',count+1));ret(ecx,4);return
 if a in [0x5642d0]:events.append({'kind':'log_failure'});ret();return
 assert 0x6ce0e0<=a<0x6ce1f8,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for seed,actor,resolved,success,refs in itertools.product([0,1,0xffffffff],[0,7],[False,True],[False,True],[1,2]):
 u.mem_write(heap,b'\0'*0x10000);u.mem_write(stack,b'\0'*0x10000);u.mem_write(0,b'\0'*4)
 u.mem_write(manager+0xc,struct.pack('<I',seed));u.mem_write(control+4,struct.pack('<I',refs));u.mem_write(heap+0x4000,b'event\0'+b'\0'*10+struct.pack('<II',5,15));u.mem_write(heap+0x4100,struct.pack('<fff',1.,2.,3.))
 u.mem_write(0x2d78b98,struct.pack('<I',heap+0x5000));u.mem_write(heap+0x5000,struct.pack('<I',heap+0x5100));u.mem_write(heap+0x5130,struct.pack('<I',end+0x30))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<IIIIf',end,heap+0x4000,actor,heap+0x4100,-.5));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);events.clear();u.emu_start(0x6ce0e0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 handle=u.reg_read(UC_X86_REG_EAX);counter=struct.unpack('<I',u.mem_read(manager+0xc,4))[0];bound=struct.unpack('<I',u.mem_read(entry+8,4))[0];strong=struct.unpack('<I',u.mem_read(control+4,4))[0]
 assert handle==(seed if success else 0xffffffff) and counter==((seed+1)&0xffffffff if success else seed)
 assert bound==(actor if success and resolved else 0) and strong==refs
 assert sum(x['kind']=='map_entry' for x in events)==int(success)
 cases.append({'counter':seed,'actor_id':actor,'actor_resolved':resolved,'voice_created':success,'initial_strong':refs,'returned_raw':handle,'next_counter':counter,'retained_actor':bound,'final_strong':strong,'events':list(events)})
proof={'passed':True,'cases':cases,'native_sha256':digest,'native_interface':'10A48E4+18->6CE0E0; factory6F79D0->10AF384+40->705A10','limits':['Original6CE0E0 wrapper runs; actor lookup, actual shared voice creation6F79D0, map insertion, shared assignment and logging explicitly adapted.','Shared assignment adapter increments strong reference; original wrapper atomic decrement executed. Full shared-control destructor/map overwrite lifetime excluded.','Actual physical voice factory and Wwise playback still unqualified here. Counter initial constructor seed not qualified; explicit restore state only.'],'complete':False}
(r/'data/4.20/audio_backend_reference_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original backend reference',len(cases),'cases passed')
