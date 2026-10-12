"""Original RNG seed/bounded/fraction routines and full camera shake update."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'setup','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
result=heap+0x5000;shake=heap+0x6000;camera=heap+0x8000;stub=end+0x600;random_calls=0
u.mem_write(stub,b'\xdd\x15'+struct.pack('<I',result+8)+b'\xd9\x1d'+struct.pack('<I',result)+b'\xe9'+struct.pack('<i',end-(stub+17)))
def bits(values):return list(struct.unpack('<'+'I'*len(values),struct.pack('<'+'f'*len(values),*values)))
def rng_state():return {'words':list(struct.unpack('<55I',u.mem_read(0x2d6ec08,220))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
allowed=[(0x8e25c0,0x8e262b),(0x8e2630,0x8e2694),(0x8e26a0,0x8e2718),(stub,stub+17),(0x7d2be0,0x7d2e60),(0x66d6e0,0x66d72a)]
def hook(uc,a,size,user):
 global random_calls
 if a==0x8e26a0:random_calls+=1
 assert any(lo<=a<hi for lo,hi in allowed),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(start,args=[],ecx=0,float_return=False):
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),stub if float_return else end,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(start,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 return u.reg_read(UC_X86_REG_EAX)
def seed(value):run(0x8e2630,[value])
sequences=[]
for seed_value in [0,1,54,55,56,0x7fffffff,0x80000000,0xfffffffe,0xffffffff]:
 seed(seed_value);initial=rng_state();steps=[]
 for _ in range(16):
  for maximum in [None,0,1,55,0x80000000,0xffffffff]:
   if maximum is None:run(0x8e26a0,float_return=True);value={'fraction_bits':read32(result),'extended_bits':struct.unpack('<Q',u.mem_read(result+8,8))[0]}
   else:value={'bounded':run(0x8e25c0,[maximum])}
   steps.append({'maximum':maximum,**value,'state':rng_state()})
 sequences.append({'seed':seed_value,'initial':initial,'steps':steps})
initial_camera=bits([7000.,1500.,6600.,50.,5000.,0.,-.8,.6,0.,1.,0.,50.,0.,1000.,1000.,0.]);initial_camera[12]=0
cases=[]
for direction,duration,amplitude,frequency,active,next_time,seed_value in itertools.product([[0.,-.8,.6],[.4,-.8,.4],[0.,0.,0.],[0.,-1.,0.],[1.,0.,0.]],[0.,.3,2.],[0.,10.],[1.,10.],[0,2],[-1.,.2],[0,0xffffffff]):
 initial=bits([2.,99.,-3.,duration,.1,amplitude,next_time,frequency]);u.mem_write(shake,struct.pack('<8I',*initial)+bytes([active])+b'\x00'*3);words=initial_camera.copy();words[5:8]=bits(direction);u.mem_write(camera,struct.pack('<16I',*words));seed(seed_value);steps=[]
 for now in [0.,.1,.2,.4,1.,3.]:
  u.mem_write(0x2d78dfc,struct.pack('<f',now));random_calls=0;run(0x7d2be0,[camera],ecx=shake)
  steps.append({'now_bits':bits([now])[0],'shake_bits':list(struct.unpack('<8I',u.mem_read(shake,32))),'active_raw':u.mem_read(shake+0x20,1)[0],'camera_bits':list(struct.unpack('<16I',u.mem_read(camera,64))),'random_calls':random_calls,'rng':rng_state()})
 cases.append({'seed':seed_value,'initial_shake_bits':initial,'initial_active_raw':active,'initial_camera_bits':words,'steps':steps})
proof={'native_sha256':digest,'passed':True,'seed_table_words':list(struct.unpack('<55I',u.mem_read(0x10cf9a8,220))),'constants_bits':{hex(a):read32(a) for a in [0x1139280,0x113898c,0x1138cd4,0x1138bd4,0x1138990]},'rng_sequences':sequences,'shake_cases':cases,'complete':False,'limits':['Full8E2630 seed initializer,8E25C0 bounded generator and8E26A0 fractional generator execute without math/state adapters. Fraction capture writes the native x87 return to f64 andf32.','Full7D2BE0 active/inactive/expiry/renewal/basis/camera-position update executes with real RNG and reciprocal square root; clock and initial states supplied. No shake math adapters.','Original RNG table/index initialization callers and shared draw ordering across game systems still unqualified; explicit seeds are fixture inputs.','8E2720 is an allocator wrapper, not RNG seed initialization. Previous static followup inference corrected by decoding8E2630.','Shake triggering/native effect bindings and visible game integration remain incomplete. Camera near/far/default/input qualifications retain their existing limits.']}
(r/'data/4.20/camera_random_shake_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native RNG/shake',len(sequences),sum(len(c['steps']) for c in sequences),len(cases),sum(len(c['steps']) for c in cases))
