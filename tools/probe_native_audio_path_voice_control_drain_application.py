from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
control=0x14a7a7c;notification=0x14a82f0;voices=vector+0x4000;table=vector+0x7000;nodes=vector+0x8000;notices=vector+0x9000;calls=[];visited=set()
u.mem_write(table,bytes(16));w(table+4,vector+0xf010);w(table+12,vector+0xf020);w(table+0x10,0x565170);w(table+0x2c,0x5642d0)
def hook(uc,a,size,data):
 if a==0xaee720:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'apply','voice':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'argument':read(sp+8),'value_bits':read(sp+12)});return
 if a in [vector+0xf010,vector+0xf020]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'virtual04'if a==vector+0xf010 else'virtual0c','voice':u.reg_read(UC_X86_REG_ECX),'argument':read(sp+4)});assert read(sp+4)==0;finish(1,4);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8)});finish(1);return
 assert 0xaf3aa0<=a<=0xaf3bc3 or 0xb1bf30<=a<0xb1c080 or 0xaee720<=a<0xaee770 or 0x5642d0<=a<0x5642d5 or 0x565170<=a<0x565175,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,selector,pooled,notice_pooled,linked in itertools.product([0,0xa5],[0,1,3],[0,3,4,99],[False,True],[False,True],[False,True]):
 calls.clear();u.mem_write(nodes,bytes([pattern])*60);u.mem_write(notices,bytes([pattern])*60);u.mem_write(voices,bytes([pattern])*1536)
 for i in range(3):
  v=voices+i*512;w(v,table);w(v+12,voices+(i+1)*512 if linked and i+1<count else 0)
  n=nodes+i*20;w(n,nodes+(i+1)*20 if i+1<count else 0);w(n+4,v);w(n+8,selector);w(n+12,i+1);w(n+16,0x3f000000)
  n=notices+i*20;w(n,notices+(i+1)*20 if i+1<count else 0);w(n+4,v);w(n+8,2)
 for q,base,poolrange in [(control,nodes,pooled),(notification,notices,notice_pooled)]:
  u.mem_write(q,bytes(28));w(q,base if count else 0);w(q+4,base+(count-1)*20 if count else 0);w(q+12,3 if poolrange else 0);w(q+16,4);w(q+20,count);w(q+24,base if poolrange else 0)
 w(0x12100dc,19);w(0x1210228,17);w(0x14a7a70,count if linked else 0);w(0x14a7a74,voices if linked and count else 0);w(0x14a7a78,voices+(count-1)*512 if linked and count else 0)
 def snap():return {'control_queue':bytes(u.mem_read(control,28)).hex(),'control_nodes':bytes(u.mem_read(nodes,60)).hex(),'notification_queue':bytes(u.mem_read(notification,28)).hex(),'notification_nodes':bytes(u.mem_read(notices,60)).hex(),'voices':bytes(u.mem_read(voices,1536)).hex(),'active_count':read(0x14a7a70),'active_head':read(0x14a7a74),'active_tail':read(0x14a7a78)}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xaf3aa0,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'selector':selector,'pooled':pooled,'notice_pooled':notice_pooled,'linked':linked,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf3aa0','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AF3AA0 drains control queue, unlinks active voices for selector4, calls actual B1BF30 notification removal and recycles pooled slots or calls physical external free. Actual AEE720 applies selectors including selector4/argument1 flag changes and selector3 phase writes/actual base virtual2C/10 no-ops. Derived virtual0C/04 remain controlled callbacks recording arguments, not implementations or completed audible output. Allocator/free transports controlled. Full canonical lifetime, actual derived callback bodies, dynamic command mutation, malformed queues and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_control_drain_application_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native control drain cases with actual AEE720 and base control callbacks; derived cleanup remains explicit boundary')
