from pathlib import Path
import json,struct,datetime,math
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
state=heap+0x1f300;frame=sp+0x100;cases=[]
for upscale in [False,True]:
 for sigma in [-1.,0.,0.01,0.1,0.25,0.5,1.,2.,4.,8.]:
  u.mem_write(state+0x19,bytes([upscale]));u.mem_write(frame+0x10,struct.pack('<f',sigma))
  for offset in [-0x14,-0x10,-0xc,0]:write32(frame+offset,0)
  write32(frame+4,end);u.reg_write(UC_X86_REG_ESP,frame-0x14);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EDI,state)
  u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
  u.emu_start(0x6b4e43,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  values=list(struct.unpack('<3f',u.mem_read(state+0x1c,12)))
  cases.append({'sigma':sigma,'upscale':upscale,'center_weight':values[0] if math.isfinite(values[0]) else None,'paired_weight':values[1] if math.isfinite(values[1]) else None,'sample_offset':values[2] if math.isfinite(values[2]) else None,'result_bits':[struct.unpack('<I',struct.pack('<f',v))[0] for v in values],'finite':all(math.isfinite(v) for v in values)})
constants={hex(a):floats(a,1)[0] for a in [0x1138960,0x1138f8c,0x11392a8,0x11392ec,0x1139348]}
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b4e43','cases':cases,'constants':constants,'original_instruction_addresses':len(visited),'runtime_adapters':[],'x87_control_word_prerequisite':'0x037f','limits':['Original constructor arithmetic and fallback executed; device allocation and constructor prefix are not run.','Config sigma/upscale selection, shader constant upload, sampling and live GPU blur remain unqualified.']}
(r/'data/4.20/fow_gaussian_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':cases,'constants':constants,'native_addresses':len(visited)}))
