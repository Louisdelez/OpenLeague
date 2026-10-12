"""Qualify full native565910 mode3 and polynomial sin/cos helpers."""
from pathlib import Path
import json,struct,itertools,random
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_camera_random_shake.py').read_text(encoding='utf-8').split('sequences=[]')[0],'setup','exec'))
allowed.extend([(0x565910,0x565c9e),(0x8e1f40,0x8e2109),(end+0x700,end+0x701)])
entity=heap+0x9000;state=heap+0x6000;matrix=heap+0xb000;vtable=heap+0xc000;callback=end+0x700;write32(0x2d77f48,entity);write32(entity+0x3e0,vtable);write32(vtable+0x20,callback)
calls=[]
def service_hook(uc,a,size,user):
 if a==callback:
  assert u.reg_read(UC_X86_REG_ECX)==entity+0x3e0;calls.append('entity matrix virtual20');finish(eax=matrix)
u.hook_add(unicorn.UC_HOOK_CODE,service_hook)
trig=[]
values=[0.,-0.,.1,-.1,1.5707963,-1.5707963,3.1415927,-3.1415927,6.2831853,-6.2831853,10.,-10.]+[i*.03125 for i in range(-128,129)]
for v in values:
 row={'input_bits':bits([v])[0]}
 for address,key in [(0x8e1f40,'sin_bits'),(0x8e2030,'cos_bits')]:run(address,[row['input_bits']],float_return=True);row[key]=read32(result)
 trig.append(row)
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
matrices=[identity,[0.,0.,1.,0.,0.,1.,0.,0.,-1.,0.,0.,0.,0.,0.,0.,1.],[1.,.1,.2,0.,-.3,2.,.4,0.,.5,-.6,3.,0.,10.,-20.,30.,1.],[0.]*16]
initial=bits([1.,2.,3.,50.,5000.,0.,0.,1.,0.,1.,0.,103.,0.,1000.,1000.,0.]);initial[12]=2;initial[15]=0xdeadbeef
cases=[]
for angles,distances,position,transform in itertools.product([[0.,0.],[45.,56.],[-90.,-30.],[180.,89.],[360.,-180.]],[[0.,0.,0.],[20.,3.,40.],[-15.,7.,0.]],[[0.,0.,0.],[7000.,50.,8000.]],matrices):
 fields=angles+distances;u.mem_write(state,struct.pack('<5f',*fields));u.mem_write(entity+0x60,struct.pack('<3f',*position));u.mem_write(matrix,struct.pack('<16f',*transform));u.mem_write(camera,struct.pack('<16I',*initial));calls=[]
 run(0x565910,[camera],state);assert len(calls)==1
 cases.append({'state_bits':bits(fields),'entity_position_bits':bits(position),'matrix_bits':bits(transform),'initial_camera_bits':initial,'output_camera_bits':list(struct.unpack('<16I',u.mem_read(camera,64)))})
constants=[0x1138a68,0x1138d2c,0x1138eac,0x11392ac,0x11389a8,0x11389e0,0x1138a4c,0x1138b10,0x1138c74,0x11392b0,0x11389c0,0x1138a1c,0x1138a94,0x1138ba4,0x1138990]
proof={'native_sha256':digest,'passed':True,'complete':False,'trig_cases':trig,'cases':cases,'constants_bits':{hex(a):read32(a) for a in constants},'limits':['Full565910 and original8E1F40/8E2030/66D6E0 execute without math adapters. Entity matrix virtual20 supplies explicit16float matrix; world/entity matrix producer and mode/input bindings not qualified.','Polynomial helpers do not perform generic periodic angle wrapping: preserve original branch/order/sign behavior instead of replacing by standard sin/cos.','Mode3 sets far25000/FOV50, preserves projection mode/near/up/dimensions/auxiliary, applies no7D2BE0 shake call. Whole58C8B0 renderer sequence remains incomplete.']}
(r/'data/4.20/camera_angles_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native angle camera:',len(cases),'builders,',len(trig),'sin/cos pairs')
