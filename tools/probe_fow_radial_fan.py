from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
obj=heap+0x1f300;desc=heap+0x1f500;rays=[];cases=[]
def ray_boundary(uc,address,size,user):
 if address==0x6b0db0:
  top=uc.reg_read(UC_X86_REG_ESP)
  coordinates=list(struct.unpack('<4f',uc.mem_read(top+4,16)));assert read32(top+24)==desc
  rays.append({'origin':coordinates[:2],'end':coordinates[2:]});finish(24)
u.hook_add(unicorn.UC_HOOK_CODE,ray_boundary)
for center in [[4.,4.],[1.,1.]]:
 for radius in [0.,0.25,0.5,1.,2.,3.,4.,8.]:
  rays.clear();write32(0x2d7c060,0);write32(sp,end);u.mem_write(sp+4,struct.pack('<3f',*center,radius));write32(sp+16,desc)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj)
  u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
  u.emu_start(0x6b1140,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
  cases.append({'center':center,'radius':radius,'rays':list(rays)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b1140','step':floats(0x2d7c064,1)[0],'radius_multiplier':floats(0x2d7c068,1)[0],'cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[{'address':'0x6b0db0','purpose':'Record ray arguments at clipping boundary; skip clipping and terrain trace in this dispatch proof.'}],'limits':['Original complete radial dispatch and native multiplier initializer executed.','Clipping and terrain are separate contracts; actual occluded stencil composition and Map10 providers remain open.']}
(r/'data/4.20/fow_radial_fan_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'step':proof['step'],'radius_multiplier':proof['radius_multiplier'],'native_addresses':len(visited),'counts':[len(c['rays']) for c in cases]}))
