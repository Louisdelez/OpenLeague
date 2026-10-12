from pathlib import Path
import json,struct
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_legacy_paths.py').read_text().split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(setup,'lookup harness','exec'))
component=heap+0x1000;wrapper=heap+0x2000;state=heap+0x2100;skeleton=heap+0x3000;poses=heap+0x4000;output=heap+0x5000
source=json.loads((r/'docs/map_ambient_source_validation.json').read_text())
model=next(x for x in source['models'] if x['native_asset']=='TT_Chains_Bot_Lane')
rig=next(Path(x['path']) for x in model['sources'] if Path(x['path']).suffix.lower()=='.skl')
rig_bytes=rig.read_bytes();assert b'Chain4_3' in rig_bytes and b'Chain4-3' not in rig_bytes
hashes={name:native_hash(name) for name in ['Chain4_3','Chain4-3','chain4_3','chain4-3']}
assert hashes['Chain4_3']!=hashes['Chain4-3']
u.mem_write(component,bytes(0x100));write32(component+0x20,wrapper);write32(wrapper+0x10,state);write32(state+0x1c,skeleton);write32(state+8,poses)
u.mem_write(skeleton,bytes(0x200));u.mem_write(skeleton+0xe,struct.pack('<H',1));write32(skeleton+0x14,0x40);write32(skeleton+0x18,0x100);write32(skeleton+0x100,0);write32(skeleton+0x104,hashes['Chain4_3'])
values=[11.,22.,33.,0.,0.,0.,1.,1.,1.,1.];u.mem_write(poses,struct.pack('<10f',*values));rows=[]
for name,h in hashes.items():
 u.mem_write(output,b'\xa5'*40);sp=stack+0x8000;write32(sp,end);write32(sp+4,h);write32(sp+8,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,component)
 u.emu_start(0x886df0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 ok=u.reg_read(UC_X86_REG_EAX)&255;expected='_' in name;assert bool(ok)==expected
 actual=bytes(u.mem_read(output,40));assert actual==(struct.pack('<10f',*values) if expected else b'\xa5'*40)
 rows.append(dict(name=name,hash=h,found=bool(ok),output_words=list(struct.unpack('<10I',actual))))
proof=dict(passed=True,complete=False,native_sha256=digest,rig=str(rig),rig_sha256=hashlib.sha256(rig_bytes).hexdigest(),cases=rows,entries=['8E45D0','886DF0','894730','899910'],adapters=['Supplied one-entry skeleton lookup table for actual source name Chain4_3 and10float pose; original hash, binary search and signed-index pose fetch execute without stubs.'],limits=['One-entry table proves naming/failure behavior, not full skeleton binary loading or per-bone animation fidelity.'])
(r/'data/4.20/chain_bone_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'original hash/lookup/pose cases; hyphen remains missing, underscore resolves')
