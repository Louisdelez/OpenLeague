from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
visited=set()
def hook(uc,a,size,data):assert 0xaf1a70<=a<0xaf1a8d,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,depth,placement,root in itertools.product([0,0xa5,0xff],[1,2,4],['none','first','last','all'],[vector+0x10000,0xf0000000,0xfffffff0]):
 sources=[vector+0x4000+i*128 for i in range(depth)]
 for i,ref in enumerate(sources):
  u.mem_write(ref,bytes([pattern])*96);w(ref+32,sources[i+1]if i+1<depth else 0);w(ref+68,root if placement=='all'or placement=='first'and i==0 or placement=='last'and i==depth-1 else 0)
 before=[{'reference':ref,'raw':bytes(u.mem_read(ref,96)).hex()}for ref in sources];w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,sources[0]);u.emu_start(0xaf1a70,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 after=[{'reference':ref,'raw':bytes(u.mem_read(ref,96)).hex()}for ref in sources];assert after==before
 rows.append({'depth':depth,'placement':placement,'before':before,'after':after,'result':u.reg_read(UC_X86_REG_EAX)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf1a70','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual nearest-resource lookup executes with complete source chains; returns resource+64 including pointer wrapping without dereferencing resource. Source constructors/parent ownership, cycles/missing-node faults, actual resource state/history access, Rust port and caller composition remain required.']}
(r/'data/4.20/audio_path_source_state_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native nearest ancestor resource state cases')
