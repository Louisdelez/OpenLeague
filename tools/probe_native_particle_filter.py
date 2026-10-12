from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native sampler setup','exec'))
cases=[]
for cached in [0xffffffff,0]:
 for stage in range(3):
  for key in range(8):write32(wrapper+0x164+(stage*8+key)*4,cached)
 calls.clear();u.reg_write(UC_X86_REG_ESP,sp)
 u.emu_start(0x93cf80,0x93d098,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x93d098
 u.emu_start(0x9310b5,0x93115c,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x93115c
 cases.append(dict(initial_cached=cached,calls=list(calls),stage0_cached=[read32(wrapper+0x164+i*4) for i in range(8)]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,ranges=[['0x93cf80','0x93d098'],['0x9310b5','0x93115c']],cases=cases,runtime_adapters=['D3D9 SetSamplerState API boundary records and returns S_OK.','Stack-cookie check returns without comparison.'],limits=['Common particle manager sampler setup followed by projected addressing segment executes; later authored pixelate/variant overrides not qualified.','Stage0native MAG/MIN are LINEAR2, MIPFILTER is NONE0 and addressing CLAMP3; no native GPU rendered.','WGPU mip selection must be disabled explicitly if multiple levels are later loaded; existing PNG has a single level.'])
(r/'data/4.20/particle_filter_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(proof['cases']))
