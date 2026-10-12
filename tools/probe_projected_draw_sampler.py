from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
cases=[]
for border in [0,0xffffffff]:
 for stage in range(16):
  for key in range(8):write32(wrapper+0x164+(stage*8+key)*4,0xffffffff)
 calls.clear();write32(sp,end);write32(sp+4,border);u.reg_write(UC_X86_REG_ESP,sp)
 u.emu_start(0x92ddf0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 before=list(calls);cache=[read32(wrapper+0x164+key*4) for key in range(8)]
 assert [0,1,3] in before and [0,2,3] in before and [0,7,0] in before
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x92de70,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 after=calls[len(before):]
 assert [0,7,2] in after and [0,1,1] in after and [0,2,1] in after
 for stage in range(16):
  for key in [5,6,7]:assert [stage,key,2] in after
 cases.append({'border_color':border,'draw_setup_calls':before,'draw_internal_cache':cache,'post_draw_restore_calls':after})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry_points':['0x92ddf0','0x92de70'],'cases':cases,'original_instruction_addresses':len(visited-{api,0xc975f5}),'interpretation':['Per-geometry stage0 clamp U/V and mip NONE are explicitly restored before drawing. Border color is caller supplied.','Post-draw helper restores linear MAG/MIN/MIP on all16stages and wrap U/V on stage0. These mutations must not be confused with FOW texture binding.'],'limits':['Native D3D SetSamplerState API and cookie adapters only; no native GPU.','Texture identities/FOW binding and caller border-color provenance are not qualified.']}
(r/'data/4.20/projected_draw_sampler_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'native_addresses':proof['original_instruction_addresses'],'draw_calls':[c['draw_setup_calls'] for c in cases],'restore_calls':len(cases[0]['post_draw_restore_calls'])}))
