from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x4000;properties=vector+0x5000;ranges=vector+0x6000;calls=[];visited=set();rng=17

def hook(uc,a,size,data):
 global rng
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;value=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':value});finish(value);return
 assert 0xaf3150<=a<0xaf31fe or 0xca1e40<=a<0xca1ef5,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
layouts=[None,[],[7],[1],[1,2,7],[7,2,7],[1,2,3,4],[1,2,3,4,5,6,7]]
spans=[None,(0,0),(-4,7),(0,2),(-2147483648,2147483647),(9,-9)]
for pattern,ids,range_ids,span,seed,sse in itertools.product([0,0xa5],layouts,layouts,spans,[0,17,0xffffffff],[0,1]):
 rng=seed;calls.clear();u.mem_write(source,bytes([pattern])*96);u.mem_write(properties,bytes([pattern])*64);u.mem_write(ranges,bytes([pattern])*64);w(source+40,properties if ids is not None else 0);w(source+72,ranges if span is not None and range_ids is not None else 0);w(0x14ae660,sse)
 if ids is not None:
  u.mem_write(properties,bytes([len(ids),*ids]));offset=(len(ids)+4)&~3
  for i in range(max(1,len(ids))):w(properties+offset+i*4,[1,0xffffffff,65537,0x80000000,37,0x12345678,0xffff][i])
  if len(ids)==0:u.mem_write(properties+1,b'\x07')
 if span is not None and range_ids is not None:
  u.mem_write(ranges,bytes([len(range_ids),*range_ids]));offset=(len(range_ids)+4)&~3
  for i in range(max(1,len(range_ids))):
   lo,hi=span if (len(range_ids)==0 or range_ids[i]==7)else(-13+i,27-i);w(ranges+offset+i*8,lo);w(ranges+offset+i*8+4,hi)
  if len(range_ids)==0:u.mem_write(ranges+1,b'\x07')
 def snap():return {'source':bytes(u.mem_read(source,96)).hex(),'properties':bytes(u.mem_read(properties,64)).hex(),'ranges':bytes(u.mem_read(ranges,64)).hex(),'rng_state':rng}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0xaf3150,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'ids':ids,'range_ids':range_ids,'span':span,'seed':seed,'sse_conversion':sse,'before':before,'after':snap(),'result_low16':u.reg_read(UC_X86_REG_EAX)&0xffff,'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf3150','case_count':len(rows),'random_multiplier_bits':bytes(u.mem_read(0xff0e78,8)).hex(),'rounding_bias_bits':bytes(u.mem_read(0x1138d88,8)).hex(),'cases':rows,'native_addresses':len(visited),'limits':['Original static ID7 lookup, count/alignment/duplicate-first behavior, range integer arithmetic, conditional random draw and both native CRT conversion branches execute. Seeded CRT RNG is explicit controlled transport. Return low16 matches actual AEF540 consumer; unspecified high EAX not interpreted. Source properties count0 still scans first ID byte natively. Full borrowed source/table bytes recorded. Both property and range count0/1/3/4/7 tables, absent/first/last/duplicate/missing IDs and actual integer range arithmetic are covered. Out-of-bounds table faults/source producers, upper voice/frame integration and Rust port remain required.']}
(r/'data/4.20/audio_path_source_value_tables_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native source integer property/range cases')
