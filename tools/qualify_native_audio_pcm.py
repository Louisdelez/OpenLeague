"""Execute original coefficient setter and aligned/scalar PCM processing."""
from pathlib import Path
import json,sys,struct,hashlib,math
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_filter_coefficients_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0xb2bb30,0xb2bdd8),(0xb2b870,0xb2b9d0),(0xb2b9d0,0xb2baff)];md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:None if any(x<=a<z for x,z in areas) else (_ for _ in ()).throw(AssertionError(hex(a))))
def call(fn,args):
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',trap)+args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap)
 u.emu_start(fn,trap,count=100000);assert u.reg_read(UC_X86_REG_EIP)==trap
samples=[[1.]+[0.]*63,[.25]*33,[(-1.)**i*.5 for i in range(31)],[math.sin(i*.37)*.3 for i in range(37)],[],[.1],[.1,-.2],[.1,-.2,.3],[.1,-.2,.3,-.4]]
params=[c['cases'][i]['native_coefficients'] for i in [0,3,4,5]]+[[1.,0.,0.,0.,0.]]
cases=[]
for coeff in params:
 for alignment in [0,4,8,12]:
  for pattern in samples:
   u.mem_write(heap,b'\0'*0x200);u.mem_write(heap+0xa0,struct.pack('<I',heap+0x4000));hist=[[0.,0.,0.,0.],[.25,-.5,.1,-.2]]
   u.mem_write(heap+0x4000,struct.pack('<8f',*(hist[0]+hist[1])));call(0xb2bb30,struct.pack('<5f',*coeff));expanded=list(struct.unpack('<40f',u.mem_read(heap,160)))
   steps=[]
   for channel,source in [(0,pattern),(1,[v*.75 for v in pattern]),(0,[0.]*7)]:
    source=list(struct.unpack('<%sf'%len(source),struct.pack('<%sf'%len(source),*source)))
    address=heap+0x2000+alignment
    if source:u.mem_write(address,struct.pack('<%sf'%len(source),*source))
    call(0xb2b870,struct.pack('<III',address,len(source),channel))
    output=list(struct.unpack('<%sf'%len(source),u.mem_read(address,len(source)*4)))
    history=list(struct.unpack('<8f',u.mem_read(heap+0x4000,32)))
    steps.append({'channel':channel,'input':source,'output':output,'history':history})
   cases.append({'coefficients':coeff,'alignment_bytes':alignment,'initial_history':hist,'expanded':expanded,'steps':steps})
result={'passed':True,'cases':cases,'regions':regions,'provenance':c['provenance'],'limits':['Original fixed-coefficient setter and PCM routines executed, including aligned four-sample path and scalar prefixes/tails.','Parameter transitions, bypass and denormal/NaN/Inf modes not qualified. No ambient playback or audible acceptance.'],'complete':False}
(r/'data/4.20/audio_pcm_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native PCM:',len(cases),'sequences/',sum(len(v['steps']) for v in cases),'blocks')
