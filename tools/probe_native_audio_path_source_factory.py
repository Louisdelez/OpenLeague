from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;manager=vector+0x5000;previous=vector+0x6000;calls=[];visited=set();failure=False
regions=[('source',source,120),('manager',manager,800),('previous',previous,16)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+8)==120;result=0 if failure else source;calls.append({'kind':'allocate','pool':read(sp+4),'size':120,'result':result,'at_call':snap()});finish(result);return
 if a in [read(0xfa4424),read(0xfa4428)]:
  sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+4)==manager;calls.append({'kind':'lock'if a==read(0xfa4424)else'unlock','receiver':read(sp+4),'at_call':snap()});finish(0,4);return
 assert any(lo<=a<hi for lo,hi in [(0xb226a0,0xb22708),(0xaf30b0,0xaf30cb),(0xaefc10,0xaefc5a),(0xafdd70,0xafddd8),(0xafd490,0xafd4ac),(0xb01cf0,0xb01d23),(0x75a270,0x75a276),(0xafe420,0xafe47f),(0xaf6430,0xaf6445)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x12100dc,19);w(0x14a7a08,manager);rows=[]
for pattern,key,count,present,failure in itertools.product([0,0xa5,0xff],[0,1,193,0xffffffff],[0,5,0xffffffff],[False,True],[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 w(manager+24+(key%193)*4,previous if present else 0);w(manager+796,count);before=snap();calls.clear();w(stack,end);w(stack+4,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0);u.emu_start(0xb226a0,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);assert result==(0 if failure else source);rows.append({'pattern':pattern,'key':key,'manager_count':count,'previous_present':present,'allocation_failure':failure,'before':before,'after':snap(),'calls':list(calls),'result':result})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual B226A0 Source factory allocates120bytes, executes complete AF30B0/AEFC10/AFDD70/AFD490 and embedded B01CF0 constructors, original virtual38 returns3, actual AF6430 manager selection and AFE420 unsigned193-bucket insertion, preserved previous link and wrapping manager count.','Allocation and Windows lock transports are controlled ABI boundaries with full memory snapshots; existing manager/source allocation supplied. Action input12 producer, external admission caller, parent links/owner counter population and normal frame provenance remain unqualified. Rust factory replay remains pending; full game not complete.']}
(r/'data/4.20/audio_path_source_factory_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual120byte Source factory/constructor/manager insertion cases')
