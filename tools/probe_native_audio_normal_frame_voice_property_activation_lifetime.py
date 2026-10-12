from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_factory_actual_fallback.py').read_text(encoding='utf-8').split('\nfor kind,retry,scenario')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_live_fallback)','live_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_live_fallback)');exec(compile(setup,'live_setup','exec'));u.hook_del(live_hook)
common=heap+0x31000;callback_table=heap+0x32000;callbacks=[heap+0x34000,heap+0x34010];due_nodes=[heap+0x3c000+i*16 for i in range(3)];due_commands=[heap+0x3d000+i*64 for i in range(3)];due_actions=[heap+0x3e000+i*256 for i in range(3)];action_vt=heap+0x3f000;command_vt=heap+0x3f100;due_methods={heap+0x3f200:'due_query',heap+0x3f220:'due_execute',heap+0x3f240:'due_release',heap+0x3f260:'due_destroy'};lock_api=read(0xfa4424,'I')[0];unlock_api=read(0xfa4428,'I')[0]
u.mem_map(0x41000000,0x10000);bank_base=0x41000000
node_table=heap+0x38800;frame_nodes=[heap+0x38000+i*128 for i in range(4)];node_appended=False
post={0xb1c590:'optional',0xaf5b10:'advance_a',0xb14140:'advance_b',0xb19ec0:'post_a',0xaf3f80:'post_b',0xb0fdb0:'post_c',0xaf3aa0:'post_d',0xb15110:'final'}
def frame_guard(uc,a,n,d):
 global node_appended,rng
 sp=u.reg_read(UC_X86_REG_ESP);receiver=u.reg_read(UC_X86_REG_ECX)
 if 0xaef540<=a<0xaef589 or 0xaf3150<=a<0xaf31fe or 0xca1e40<=a<0xca1ef0 or 0xaed8d0<=a<0xaeda05 or 0xaf1a70<=a<0xaf1a8d:return
 if 0xaf0640<=a<0xaf069f or 0xb1b0f0<=a<0xb1b173 or 0xaf2c60<=a<0xaf2e4c or 0xaf22a0<=a<0xaf234a or 0xaefde0<=a<0xaefe01 or 0xb1b180<=a<0xb1b1ba or 0xb1b1f0<=a<0xb1b212:return
 if a==0xada670 and building_resource and read(sp+8,'I')[0]==72:
  pointer=heap+0x38200+resource_slot*80;assert read(sp+4,'I')[0]==17;u.mem_write(pointer,bytes([pattern])*72);calls.append({'kind':'resource_allocate','pool':17,'bytes':72,'reference':pointer});ret(pointer,0);return
 if a==0xada670 and building_resource:
  resource_nth[0]+=1;stage=resource_nth[0];assert stage in [1,2] and read(sp+4,'I')[0]==17 and read(sp+8,'I')[0]==(48 if stage==1 else 32);pointer=heap+0x38d00+resource_slot*64 if stage==1 else heap+0x38c00+resource_slot*32;u.mem_write(pointer,bytes([pattern])*(48 if stage==1 else 32));calls.append({'kind':'resource_allocate','pool':17,'bytes':48 if stage==1 else 32,'reference':pointer});ret(pointer,0);return
 if a==0xca1ef0 and building_resource:
  dest,src,size=read(sp+4,'I')[0],read(sp+8,'I')[0],read(sp+12,'I')[0];assert size==48;u.mem_write(dest,bytes(u.mem_read(src,size)));calls.append({'kind':'resource_copy','source':src,'destination':dest,'bytes':size});ret(dest,0);return
 if a==0xada3e0 and destroying_resources:
  reference=read(sp+8,'I')[0];assert read(sp+4,'I')[0]==17 and reference in [heap+0x38d00+i*64 for i in range(4)]+[heap+0x38c00+i*32 for i in range(4)]+[heap+0x38200+i*80 for i in range(4)] and reference not in resource_freed;resource_freed.append(reference);calls.append({'kind':'resource_free','pool':17,'reference':reference});ret(1,0);return
 if 0xb1b220<=a<0xb1b3bc or 0xb1b430<=a<0xb1b47d or 0xb1b3c0<=a<0xb1b3ed or 0xb142d0<=a<0xb14301:return
 if a==0xada670 and creating_nodes and read(sp+8,'I')[0]==108:
  assert read(sp+4,'I')[0]==17 and read(sp+8,'I')[0]==108;u.mem_write(created_target,bytes([pattern])*108);calls.append({'kind':'node_allocate','pool':17,'bytes':108,'reference':created_target});ret(created_target,0);return
 if a==0x5642d0:calls.append({'kind':'destroy_node','reference':receiver})
 if 0xb13fa0<=a<0xb1400d or 0xb14180<=a<0xb141ed or 0x5642d0<=a<0x5642d3:return
 if a==0xada670 and registering_binding:
  assert read(sp+4,'I')[0]==17 and read(sp+8,'I')[0]==32;u.mem_write(binding_target,bytes([pattern])*32);calls.append({'kind':'binding_allocate','pool':17,'bytes':32,'reference':binding_target});ret(binding_target,0);return
 if 0xb14010<=a<0xb140a5 or 0xaff610<=a<0xaff67d:return
 if a==0xada3e0 and retiring_path:
  assert read(sp+4,'I')[0]==17;reference=read(sp+8,'I')[0];assert reference not in path_freed and reference in [heap+0x38900+i*64 for i in range(4)]+[heap+0x38f00+i*4 for i in range(4)]+frame_nodes;path_freed.append(reference);calls.append({'kind':'path_free','pool':17,'reference':reference,'node':retiring_reference,'node_at_call':bytes(u.mem_read(retiring_reference,108)).hex()});ret(1,0);return
 if a==0xada670 and configuring_history:
  assert read(sp+4,'I')[0]==17 and read(sp+8,'I')[0]==2;calls.append({'kind':'path_allocate','pool':17,'bytes':2,'reference':history_target});ret(history_target,0);return
 if 0xb1b480<=a<0xb1b4dd or 0xb1bca0<=a<0xb1bd0f or 0xb1b9a0<=a<0xb1ba41 or 0xb1b4e0<=a<0xb1b505 or 0xb1ba70<=a<0xb1bc91 or 0xb1b8e0<=a<0xb1b944 or 0xb1bdf0<=a<0xb1be2f or 0xb14310<=a<0xb14385:return
 if a in [lock_api,unlock_api]and read(sp+4,'I')[0]==0x14a7a44:calls.append({'kind':'frame_lock'if a==lock_api else 'frame_unlock'});ret(1,4);return
 if a==0xb14140:calls.append({'kind':'advance_b','receiver':receiver,'frame':read(sp+4,'I')[0]});return
 if a==0xb1bd10:calls.append({'kind':'node_update','reference':receiver,'frame':read(sp+4,'I')[0]});return
 if a==0xb1b680:calls.append({'kind':'finish_node','reference':receiver});return
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;value=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':value});ret(value,0);return
 if a==0xb1b510:calls.append({'kind':'restart_path','reference':receiver});return
 if 0xb1b510<=a<0xb1b584 or 0xb1b850<=a<0xb1b8d5:return
 if 0xb1b680<=a<0xb1b82a:return
 if 0xb1bd10<=a<0xb1bde1:return
 if 0xb14140<=a<0xb1417a:return
 if a in due_methods:
  event={'kind':due_methods[a],'reference':receiver}
  if event['kind']=='due_query':
   out=read(sp+4,'I')[0];assert bytes(u.mem_read(out,4))==bytes(4);u.mem_write(out,bytes([0x5a])*68)
  if event['kind']=='due_execute':event['command']=read(sp+4,'I')[0]
  if event['kind']=='due_destroy':event['flags']=read(sp+4,'I')[0]
  calls.append(event);ret(1,4 if event['kind'] in ['due_query','due_execute','due_destroy']else 0);return
 if a in post:
  event={'kind':post[a]}
  if a in [0xaf5b10,0xb14140,0xb15110]:event['receiver']=receiver
  if a in [0xaf5b10,0xb14140]:event['frame']=read(sp+4,'I')[0]
  calls.append(event);ret(0,4 if a in [0xaf5b10,0xb14140]else 0);return
 if a in callbacks:calls.append({'kind':'frame_callback','reference':a,'reason':read(sp+4,'I')[0]});ret(0,0);return
 if a in [0xb06c60,0xb07e50]:calls.append({'kind':'command_consumer'if a==0xb06c60 else 'due_actions','receiver':receiver})
 if 0xb06950<=a<0xb069f6 or 0xb06c60<=a<0xb06f98 or 0xb07e50<=a<0xb07f28:return
 guard_live_fallback(uc,a,n,d)
