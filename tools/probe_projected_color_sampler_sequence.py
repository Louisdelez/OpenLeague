from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text().split('cases=[]')[0],'native sampler setup','exec'))
rows=[]
for sentinel in [0,0xffffffff,0x12345678]:
 for stage in range(16):
  for key in range(8):write32(wrapper+0x164+(stage*8+key)*4,sentinel)
 calls.clear();write32(sp+0x14,wrapper);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,wrapper)
 u.emu_start(0x9c1cd8,0x9c1d62,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x9c1d62
 for draw in [0,1]:
  calls.clear();u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x9310b5,0x93115c,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x93115c
  write32(sp,end);write32(sp+4,0);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x92ddf0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
  caches=[[read32(wrapper+0x164+(stage*8+key)*4) for key in range(8)] for stage in range(3)]
  assert caches[1][:2]==[2,2]
  assert caches[1][4:7]==([1,1,0] if draw==0 else [2,2,2])
  rows.append(dict(initial_cache=sentinel,draw_index=draw,stage_caches=caches,api_calls=list(calls)))
  write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x92de70,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
proof=dict(passed=True,complete=False,native_sha256=digest,cases=rows,findings=['Stage1 U/V clamp is explicit. MAG/MIN are POINT after reset, LINEAR after prior projected draw restoration in this selected sequence.','Stage1 MIP starts NONE after reset, becomes LINEAR after prior projected draw restoration; stage0 is explicitly reset to NONE each draw.'],adapters=['D3D9 SetSamplerState boundary returns S_OK; cookie check adapted.'],limits=['Sequence executes selected native routines; interleaved renderer/texture-binding and particle state routine932A60 not executed. Not final ordinary draw state proof.','Color-hold native8x8 texture is uniformly opaque white, so these filter variants are not visually distinguishable on this resource.'])
(r/'data/4.20/projected_color_sampler_sequence_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows))


