"""Capture actual91C0C0 source defaults used by a constant projected emitter."""
from pathlib import Path
import json,struct,datetime,shutil
r=Path('E:/OpenLeague')
s=(r/'tools/probe_native_simple_defaults.py').read_text(encoding='utf-8').split('offsets=')[0]
exec(compile(s,'native projection sources initializer','exec'))
u.mem_write(object_address,b'\0'*0x410)
sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,object_address)
u.emu_start(0x91c0c0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
def table(offset,width):
 begin=read32(object_address+offset);last=read32(object_address+offset+4)
 assert last>=begin and (last-begin)%(width*4)==0 and last-begin<4096
 return dict(raw=list(struct.unpack('<'+'I'*((last-begin)//4),u.mem_read(begin,last-begin))),probability=read32(object_address+offset+0xc),width=width)
tables={hex(o):table(o,w) for o,w in [(0x74,1),(0x88,1),(0xa8,3),(0xc4,1),(0xd8,1),(0xec,3),(0x108,1),(0x11c,3)]}
fields={hex(o):read32(object_address+o) for o in [0x158,0x15c,0x164,0x170,0x174,0x17c,0x20c,0x210,0x214,0x218,0x21c,0x220,0x1ec,0x1f0]}
flags={hex(o):u.mem_read(object_address+o,1)[0] for o in [0x9c,0x150,0x151,0x160,0x161,0x334,0x340,0x364,0x388,0x3a4,0x3bc,0x3e0,0x400]}
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='91C0C0',tables=tables,fields=fields,flags=flags,adapters=calls,limits=['Actual initializer with supplied empty storage and controlled allocation/free/cookie adapters. Source population and native surrounding constructor remain unqualified.','Authored projection overrides and runtime cycle are qualified by separate full-frame contracts.'])
(r/'data/4.20/simple_projection_sources_defaults.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(tables=tables,fields=fields,flags=flags)))
