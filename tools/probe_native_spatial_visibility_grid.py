from pathlib import Path
import json,struct,itertools,datetime,hashlib,shutil,math
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
volume=vector+0x4000;manager=vector+0x1000;output=vector+0x2000;captured=None
w(0x2da52e8,1);w(0x14ae660,1)
def hook(uc,a,size,user):
 global captured
 if a==0x95ee00:
  ptr=read(u.reg_read(UC_X86_REG_ESP)+4);captured=list(struct.unpack('<4i',u.mem_read(ptr,16)));u.emu_stop();return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
values=[-2147483648.,-2147483520.,-8388609.,-8388608.,-10.75,-1.5,-1.,-0.5,-0.,0.,0.5,1.,1.5,10.75,8388607.5,8388608.,2147483520.,2147483648.];rows=[]
for lo,hi in itertools.product(values,values):
 inputs=[lo,hi,hi,lo];u.mem_write(volume+0x114,struct.pack('<6f',lo,0.,hi,hi,0.,lo));w(stack,end);w(stack+4,output);w(stack+8,volume);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);captured=None
 u.emu_start(0x95eba0,end,count=10000);assert captured is not None,(lo,hi,hex(u.reg_read(UC_X86_REG_EIP)))
 cast=lambda x:x if -2147483648<=x<=2147483647 else -2147483648
 expected=[cast(math.floor(lo)),cast(math.floor(hi)),cast(math.ceil(hi)),cast(math.ceil(lo))];assert captured==expected,(inputs,captured,expected)
 rows.append(dict(bounds_xz=inputs,rectangle=captured))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['95EBA0','CA5F30','CA1E40'],findings=['Minimum x/z use native inline SSE floor, maximum x/z use actual CRT ceil and integer conversion.','Out-of-range signed32 conversion yields INT_MIN; signed zero converts to zero.'],adapters=['Stops on entry95EE00 after all four grid coordinates are produced.','CPU feature globals2DA52E8/14AE660 enabled, MXCSR1F80 and x87CW37F; no CRT call adapter.'],limits=['Finite inputs only; NaN/infinity, alternate floating-point modes and legacy non-SSE CRT paths remain unqualified.','Camera producer, root selection and recursive traversal still need end-to-end composition.'])
(r/'data/4.20/spatial_visibility_grid_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),native_addresses=proof['native_instruction_addresses'])))
