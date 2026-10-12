from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
queue=0x14a7a7c;voices=vector+0x4000;table=vector+0x7000;nodes=vector+0x8000;allocated=vector+0xa000;cached_node=vector+0xb000;calls=[];visited=set();attempt=0
w(table+0x2c,0x5642d0);w(table+0x10,0x565170)
def hook(uc,a,size,data):
 global attempt
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+4)==19 and read(sp+8)==20;attempt+=1;ref=0 if failure=='always'or(failure=='first'and attempt==1)else allocated;calls.append({'kind':'allocate','pool':19,'bytes':20,'reference':ref})
  if ref:u.mem_write(ref,bytes([pattern])*20)
  finish(ref);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8)});finish(1);return
 assert 0xaf36b0<=a<=0xaf36f0 or 0xaf34d0<=a<=0xaf352f or 0xaf3aa0<=a<=0xaf3bc3 or 0xaee720<=a<0xaee770 or 0x5642d0<=a<0x5642d5 or 0x565170<=a<0x565175,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,selector,pooled,cached,limit,failure in itertools.product([0,0xa5],[0,1,3],[0,3],[False,True],[False,True],[0,4],['never','first','always']):
 calls.clear();attempt=0;u.mem_write(voices,bytes([pattern])*2048);u.mem_write(nodes,bytes([pattern])*60);u.mem_write(allocated,bytes([0x33])*20);u.mem_write(cached_node,bytes([pattern])*20);w(cached_node,0)
 for i in range(4):w(voices+i*512,table)
 for i in range(3):n=nodes+i*20;w(n,nodes+(i+1)*20 if i+1<count else 0);w(n+4,voices+i*512);w(n+8,selector);w(n+12,0);w(n+16,0x3f000000)
 u.mem_write(queue,bytes(28));w(queue,nodes if count else 0);w(queue+4,nodes+(count-1)*20 if count else 0);w(queue+8,cached_node if cached else 0);w(queue+12,3 if pooled else 0);w(queue+16,limit);w(queue+20,count);w(queue+24,nodes if pooled else 0);w(0x12100dc,19)
 def snap():return {'queue':bytes(u.mem_read(queue,28)).hex(),'nodes':bytes(u.mem_read(nodes,60)).hex(),'allocated':bytes(u.mem_read(allocated,20)).hex(),'cached_node':bytes(u.mem_read(cached_node,20)).hex(),'voices':bytes(u.mem_read(voices,2048)).hex()}
 before=snap();w(stack,end);w(stack+4,voices+1536);w(stack+8,4);w(stack+12,1);w(stack+16,0);u.reg_write(UC_X86_REG_ESP,stack)
 fault=False
 try:u.emu_start(0xaf36b0,end,count=5000)
 except unicorn.UcError as ex:
  assert ex.errno==unicorn.UC_ERR_WRITE_UNMAPPED and u.reg_read(UC_X86_REG_EIP)==0xaf36dc,(str(ex),hex(u.reg_read(UC_X86_REG_EIP)));fault=True
 if not fault:assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'selector':selector,'pooled':pooled,'cached':cached,'limit':limit,'failure':failure,'before':before,'after':snap(),'native_null_payload_fault':fault,'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf36b0','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AF36B0 publication, AF34D0 append/allocation, AF3AA0 drain and AEE720 selectors0/3 execute, including actual base callbacks. Native allocator/free transports controlled; failed final retry causes original null payload write fault rather than a success status. Existing commands do not require selector4 derived cleanup here. Canonical real producers/lifetime and derived selector4 callbacks remain required; Rust replay not yet qualified.']}
(r/'data/4.20/audio_path_voice_control_publication_retry_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native publication allocation/full drain/retry/null-payload-fault cases')
