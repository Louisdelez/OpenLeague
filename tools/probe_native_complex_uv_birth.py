"""Original shared fraction producer9360D8..9361FA and four UV consumers936C95..936D6E."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook;stop_address=None
def hook(uc,a,size,user):
 if a==stop_address:uc.emu_stop();return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
instance=heap+0x1000;emitter=heap+0x2000;global_config=heap+0x3000;frame=stack+0x9000
keys=['e-uvoffset','e-uvoffset-mult','p-uvscroll-rgb','p-uvscroll-rgb-mult']
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
def bind(slot,row,index):
 table=heap+0x10000+index*0x3000;values=[int(v,16) for v in row['table_bits']];u.mem_write(table,struct.pack('<'+'I'*len(values),*values));write32(slot,table);write32(slot+4,table+4*len(values))
 for axis,probability in enumerate(row['probabilities']):
  prob=table+0x1000+axis*0x800;write32(slot+12+axis*4,prob if probability else 0)
  if probability:
   u.mem_write(prob,b'\0'*44);u.mem_write(prob,bytes([probability['constant']]));write32(prob+4,int(probability['constant_bits'],16));u.mem_write(prob+8,bytes([probability['fast']]));write32(prob+12,int(probability['begin_bits'],16));write32(prob+16,int(probability['difference_bits'],16))
   for offset,key in [(20,'times'),(32,'values')]:
    address=prob+0x100+offset*8;v=probability[key];u.mem_write(address,struct.pack('<'+'f'*len(v),*v));u.mem_write(prob+offset,struct.pack('<3I',address,address+4*len(v),address+4*len(v)))
reader=json.loads((r/'data/4.20/complex_uv_readers_contract.json').read_text());profiles=[]
for name in dict.fromkeys(c['name'] for c in reader['cases']):
 rows=[next(c for c in reader['cases'] if c['name']==name and c['key']==key and c['prior_count']==0) for key in keys];fields={k:v for row in rows for k,v in row['fields'].items()};profiles.append({'name':name,'fields':fields,'rows':rows})
curves=json.loads((r/'data/4.20/probability_curve_contract.json').read_text());bell=next(c for c in curves['cases'] if c['name']=='bell');duplicates=next(c for c in curves['cases'] if c['name']=='duplicates')
generic=json.loads(json.dumps(next(p for p in profiles if p['name']=='constant')));generic['name']='composed:generic-probabilities';generic['fields']={}
for key,row in zip(keys,generic['rows']):
 generic['fields'][key]=[2.,3.];row['probabilities']=[bell,duplicates]
 for axis,curve in zip(['XP','YP'],[bell,duplicates]):
  for i,(t,v) in enumerate(zip(curve['times'],curve['values']),1):generic['fields'][key+axis+str(i)]=[t,v]
profiles.append(generic)
cases=[]
for profile,age,seed in itertools.product(profiles,[bits(v) for v in [-.1,0.,.1,.5,1.,2.]]+[0x7fc01234,0x7f800000],[42,0xffffffff]):
 stop_address=None;u.mem_write(instance,b'\0'*0x300);u.mem_write(emitter,b'\0'*0x600);u.mem_write(global_config,b'\0'*0x600);write32(instance+8,emitter);write32(emitter+0x374,global_config)
 for index,(target,offset) in enumerate([(emitter,0x25c),(emitter,0x274),(global_config,0x228),(global_config,0x294)]):bind(target+offset,profile['rows'][index],index)
 u.mem_write(frame-0x500,b'\0'*0x600);sp=stack+0x7000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000);initial=state()
 u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack+0x7000);stop_address=0x9361fa;u.emu_start(0x9360d8,stop_address,count=10000);assert u.reg_read(UC_X86_REG_EIP)==stop_address;shared=hex(read32(frame-0x3c));mid=state()
 write32(frame-0x1c,age);u.reg_write(UC_X86_REG_EDI,instance);stop_address=0x936d6e;u.emu_start(0x936c95,stop_address,count=100000);assert u.reg_read(UC_X86_REG_EIP)==stop_address and state()==mid
 output=[[hex(read32(frame+offset)),hex(read32(frame+offset+4))] for offset in [-0x324,-0x31c,-0x314,-0x30c]]
 cases.append({'name':profile['name'],'age_bits':hex(age),'seed':seed,'shared_parameter_bits':shared,'initial_rng':initial,'post_fraction_rng':mid,'rng':state(),'output_bits':output})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'profiles':profiles,'cases':cases,'fragments':['9360D8..9361FA','936C95..936D6E'],'adapters':['Four native UV reader tables/probability objects supplied; one extra generic profile composes already captured bell/duplicate probability objects with native constant UV table. Legal config/owner pointer graph and caller frame supplied.','Original inline RNG/fraction producer and four entire949680calls execute. One shared parameter supplied by native producer to all8axis evaluations; no math/RNG adapter.'],'limits':['Intervening birth stages between producer and UV consumers omitted; their draws/ordering and full birth lifecycle not qualified. Normalized emitter age source qualified separately.','Storage allocation and transfer of captured local UV values to particle buffers, owner configuration ownership and ordinary material/render binding remain incomplete.']}
(r/'data/4.20/complex_uv_birth_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'cases':len(cases),'actual_map_profiles':sum(p['name'].startswith('map:') for p in profiles),'passed':True}))
