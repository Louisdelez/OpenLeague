from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;action=vector+0x2000;existing=vector+0x3000;registry=vector+0x4000;table=vector+0x4100;owners=vector+0x4200;manager=vector+0x5000;calls=[];visited=set();failure=False;freed=[];allocation_index=0;fail_index=-1;phase='init';key_failure='none';key_owner_index=0;key_table_index=0;first_pool=vector+0x6000;second_pool=vector+0x7000
regions=[('source',source,120),('action',action,88),('existing',existing,132),('registry',registry,108),('table',table,64),('registry_owners',owners,48),('source_manager',manager,800),('first_pool',first_pool,96),('second_pool',second_pool,128)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 global allocation_index,key_owner_index,key_table_index
 if a==read(0xfa41a0):
  sp=u.reg_read(UC_X86_REG_ESP);section=read(sp+4);assert section==registry+68;calls.append({'kind':'initialize_critical_section','receiver':section,'supplied_pattern':17,'result':0,'at_call':snap()});u.mem_write(section,bytes([17])*24);finish(0,4);return
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);size=read(sp+8)
  if phase=='init':assert size in[96,128];result=first_pool if size==96 else second_pool
  elif phase=='key':
   assert size in[24,64]
   if size==24:result=0 if key_failure=='owner'and key_owner_index==0 else owners+key_owner_index*24;key_owner_index+=1
   else:result=0 if key_failure=='table'and key_table_index==0 else table;key_table_index+=1
  else:
   assert size in[120,44];result=source if size==120 else 0 if allocation_index==fail_index else action+allocation_index*44;allocation_index+=int(size==44)
  calls.append({'kind':'allocate','pool':read(sp+4),'size':size,'result':result,'at_call':snap()});finish(result);return

 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);reference=read(sp+8);assert reference not in freed;freed.append(reference);calls.append({'kind':'free','pool':read(sp+4),'reference':reference,'at_call':snap()});finish(1);return
 if a in [read(0xfa4424),read(0xfa4428)]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'lock'if a==read(0xfa4424)else'unlock','receiver':read(sp+4)});finish(0,4);return
 if a in[0xaf6950,0xaf6b40]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'register_action'if a==0xaf6950 else'read_action_type','receiver':u.reg_read(UC_X86_REG_ECX),'key':read(sp+4),'arguments':[read(sp+4+j*4)for j in range(2 if a==0xaf6950 else 1)],'at_call':snap()});return
 if a in[0xaffcb0,0xafebb0,0xaf3420]:calls.append({'kind':{0xaffcb0:'source_virtuald0',0xafebb0:'release_action_owners',0xaf3420:'source_virtualcc'}[a],'receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()});return
 if a in[0xaf6650,0xae13f0,0xb22660]:
  sp=u.reg_read(UC_X86_REG_ESP);event={'kind':{0xaf6650:'remove_manager_key',0xae13f0:'source_virtual14',0xb22660:'source_destructor'}[a],'receiver':u.reg_read(UC_X86_REG_ECX)}
  if a==0xaf6650:event['key']=read(read(sp+4))
  if a==0xb22660:event['argument']=read(sp+4)
  calls.append(event);return
 if a==0xaf6f00:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_action_registry','receiver':u.reg_read(UC_X86_REG_ECX),'key':read(sp+4),'action':read(sp+8),'at_call':snap()});return
 if a==0xb00350:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'destroy_action_list','receiver':u.reg_read(UC_X86_REG_ECX),'argument':read(sp+4),'at_call':snap()});return
 if a==0x5642d0:calls.append({'kind':'source_virtualcc','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()});return
 assert any(lo<=a<hi for lo,hi in[(0xaf66c0,0xaf672b),(0xaf6b80,0xaf6c5f),(0xaf6890,0xaf6950),(0xb15890,0xb15917),(0xb153b0,0xb15426),(0xaf7350,0xaf7387),(0xb00180,0xb00243),(0xaf6650,0xaf66bb),(0xae13f0,0xae13f5),(0xafec20,0xafec9d),(0xb22660,0xb22691),(0xb01d30,0xb01d35),(0xb01da0,0xb01dfc),(0xaf30d0,0xaf30db),(0xaefc60,0xaefdda),(0xafdf20,0xafe0d7),(0xafd4f0,0xafd4fb),(0xafd4b0,0xafd4b7),(0xb00350,0xb00499),(0xaf6f00,0xaf6f47),(0xaf6e10,0xaf6e5b),(0x5642d0,0x5642d1),(0xb226a0,0xb22708),(0xaf30b0,0xaf30cb),(0xaefc10,0xaefc5a),(0xafdd70,0xafddd8),(0xafd490,0xafd4ac),(0xb01cf0,0xb01d23),(0x75a270,0x75a276),(0xafe420,0xafe47f),(0xaf6430,0xaf6445),(0xafe2e0,0xafe413),(0xaf6950,0xaf69ab),(0xaf6b40,0xaf6b75),(0xaffcb0,0xaffe4c),(0xafebb0,0xafec20),(0xaf3420,0xaf3440)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x12100dc,19);w(0x14a7a08,manager);w(0x14a7a34,registry);rows=[]


for pattern,key_count,key_failure,fail_index,refresh,reference_count in itertools.product([0,0xa5],[1,2],['none','owner','table'],[-1,0],[0,1],[1,2]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 source_key=0x12345678;w(manager+24+(source_key%193)*4,0);w(manager+796,0);calls.clear();freed.clear();allocation_index=key_owner_index=key_table_index=0;before=snap();phase='init'
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf66c0,end,count=1200);assert u.reg_read(UC_X86_REG_EAX)==registry;registry_constructor_calls=list(calls);after_registry_constructor=snap()
 calls.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6b80,end,count=1200);assert u.reg_read(UC_X86_REG_EAX)==1;registry_init_calls=list(calls);after_registry_init=snap();key_steps=[];phase='key'
 for i in range(key_count):
  calls.clear();w(stack,end);w(stack+4,0x1122+i);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6890,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
  key_steps.append({'key':0x1122+i,'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'after':snap()})
 calls.clear();phase='source';w(stack,end);w(stack+4,source_key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0);u.emu_start(0xb226a0,end,count=2000);assert u.reg_read(UC_X86_REG_EAX)==source;factory_calls=list(calls);after_factory=snap();steps=[]
 for i in range(key_count):
  calls.clear();w(stack,end);w(stack+4,0x1122+i);w(stack+8,refresh);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xafe2e0,end,count=6000);assert u.reg_read(UC_X86_REG_EIP)==end
  steps.append({'key':0x1122+i,'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'after':snap()})
 w(source+12,reference_count);before_release=snap();calls.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xb00180,end,count=12000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'key_count':key_count,'key_failure':key_failure,'fail_index':fail_index,'refresh_argument':refresh,'reference_count':reference_count,'source_key':source_key,'before':before,'registry_constructor_calls':registry_constructor_calls,'after_registry_constructor':after_registry_constructor,'registry_init_calls':registry_init_calls,'after_registry_init':after_registry_init,'key_steps':key_steps,'factory_calls':factory_calls,'after_factory':after_factory,'action_steps':steps,'before_release':before_release,'release_calls':list(calls),'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'freed':sorted(freed)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual registry108 AF66C0 constructor/AF6B80 pools, AF6890 key owner24 publication with B15890/B153B0 and OOM cleanup, Source120 factory, Action44 producer, optional property refresh and B00180 reference/registry unlink/derived/base destructor/class-correct D0/final frees all execute sequentially in original canonical memory. No existing key table or key owner fixtures are substituted. Complete intermediate physical banks and every call/free boundary captured.','Physical allocator/free/OS lock and supplied critical-section mutation remain explicit transports. Registry object storage/global pointer and source-manager initial bucket supplied. Reference count1/2 assigned before retirement. Actual key values supplied and published type4 remains native default0; resource key/type admission, registry shutdown, property/owner attachment, normal frame/voice activation and physical playback remain open. Rust complete registry/source/action lifecycle replay pending.']}
(r/'data/4.20/audio_registry_constructed_source_action_lifetime_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual registry/key/source/action/reference/destructor canonical lifetimes')
