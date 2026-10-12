"""Original logical constructor and release-key enqueue; no backend calls."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes()
assert hashlib.sha256(raw).hexdigest()=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
heap=0x30000000;stack=0x31000000;end=0x32000000;u.mem_map(0,4096)
for a in [heap,stack,end]:u.mem_map(a,0x10000)
u.mem_write(0xfa41a0,struct.pack('<I',end+0x100))
log=[]
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 if a==end+0x100:log.append('InitializeCriticalSection');ret(pop=4);return
 if a==0x68bc10:log.append('map_sentinel_allocation');ret(heap+0x5000);return
 if a in [0x9941b0,0x994210]:log.append('lock' if a==0x9941b0 else 'unlock');ret();return
 assert 0x920810<=a<0x9208fa or 0x92c8f0<=a<0x92c96a or 0x5bd2f0<=a<0x5bd358,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(a,arg):
 sp=stack+0x8000;u.mem_write(0,b'\0'*4);u.mem_write(sp,struct.pack('<II',end,arg));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap);log.clear();u.emu_start(a,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
ctors=[]
for seed in [0,0x55,0xaa,0xff]:
 for backend in [0,heap+0x6000]:
  u.mem_write(heap,bytes([seed])*0x10000);run(0x920810,backend)
  words={hex(o):struct.unpack('<I',u.mem_read(heap+o,4))[0] for o in [0,8,0x24,0x28,0x2c,0x30,0x34,0x38,0x3c,0x40,0x44,0x48,0x4c,0x50,0x54,0x58,0x5c,0x60,0x64,0x68]}
  assert words['0x5c']==1 and words['0x30']==heap+0x5000 and words['0x0']==backend
  assert all(value==0 for off,value in words.items() if off not in ['0x0','0x30','0x5c']);assert u.mem_read(heap+4,1)==b'\0'
  ctors.append({'seed_byte':seed,'backend_pointer':backend,'counter':words['0x5c'],'words':words,'calls':list(log)})
releases=[]
for keys in [[0],[1],[42],[0xffffffff],[1,1,0xffffffff,0,42]]:
 u.mem_write(heap,b'\0'*0x10000);u.mem_write(heap+0x58,struct.pack('<III',heap+0x3000,heap+0x3000,heap+0x4000))
 for key in keys:run(0x92c8f0,key);assert log==['lock','unlock']
 endptr=struct.unpack('<I',u.mem_read(heap+0x5c,4))[0];count=(endptr-(heap+0x3000))//4
 result=list(struct.unpack('<'+'I'*count,u.mem_read(heap+0x3000,4*count)));assert result==keys
 releases.append({'input_keys':keys,'queued_keys':result})
proof={'passed':True,'constructor_cases':ctors,'release_sequences':releases,'native_sha256':hashlib.sha256(raw).hexdigest(),'limits':['Original920810 constructor runs with Win32 critical section initialization and map sentinel allocation stubbed; lock storage bytes not claimed.','Original92C8F0 release queue and5BD2F0 append run with capacity available, locks stubbed. Worker voice release/removal not executed.','Release-key queue accepts all raw IDs and duplicates. Particle caller guard and teardown not yet qualified.'],'complete':False}
(r/'data/4.20/audio_logical_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original constructor8 cases / release5 sequences passed')
