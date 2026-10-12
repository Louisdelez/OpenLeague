"""Execute original706720 retired scratch cleanup and swap-last compaction."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [heap,stack,end]:u.mem_map(a,0x10000)
manager=heap;engine=heap+0x1000;array=heap+0x1800;calls=[]
for off in [0x100,0x104]:u.mem_write(end+off,b'\xc3')
def ret(pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0];u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==end+0x100:
  obj=struct.unpack('<I',u.mem_read(sp+4,4))[0];assert u.reg_read(UC_X86_REG_ECX)==engine
  calls.append({'kind':'dispose_object','index':(obj-(heap+0x4000))//0x100});ret(4);return
 if a==end+0x104:
  target=u.reg_read(UC_X86_REG_ECX);arg=struct.unpack('<I',u.mem_read(sp+4,4))[0];assert arg==1
  calls.append({'kind':'destroy_linked','index':(target-(heap+0x6000))//0x100,'argument':arg});ret(4);return
 if a==0xc98528:
  scratch=struct.unpack('<I',u.mem_read(sp+4,4))[0];calls.append({'kind':'free_scratch','index':(scratch-(heap+0x2000))//0x100});ret();return
 assert 0x706720<=a<0x7067ad or 0x7066a0<=a<0x706716,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for mode in ["retired","all"]:
 for count in range(6):
  for mask in range(1<<count):
   for link_mode in [0,1,2]:
    u.mem_write(heap,b'\0'*0x10000);u.mem_write(manager+0x3c,struct.pack('<III',array,array+4*count,array+0x100));u.mem_write(engine,struct.pack('<I',heap+0x1100));u.mem_write(heap+0x112c,struct.pack('<I',end+0x100));u.mem_write(heap+0x7000,struct.pack('<I',end+0x104))
    inputs=[]
    for index in range(count):
     scratch=heap+0x2000+index*0x100;obj=heap+0x4000+index*0x100;linked=heap+0x6000+index*0x100
     has_link=link_mode==1 or link_mode==2 and index%2==0;retired=(255 if index%2 else 1) if mask&(1<<index) else 0
     u.mem_write(array+4*index,struct.pack('<I',scratch));u.mem_write(scratch,struct.pack('<III',obj,engine,linked if has_link else 0));u.mem_write(scratch+0xc,bytes([retired]));u.mem_write(linked,struct.pack('<I',heap+0x7000));inputs.append({'index':index,'retired':retired,'linked':has_link})
    calls.clear()
    for repeat in range(2):
     sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',end));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x706720 if mode=="retired" else 0x7066a0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
    finish=struct.unpack('<I',u.mem_read(manager+0x40,4))[0];left=(finish-array)//4;remaining=[(struct.unpack('<I',u.mem_read(array+4*i,4))[0]-(heap+0x2000))//0x100 for i in range(left)]
    expected=[];live=list(range(count));cursor=0
    while cursor<len(live):
     index=live[cursor];item=inputs[index]
     if mode=='all' or item['retired']:
      expected.append({'kind':'dispose_object','index':index})
      if item['linked']:expected.append({'kind':'destroy_linked','index':index,'argument':1})
      expected.append({'kind':'free_scratch','index':index});
      if mode=='all':live.pop(cursor)
      else:live[cursor]=live[-1];live.pop()
     else:cursor+=1
    assert remaining==live and calls==expected
    cases.append({'mode':mode,'input':inputs,'calls':list(calls),'remaining_indices':remaining,'repeat_runs':2})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Whole706720 deferred pool cleanup and7066A0 shutdown cleanup executed on0..5 scratch entries/all retired subsets, retired raw1/255, absent/present/alternating linked targets; each repeated twice.','Engine virtual2C object disposal, linked virtual0(arg1) destruction and heap free explicitly recorded/adapted. Their underlying resource side effects remain separate qualification.','Native swap-last array compaction and iteration control executed; no actual playback completion timing, thread safety or callback delivery claim.'],'complete':False}
(r/'data/4.20/audio_deferred_pool_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original deferred pool',len(cases),'cases passed')
