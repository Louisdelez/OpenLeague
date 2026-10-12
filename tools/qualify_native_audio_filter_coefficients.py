"""Execute original frequency-to-biquad argument calculation B2BE98..B2BF65."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_filter_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
start,end=0xb2be98,0xb2bf65;blob=p.get_data(start-base,end-start);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
heap,stack,init=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,init]:u.mem_map(a,0x2000)
u.mem_write(init,b'\xdb\xe3');u.mem_write(init+0x100,b'\xd9\x05'+struct.pack('<I',heap))
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:None if start<=a<end or a in [init,init+0x100] else (_ for _ in ()).throw(AssertionError(hex(a))))
cases=[]
for rate in [44100,48000,96000]:
 for freq in [16.7813015,20.,100.,1000.,7000.,20000.,rate*.45-.1,rate*.45,rate*.45+.1,rate*.49]:
  u.emu_start(init,init+2);u.mem_write(heap,struct.pack('<f',freq));u.emu_start(init+0x100,init+0x106)
  bp=stack+0x1800;u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,bp-0x100);u.reg_write(UC_X86_REG_ESI,heap+0x1000);u.mem_write(0x12100f4,struct.pack('<I',rate))
  u.emu_start(start,end,count=200);assert u.reg_read(UC_X86_REG_EIP)==end
  sp=u.reg_read(UC_X86_REG_ESP);coeff=list(struct.unpack('<5f',u.mem_read(sp,20)))
  cases.append({'frequency':struct.unpack('<f',struct.pack('<f',freq))[0],'sample_rate':rate,'native_coefficients':coeff})
result={'passed':True,'cases':cases,'native_region':{'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]},'provenance':c['provenance'],'coefficient_order':['b0','b1','b2','a1','a2'],'limits':['Original coefficient argument computation executed; setter/SIMD expansion and PCM filter not executed.','Bypass, smoothing, channel histories and raw mode semantics remain incomplete.'],'complete':False}
(r/'data/4.20/audio_filter_coefficients_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native filter coefficients:',len(cases),'cases;',len(ins),'instructions')
