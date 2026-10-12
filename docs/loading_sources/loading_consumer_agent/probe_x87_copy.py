"""Hardware-only FLD32/FSTP32 evidence, local Python process, no game injection."""
import ctypes,struct,json,platform
from pathlib import Path
assert platform.system()=='Windows' and ctypes.sizeof(ctypes.c_void_p)==8
k=ctypes.WinDLL('kernel32',use_last_error=True)
k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];k.VirtualAlloc.restype=ctypes.c_void_p
k.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32];k.VirtualFree.restype=ctypes.c_int
# Windows x64 RCX=&input,RDX=&output. Save CW in caller-provided shadow space;
# use0x37F, FLD/FSTP exactly as consumer, restore CW, return. No external calls.
code=bytes.fromhex('d97c240866c744240a7f03d96c240ad901d91ad96c2408c3')
address=k.VirtualAlloc(None,4096,0x3000,0x40)
if not address:raise ctypes.WinError(ctypes.get_last_error())
cases=[]
try:
    ctypes.memmove(address,code,len(code))
    f=ctypes.WINFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint32),ctypes.POINTER(ctypes.c_uint32))(address)
    for bits in [0,0x80000000,1,0x80000001,0x007fffff,0x807fffff,0x00800000,0x80800000,0x3f800000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7f800001,0xff800001,0x7f812345,0xff812345,0x7fbfffff,0xffbfffff,0x7fc00000,0xffc00000,0x7fc12345,0xffc23456,0x7fffffff,0xffffffff]:
        src=ctypes.c_uint32(bits);dst=ctypes.c_uint32(0);f(ctypes.byref(src),ctypes.byref(dst))
        expected=bits|0x400000 if bits&0x7f800000==0x7f800000 and bits&0x7fffff else bits
        assert dst.value==expected,(hex(bits),hex(dst.value),hex(expected))
        cases.append({'input_bits':bits,'output_bits':dst.value})
finally:
    assert k.VirtualFree(address,0,0x8000)
result={'passed':True,'scope':'physical x87 FLD32/FSTP32 only, not full consumer','control_word':0x37f,'code_hex':code.hex(),'architecture':platform.machine(),'cases':cases,'limits':['Local Python-owned executable allocation released after testing; no other process accessed.','Default masked x87 mode. Outputs qualified; exception/status flags not reproduced by portable Rust bit mapping.','Unicorn leaves signaling NaNs signaling; hardware evidence is authoritative for the pure load/store conversion.']}
(Path(__file__).resolve().parent/'x87_copy_hardware.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'hardware_x87_cases':len(cases),'passed':True}))
