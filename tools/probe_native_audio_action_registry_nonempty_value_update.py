from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;table=vector+0x2000;state=vector+0x3000;action=vector+0x4000;properties=vector+0x5000;source=vector+0x6000;transitions=vector+0x7000;manager=vector+0x8000;owner=vector+0x9000;clock=vector+0xa000;vtable=vector+0xb000;callback=vector+0x1f000;action_callback=vector+0x1e000
regions=[('registry',registry,108),('table',table,8),('state',state,24),('action',action,44),('properties',properties,48),('source',source,120),('transitions',transitions,36),('manager',manager,28),('property_owner',owner,56),('clock',clock,128),('conversion_cache',0x14a7970,8)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];visited=set();callback_result=0
flags=list(bytes(u.mem_read(0xff10bc,5)))
def hook(uc,a,size,data):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==callback:calls.append({'kind':'state_callback','arguments':[read(sp+4),read(sp+8)],'result':callback_result,'at_call':snap()});finish(callback_result);return
 if a==action_callback:calls.append({'kind':'action_virtual0','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+j*4)for j in range(3)],'at_call':snap()});finish(0,12);return
 if a==0xaf7600:calls.append({'kind':'state_notify','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+j*4)for j in range(3)],'at_call':snap()})
 if a==0xaf5670:calls.append({'kind':'update_property_owner','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+j*4)for j in range(6)],'at_call':snap()})
 if a==0xaf5490:
  p=read(sp+4);calls.append({'kind':'create_transition','receiver':u.reg_read(UC_X86_REG_ECX),'descriptor_words':[read(p+j*4)for j in range(6)],'descriptor_flags':list(bytes(u.mem_read(p+24,2))),'arguments':[read(sp+8),read(sp+12)],'at_call':snap()})
 if a==0x5642d0:calls.append({'kind':'source_virtualcc','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()})
 assert 0xaf6ff0<=a<0xaf7272 or 0xaf6a30<=a<0xaf6a72 or 0xaf7600<=a<0xaf764d or 0xaff560<=a<0xaff596 or 0xaf5670<=a<0xaf5944 or 0xaf5490<=a<0xaf55c3 or a==0x5642d0,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,instant,skip,callback_kind,transition_kind,float_kind in itertools.product([0,0xa5],[0,1,256],[0,1],['null','false','true','upper'],['empty','first','last','duplicate'],['zero','normal','nan']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 key=0x12345678;old=0x11223344;new=0xaabbccdd;w(registry,table);w(registry+4,1);w(registry+12,0);w(table,key);w(table+4,state);w(state,97);w(state+4,old);w(state+8,action);w(state+12,transitions);w(state+16,0 if transition_kind=='empty'else 3)
 for i in range(3):w(transitions+i*12,old);w(transitions+i*12+4,new if(transition_kind=='first'and i==0)or(transition_kind=='last'and i==2)or(transition_kind=='duplicate'and i<2)else new+i+1);w(transitions+i*12+8,22+22*i)
 w(action,vtable);w(vtable,action_callback);w(action+4,0);w(action+12,source);w(action+16,properties);w(action+20,0);w(action+24,0);w(action+36,old);w(source,0xff10f0)
 u.mem_write(properties,bytes([5,0,1,2,3,4]));bits={'zero':0,'normal':0x3f800000,'nan':0x7fc01234}[float_kind]
 for i in range(5):w(properties+8+i*8,bits);w(properties+12+i*8,owner if i==0 else 0)
 for off,val in[(0,5),(4,0x3f800000),(8,0x40000000),(12,0),(16,24),(20,40),(28,0),(44,4),(48,0)]:w(owner+off,val)
 u.mem_write(owner+52,bytes([0,1]));u.mem_write(manager,bytes(28));w(clock+124,31);w(0x14a7a28,clock);w(0x14a7a24,manager);w(0x12100f8,48);w(0x14a7970,0);w(0x14a7974,0)
 callback_result={'null':0,'false':0,'true':1,'upper':256}[callback_kind];w(0x14a7a0c,0 if callback_kind=='null'else callback)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);before=snap();calls.clear();w(stack,end)
 for i,arg in enumerate([key,new,instant,skip]):w(stack+4+i*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6ff0,end,count=8000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'instant_argument':instant,'skip_notify_argument':skip,'callback_kind':callback_kind,'callback_result':callback_result,'transition_kind':transition_kind,'float_kind':float_kind,'key':key,'new_value':new,'before':before,'after':snap(),'calls':list(calls)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'property_flags':flags,'native_addresses':len(visited),'limits':['Actual nonempty AF6FF0 action walk, AF6A30 first transition duration lookup, AFF560 missing child, AF5670 owned property update, AF5490 empty-manager fallback, source base-class CC and final state publication execute. Action virtual0 and custom state callback are explicit ABI services. Full physical memory and call snapshots captured.','AF5490 manager count limit0 and both queues empty: no fresh allocation or reuse. Fresh allocation/setup separately prepared3888 cases. Active-source voice flags, source input98, attachment/progression, real bank/manager producers and full physical playback remain open. Rust replay pending.']}
(r/'data/4.20/audio_action_registry_nonempty_value_update_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'nonempty actual state/action/property/transition fallback memory cases; property flags',flags)