building_resource=False;destroying_resources=False;resource_slot=0;resource_nth=[0];resource_freed=[];creating_nodes=False;created_target=0;registering_binding=False;binding_target=0;retiring_path=False;retiring_reference=0;path_freed=[];configuring_history=False;history_target=0;u.hook_add(unicorn.UC_HOOK_CODE,frame_guard);rows=[]
for scenario,counter,optional,final,callback_count in itertools.product(['zero','one','three','wrap'],[0,0xffffffff],[0,1],[0,1],[0,2]):
 pattern=0xa5 if optional else 0;kind=3;retry=0;profile='ready';quota_status=1;quota=3;changed=0;previous_tick=0xfffffffa if scenario=='wrap'else 100;now={'zero':101,'one':121,'three':164,'wrap':2}[scenario]
 calls.clear();allocations.clear();next_pointer=heap+0xd000;next_aligned=buffer_base;count_allocate=0;fail_nth=0;put(0x1210228,'I',0xffffffff);put(0x12100f4,'I',48000);u.mem_write(settings,bytes([pattern])*16);put(settings+4,'I',3);put(0x14a7d50,'I',0);put(0x14a8338,'I',0xcafe1234);clock_tick=previous_tick;old_reference=invoke(0xb260b0,[settings,3,0],0);assert old_reference!=0;put(0x14a7d50,'I',old_reference);put(0x14a7e48,'I',0);u.mem_write(0x14a7e35,b'\0');put(0x14a79f4,'I',3);output_table=heap+0x8800;u.mem_write(output_table,bytes([pattern])*56);put(output_table+4,'I',old_reference);put(output_table+16,'2I',0,0);put(0x14a7cf8,'2I',output_table,1)
 u.mem_write(common,bytes(0x98));put(common+0x7c,'I',counter);put(0x14a7a5c,'3I',callback_table,callback_count,2);put(callback_table,'2I',*callbacks);put(0x14a82e4,'I',optional);put(0x14a7e4c,'I',heap+0x35000 if final else 0);put(0x14a7a24,'I',heap+0x36000);put(0x14a7a40,'I',heap+0x37000);put(0x12100dc,'I',17);put(0x12101bc,'I',64);put(0x14a82e0,'I',0xffffffff);put(common+0x18,'8I',heap+0x39000,2,2,2,0,0,0,48);put(common+0x80,'2I',1,0);put(common+0x90,'I',456);u.mem_write(heap+0x39000,bytes(16));put(heap+0x39000,'4I',heap+0x3a000,48,heap+0x3a100,0)
 for page in [heap+0x3a000,heap+0x3a100]:u.mem_write(page,bytes([pattern])*64);allocations.append({'reference':page,'size':64,'freed':False})
 allocations.append({'reference':heap+0x39000,'size':16,'freed':False});u.mem_write(heap+0x3a000,bytes.fromhex('1800ffff')+bytes(range(20))+bytes.fromhex('18000000')+bytes(range(20)))
 put(action_vt+0x2c,'I',heap+0x3f200);put(action_vt+0x20,'I',heap+0x3f220);put(action_vt+8,'I',heap+0x3f240);put(command_vt+4,'I',heap+0x3f260)
 put(common+0x44,'3I',due_nodes[0],due_nodes[-1],0);put(common+0x58,'I',3)
 deadlines=[0,1,2]if counter==0 else [0xfffffffe,0xffffffff,0xffffffff]
 for i,(node,command,action)in enumerate(zip(due_nodes,due_commands,due_actions)):
  put(node,'3I',due_nodes[i+1]if i<2 else 0,deadlines[i],command);u.mem_write(command,bytes([pattern])*44);put(command,'2I',command_vt,action);put(command+40,'I',0);u.mem_write(action,bytes([pattern])*153);put(action,'I',action_vt);put(action+32,'H',0x403);allocations.append({'reference':command,'size':44,'freed':False})
 node_appended=False;u.mem_write(heap+0x37000,bytes(12));put(heap+0x37000,'3I',node_table,3,4);u.mem_write(node_table,bytes([pattern])*16);put(node_table,'3I',*frame_nodes[:3])
 for i,node in enumerate(frame_nodes):
  u.mem_write(node,bytes([pattern])*108);put(node,'I',2 if i==1 else 1);binding_table=heap+0x38900+i*64;link=heap+0x38a00+i*64;target=heap+0x38b00+i*64;put(node+32,'2I',binding_table,1);put(node+52,'I',0 if i==0 else 2);put(node+60,'2f',1/1024,.5);put(node+72,'6f',1.+i,-2.,3.,2.,4.,-8.);u.mem_write(binding_table,bytes([pattern])*32);put(binding_table,'I',link);u.mem_write(link,bytes([pattern])*52);put(link+48,'I',target);u.mem_write(target,bytes([pattern])*60);u.mem_write(target+56,bytes([4 if i==2 and optional else 0]))
 rng=17;put(0x12100f8,'I',1024)
 for i,node in enumerate(frame_nodes):
  descriptor=heap+0x38c00+i*32;points=heap+0x38d00+i*64;put(node+4,'I',descriptor);put(node+12,'I',descriptor);put(node+16,'2H',0,2);put(node+20,'H',0);put(node+24,'I',3);u.mem_write(node+29,bytes([optional]));put(node+56,'I',1);put(descriptor,'2I2f',points,2,4.,8.);put(descriptor+16,'2I2f',points,2,8.,4.);history=heap+0x38f00+i*4;put(node+8,'I',history);u.mem_write(history,bytes([0xa5 if optional else 0])*2+bytes([pattern])*2);put(points,'3fI3fI3fI',1.+i,3.,2.,1024,2.+i,4.,-1.,1024,5.+i,6.,0.,1024)
 calls.clear();clock_tick=now;put(0x14a7a28,'I',common)
 def snapshot():return {'common':bytes(u.mem_read(common,0x98)).hex(),'table':bytes(u.mem_read(output_table,56)).hex(),'retry':read(0x14a7e48,'I')[0],'device':read(0x14a7d50,'I')[0],'changed':bytes(u.mem_read(0x14a7e35,1))[0],'settings':bytes(u.mem_read(settings,16)).hex(),'legacy_handle':read(0x14a8338,'I')[0],'callback_header':bytes(u.mem_read(0x14a7a5c,12)).hex(),'callback_table':bytes(u.mem_read(callback_table,8)).hex(),'node_update':{'header':bytes(u.mem_read(heap+0x37000,12)).hex(),'table':bytes(u.mem_read(node_table,16)).hex(),'objects':[{'reference':n,'raw':bytes(u.mem_read(n,108)).hex()}for n in frame_nodes]},'timed_bindings':{'tables':[{'reference':heap+0x38900+i*64,'raw':bytes(u.mem_read(heap+0x38900+i*64,32)).hex()}for i in range(4)],'links':[{'reference':heap+0x38a00+i*64,'raw':bytes(u.mem_read(heap+0x38a00+i*64,52)).hex()}for i in range(4)],'targets':[{'reference':heap+0x38b00+i*64,'raw':bytes(u.mem_read(heap+0x38b00+i*64,60)).hex()}for i in range(4)]},'resources':[{'reference':heap+0x38200+i*80,'raw':bytes(u.mem_read(heap+0x38200+i*80,72)).hex()}for i in range(4)],'paths':{'descriptors':[{'reference':heap+0x38c00+i*32,'raw':bytes(u.mem_read(heap+0x38c00+i*32,32)).hex()}for i in range(4)],'points':[{'reference':heap+0x38d00+i*64,'raw':bytes(u.mem_read(heap+0x38d00+i*64,48)).hex()}for i in range(4)],'rng_state':rng,'interval':1024},'selection':{'masks':[{'reference':heap+0x38f00+i*4,'raw':bytes(u.mem_read(heap+0x38f00+i*4,4)).hex()}for i in range(4)]},'processed':read(0x14a82e0,'I')[0],'due_nodes':[{'reference':n,'raw':bytes(u.mem_read(n,12)).hex()}for n in due_nodes],'due_actions':[{'reference':n,'raw':bytes(u.mem_read(n,153)).hex()}for n in due_actions],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 for i in range(4):
  resource=heap+0x38200+i*80;u.mem_write(resource,bytes([pattern])*72);put(resource+32,'I',3);put(resource+36,'I',1024);put(resource+40,'4I',0,0,0,0);u.mem_write(resource+56,bytes([optional<<5]));u.mem_write(heap+0x38400+i*64,bytes(u.mem_read(heap+0x38d00+i*64,48)));put(heap+0x38600+i*16,'4I',0,2,1,2)
 def reader_snapshot():return {'owners':[{'reference':bank_base+0x1000+i*128,'raw':bytes(u.mem_read(bank_base+0x1000+i*128,96)).hex()}for i in range(4)],'cursors':[read(bank_base+0x2000+i*4,'I')[0]for i in range(4)],'streams':[{'reference':bank_base+0x3000+i*256,'raw':bytes(u.mem_read(bank_base+0x3000+i*256,stream_lengths[i])).hex()}for i in range(4)]}
 stream_lengths=[]
 for i in range(4):
  owner=bank_base+0x1000+i*128;stream=bank_base+0x3000+i*256;u.mem_write(owner,bytes([pattern])*96);put(owner+68,'I',0);prop=bank_base+0x7000+i*128;span=bank_base+0x7800+i*128;u.mem_write(prop,bytes([pattern])*32);u.mem_write(span,bytes([pattern])*32);u.mem_write(prop,b'\x03\x01\x02\x07');put(prop+4,'3I',13,27,257+i);u.mem_write(span,b'\x03\x07\x01\x02');put(span+4,'6i',-4+i,7+i,-13,27,-13,27);put(owner+40,'I',prop);put(owner+72,'I',span);put(0x14ae660,'I',pattern&1)
  payload=bytes([1,0,1])+struct.pack('<II',0,0x12345678)+bytes([1])+struct.pack('<I',3)+bytes([optional])+struct.pack('<I',1024)+bytes([1])+struct.pack('<I',3)+bytes(u.mem_read(heap+0x38d00+i*64,48))+struct.pack('<I4I4f',2,0,2,1,2,4.,8.,8.,4.)
  u.mem_write(stream,payload);stream_lengths.append(len(payload));put(bank_base+0x2000+i*4,'I',stream)
 put(0x121026c,'3I',0x3f800000,0,0xbf800000);reader_before=reader_snapshot()
 put(heap+0x37000,'4I',node_table,0,4,4);before_resources=snapshot();calls.clear();building_resource=True
 for i in range(4):
  resource_slot=i;resource_nth[0]=0;assert invoke(0xaf2c60,[bank_base+0x2000+i*4,0],bank_base+0x1000+i*128)==1
 building_resource=False;reader_after=reader_snapshot();resource_calls=list(calls);after_resources=snapshot();before_creation=after_resources;calls.clear()
 def voice_snapshot():return [{'reference':bank_base+0x5000+i*512,'raw':bytes(u.mem_read(bank_base+0x5000+i*512,408)).hex()}for i in range(4)]
 for i in range(4):
  v=bank_base+0x5000+i*512;q=bank_base+0x5800+i*16;u.mem_write(v,bytes([pattern])*408);put(v+48,'I',heap+0x38200+i*80);put(v+96,'I',bank_base+0x1000+i*128);put(v+104,'I',q);u.mem_write(v+299,bytes([4]));u.mem_write(v+301,bytes([pattern&0x7f]));put(v+400,'2I',0,0x11223344);u.mem_write(q,bytes(12));u.mem_write(q+10,bytes([3]))
 voice_before=voice_snapshot();creating_nodes=True;configuring_history=True
 for i,node in enumerate(frame_nodes):
  created_target=node;history_target=heap+0x38f00+i*4;assert invoke(0xaed8d0,[bank_base+0x5800+i*16],bank_base+0x5000+i*512)==1
 creating_nodes=False;configuring_history=False;voice_configuration_calls=list(calls);voice_after=voice_snapshot();creation_calls=[];before_construction=before_creation;after_construction=snapshot()
 calls.clear();registering_binding=True
 for i,node in enumerate(frame_nodes):
  binding_target=heap+0x38900+i*64;assert invoke(0xb14010,[node,heap+0x38a00+i*64],heap+0x37000)==1
 registering_binding=False;binding_calls=list(calls)
 before_initialization=snapshot();calls.clear();initial_states=[]
 for i,node in enumerate(frame_nodes):
  put(node,'I',0);u.mem_write(node+28,b'\0');state=heap+0x38200+i*80+64;history_target=heap+0x38f00+i*4;u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);
  try:invoke(0xaef540,[],bank_base+0x5000+i*512)
  except Exception:
   print('activation fault',i,'eip',hex(u.reg_read(UC_X86_REG_EIP)),'source',hex(read(bank_base+0x5000+i*512+96,'I')[0]),'source_properties',hex(read(bank_base+0x1000+i*128+40,'I')[0]),hex(read(bank_base+0x1000+i*128+72,'I')[0]));raise
  assert read(node,'I')[0]==1;initial_states.append({'reference':state,'raw':bytes(u.mem_read(state,8)).hex()})
 voice_after_first_activation=voice_snapshot();first_calls=list(calls);calls.clear()
 for i in range(4):invoke(0xaef540,[],bank_base+0x5000+i*512)
 repeat_calls=list(calls);assert len(repeat_calls)==4 and all(c['kind']=='rand'for c in repeat_calls);voice_after_activation=voice_snapshot();calls[:]=first_calls+repeat_calls
 initialization_calls=list(calls);calls.clear();before=snapshot();u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);result=invoke(0xb06950,[],common);after_frame=snapshot();frame_calls=list(calls);calls.clear();path_freed.clear();retiring_path=True
 for node in frame_nodes:retiring_reference=node;assert invoke(0xb14180,[node],heap+0x37000)==1
 retiring_path=False;after_retirement=snapshot();retirement_calls=list(calls);calls.clear();resource_freed.clear();destroying_resources=True
 for i in range(4):invoke(0xaf22a0,[0,1,0,0],bank_base+0x1000+i*128)
 destroying_resources=False;after_resource_teardown=snapshot();rows.append({'native_restart':True,'native_selection':True,'native_activation':True,'native_lifecycle':True,'native_binding_registration':True,'native_manager_lifetime':True,'native_resource':True,'native_resource_reader':True,'native_reader_acquisition':True,'native_voice_configuration':True,'native_voice_once_activation':True,'native_source_properties':True,'voice_after_first_activation':voice_after_first_activation,'repeat_activation_calls':repeat_calls,'source_properties':[{'reference':bank_base+offset+i*128,'raw':bytes(u.mem_read(bank_base+offset+i*128,32)).hex()}for offset in [0x7000,0x7800]for i in range(4)],'voice_after_activation':voice_after_activation,'voice_queries':[{'reference':bank_base+0x5800+i*16,'raw':bytes(u.mem_read(bank_base+0x5800+i*16,12)).hex()}for i in range(4)],'voice_before':voice_before,'voice_after':voice_after,'voice_configuration_calls':voice_configuration_calls,'reader_after_cleanup':reader_snapshot(),'reader_before':reader_before,'reader_after':reader_after,'scenario':scenario,'clock':now,'rate':48000,'command_pool':17,'optional':optional,'final':final,'before_resources':before_resources,'after_resources':after_resources,'resource_calls':resource_calls,'creation_calls':creation_calls,'binding_calls':binding_calls,'before_construction':before_construction,'after_construction':after_construction,'before_initialization':before_initialization,'initial_states':initial_states,'initialization_calls':initialization_calls,'before':before,'result':result,'after':after_frame,'calls':frame_calls,'after_retirement':after_retirement,'retirement_calls':retirement_calls,'path_freed':list(path_freed),'after_resource_teardown':after_resource_teardown,'resource_teardown_calls':list(calls),'resource_freed':list(resource_freed)})

