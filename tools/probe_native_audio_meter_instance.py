from pathlib import Path
from native_x87 import HardwareFyl2x
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
u.mem_map(heap+0x10000,0x10000);u.mem_map(heap+0x30000,0x10000)
voice=heap+0x1000;node=heap+0x2000;cache=heap+0x3000;binding=heap+0x3100;original=heap+0x5000;resource=heap+0x6000;resource_table=heap+0x6200;allocator_table=heap+0x6500;registry=heap+0x18000;factory_table=heap+0x7000;buffer=heap+0x8000;samples=heap+0x9000;allocator=0x121023c;pool=0xffffffff;calls=[];allocations=[];next_pointer=heap+0x30000;profile='success';pattern=0;category=0
put(allocator,'I',allocator_table);put(allocator_table+4,'II',trap+0x500,trap+0x510);put(resource_table+8,'I',trap+0x520);put(factory_table,'III',0x00810003,0xb3e260,0xb3df60);put(0x14a7abc,'II',factory_table,1);put(0x1210228,'I',pool);put(0x12100f4,'I',48000);put(0x14a7a3c,'I',heap+0xa000)
locks={read(0xfa4424,'I')[0]:'lock',read(0xfa4428,'I')[0]:'unlock'};ctx_destructor=read(0xff273c,'I')[0];hardware=HardwareFyl2x();finit=trap+0x600;u.mem_write(finit,b'\xdb\xe3\xc3')
regions=[(0xb270b0,0xb27272),(0xb268e0,0xb26962),(0xb27c00,0xb27c39),(0xb030b0,0xb03142),(0xb02f20,0xb02fbd),(0xaf9530,0xaf9593),(0xb25630,0xb2568a),(0xb29100,0xb29136),(0xb27020,0xb270a7),(0xb09360,0xb093b7),(0xb3e260,0xb3e29d),(0xb3dfe0,0xb3e032),(0xb3e040,0xb3e07d),(0xb3e080,0xb3e0a3),(0xb3e1d0,0xb3e1f2),(0xb3e2e0,0xb3e34f),(0xb3e350,0xb3e3dc),(0xb3e3e0,0xb3e3fb),(0xb3eb60,0xb3ebba),(0xb3e400,0xb3eaab),(0xb3ebc0,0xb3ed43),(0xb3f280,0xb3f2a2),(0xca2770,0xca2786),(0xca1e10,0xca1e3b)]
def allocate(method,owner,size):
 global next_pointer
 failure={'factory_fail':84,'clone_fail':32,'context_fail':28,'manager_fail':16}.get(profile)==size
 reference=0 if failure else next_pointer
 if reference:next_pointer+=0x100;u.mem_write(reference,bytes([pattern])*size);allocations.append({'reference':reference,'size':size,'freed':False})
 calls.append({'kind':'allocate','method':method,'allocator':owner,'size':size,'reference':reference});return reference
def release(kind,owner,reference):
 calls.append({'kind':kind,'allocator':owner,'reference':reference});allocation=next(a for a in allocations if a['reference']==reference);assert not allocation['freed'];allocation['freed']=True

