"""Original93C37A..93C3C5 consumer with original8E2630/8E26A0 RNG."""
from pathlib import Path
import json,struct,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text(encoding='utf-8').split('\ninputs=')[0];exec(compile(setup,'probability setup','exec'))
data=json.loads((r/'data/4.20/probability_curve_contract.json').read_text());names=['absent','constant','linear','bell','duplicates','single-point','map:TT_Ghosts_01.troy:TT_Ghost:p-lifeP'];cases=[]
def state():return {'words':list(struct.unpack('<55I',bytes(u.mem_read(0x2d6ec08,220)))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
for name in names+['null']:
 row=next((v for v in data['cases'] if v['name']==name),None)
 u.mem_write(obj,b'\0'*44)
 if row:
  u.mem_write(obj,bytes([row['constant']]));write32(obj+4,int(row['constant_bits'],16));u.mem_write(obj+8,bytes([row['fast']]));write32(obj+12,int(row['begin_bits'],16));write32(obj+16,int(row['difference_bits'],16))
  for vector,key in [(20,'times'),(32,'values')]:
   address=heap+0x6000+vector*0x100;values=row[key];u.mem_write(address,struct.pack('<'+'f'*len(values),*values));u.mem_write(obj+vector,struct.pack('<3I',address,address+4*len(values),address+4*len(values)))
 for seed in [0,42,0x80000000,0xffffffff]:
  for scale in [-2.,0.,3.5]:
   sp=stack+0x8000;write32(sp,end);write32(sp+4,seed);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x8e2630,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;initial=state();steps=[]
   for index in range(8):
    sp=stack+0x8000;u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,stack+0x4000);u.reg_write(UC_X86_REG_EDI,0 if row is None else obj);u.reg_write(UC_X86_REG_XMM1,struct.unpack('<I',struct.pack('<f',scale))[0]);u.emu_start(0x93c37a,0x93c3c5,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x93c3c5;steps.append({'output_bits':hex(u.reg_read(UC_X86_REG_XMM1)&0xffffffff),'rng':state()})
   cases.append({'name':name,'seed':seed,'scale':scale,'initial_rng':initial,'steps':steps})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'consumer_start':'0x93c37a','consumer_stop':'0x93c3c5','rng_entries':['0x8e2630','0x8e26a0'],'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Probability objects supplied from original reader capture; existing heap/cookie transport adapters retained but no RNG/math adapter. Consumer branches, RNG seed/state advances, x87 fraction, fast SSE multiply/add, original generic evaluator and base multiplication execute.'],'limits':['Caller parameter binding and age input before consumer fragment, vector/color handling and ordinary emitter activation/rendering remain incomplete.','Null, constant and explicit seeded finite cases qualified; no arbitrary clock/global call-order parity claimed.']};(r/'data/4.20/probability_random_consumer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'steps':sum(len(c['steps']) for c in cases),'native_addresses':len(visited),'passed':True}))
