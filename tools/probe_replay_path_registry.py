from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'path registry prerequisites','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
GLOBAL=0x2d8bac0;FLAG=0x2d8bab4;SIZE=0x10a8;BUFFER=0x37000000
u.mem_map(BUFFER,0x80000)
original_global=bytes(u.mem_read(GLOBAL,SIZE));original_flag=bytes(u.mem_read(FLAG,4))
registrations=[]
def observe(uc,address,size,user):
 if address==0x8c5a34:registrations.append(read32(u.reg_read(UC_X86_REG_ESP)))
u.hook_add(unicorn.UC_HOOK_CODE,observe)
def state():
 v=snapshot();v['global_hex']=bytes(u.mem_read(GLOBAL,SIZE)).hex();v['flag']=read32(FLAG);v['registrations']=list(registrations);registrations.clear();return v
cases=[]
try:
 for poison,counter,path_bytes in itertools.product([0,165],[0,0xfffffffe],[b'',b'E:/OpenLeague/logs/native.txt',b'x'*255,b'x'*256,b'x'*512]):
  u.mem_write(GLOBAL,original_global);u.mem_write(FLAG,original_flag);snapshot();baseline=set(live)
  result=call(0x8c59f0,0,[]);assert result==GLOBAL;initial=state()
  u.mem_write(GLOBAL+0x10a0,b'\1');write32(GLOBAL+0x10a4,1);write32(GLOBAL+0x68,BUFFER);write32(GLOBAL+0x1098,counter);u.mem_write(BUFFER,bytes([poison])*0x80000)
  path=heap+0xc000;u.mem_write(path,path_bytes+b'\0');steps=[]
  for i in range(4):
   code=call(0x8c5e90,GLOBAL,[path])&255
   steps.append({'return_byte':code,'state':state(),'buffer_hex':bytes(u.mem_read(BUFFER,read32(GLOBAL+0x109c))).hex()})
  call(0x8c5bb0,0,[]);final=state();assert set(live)==baseline
  cases.append({'fill':poison,'counter':counter,'path_hex':path_bytes.hex(),'initial':initial,'path_pointer':path,'steps':steps,'shutdown':final})
 result={'passed':True,'native_sha256':digest,'initial_global_hex':original_global.hex(),'initial_flag_hex':original_flag.hex(),'cases':cases,'limits':['20 original singleton lifetimes with explicitly supplied enabled path-register buffer, file strings of0/29/255/256/512 bytes and wrapping signed counter. Hashing, tree insertion/rebalancing, formatting, padding and shutdown execute inside the original PE32.','Operating-system crash-report activation8C80D0 and active teardown8C8C10/8C8D30 are outside this fixture. The buffer supplied by the harness is not an opened output file. No replay frames are serialized.']}
except Exception as e:
 import traceback;traceback.print_exc();result={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'calls':call_trail[-20:],'cases_completed':len(cases)}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in result.items() if k not in ['cases','initial_global_hex','initial_flag_hex','limits']}))
if not result['passed']:sys.exit(1)
