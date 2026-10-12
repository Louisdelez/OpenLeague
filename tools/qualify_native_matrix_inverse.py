"""Execute full original8DEC10; preserve explicit global singular fallback input."""
from pathlib import Path
import json,struct,itertools,random,hashlib
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'));matrix=heap+0x6000;used_fallback=False

def hook(uc,a,size,user):
 global used_fallback
 if a==0x8df15e:used_fallback=True
 assert 0x8dec10<=a<=0x8df16e or 0x8de480<=a<=0x8de4f1 or 0x8de500<=a<=0x8de567,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def words(values):return list(struct.unpack('<16I',struct.pack('<16f',*values)))
identity=words([1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]);zero=[0]*16
inputs={}
for filename in ['camera_view_contract.json','camera_projection_contract.json']:
 proof=json.loads((r/'data/4.20'/filename).read_text(encoding='utf-8'))
 for i,c in enumerate(proof['cases']):inputs.setdefault(tuple(c['matrix_bits']),{'source':filename,'case':i})
rng=random.Random(420)
for i in range(64):inputs.setdefault(tuple(words([rng.uniform(-10.,10.) for _ in range(16)])),{'source':'synthetic general matrix','case':i})
threshold=read32(0x11389ac)
for value in [0,threshold-1,threshold,threshold+1,0x80000000,0x7fc00000,0x7f800000,0xff800000]:
 raw=identity[:];raw[0]=value;inputs.setdefault(tuple(raw),{'source':'determinant boundary/exceptional','first_word':value})
inputs.setdefault(tuple(zero),{'source':'zero singular matrix'})
duplicate=identity[:];duplicate[4:8]=duplicate[0:4];inputs.setdefault(tuple(duplicate),{'source':'duplicate rows'})
fallbacks=[identity,zero,words([float(i-7) for i in range(16)])];cases=[]
for (bits,origin),fallback in itertools.product(inputs.items(),fallbacks):
 u.mem_write(matrix,struct.pack('<16I',*bits));u.mem_write(0x2d77410,struct.pack('<16I',*fallback));used_fallback=False
 sp=stack+0x7000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,matrix);u.emu_start(0x8dec10,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)==matrix
 output=list(struct.unpack('<16I',u.mem_read(matrix,64)))
 if used_fallback:assert output==fallback
 cases.append({'origin':origin,'input_bits':list(bits),'fallback_bits':fallback,'used_fallback':used_fallback,'output_bits':output})
proof={'native_sha256':digest,'passed':True,'determinant_threshold_bits':threshold,'cases':cases,'source_contracts_sha256':{name:hashlib.sha256((r/'data/4.20'/name).read_bytes()).hexdigest() for name in ['camera_view_contract.json','camera_projection_contract.json']},'complete':False,'limits':['Full8DEC10 plus original8DE480/8DE500 executed; no math adapters.','Global2D77410 singular fallback supplied as explicit input in three variants; its runtime initialization remains unqualified.','Source camera matrices and synthetic general/boundary/exceptional inputs are arithmetic fixtures, not runtime rendering evidence.']}
(r/'data/4.20/matrix_inverse_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original full inverse: {len(inputs)} matrices, {len(cases)} cases; {sum(c["used_fallback"] for c in cases)} fallback cases')
