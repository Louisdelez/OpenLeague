"""Original9492F0 birth variation and93C21F..93C2BA age/vector multiplication."""
from pathlib import Path
import json,struct,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text(encoding='utf-8').split('\ninputs=')[0];exec(compile(setup,'native setup','exec'))
data=json.loads((r/'data/4.20/probability_curve_contract.json').read_text());full=json.loads((r/'data/4.20/vector_parameter_contract.json').read_text());get=lambda name:next(c for c in data['cases'] if c['name']==name)
profiles=[('null',[None,None,None]),('constants',[get('constant')]*3),('all-curves',[get('linear'),get('bell'),get('duplicates')]),('mixed',[get('constant'),get('bell'),None]),('reversed',[get('map:TT_Ghosts_01.troy:TT_Ghost:p-lifeP'),get('single-point'),get('linear')])]
profiles.extend((c['name'],c['probabilities']) for c in full['cases'] if c['returned'] and any(not p['constant'] for p in c['probabilities']))
vectorobj=heap+0x1000;out=heap+0x1800;instance=heap+0x1900;table=heap+0x8000
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
cases=[]
for name,axes in profiles:
 u.mem_write(vectorobj,b'\0'*28)
 for axis,row in enumerate(axes):
  prob=heap+0x3000+axis*0x800;write32(vectorobj+12+4*axis,prob if row else 0)
  if row:
   u.mem_write(prob,b'\0'*44);u.mem_write(prob,bytes([row['constant']]));write32(prob+4,int(row['constant_bits'],16));u.mem_write(prob+8,bytes([row['fast']]));write32(prob+12,int(row['begin_bits'],16));write32(prob+16,int(row['difference_bits'],16))
   for offset,key in [(20,'times'),(32,'values')]:
    addr=prob+0x100+offset*8;values=row[key];u.mem_write(addr,struct.pack('<'+'f'*len(values),*values));u.mem_write(prob+offset,struct.pack('<3I',addr,addr+4*len(values),addr+4*len(values)))
 for seed in [0,42,0x80000000,0xffffffff]:
  for input_vector in [[1.,1.,1.],[-2.,0.,3.5]]:
   sp=stack+0x8000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;initial=state();steps=[]
   for i in range(8):
    sp=stack+0x8000;write32(sp,end);write32(sp+4,out);u.mem_write(sp+8,struct.pack('<3f',*input_vector));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,vectorobj);u.emu_start(0x9492f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;steps.append({'output_bits':[hex(v) for v in struct.unpack('<3I',bytes(u.mem_read(out,12)))],'rng':state()})
   cases.append({'name':name,'axes':axes,'seed':seed,'base':input_vector,'initial_rng':initial,'steps':steps})
# The frame-update fragment consumes supplied birth multipliers; no RNG call here.
updates=[]
for count in [1,3,16,256]:
 vectors=[[f32(i*.1),f32(-i*.2),f32(i+.5)] for i in range(count)];u.mem_write(table,struct.pack('<'+'f'*(count*3),*(v for xyz in vectors for v in xyz)));write32(vectorobj,table);write32(vectorobj+4,table+count*12);write32(instance,vectorobj)
 for age in [-.1,0.,.25,.5,.99999,1.,1.1]:
  for multiplier in [[1.,1.,1.],[-2.,0.,3.5]]:
   u.mem_write(instance+4,struct.pack('<3f',*multiplier));sp=stack+0x8000;write32(sp+12,0);u.reg_write(UC_X86_REG_EBP,sp);u.mem_write(sp+12,struct.pack('<f',age));u.reg_write(UC_X86_REG_ESP,stack+0x6000);u.reg_write(UC_X86_REG_ESI,instance);u.reg_write(UC_X86_REG_XMM4,struct.unpack('<I',struct.pack('<f',age))[0]);before=state();u.emu_start(0x93c21f,0x93c2ba,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x93c2ba and before==state();updates.append({'count':count,'vectors':vectors,'age':age,'multiplier':multiplier,'output_bits':[hex(v) for v in struct.unpack('<3I',bytes(u.mem_read(instance+16,12)))]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'birth_entry':'0x9492f0','update_start':'0x93c21f','update_stop':'0x93c2ba','cases':cases,'updates':updates,'original_instruction_addresses':len(visited),'adapters':['Probability objects supplied from original reader captures. Original birth loop, RNG, generic/fast probability evaluation, table indexing and frame multiplication execute; no RNG/math adapter.'],'limits':['Native ownership/lifecycle call sites and normalized-age source not qualified. Rotation-mode bake and ordinary Map10 rendering still pending.','Update fragment stops before postoffset addition and later scalar/life consumers. Finite ages tested here; scalar selector previously qualified nonfinite conversion.']};(r/'data/4.20/vector_instance_consumer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'birth_cases':len(cases),'birth_steps':sum(len(c['steps']) for c in cases),'update_cases':len(updates),'native_addresses':len(visited),'passed':True}))
