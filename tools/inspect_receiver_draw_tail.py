from pathlib import Path
import sys,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');proof=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(proof['source']).read_bytes();assert hashlib.sha256(raw).hexdigest()==proof['sha256']
p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase;memory=p.get_memory_mapped_image();cs=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for name,start,end in [('dispatch_tail',0x95c944,0x95cc10),('batch_draw',0x95afc0,0x95b140)]:
 lines=[f'{i.address:#x} {i.mnemonic} {i.op_str}' for i in cs.disasm(memory[start-base:end-base],start)]
 (r/f'logs/receiver_{name}.txt').write_text('\n'.join(lines)+'\n')
 print(name+'\n'+'\n'.join(x for x in lines if 'call' in x or 'ret' in x))
