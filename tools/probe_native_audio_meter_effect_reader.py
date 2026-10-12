from pathlib import Path
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_audio_bus_effect_instance_composition.py').read_text(encoding='utf-8').split("\nexec(compile(code,'native-instance-composition','exec'))")[0]
exec(compile(prefix,'prepare-existing-composition','exec'))
start=code.index('\nu.mem_map(heap+0x20000,0x10000)');end=code.index('\ndef actual_guard(',start)
setup=r'''
u.mem_map(heap+0x20000,0x10000)
fx_registry=heap+0x20000;fx_resources=[heap+0x24000+i*0x80 for i in range(3)];fx_originals=[heap+0x25000+i*0x80 for i in range(3)];fx_ids=[100,293,1234]
fx_allocator=0x121023c;fx_allocator_table=heap+0x23000;fx_resource_table=heap+0x23200;fx_factory_table=heap+0x23400
put(fx_allocator,'I',fx_allocator_table);put(fx_allocator_table+4,'II',trap+0x500,trap+0x510);put(fx_resource_table+8,'I',trap+0x570);put(fx_factory_table,'III',0x00810003,0xb3e260,0xb3df60);put(0x14a7abc,'II',fx_factory_table,1);put(0x1210228,'I',0xffffffff)
fx_counter=heap+0x26000;fx_contexts=[];fx_results=[];fx_profile='success';fx_allocations=[]
fx_locks=[read(0xfa4424,'I')[0],read(0xfa4428,'I')[0]];fx_destructor=read(0xff273c,'I')[0]
regions +=[(0xb270b0,0xb27272),(0xb268e0,0xb26962),(0xb27c00,0xb27c39),(0xb030b0,0xb03142),(0xb02f20,0xb02fbd),(0xaf9530,0xaf9593),(0xb25630,0xb2568a),(0xb29100,0xb29136),(0xb27020,0xb270a7),(0xb09360,0xb093b7),(0xb3e260,0xb3e29d),(0xb3dfe0,0xb3e032),(0xb3e040,0xb3e07d),(0xb3e080,0xb3e0a3),(0xb3e1d0,0xb3e1f2),(0xb3e2e0,0xb3e34f),(0xb3e350,0xb3e3dc),(0xb3e3e0,0xb3e3fb),(0xb3eb60,0xb3ebba),(0xb3f280,0xb3f2a2)]
def fx_allocate(method,owner,size):
 global fx_counter
 fail=(fx_profile=='factory_fail'and size==84)or(fx_profile=='manager_fail'and size==16)
 pointer=0 if fail else fx_counter
 if pointer:
  fx_counter+=0x80;u.mem_write(pointer,b'\xa5'*size);fx_allocations.append({'reference':pointer,'size':size,'freed':False})
  if size==28:fx_contexts.append(pointer)
 calls.append({'kind':'fx_allocate','method':method,'allocator':owner,'size':size,'reference':pointer});return pointer
def fx_free(kind,owner,pointer):
 allocation=next(row for row in fx_allocations if row['reference']==pointer);assert not allocation['freed'];allocation['freed']=True;calls.append({'kind':kind,'allocator':owner,'reference':pointer})
'''
code=code[:start]+setup+code[end:]
start=code.index(' if a==0xada670:');end=code.index(' if a==0xb03d40:',start)
code=code[:start]+''' if a==0xada670:
  pool,size=read(sp+4,'II')
  if size==36:calls.append({'kind':'allocate','size':size});ret(0 if allocation_failure else allocated,0)
  else:ret(fx_allocate('pool',pool,size),0)
  return
'''+code[end:]
start=code.index(' if a in fx_locks:');end=code.index(' assert any(lo<=a<hi for lo,hi in regions),hex(a)',start)
more=''' if a in fx_locks:ret(1,4);return
 if a==0xb27269:
  bp=u.reg_read(UC_X86_REG_EBP);fx_results.append([read(bp-4,'I')[0],read(bp+0xc,'I')[0],u.reg_read(UC_X86_REG_ESI)])
 if a==trap+0x500:ret(fx_allocate('virtual',who,read(sp+4,'I')[0]),4);return
 if a==trap+0x510:fx_free('fx_free_virtual',who,read(sp+4,'I')[0]);ret(0,4);return
 if a==0xada3e0:owner,pointer=read(sp+4,'II');fx_free('fx_free_pool',owner,pointer);ret(0,0);return
 if a==0xb12e20:calls.append({'kind':'unsubscribe','parameter':read(sp+4,'I')[0]});ret(0,4);return
 if a==fx_destructor:calls.append({'kind':'context_destroy','reference':who});ret(who,4);return
 if a==0xae9f60:calls.append({'kind':'fx_register_callback','callback':read(sp+4,'I')[0]});ret(0,0);return
 if a==trap+0x570:
  value=read(who+0xc,'I')[0]-1;put(who+0xc,'I',value);calls.append({'kind':'resource_release','reference':who});ret(value,0);return
'''
code=code[:start]+more+code[end:]
code=code.replace("fx_counter=heap+0x26000;fx_queries.clear();fx_contexts.clear();fx_results.clear();fx_profile=['success','factory_fail','init_fail'][existing]", "fx_counter=heap+0x26000;fx_contexts.clear();fx_results.clear();fx_allocations.clear();fx_profile=['success','factory_fail','manager_fail'][existing];put(0x14a83c4,'I',0)")
code=code.replace("put(parameter,'I',fx_param_table)", "u.mem_write(parameter,bytes(32));put(parameter,'IIIIIIII',0xff36a4,0,0x3dcccccd,0xc2400000,0x40c00000,0,0,id)")
code=code.replace("'fx_profile':fx_profile,", "'fx_allocations':[{**row,'raw':bytes(u.mem_read(row['reference'],row['size'])).hex()}for row in fx_allocations],'fx_manager':read(0x14a83c4,'I')[0],'fx_source_parameters':[{'reference':p,'raw':bytes(u.mem_read(p,32)).hex()}for p in fx_originals],'fx_profile':fx_profile,")
code=code.replace('audio_bus_effect_instance_composition_contract.json','audio_meter_effect_reader_contract.json')
code=code.replace("proof={'passed':True","proof={'meter_bodies':'Actual Meter factory,creation,clone,info,Init,Reset and immediate Term/cleanup execute behind complete effect reader;kernel/resource/context/subscription/callback boundaries explicit. No Meter plugin result adapters.','passed':True",1)
code=code.replace('Plugin factory/virtual methods, clone/destroy, reference release, context destructor, unsubscribe, mutexes and allocation/free remain mandatory explicit interfaces.', 'Actual Meter factory/virtual methods and clone/destructor/manager bodies also execute;reference release,context destructor,unsubscribe,mutexes,callback registration and allocation/free remain explicit services.')
code=code.replace('full effects reader with actual effect-instance state machine and explicit plugin interfaces','full effects reader with actual Meter instance bodies')
exec(compile(code,'native-meter-reader-composition','exec'))
