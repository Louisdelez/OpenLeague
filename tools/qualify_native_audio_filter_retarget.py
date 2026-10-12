"""Native allocated-voice filter gate/writer plus retargeting and reset traces."""
from pathlib import Path
import sys,json,struct,hashlib,math,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_pcm_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0xb1505f,0xb150d5),(0xb2b410,0xb2b467),(0xb2b7e0,0xb2b86f),(0xb2bb00,0xb2bb23),(0xb2b4f0,0xb2b7d8),(0xb2be10,0xb2bfa1),(0xb35530,0xb35681),(0xb2bb30,0xb2bdd8),(0xb2b870,0xb2b9d0),(0xb2b9d0,0xb2baff)]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x20000)
u.mem_write(trap+0x100,b'\xdb\xe3');captures=[]
def hook(uc,a,n,d):
 if a in [0xada670,0xca1d00]:
  sp=uc.reg_read(UC_X86_REG_ESP);ret=struct.unpack('<I',uc.mem_read(sp,4))[0]
  if a==0xada670:uc.reg_write(UC_X86_REG_EAX,heap+0x1000)
  else:
   dest,val,size=struct.unpack('<III',uc.mem_read(sp+4,12));assert size==32 and dest==heap+0x1000;uc.mem_write(dest,bytes([val&255])*size);uc.reg_write(UC_X86_REG_EAX,dest)
  uc.reg_write(UC_X86_REG_ESP,sp+4);uc.reg_write(UC_X86_REG_EIP,ret);return
 assert any(x<=a<z for x,z in areas) or a==trap+0x100,hex(a)
 if a==0xb2bb30:
  sp=uc.reg_read(UC_X86_REG_ESP);captures.append(list(struct.unpack('<5f',uc.mem_read(sp+4,20))))
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def fninit():u.emu_start(trap+0x100,trap+0x102)
def call(fn,args,this):
 fninit();sp=stack+0x18000;u.mem_write(sp,struct.pack('<I',trap)+args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.emu_start(fn,trap,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==trap

def state():
 current,target,step=struct.unpack('<ffH',u.mem_read(heap+0xc0,10));mode,bypass,dirty,immediate=struct.unpack('<4B',u.mem_read(heap+0xcc,4));return dict(current=current,target=target,step=step,mode_raw=mode,bypass=bool(bypass),dirty=bool(dirty),immediate=bool(immediate))
# Allocator/memset are explicit stubs. Original constructor and init execute.
cases=[]
for rate,align in itertools.product([44100,48000,96000],[0,4,8,12]):
 u.mem_write(0x12100f4,struct.pack('<I',rate));u.mem_write(heap,b'\0'*0x200);call(0xb2b410,b'',heap);call(0xb2b7e0,struct.pack('<II',3,1),heap);initial=state();initial_history=list(struct.unpack('<8f',u.mem_read(heap+0x1000,32)));steps=[]
 timeline=[(40.,3,False),(40.,129,False),(80.,3,False),(80.,129,False),(80.,0,False),(80.,261,False),(20.,7,False),(20.,129,False),(0.,17,False),(.1,17,False),(-10.,17,False),(20.,129,False),(120.,129,False),(100.,261,False),(100.,3,True),(100.,129,False),(99.999,129,False),(99.999,1024,False)]
 for raw,frames,reset in timeline:
  if reset:call(0xb2bb00,b'',heap)
  capacity=frames+3;source=[math.sin(i*.17)*.25 for i in range(frames)];pcm=[]
  for ch in [0,1]:pcm.extend([v*(1. if ch==0 else -.75) for v in source]+[.875]*3)
  pcm=list(struct.unpack('<%sf'%len(pcm),struct.pack('<%sf'%len(pcm),*pcm)));address=heap+0x4000+align;u.mem_write(address,struct.pack('<%sf'%len(pcm),*pcm));u.mem_write(heap+0x2000,struct.pack('<IIIHH',address,3,0,capacity,frames));u.mem_write(heap+0x3000+0xc,struct.pack('<f',raw));u.mem_write(heap+0x3000+0x14,struct.pack('<I',heap));u.mem_write(heap+0x3800+0x34,struct.pack('<I',heap+0x2000));captures.clear();fninit();u.reg_write(UC_X86_REG_ESP,stack+0x18000);u.reg_write(UC_X86_REG_ESI,heap+0x3000);u.reg_write(UC_X86_REG_EDI,heap+0x3800);u.emu_start(0xb1505f,0xb150d5,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==0xb150d5
  steps.append({'raw_control':raw,'reset':reset,'frames':frames,'capacity':capacity,'input':pcm,'output':list(struct.unpack('<%sf'%len(pcm),u.mem_read(address,len(pcm)*4))),'state':state(),'history':list(struct.unpack('<8f',u.mem_read(heap+0x1000,32))),'coefficient_updates':captures.copy()})
 cases.append({'sample_rate':rate,'alignment_bytes':align,'initial':initial,'initial_history':initial_history,'steps':steps})
# Separately execute the finite target writer including below-threshold values,
# which the allocated voice gate normally skips, and preserve pending dirty/reset.
writer=[]
for old,target,dirty,immediate in itertools.product([0.,40.,100.],[-10.,0.,.1,40.,80.,100.,120.],[False,True],[False,True]):
 u.mem_write(heap+0xc4,struct.pack('<f',old));u.mem_write(heap+0xce,struct.pack('<2B',dirty,immediate));u.mem_write(heap+0x3000+0xc,struct.pack('<f',target));u.mem_write(heap+0x3000+0x14,struct.pack('<I',heap));u.reg_write(UC_X86_REG_ESI,heap+0x3000);u.emu_start(0xb15086,0xb150ca,count=100);assert u.reg_read(UC_X86_REG_EIP)==0xb150ca
 writer.append({'old_target':old,'raw_control':target,'dirty_before':dirty,'immediate_before':immediate,'target_after':struct.unpack('<f',u.mem_read(heap+0xc4,4))[0],'dirty_after':bool(u.mem_read(heap+0xce,1)[0]),'immediate_after':bool(u.mem_read(heap+0xcf,1)[0])})
result={'passed':True,'cases':cases,'writer_cases':writer,'regions':regions,'provenance':c['provenance'],'stubs':['ada670 returns allocated history storage; ca1d00 clears requested history bytes. No PCM/control routines stubbed.'],'limits':['Voice gate and target writer executed with preexisting filter and buffer. Allocation failure and upstream LPF aggregation unqualified.','Constructor/initializer and reset executed with bounded allocator/memset stubs. Native voice creator mode1 argument source inspected separately; other callers not qualified.','Finite controls, two channels, three supported sample rates and four alignments. No live audio playback acceptance.'],'complete':False}
(r/'data/4.20/audio_filter_retarget_contract.json').write_text(json.dumps(result,separators=(',',':'))+'\n',encoding='utf-8');print('Native retarget:',len(cases),'sequences/',sum(len(v['steps']) for v in cases),'blocks;',len(writer),'writer cases')
