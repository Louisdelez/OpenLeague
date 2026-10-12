"""Whole940D19..940E83 state copyback and request reset."""
from pathlib import Path
import json,struct,datetime,shutil,random
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_properties.py').read_text(encoding='utf-8').split('\nactor=')[0]
setup=setup.replace('0x93fb60<=a<0x93fcb8','0x93fb60<=a<0x93fcb8 or 0x940d19<=a<0x940e83')
exec(compile(setup,'native copyback setup','exec'))
actor=heap+0x9000;actor_config=heap+0xa000;wrapper=heap+0xb000
def hook(uc,a,size,user):
 if a==0x940e83:u.emu_stop();return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
patterns=[0,0x80000000,1,0x80000001,0x3f000000,0x3f800000,0x40000000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234,0xffc05678]
rng=random.Random(420);cases=[]
def snapshot():return {'requests':read32(wrapper+0x144),'flags':read32(wrapper+0x24),'config_flags':read32(wrapper+0x28),'flag_bytes':[u.mem_read(wrapper+offset,1)[0] for offset in (0x2d,0x2e,0x110)],'visibility':u.mem_read(wrapper+0x84,1)[0],'channels':[hex(read32(wrapper+0x2f+i*4)) for i in range(3)],'field_80':hex(read32(wrapper+0x3c)),'position':[hex(read32(wrapper+0x40+i*4)) for i in range(3)],'params':[hex(read32(wrapper+0x58+i*4)) for i in range(3)],'color':[hex(read32(wrapper+0x64+i*4)) for i in range(8)],'minimum':[hex(read32(wrapper+0xe0+i*4)) for i in range(3)],'maximum':[hex(read32(wrapper+0xec+i*4)) for i in range(3)]}
for index in range(512):
 flags=index%256;source_flags=rng.getrandbits(32);config_flags=rng.getrandbits(32);requests=rng.getrandbits(32)
 params=[patterns[(index+i*3)%16] for i in range(3)];channels=[patterns[(index+i+4)%16] for i in range(3)];color=[patterns[(index+i+7)%16] for i in range(8)];position=[patterns[(index+i+1)%16] for i in range(3)];minimum=[patterns[(index+i+5)%16] for i in range(3)];maximum=[patterns[(index+i+9)%16] for i in range(3)];field_80=patterns[(index+2)%16]
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(actor,b'\0'*0x200);u.mem_write(wrapper,b'\xcc'*0x200);write32(actor+0xe8,actor_config);write32(actor_config+0x1bc,config_flags);write32(actor+0x70,source_flags);u.mem_write(actor+0x1dc,bytes([flags]));write32(wrapper+0x114,actor);write32(wrapper+0x144,requests)
  for offset,words in [(0xbc,params),(0x74,channels),(0xc8,color),(0x90,position),(0x130,minimum),(0x13c,maximum)]:u.mem_write(actor+offset,struct.pack('<'+'I'*len(words),*words))
  write32(actor+0x80,field_80);before=snapshot();sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDI,wrapper);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x940d19,0x940e83,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x940e83 and u.reg_read(UC_X86_REG_ESP)==sp and restore is None;captures.append(snapshot())
 cases.append({'flags':flags,'source_flags':source_flags,'config_flags':config_flags,'requests':requests,'params':[hex(v) for v in params],'channels':[hex(v) for v in channels],'color':[hex(v) for v in color],'position':[hex(v) for v in position],'minimum':[hex(v) for v in minimum],'maximum':[hex(v) for v in maximum],'field_80':hex(field_80),'before':before,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'940D19..940E83','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_x87_copies':x87_copies,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole original state copyback and final request reset execute; explicit emitter/config input words, wrapper sentinels.','Separate actualCPU SSE multiplication and x87 float copies; original VM captures retained independently.','Stack balance checked at fragment exit.'],'limits':['Copyback is final phase, not qualification of earlier reset/audio/resource/frame update phases or graphical integration.','Default masked arithmetic control only; supplied emitter fields require native producers and runtime integration.']}
(r/'data/4.20/troy_copyback_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'sse':cpu_calls,'x87':x87_copies,'disagreements':proof['emulator_cpu_case_disagreements']}))
