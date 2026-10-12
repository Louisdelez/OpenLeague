from pathlib import Path
import sys,json,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone,unicorn
from unicorn.x86_const import UC_X86_REG_ESI,UC_X86_REG_EDI
raw=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;data=pe.get_memory_mapped_image();md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);rows=[]
for address,reg,value in [(0x59ce8a,UC_X86_REG_ESI,0),(0x59cfeb,UC_X86_REG_EDI,1),(0x59d134,UC_X86_REG_EDI,1),(0x59d29c,UC_X86_REG_EDI,1),(0x59d4e0,UC_X86_REG_ESI,1)]:
 ins=next(md.disasm(data[address-base:address-base+16],address))
 for initial in [0,0x55,0xff]:
  u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);page=address&~4095;u.mem_map(page,4096);u.mem_write(address,data[address-base:address-base+ins.size]);obj=0x30000000;u.mem_map(obj,4096);u.mem_write(obj,bytes([initial])*4096);u.reg_write(reg,obj+0x60);u.emu_start(address,address+ins.size);observed=u.mem_read(obj+0x122,1)[0];assert observed==value;rows.append(dict(address=hex(address),initial=initial,value=observed,instruction=ins.mnemonic+' '+ins.op_str))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['72A485 passes manager+60 to59CC60. Constructor59CE8A clears dword subobject+C0, including manager122.','Four located activation writes set subobject+C2 to1.'],limits=['Individual original write instructions executed with explicit this alias; complete constructor/caller paths not executed.','Startup default0 proven by instruction path inspection; normal gameplay activation callers still unqualified.'])
(r/'data/4.20/projectile_root_filter_writes.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS15 native write cases')
for name in ['coverage','resume_checkpoint','completion_plan','goal_plan_revision']:
 p=r/f'docs/{name}.json';d=json.loads(p.read_text(encoding='utf-8'));d['next_action']='Root filter writer found: manager+60 subobject initialized59CC60;59CE8A clears dword+C0 including manager122. Four writes59CFEB/59D134/59D29C/59D4E0 set subobjectC2=1.15 isolated native instruction cases pass (data/4.20/projectile_root_filter_writes.json); full constructor/caller execution not proven. Next trace four activation entry callers and meanings before integrating rootfilter state; normal match may activate after default0. No active process. Full plan preserved.';p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
