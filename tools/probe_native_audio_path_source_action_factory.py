from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;action=vector+0x2000;existing=vector+0x3000;registry=vector+0x4000;table=vector+0x4100;owners=vector+0x4200;manager=vector+0x5000;calls=[];visited=set();failure=False;freed=[]
regions=[('source',source,120),('action',action,44),('existing',existing,132),('registry',registry,12),('table',table,24),('registry_owners',owners,96),('source_manager',manager,800)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);size=read(sp+8);assert size in[120,44];result=source if size==120 else 0 if failure else action;calls.append({'kind':'allocate','pool':read(sp+4),'size':size,'result':result,'at_call':snap()});finish(result);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);reference=read(sp+8);assert reference not in freed;freed.append(reference);calls.append({'kind':'free','pool':read(sp+4),'reference':reference,'at_call':snap()});finish(1);return
 if a in [read(0xfa4424),read(0xfa4428)]:finish(0,4);return
 if a in[0xaf6950,0xaf6b40]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'register_action'if a==0xaf6950 else'read_action_type','receiver':u.reg_read(UC_X86_REG_ECX),'key':read(sp+4),'arguments':[read(sp+4+j*4)for j in range(2 if a==0xaf6950 else 1)],'at_call':snap()});return
 if a in[0xaffcb0,0xafebb0,0xaf3420]:calls.append({'kind':{0xaffcb0:'source_virtuald0',0xafebb0:'release_action_owners',0xaf3420:'source_virtualcc'}[a],'receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()});return
 assert any(lo<=a<hi for lo,hi in[(0xb226a0,0xb22708),(0xaf30b0,0xaf30cb),(0xaefc10,0xaefc5a),(0xafdd70,0xafddd8),(0xafd490,0xafd4ac),(0xb01cf0,0xb01d23),(0x75a270,0x75a276),(0xafe420,0xafe47f),(0xaf6430,0xaf6445),(0xafe2e0,0xafe413),(0xaf6950,0xaf69ab),(0xaf6b40,0xaf6b75),(0xaffcb0,0xaffe4c),(0xafebb0,0xafec20),(0xaf3420,0xaf3440)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x12100dc,19);w(0x14a7a08,manager);w(0x14a7a34,registry);rows=[]
for pattern,list_kind,registry_kind,failure,refresh in itertools.product([0,0xa5],['empty','first','middle','missing'],['empty','present','missing'],[False,True],[0,1,0x100]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 key=0x12345678;w(manager+24+(key%193)*4,0);w(manager+796,0);w(stack,end);w(stack+4,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0);u.emu_start(0xb226a0,end,count=2000);assert u.reg_read(UC_X86_REG_EAX)==source
 w(source+16,0 if list_kind=='empty'else existing)
 for i in range(3):
  a=existing+i*44;w(a,0xff10ec);w(a+4,0);w(a+8,a+44 if i<2 else 0);w(a+12,source);w(a+16,0);w(a+20,0);w(a+24,0);w(a+28,0);w(a+32,key if(list_kind=='first'and i==0)or(list_kind=='middle'and i==1)else key+i+1);w(a+36,0x5500+i)
 w(registry,table);w(registry+4,0 if registry_kind=='empty'else 3);w(registry+8,3)
 for i in range(3):w(table+i*8,key if registry_kind=='present'and i==1 else key+i+1);w(table+i*8+4,owners+i*32);w(owners+i*32+4,0x36+i);w(owners+i*32+8,existing+88 if i==1 else 0)
 before=snap();calls.clear();freed.clear();w(stack,end);w(stack+4,key);w(stack+8,refresh);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xafe2e0,end,count=6000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'list_kind':list_kind,'registry_kind':registry_kind,'allocation_failure':failure,'refresh_argument':refresh,'key':key,'before':before,'after':snap(),'calls':list(calls),'freed':sorted(freed),'result':u.reg_read(UC_X86_REG_EAX)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Original120-byte Source factory executes before each case; supplied existing action/registry state is then installed explicitly. Actual AFE2E0 first matching key32 reuse or44-byte FF10EC construction, action12 points to actual Source, original AF6950 registration and AF6B40 type lookup, head insertion, low-byte refresh gate and real AFFCB0/AFEBB0/AF3420 execute. Failed allocation and missing registration/free paths captured.','Allocator/free/lock ABI transports controlled. Registry content and initial intrusive lists supplied; refresh uses owner-null/no-property/no-child graph. External admission caller, registry producers, nonempty property attachment and normal frame activation remain open. Rust replay pending.']}
(r/'data/4.20/audio_path_source_action_factory_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Source action producer44byte constructor/registration/input12/refresh cases')
