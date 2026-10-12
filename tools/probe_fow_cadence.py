from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
state=heap+0x1f300;frame=sp+0x100;cases=[]
interval=floats(0x1138a84,1)[0]
for now,previous in [(0.,0.),(0.016,0.),(interval,0.),(interval+0.00001,0.),(0.1,0.),(1.,0.),(10.,9.9),(10000.,9999.9)]:
 u.mem_write(frame+8,struct.pack('<f',now));u.mem_write(state+0x10,struct.pack('<f',previous))
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESI,state);u.reg_write(UC_X86_REG_ESP,frame-0x30)
 u.emu_start(0x6b57f6,0x6b580c,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x6b580c
 elapsed=struct.unpack('<f',u.mem_read(frame-4,4))[0];flags=u.reg_read(UC_X86_REG_EFLAGS);ready=not bool(flags&0x41)
 result=None
 if ready:
  u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
  u.emu_start(0x6b5823,0x6b5837,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x6b5837
  result=floats(state+0x10,1)[0]
 cases.append({'now':now,'previous':previous,'elapsed':elapsed,'ready':ready,'new_previous':result})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'interval':interval,'interval_bits':struct.unpack('<I',struct.pack('<f',interval))[0],'cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[],'limits':['Original scheduling comparison and original floating remainder helper executed; fade and blur draws are skipped.','Frame clock source, texture allocation/format and complete GPU pipeline remain unqualified.']}
(r/'data/4.20/fow_cadence_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
