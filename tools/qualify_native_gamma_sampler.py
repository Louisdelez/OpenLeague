from pathlib import Path
exec(compile(Path('E:/OpenLeague/tools/qualify_native_map10_gamma.py').read_text(encoding='utf-8'),'gamma prerequisites','exec'))
import pefile
original=pefile.PE(json.loads((r/'data/4.20/native_endgame_default_timing.json').read_text())['source'])
image=original.get_memory_mapped_image();base=original.OPTIONAL_HEADER.ImageBase
default_enabled=image[0x1224dd9-base];assert default_enabled==1
native_code_ranges.extend([(0x9c2270,0x9c22a8),(0x9c1960,0x9c19bb),(0x9c5260,0x9c5380)])
renderer=0x70020000;com_device=0x70021000;com_table=0x70022000;callback=end+0xb00
u.mem_write(renderer,bytes(0x1000));write32(renderer+0x14,com_device);write32(com_device,com_table);write32(com_table+0x114,callback)
u.mem_write(callback,b'\xcc');native_code_ranges.append((callback,callback+1));calls=[]
def sampler_boundary(uc,a,size,user):
 if a==callback:
  top=uc.reg_read(UC_X86_REG_ESP);args=[read32(top+i*4) for i in range(1,5)]
  assert args[0]==com_device;calls.append(dict(stage=args[1],d3d_type=args[2],d3d_value=args[3]));returned(0,16)
u.hook_add(unicorn.UC_HOOK_CODE,sampler_boundary)
cases=[]
for stage in [0,1]:
 for kind,value in [(4,1),(5,1),(6,1),(0,2),(1,2)]:
  initial=len(calls);invoke(0x9c2270,renderer,struct.pack('<3I',stage,kind,value))
  assert len(calls)==initial+1
  expected=dict(stage=stage,d3d_type=kind+1,d3d_value=1 if kind in [4,5,6] else 3)
  assert calls[-1]==expected
  invoke(0x9c2270,renderer,struct.pack('<3I',stage,kind,value));assert len(calls)==initial+1
  cases.append(dict(stage=stage,native_kind=kind,native_value=value,submission=expected,repeated_state_elided=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,
 entries=['0x9c2270','0x9c1960','0x9c5260'],com_vtable_offset='0x114',cases=cases,
 default_gamma_enabled=bool(default_enabled),default_gamma_enabled_address='0x1224dd9',
 filter='point',address_u='clamp',address_v='clamp',lookup_index='min(255,floor(clamp(channel,0,1)*256))',
 adapters=['Preallocated renderer state cache and COM object; original state cache, enum mappings and SetSamplerState wrapper execute. COM call observes arguments and returns S_OK.',
 'Defaults read from original PE image. User option dispatch/root state producer not executed.'],
 limits=['Original gamma pass state values were identified in code741520..741653; physical D3D sampler/raster not executed.','Whole framebuffer, HUD ordering, overrides/color fade and GPU transfer remain separate qualification requirements.'])
(r/'data/4.20/native_gamma_sampler_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),point=True,clamp=True,default_enabled=True)))
