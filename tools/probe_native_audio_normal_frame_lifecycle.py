from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_factory_actual_fallback.py').read_text(encoding='utf-8').split('\nfor kind,retry,scenario')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_live_fallback)','live_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_live_fallback)');exec(compile(setup,'live_setup','exec'));u.hook_del(live_hook)
common=heap+0x31000;callback_table=heap+0x32000;callbacks=[heap+0x34000,heap+0x34010];due_nodes=[heap+0x3c000+i*16 for i in range(3)];due_commands=[heap+0x3d000+i*64 for i in range(3)];due_actions=[heap+0x3e000+i*256 for i in range(3)];action_vt=heap+0x3f000;command_vt=heap+0x3f100;due_methods={heap+0x3f200:'due_query',heap+0x3f220:'due_execute',heap+0x3f240:'due_release',heap+0x3f260:'due_destroy'};lock_api=read(0xfa4424,'I')[0];unlock_api=read(0xfa4428,'I')[0]
node_table=heap+0x38800;frame_nodes=[heap+0x38000+i*128 for i in range(4)];node_appended=False
post={0xb1c590:'optional',0xaf5b10:'advance_a',0xb14140:'advance_b',0xb19ec0:'post_a',0xaf3f80:'post_b',0xb0fdb0:'post_c',0xaf3aa0:'post_d',0xb15110:'final'}
def frame_guard(uc,a,n,d):
 global node_appended,rng
 sp=u.reg_read(UC_X86_REG_ESP);receiver=u.reg_read(UC_X86_REG_ECX)
 if a==0xada3e0 and retiring_path:
  assert read(sp+4,'I')[0]==17;reference=read(sp+8,'I')[0];assert reference not in path_freed and reference in [heap+0x38900+i*16 for i in range(4)]+[heap+0x38f00+i*4 for i in range(4)];path_freed.append(reference);calls.append({'kind':'path_free','pool':17,'reference':reference,'node':retiring_reference,'node_at_call':bytes(u.mem_read(retiring_reference,108)).hex()});ret(1,0);return
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
retiring_path=False;retiring_reference=0;path_freed=[];configuring_history=False;history_target=0;u.hook_add(unicorn.UC_HOOK_CODE,frame_guard);rows=[]
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
  u.mem_write(node,bytes([pattern])*108);put(node,'I',2 if i==1 else 1);binding_table=heap+0x38900+i*16;link=heap+0x38a00+i*64;target=heap+0x38b00+i*64;put(node+32,'2I',binding_table,1);put(node+52,'I',0 if i==0 else 2);put(node+60,'2f',1/1024,.5);put(node+72,'6f',1.+i,-2.,3.,2.,4.,-8.);u.mem_write(binding_table,bytes([pattern])*4);put(binding_table,'I',link);u.mem_write(link,bytes([pattern])*52);put(link+48,'I',target);u.mem_write(target,bytes([pattern])*60);u.mem_write(target+56,bytes([4 if i==2 and optional else 0]))
 rng=17;put(0x12100f8,'I',1024)
 for i,node in enumerate(frame_nodes):
  descriptor=heap+0x38c00+i*32;points=heap+0x38d00+i*64;put(node+4,'I',descriptor);put(node+12,'I',descriptor);put(node+16,'2H',0,2);put(node+20,'H',0);put(node+24,'I',3);u.mem_write(node+29,bytes([optional]));put(node+56,'I',1);put(descriptor,'2I2f',points,2,4.,8.);put(descriptor+16,'2I2f',points,2,8.,4.);history=heap+0x38f00+i*4;put(node+8,'I',history);u.mem_write(history,bytes([0xa5 if optional else 0])*2+bytes([pattern])*2);put(points,'3fI3fI3fI',1.+i,3.,2.,1024,2.+i,4.,-1.,1024,5.+i,6.,0.,1024)
 calls.clear();clock_tick=now;put(0x14a7a28,'I',common)
 def snapshot():return {'common':bytes(u.mem_read(common,0x98)).hex(),'table':bytes(u.mem_read(output_table,56)).hex(),'retry':read(0x14a7e48,'I')[0],'device':read(0x14a7d50,'I')[0],'changed':bytes(u.mem_read(0x14a7e35,1))[0],'settings':bytes(u.mem_read(settings,16)).hex(),'legacy_handle':read(0x14a8338,'I')[0],'callback_header':bytes(u.mem_read(0x14a7a5c,12)).hex(),'callback_table':bytes(u.mem_read(callback_table,8)).hex(),'node_update':{'header':bytes(u.mem_read(heap+0x37000,12)).hex(),'table':bytes(u.mem_read(node_table,16)).hex(),'objects':[{'reference':n,'raw':bytes(u.mem_read(n,108)).hex()}for n in frame_nodes]},'timed_bindings':{'tables':[{'reference':heap+0x38900+i*16,'raw':bytes(u.mem_read(heap+0x38900+i*16,4)).hex()}for i in range(4)],'links':[{'reference':heap+0x38a00+i*64,'raw':bytes(u.mem_read(heap+0x38a00+i*64,52)).hex()}for i in range(4)],'targets':[{'reference':heap+0x38b00+i*64,'raw':bytes(u.mem_read(heap+0x38b00+i*64,60)).hex()}for i in range(4)]},'paths':{'descriptors':[{'reference':heap+0x38c00+i*32+slot*16,'raw':bytes(u.mem_read(heap+0x38c00+i*32+slot*16,16)).hex()}for i in range(4)for slot in range(2)],'points':[{'reference':heap+0x38d00+i*64,'raw':bytes(u.mem_read(heap+0x38d00+i*64,48)).hex()}for i in range(4)],'rng_state':rng,'interval':1024},'selection':{'masks':[{'reference':heap+0x38f00+i*4,'raw':bytes(u.mem_read(heap+0x38f00+i*4,4)).hex()}for i in range(4)]},'processed':read(0x14a82e0,'I')[0],'due_nodes':[{'reference':n,'raw':bytes(u.mem_read(n,12)).hex()}for n in due_nodes],'due_actions':[{'reference':n,'raw':bytes(u.mem_read(n,153)).hex()}for n in due_actions],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before_construction=snapshot()
 for node in frame_nodes:assert invoke(0xb1b480,[],node)==node
 after_construction=snapshot()
 # Existing bound resources supplied at the still-mandatory registration boundary.
 for i,node in enumerate(frame_nodes):put(node+32,'3I',heap+0x38900+i*16,1,1)
 before_initialization=snapshot();calls.clear();initial_states=[]
 for i,node in enumerate(frame_nodes):
  put(node,'I',0);u.mem_write(node+28,b'\0');state=heap+0x38e00+i*16;u.mem_write(state,bytes(8));history_target=heap+0x38f00+i*4;configuring_history=True;u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);configured=invoke(0xb1b9a0,[heap+0x38c00+i*32,2,3,optional,state],node);configuring_history=False;assert configured==1;activated=invoke(0xb14310,[node,state],0);assert activated==1;initial_states.append({'reference':state,'raw':bytes(u.mem_read(state,8)).hex()})
 initialization_calls=list(calls);calls.clear();before=snapshot();u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);result=invoke(0xb06950,[],common);after_frame=snapshot();frame_calls=list(calls);calls.clear();path_freed.clear();retiring_path=True
 for node in frame_nodes:retiring_reference=node;invoke(0xb1bca0,[],node)
 retiring_path=False;after_retirement=snapshot();retirement_calls=list(calls);rows.append({'native_restart':True,'native_selection':True,'native_activation':True,'native_lifecycle':True,'scenario':scenario,'clock':now,'rate':48000,'command_pool':17,'optional':optional,'final':final,'before_construction':before_construction,'after_construction':after_construction,'before_initialization':before_initialization,'initial_states':initial_states,'initialization_calls':initialization_calls,'before':before,'result':result,'after':after_frame,'calls':frame_calls,'after_retirement':after_retirement,'retirement_calls':retirement_calls,'path_freed':list(path_freed)})

proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'adapters':['Full native B06950 caller, actual fallback quota, actual B06C60 command consumer with frame/default packets, actual B07E50 nonempty due queue, native reverse callback iteration and wrapping frame counter execute. Actual B14140 class1 traversal with live count reload executes. Actual B1BD10 timed progression and XYZ binding writes execute. Actual B1B680 next-segment path advancement executes; CRT RNG returns qualified sequence values. Actual B1B510 restart-path executes with sequential/looping flags. Actual B1B850 random selection/history with shared RNG executes. Remaining post-frame/optional/final consumers and callback bodies remain controlled interfaces; physical clock/locks adapted.'],'limits':['Nonempty frame/default command packets and three scheduled Play0403 descriptors; concrete action methods remain controlled interfaces. Native configuration B1B9A0 and outer B14310/B1BA70 initial activation execute before full frame; history allocation is a controlled transport. Actual B1B480108byte constructor precedes configuration, activation and whole frame; actual B1BCA0 retirement follows. Binding registration and physical release remain controlled mandatory boundaries. Rust whole-lifetime replay required; preparation is not Rust integration acceptance. Controlled remaining consumers/callback bodies are not qualified implementations. Hardware output, normal configuration and complete audio frame remain required.']}
(r/'data/4.20/audio_normal_frame_lifecycle_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native full frame with owned timed-node/path-segment/native-restart/native-selection compositions, nonempty input queues and explicit remaining consumers')
