from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
u.mem_map(heap+0x10000,0x10000)
voice=heap+0x1000;node=heap+0x2000;cache=heap+0x3000;binding=heap+0x3100;old_plugin=heap+0x4000;old_param=heap+0x4100;old_context=heap+0x4200;original=heap+0x5000;clone=heap+0x5100;context=heap+0x5200;plugin=heap+0x5300;resource=heap+0x6000;resource_table=heap+0x6200;plugin_table=heap+0x6300;param_table=heap+0x6400;context_table=heap+0x6500;registry=heap+0x18000;calls=[];query=0;profile='none'
locks={read(0xfa4424,'I')[0]:'lock',read(0xfa4428,'I')[0]:'unlock'};ctx_destructor=read(0xff273c,'I')[0]
methods={trap+0x500:'plugin_destroy',trap+0x510:'plugin_reset',trap+0x520:'plugin_info',trap+0x530:'plugin_init',trap+0x540:'clone',trap+0x550:'parameter_destroy',trap+0x560:'context_destroy',trap+0x570:'resource_release'}
put(plugin_table+4,'II',trap+0x500,trap+0x510);put(plugin_table+0xc,'I',trap+0x520);put(plugin_table+0x18,'I',trap+0x530);put(param_table+8,'I',trap+0x540);put(param_table+0x10,'I',trap+0x550);put(context_table,'I',trap+0x560);put(resource_table+8,'I',trap+0x570)
regions=[(0xb270b0,0xb27272),(0xb268e0,0xb26962),(0xb27c00,0xb27c39),(0xb030b0,0xb03142),(0xb02f20,0xb02fbd),(0xaf9530,0xaf9593),(0xb25630,0xb2568a),(0xb29100,0xb29136),(0xb27020,0xb270a7)]
def guard(uc,a,n,d):
 global query
 sp=u.reg_read(UC_X86_REG_ESP);who=u.reg_read(UC_X86_REG_ECX)
 if a in locks:ret(1,4);return
 if a==0xb09360:
  allocator,id,out=read(sp+4,'III');status=7 if profile=='factory_fail'else 1;put(out,'I',plugin if status==1 else 0);calls.append({'kind':'factory','id':id,'status':status});ret(status,0);return
 if a==0xada670:
  pool,size=read(sp+4,'II');assert size==28;calls.append({'kind':'allocate','size':size});ret(0 if profile=='allocation_fail'else context,0);return
 if a==0xada3e0:calls.append({'kind':'free','reference':read(sp+8,'I')[0]});ret(0,0);return
 if a==0xb12e20:calls.append({'kind':'unsubscribe','parameter':read(sp+4,'I')[0]});ret(0,4);return
 if a==ctx_destructor:
  calls.append({'kind':'context_destroy','reference':who});ret(who,4);return
 if a in methods:
  kind=methods[a]
  if kind=='resource_release':
   count=read(who+0xc,'I')[0];put(who+0xc,'I',count-1);calls.append({'kind':kind,'reference':who});ret(count-1,0);return
  if kind=='clone':calls.append({'kind':kind,'reference':who});ret(0 if profile=='clone_fail'else clone,4);return
  if kind=='plugin_info':
   query+=1;out=read(sp+4,'I')[0];raw=bytearray(8);raw[4]=0 if profile=='not_inplace'else 1;raw[5]=1 if profile=='info_flag'and query==2 else 0;u.mem_write(out,bytes(raw));status=7 if profile=='info_fail'and query==2 else 1;calls.append({'kind':kind,'query':query,'status':status,'raw':raw.hex()});ret(status,4);return
  if kind=='plugin_init':
   allocator,ctx,param,fmt=read(sp+4,'IIII');status=7 if profile=='init_fail'else 1;calls.append({'kind':kind,'context':ctx,'parameter':param,'format':bytes(u.mem_read(fmt,8)).hex(),'status':status});ret(status,16);return
  if kind=='plugin_reset':status=7 if profile=='reset_fail'else 1;calls.append({'kind':kind,'status':status});ret(status,0);return
  calls.append({'kind':kind,'reference':who});ret(0,4);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
profiles=['none','factory_fail','not_inplace','clone_fail','allocation_fail','info_flag','info_fail','init_fail','reset_fail','success']
for profile,old_mask,index,bypass,category in itertools.product(profiles,range(8),range(4),[0,255],[0,1]):
 u.mem_write(voice,b'\xa5'*0x500);put(voice+0x41c,'I',[0,3,0x600][index%3]);slot=voice+0x470+index*20;put(slot,'IIII',999,old_param if old_mask&1 else 0,old_plugin if old_mask&2 else 0,old_context if old_mask&4 else 0)
 for ptr,vt in [(old_plugin,plugin_table),(plugin,plugin_table),(old_param,param_table),(original,param_table),(clone,param_table),(old_context,context_table)]:put(ptr,'I',vt)
 u.mem_write(context,b'\xa5'*28);u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+0x18,'I',cache);u.mem_write(cache,bytes(36));put(cache+index*8,'BB',0,category);put(cache+index*8+4,'I',100);u.mem_write(cache+0x20,bytes([bypass]));put(binding,'I',node);u.mem_write(registry,bytes(0x2600));put(0x14a7a08,'I',registry);put(0x12100f4,'I',48000)
 u.mem_write(resource,bytes(48));put(resource,'IIIIII',resource_table,0,100,7,0x00810003,original)
 if profile!='none':put(registry+(0x1c20 if category else 0x1f40)+0x18+(100%193)*4,'I',resource)
 before=bytes(u.mem_read(voice,0x500)).hex();calls.clear();query=0;sp=stack+0x8000;put(sp,'III',trap,binding,index);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0xb270b0,trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'profile':profile,'old_mask':old_mask,'index':index,'bypass':bypass,'category':category,'before':before,'after':bytes(u.mem_read(voice,0x500)).hex(),'context':bytes(u.mem_read(context,28)).hex(),'resource_refcount':read(resource+0xc,'I')[0],'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual B270B0/B268E0 teardown/replacement, Bus E0 B030B0/B02F20 getter and AF9530 lookup/retain, empty B25630 parameter bindings, B29100 constructor and B27020 format pack execute. Mutex functions, plugin factory/virtual methods, clone/destroy, resource release, context destructor, unsubscribe and allocation/free are mandatory explicit interfaces. No plugin DSP/body fidelity claimed.'],'limits':['Preparatory Rust state-machine contract; actual plugin resource/parameter initialization and RTPC binding lifecycle, destructors/factory/mixer remain required.','Finite controlled pointers, four slots, static bypass and empty resource RTPC subscription list. Native clock/device/audio acceptance unqualified.']}
(r/'data/4.20/audio_bus_effect_instance_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual effect-instance replacement/status/cleanup interface cases')

