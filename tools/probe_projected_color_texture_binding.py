from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_grass_bind_filter.py').read_text().split('\nquad=json.loads')[0],'native texture binding setup','exec'))
cases=[]
for stage in [0,1,2]:
 for filters in [[1,1,0],[2,2,2],[1,2,0]]:
  uploads=[];samplers=[];textures=[];ref_calls=[];shader_override=False
  for key in range(8):w(driver+0x164+(stage*8+key)*4,0)
  for key,value in zip([4,5,6],filters):w(driver+0x164+(stage*8+key)*4,value)
  w(driver+0x58+stage*4,0);w(0x2d77ad0+stage*4,0);w(0x14beef8+stage*4,0xffffffff)
  w(stack,end);w(stack+4,context);w(stack+8,stage);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager)
  u.emu_start(0x983cb0,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
  final=[read(driver+0x164+(stage*8+key)*4) for key in [4,5,6]]
  assert final==filters and samplers==[] and textures==[[stage,raw_texture]]
  cases.append(dict(stage=stage,filters=filters,final=final,texture_calls=textures,sampler_calls=samplers))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,entry='983CB0',adapters=['Opaque COM methods supply raw texture handle; D3D SetTexture returns success. Existing qualified native driver wrapper setup reused.'],limits=['Manager and native wrapper texture bind execute for stages0/1/2; no filter mutation in selected non-null cold-cache cases.','Upstream global renderer filter producers and texture upload mip generation remain unqualified.'])
(r/'data/4.20/projected_color_texture_binding_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(cases))

