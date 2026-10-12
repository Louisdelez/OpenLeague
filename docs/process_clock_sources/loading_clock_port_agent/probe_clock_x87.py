"""No compiler: physical x87 conversion in a local Python-owned executable page."""
from pathlib import Path
import ctypes,hashlib,json,platform,struct,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import capstone
OUT=Path(__file__).resolve().parent
assert platform.system()=='Windows' and ctypes.sizeof(ctypes.c_void_p)==8
source=(OUT/'native_clock_results.json').read_bytes();proof=json.loads(source)
# Windows x64 RCX points to four signed qwords; RDX points to result32.
# Save/restore CW via shadow space; identical x87 integer conversion/division.
code=bytes.fromhex('d97c240866c744240a7f03d96c240adf29df6908d9e0dec1df6910df6918d9e0dec1def9d91ad96c2408c3')
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_64)
instructions=[f'{i.address:02x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in decoder.disasm(code,0)]
k=ctypes.WinDLL('kernel32',use_last_error=True)
k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];k.VirtualAlloc.restype=ctypes.c_void_p
k.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32];k.VirtualFree.restype=ctypes.c_int
address=k.VirtualAlloc(None,4096,0x3000,0x40)
if not address:raise ctypes.WinError(ctypes.get_last_error())
rows=[];mismatches=[]
try:
    ctypes.memmove(address,code,len(code))
    f=ctypes.WINFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint64),ctypes.POINTER(ctypes.c_uint32))(address)
    for case_index,case in enumerate(proof['cases']):
        if case['entry']!='sample':continue
        for sample_index,sample in enumerate(case['samples']):
            events=case['events'][sample['events_start']:sample['events_end']]
            query=next(e for e in reversed(events) if e['op']=='qpc')
            reads={e['address']:e['value'] for e in events if e['op']=='read'}
            counter=int.from_bytes(bytes.fromhex(query['output_hex']),'little')
            origin=reads[0x14bef48]|(reads[0x14bef4c]<<32)
            frequency=reads[0x14bef50]|(reads[0x14bef54]<<32)
            elapsed=(counter-origin)&((1<<64)-1)
            values=(ctypes.c_uint64*4)(elapsed&0x7fffffffffffffff,elapsed&0x8000000000000000,frequency&0x7fffffffffffffff,frequency&0x8000000000000000)
            dst=ctypes.c_uint32(0);f(values,ctypes.byref(dst))
            row=dict(case_index=case_index,sample_index=sample_index,counter=counter,origin=origin,frequency=frequency,elapsed=elapsed,native_unicorn_bits=sample['bits'],hardware_bits=dst.value,match=dst.value==sample['bits'])
            rows.append(row)
            if not row['match']:mismatches.append(row)
finally:
    assert k.VirtualFree(address,0,0x8000)
result=dict(schema=1,passed=not mismatches,source_sha256=hashlib.sha256(source).hexdigest(),native_sha256=proof['native_sha256'],control_word=0x37f,architecture=platform.machine(),code_hex=code.hex(),code_sha256=hashlib.sha256(code).hexdigest(),instructions=instructions,cases=rows,mismatches=mismatches,
            limits=['Physical x87 conversion/division/storage only; Windows x64 ABI bridge is local and synthetic, not whole original32-bit initializer.',
                    'No Rust compilation. No game process or remote process accessed. The Python-owned executable page was released.',
                    'CW037F and output bits qualified; exception/status flags and arbitrary caller control words remain outside this test.'])
(OUT/'clock_x87_hardware.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(dict(passed=result['passed'],samples=len(rows),mismatches=len(mismatches))))
assert not mismatches,mismatches[:3]
