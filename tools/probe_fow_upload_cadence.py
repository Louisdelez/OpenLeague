from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
state=heap+0x1f300;frame=sp+0x100;cases=[];interval=floats(0x1138b30,1)[0]
for now,previous in [(0.,0.),(0.1,0.),(interval,0.),(interval+0.00001,0.),(0.5,0.),(10.,9.9),(10.,9.7),(10000.,9999.8)]:
 u.mem_write(frame+8,struct.pack('<f',now));u.mem_write(state+0x14,struct.pack('<f',previous))
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EAX,state)
 u.emu_start(0x6b5097,0x6b50ac,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x6b50ac
 ready=bool(u.reg_read(UC_X86_REG_EFLAGS)&1)
 cases.append({'now':now,'previous':previous,'ready':ready})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'interval':interval,'interval_bits':struct.unpack('<I',struct.pack('<f',interval))[0],'cases':cases,'runtime_adapters':[],'original_instruction_addresses':len(visited),'limits':['Original fourfold upload time comparison executed; texture lock and upload are not executed.','Failed-lock timestamp behavior and non-upscale uploader are not yet qualified.']}
(r/'data/4.20/fow_upload_cadence_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'interval':interval,'cases':cases,'native_addresses':len(visited)}))
