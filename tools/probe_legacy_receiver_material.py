from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
material=heap+0x1e000;cases=[]
for kind in range(5):
 for flags in range(256):
  write32(material+0x104,kind);write32(material+0x108,flags);write32(sp,end)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,material);u.reg_write(UC_X86_REG_EDX,5)
  u.emu_start(0x95b4d0,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
  rejected=(u.reg_read(UC_X86_REG_EAX)&255)!=0
  assert rejected==(kind not in [0,2,3])
  cases.append({'material_104':kind,'flags_108':flags,'rejected':rejected})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x95b4d0','render_type':5,'jump_target':hex(read32(0x95b55c+5*4)),'cases':cases,'limits':['Material structure supplied; native loader mapping of field104 to map materials not yet qualified.','Object quality gate at95B851, geometry choice and enqueue not executed.']}
(r/'data/4.20/legacy_receiver_material_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('1280 native material gate cases passed')
