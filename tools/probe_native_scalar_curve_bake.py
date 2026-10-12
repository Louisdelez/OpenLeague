"""Execute original scalar interpolation and table bake without math adapters."""
from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil,random
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
u.mem_map(heap+0x10000,0x100000);knots=heap+0x1000;times=heap+0x2000;values=heap+0x3000;output=heap+0x4000;result=heap+0x5000;stub=end+0x100;u.mem_write(stub,b'\xd9\x1d'+struct.pack('<I',result)+b'\xc3');allocation_cursor=heap+0x10000;visited=set()
def hook(uc,a,size,user):
 global allocation_cursor
 if stub<=a<stub+7:return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a in (0xc9f39b,0x9933e0):
  n=read32(u.reg_read(UC_X86_REG_ESP)+4);assert 0<n<65536;ptr=allocation_cursor;allocation_cursor+=(n+31)&~15;assert allocation_cursor<heap+0x110000;u.mem_write(ptr,b'\xa5'*n);finish(eax=ptr);return
 if a==0xc98528:ptr=read32(u.reg_read(UC_X86_REG_ESP)+4);assert ptr==0 or heap+0x10000<=ptr<allocation_cursor;finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);write32(0x14bef58,0);write32(0x14bef40,0)
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0];bits=lambda v:hex(struct.unpack('<I',struct.pack('<f',v))[0])
datasets=[{'name':'constant','times':[0.],'values':[2.]},{'name':'linear','times':[0.,1.],'values':[0.,1.]},{'name':'negative','times':[0.,1.],'values':[-10.,5.]},{'name':'bell','times':[0.,.25,.75,1.],'values':[0.,.5,.5,0.]},{'name':'duplicates','times':[0.,.5,.5,1.],'values':[0.,1.,3.,0.]},{'name':'inner-domain','times':[.2,.8],'values':[2.,-3.]}]
rng=random.Random(420)
for index in range(8):
 ts=sorted([0.,1.]+[f32(rng.random()) for _ in range(5)]);datasets.append({'name':f'random-{index}','times':ts,'values':[f32(rng.uniform(-50,50)) for _ in ts]})
cases=[];samples=[]
for dataset in datasets:
 ts=[f32(v) for v in dataset['times']];vs=[f32(v) for v in dataset['values']];n=len(ts);u.mem_write(times,struct.pack('<'+'f'*n,*ts));u.mem_write(values,struct.pack('<'+'f'*n,*vs));u.mem_write(knots,struct.pack('<6I',times,times+4*n,times+4*n,values,values+4*n,values+4*n))
 for count in (1,3,16,256):
  allocation_cursor=heap+0x10000;u.mem_write(output,b'\0'*16);sp=stack+0x8000;write32(sp,end);write32(sp+4,knots);write32(sp+8,count);write32(sp+12,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,output);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x94d080,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  size=read32(output+4)-read32(output);actual_count=size//4;assert actual_count==(1 if n==1 else count);payload=bytes(u.mem_read(read32(output),size));cases.append({'name':dataset['name'],'times':ts,'values':vs,'requested_count':count,'actual_count':actual_count,'output_f32_bits':[hex(v) for v in struct.unpack('<'+'I'*actual_count,payload)]})
 for time in [-.1,0.,.2,.25,.5,.500001,.75,.8,1.,1.1]+ts:
  t=f32(time);sp=stack+0x8000;write32(sp,stub);write32(sp+4,struct.unpack('<I',struct.pack('<f',t))[0]);write32(sp+8,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,knots);u.emu_start(0x94ec10,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;samples.append({'name':dataset['name'],'times':ts,'values':vs,'time':t,'output_f32_bits':hex(read32(result))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'bake_entry':'0x94d080','sample_entry':'0x94ec10','cases':cases,'samples':samples,'original_instruction_addresses':len(visited),'adapters':['Heap allocation/free and stack cookie only in baker. Sample return captured by original x87 fstp adapter. Input knot vectors supplied; original field parser not executed.'],'limits':['Nonempty sorted finite scalar knots, including duplicate times. Vector/color variants and malformed/unsorted/empty data not qualified.','Baker samples i/count, excluding final endpoint, and uses one element for a constant curve. This differs from endpoint-inclusive generic interpolation.','Original x87 arithmetic and lower_bound execute; Rust port, metadata decoding, RNG, instance age input and ordinary rendering still pending.']};(r/'data/4.20/scalar_curve_bake_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'bake_cases':len(cases),'samples':len(samples),'table_values':sum(v['actual_count'] for v in cases),'native_addresses':len(visited),'passed':True}))
