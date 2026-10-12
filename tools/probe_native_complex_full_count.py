"""Original9345F0 whole function: zero ratebyvel, no attribute-rate source."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook
instance=heap+0x1000;config=heap+0x2000;owner=heap+0x3000;scales=heap+0x5000;prob=heap+0x6000;table=heap+0x8000;pair=heap+0x9000
trace={}
def hook(uc,a,size,user):
 if a==0x949680:trace['age_bits']=hex(read32(u.reg_read(UC_X86_REG_ESP)+8))
 if a==0x934763:trace['rate_bits']=hex(read32(u.reg_read(UC_X86_REG_EBP)-8))
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def fbits(v):return struct.unpack('<f',struct.pack('<I',int(v,16)))[0]
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
def seed_rng(seed):
 sp=stack+0x8000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000)
def bind(parameter):
 values=[int(b,16) for b in parameter['table_bits']];u.mem_write(table,struct.pack('<'+'I'*len(values),*values));write32(config+0xc4,table);write32(config+0xc8,table+4*len(values));write32(config+0xd0,prob)
 probability=parameter['probability'];u.mem_write(prob,b'\0'*44);u.mem_write(prob,bytes([probability['constant']]));write32(prob+4,int(probability['constant_bits'],16));u.mem_write(prob+8,bytes([probability['fast']]));write32(prob+12,int(probability['begin_bits'],16));write32(prob+16,int(probability['difference_bits'],16))
 for offset,key in [(20,'times'),(32,'values')]:
  addr=prob+0x100+offset*8;values=probability[key];u.mem_write(addr,struct.pack('<'+'f'*len(values),*values));u.mem_write(prob+offset,struct.pack('<3I',addr,addr+4*len(values),addr+4*len(values)))
 u.mem_write(pair,b'\0'*8);write32(config+0x28c,pair);write32(config+0x290,pair+8)
def run(parameter,timing,time,seed):
 global trace
 trace={};u.mem_write(instance,b'\0'*0x300);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200);u.mem_write(scales,b'\0'*0x200)
 for addr,val in [(instance,scales),(instance+4,owner),(instance+8,config),(config+0x314,10),(instance+0x118,3)]:write32(addr,val)
 for addr,key in [(config+0x308,'period_bits'),(config+0x30c,'active_bits'),(config+0x2ec,'time_offset_bits'),(instance+0x7c,'life_bits')]:write32(addr,int(timing[key],16))
 write32(scales+0xec,bits(1.));u.mem_write(instance+0x74,b'\1');bind(parameter);seed_rng(seed);initial=state()
 sp=stack+0x8000;write32(sp,end);write32(sp+4,bits(time));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x9345f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 count=u.reg_read(UC_X86_REG_EAX);count=count if count<0x80000000 else count-0x100000000
 return {'name':parameter['name'],'fields':parameter['fields'],'timing':{k:timing[k] for k in ('period_bits','active_bits','time_offset_bits','life_bits')},'time_bits':hex(bits(time)),'seed':seed,'initial_rng':initial,'rng':state(),'count':count,**trace}
scalar=json.loads((r/'data/4.20/complex_scalar_parameter_contract.json').read_text());timings=json.loads((r/'data/4.20/complex_emitter_timing_contract.json').read_text());lookup={c['name']:c for c in timings['cases']};profiles=[c for c in scalar['cases'] if c['name'].startswith('map:') and c['key']=='e-rate'];assert len(profiles)==27
cases=[]
for profile in profiles:
 timing=lookup[profile['name'].removesuffix(':e-rate')]
 for time,seed in itertools.product([-.1,0.,.01,.1,.5,1.,10.,100.],[0,42,0xffffffff]):cases.append(run(profile,timing,time,seed))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'0x9345f0','profiles':27,'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Existing original scalar reader/baker/probability captures and timing caller captures supply binary configuration. Rate-by-velocity table is zero and attribute flag4B8 disabled. Original entire count function, 949680 pair sampling, 948EE0 scalar sampling, probability interpolation and RNG execute.'],'limits':['Zero ratebyvel and disabled attribute-rate scope; config construction and owner/type scale sources not qualified here.','Full count uses x87 normalized-age arithmetic, not the SSE birth-age producer. Finite captured times/durations only.','Live counter/time updates, birth/lifecycle and ordinary graphical integration remain incomplete.']}
(r/'data/4.20/complex_full_count_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'cases':len(cases),'passed':True}))
