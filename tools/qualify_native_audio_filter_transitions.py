"""Bounded execution of native filter dirty consumption and planar transitions."""
from pathlib import Path
import sys,json,struct,hashlib,math,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_pcm_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0xb2b4f0,0xb2b7d8),(0xb2be10,0xb2bfa1),(0xb35530,0xb35681),(0xb2bb30,0xb2bdd8),(0xb2b870,0xb2b9d0),(0xb2b9d0,0xb2baff)]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
assert struct.unpack('<I',p.get_data(0x1210100-base,4))[0]==128
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x20000)
u.mem_write(trap+0x100,b'\xdb\xe3')
captures=[]
def hook(uc,a,n,d):
 assert any(x<=a<z for x,z in areas) or a==trap+0x100,hex(a)
 if a==0xb2bb30:
  sp=uc.reg_read(UC_X86_REG_ESP);captures.append(list(struct.unpack('<5f',uc.mem_read(sp+4,20))))
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def call(fn,args,this):
 u.emu_start(trap+0x100,trap+0x102)
 sp=stack+0x18000;u.mem_write(sp,struct.pack('<I',trap)+args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this)
 u.emu_start(fn,trap,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==trap

def state():
 current,target,step=struct.unpack('<ffH',u.mem_read(heap+0xc0,10));mode,bypass,dirty,immediate=struct.unpack('<4B',u.mem_read(heap+0xcc,4))
 return dict(current=current,target=target,step=step,mode_raw=mode,bypass=bool(bypass),dirty=bool(dirty),immediate=bool(immediate))
# State injection isolates consumer behavior; target/mode producers remain separate.
scenarios=[(0.,40.,8,True,True,True),(0.,80.,8,True,True,False),(40.,0.,8,False,True,False),(40.,80.,8,False,True,False),(0.,0.,8,True,True,False),(40.,.1,8,False,True,True),(40.,80.,7,False,False,False),(40.,40.,8,False,False,False),(0.1,.10001,8,True,True,False),(0.,.09999,8,True,True,True)]
cases=[]
for mode,align,scenario in itertools.product([0,1],[0,4,8,12],scenarios):
 u.mem_write(heap,b'\0'*0x200);u.mem_write(heap+0xb0,struct.pack('<I',heap+0x1000));hist=[[.25,-.5,.1,-.2],[-.25,.5,-.1,.2]];u.mem_write(heap+0x1000,struct.pack('<8f',*(hist[0]+hist[1])))
 coeff=[1.,0.,0.,0.,0.];call(0xb2bb30,struct.pack('<5f',*coeff),heap+0x10)
 current,target,step,bypass,dirty,immediate=scenario;u.mem_write(heap+0xc0,struct.pack('<ffH',current,target,step));u.mem_write(heap+0xcc,struct.pack('<4B',mode,bypass,dirty,immediate));initial=state();steps=[]
 for frames in [0,1,2,3,129,1024,17]:
  capacity=frames+3;source=[math.sin(i*.37)*.3 for i in range(frames)];pcm=[]
  for ch in [0,1]:pcm.extend([v*(1. if ch==0 else -.75) for v in source]+[.875]*3)
  pcm=list(struct.unpack('<%sf'%len(pcm),struct.pack('<%sf'%len(pcm),*pcm)))
  address=heap+0x4000+align;u.mem_write(address,struct.pack('<%sf'%len(pcm),*pcm));u.mem_write(heap+0x2000,struct.pack('<IIIHH',address,3,0,capacity,frames));captures.clear();call(0xb2b4f0,struct.pack('<I',heap+0x2000),heap)
  steps.append({'frames':frames,'capacity':capacity,'input':pcm,'output':list(struct.unpack('<%sf'%len(pcm),u.mem_read(address,len(pcm)*4))),'state':state(),'history':list(struct.unpack('<8f',u.mem_read(heap+0x1000,32))),'coefficient_updates':captures.copy()})
 cases.append({'initial':initial,'initial_history':hist,'initial_coefficients':coeff,'sample_rate':48000,'alignment_bytes':align,'steps':steps})
result={'passed':True,'cases':cases,'regions':regions,'provenance':c['provenance'],'block_size':128,'transition_steps':8,'bypass_threshold':struct.unpack('<f',p.get_data(0x1138ac8-base,4))[0],'limits':['Consumer states injected; external target/mode writers and allocator constructor not executed.','48000Hz planar two-channel tests; valid finite inputs only. Other rates have separate frequency/coefficient qualification.','No client mixer integration, audible acceptance or complete game qualification.'],'complete':False}
(r/'data/4.20/audio_filter_transition_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native transitions:',len(cases),'sequences /',sum(len(v['steps']) for v in cases),'blocks')
