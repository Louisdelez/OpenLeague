"""Native birth age/table selection, inline p-life probability and life finalizer."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0];exec(compile(setup,'native setup','exec'))
instance=heap+0x1000;config=heap+0x2000;owner=heap+0x3000;prob=heap+0x6000;table=heap+0x8000;frame=stack+0x8000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
def start(address,stop):
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.reg_write(UC_X86_REG_EDI,instance);u.emu_start(address,stop,count=100000);assert u.reg_read(UC_X86_REG_EIP)==stop
def bind(parameter):
 values=[int(b,16) for b in parameter['table_bits']];u.mem_write(table,struct.pack('<'+'I'*len(values),*values));write32(config+0xd8,table);write32(config+0xdc,table+4*len(values));write32(config+0xe4,prob)
 probability=parameter['probability'];u.mem_write(prob,b'\0'*44);u.mem_write(prob,bytes([probability['constant']]));write32(prob+4,int(probability['constant_bits'],16));u.mem_write(prob+8,bytes([probability['fast']]));write32(prob+12,int(probability['begin_bits'],16));write32(prob+16,int(probability['difference_bits'],16))
 for offset,key in [(20,'times'),(32,'values')]:
  addr=prob+0x100+offset*8;values=probability[key];u.mem_write(addr,struct.pack('<'+'f'*len(values),*values));u.mem_write(prob+offset,struct.pack('<3I',addr,addr+4*len(values),addr+4*len(values)))
def run(parameter,time_bits,seed,with_modifiers):
 u.mem_write(instance,b'\0'*0x300);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200);write32(instance+8,config);write32(instance+4,owner)
 for addr in (config+0x308,config+0x30c,instance+0x7c):write32(addr,bits(1.))
 write32(frame+8,time_bits);write32(owner+0x80,bits(2.));write32(frame-0x14c,0);u.mem_write(config+0xec,bytes([with_modifiers]));write32(config+0x304,7)
 for axis,val in enumerate([-2.,3.,-4.]):write32(frame-0x7c+axis*4,bits(val))
 coefficients=[.2,-.5,1.] if with_modifiers else [0.,0.,0.]
 for axis,val in enumerate(coefficients):write32(config+0x2f5+axis*4,bits(val))
 bind(parameter);sp=stack+0x8000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000);initial=state()
 start(0x93488c,0x934930);age=hex(read32(frame-0x1c));base_life=hex(read32(frame-0xd8));u.reg_write(UC_X86_REG_ESI,config);u.reg_write(UC_X86_REG_XMM0,0)
 start(0x9355c2,0x9356a6);sampled=hex(read32(frame-0x34));start(0x935d2e,0x935e4b)
 return {'name':parameter['name'],'fields':parameter['fields'],'time_bits':hex(time_bits),'seed':seed,'with_modifiers':with_modifiers,'coefficients':coefficients,'age_bits':age,'base_life_bits':base_life,'sampled_life_bits':sampled,'final_life_bits':hex(read32(frame-0x34)),'initial_rng':initial,'rng':state()}
scalar=json.loads((r/'data/4.20/complex_scalar_parameter_contract.json').read_text());profiles=[c for c in scalar['cases'] if c['name'].startswith('map:') and c['key']=='p-life'];assert len(profiles)==27
ages=[bits(v) for v in [-.1,0.,.1,.25,.5,.75,1.,2.]]+[0x80000000,0x7f800000,0xff800000,0x7fc01234,0x7f7fffff]
cases=[]
for parameter,time,seed,modifiers in itertools.product(profiles,ages,[42,0xffffffff],[False,True]):cases.append(run(parameter,time,seed,modifiers))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragments':['93488C..934930','9355C2..9356A6','935D2E..935E4B'],'profiles':27,'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Original scalar reader/baker captures supply p-life tables and probability structures. Legal owner/configuration and caller locals supplied. Native age producer, life table selection, complete inline p-life RNG/probability arithmetic and final life modifiers execute.'],'limits':['Intervening birth fields and their random draws excluded: full birth draw order is not qualified. Attribute p-life4F8 branch disabled.','Life modifiers supplied explicitly; their raw configuration readers and owner scale sources are not qualified by this probe.','Actual particle storage/update and ordinary graphical rendering remain incomplete.']}
(r/'data/4.20/complex_birth_life_probability_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'cases':len(cases),'passed':True}))
