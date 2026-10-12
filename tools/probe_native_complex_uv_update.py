"""Original939DBE..939F75 two UV layers, clamp flags and native CRT fraction."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook;stop_address=None;trace=[]
def hook(uc,a,size,user):
 trace.append(a)
 if len(trace)>30:trace.pop(0)
 if a==stop_address:uc.emu_stop();return
 if heap+0xf100<=a<heap+0xf10a:return
 if a==0xca91a9:finish(eax=heap+0xa000);return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
container=heap+0x1000;config=heap+0x2000;stored=heap+0x3000;u.mem_write(heap+0xa000,b'\0'*0x400)
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def number(v):return struct.unpack('<f',struct.pack('<I',v))[0]
# Qualify the CRT's SSE2 dispatch available on this Windows CPU; startup flag supplied.
write32(0x2da52e8,1)
cpu={};exec((r/'tools/check_scale_sse_cpu.py').read_text().split('values=')[0],cpu)
addcode=cpu['code'].replace(bytes.fromhex('f30f59c1'),bytes.fromhex('f30f58c1'));addaddress=cpu['k'].VirtualAlloc(None,4096,0x3000,0x40);assert addaddress
cpu['ctypes'].memmove(addaddress,addcode,len(addcode));add=cpu['ctypes'].CFUNCTYPE(cpu['ctypes'].c_uint32,cpu['ctypes'].c_uint32,cpu['ctypes'].c_uint32)(addaddress)
crt_result=heap+0xf000;integer=heap+0xf010;gadget=heap+0xf100
u.mem_write(gadget,b'\x83\xc4\x0c\xd9\x1d'+struct.pack('<I',crt_result)+b'\xc3')
def fractional(value):
 global stop_address
 stop_address=None;sp=stack+0x6000;write32(sp,gadget);u.mem_write(sp+4,struct.pack('<d',number(value)));write32(sp+12,integer);write32(sp+16,end);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xc9c0b0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 return read32(crt_result)
def finish_uv(value,clamp):
 if clamp:
  v=number(value);return bits(1.) if v>1. else bits(-1.) if v< -1. else value
 return fractional(value)
fixtures=[([0]*4,[bits(0.)]*4),([bits(v) for v in [.5,-.5,1.,-1.]],[bits(v) for v in [.125,-.125,2.,-2.]]),([bits(v) for v in [2.,-2.,3.5,-3.5]],[bits(v) for v in [-.5,.5,-.25,.25]]),([0x80000000]*4,[0x80000000]*4),([0x7f7fffff,0xff7fffff,0x7f7fffff,0xff7fffff],[bits(2.)]*4),([0x7fc01234,0,0x7fa01234,0],[bits(.5)]*4),([bits(.25)]*4,[0x7fc05678,0x7f800000,0xff800000,0]),([1,0x80000001,1,0x80000001],[bits(.5)]*4)]
elapsed=[bits(v) for v in [-2.,0.,.25,.5,1.,2.]]+[0x7f800000,0x7fc0abcd]
cases=[]
for index,age,flags in itertools.product(range(len(fixtures)),elapsed,[0,1,2,4,6,7,0xaa,0xff]):
 stop_address=None;base_values,rates=fixtures[index];u.mem_write(container,b'\0'*0x200);u.mem_write(config,b'\0'*0x600);u.mem_write(stored,b'\0'*0x80);write32(container+0x40,stored);write32(container+0xa0,config);u.mem_write(config+0x2ad,bytes([flags]));u.mem_write(stored+8,struct.pack('<4I',*base_values));u.mem_write(stored+0x18,struct.pack('<4I',*rates))
 sp=stack+0x7000;u.mem_write(sp,b'\0'*0x200);write32(sp+0x14,age);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_XMM4,age);u.reg_write(UC_X86_REG_XMM3,bits(1.));stop_address=0x939f75
 try:u.emu_start(0x939dbe,stop_address,count=100000)
 except Exception:
  print('FAILED',index,hex(age),flags,hex(u.reg_read(UC_X86_REG_EIP)),[hex(v) for v in trace]);raise
 assert u.reg_read(UC_X86_REG_EIP)==stop_address
 original=[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(stored+0x28,16)))];after_base=[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(stored+8,16)))];after_rates=[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(stored+0x18,16)))];expected=[]
 for axis in range(4):
  product=cpu['fn'](rates[axis],age);raw=add(product,base_values[axis]) if axis==0 else add(base_values[axis],product)
  expected.append(hex(finish_uv(raw,bool(flags&(2 if axis<2 else 4)))))
 cases.append({'fixture':index,'base_bits':[hex(v) for v in base_values],'rate_bits':[hex(v) for v in rates],'elapsed_bits':hex(age),'flags':flags,'output_bits':original,'cpu_arithmetic_native_crt_bits':expected,'base_after_bits':after_base,'rate_after_bits':after_rates})
cpu['k'].VirtualFree(cpu['address'],0,0x8000);cpu['k'].VirtualFree(addaddress,0,0x8000)
flag_cases=[]
for first,second,prior in itertools.product([0,1,2,255],[0,1,2,255],[0,0xff,0x55,0xaa]):
 stop_address=None;u.mem_write(config+0x2ad,bytes([prior]));sp=stack+0x7000;u.mem_write(sp,b'\0'*0x200);u.reg_write(UC_X86_REG_EBP,sp);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,config);u.mem_write(sp+0xf,bytes([first]));stop_address=0x914f9a;u.emu_start(0x914f83,stop_address,count=1000);assert u.reg_read(UC_X86_REG_EIP)==stop_address
 u.mem_write(sp+0xf,bytes([second]));stop_address=0x91505b;u.emu_start(0x915026,stop_address,count=1000);assert u.reg_read(UC_X86_REG_EIP)==stop_address
 flag_cases.append({'first':first,'second':second,'prior':prior,'flags':u.mem_read(config+0x2ad,1)[0]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragment':['939DBE','939F75'],'cases':cases,'flag_cases':flag_cases,'emulator_cpu_disagreements':sum(c['output_bits']!=c['cpu_arithmetic_native_crt_bits'] for c in cases),'adapters':['Stored UV offsets, rates, elapsed time and flags supplied. Original loop fragment and whole native CRT fractional function execute.','CRT startup SSE2 capability flag supplied as1, with original default masked arithmetic controls. SSE2 fallback-x87 branch not qualified.','Supplemental actual CPU MULSS and ADDSS arithmetic plus original CRT fraction used to qualify nonfinite payloads. Original emulator output retained. Raw flag write fragments execute; typed source transport uses previously qualified binary bool rules.'],'limits':['UV rate/offset readers, birth sampling and owner transport not qualified. Main and multiplicative UV layer stages only; alpha/material/texture binding and renderer pending.','Global override/text-file boolean reader and startup CPU capability detection not qualified.']}
(r/'data/4.20/complex_uv_update_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'flag_cases':len(flag_cases),'emulator_cpu_disagreements':proof['emulator_cpu_disagreements'],'passed':True}))
