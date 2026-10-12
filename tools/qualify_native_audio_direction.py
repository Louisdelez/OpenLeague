"""Bounded native render-view direction extraction, without running LoL."""
from pathlib import Path
import json,sys,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_listener_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0x7cfde1,0x7cfe79),(0x66d6e0,0x66d72a)];md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
regions=[]
for a,end in areas:
 blob=p.get_data(a-base,end-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(a),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
assert p.get_data(0x704b5f-base,7).hex()=='c7461400000000'
heap,stack,init=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,init]:u.mem_map(a,0x2000)
u.mem_write(init,b'\xdb\xe3')
def guard(uc,a,n,d):assert any(x<=a<z for x,z in areas) or a==init,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
cases=[]
for eye,focus in [([7400.,6900.,2398.671875],[7400.,100.,7698.671875]),([0.,0.,0.],[0.,0.,1.]),([0.,0.,0.],[1.,0.,0.]),([1.,2.,3.],[1.,2.,3.]),([0.,0.,0.],[0.,1.,0.]),([3.,4.,5.],[-4.,2.,7.]),([0.,0.,0.],[.000001,0.,0.]),([0.,0.,0.],[.001,0.,0.])]:
 u.emu_start(init,init+2);bp=stack+0x1800
 u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,bp-0x100);u.reg_write(UC_X86_REG_EDI,heap+0x1000)
 u.mem_write(bp+8,struct.pack('<I',heap));u.mem_write(heap+0x1130,struct.pack('<f',56.))
 for reg,v in [(UC_X86_REG_XMM0,focus[0]),(UC_X86_REG_XMM1,focus[1]),(UC_X86_REG_XMM5,focus[2]),(UC_X86_REG_XMM4,eye[0]),(UC_X86_REG_XMM2,eye[1]),(UC_X86_REG_XMM3,eye[2])]:u.reg_write(reg,int.from_bytes(struct.pack('<f',v),'little'))
 u.emu_start(0x7cfde1,0x7cfe79,count=200);assert u.reg_read(UC_X86_REG_EIP)==0x7cfe79
 result=list(struct.unpack('<3f',u.mem_read(heap+0x14,12)));cases.append({'eye':eye,'focus':focus,'native_direction':result})
result={'passed':True,'cases':cases,'regions':regions,'provenance':c['provenance'],'native_default_audio_angle':0.0,'default_angle_instruction':'c7461400000000','limits':['Only view direction tail executed. Camera eye derivation, camera shake finalizer7d2be0 and modes1/2/3 remain unqualified.','Client direction uses its existing render eye; historical camera pitch/distance matching remains incomplete. No audible playback acceptance.'],'complete':False}
(r/'data/4.20/audio_direction_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print('Native camera view direction: 8 cases passed; audio angle default0 byte verified')
