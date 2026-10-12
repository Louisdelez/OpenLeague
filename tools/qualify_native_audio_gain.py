"""Execute native scaling4 dB-to-amplitude branch, with no client execution."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_listener_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
start,end=0xadee1c,0xadeed9;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
constants={a:struct.unpack('<f',p.get_data(a-base,4))[0] for a in [0x1138a98,0xff0100,0xff00f8,0xff00d8,0xff00c4,0xff00e8]}
assert p.get_data(0xadee53-base,10).hex()=='c70570794a01789ad44b'
assert p.get_data(0xaf56d4-base,7).hex()=='f30f59c30f2fe0'
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x2000)
u.mem_write(trap,b'\xd9\x1d'+struct.pack('<I',heap)+b'\xf4');u.mem_write(trap+0x100,b'\xdb\xe3')
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:None if start<=a<end or trap<=a<trap+7 or a==trap+0x100 else (_ for _ in ()).throw(AssertionError(hex(a))))
cases=[]
values=[-4096.,-1000.,-740.01,-740.,-739.99,-200.,-96.3,-80.,-60.,-40.,-35.,-31.,-26.5,-23.,-22.,-12.,-6.,-.001,0.,.001,6.,12.,24.,48.]+[float(v) for v in range(-100,49)]
for db in values:
 u.emu_start(trap+0x100,trap+0x102);bp=stack+0x1800;u.mem_write(bp,struct.pack('<II',0,trap));u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,bp-0x100)
 u.reg_write(UC_X86_REG_XMM3,int.from_bytes(struct.pack('<f',db),'little'));u.emu_start(start,trap+6,count=100);assert u.reg_read(UC_X86_REG_EIP)==trap+6
 gain=struct.unpack('<f',u.mem_read(heap,4))[0];cases.append({'db':db,'native_gain':gain})
result={'passed':True,'provenance':c['provenance'],'constants':{hex(a):v for a,v in constants.items()},'exponent_multiplier_bits':'4bd49a78','native_region':{'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]},'cases':cases,'limits':['Native scaling4 branch and its lazy constant initialization executed, without the generic interpolation prefix.','Rust support qualified up to48dB; higher positive gains not implemented. Very negative input uses native zero branch.','Voice property aggregation, gain smoothing, LPF, pitch, spatial distance and audible mixer remain incomplete.'],'complete':False}
(r/'data/4.20/audio_gain_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native dB gain:',len(cases),'cases passed; gain0=',next(c['native_gain'] for c in cases if c['db']==0.))
