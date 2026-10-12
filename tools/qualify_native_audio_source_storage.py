"""Original queue13/registered-source storage, allocation and dirty/mode semantics."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
prior=json.loads((r/'data/4.20/audio_emitter_position_contract.json').read_text())
b=Path(prior['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==prior['provenance']['sha256']
p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0xb0743a,0xb07450),(0xb09fe0,0xb0a039),(0xaf6400,0xaf642d),(0xaeedc0,0xaeee47)]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
assert struct.unpack('<I',p.get_data(0xb07d78+13*4-base,4))[0]==0xb0743a
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image()
u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
manager,node,object_ptr,old_ptr,new_ptr,source,message= [heap+i for i in [0,0x800,0x1000,0x2000,0x3000,0x4000,0x5000]]
calls=[];fail=False;internal_result=None
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def ret(value,cleanup):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0];u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4+cleanup);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,n,d):
 global internal_result
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool,size=read(sp+4,'II');calls.append({'operation':'allocate','bytes':size});ret(0 if fail else new_ptr,0);return
 if a==0xada3e0:
  pool,ptr=read(sp+4,'II');assert ptr==old_ptr;calls.append({'operation':'free'});ret(0,0);return
 if a==0xca1ef0:
  dest,src,size=read(sp+4,'III');calls.append({'operation':'memcpy','bytes':size})
  if size:u.mem_write(dest,bytes(u.mem_read(src,size)))
  ret(dest,0);return
 if a==0xaf6415:internal_result=u.reg_read(UC_X86_REG_EAX)
 if a==0xb07450:u.emu_stop();return
 assert any(s<=a<e for s,e in areas),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
sources=[[0x45e74000,0x44bb8000,0x45f0a000,0x7fc00000,0xdeadbeef,0],
 [0xc2480000,0x43480000,0x40f00000,0x3f800000,0x00000001,0x80000000],
 [0x3f000000,0x40000000,0x40400000,1,2,3]]
def run(found,old_count,count,mode,old_mode,dirty,allocation_failure,queue=False):
 global fail,internal_result
 fail=allocation_failure;internal_result=None;calls.clear();u.mem_write(heap,b'\0'*0x6000)
 # Bucket head includes a nonmatching object193 before object386 (same modulo193).
 obj=386;bucket=obj%193
 put(manager+0x20+bucket*4,'I',node)
 put(node,'III',node+0x20,193,object_ptr+0x200)
 put(node+0x20,'III',0,obj if found else 579,object_ptr)
 put(object_ptr+4,'I',old_ptr if old_count else 0);put(object_ptr+8,'H',old_count)
 put(object_ptr+0xa,'BB',0x81,old_mode);put(object_ptr+0x60,'I',dirty)
 old_words=[[10+i,20+i,30+i,40+i,50+i,60+i] for i in range(old_count)]
 for i,words in enumerate(old_words):put(old_ptr+i*24,'6I',*words)
 for i,words in enumerate(sources):put(source+i*24,'6I',*words)
 sp=stack+0x8000
 if queue:
  put(0x14a7a04,'I',manager);put(message+8,'I',obj);put(message+12,'6I',*sources[0])
  put(sp,'I',trap);u.reg_write(UC_X86_REG_EDI,message)
 else:put(sp,'5I',trap,obj,source,count,mode)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager)
 u.emu_start(0xb0743a if queue else 0xb09fe0,trap,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==(0xb07450 if queue else trap)
 pointer=read(object_ptr+4,'I')[0];actual_count=read(object_ptr+8,'H')[0]
 actual=[list(read(pointer+i*24,'6I')) for i in range(actual_count)] if pointer else []
 failed=found and old_count!=count and count>0 and fail
 expected_count=(0 if failed else count) if found else old_count
 expected=sources[:count] if found and not failed else ([] if found else old_words)
 expected_mode=((old_mode&0xf8)|(mode&7)) if found else old_mode
 assert actual_count==expected_count and actual==expected
 assert read(object_ptr+0xb,'B')[0]==expected_mode
 assert read(object_ptr+0xa,'B')[0]==0x81
 assert read(object_ptr+0x60,'I')[0]==(dirty|0x40000000 if found else dirty)
 assert u.reg_read(UC_X86_REG_EAX)==(1 if found else 2)
 assert internal_result==(52 if failed else 1) if found else internal_result is None
 return {'found':found,'old_count':old_count,'count':count,'mode':mode,'old_mode':old_mode,'prior_dirty':dirty,'allocation_failure':fail,'queue13':queue,
 'input_words':sources[:count],'prior_words':old_words,'stored_words':actual,'stored_count':actual_count,
 'stored_mode':expected_mode,'stored_mask':0x81,'stored_dirty':read(object_ptr+0x60,'I')[0],
 'manager_result':u.reg_read(UC_X86_REG_EAX),'storage_result':internal_result,'calls':calls.copy()}
cases=[]
for found,old_count,count,mode,old_mode,dirty,fail in itertools.product([False,True],[0,1,3],[0,1,3],[0,1,7,8,255],[0,0xa5],[0,0x12345678],[False,True]):
 cases.append(run(found,old_count,count,mode,old_mode,dirty,fail))
queue_cases=[run(found,old_count,1,0,old_mode,dirty,fail,True)
 for found,old_count,old_mode,dirty,fail in itertools.product([False,True],[0,1,3],[0,0xa5],[0,0x12345678],[False,True])]
result={'passed':True,'cases':cases,'queue13_cases':queue_cases,'regions':regions,'provenance':prior['provenance'],
 'stubs':['ADA670 allocator returns fixed buffer or zero; ADA3E0 free captures call; CA1EF0 memcpy copies requested bytes. Native descriptor resizing, count, low-mode-bit update, hash collision lookup, dirty flags and error propagation execute original instructions.'],
 'limits':['Full queue scheduler and registration/unregistration lifecycle not executed; bucket linked nodes are explicit fixtures.',
 'Orientation remains raw opaque words; no normalized or default direction inferred.',
 'Actual heap allocator/memcpy optimizations, audio DSP, rendering and audible acceptance not qualified.',
 'Native manager returns1 for existing object even when descriptor allocation reports52 and old positions are lost.'],
 'complete':False}
(r/'data/4.20/audio_source_storage_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print('Native source storage:',len(cases),'direct cases;',len(queue_cases),'queue13 cases')