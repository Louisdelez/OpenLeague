"""Whole 9214F0 worker with explicit backend/container/lock adapters."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000;u.mem_map(0,4096)
for a in [heap,stack,end]:u.mem_map(a,0x10000)
manager=heap;node=heap+0x1000;sentinel=heap+0x1800;calls=[];answer=0
u.mem_write(0xfa4428,struct.pack('<I',end+0x100))
for slot in [0x14,0x18,0x1c,0x20,0x24,0x54]:u.mem_write(end+slot,b'\xc3')
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value&0xffffffff)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a in [0x9941b0,0xc975f5,0x94bd80]:ret();return
 if a==end+0x100:ret(pop=4);return
 if a==0x564af0:
  src=struct.unpack('<I',u.mem_read(sp+4,4))[0];u.mem_write(ecx,bytes(u.mem_read(src,24)));ret(pop=12);return
 if a==0x946c70:ret(node+0x14,4);return
 if a==0x5c4680:
  out,target=struct.unpack('<II',u.mem_read(sp+4,8));assert target==node
  calls.append({'kind':'erase','logical_id':42});u.mem_write(sentinel+4,struct.pack('<I',sentinel));ret(pop=8);return
 if a in [end+0x18,end+0x1c,end+0x20,end+0x24]:
  count={0x18:4,0x1c:2,0x20:2,0x24:1}[a-end];args=list(struct.unpack('<'+'I'*count,u.mem_read(sp+4,count*4)))
  if a==end+0x18:calls.append({'kind':'create'});ret(answer,16)
  elif a==end+0x1c:calls.append({'kind':'position','backend_reference_raw':args[0]});ret(pop=8)
  elif a==end+0x20:calls.append({'kind':'boolean','backend_reference_raw':args[0],'value_raw':args[1]&255});ret(pop=8)
  else:calls.append({'kind':'release','backend_reference_raw':args[0]});ret(pop=4)
  return
 assert 0x9214f0<=a<0x921dd7 or 0x94bd20<=a<0x94bd76,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
patterns=[[],[42],[42,42],[99,42,99]];cases=[]
for creates,releases,flags,answer in itertools.product(patterns,patterns,[0,1,2,3],[-1,0,123]):
 u.mem_write(heap,b'\0'*0x10000);u.mem_write(stack,b'\0'*0x10000);u.mem_write(0,b'\0'*4)
 u.mem_write(manager,struct.pack('<I',heap+0x400));u.mem_write(manager+4,b'\1');u.mem_write(heap+0x400,struct.pack('<I',heap+0x500))
 for slot in [0x14,0x18,0x1c,0x20,0x24,0x54]:u.mem_write(heap+0x500+slot,struct.pack('<I',end+slot))
 u.mem_write(manager+0x30,struct.pack('<I',sentinel));u.mem_write(sentinel,struct.pack('<III',sentinel,node,sentinel));u.mem_write(sentinel+0xd,b'\1')
 u.mem_write(node,struct.pack('<III',sentinel,sentinel,sentinel));u.mem_write(node+0x10,struct.pack('<II',42,0xfffffffe))
 u.mem_write(node+0x18,b'event\0'+b'\0'*10+struct.pack('<II',5,15));u.mem_write(node+0x30,struct.pack('<IIfff',0,flags,1.,2.,3.));u.mem_write(node+0x44,b'\1');u.mem_write(node+0x48,struct.pack('<f',0.))
 for offset,pointer,keys in [(0x24,heap+0x2000,[]),(0x38,heap+0x3000,creates),(0x44,heap+0x3100,[42,99,42]),(0x50,heap+0x3200,releases),(0x60,heap+0x3300,[])]:
  u.mem_write(manager+offset,struct.pack('<III',pointer,pointer+len(keys)*4,pointer+0x80))
  if keys:u.mem_write(pointer,struct.pack('<'+'I'*len(keys),*keys))
 calls.clear();sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',end));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x9214f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 reference=(answer if 42 in creates else -2)&0xffffffff
 expected=[{'kind':'create'} for x in creates if x==42]
 for repeat in range(2):
  if flags&1:expected.append({'kind':'position','backend_reference_raw':reference})
  if flags&2:expected.append({'kind':'boolean','backend_reference_raw':reference,'value_raw':1})
 if 42 in releases:expected += [{'kind':'release','backend_reference_raw':reference},{'kind':'erase','logical_id':42}]
 assert calls==expected,(creates,releases,flags,answer,calls,expected)
 cleared={hex(o):struct.unpack('<II',u.mem_read(manager+o,8))[0]==struct.unpack('<II',u.mem_read(manager+o,8))[1] for o in [0x24,0x38,0x44,0x50,0x60]};assert all(cleared.values())
 cases.append({'creates':creates,'updates':[42,99,42],'releases':releases,'dirty_flags':flags,'backend_return':answer,'calls':list(calls),'all_queues_cleared':True,'entry_retained':42 not in releases})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Whole original9214F0 executed for persistent creation/update/release queues, native single-node lookup including missing IDs, native queue resets and transient-empty destruction.','Backend virtual callbacks, string copy, map store/erase and extra-empty destruction adapters; actual map erase updates fixture sentinel. No Wwise playing voices or audible output.','Lock fast-path initialized as acquired fixture, lock/security/LeaveCriticalSection callbacks adapted. Other-thread lock branches excluded.','Transient and secondary request vectors empty; their full non-empty handling remains unqualified.'],'complete':False}
(r/'data/4.20/audio_worker_queues_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Whole native worker192 queue cases passed')
