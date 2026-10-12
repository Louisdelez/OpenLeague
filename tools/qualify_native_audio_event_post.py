"""Execute original706850 object event post/age seek; Wwise APIs adapted."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [heap,stack,end]:u.mem_map(a,0x10000)
obj=heap;string=heap+0x100;calls=[];answer=0
u.mem_write(obj,struct.pack('<I',heap+0x400));u.mem_write(heap+0x400,struct.pack('<I',0x7072f0))
def text_at(ptr):return bytes(u.mem_read(ptr,128)).split(b'\0',1)[0].decode('ascii')
def ret(value=None):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaea950:
  name,object_id,flags,callback,cookie,z1,z2,z3=struct.unpack('<8I',u.mem_read(sp+4,32));assert z1==z2==z3==0
  calls.append({'kind':'post','event':text_at(name),'object_id':object_id,'flags':flags,'callback_raw':callback,'cookie':cookie});ret(answer);return
 if a==0xaeb080:
  name,object_id,milliseconds,marker=struct.unpack('<4I',u.mem_read(sp+4,16));calls.append({'kind':'seek','event':text_at(name),'object_id':object_id,'milliseconds_raw':milliseconds,'nearest_marker_raw':marker});ret(1);return
 assert 0x706850<=a<0x706906 or 0x7072f0<=a<0x7072f4,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for name,object_id,cookie,answer,age in itertools.product(['','event','Play_sfx_Env_Map10_Emitter_brazierchain'],[0,123,0xffffffff],[0,0x30002000],[0,7],[0.,-0.,.0005,.5,-.5,2.,3000000.]):
 u.mem_write(string,b'\0'*24)
 if len(name)<16:u.mem_write(string,name.encode()+b'\0');capacity=15
 else:u.mem_write(heap+0x800,name.encode()+b'\0');u.mem_write(string,struct.pack('<I',heap+0x800));capacity=len(name)
 u.mem_write(string+16,struct.pack('<II',len(name),capacity));u.mem_write(obj+4,struct.pack('<I',object_id))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<IIIIIf',end,obj,string,0,cookie,age));u.reg_write(UC_X86_REG_ESP,sp);calls.clear();u.emu_start(0x706850,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);assert result==(answer if name else 0)
 if name:
  assert calls[0]=={'kind':'post','event':name,'object_id':object_id,'flags':5 if cookie else 0,'callback_raw':0x704a40 if cookie else 0,'cookie':cookie}
  assert len(calls)==1+int(answer!=0 and age!=0.)
 else:assert not calls
 cases.append({'event':name,'object_id':object_id,'cookie':cookie,'post_return':answer,'age_bits':struct.unpack('<I',struct.pack('<f',age))[0],'calls':list(calls),'result':result})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Original706850 and object ID getter7072F0 executed. Wwise PostEvent(AEA950) and Seek(AEB080) adapted to record arguments/return controlled playing ID; no queue packet worker or actual audio.','Both native SSO and heap event strings tested; allocation/real registry validation excluded.','Native age*1000 CVTTSS2SI includes negative and positive overflow. NaN/infinite age inputs not qualified. Callback704A40 target recorded but not executed.'],'complete':False}
(r/'data/4.20/audio_event_post_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original object event post',len(cases),'cases passed')
