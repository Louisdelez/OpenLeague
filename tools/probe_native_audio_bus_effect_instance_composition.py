from pathlib import Path
r=Path('E:/OpenLeague');code=(r/'tools/probe_native_audio_bus_effect_gain_consumers.py').read_text()
setup='''
u.mem_map(heap+0x20000,0x10000)
fx_registry=heap+0x20000;fx_resources=[heap+0x24000+i*0x80 for i in range(3)];fx_originals=[heap+0x25000+i*0x80 for i in range(3)];fx_ids=[100,293,1234]
fx_plugin_table=heap+0x23000;fx_param_table=heap+0x23100;fx_resource_table=heap+0x23200
fx_counter=heap+0x26000;fx_queries={};fx_contexts=[];fx_results=[];fx_profile='success'
fx_locks=[read(0xfa4424,'I')[0],read(0xfa4428,'I')[0]];fx_destructor=read(0xff273c,'I')[0]
put(fx_plugin_table+4,'II',trap+0x500,trap+0x510);put(fx_plugin_table+0xc,'I',trap+0x520);put(fx_plugin_table+0x18,'I',trap+0x530);put(fx_param_table+8,'I',trap+0x540);put(fx_param_table+0x10,'I',trap+0x550);put(fx_resource_table+8,'I',trap+0x570)
regions +=[(0xb270b0,0xb27272),(0xb268e0,0xb26962),(0xb27c00,0xb27c39),(0xb030b0,0xb03142),(0xb02f20,0xb02fbd),(0xaf9530,0xaf9593),(0xb25630,0xb2568a),(0xb29100,0xb29136),(0xb27020,0xb2705e)]
def fx_token(table=0):
 global fx_counter
 pointer=fx_counter;fx_counter+=0x80;u.mem_write(pointer,b'\\xa5'*0x80)
 if table:put(pointer,'I',table)
 return pointer
'''
code=code.replace('def actual_guard(',setup+'\ndef actual_guard(',1)
code=code.replace(' sp=u.reg_read(UC_X86_REG_ESP)\n', ' global fx_counter\n sp=u.reg_read(UC_X86_REG_ESP);who=u.reg_read(UC_X86_REG_ECX)\n',1)
old="  pool,size=read(sp+4,'II');assert size==36;calls.append({'kind':'allocate','size':size});ret(0 if allocation_failure else allocated,0);return"
new="""  pool,size=read(sp+4,'II');calls.append({'kind':'allocate','size':size})
  if size==36:ret(0 if allocation_failure else allocated,0)
  else:
   assert size==28;pointer=fx_token();fx_contexts.append(pointer);ret(pointer,0)
  return"""
