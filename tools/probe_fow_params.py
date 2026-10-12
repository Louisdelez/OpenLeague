from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
extent_object=heap+0x1f300;write32(0x2d78a40,extent_object)
cases=[]
for extent in [1.,256.,10000.,15398.671875,16000.,32768.]:
 u.mem_write(extent_object+0xc,struct.pack('<f',extent));u.reg_write(UC_X86_REG_ESP,sp)
 u.emu_start(0x6b3849,0x6b3894,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x6b3894
 current=u.reg_read(UC_X86_REG_ESP);register=read32(current);pointer=read32(current+4);count=read32(current+8)
 values=list(struct.unpack('<4f',u.mem_read(pointer,16)));assert register==230 and count==1
 expected=struct.unpack('<f',struct.pack('<f',1./extent))[0];assert values==[expected,-expected,0.,1.]
 cases.append({'extent':extent,'register':register,'count':count,'params':values})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b3849','stop_before_virtual_constant_upload':'0x6b3894','extent_field':'[global2D78A40]+0xC','cases':cases,'native_instruction_addresses':len(visited),'runtime_math_adapters':[],'limits':['Original arithmetic and c230 upload arguments executed; upload call and full fog renderer not run.','Map-specific extent value, visibility/overlay textures and native visibility rasterizer remain to trace.']}
(r/'data/4.20/fow_params_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'formula':'[1/extent,-1/extent,0,1]'}))
