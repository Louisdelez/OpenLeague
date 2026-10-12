from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;key_table=vector+0x2000;state=vector+0x3000;action=vector+0x4000;properties=vector+0x5000;source=vector+0x6000;input_owner=vector+0x7000;manager=vector+0x8000;queues=vector+0x9000;clock=vector+0xa000;voices=vector+0xb000;owners=vector+0xc000;bindings=vector+0xe000
child=vector+0x10000;child_table=vector+0x11000;child_properties=vector+0x12000
regions=[('registry',registry,108),('key_table',key_table,8),('state',state,24),('action',action,44),('properties',properties,48),('source',source,120),('input_owner',input_owner,60),('manager',manager,28),('queues',queues,64),('clock',clock,128),('voices',voices,424),('property_owners',owners,320),('bindings',bindings,160),('conversion_cache',0x14a7970,8),('selected_child',child,44),('selected_children',child_table,24),('selected_properties',child_properties,32)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];freed=[];allocated=[];visited=set();failure='none';owner_index=binding_index=0
flags=list(bytes(u.mem_read(0xff10bc,5)))
def hook(uc,a,size,data):
 global owner_index,binding_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19 and size in[56,32,60]
  fail=(failure=='owner'and size==56)or(failure=='binding'and size==32)or(failure=='input'and size==60)
  if fail:result=0
  elif size==56:result=owners+owner_index*64;owner_index+=1
  elif size==32:result=bindings+binding_index*32;binding_index+=1
  else:result=input_owner
  assert owner_index<=5 and binding_index<=5;calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snap()})
  if result:allocated.append({'reference':result,'size':size})
  finish(result);return
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snap()});assert ref not in freed;freed.append(ref);finish(0);return
 if a==0xaf5490:
  p=read(sp+4);calls.append({'kind':'create_transition','receiver':u.reg_read(UC_X86_REG_ECX),'descriptor_words':[read(p+j*4)for j in range(6)],'descriptor_flags':list(bytes(u.mem_read(p+24,2))),'arguments':[read(sp+8),read(sp+12)],'at_call':snap()})
 if a==0xaff730:calls.append({'kind':'input_virtual98','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()})
 if a==0xb01250:calls.append({'kind':'action_virtual0','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4),read(sp+8),read(sp+12)&255],'at_call':snap()})
 if a==0xafe5b0:calls.append({'kind':'input_virtual9c','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()})
 if a==0xaf5b90:calls.append({'kind':'release_property_owner','receiver':u.reg_read(UC_X86_REG_ECX),'owner':read(sp+4),'key':read(sp+8),'at_call':snap()})
 if a==0xaf3420:calls.append({'kind':'source_virtualcc','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()})
 if a==0xaee780:calls.append({'kind':'clear_voice_flags','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()})
 if a==0xb20ee0:calls.append({'kind':'progress_owner','receiver':u.reg_read(UC_X86_REG_ECX),'time':read(sp+4),'at_call':snap()})
 assert 0xaf6ff0<=a<0xaf7272 or 0xaf6a30<=a<0xaf6a72 or 0xaff560<=a<0xaff596 or 0xaf5490<=a<0xaf55c3 or 0xb20ea0<=a<0xb20ed4 or 0xb21040<=a<0xb21281 or 0xaff610<=a<0xaff67c or 0xb212c0<=a<0xb212f0 or 0xaff730<=a<0xaff7c9 or 0xafea80<=a<0xafeb06 or 0xaff3d0<=a<0xaff429 or 0xafdcf0<=a<0xafdd66 or 0xaffe50<=a<0xaffea1 or 0xb01250<=a<0xb012b4 or 0xafe5b0<=a<0xafe64e or 0xafe9c0<=a<0xafea21 or 0xafde90<=a<0xafdf1b or 0xaf5b90<=a<0xaf5bf8 or 0xaf3420<=a<0xaf3440 or 0xaee780<=a<0xaee78f or 0xb20ee0<=a<0xb21038 or 0xadf570<=a<0xadf7ac or a==0x5642d0,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,input_kind,failure,duration,time,instant,child_kind in itertools.product([0,0xa5],['new','existing_voice'],['none','owner','binding','input'],[0,1,97],[35],[0,1],['first_duplicate','missing_key','zero_count_padding']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 owner_index=binding_index=0;key=0x12345678;new=0xaabbccdd;w(registry,key_table);w(registry+4,1);w(key_table,key);w(key_table+4,state);w(state,duration);w(state+4,0x11223344);w(state+8,action);w(state+12,0);w(state+16,0)
 w(action,0xff10ec);w(action+4,0);w(action+12,source);w(action+16,properties);w(action+20,0);w(action+24,0);w(action+36,0x11223344);u.mem_write(properties,bytes([5,0,1,2,3,4]))
 for i in range(5):w(properties+8+i*8,0x3f800000);w(properties+12+i*8,0)
 w(action+20,child_table);w(action+24,2);w(child_table,new if child_kind!='missing_key'else new+1);w(child_table+4,child);w(child_table+12,new);w(child_table+16,0 if child_kind!='missing_key'else child)
 w(child+16,child_properties)
 if child_kind=='zero_count_padding':
  u.mem_write(child_properties,bytes([0,0,3,4]));w(child_properties+4,0x40000000)
 else:
  u.mem_write(child_properties,bytes([5,0,1,2,3,4]))
  for i,bits in enumerate([0x40000000,0xbf800000,0,0x3f800000,0x40400000]):w(child_properties+8+i*4,bits)
 w(source,0xff1cd8);w(source+16,action);w(source+28,input_owner if input_kind=='existing_voice'else 0);w(source+32,0);w(source+36,0);w(source+56,0);u.mem_write(source+44,bytes(3));w(source+48,0)
 if input_kind=='existing_voice':
  for off in[0,4,8,16,20,24,36,40,44,48,52]:w(input_owner+off,0)
  w(input_owner+12,voices);w(voices+16,0);u.mem_write(voices+300,bytes([255]));u.mem_write(voices+302,bytes([255]))
 w(manager,8)
 for off,ptr in[(4,queues),(16,queues+32)]:w(manager+off,ptr);w(manager+off+4,0);w(manager+off+8,8)
 w(clock+124,31);w(0x14a7a24,manager);w(0x14a7a28,clock);w(0x12100dc,19);w(0x12100f8,48);w(0x14a7970,0);w(0x14a7974,0)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);before=snap();calls.clear();freed.clear();allocated.clear();w(stack,end)
 for i,arg in enumerate([key,new,instant,1]):w(stack+4+i*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6ff0,end,count=30000);assert u.reg_read(UC_X86_REG_EIP)==end;after_creation=snap();creation_calls=list(calls);live_owners=[a['reference']for a in allocated if a['size']==56 and a['reference']not in freed];steps=[]
 for ref in live_owners:
  step_before=snap();calls.clear();w(stack,end);w(stack+4,time);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,ref);u.emu_start(0xb20ee0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;steps.append({'owner':ref,'time':time,'before':step_before,'after':snap(),'calls':list(calls),'finished':u.reg_read(UC_X86_REG_EAX)&255})
 rows.append({'child_kind':child_kind,'pattern':pattern,'input_kind':input_kind,'failure':failure,'duration':duration,'time':time,'instant_argument':instant,'key':key,'new_value':new,'before':before,'after_creation':after_creation,'creation_calls':creation_calls,'steps':steps,'after':snap(),'allocations':list(allocated),'freed':list(freed)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'floating_control':{'x87_control_word':895,'mxcsr':8064},'property_flags':flags,'cases':rows,'limits':['Actual AF6FF0 nonempty registry update, AF5490 fresh owner56/setup/growth/publication, original Source98 owner60 creation and counter acquisition, actual Action0 callbacks/recursive Source9C retirement, AF5B90 rejection cleanup, active SourceCC voice flag invalidation and complete B20EE0 owner progression execute in shared physical banks. Only allocator/free ABI adapters; source/action callbacks execute originals. OOM owner/binding/input, fresh/existing input owner, five properties, instant/duration, progress/final stages captured.','Initial registry/action/packed properties/manager/source/voice structures supplied; selected children with first duplicate and NULL child, later matching child, and zero-count padding property lookup; notifications skipped. Progression explicitly invoked once for each physically live allocated owner; manager normal-frame dispatch/phase retirement is not executed. No parents, no real bank/resource/startup producers or physical playback. Explicit PC64 nearest037f/MXCSR1f80 supplied. Rust replay pending.']}
(r/'data/4.20/audio_registry_selected_child_callbacks_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual registry transition allocation/input98/action0/9C/voice flags/progression complete canonical memory cases')