proof={'passed':True,'complete':False,'listener_matrices':[bytes(u.mem_read(0x14a7eb0+i*0x90,36)).hex()for i in range(8)],'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'adapters':['Full native B06950 caller, actual fallback quota, actual B06C60 command consumer with frame/default packets, actual B07E50 nonempty due queue, native reverse callback iteration and wrapping frame counter execute. Actual B14140 class1 traversal with live count reload executes. Actual B1BD10 timed progression and XYZ binding writes execute. Actual B1B680 next-segment path advancement executes; CRT RNG returns qualified sequence values. Actual B1B510 restart-path executes with sequential/looping flags. Actual B1B850 random selection/history with shared RNG executes. Remaining post-frame/optional/final consumers and callback bodies remain controlled interfaces; physical clock/locks adapted.'],'limits':['Nonempty frame/default command packets and three scheduled Play0403 descriptors; concrete action methods remain controlled interfaces. Native configuration B1B9A0 and outer B14310/B1BA70 initial activation execute before full frame; history allocation is a controlled transport. Actual B1B480108byte constructor precedes configuration, activation and whole frame; actual B1BCA0 retirement follows. Actual B14010/AFF610 binding insertion/growth execute between construction and configuration; physical allocation/free remain controlled mandatory transports. Link and owner target constructors are supplied inputs and still need their producer qualification. Actual manager B13FA0 allocation/publication and B14180 owning removal encompass real constructor/binding/configuration/frame/retirement; manager holds four nodes then removes them by swap-last and object release. Actual AF2C60 parser with actual acquisition/72-byte constructor/owner cleanup and actual B1B220 builds shared resource point/descriptor blocks first, B1B3C0/B142D0 configure nodes from resource flags/counts, and B1B430 releases resource blocks last. Root flags/point records/pairs/link-owner inputs remain supplied. Rust whole resource-to-manager lifetime replay required; preparation is not Rust integration acceptance. Controlled remaining consumers/callback bodies are not qualified implementations. Hardware output, normal configuration and complete audio frame remain required.']}
proof['limits'].append('Actual original voice caller AED8D0 creates and configures nodes via source state getter AF1A70 before binding registration and outer activation; source hierarchy gate bit4 and resource flags3 are supplied. Voice/source constructors, other gates/flags, identity sharing, actual outer owner and Rust replay remain required.')
proof['limits'].append('Actual owner AF22A0 disable branch with notification skipped executes auxiliary B1B1F0 (null auxiliary), path B1B430 teardown and virtual destructor AEFDE0/B1B180, then physical resource free. Four 72-byte roots and eight path blocks are retired. Non-null auxiliary, enable branch/property callback, producer defaults and Rust owner-cleanup port remain required.')
proof['limits'].append('Actual AEF540 caller executes initial activation from canonical resource+64 state with original AF3150 nonnull property/range ID7 tables. Supplied source pointers40/72 reference preserved borrowed tables. Original getter draws before each one-shot gate, including the repeated activation call; four extra shared RNG draws and refreshed voice half296 captured. Actual source constructor remains unqualified. Repeat activation suppresses node start while source property lookup/RNG/half296 overwrite still execute before the gate. All four voice bytes recorded after activation; actual voice/source constructors, nonnull property/range tables, final voice retirement, physical output and Rust replay remain required.')
(r/'data/4.20/audio_normal_frame_voice_property_activation_lifetime_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native full frame with owned timed-node/path-segment/native-restart/native-selection compositions, nonempty input queues and explicit remaining consumers')
