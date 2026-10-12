from pathlib import Path
import ctypes,random
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_clock_scale.py').read_text().split('rows=[]')[0],'setup','exec'))
k=ctypes.windll.kernel32;k.VirtualAlloc.restype=ctypes.c_void_p;k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_ulong,ctypes.c_ulong]
# Identical x87 arithmetic order, adapted input addressing and f64 output store.
code=bytes.fromhex('d97922d96920dd01dc6108dc4910dc4118dd1ad96922c3')
addr=k.VirtualAlloc(None,4096,0x3000,0x40);assert addr;ctypes.memmove(addr,code,len(code));cpu=ctypes.CFUNCTYPE(None,ctypes.c_void_p,ctypes.c_void_p)(addr)
def sample(first,origin,scale,offset):
 buf=ctypes.create_string_buffer(struct.pack('<4dHHI',first,origin,scale,offset,0x37f,0,0));out=ctypes.c_double();cpu(ctypes.addressof(buf),ctypes.byref(out));return out.value
rng=random.Random(420);rows=[];disagreements=0
for n in range(400):
 first=rng.uniform(-1e9,1e9);second=first+rng.uniform(0,.25);origin=first+rng.uniform(-2,2);scale=rng.uniform(0,4);offset=rng.uniform(-100,100);new_scale=[0.,1.,.5,2.][n%4]
 reads.clear();inputs[:]=[first,second];u.mem_write(obj,b'\0'*0x30);w(obj,0x10d6bc4);w(obj+8,source_obj)
 for off,x in [(0x10,scale),(0x20,origin),(0x28,offset)]:u.mem_write(obj+off,struct.pack('<d',x))
 w(stack,end);u.mem_write(stack+4,struct.pack('<d',new_scale));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.emu_start(0x9283c0,end,count=100)
 assert u.reg_read(UC_X86_REG_EIP)==end and reads==[first,second]
 cpu_offset=sample(first,origin,scale,offset);emu_offset=f64(obj+0x28);disagreements+=struct.pack('<d',cpu_offset)!=struct.pack('<d',emu_offset)
 assert f64(obj+0x20)==second and f64(obj+0x10)==new_scale
 rows.append(dict(before=dict(origin=origin,scale=scale,offset=offset),source_reads=[first,second],new_scale=new_scale,after_words={k:struct.pack('<d',v).hex() for k,v in dict(origin=second,scale=new_scale,offset=cpu_offset).items()},emulator_offset_words=struct.pack('<d',emu_offset).hex()))
out=dict(complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,physical_cpu_x87_cases=len(rows),emulator_cpu_offset_disagreements=disagreements,limits=['Native mutator control flow executes in Unicorn; offset arithmetic additionally evaluated on physical x87 with identical operation order and adapted addressing.','Original source provider, nonfinite profiles and alternate x87 control words remain unqualified.'])
(r/'data/4.20/clock_scale_precision_contract.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'cases':len(rows),'emulator_cpu_offset_disagreements':disagreements}))
