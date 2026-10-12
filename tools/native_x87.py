"""Hardware x87 FYL2X boundary for Unicorn's verified zero-domain discrepancy.
Execute the actual x87 instruction on80-bit operands, not a library logarithm.
Other instructions remain native PE instructions in Unicorn. This is a hybrid
reference, not proof of a full client run on original hardware.
"""
import ctypes,struct,hashlib
class HardwareFyl2x:
 def __init__(self):
  k=ctypes.WinDLL('kernel32',use_last_error=True);k.VirtualAlloc.restype=ctypes.c_void_p;k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_ulong,ctypes.c_ulong];k.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_ulong];self.kernel=k
  # Save the caller's complete x87 environment. Load explicit native control word,
  # two extended operands; actual FYL2X; status/result; restore entire environment.
  self.code=bytes.fromhex('dd7140d96932db29db6910d9f1dd7934db7920dd6140c3')
  self.pointer=k.VirtualAlloc(None,len(self.code),0x3000,0x40);assert self.pointer;ctypes.memmove(self.pointer,self.code,len(self.code));self.function=ctypes.WINFUNCTYPE(None,ctypes.c_void_p)(self.pointer);self.buffer=ctypes.create_string_buffer(192);self.count=0
 def evaluate(self,y,x,cw=0x037f):
  self.buffer[0:10]=struct.pack('<QH',*y);self.buffer[16:26]=struct.pack('<QH',*x);self.buffer[50:52]=struct.pack('<H',cw);self.function(ctypes.addressof(self.buffer));self.count+=1;return struct.unpack('<QH',self.buffer[32:42]),struct.unpack('<H',self.buffer[52:54])[0]
 def execute(self,u,address):
  from unicorn.x86_const import UC_X86_REG_FP0,UC_X86_REG_FPSW,UC_X86_REG_FPTAG,UC_X86_REG_FPCW,UC_X86_REG_EIP
  status=u.reg_read(UC_X86_REG_FPSW);top=(status>>11)&7;x=u.reg_read(UC_X86_REG_FP0+top);y=u.reg_read(UC_X86_REG_FP0+((top+1)&7));result,physical=self.evaluate(y,x,u.reg_read(UC_X86_REG_FPCW));target=(top+1)&7
  u.reg_write(UC_X86_REG_FP0+target,result)
  tags=u.reg_read(UC_X86_REG_FPTAG);mantissa,exponent=result;tag=1 if mantissa==0 and exponent&0x7fff==0 else(2 if exponent&0x7fff==0x7fff or exponent&0x7fff==0 else 0)
  tags=(tags&~(3<<(2*top)))|(3<<(2*top));tags=(tags&~(3<<(2*target)))|(tag<<(2*target));u.reg_write(UC_X86_REG_FPTAG,tags)
  # FYL2X pops one entry; preserve previous sticky exceptions, use physical C1.
  status=(status&~(0x3800|0x0200))|(target<<11)|(physical&0x0200)|(physical&0x003f);u.reg_write(UC_X86_REG_FPSW,status);u.reg_write(UC_X86_REG_EIP,address+2)
 def metadata(self):return {'kind':'hardware_x87_fyl2x','code_hex':self.code.hex(),'sha256':hashlib.sha256(self.code).hexdigest(),'executions':self.count,'reason':'Unicorn FYL2X zero-domain reference returned0;actual processor returns negative infinity. Exact80-bit operands/results and FPU stack/tags/status are transferred.'}
 def close(self):
  if self.pointer:self.kernel.VirtualFree(self.pointer,0,0x8000);self.pointer=None
