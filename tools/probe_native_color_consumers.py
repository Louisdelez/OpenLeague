"""Original949550 RGBA birth multipliers and949420 table/probability sampling."""
from pathlib import Path
import json,struct,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0];exec(compile(setup,'native setup','exec'))
data=json.loads((r/'data/4.20/probability_curve_contract.json').read_text());full=json.loads((r/'data/4.20/complex_color_contract.json').read_text());get=lambda name:next(c for c in data['cases'] if c['name']==name)
profiles=[('null',[None]*4),('constants',[get('constant')]*4),('all-curves',[get('linear'),get('bell'),get('duplicates'),get('single-point')]),('mixed',[get('constant'),get('bell'),None,get('linear')]),('reversed',[get('map:TT_Ghosts_01.troy:TT_Ghost:p-lifeP'),get('single-point'),get('linear'),None])]
profiles.extend((c['name'],c['probabilities']) for c in full['cases'] if c['prior_count']==0 and any(p and not p['constant'] for p in c['probabilities']))
colorobj=heap+0x1000;out=heap+0x1800;table=heap+0x8000
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
def seed_rng(seed):
 sp=stack+0x8000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
def bind(channels):
 u.mem_write(colorobj,b'\0'*32)
 for channel,row in enumerate(channels):
  prob=heap+0x3000+channel*0x800;write32(colorobj+12+4*channel,prob if row else 0)
  if row:
   u.mem_write(prob,b'\0'*44);u.mem_write(prob,bytes([row['constant']]));write32(prob+4,int(row['constant_bits'],16));u.mem_write(prob+8,bytes([row['fast']]));write32(prob+12,int(row['begin_bits'],16));write32(prob+16,int(row['difference_bits'],16))
   for offset,key in [(20,'times'),(32,'values')]:
    addr=prob+0x100+offset*8;values=row[key];u.mem_write(addr,struct.pack('<'+'f'*len(values),*values));u.mem_write(prob+offset,struct.pack('<3I',addr,addr+4*len(values),addr+4*len(values)))
cases=[];samples=[]
for name,channels in profiles:
 bind(channels)
 for seed in [0,42,0x80000000,0xffffffff]:
  for input_color in [[1.]*4,[-2.,0.,3.5,-.5]]:
   seed_rng(seed);initial=state();steps=[]
   for i in range(8):
    sp=stack+0x8000;write32(sp,end);write32(sp+4,out);u.mem_write(sp+8,struct.pack('<4f',*input_color));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,colorobj);u.emu_start(0x949550,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
    steps.append({'output_bits':[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(out,16)))],'rng':state()})
   cases.append({'name':name,'channels':channels,'seed':seed,'base':input_color,'initial_rng':initial,'steps':steps})
 for count in [1,3,16,256]:
  colors=[[f32(i*.1),f32(-i*.2),f32(i+.5),f32(.25-i*.01)] for i in range(count)];u.mem_write(table,struct.pack('<'+'f'*(count*4),*(v for rgba in colors for v in rgba)));write32(colorobj,table);write32(colorobj+4,table+count*16)
  age_bits=[struct.unpack('<I',struct.pack('<f',v))[0] for v in [-.1,0.,.25,.5,.99999,1.,1.1]]+[0x80000000,0x7fc00000,0x7f800000,0xff800000,0x7f7fffff,0xff7fffff]
  for age in age_bits:
   for seed in [42,0xffffffff]:
    seed_rng(seed);initial=state();steps=[]
    for i in range(2):
     sp=stack+0x8000;write32(sp,end);write32(sp+4,out);write32(sp+8,age);write32(sp+12,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,colorobj);u.emu_start(0x949420,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
     steps.append({'output_bits':[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(out,16)))],'rng':state()})
    samples.append({'name':name,'channels':channels,'count':count,'colors':colors,'age_bits':hex(age),'seed':seed,'initial_rng':initial,'steps':steps})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'birth_entry':'0x949550','sample_entry':'0x949420','cases':cases,'samples':samples,'original_instruction_addresses':len(visited),'adapters':['Probability objects supplied from original reader captures. Native RNG seed/state, complete RGBA birth loop, baked selection and complete RGBA sampled probability loop execute without RNG/math adapters.'],'limits':['Actual lifecycle call sites not qualified: the table sampler draws each call for variable channels, while the birth helper produces stored multipliers. Do not conflate these paths in the renderer.','Normalized-age producer, actual color update using stored factors, ownership and ordinary graphical integration remain pending.']}
(r/'data/4.20/color_consumer_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'birth_cases':len(cases),'birth_steps':sum(len(c['steps']) for c in cases),'sample_cases':len(samples),'sample_steps':sum(len(c['steps']) for c in samples),'passed':True}))
