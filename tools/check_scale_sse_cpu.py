import ctypes,struct,json
from pathlib import Path
k=ctypes.WinDLL('kernel32',use_last_error=True)
k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];k.VirtualAlloc.restype=ctypes.c_void_p
k.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32]
code=bytes.fromhex('660f6ec1660f6ecaf30f59c1660f7ec0c3')
address=k.VirtualAlloc(None,4096,0x3000,0x40);assert address
ctypes.memmove(address,code,len(code));fn=ctypes.CFUNCTYPE(ctypes.c_uint32,ctypes.c_uint32,ctypes.c_uint32)(address)
values=[0x7fc01234,0x7fc05678,0x7fa01234,0x3f800000,0,0x7f800000];cases=[]
for a in values:
 for b in values:cases.append({'left_bits':hex(a),'right_bits':hex(b),'output_bits':hex(fn(a,b))})
assert fn(0x7fe01234,0x7fc05678)==0x7fe01234
k.VirtualFree(address,0,0x8000)
Path('E:/OpenLeague/data/4.20/complex_lifetime_scale_cpu_multiply.json').write_text(json.dumps({'passed':True,'instruction_bytes':code.hex(),'cases':cases,'scope':'Actual x86-64 CPU MULSS instruction, not whole original client'},indent=2)+'\n')
print(json.dumps({'passed':True,'cases':len(cases)}))
