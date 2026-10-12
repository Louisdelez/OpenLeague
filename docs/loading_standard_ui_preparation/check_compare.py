from pathlib import Path
import sys,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
out=Path(__file__).resolve().parent
source=json.loads((out/'source_regions.json').read_text());raw=Path(source['native_executable']).read_bytes();assert hashlib.sha256(raw).hexdigest()==source['native_sha256']
p=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
lines=[]
for a,n in [(0x5fa6b0,0x70),(0xc9cf31,0x10)]:
    data=p.get_data(a-p.OPTIONAL_HEADER.ImageBase,n);lines.append(f'BOUNDED WINDOW {a:08x} bytes={n}')
    for ins in md.disasm(data,a):lines.append(f'{ins.address:08x} {ins.mnemonic} {ins.op_str}')
(out/'compare_windows.txt').write_text('\n'.join(lines)+'\n');print('\n'.join(lines))