assert old in code;code=code.replace(old,new,1)
old=" if a==0xb270b0:calls.append({'kind':'refresh_slot','voice':u.reg_read(UC_X86_REG_ECX),'binding':read(sp+4,'I')[0],'index':read(sp+8,'I')[0]});ret(0,8);return"
assert old in code;code=code.replace(old,'',1)
more='''
 if a in fx_locks:ret(1,4);return
 if a==0xb27269:
  bp=u.reg_read(UC_X86_REG_EBP);fx_results.append([read(bp-4,'I')[0],read(bp+0xc,'I')[0],u.reg_read(UC_X86_REG_ESI)])
 if a==0xb09360:
  allocator,id,out=read(sp+4,'III');status=7 if fx_profile=='factory_fail'else 1;pointer=fx_token(fx_plugin_table)if status==1 else 0;put(out,'I',pointer);calls.append({'kind':'factory','id':id,'status':status,'plugin':pointer});ret(status,0);return
 if a==0xada3e0:calls.append({'kind':'free','reference':read(sp+8,'I')[0]});ret(0,0);return
 if a==0xb12e20:calls.append({'kind':'unsubscribe','parameter':read(sp+4,'I')[0]});ret(0,4);return
 if a==fx_destructor:calls.append({'kind':'context_destroy','reference':who});ret(who,4);return
 if a==trap+0x500:calls.append({'kind':'plugin_destroy','reference':who});ret(0,4);return
 if a==trap+0x510:calls.append({'kind':'plugin_reset','status':1});ret(1,0);return
 if a==trap+0x520:
  query=fx_queries.get(who,0)+1;fx_queries[who]=query;raw=bytes([0,0,0,0,1,0,0,0]);u.mem_write(read(sp+4,'I')[0],raw);calls.append({'kind':'plugin_info','query':query,'status':1,'raw':raw.hex()});ret(1,4);return
 if a==trap+0x530:
  allocator,context,parameter,fmt=read(sp+4,'IIII');status=7 if fx_profile=='init_fail'else 1;calls.append({'kind':'plugin_init','context':context,'parameter':parameter,'format':bytes(u.mem_read(fmt,8)).hex(),'status':status});ret(status,16);return
 if a==trap+0x540:calls.append({'kind':'clone','reference':who});ret(fx_token(fx_param_table),4);return
 if a==trap+0x550:calls.append({'kind':'parameter_destroy','reference':who});ret(0,4);return
 if a==trap+0x570:
  value=read(who+0xc,'I')[0]-1;put(who+0xc,'I',value);calls.append({'kind':'resource_release','reference':who});ret(value,0);return
'''
code=code.replace(' assert any(lo<=a<hi for lo,hi in regions),hex(a)',more+' assert any(lo<=a<hi for lo,hi in regions),hex(a)',1)
initial='''
 fx_counter=heap+0x26000;fx_queries.clear();fx_contexts.clear();fx_results.clear();fx_profile=['success','factory_fail','init_fail'][existing]
 u.mem_write(fx_registry,bytes(0x2600));put(0x14a7a08,'I',fx_registry);put(0x12100f4,'I',48000)
 for i,(pointer,id,parameter)in enumerate(zip(fx_resources,fx_ids,fx_originals)):
  u.mem_write(pointer,bytes(48));put(pointer,'IIIIII',fx_resource_table,0,id,7,0x00810003,parameter);put(parameter,'I',fx_param_table)
  for category in [0x1c20,0x1f40]:
   bucket=fx_registry+category+0x18+(id%193)*4;previous=read(bucket,'I')[0];put(pointer+4,'I',previous);put(bucket,'I',pointer)
'''
code=code.replace(' u.mem_write(node,bytes(200));',initial+' u.mem_write(node,bytes(200));',1)
old="  u.mem_write(target,b'\\xa5'*0x500);"
# Keep the original target initialization, then clear the four old instance pointers.
needle=' before_source=bytes(u.mem_read(source,20)).hex();'
clear='''
 for target in targets:
  put(target+0x41c,'I',3)
  for slot_index in range(4):put(target+0x470+slot_index*20,'IIII',0xffffffff,0,0,0)
'''
assert needle in code;code=code.replace(needle,clear+needle,1)
code=code.replace("'mode':mode,'existing':existing", "'fx_profile':fx_profile,'fx_contexts':[{'reference':p,'raw':bytes(u.mem_read(p,28)).hex()}for p in fx_contexts],'fx_results':list(fx_results),'fx_refcounts':[read(p+0xc,'I')[0]for p in fx_resources],'mode':mode,'existing':existing",1)
code=code.replace("audio_bus_effect_gain_consumers_contract.json","audio_bus_effect_instance_composition_contract.json")
code=code.replace("only B270B0 effect-instance replacement is a mandatory recorded interface.","B270B0/B268E0 resource selection and state machine also execute. Plugin factory/virtual methods, clone/destroy, reference release, context destructor, unsubscribe, mutexes and allocation/free remain mandatory explicit interfaces.")
code=code.replace("full effects reader with actual gain/state/RTPC/spatial/application consumers","full effects reader with actual effect-instance state machine and explicit plugin interfaces")
exec(compile(code,'native-instance-composition','exec'))
