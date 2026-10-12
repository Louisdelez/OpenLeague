"""Original5657E0 cached entity position update, including diagnostics and IEEE copies."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_camera_random_shake.py').read_text(encoding='utf-8').split('sequences=[]')[0],'setup','exec'))
allowed.extend([(0x5657e0,0x565864),(0x991e60,0x991e61)])
frame=heap+0x6000;vector=heap+0x9000;warnings=[];wrote=False
def warning_hook(uc,a,size,user):
 global wrote
 if a==0x56584f:wrote=True
 if a==0x991e60:
  sp=u.reg_read(UC_X86_REG_ESP);warnings.append([read32(sp+4+i*4) for i in range(5)]);finish(eax=0)
u.hook_add(unicorn.UC_HOOK_CODE,warning_hook)
eps=read32(0x11389a0);minus=read32(0x11392b8);lower=read32(0x11393a0);upper=read32(0x1139278)
xs=[0,0x80000000,eps,eps+1,minus,minus+1,lower,upper,0x7f800000,0xff800000,0x7fc01234,0x7fa01234]
zs=[0,0x80000000,eps,eps+1,minus,minus+1,0x7fc01234,0x7fa01234]
ys=[0,0x42480000,0x7fc01234,0x7fa01234]
initial_matrix=[0xdeadbeef,0x7fa12345]+[0xa5a5a5a5]*14
cases=[]
for x,y,z,old in itertools.product(xs,ys,zs,[[0x3f800000,0x40000000,0x40400000],[0x7fa77777,0x80000000,0xff800000]]):
 initial=initial_matrix+old;u.mem_write(frame,struct.pack('<19I',*initial));u.mem_write(vector,struct.pack('<3I',x,y,z));warnings=[];wrote=False;run(0x5657e0,[vector],frame)
 out=list(struct.unpack('<19I',u.mem_read(frame,76)));assert out[:16]==initial[:16]
 assert len(warnings)<=1
 if warnings:assert warnings[0]==[0x1086440,0x1085b2d,0,0x1085b2d,0x1085b2d]
 cases.append({'input_position_bits':[x,y,z],'initial_frame_bits':initial,'output_frame_bits':out,'warning':bool(warnings),'wrote_position':wrote})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'constants_bits':{hex(a):read32(a) for a in [0x11393a0,0x1139278,0x11389a0,0x11392b8]},'limits':['Full5657E0 executes actual comparisons and stores.991E60 diagnostic logger is an adapter recording all5arguments; actual logger output not qualified.','Stores at matrix receiver40/44/48 are position cache following64byte matrix, not matrix translation row30/34/38. Matrix64bytes stay bitwise unchanged.','Strict Â±1e9 X diagnostic bounds; cache update skipped only when X/Z both lie in inclusiveÂ±1e-6 square; Y ignored for this gate. NaN follows original unordered comparisons.','X MOVSS preserves rawbits; Y/Z use x87 FLD/FSTP. Unicorn signaling NaN copy differs from host CPU; see separatehardwareprobe. Actual world movement writer and client activation remain incomplete.']}
(r/'data/4.20/entity_position_cache_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native position cache:',len(cases),'cases')
