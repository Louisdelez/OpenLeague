"""Read-only PE provenance; does not load a DLL or execute this dependency."""
from pathlib import Path
import sys,json,hashlib,importlib.util
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('source','E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py')
s=importlib.util.module_from_spec(spec);spec.loader.exec_module(s)
import pefile
dll=s.EXE.parent.parents[5]/'RADS'/'RiotRadsIO.dll'
assert dll.is_file(),dll
raw=dll.read_bytes();p=pefile.PE(data=raw)
regions=[];disassembly=[]
for role,a,n in [('rads_dynamic_loader',0x9529b0,0x140),('rads_entry_caller',0x9534b0,0x100),('logger_directory',0x8b3650,0x130),('logger_pipe',0x998d40,0x100)]:
    b=s.read(a,n)
    regions.append({'role':role,'address':a,'rva':a-s.BASE,'bytes':n,'sha256':hashlib.sha256(b).hexdigest(),'hex':b.hex()})
    disassembly.append('\n'+role+'\n'+'\n'.join(f'{i.address:08X}  {i.mnemonic} {i.op_str}' for i in s.md.disasm(b,a)))
proof={'source':str(s.EXE),'source_sha256':s.digest,'dll':str(dll),'dll_sha256':hashlib.sha256(raw).hexdigest(),
       'dll_bytes':len(raw),'machine':hex(p.FILE_HEADER.Machine),'image_base':hex(p.OPTIONAL_HEADER.ImageBase),
       'entrypoint_rva':hex(p.OPTIONAL_HEADER.AddressOfEntryPoint),'regions':regions,
       'exports':[{'name':x.name.decode() if x.name else None,'ordinal':x.ordinal,'rva':hex(x.address),'forwarder':x.forwarder.decode() if x.forwarder else None} for x in p.DIRECTORY_ENTRY_EXPORT.symbols],
       'imports':{x.dll.decode():[i.name.decode() if i.name else '#'+str(i.ordinal) for i in x.imports] for x in p.DIRECTORY_ENTRY_IMPORT},
       'dll_execution':'not performed; the native caller stops before LoadLibraryA. A host64 load is not a valid substitute for this x86 module.'}
(OUT/'rads_dependency.json').write_text(json.dumps(proof,indent=2)+'\n')
(OUT/'rads_dependency_source.txt').write_text('\n'.join(disassembly)+'\n')
print(json.dumps({k:proof[k] for k in ['dll','dll_sha256','dll_bytes','machine','entrypoint_rva','exports']}))
