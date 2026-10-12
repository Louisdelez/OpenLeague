"""Execute original 920D50; explicit string/container/lock/security adapters only."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
ctx=json.loads((r/'data/4.20/ambient_audio_context.json').read_text())
exe=next(p for p in Path(ctx['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
raw=exe.read_bytes();assert hashlib.sha256(raw).hexdigest()=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=pe.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
u.mem_map(0,4096)
for a in [heap,stack,end]:u.mem_map(a,0x20000)
calls=[]
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a in [0x9941b0,0x994210,0x564900,0xc975f5]:ret();return
 if a==0x564af0:
  src=struct.unpack('<I',u.mem_read(sp+4,4))[0];u.mem_write(ecx,bytes(u.mem_read(src,24)));ret(pop=12);return
 if a==0x946c70:
  ptr=struct.unpack('<I',u.mem_read(sp+4,4))[0];calls.append({'kind':'map_entry','key':struct.unpack('<I',u.mem_read(ptr,4))[0]});ret(heap+0x1000,4);return
 if a==0x5bd2f0:
  ptr=struct.unpack('<I',u.mem_read(sp+4,4))[0];calls.append({'kind':'queue_key','key':struct.unpack('<I',u.mem_read(ptr,4))[0],'container_offset':ecx-heap});return
 assert 0x920d50<=a<0x920eda or 0x5bd2f0<=a<0x5bd358,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for counter in [0,1,42,0xfffffffe,0xffffffff]:
 for position in [[1.,2.,3.],[-50.,-0.,15000.],[7400.,1500.,7700.]]:
  for age in [-.5,0.,2.]:
   u.mem_write(heap,b'\0'*0x20000);u.mem_write(0,b'\0'*4);u.mem_write(heap+0x5c,struct.pack('<I',counter));u.mem_write(heap+0x38,struct.pack('<III',heap+0x3000,heap+0x3000,heap+0x4000))
   # SSO string fixture. Copy adapter preserves native 24-byte string descriptor.
   u.mem_write(heap+0x400,b'event\0'+b'\0'*10+struct.pack('<II',5,15));u.mem_write(heap+0x500,struct.pack('<fff',*position))
   sp=stack+0x10000;u.mem_write(sp,struct.pack('<III f',end,heap+0x400,heap+0x500,age));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap)
   calls.clear();u.emu_start(0x920d50,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
   handle=u.reg_read(UC_X86_REG_EAX);next_counter=struct.unpack('<I',u.mem_read(heap+0x5c,4))[0]
   record=bytes(u.mem_read(heap+0x1000,56));assert handle==counter and next_counter==(counter+1)&0xffffffff
   assert calls==[{'kind':'map_entry','key':counter},{'kind':'queue_key','key':counter,'container_offset':0x38}]
   assert record[4:28]==bytes(u.mem_read(heap+0x400,24))
   assert struct.unpack('<III',record[:4]+record[28:36])==(0xffffffff,0,0)
   assert record[48]==0
   assert struct.unpack('<I',u.mem_read(heap+0x3000,4))[0]==counter
   assert struct.unpack('<I',u.mem_read(heap+0x3c,4))[0]==heap+0x3004
   cases.append({'counter':counter,'next_counter':next_counter,'returned_handle':handle,'position_bits':list(struct.unpack('<III',record[36:48])),'age_bits':struct.unpack('<I',record[52:56])[0],'calls':list(calls)})
proof={'schema':1,'passed':True,'cases':cases,'native_function':'0x920d50','native_sha256':hashlib.sha256(raw).hexdigest(),'limits':['String descriptor copy, map entry lookup/allocation, lock, string destruction and security check explicitly adapted. Native pending-key vector append executed with capacity available; vector growth/allocation failure not qualified.','Logical reference registration and counter are original code; no Wwise voice acceptance, audible playback or worker lifetime claim.'],'complete':False}
(r/'data/4.20/audio_logical_registration_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('Original logical registration:',len(cases),'cases passed')
