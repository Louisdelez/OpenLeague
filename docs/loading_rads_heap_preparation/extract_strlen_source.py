"""Static PE source extraction for the exact observed DWORD scan boundary."""
from pathlib import Path
import sys,json,hashlib
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import pefile,capstone
OUT=Path(__file__).resolve().parent
DLL=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\RiotRadsIO.dll')
raw=DLL.read_bytes();digest=hashlib.sha256(raw).hexdigest()
assert digest=='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
pe=pefile.PE(data=raw);va=0x100f86d0;rva=va-pe.OPTIONAL_HEADER.ImageBase
code=pe.get_data(rva,0x8b);assert len(code)==0x8b
assert code[0x30:0x32]==bytes.fromhex('8b01')
assert code[0x48:0x4b]==bytes.fromhex('8b41fc')
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
proof=dict(source=str(DLL),source_sha256=digest,va=va,rva=rva,bytes=len(code),
    sha256=hashlib.sha256(code).hexdigest(),hex=code.hex(),native_execution=False,
    instructions=[dict(va=i.address,bytes=i.bytes.hex(),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(code,va)],
    limitations=['This is a static extraction, not qualification of a padding read.',
                 'EAX returns length, but EDX retains a value dependent on DWORD/padding; arbitrary fill is not full-register parity.'])
(OUT/'strlen_source.json').write_bytes((json.dumps(proof,indent=2)+'\n').encode())
print(json.dumps({'bytes':len(code),'sha256':proof['sha256'],'native_execution':False}))
