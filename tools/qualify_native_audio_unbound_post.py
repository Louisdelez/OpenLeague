"""Original706910 unbound launch; allocation and Wwise calls adapted explicitly."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [heap,stack,end]:u.mem_map(a,0x10000)
engine=heap;obj=heap+0x100;string=heap+0x200;scratch=heap+0x300;linked=heap+0x400;position=heap+0x600;out=heap+0x700;calls=[]
for a in [end+0x100,end+0x200]:u.mem_write(a,b'\xc3')
u.mem_write(obj,struct.pack('<I',heap+0x800));u.mem_write(heap+0x800,struct.pack('<4I',0x7072f0,0,0,end+0x100));u.mem_write(obj+4,struct.pack('<I',123))
u.mem_write(linked,struct.pack('<I',heap+0x900));u.mem_write(heap+0x904,struct.pack('<I',end+0x200))
def text_at(ptr):return bytes(u.mem_read(ptr,128)).split(b'\0',1)[0].decode('ascii')
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x706600:
  assert u.reg_read(UC_X86_REG_ECX)==engine;assert struct.unpack('<I',u.mem_read(sp+4,4))[0]==0
  calls.append({'kind':'allocate'});ret(scratch if scratch_ok else 0,4);return
 if a==end+0x100:
  assert u.reg_read(UC_X86_REG_ECX)==obj
  ptr=struct.unpack('<I',u.mem_read(sp+4,4))[0]
  calls.append({'kind':'position','bits':list(struct.unpack('<3I',u.mem_read(ptr,12)))});ret(pop=4);return
 if a==end+0x200:
  assert u.reg_read(UC_X86_REG_ECX)==linked;calls.append({'kind':'linked_end'});ret();return
 if a==0xaea950:
  name,object_id,flags,callback,cookie,z1,z2,z3=struct.unpack('<8I',u.mem_read(sp+4,32));assert z1==z2==z3==0
  calls.append({'kind':'post','event':text_at(name),'object_id':object_id,'flags':flags,'callback_raw':callback,'cookie':cookie});ret(answer);return
 if a==0xaeb080:
  name,object_id,milliseconds,marker=struct.unpack('<4I',u.mem_read(sp+4,16));calls.append({'kind':'seek','event':text_at(name),'object_id':object_id,'milliseconds_raw':milliseconds,'nearest_marker_raw':marker});ret(1);return
 assert 0x706910<=a<0x706a1d or 0x7072f0<=a<0x7072f4,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for name,pos,scratch_ok,has_link,answer,age in itertools.product(['','event','Play_sfx_Env_Map10_Emitter_brazierchain'],[[1.,2.,3.],[3.4028234663852886e38]*3,[3.4028234663852886e38,2.,3.]],[False,True],[False,True],[0,7],[0.,-0.,.0005,.5,-.5,2.,3000000.]):
 u.mem_write(string,b'\0'*24)
 if len(name)<16:u.mem_write(string,name.encode()+b'\0');capacity=15
 else:u.mem_write(heap+0x1000,name.encode()+b'\0');u.mem_write(string,struct.pack('<I',heap+0x1000));capacity=len(name)
 u.mem_write(string+16,struct.pack('<II',len(name),capacity));u.mem_write(position,struct.pack('<3f',*pos));u.mem_write(out,struct.pack('<I',0xfeedbeef));u.mem_write(scratch,struct.pack('<4I',obj,engine,linked if has_link else 0,0))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<IIIIIf',end,out,string,position,0,age));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,engine);calls.clear();u.emu_start(0x706910,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);out_value=struct.unpack('<I',u.mem_read(out,4))[0];retired=u.mem_read(scratch+12,1)[0]
 assert result==(answer if name and scratch_ok else 0)
 assert out_value==(0xfeedbeef if not name else obj if scratch_ok else 0)
 assert retired==int(bool(name) and scratch_ok and answer==0)
 if not name:assert not calls
 elif not scratch_ok:assert calls==[{'kind':'allocate'}]
 else:
  assert calls[0]=={'kind':'allocate'}
  post=next(x for x in calls if x['kind']=='post');assert post=={'kind':'post','event':name,'object_id':123,'flags':5,'callback_raw':0x704a00,'cookie':scratch}
  assert sum(x['kind']=='position' for x in calls)==int(pos!=[3.4028234663852886e38]*3)
  assert sum(x['kind']=='linked_end' for x in calls)==int(answer==0 and has_link)
  assert sum(x['kind']=='seek' for x in calls)==int(answer!=0 and age!=0.)
 cases.append({'event':name,'position_bits':list(struct.unpack('<3I',struct.pack('<3f',*pos))),'scratch_available':scratch_ok,'linked_present':has_link,'post_return':answer,'age_bits':struct.unpack('<I',struct.pack('<f',age))[0],'calls':list(calls),'result':result,'output_object_raw':out_value,'retired':retired})
proof={'passed':True,'cases':cases,'native_sha256':digest,'addresses':{'object':obj,'scratch':scratch,'initial_output':0xfeedbeef},'limits':['Original706910 and ID getter7072F0 executed. Scratch creation706600, object position virtualC, linked End virtual4 and Wwise post/seek are explicit adapters.','All-MAX sentinel skips position; partial sentinel does not. Empty event preserves caller output; failed allocation clears it. Failed post preserves object output and marks scratch retired before linked End.','No actual audio queue, source registration, linked side effects, thread safety or audible playback measured. NaN/infinite age excluded.'],'complete':False}
(r/'data/4.20/audio_unbound_post_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original unbound launch',len(cases),'cases passed')
