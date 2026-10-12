from pathlib import Path
import sys,json,struct,datetime,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');native=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);raw=native.read_bytes();pe=pefile.PE(data=raw);im=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.skipdata=True;md.detail=True;candidates=[]
for i in md.disasm(im[0x6b0000-base:0x6b2d10-base],0x6b0000):
 if i.mnemonic!='mov' or len(i.operands)!=2:continue
 if i.operands[0].type!=capstone.x86.X86_OP_MEM or i.operands[1].type!=capstone.x86.X86_OP_IMM:continue
 addr=i.operands[1].imm
 if not 0x1000000<=addr<=0x1140000:continue
 values=struct.unpack_from('<6I',im,addr-base)
 if not all(0x400000<=v<=0x1000000 for v in values):continue
 candidates.append({'instruction':hex(i.address),'operand':i.op_str,'vtable':hex(addr),'functions':[hex(v) for v in values]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':hashlib.sha256(raw).hexdigest(),'complete':False,'candidates':candidates,'limits':['Static constructor vtable candidates; shape identities and geometry behavior require original function execution.']}
(r/'docs/fow_shape_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(candidates))
