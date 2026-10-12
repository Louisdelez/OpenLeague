"""Execute original cutoff control mapping B35530, preserving raw mode selector."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_listener_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
start,end=0xb35530,0xb35681;blob=p.get_data(start-base,end-start);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
assert p.get_data(0xb3557e-base,10).hex()=='c70550834a01bf9f7e49'
addresses=[0x1139020,0xff3044,0xff3048,0x11390a4,0xff3040,0x1138a0c,0x1138fa0,0xff00d8,0xff00c4,0xff00e8]
constants={hex(a):{'value':struct.unpack('<f',p.get_data(a-base,4))[0],'bytes':p.get_data(a-base,4).hex()} for a in addresses}
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x2000)
u.mem_write(trap,b'\xd9\x1d'+struct.pack('<I',heap));u.mem_write(trap+0x100,b'\xdb\xe3')
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:None if start<=a<end or a in [trap,trap+0x100] else (_ for _ in ()).throw(AssertionError(hex(a))))
cases=[]
for control,mode,rate in itertools.product([float(i) for i in range(101)]+[29.99,30.01,99.99],[0,1,255],[44100,48000,96000]):
 u.emu_start(trap+0x100,trap+0x102);sp=stack+0x1800;u.mem_write(sp,struct.pack('<IfI',trap,control,mode));u.reg_write(UC_X86_REG_ESP,sp);u.mem_write(0x12100f4,struct.pack('<I',rate))
 u.emu_start(start,trap,count=500);assert u.reg_read(UC_X86_REG_EIP)==trap
 u.emu_start(trap,trap+6);cases.append({'control':control,'mode_raw':mode,'sample_rate':rate,'native_cutoff':struct.unpack('<f',u.mem_read(heap,4))[0]})
result={'passed':True,'cases':cases,'constants':constants,'multiplier_bits':'497e9fbf','native_region':{'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]},'provenance':c['provenance'],'limits':['Both raw cutoff mapping branches executed; nonzero selector takes alternate sample-rate-dependent path. Meaning and selection of mode field+bc remain to qualify.','Frequency mapping only. Native coefficient calculation/bypass/smoothing/PCM filter still to implement.','Control0..100 and sample rates44100/48000/96000 tested. No audible playback acceptance.'],'complete':False}
(r/'data/4.20/audio_filter_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native cutoff mapping:',len(cases),'samples;',len(ins),'instructions')
