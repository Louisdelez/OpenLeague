from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
state=heap+0x1f300;frame=sp+0x100;cases=[]
for first in [False,True]:
 for delta in [0.,0.016,1./30.,0.1,1.]:
  u.mem_write(state+0x18,bytes([first]));u.mem_write(frame+8,struct.pack('<f',delta))
  u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x20);u.reg_write(UC_X86_REG_EDI,state)
  u.emu_start(0x6b54bb,0x6b5504,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x6b5504
  cases.append({'first_frame':first,'delta':delta,'parameters':list(struct.unpack('<4f',u.mem_read(frame-0x14,16)))})
constants={hex(a):floats(a,1)[0] for a in [0x1138ca0,0x1138df8,0x1138ba4,0x1138a84,0x1138b30]}
receipt={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b54bb','stop':'0x6b5504','cases':cases,'constants':constants,'runtime_adapters':[],'original_instruction_addresses':len(visited),'limits':['Executed original arithmetic for fade shader parameters with supplied first-frame flag and elapsed time.','Caller scheduling/remainder update, render-target formats and actual texture draws not executed.']}
(r/'data/4.20/fow_fade_parameters_contract.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'constants':constants,'parameters':cases[:2],'original_addresses':len(visited)}))
