from pathlib import Path
import itertools,json,hashlib,struct
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
regions=[('globals',0x12100c0,0x180),('conversion_cache',0x14a7970,8)]
visited=set()
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,z,user):visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
values=[struct.unpack('<I',struct.pack('<f',v))[0]for v in[-96.4,-96.3,-96.,-74.,-32.,-1.,-0.,0.,1.]]+[0x7f800000,0x7fc12345]
rows=[];faults=[]
for pattern,priority,selector,cache,bits in itertools.product([0,165],[0,0xffffffff,0x7fffffff],[0,2,0xffffffff],[0,1,0xa5,0x80000000],values):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 w(0x12100d4,priority);w(0x14a7974,cache);w(0x2da52e8,0);u.mem_write(stack-0x1000,bytes([pattern])*0x1000)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);before=snapshot();w(stack,end);w(stack+4,bits);w(stack+8,selector);u.reg_write(UC_X86_REG_ESP,stack)
 try:
  u.emu_start(0xaeb3d0,end,count=25000)
  if u.reg_read(UC_X86_REG_EIP)!=end:raise RuntimeError('instruction limit')
 except Exception as e:
  faults.append({'pattern':pattern,'priority':priority,'selector':selector,'cache_flags':cache,'bits':bits,'before':before,'after':snapshot(),'fault_pc':u.reg_read(UC_X86_REG_EIP),'error':str(e)});continue
 rows.append({'pattern':pattern,'priority':priority,'selector':selector,'cache_flags':cache,'bits':bits,'before':before,'after':snapshot(),'result':u.reg_read(UC_X86_REG_EAX),'fpcw_after':u.reg_read(UC_X86_REG_FPCW),'mxcsr_after':u.reg_read(UC_X86_REG_MXCSR)})
p={'passed':not faults,'complete':False,'case_count':len(rows),'fault_count':len(faults),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'visited_addresses':sorted(visited),'cases':rows,'faults':faults,'limits':['Actual AEB3D0 global decibel threshold configuration and original CRT pow fallback execute without service substitution. Explicit CRT dispatch selector2DA52E8=0, PC64 nearest037F and MXCSR1F80, supplied global/cache state, lower bound-96.300003 and upper0. Original return statuses and all global/cache bytes retained.','Numerical emulation is not actual CPU qualification. Native CRT hardware dispatch/startup controls, signaling NaNs and full resource/global integration require separate validation. Rust implementation and replay pending.']}
(r/'data/4.20/audio_global_float_configuration_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_global_float_configuration.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Original float configuration:',len(rows),'completed;',len(faults),'faults;',len(visited),'native addresses')
if faults:print('first fault',faults[0]['error'],hex(faults[0]['fault_pc']))
