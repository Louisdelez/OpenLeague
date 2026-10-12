"""Original93C2E4..93C309 table index selection and SSE load."""
from pathlib import Path
import sys,struct,json,datetime,shutil,random
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));obj=heap+0x1000;table=heap+0x2000;visited=set()
def hook(uc,a,size,user):assert 0x93c2e4<=a<=0x93c309,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[];random_values=random.Random(420)
for count in [1,3,7,16,64,256]:
 values=[struct.unpack('<f',struct.pack('<f',random_values.uniform(-50,50)))[0] for _ in range(count)];u.mem_write(table,struct.pack('<'+'f'*count,*values));write32(obj+0x1c,table);write32(obj+0x20,table+count*4)
 times=[-.1,-0.,0.,.1,.25,.5,.75,.999999,1.,1.1,1e10]+[i/count for i in range(count)]
 timebits=[struct.unpack('<I',struct.pack('<f',v))[0] for v in times]+[0x7f800000,0xff800000,0x7fc00000,0x7f7fffff]
 for bits in timebits:
  u.reg_write(UC_X86_REG_ESP,stack+0x8000);u.reg_write(UC_X86_REG_EDI,obj);u.reg_write(UC_X86_REG_XMM4,bits);u.emu_start(0x93c2e4,0x93c30e,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x93c30e;cases.append({'count':count,'values':values,'time_bits':hex(bits),'index':u.reg_read(UC_X86_REG_EAX),'output_bits':hex(u.reg_read(UC_X86_REG_XMM0)&0xffffffff)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'0x93c2e4','stop':'0x93c30e','cases':cases,'original_instruction_addresses':len(visited),'adapters':[],'limits':['Nonempty scalar tables sizes1,3,7,16,64,256 and supplied normalized-time register. Original age/time normalization before this fragment not qualified.','Original cvttss2si yields INT_MIN on NaN, infinity or positive overflow, then lower clamp selects first entry. Empty-table read unsafe and unsupported.','No interpolation at runtime: quantized table selection. Ordinary emitter integration remains pending.']};(r/'data/4.20/baked_scalar_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
