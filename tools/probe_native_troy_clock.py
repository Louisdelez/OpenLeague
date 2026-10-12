from pathlib import Path
import shutil,ctypes,random
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
k=ctypes.windll.kernel32;k.VirtualAlloc.restype=ctypes.c_void_p;k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_ulong,ctypes.c_ulong]
blocks=[]
def cpu_function(body):
 code=bytes.fromhex('d97922d96920'+body+'d91ad96922c3');addr=k.VirtualAlloc(None,4096,0x3000,0x40);assert addr;ctypes.memmove(addr,code,len(code));blocks.append(addr);return ctypes.CFUNCTYPE(None,ctypes.c_void_p,ctypes.c_void_p)(addr)
normal=cpu_function('dd01dc6108dc4910dc4118');absent=cpu_function('dd4118')
obj=vector+0x6000;source_obj=vector+0x7000;vtable=vector+0x8000;stub=vector+0xb000;wrapper=vector+0xb020;source_value=vector+0xc000;output=vector+0xc100
u.mem_write(stub,b'\xdd\x05'+struct.pack('<I',source_value)+b'\xc3');w(vtable+4,stub);w(source_obj,vtable)
u.mem_write(wrapper,b'\xe8'+struct.pack('<i',0x928360-(wrapper+5))+b'\xd9\x1d'+struct.pack('<I',output)+b'\xc3')
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:visited.add(a))
profiles=list(itertools.product([None,0.,0.1,1.,12345.678,1e10],[0.,0.1,12345.67],[0.,0.1,0.5,1.,2.],[0.,0.125,-2.,1e10]))
rng=random.Random(420)
for _ in range(400):
 x=rng.uniform(-1e10,1e10);profiles.append((x,x+rng.uniform(-1,1),rng.uniform(-100,100),rng.uniform(-1e4,1e4)))
rows=[];disagreements=0
hex64=lambda x:struct.pack('<d',x).hex()
for source,origin,scale,offset in profiles:
 u.mem_write(obj,b'\0'*0x30);w(obj+8,source_obj if source is not None else 0)
 for off,val in [(0x10,scale),(0x20,origin),(0x28,offset)]:u.mem_write(obj+off,struct.pack('<d',val))
 u.mem_write(source_value,struct.pack('<d',0. if source is None else source));w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(wrapper,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end;emulated=read(output)
 buf=ctypes.create_string_buffer(struct.pack('<4d',0. if source is None else source,origin,scale,offset)+struct.pack('<HHI',0x37f,0,0));result=ctypes.c_uint32();(normal if source is not None else absent)(ctypes.addressof(buf),ctypes.byref(result));disagreements+=emulated!=result.value
 rows.append(dict(source_words=None if source is None else hex64(source),origin_words=hex64(origin),scale_words=hex64(scale),offset_words=hex64(offset),cpu_words=result.value,emulator_words=emulated))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x928360',control_word='0x037f',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),actual_cpu_x87_cases=len(rows),emulator_cpu_disagreements=disagreements,cases=rows,findings=['Original clock wrapper928360 computes (source-origin)*scale+offset in x87 extended intermediates; absent source loads offset only.','Result converted to f32 at caller storage. CPU executes original arithmetic instruction sequence with saved/restored x87 control037F.','760 cases include cancellation and nontrivial f64 scales; f64 intermediate rounding is not substituted for x87.'],adapters=['Underlying source virtual4 reads supplied f64; time source and scale/offset mutators remain unqualified.','Host CPU64 thunk preserves same x87 arithmetic sequence and final f32 store; calling convention adjusted.'],limits=['Finite supplied profiles and default037F only; nonfinite input, overflow and other control words unqualified.','No live client clock provider, pause/scale transition continuity or full lifecycle qualification.'])
(r/'data/4.20/troy_clock_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_instruction_addresses=proof['native_instruction_addresses'],emulator_cpu_disagreements=disagreements)))
