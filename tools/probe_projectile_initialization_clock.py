from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_projectile_default_mask_activation.py').read_text().split('\nrows=[]')[0],'setup','exec'))
def reset_stop(uc,a,size,user):
 if a==0x940938:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,reset_stop)
rows=[]
for load_time,initialization_time,activation_time in [(1.,1.,1.),(1.,2.,3.),(7.,7.25,8.),(100.,101.,110.)]:
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20)]:u.mem_write(a,b'\0'*n)
 live=True;w(0x2d628c0,0);w(0x2d77f48,0);u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.))
 w(clock_value,struct.unpack('<I',struct.pack('<f',load_time))[0]);run(0x93fd60,troy,[0,nameptr,0]);w(wrapper,0x10a4960);w(wrapper+0xb0,0x212)
 run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 after_load=read(troy+0x118)
 init_bits=struct.unpack('<I',struct.pack('<f',initialization_time))[0];w(clock_value,init_bits)
 w(vector+0x1a000,wrapper);u.reg_write(UC_X86_REG_ESI,vector+0x1a000);u.reg_write(UC_X86_REG_EBP,stack+0x100);run(0x717ec0,0,[])
 assert read(troy+0x118)==init_bits and read(troy+0x144)&0x200
 w(clock_value,struct.unpack('<I',struct.pack('<f',activation_time))[0]);run(0x6c9b60,wrapper,[])
 assert read(troy+0x118)==init_bits
 u.mem_write(instance,bytes(0x200));w(instance+0x1ac,0xffffffff);w(instance+0x1b0,0xffffffff)
 w(troy+0x114,instance)
 u.reg_write(UC_X86_REG_EDI,troy);u.reg_write(UC_X86_REG_EBP,stack+0x2000)
 run(0x9408e8,0,[])
 reset_clocks=[read(instance+offset) for offset in [0xa8,0xac,0xb0]]
 assert reset_clocks==[init_bits]*3
 rows.append(dict(reset_clock_bits=reset_clocks,load_time=load_time,initialization_time=initialization_time,activation_time=activation_time,after_load_start_bits=after_load,after_activation_start_bits=read(troy+0x118),requests=read(troy+0x144)))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Deferred44 calls Troy9C=928990, storing initialization clock in118 and requesting200.','Subsequent activation updates visibility/pose without replacing stored start clock.','Original9408E8 caller and whole93E6F0 empty-instance reset copy initialization clock into all three simulation clocks.'],adapters=['Inherited clock ready and supplied float clock; original native reset and activation execute.','Registry single-item dispatch; allocation/resource supplied.'],limits=['Empty resource instance only; populated reset covered separately. Live frame timing remains a local adapter.'])
(r/'data/4.20/projectile_initialization_clock_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS4 native clock scenarios composed through original reset consumer')
