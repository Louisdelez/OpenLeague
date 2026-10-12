from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'path registry prerequisites','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
GLOBAL=0x2d8bac0;FLAG=0x2d8bab4;SIZE=0x10a8;BUFFER=0x37000000
u.mem_map(BUFFER,0x80000);registrations=[]
def observe(uc,address,size,user):
 if address==0x8c5a34:registrations.append(read32(u.reg_read(UC_X86_REG_ESP)))
u.hook_add(unicorn.UC_HOOK_CODE,observe)
def state():
 v=snapshot();v['words']=[row for row in v['words'] if not any(p<=row[0]<p+size for p,size in baseline.items())]
 v['global_hex']=bytes(u.mem_read(GLOBAL,SIZE)).hex();v['flag']=read32(FLAG);v['registrations']=list(registrations);registrations.clear();return v
profiles=[]
for poison in [0,165]:
 for flag in [0,2,0xa5a50000]:profiles.append({'kind':'default','fill':poison,'global_fill':poison,'flag':flag,'enabled':0,'mask':0,'used':0,'requests':[{'path_hex':None,'name_hex':None}]})
 for enabled,mask in itertools.product([0,1,165],[0,2,256]):profiles.append({'kind':'gate','fill':poison,'global_fill':0,'flag':0,'enabled':enabled,'mask':mask,'used':0,'requests':[{'path_hex':None,'name_hex':None}]})
 for used in [0x80000-265,0x80000-264,0x80000]:profiles.append({'kind':'capacity','fill':poison,'global_fill':0,'flag':0,'enabled':1,'mask':1,'used':used,'requests':[{'path_hex':b'path'.hex(),'name_hex':None} for _ in range(3)]})
 profiles.append({'kind':'deep','fill':poison,'global_fill':0,'flag':0,'enabled':1,'mask':1,'used':0,'requests':[{'path_hex':('path%03d'%i).encode().hex(),'name_hex':None} for i in range(32)]})
 names=[b'Zulu',b'alpha',b'beta',b'Gamma',b'Delta',bytes([128]),bytes([233]),b'',b'ALPHA',b'gamma',b'BETA',b'zulu',b'omicron',b'lambda',b'iota',b'eta',b'theta',b'epsilon',b'pi',b'phi',b'chi',b'omega',b'kappa',b'nu']
 profiles.append({'kind':'named','fill':poison,'global_fill':0,'flag':0,'enabled':1,'mask':1,'used':0,'requests':[{'path_hex':('named%03d'%i).encode().hex(),'name_hex':name.hex()} for i,name in enumerate(names)]})
cases=[]
try:
 for profile in profiles:
  poison=profile['fill'];u.mem_write(GLOBAL,bytes([profile['global_fill']])*SIZE);write32(FLAG,profile['flag']);snapshot();baseline=dict(live)
  assert call(0x8c59f0,0,[])==GLOBAL;initial=state();assert call(0x8c59f0,0,[])==GLOBAL;cached=state()
  u.mem_write(GLOBAL+0x10a0,bytes([profile['enabled']]));write32(GLOBAL+0x10a4,profile['mask']);write32(GLOBAL+0x68,BUFFER);write32(GLOBAL+0x109c,profile['used']);u.mem_write(BUFFER,bytes([poison])*0x80000)
  path=heap+0xc000;name=heap+0xd000;steps=[]
  for request in profile['requests']:
   path_bytes=None if request['path_hex'] is None else bytes.fromhex(request['path_hex'])
   if path_bytes is not None:u.mem_write(path,path_bytes+b'\0')
   args=[0 if path_bytes is None else path];entry=0x8c5e90
   if request['name_hex'] is not None:u.mem_write(name,bytes.fromhex(request['name_hex'])+b'\0');args.insert(0,name);entry=0x8c5d10
   code=call(entry,GLOBAL,args)&255
   changed_start=min(profile['used'],0x80000);changed_len=min(0x80000-changed_start,max(0,read32(GLOBAL+0x109c)-changed_start))
   steps.append({'request':request,'return_byte':code,'state':state(),'buffer_offset':changed_start,'buffer_hex':bytes(u.mem_read(BUFFER+changed_start,changed_len)).hex()})
  call(0x8c5bb0,0,[]);final=state();assert set(live)==set(baseline)
  cases.append({'profile':profile,'initial':initial,'cached':cached,'path_pointer':path,'steps':steps,'shutdown':final})
 result={'passed':True,'native_sha256':digest,'cases':cases,'limits':['34 original singleton lifetimes: sparse global construction, cached access, default path no-op, disabled bit masks, buffer capacity boundaries,32-node rotations and case-folded/narrow-byte named-key reuse. All path formatting, hashing, trees and shutdown execute in the original PE32.','Allocator storage and initialization of enabled path-register buffer are supplied; operating-system crash-report activation8C80D0 and active teardown8C8C10/8C8D30 are not exercised. No replay frames are serialized.']}
except Exception as e:
 import traceback;traceback.print_exc();result={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'calls':call_trail[-20:],'cases_completed':len(cases)}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in result.items() if k not in ['cases','limits']}))
if not result['passed']:sys.exit(1)

