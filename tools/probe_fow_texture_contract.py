from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
frame=sp+0x100;obj=heap+0x1f300;cases=[]
for dimension in [128,512]:
 args=[dimension,dimension,dimension,dimension,0,0,1,dimension,1,dimension]
 for i,value in enumerate(args):write32(frame+8+i*4,value)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESI,obj)
 u.emu_start(0x9882de,0x988354,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x988354
 fields={hex(o):read32(obj+o) for o in [0x18,0x1c,0x20,0x24,0x28,0x2c,0x30,0x34,0x38,0x3c,0x44]}
 assert fields['0x24']==1 and fields['0x2c']==1
 cases.append({'stage':'render_target_fields','dimension':dimension,'fields':fields})
for native_format in [1,20]:
 for o,v in [(0x18,native_format),(0x1c,0),(0x14,1)]:write32(frame+o,v)
 u.reg_write(UC_X86_REG_EBP,frame)
 u.emu_start(0x9c2d6b,0x9c2d82,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9c2d82
 cases.append({'stage':'format_translation','native_format':native_format,'d3d_format':u.reg_read(UC_X86_REG_ESI),'pool':u.reg_read(UC_X86_REG_EDI)})
u.reg_write(UC_X86_REG_ESP,frame-0x50)
u.emu_start(0x9885e0,0x9885fa,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9885fa
clear=[read32(u.reg_read(UC_X86_REG_ESP)+i*4) for i in range(6)]
assert clear==[0,0,1,0,0x3f800000,0]
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'clear_arguments':clear,'original_instruction_addresses':len(visited),'runtime_adapters':[],'api_documentation':'https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dformat','formats':{'raw_visibility':'D3DFMT_L8 = 50; native enum20','intermediates':'D3DFMT_X8R8G8B8 = 22; native enum1'},'limits':['Executed original render-target constructor fields, format lookup and clear argument preparation with valid supplied factory arguments.','Factory GPU creation, original D3D clear execution and allocation failure paths are not executed.','Raw texture initialization and fourfold corner bytes require separate qualification.']}
(r/'data/4.20/fow_texture_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
