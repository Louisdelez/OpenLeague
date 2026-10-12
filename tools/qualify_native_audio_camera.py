"""Execute the original locked-camera focus copy; never run the client executable."""
from pathlib import Path
import json,struct,hashlib,sys
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import UC_X86_REG_ECX,UC_X86_REG_EDI,UC_X86_REG_EIP
listener=json.loads((r/'data/4.20/audio_listener_contract.json').read_text())
b=Path(listener['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==listener['provenance']['sha256']
p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
anchors={0x7d1334:'8a425f84c07444',0x7d133b:'8b0d487fd70285c9743a',0x7d1345:'8b4214807860000f843a020000'}
for a,h in anchors.items():assert b[p.get_offset_from_rva(a-base):][:len(h)//2].hex()==h
start,end=0x7d1352,0x7d136d
blob=b[p.get_offset_from_rva(start-base):][:end-start]
assert blob.hex()=='d94160d99f04010000d94164d99f08010000d94168d99f0c010000'
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
ins=[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in md.disasm(blob,start)]
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
heap=0x30000000;u.mem_map(heap,0x2000)
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,data: None if start<=a<end else (_ for _ in ()).throw(AssertionError(hex(a))))
cases=[]
for v in [[0.,0.,0.],[7400.,100.,7698.671875],[-50.,-200.,7.5],[7000.,1500.,7700.],[15398.,2500.,0.]]:
 u.mem_write(heap+0x60,struct.pack('<3f',*v));u.mem_write(heap+0x1000+0x104,b'\0'*12)
 u.reg_write(UC_X86_REG_ECX,heap);u.reg_write(UC_X86_REG_EDI,heap+0x1000)
 u.emu_start(start,end,count=6);assert u.reg_read(UC_X86_REG_EIP)==end
 focus=list(struct.unpack('<3f',u.mem_read(heap+0x1000+0x104,12)));assert focus==v
 cases.append({'actor_position':v,'camera_focus':focus,'listener_position':[focus[0],500.,focus[2]]})
proof={'passed':True,'provenance':listener['provenance'],'branch_anchors':{hex(a):h for a,h in anchors.items()},'instructions':ins,'cases':cases,'native_executed_cases':len(cases),'semantic_evidence':'Locked-camera branch 7d1334/7d1348 copies local actor+60/+64/+68 into camera+104/+108/+10c. Qualified listener consumes these fields and replaces Y with height500.','limits':['Only locked-camera copy executed; branch selection, pan limits, easing and full camera controller are not emulated.','Client position bridge only; direction source, distance mixer and audible playback remain incomplete.'],'complete':False}
(r/'docs/map_ambient_audio_camera_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('Original camera focus copy: 5 cases, 6 instructions passed')
