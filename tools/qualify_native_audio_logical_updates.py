"""Original logical position/boolean update methods, native lookup/copy/vector append."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000;u.mem_map(0,4096)
for a in [heap,stack,end]:u.mem_map(a,0x10000)
manager=heap;node=heap+0x1000;sentinel=heap+0x1800;record=node+0x14
calls=[]
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value&0xffffffff)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a in [0x9941b0,0x994210,0xc975f5,0x564900]:ret();return
 if a==0x564af0:
  src=struct.unpack('<I',u.mem_read(sp+4,4))[0];u.mem_write(ecx,bytes(u.mem_read(src,24)));ret(pop=12);return
 if a==0x946c70:
  ptr=struct.unpack('<I',u.mem_read(sp+4,4))[0];assert struct.unpack('<I',u.mem_read(ptr,4))[0]==42
  calls.append('store');ret(record,4);return
 if a==0x5bd2f0:calls.append('enqueue')
 assert 0x921150<=a<0x921312 or 0x921320<=a<0x921381 or 0x921390<=a<0x9214ee or 0x920ee0<=a<0x920f34 or 0x5bd2f0<=a<0x5bd358,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def setup(flags,backend,current):
 u.mem_write(heap,b'\0'*0x10000);u.mem_write(stack,b'\0'*0x10000);u.mem_write(0,b'\0'*4)
 u.mem_write(manager+0x30,struct.pack('<I',sentinel));u.mem_write(sentinel,struct.pack('<III',sentinel,node,sentinel));u.mem_write(sentinel+0xd,b'\1')
 u.mem_write(node,struct.pack('<III',sentinel,sentinel,sentinel));u.mem_write(node+0x10,struct.pack('<Ii',42,backend))
 u.mem_write(node+0x18,b'event\0'+b'\0'*10+struct.pack('<II',5,15));u.mem_write(node+0x30,struct.pack('<IIfff',7,flags,1.,2.,3.));u.mem_write(node+0x44,bytes([current]));u.mem_write(node+0x48,struct.pack('<f',-.5))
 u.mem_write(manager+0x44,struct.pack('<III',heap+0x3000,heap+0x3000,heap+0x4000))
def run(method,key,value):
 sp=stack+0x8000;arg=heap+0x5000 if method=='position' else value
 if method=='position':u.mem_write(arg,struct.pack('<fff',*value))
 u.mem_write(sp,struct.pack('<III',end,key,arg));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);calls.clear()
 u.emu_start(0x921150 if method=='position' else 0x921390,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 record_raw=bytes(u.mem_read(record,56));finish=struct.unpack('<I',u.mem_read(manager+0x48,4))[0];count=(finish-(heap+0x3000))//4
 queued=list(struct.unpack('<'+'I'*count,u.mem_read(heap+0x3000,4*count)))
 return record_raw,queued,list(calls)
cases=[]
for method in ['position','boolean']:
 values=[[1.,2.,3.],[-50.,-0.,15000.]] if method=='position' else [0,1,255]
 for flags,backend,current,key,value in itertools.product([0,2,0x80000000],[-1,123],[0,1,255],[42,99],values):
  setup(flags,backend,current);before=bytes(u.mem_read(record,56));after,queued,operations=run(method,key,value)
  changed=key==42 and (method=='position' or value!=current)
  expected=bytearray(before)
  if changed:
   if method=='position':expected[32:36]=struct.pack('<I',flags|1);expected[36:48]=struct.pack('<fff',*value)
   else:expected[32:36]=struct.pack('<I',flags|2);expected[48]=value
  assert after==expected and queued==([42] if changed else []) and operations==(['store','enqueue'] if changed else [])
  cases.append({'method':method,'flags':flags,'backend':backend,'initial_boolean':current,'key':key,'value':value,'queued':queued,'final_flags':struct.unpack('<I',after[32:36])[0],'final_position_bits':list(struct.unpack('<III',after[36:48])),'final_boolean':after[48]})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Original921150/921390 including native single-node lookup/missing IDs, copy921320, assignment920EE0 and pending-vector append5BD2F0 executed.','String descriptor copy, map store lookup, lock/destructor/security adapted; vector has capacity. String heap allocation/lock failures excluded.','Raw byte boolean comparison qualified including255; audible routing semantics and actual backend integration not claimed.'],'complete':False}
(r/'data/4.20/audio_logical_updates_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original logical updates',len(cases),'cases passed')
