"""Bounded native closest scaled listener distance and scale setter execution."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_pcm_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0xaf3700,0xaf37f3),(0xb05310,0xb0533b),(0xb1a690,0xb1a6b2)];md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
heap,stack,trap=0x30000000,0x31000000,0x32000000;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
u.mem_write(trap,b'\xd9\x1d'+struct.pack('<I',heap+0x8000));u.mem_write(trap+0x100,b'\xdb\xe3')
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:None if any(x<=a<z for x,z in areas) or a in [trap,trap+0x100] else (_ for _ in ()).throw(AssertionError(hex(a))))
def f32(v):return struct.unpack('<f',struct.pack('<f',v))[0]
def call(fn,args):
 u.emu_start(trap+0x100,trap+0x102);sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',trap)+args);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(fn,trap,count=100000);assert u.reg_read(UC_X86_REG_EIP)==trap
scale_cases=[]
for index,scale in itertools.product(range(8),[.5,1.,2.,3.]):
 address=0x14a7e84+index*0x90;u.mem_write(address,struct.pack('<f',1.));u.mem_write(0x14a7ee0+index*0x90,b'\0');call(0xb1a690,struct.pack('<If',index,scale));assert struct.unpack('<f',u.mem_read(address,4))[0]==scale and u.mem_read(0x14a7ee0+index*0x90,1)==b'\1';scale_cases.append({'index':index,'scale':scale,'dirty_after':True})
cases=[]
for mask,mode,count,scaled,cluster in itertools.product([0,1,2,3,128,255],[0,1,7,8,255],[0,1,3],[False,True],[False,True]):
 listeners=[]
 for i in range(8):
  pos=[7400.+i*400,500.+i*20,7700.+i*100] if not cluster else [i*.125,(i-4)*.375,i*.625]
  scale=[.5,1.,2.,3.][i%4] if scaled else 1.;u.mem_write(0x14a7e78+i*0x90,struct.pack('<3f',*pos));call(0xb1a690,struct.pack('<If',i,scale));listeners.append({'position':pos,'distance_scale':scale})
 positions=([[7400.,1500.,7700.],[8400.,500.,7000.],[-800.,-50.,25.]] if not cluster else [[0.,0.,0.],[.125,-.25,.375],[.01,.02,.03]])[:count]
 positions=[[f32(v) for v in pos] for pos in positions];pointer=heap+0x1000 if count else 0
 for i,pos in enumerate(positions):u.mem_write(pointer+i*24,struct.pack('<6f',*pos,0.,0.,-1.))
 u.mem_write(heap,struct.pack('<IHBB',pointer,count,mask,mode));call(0xaf3700,struct.pack('<I',heap));u.emu_start(trap,trap+6);distance=struct.unpack('<f',u.mem_read(heap+0x8000,4))[0]
 cases.append({'listener_mask':mask,'mode_raw':mode,'positions':positions,'listeners':listeners,'native_distance':distance})
# Preserve original finite minimum sentinel when every selected distance exceeds it.
listeners=[{'position':[0.,0.,0.],'distance_scale':1.} for i in range(8)]
for i in range(8):u.mem_write(0x14a7e78+i*0x90,struct.pack('<3f',0.,0.,0.));call(0xb1a690,struct.pack('<If',i,1.))
pos=[f32(3e10),0.,0.];u.mem_write(heap+0x1000,struct.pack('<6f',*pos,0.,0.,-1.));u.mem_write(heap,struct.pack('<IHBB',heap+0x1000,1,255,1));call(0xaf3700,struct.pack('<I',heap));u.emu_start(trap,trap+6);cases.append({'listener_mask':255,'mode_raw':1,'positions':[pos],'listeners':listeners,'native_distance':struct.unpack('<f',u.mem_read(heap+0x8000,4))[0]})
result={'passed':True,'cases':cases,'scale_cases':scale_cases,'regions':regions,'provenance':c['provenance'],'sentinel':{'address':'0x1139284','bytes':p.get_data(0x1139284-base,4).hex(),'value':struct.unpack('<f',p.get_data(0x1139284-base,4))[0]},'default_position':{'address':'0x121026c','bytes':p.get_data(0x121026c-base,12).hex(),'value':list(struct.unpack('<3f',p.get_data(0x121026c-base,12)))},'limits':['Native Euclidean helper, scaled listener minimum, mask and source-mode iteration executed. Listener/source positions injected, not captured from original running client.','Full world-to-backend descriptor mapping, default descriptor usage and scale-setting callers remain to qualify. Tested finite positive listener scales only.','No complete gain/pitch/LPF aggregation, actual client playback or audible acceptance.'],'complete':False}
(r/'data/4.20/audio_distance_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native distance:',len(cases),'cases;',len(scale_cases),'scale setter cases; sentinel',result['sentinel']['value'])
