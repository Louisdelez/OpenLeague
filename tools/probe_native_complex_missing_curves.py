"""Execute missing-curve fallbacks on freshly constructed original objects."""
from pathlib import Path
import sys,json,struct,shutil,datetime
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_complex_emitter_defaults.py').read_text(encoding='utf-8').split('for prior in')[0];exec(compile(setup,'complex constructor prerequisites','exec'));stops={0x91215b,0x91222d}
def stop_at_fallback(uc,a,size,user):
 if a in stops:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop_at_fallback);cases=[]
for old_bits in (0,0x42c80000,0x7fc00000):
 for importance in (0,1,2):
  allocation_cursor=heap+0x10000;allocations.clear();frees.clear();u.mem_write(obj,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200);write32(0x14bef58,0);write32(0x14bef40,0);sp=stack+0x8000;write32(sp,end);write32(sp+4,owner);write32(sp+8,importance);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x90fa70,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  before={'e_rate_scalar_bits':hex(read32(obj+0xd4)),'p_life_scalar_bits':hex(read32(obj+0xe8))};result={}
  for field,scalar,vector,entry,stop in [('e-rate',0xd4,0xc4,0x912138,0x91215b),('p-life',0xe8,0xd8,0x91220a,0x91222d)]:
   write32(obj+scalar,old_bits);write32(read32(obj+vector),old_bits);u.reg_write(UC_X86_REG_ESP,stack+0x8000);u.reg_write(UC_X86_REG_EDI,obj);u.emu_start(entry,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==stop
   output=read32(obj+scalar);constant=read32(read32(obj+vector));count=read32(obj+vector+4)-read32(obj+vector);assert output==constant and count==4
   result[field]={'entry':hex(entry),'stop':hex(stop),'scalar_offset':hex(scalar),'vector_offset':hex(vector),'scalar_bits':hex(output),'curve_constant_bits':hex(constant),'curve_count':count//4}
  assert result['e-rate']['scalar_bits']=='0x0' and result['p-life']['scalar_bits']=='0x40400000'
  cases.append({'prior_curve_bits':hex(old_bits),'importance':importance,'constructor_defaults':before,'reader_missing_curve_fallbacks':result})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Original constructor prerequisites and heap/cookie adapters from complex defaults probe.','Branch entry supplied as the native missing-curve path; 94A7F0 reader result and dictionary lookup not executed.'],'limits':['Constructor e-rate100 and p-life1 are replaced by reader missing-curve fallbacks e-rate0 and p-life3. Original resizer and fallback writes execute.','Existing constants tested as zero,100,quiet NaN under three importance values; exact scalar/curve constant bits and count1 checked.','Does not prove why a full curve reader returns not-found, authored curve decoding, interpolation, random sampling or ordinary rendering.']};(r/'data/4.20/complex_missing_curve_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'e_rate_fallback':0,'p_life_fallback':3,'native_addresses':len(visited)}))
