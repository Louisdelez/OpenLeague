from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
base=0x12100c0
visited=set()
def hook(uc,a,z,user):
 assert 0xaeb180<=a<0xaeb1b1,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for pattern,priority,selector,bits in itertools.product([0,165],[0,2,0x7fffffff,0x80000000,0xffffffff],[0,2,0x7fffffff,0x80000000,0xffffffff],[0,1,128,65535,65536,0xa5a50000,0xa5a50080,0xffffffff]):
 u.mem_write(base,bytes([pattern])*64);w(0x12100d8,priority);before=bytes(u.mem_read(base,64)).hex()
 w(stack,end);w(stack+4,bits);w(stack+8,selector);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xaeb180,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'priority':priority,'selector':selector,'bits':bits,'before':before,'after':bytes(u.mem_read(base,64)).hex(),'result':u.reg_read(UC_X86_REG_EAX)})
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'reference':base,'size':64,'native_addresses':len(visited),'cases':rows,'limits':['Actual AEB180 body executed without service substitutions. Supplied global64byte state, unsigned pushed value truncated to16bits, signed priority comparison. Zero low16 returns31 and leaves globals untouched; nonzero returns1 and lower/equal signed selector publishes priority and voice-limit word, preserving all surrounding bytes.','Native preparation only; Rust implementation and full resource/global/device integration pending. Float configuration AEB3D0 separate dependency.']}
(r/'data/4.20/audio_global_voice_limit_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_global_voice_limit.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('PASS',len(rows),'actual global voice limit signed priority/low16/zero status/native bytes')
