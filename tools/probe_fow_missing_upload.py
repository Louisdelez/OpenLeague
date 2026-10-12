from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
state=heap+0x1f300;tex=heap+0x1f500;fog=heap+0x1f700;cases=[]
write32(state,fog);write32(fog+0x10,128);write32(tex+0x90,0);write32(tex+0x60,128);write32(tex+0x64,128)
for upscale in [False,True]:
 for target_present in [False,True]:
  for now in [0.,0.2,0.20001,1.]:
   write32(state+4,tex if target_present else 0);u.mem_write(state+0x14,struct.pack('<f',0.));write32(sp,end);u.mem_write(sp+4,struct.pack('<f',now))
   u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,state)
   u.emu_start(0x6b5080 if upscale else 0x6b4f70,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
   after=floats(state+0x14,1)[0]
   cases.append({'upscale':upscale,'target_present':target_present,'now':now,'previous':0.,'after':after})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[],'limits':['Original uploader entry/exit executed without GPU adapters for missing texture or missing interface.','Actual LockRect failure with valid interface and successful GPU upload remain unqualified.']}
(r/'data/4.20/fow_missing_upload_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
