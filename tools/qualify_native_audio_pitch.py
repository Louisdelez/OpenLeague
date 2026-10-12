"""Execute the original pitch exponent and bounded x87 CRT power path."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_listener_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
assert p.get_data(0xb27f56-base,22).hex()=='d905f88d1301568b770cd98680000000d80d4826ff00'
assert struct.unpack('<f',p.get_data(0x1138df8-base,4))[0]==2.
factor=struct.unpack('<f',p.get_data(0xff2648-base,4))[0]
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x2000)
u.mem_write(trap,b'\xd9\x1d'+struct.pack('<I',heap+0x800));u.mem_write(trap+0x100,b'\xdb\xe3')
visited={};md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def guard(uc,a,n,d):
 assert 0xb27f56<=a<0xb27f71 or 0xca2fa0<=a<0xca3260 or 0xcb8bd0<=a<0xcb9000 or a in [trap,trap+0x100],hex(a)
 if a<heap:visited[a]=bytes(uc.mem_read(a,n))
u.hook_add(unicorn.UC_HOOK_CODE,guard)
cases=[]
for cents in [-2400.,-1200.,-400.,-200.,-150.,-.01,0.,.01,150.,200.,400.,1200.,2400.]+[float(v) for v in range(-2400,2401,25)]:
 u.emu_start(trap+0x100,trap+0x102);u.mem_write(heap+0xc,struct.pack('<I',heap+0x100));u.mem_write(heap+0x180,struct.pack('<f',cents))
 u.reg_write(UC_X86_REG_EDI,heap);u.reg_write(UC_X86_REG_ESP,stack+0x1800)
 u.emu_start(0xb27f56,0xb27f71,count=2000);assert u.reg_read(UC_X86_REG_EIP)==0xb27f71
 u.emu_start(trap,trap+6);cases.append({'cents':cents,'native_ratio':struct.unpack('<f',u.mem_read(heap+0x800,4))[0]})
ins=[]
for a,blob in sorted(visited.items()):
 i=next(md.disasm(blob,a));ins.append({'address':hex(a),'bytes':blob.hex(),'mnemonic':i.mnemonic,'operands':i.op_str})
result={'passed':True,'provenance':c['provenance'],'cents_multiplier':factor,'cents_multiplier_bits':p.get_data(0xff2648-base,4).hex(),'native_executed_instructions':ins,'cases':cases,'limits':['Original cents scaling and x87 CRT power executed; SSE CRT dispatch branch not exercised.','Supported cents domain limited to -2400..2400; playback resampler and pitch aggregation not implemented.','No audible playback acceptance or proof that generic Bevy resampling reproduces original Wwise.'],'complete':False}
(r/'data/4.20/audio_pitch_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native pitch:',len(cases),'cases;',len(ins),'executed instructions')
