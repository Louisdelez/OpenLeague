"""Original704A00/704A40 event callbacks; interface calls adapted."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [heap,stack,end]:u.mem_map(a,0x10000)
cookie=heap;linked=heap+0x1000;info=heap+0x2000;calls=[]
for slot in [0,4,8]:u.mem_write(end+0x100+slot,b'\xc3')
def hook(uc,a,size,user):
 if a in [end+0x100,end+0x104,end+0x108]:
  sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0];slot=a-end-0x100
  assert u.reg_read(UC_X86_REG_ECX)==(cookie if kind=='bound' else linked)
  arg=struct.unpack('<I',u.mem_read(sp+4,4))[0] if slot==0 else None
  if slot==0:assert arg==1
  calls.append({'slot':slot,'argument':arg});u.reg_write(UC_X86_REG_ESP,sp+4+(4 if slot==0 else 0));u.reg_write(UC_X86_REG_EIP,target);return
 assert 0x704a00<=a<0x704a37 or 0x704a40<=a<0x704a73,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for kind,event_type,present,has_link,initial in itertools.product(['bound','unbound'],[0,1,4,5,255],[False,True],[False,True],[0,1]):
 u.mem_write(heap,b'\0'*0x10000);u.mem_write(info,struct.pack('<I',cookie if present else 0));u.mem_write(cookie+0xc,bytes([initial]))
 object_target=cookie if kind=='bound' else linked;u.mem_write(object_target,struct.pack('<I',heap+0x3000));u.mem_write(cookie+8,struct.pack('<I',linked if has_link else 0))
 for slot in [0,4,8]:u.mem_write(heap+0x3000+slot,struct.pack('<I',end+0x100+slot))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<III',end,event_type,info));u.reg_write(UC_X86_REG_ESP,sp);calls.clear();u.emu_start(0x704a40 if kind=='bound' else 0x704a00,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 ended=u.mem_read(cookie+0xc,1)[0];expected=[]
 if present and event_type in [1,4] and (kind=='bound' or has_link):
  expected=[{'slot':4,'argument':None},{'slot':0,'argument':1}] if kind=='bound' and event_type==1 else [{'slot':4 if event_type==1 else 8,'argument':None}]
 assert calls==expected;assert ended==(1 if kind=='unbound' and present and event_type==1 else initial)
 cases.append({'kind':kind,'event_type':event_type,'cookie_present':present,'linked_object_present':has_link,'initial_retired':initial,'final_retired':ended,'calls':list(calls)})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Original704A00/unbound and704A40/bound callbacks executed; target interface virtual0/4/8 calls recorded with explicit adapters.','Callback-info pointer valid; missing cookie and missing linked target covered. Interface meanings/destruction side effects and Wwise callback delivery not qualified by this step.','Unbound End(type1) marks scratch retired for deferred cleanup; does not directly unregister audio source. Bound End invokes slot4 then slot0(arg1). Other event bits ignored unless exact1/4.'],'complete':False}
(r/'data/4.20/audio_object_callbacks_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original object callbacks80 cases passed')
