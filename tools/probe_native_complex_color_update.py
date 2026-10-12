"""Original939B94..939C47 age, live color sampling and stored birth multiplication."""
from pathlib import Path
import struct,json,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook;stop_address=None
def hook(uc,a,size,user):
 if a==stop_address:uc.emu_stop();return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
container=heap+0x1000;config=heap+0x2000;pairs=heap+0x3000;stored=heap+0x4000;table=heap+0x8000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
def bind(channels,colors):
 u.mem_write(config,b'\0'*0x600);write32(config+0x340,table);write32(config+0x344,table+len(colors)*16);u.mem_write(table,struct.pack('<'+'f'*(len(colors)*4),*(v for c in colors for v in c)))
 for channel,row in enumerate(channels):
  prob=heap+0x5000+channel*0x800;write32(config+0x34c+channel*4,prob if row else 0)
  if row:
   u.mem_write(prob,b'\0'*44);u.mem_write(prob,bytes([row['constant']]));write32(prob+4,int(row['constant_bits'],16));u.mem_write(prob+8,bytes([row['fast']]));write32(prob+12,int(row['begin_bits'],16));write32(prob+16,int(row['difference_bits'],16))
   for off,key in [(20,'times'),(32,'values')]:
    addr=prob+0x100+off*8;values=row[key];u.mem_write(addr,struct.pack('<'+'f'*len(values),*values));u.mem_write(prob+off,struct.pack('<3I',addr,addr+4*len(values),addr+4*len(values)))
def run(name,channels,colors,age_bits,seed,birth_color):
 global stop_address
 stop_address=None;u.mem_write(container,b'\0'*0x200);write32(container+4,pairs);write32(container+0x28,stored);write32(container+0xa0,config);write32(pairs,0);write32(pairs+4,bits(1.));u.mem_write(stored,struct.pack('<4f',*birth_color)+b'\0'*16);bind(channels,colors)
 sp=stack+0x8000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000);initial=state()
 sp=stack+0x7000;u.mem_write(sp,b'\0'*0x200);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_EAX,pairs);u.reg_write(UC_X86_REG_ECX,0);u.reg_write(UC_X86_REG_EDX,0);u.reg_write(UC_X86_REG_XMM3,0);u.reg_write(UC_X86_REG_XMM1,bits(1.));u.reg_write(UC_X86_REG_XMM4,age_bits);stop_address=0x939c47;u.emu_start(0x939b94,stop_address,count=100000);assert u.reg_read(UC_X86_REG_EIP)==stop_address
 return {'name':name,'channels':channels,'colors':colors,'time_bits':hex(age_bits),'seed':seed,'birth_color':birth_color,'initial_rng':initial,'rng':state(),'output_bits':[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(stored+16,16)))],'birth_after_bits':[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(stored,16)))]}
source=json.loads((r/'data/4.20/color_consumer_contract.json').read_text());profiles={row['name']:row['channels'] for row in source['cases']};cases=[]
ages=[bits(v) for v in [-.1,0.,.1,.5,1.,2.]]+[0x7fc01234,0x7f800000]
for (name,channels),count,age,seed,birth_color in itertools.product(profiles.items(),[1,3,16,256],ages,[42,0xffffffff],[[1.]*4,[-2.,0.,3.5,-.5]]):
 colors=[[f32(i*.1),f32(-i*.2),f32(i+.5),f32(.25-i*.01)] for i in range(count)];cases.append(run(name,channels,colors,age,seed,birth_color))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragment':['939B94','939C47'],'profiles':len(profiles),'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Legal per-particle birth/life pair and immutable stored birth color; lifetime color tables/probabilities from original reader captures supplied. Original age producer, whole949420 sampler/probability/RNG and multiplication/stores execute.'],'limits':['Container+A0configuration field340production/reader, distance modulation after939C47, rest of material/color update and ordinary renderer are unqualified.','Whole birth RNG ordering and owner/render sources remain incomplete.']}
(r/'data/4.20/complex_color_update_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'cases':len(cases),'passed':True}))
