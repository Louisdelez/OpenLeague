"""Execute original706C70 constructor; string and clock dependencies explicit."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [0,heap,stack,end]:u.mem_map(a,0x10000)
voice=heap;play=heap+0x100;stop=heap+0x200;clock=heap+0x300;vt=heap+0x400;calls=[];fatal=False
u.mem_write(clock,struct.pack('<I',vt));u.mem_write(vt+4,struct.pack('<I',end+0x100));u.mem_write(vt+0x20,struct.pack('<I',end+0x200));u.mem_write(end+0x100,b'\xd9\x05'+struct.pack('<I',heap+0x500)+b'\xc3');u.mem_write(end+0x200,b'\xc3')
def text_at(ptr):
 size,cap=struct.unpack('<II',u.mem_read(ptr+16,8));data=struct.unpack('<I',u.mem_read(ptr,4))[0] if cap>=16 else ptr
 return bytes(u.mem_read(data,size)).decode('ascii')
def string_at(ptr,name,storage):
 u.mem_write(ptr,b'\0'*24)
 if len(name)<16:u.mem_write(ptr,name.encode()+b'\0');cap=15
 else:u.mem_write(storage,name.encode()+b'\0');u.mem_write(ptr,struct.pack('<I',storage));cap=len(name)
 u.mem_write(ptr+16,struct.pack('<II',len(name),cap))
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 global fatal
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x564af0:
  src,start,length=struct.unpack('<3I',u.mem_read(sp+4,12));assert start==0 and length==0xffffffff
  dest=u.reg_read(UC_X86_REG_ECX);name=text_at(src);calls.append({'kind':'copy','field':dest-voice,'text':name});string_at(dest,name,heap+0x2000+(dest-voice)*32);ret(dest,12);return
 if a==end+0x200:calls.append({'kind':'clock_ready'});ret(int(ready));return
 if a==end+0x100:calls.append({'kind':'clock_get'});return
 if a==0x706d21:fatal=True;u.emu_stop();return
 assert 0x706c70<=a<0x706d62 or end+0x100<=a<end+0x109,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
inputs=list(itertools.product(['event','Play_sfx_Env_Map10_Emitter_brazierchain'],['','Stop_sfx_Env_Map10_Emitter_brazierchain'],[0,7,0xffffffff],[0,123,0xffffffff],[0,2,0xffffffff],[0.,-0.,.125,1000.25,65536.0625]))
for name,stop_name,playing_id,object_id,expected,now in inputs:
 ready=True;fatal=False;u.mem_write(voice,b'\xa5'*76);string_at(play,name,heap+0x1000);string_at(stop,stop_name,heap+0x1100);u.mem_write(0x2d791a8,struct.pack('<I',clock));u.mem_write(heap+0x500,struct.pack('<f',now));u.mem_write(0,b'\0'*4)
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<7I',end,playing_id,object_id,expected,play,456,stop));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);calls.clear();u.emu_start(0x706c70,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and not fatal
 assert u.reg_read(UC_X86_REG_EAX)==voice
 v,pid,oid,record=struct.unpack('<4I',u.mem_read(voice,16));stop_id=struct.unpack('<I',u.mem_read(voice+0x28,4))[0];clock_bits=struct.unpack('<I',u.mem_read(voice+0x44,4))[0];flags=list(u.mem_read(voice+0x48,4))
 assert (v,pid,oid,record,stop_id)==(0x10af338,playing_id,object_id,expected,456);assert flags==[0,1,0xa5,0xa5];assert clock_bits==struct.unpack('<I',struct.pack('<f',now))[0]
 assert text_at(voice+0x10)==name and text_at(voice+0x2c)==stop_name
 assert calls==[{'kind':'copy','field':16,'text':name},{'kind':'copy','field':44,'text':stop_name},{'kind':'clock_ready'},{'kind':'clock_get'}]
 cases.append({'play_event':name,'stop_event':stop_name,'playing_id':pid,'object_id':oid,'expected_record_raw':record,'stop_event_id':stop_id,'clock_bits':clock_bits,'released_raw':flags[0],'flag49_raw':flags[1],'unwritten_tail':flags[2:],'calls':list(calls)})
fatal_cases=[]
for present,ready in [(False,False),(True,False)]:
 fatal=False;u.mem_write(voice,b'\xa5'*76);u.mem_write(0x2d791a8,struct.pack('<I',clock if present else 0));sp=stack+0x8000;u.mem_write(sp,struct.pack('<7I',end,7,123,2,play,456,stop));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);calls.clear();u.emu_start(0x706c70,end,count=10000);assert fatal and not any(x['kind']=='clock_get' for x in calls)
 fatal_cases.append({'clock_present':present,'clock_ready':ready,'fatal_branch_reached':fatal,'calls':list(calls)})
proof={'passed':True,'cases':cases,'fatal_cases':fatal_cases,'native_sha256':digest,'limits':['Original706C70 constructor executed. String copy564AF0 and clock virtual readiness/getter inputs supplied explicitly; x87 clock return/field write executed.','Missing/not-ready clock branches run only up to706D21 fatal assertion entry; logging/crash excluded. Rust must return explicit error instead of silently inventing time.','Field49 is raw1; its meaning is not inferred. Bytes4A/4B preserve allocator seed and are not zero-initialized by constructor.','Actual string allocator, time-manager clock source, voice storage/control block and physical launch association remain separate qualification.'],'complete':False}
(r/'data/4.20/audio_voice_constructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original voice constructor',len(cases),'cases and',len(fatal_cases),'clock prerequisite branches passed')