def guard(uc,a,n,d):
 if a in [0xb3e570,0xb3e676,0xb3e6b7]:hardware.execute(u,a);return
 sp=u.reg_read(UC_X86_REG_ESP);who=u.reg_read(UC_X86_REG_ECX)
 if a in locks:calls.append({'kind':locks[a],'category':category!=0});ret(1,4);return
 if a==trap+0x500:ret(allocate('virtual',who,read(sp+4,'I')[0]),4);return
 if a==trap+0x510:release('free_virtual',who,read(sp+4,'I')[0]);ret(0,4);return
 if a==trap+0x520:count=read(who+12,'I')[0]-1;put(who+12,'I',count);calls.append({'kind':'resource_release','reference':who});ret(count,0);return
 if a==0xada670:owner,size=read(sp+4,'II');ret(allocate('pool',owner,size),0);return
 if a==0xada3e0:owner,reference=read(sp+4,'II');release('free_pool',owner,reference);ret(0,0);return
 if a==0xb12e20:calls.append({'kind':'unsubscribe','parameter':read(sp+4,'I')[0]});ret(0,4);return
 if a==ctx_destructor:calls.append({'kind':'context_destroy','reference':who});ret(who,4);return
 if a in [0xae9f60,0xaeaf90]:calls.append({'kind':'register_callback'if a==0xae9f60 else'unregister_callback','callback':read(sp+4,'I')[0]});ret(0,0);return
 if a==0xb12320:
  id,bits,owner,transition,mode=read(sp+4,'5I');calls.append({'kind':'set_rtpc','manager':who,'id':id,'bits':bits,'owner':owner,'transition':list(read(transition,'2I')),'mode':mode});ret(1,20);return
 if a==0xca1d00:
  dst,value,size=read(sp+4,'3I');u.mem_write(dst,bytes([value&255])*size);calls.append({'kind':'clear','offset':dst-samples,'size':size});ret(dst,0);return
 if finit<=a<finit+3:return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(entry,args=(),this=voice):
 sp=stack+0x8000;put(sp,'I'*(len(args)+1),trap,*args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.emu_start(entry,trap,count=40000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
def snapshot(stage,result,processed=False):
 copied=[{**item,'raw':bytes(u.mem_read(item['reference'],item['size'])).hex()}for item in allocations]
 return {'stage':stage,'result':result,'voice':bytes(u.mem_read(voice,0x500)).hex(),'source_parameter':bytes(u.mem_read(original,32)).hex(),'resource_refcount':read(resource+12,'I')[0],'global_manager':read(0x14a83c4,'I')[0],'allocations':copied,'processed':processed,'buffer':bytes(u.mem_read(buffer,16)).hex()if processed else None,'samples':bytes(u.mem_read(samples,64)).hex()if processed else None,'calls':list(calls)}
rows=[]
for profile,index,bypass,category,pattern in itertools.product(['missing','unregistered','factory_fail','clone_fail','context_fail','manager_fail','success'],range(4),[0,255],[0,1],[0,0xa5,0xff]):
 calls.clear();allocations.clear();next_pointer=heap+0x30000;put(0x14a83c4,'I',0);u.mem_write(voice,b'\xa5'*0x500);put(voice+0x41c,'I',3);put(voice+0x470+index*20,'IIII',999,0,0,0);u.mem_write(original,bytes([pattern])*32);put(original,'I',0xff36a4);assert invoke(0xb3e040,[allocator,0,0],original)==1;put(original+28,'I',100)
 u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+24,'I',cache);u.mem_write(cache,bytes(36));put(cache+index*8,'BB',0,category);put(cache+index*8+4,'I',100);u.mem_write(cache+32,bytes([bypass]));put(binding,'I',node);u.mem_write(registry,bytes(0x2600));put(0x14a7a08,'I',registry);u.mem_write(resource,bytes(48));put(resource,'IIIIII',resource_table,0,100,7,0xdeadbeef if profile=='unregistered'else 0x00810003,original)
 if profile!='missing':put(registry+(0x1c20 if category else 0x1f40)+24+(100%193)*4,'I',resource)
 invoke(finit);before=bytes(u.mem_read(voice,0x500)).hex();source=bytes(u.mem_read(original,32)).hex();stages=[]
 for step in range(2):
  calls.clear();result=invoke(0xb270b0,[binding,index]);plugin=read(voice+0x470+index*20+8,'I')[0];processed=result==1 and plugin!=0
  if processed:
   raw=struct.pack('<16f',*([-0.25,.5,-1.,.125,0.,-.75,.25,1.]*2));u.mem_write(samples,raw);put(buffer,'IIIHH',samples,3,17,8,4);invoke(0xb3e400,[buffer],plugin)
  stages.append(snapshot('replace'+str(step),result,processed))
 calls.clear();invoke(0xb268e0,[index]);stages.append(snapshot('teardown',1));calls.clear()
 if read(0x14a83c4,'I')[0]:invoke(0xb3ed30,[0])
 stages.append(snapshot('update',1));rows.append({'profile':profile,'index':index,'bypass':bypass,'category':category,'pattern':pattern,'before':before,'source_parameter':source,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'arithmetic_boundary':hardware.metadata(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual instance/resource lookup/retain/factory/Meter creator/clone/info/Init/Reset/Term/Process/callback/update and intrusive ownership bodies execute. Kernel allocation/free/mutex,context destructor,unsubscribe,resource virtual release,callback registration/unregistration and actual RTPC setter remain explicit boundaries.','FYL2X executes actual processor instruction on80-bit operands to correct verified Unicorn domain discrepancy; other PE instructions execute in emulation.'],'findings':['Two consecutive replacements retain old successful Meter effect until final callback,while its cloned parameter/context are released earlier;callback then frees both effects and manager.','Actual allocation failures84/32/28/16 bytes and missing factory/resource are differentiated with exact voice fields,raw allocations and callback order.','Direct Process is called on successful plugin instances;this does not qualify normal bypass/admission/device scheduling.'],'limits':['Controlled original initialized resource parameters,empty RTPC subscription list,static bypass and registry with only Meter;normal HIRC8/registration producer/resource construction remain required.','Physical device,bank reader scheduling,RTPC mutation/propagation,concurrency/lifetime and audible acceptance incomplete.']};hardware.close();(r/'data/4.20/audio_meter_instance_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Meter instance/two replacements/DSP/teardown/update cases')
