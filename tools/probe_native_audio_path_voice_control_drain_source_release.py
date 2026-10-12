from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
control=0x14a7a7c;notification=0x14a82f0;voices=vector+0x4000;table=vector+0x7000;nodes=vector+0x8000;notices=vector+0x9000;calls=[];visited=set()
u.mem_write(table,bytes(16));w(table+4,0xaec160);w(table+12,0xaeef20);w(vector+0x13000+8,vector+0x1f000);w(vector+0x13000+0x8c,vector+0x1f010);w(table+0x10,0x565170);w(table+0x2c,0x5642d0)
def hook(uc,a,size,data):
 if a==0xaecead:initial_scratch.append({'voice':u.reg_read(UC_X86_REG_ESI),'raw':bytes(u.mem_read(u.reg_read(UC_X86_REG_EBP)-24,24)).hex()})
 if a==0xaee720:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'apply','voice':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'argument':read(sp+8),'value_bits':read(sp+12)});return
 if a==0xaec160:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'virtual04','voice':u.reg_read(UC_X86_REG_ECX),'argument':read(sp+4)});assert read(sp+4)==0;return
 if a==0xaeef20:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'virtual0c','voice':u.reg_read(UC_X86_REG_ECX),'argument':read(sp+4)});return
 if a==0xb00250:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_registration','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4),read(sp+8)]});return
 if a==0xaeea00:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_source_voice','receiver':u.reg_read(UC_X86_REG_ECX),'voice':read(sp+4)});return
 if a in [vector+0x1f000,vector+0x1f010]:
  sp=u.reg_read(UC_X86_REG_ESP);event={'kind':'source_virtual08'if a==vector+0x1f000 else'source_virtual8c','receiver':u.reg_read(UC_X86_REG_ECX)}
  if a==vector+0x1f010:event['payload']=bytes(u.mem_read(read(sp+4),24)).hex()
  calls.append(event);finish(1,4 if a==vector+0x1f010 else 0);return
 if a==vector+0xf020:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'virtual04'if a==vector+0xf010 else'virtual0c','voice':u.reg_read(UC_X86_REG_ECX),'argument':read(sp+4)});assert read(sp+4)==0;finish(1,4);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8)});finish(1);return
 assert 0xaeea00<=a<=0xaeea6e or 0xafe9c0<=a<=0xafea20 or 0xafde90<=a<=0xafdf1a or 0xaeef20<=a<=0xaef114 or 0xaece30<=a<=0xaecedf or 0xb00250<=a<=0xb002d4 or 0xafd670<=a<0xafd740 or 0xaf3aa0<=a<=0xaf3bc3 or 0xb1bf30<=a<0xb1c080 or 0xaeaf40<=a<=0xaeaf83 or 0xaec160<=a<=0xaec1c4 or 0xaee720<=a<0xaee770 or 0x5642d0<=a<0x5642d5 or 0x565170<=a<0x565175,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,selector,pooled,notice_pooled,linked,owned,reference_case,registered in itertools.product([0,0xa5],[1,3],[3,4],[False,True],[False,True],[False,True],[False,True],['null','last_mixed'],[False,True]):
 calls.clear();initial_scratch=[];u.mem_write(0x12100e0,bytes(16));u.mem_write(vector+0x11000,bytes([pattern])*768);u.mem_write(vector+0x12000,bytes([pattern])*768);u.mem_write(vector+0x14000,bytes([pattern])*768);
 for bank in [0x16000,0x17000,0x18000]:u.mem_write(vector+bank,bytes([0x33])*768)
 u.mem_write(vector+0xd000,bytes([pattern])*768);
 for j in range(3):
  ref=vector+0xd000+j*256;w(ref,2 if reference_case=='two'else 0 if reference_case=='zero'else 1);w(ref+4,3 if reference_case=='last_mixed'else 0)
  for k in range(3):w(ref+16+k*24,vector+0x10000+j*256+k*20 if k!=1 else 0)
 u.mem_write(nodes,bytes([pattern])*60);u.mem_write(notices,bytes([pattern])*60);u.mem_write(voices,bytes([pattern])*1536)
 for i in range(3):
  v=voices+i*512;w(v,table);w(v+68,0 if reference_case=='null'else vector+0xd000+i*256);w(v+344,vector+0xc000+i*20 if owned else 0);w(v+96,vector+0x11000+i*256);w(v+100,vector+0x12000+i*256);w(vector+0x11000+i*256,vector+0x13000);w(vector+0x12000+i*256+16,0)
  root=vector+0x11000+i*256;owner=vector+0x14000+i*256;w(root+28,owner);w(root+32,0);w(root+36,0);w(root+56,0);w(owner+12,v);w(v+16,0)
  for j,(pointer,cnt,capacity)in enumerate([(0,4,8),(16,20,24),(36,40,44)]):w(owner+pointer,vector+[0x16000,0x17000,0x18000][j]+i*256 if owned else 0);w(owner+cnt,0);w(owner+capacity,8)
  u.mem_write(owner+48,bytes(8))
  for o in [20,24,48,72,80,84,104,332,396,400,408,412]:w(v+o,0)
  u.mem_write(v+302,bytes([0 if registered else 0x10]));u.mem_write(v+303,b'\x00');w(v+12,voices+(i+1)*512 if linked and i+1<count else 0)
  n=nodes+i*20;w(n,nodes+(i+1)*20 if i+1<count else 0);w(n+4,v);w(n+8,selector);w(n+12,i+1);w(n+16,0x3f000000)
  n=notices+i*20;w(n,notices+(i+1)*20 if i+1<count else 0);w(n+4,v);w(n+8,2)
 for q,base,poolrange in [(control,nodes,pooled),(notification,notices,notice_pooled)]:
  u.mem_write(q,bytes(28));w(q,base if count else 0);w(q+4,base+(count-1)*20 if count else 0);w(q+12,3 if poolrange else 0);w(q+16,4);w(q+20,count);w(q+24,base if poolrange else 0)
 w(0x12100dc,19);w(0x1210228,17);w(0x14a7a70,count if linked else 0);w(0x14a7a74,voices if linked and count else 0);w(0x14a7a78,voices+(count-1)*512 if linked and count else 0)
 def snap():return {'control_queue':bytes(u.mem_read(control,28)).hex(),'control_nodes':bytes(u.mem_read(nodes,60)).hex(),'notification_queue':bytes(u.mem_read(notification,28)).hex(),'notification_nodes':bytes(u.mem_read(notices,60)).hex(),'voices':bytes(u.mem_read(voices,1536)).hex(),'references':bytes(u.mem_read(vector+0xd000,768)).hex(),'sources':bytes(u.mem_read(vector+0x11000,768)).hex(),'inputs':bytes(u.mem_read(vector+0x12000,768)).hex(),'global_registry':bytes(u.mem_read(0x12100e0,16)).hex(),'source_owners':bytes(u.mem_read(vector+0x14000,768)).hex(),'source_buffers':[{'reference':vector+bank,'raw':bytes(u.mem_read(vector+bank,768)).hex()}for bank in [0x16000,0x17000,0x18000]],'active_count':read(0x14a7a70),'active_head':read(0x14a7a74),'active_tail':read(0x14a7a78)}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xaf3aa0,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'selector':selector,'pooled':pooled,'notice_pooled':notice_pooled,'linked':linked,'owned':owned,'reference_case':reference_case,'registered':registered,'registration_scratch_initial':initial_scratch,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf3aa0','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AF3AA0/AEE720 queue consumer and selector application, actual AEEF20/AECE30 cleanup with empty global registration removed by actual B00250/AFD670, actual AEC160/AEAF40 destructor/reference release all compose in one native execution. Both queue/list headers, voice/reference/source/input memory and all downstream calls captured. Native cleanup optional owners/bindings/query/source/secondary resources null here; other prepared cleanup48 composition exercises actual binding/owner retirement. Actual AEEA00/AFE9C0/AFDE90 source voice unlink, empty-owner gate and ordered source owner/buffer destruction execute, with all source regions and free order captured. Source virtual08/8C remain controlled; real source producers/last-registry reclamation/canonical lifetime and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_control_drain_source_release_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native control drain cases with actual AEE720 and base control callbacks; actual cleanup/registration/destructor/reference bodies; actual source owner release; source virtual callbacks remain explicit boundaries')
