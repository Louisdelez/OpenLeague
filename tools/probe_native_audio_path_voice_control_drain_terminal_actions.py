from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
control=0x14a7a7c;notification=0x14a82f0;voices=vector+0x4000;table=vector+0x7000;nodes=vector+0x8000;notices=vector+0x9000;calls=[];visited=set()
u.mem_write(table,bytes(16));w(table+4,0xaec160);w(table+12,0xaeef20);w(vector+0x13000+8,vector+0x1f000);w(vector+0x13000+0x8c,vector+0x1f010);w(table+0x10,0x565170);w(table+0x2c,0x5642d0);w(0x14a7a08,vector+0x1a000);w(0xfa4424,vector+0x1f000);w(0xfa4428,vector+0x1f010)
def hook(uc,a,size,data):
 if a==0xaecedb and any(v['voice']==u.reg_read(UC_X86_REG_ESI)for v in initial_scratch):final_scratch.append({'voice':u.reg_read(UC_X86_REG_ESI),'raw':bytes(u.mem_read(u.reg_read(UC_X86_REG_EBP)-24,24)).hex()})
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
 if a in [0xaf6650,0xae13f0,0xb22660]:
  sp=u.reg_read(UC_X86_REG_ESP);ev={'kind':{0xaf6650:'remove_source_manager_key',0xae13f0:'source_virtual14',0xb22660:'source_destructor'}[a],'receiver':u.reg_read(UC_X86_REG_ECX)}
  if a==0xaf6650:ev['key']=read(read(sp+4))
  if a==0xb22660:ev['argument']=read(sp+4)
  calls.append(ev);return
 if a in [0xb00180,0xaf0370]:
  sp=u.reg_read(UC_X86_REG_ESP);event={'kind':'source_virtual08'if a==0xb00180 else'source_virtual8c','receiver':u.reg_read(UC_X86_REG_ECX)}
  if a==0xaf0370:event['payload']=bytes(u.mem_read(read(sp+4),24)).hex()
  calls.append(event);return
 if a in [vector+0x1f000,vector+0x1f010]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'source_lock'if a==vector+0x1f000 else'source_unlock','receiver':read(sp+4)});finish(1,4);return
 if a==vector+0xf020:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'virtual04'if a==vector+0xf010 else'virtual0c','voice':u.reg_read(UC_X86_REG_ECX),'argument':read(sp+4)});assert read(sp+4)==0;finish(1,4);return
 if a==0xb00350:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'destroy_action_list','receiver':u.reg_read(UC_X86_REG_ECX),'argument':read(sp+4)});return
 if a==0xaf6f00:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_action_registry','receiver':u.reg_read(UC_X86_REG_ECX),'key':read(sp+4),'action':read(sp+8)});return
 if a==0xaffcb0:calls.append({'kind':'source_virtuald0','receiver':u.reg_read(UC_X86_REG_ECX)});return
 if a==0x5642d0 and vector+0x11000<=u.reg_read(UC_X86_REG_ECX)<vector+0x11300:calls.append({'kind':'source_virtualcc','receiver':u.reg_read(UC_X86_REG_ECX)});return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8)});finish(1);return
 assert 0xb00350<=a<0xb00499 or 0xaf6f00<=a<0xaf6f47 or 0xaf6e10<=a<0xaf6e5b or 0xb22650<=a<0xb22658 or 0xaffcb0<=a<0xaffe4c or 0xaf6650<=a<0xaf66bb or 0xae13f0<=a<0xae13f5 or 0xafec20<=a<0xafec9d or 0xb22660<=a<0xb22691 or 0xb01d30<=a<0xb01d35 or 0xb01da0<=a<0xb01dfc or 0xaf30d0<=a<0xaf30db or 0xaefc60<=a<0xaefdda or 0xafdf20<=a<0xafe0d7 or 0xafd4f0<=a<0xafd4fb or 0xafd4b0<=a<0xafd4b7 or 0xb00180<=a<0xb00243 or 0xaf6430<=a<0xaf6445 or 0xaf0370<=a<0xaf042a or 0xafe760<=a<0xafe7a0 or 0xafe690<=a<0xafe720 or 0xaeea00<=a<=0xaeea6e or 0xafe9c0<=a<=0xafea20 or 0xafde90<=a<=0xafdf1a or 0xaeef20<=a<=0xaef114 or 0xaece30<=a<=0xaecedf or 0xb00250<=a<=0xb002d4 or 0xafd670<=a<0xafd740 or 0xaf3aa0<=a<=0xaf3bc3 or 0xb1bf30<=a<0xb1c080 or 0xaeaf40<=a<=0xaeaf83 or 0xaec160<=a<=0xaec1c4 or 0xaee720<=a<0xaee770 or 0x5642d0<=a<0x5642d5 or 0x565170<=a<0x565175,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,selector,pooled,notice_pooled,linked,owned,reference_case,registered in itertools.product([0,0xa5],[1,3],[3,4],[False,True],[False,True],[False,True],[False,True],['null','last_mixed'],[False,True]):
 calls.clear();initial_scratch=[];final_scratch=[];u.mem_write(vector+0x1a000,bytes(1600));w(vector+0x1a000+24+(0x12345678%193)*4,vector+0x11000);w(vector+0x1a000+24+772,3);u.mem_write(0x12100e0,bytes(16));u.mem_write(vector+0x11000,bytes([pattern])*768);u.mem_write(vector+0x12000,bytes([pattern])*768);u.mem_write(vector+0x14000,bytes([pattern])*768);
 for bank in [0x16000,0x17000,0x18000]:u.mem_write(vector+bank,bytes([0x33])*768)
 u.mem_write(vector+0xd000,bytes([pattern])*768);
 for j in range(3):
  ref=vector+0xd000+j*256;w(ref,2 if reference_case=='two'else 0 if reference_case=='zero'else 1);w(ref+4,3 if reference_case=='last_mixed'else 0)
  for k in range(3):w(ref+16+k*24,vector+0x10000+j*256+k*20 if k!=1 else 0)
 u.mem_write(nodes,bytes([pattern])*60);u.mem_write(notices,bytes([pattern])*60);u.mem_write(voices,bytes([pattern])*1536)
 for i in range(3):
  v=voices+i*512;w(v,table);w(v+68,0 if reference_case=='null'else vector+0xd000+i*256);w(v+344,vector+0xc000+i*20 if owned else 0);w(v+96,vector+0x11000+i*256);w(v+100,vector+0x12000+i*256);w(vector+0x11000+i*256,0xff1cd8);w(vector+0x12000+i*256+16,0)
  root=vector+0x11000+i*256;w(root+12,1);w(root+4,vector+0x11000+(i+1)*256 if i<2 else 0);w(root+8,0x12345678+i*193);owner=vector+0x14000+i*256;w(root+28,owner);w(root+32,0);w(root+36,0);w(root+56,0);w(owner+12,v);w(v+16,0)
  for j,(pointer,cnt,capacity)in enumerate([(0,4,8),(16,20,24),(36,40,44)]):w(owner+pointer,vector+[0x16000,0x17000,0x18000][j]+i*256 if owned else 0);w(owner+cnt,0);w(owner+capacity,8)
  for offset in[16,20,24,40,48,52,64,68,72,76,80,104,108]:w(root+offset,0)
  u.mem_write(owner+48,(1 if registered else 0).to_bytes(2,'little')+bytes(6));u.mem_write(owner+56,b'\x00')
  for o in [20,24,48,72,80,84,104,332,396,400,408,412]:w(v+o,0)
  u.mem_write(v+302,bytes([0 if registered else 0x10]));u.mem_write(v+303,b'\x00');w(v+12,voices+(i+1)*512 if linked and i+1<count else 0)
  n=nodes+i*20;w(n,nodes+(i+1)*20 if i+1<count else 0);w(n+4,v);w(n+8,selector);w(n+12,i+1);w(n+16,0x3f000000)
  n=notices+i*20;w(n,notices+(i+1)*20 if i+1<count else 0);w(n+4,v);w(n+8,2)
 for q,base,poolrange in [(control,nodes,pooled),(notification,notices,notice_pooled)]:
  u.mem_write(q,bytes(28));w(q,base if count else 0);w(q+4,base+(count-1)*20 if count else 0);w(q+12,3 if poolrange else 0);w(q+16,4);w(q+20,count);w(q+24,base if poolrange else 0)
 for base,size in [(0x1000,12),(0x1100,24),(0x1200,192),(0x2000,384),(0x3000,192),(0xb000,384),(0xe000,768)]:u.mem_write(vector+base,bytes([pattern])*size)
 w(0x14a7a34,vector+0x1000);w(vector+0x1000,vector+0x1100);w(vector+0x1004,3);w(vector+0x1008,8)
 for i in range(3):
  root=vector+0x11000+i*256;action=vector+0x2000+i*128;entries=vector+0x3000+i*64;blob=vector+0xb000+i*128;child=vector+0xe000+i*256;group=vector+0x1200+i*64
  w(root+16,action);w(action+4,0);w(action+8,0);w(action+16,blob);w(action+20,entries);w(action+24,1);w(action+28,8);w(action+32,0x1234+i);u.mem_write(blob,b'\x00')
  w(entries,0x6789+i);w(entries+4,child);w(child,0xff1cd8);w(child+12,2);w(child+20,0xabcdef);u.mem_write(child+47,bytes([2 if i==1 else 0]));w(vector+0x1100+i*8,0x1234+i);w(vector+0x1104+i*8,group);w(group+8,action)
 w(0x12100dc,19);w(0x1210228,17);w(0x14a7a70,count if linked else 0);w(0x14a7a74,voices if linked and count else 0);w(0x14a7a78,voices+(count-1)*512 if linked and count else 0)
 def snap():return {'action_registry':bytes(u.mem_read(vector+0x1000,12)).hex(),'action_registry_table':bytes(u.mem_read(vector+0x1100,24)).hex(),'action_registry_owners':bytes(u.mem_read(vector+0x1200,192)).hex(),'actions':bytes(u.mem_read(vector+0x2000,384)).hex(),'action_tables':bytes(u.mem_read(vector+0x3000,192)).hex(),'action_properties':bytes(u.mem_read(vector+0xb000,384)).hex(),'child_sources':bytes(u.mem_read(vector+0xe000,768)).hex(),'source_manager':bytes(u.mem_read(vector+0x1a000,1600)).hex(),'control_queue':bytes(u.mem_read(control,28)).hex(),'control_nodes':bytes(u.mem_read(nodes,60)).hex(),'notification_queue':bytes(u.mem_read(notification,28)).hex(),'notification_nodes':bytes(u.mem_read(notices,60)).hex(),'voices':bytes(u.mem_read(voices,1536)).hex(),'references':bytes(u.mem_read(vector+0xd000,768)).hex(),'sources':bytes(u.mem_read(vector+0x11000,768)).hex(),'inputs':bytes(u.mem_read(vector+0x12000,768)).hex(),'global_registry':bytes(u.mem_read(0x12100e0,16)).hex(),'source_owners':bytes(u.mem_read(vector+0x14000,768)).hex(),'source_buffers':[{'reference':vector+bank,'raw':bytes(u.mem_read(vector+bank,768)).hex()}for bank in [0x16000,0x17000,0x18000]],'active_count':read(0x14a7a70),'active_head':read(0x14a7a74),'active_tail':read(0x14a7a78)}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xaf3aa0,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'selector':selector,'pooled':pooled,'notice_pooled':notice_pooled,'linked':linked,'owned':owned,'reference_case':reference_case,'registered':registered,'registration_scratch_initial':initial_scratch,'registration_scratch_after':final_scratch,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf3aa0','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Full consumer/voice cleanup/last root reference/destructor now executes actual nonempty B00350 action list, AF6F00/AF6E10 registry unlink, B22650 child owner-field clear, B00180 child2-to1, base D0/CC and action property/table frees. Canonical root/child/action/registry banks captured. Property blobs have zero packed owners. Selector3 cases retain action graph; selector4 retires it in full native pipeline. Rust replay and physical producer/complete frame integration required.','Actual AF3AA0/AEE720 queue consumer and selector application, actual AEEF20/AECE30 cleanup with empty global registration removed by actual B00250/AFD670, actual AEC160/AEAF40 destructor/reference release all compose in one native execution. Both queue/list headers, voice/reference/source/input memory and all downstream calls captured. Native cleanup optional owners/bindings/query/source/secondary resources null here; other prepared cleanup48 composition exercises actual binding/owner retirement. Actual AEEA00/AFE9C0/AFDE90 source voice unlink, empty-owner gate and ordered source owner/buffer destruction execute, with all source regions and free order captured. Actual B00180 source08 reference decrement/AF6430 critical-section selection and AF0370 source8C/AFE760/AFE690 counters and payload execute. OS critical sections adapted. Source references start at1; actual last-source AF6650/AE13F0/AFEC20/B22660/B01DA0/AF30D0/AEFC60/AFDF20/AFD4F0/AFD4B0 destruction executes, manager hash/source nodes and free order captured; other downstream optional paths null. Real producers/canonical full frame lifetime and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_control_drain_terminal_actions_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native control drain cases with actual AEE720 and base control callbacks; actual cleanup/registration/destructor/reference bodies; actual source owner release; actual source virtual08/8C outer bodies execute; actual source terminal manager/destructor bodies execute; producer/OS/graph qualification remains open')
