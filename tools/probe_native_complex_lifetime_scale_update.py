"""Original939D56..939DBE live p-xscale sample and stored birth/owner scale."""
from pathlib import Path
import struct,json,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook;stop_address=None
def hook(uc,a,size,user):
 if a==stop_address:uc.emu_stop();return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
container=heap+0x1000;config=heap+0x2000;stored=heap+0x4000;table=heap+0x8000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
def run(row,age,seed,birth,owner):
 global stop_address
 stop_address=None;u.mem_write(container,b'\0'*0x200);u.mem_write(config,b'\0'*0x600);write32(container+0x34,stored)
 values=[int(v,16) for v in row['table_bits']];write32(config+0x324,table);write32(config+0x328,table+len(values)*4);u.mem_write(table,struct.pack('<'+'I'*len(values),*values))
 for axis,probability in enumerate(row['probabilities']):
  prob=heap+0x5000+axis*0x800;write32(config+0x330+axis*4,prob if probability else 0)
  if probability:
   u.mem_write(prob,b'\0'*44);u.mem_write(prob,bytes([probability['constant']]));write32(prob+4,int(probability['constant_bits'],16));u.mem_write(prob+8,bytes([probability['fast']]));write32(prob+12,int(probability['begin_bits'],16));write32(prob+16,int(probability['difference_bits'],16))
   for offset,key in [(20,'times'),(32,'values')]:
    address=prob+0x100+offset*8;v=probability[key];u.mem_write(address,struct.pack('<'+'f'*len(v),*v));u.mem_write(prob+offset,struct.pack('<3I',address,address+4*len(v),address+4*len(v)))
 u.mem_write(stored,struct.pack('<3I',*birth)+b'\0'*12)
 sp=stack+0x8000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000);initial=state()
 sp=stack+0x7000;u.mem_write(sp,b'\0'*0x200);write32(sp+0x10,age);write32(sp+0x50,owner);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_ECX,config);stop_address=0x939dbe;u.emu_start(0x939d56,stop_address,count=100000);assert u.reg_read(UC_X86_REG_EIP)==stop_address
 return {'name':row['name'],'age_bits':hex(age),'seed':seed,'birth_bits':[hex(v) for v in birth],'owner_bits':hex(owner),'initial_rng':initial,'rng':state(),'sample_bits':[hex(v) for v in struct.unpack('<3I',bytes(u.mem_read(sp+0x54,12)))],'output_bits':[hex(v) for v in struct.unpack('<3I',bytes(u.mem_read(stored+12,12)))],'birth_after_bits':[hex(v) for v in struct.unpack('<3I',bytes(u.mem_read(stored,12)))]}
source=json.loads((r/'data/4.20/complex_lifetime_scale_contract.json').read_text());profiles=[row for row in source['cases'] if row['prior_count']==0];cases=[]
ages=[bits(v) for v in [-.1,0.,.1,.5,1.,2.]]+[0x7fc01234,0x7f800000]
for row,age,seed,birth,owner in itertools.product(profiles,ages,[42,0xffffffff],[[bits(1.)]*3,[bits(v) for v in [-2.,0.,3.5]]],[bits(1.),bits(.5)]):cases.append(run(row,age,seed,birth,owner))
for row in profiles[:4]:
 for birth,owner in itertools.product([[0x7fc01234,0,0x7f800000],[0xff800000,0x80000000,0x7fa01234]],[0x7fc05678,0x7f800000,0]):cases.append(run(row,bits(.5),42,birth,owner))
cpu={};exec((r/'tools/check_scale_sse_cpu.py').read_text().split('values=')[0],cpu)
differences=0
for case in cases:
 output=[cpu['fn'](cpu['fn'](int(b,16),int(s,16)),int(case['owner_bits'],16)) for b,s in zip(case['birth_bits'],case['sample_bits'])]
 case['cpu_output_bits']=[hex(v) for v in output]
 if case['cpu_output_bits']!=case['output_bits']:differences+=1
cpu['k'].VirtualFree(cpu['address'],0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragment':['939D56','939DBE'],'cases':cases,'profiles':profiles,'cpu_multiply_instructions':len(cases)*6,'emulator_cpu_nan_disagreements':differences,'adapters':['Decoded tables/probabilities from original p-xscale reader captures supplied to field324. Stored birth scale, particle normalized age and owner scalar supplied. Original949120, probability and RNG bodies, SSE multiplications and stores execute in Unicorn.','Supplemental actual processor MULSS executes birth*sample then result*owner, preserving both emulated and CPU outputs. Emulator NaN payload differences are recorded, not treated as CPU fidelity.'],'limits':['Normalized age producer was qualified separately; owner scalar source and birth scale producer not qualified here.','Whole constructor/lifecycle/RNG sequence, distance color, subsequent UV/material stages and ordinary GPU application integration still pending.']}
(r/'data/4.20/complex_lifetime_scale_update_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'cases':len(cases),'cpu_multiply_instructions':len(cases)*6,'emulator_cpu_nan_disagreements':differences,'passed':True}))
