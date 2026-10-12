from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'derived stream lifetime prerequisites','exec'))
cases=[]
try:
 for poison,mode in itertools.product([0,165],['scalar0','scalar1','shared']):
  snapshot();baseline=set(live);obj=call(0x9933e0,0,[0x918]);returned=call(0x8f6d00,obj,[]);assert returned==obj
  constructed=snapshot();steps=[]
  if mode=='shared':
   first,second=heap+0xf800,heap+0xf810
   for p in [first,second]:u.mem_write(p,bytes(8))
   call(0x9018c0,first,[obj]);control=read32(first+4);assert read32(first)==obj+0xe0 and read32(control+12)==obj
   steps.append({'action':'wrap','pair':[read32(first),read32(first+4)],'control':control,'snapshot':snapshot()})
   call(0x5cc070,second,[first]);steps.append({'action':'copy','pair':[read32(second),read32(second+4)],'snapshot':snapshot()})
   call(0x5bd3c0,first,[]);steps.append({'action':'release_first','snapshot':snapshot()})
   call(0x5bd3c0,second,[]);steps.append({'action':'release_second','snapshot':snapshot()})
  else:
   flags=0 if mode=='scalar0' else 1;assert call(0x8f6d90,obj,[flags])==obj
   steps.append({'action':mode,'snapshot':snapshot()})
   if flags==0:call(0xc98528,0,[obj]);snapshot()
  assert set(live)==baseline,{'remaining':sorted(set(live)-baseline)}
  cases.append({'fill':poison,'mode':mode,'object':obj,'constructed':constructed,'steps':steps})
 tables={hex(p):[read32(p+i*4) for i in range(n)] for p,n in [(0x10d6040,2),(0x10d6254,12),(0x10d5fdc,3),(0x10d5fec,12)]}
 result={'passed':True,'native_sha256':digest,'cases':cases,'tables':tables,'limits':['Actual8F6D00 constructs2328 bytes with224-byte8FC230 prefix and a second interface at+E0. Actual8F6D90/8F6DD0 destruction,9018C0 aliasing control creation,5CC070 copy and5BD3C0 reference release execute in6 supplied-memory profiles.','Observed primitive allocators/locks use the established native probe boundaries. No stream opening8F68D0, key construction98F710, network I/O or Rust derived-object parity is claimed.']}
except Exception as e:
 import traceback
 traceback.print_exc();result={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in result.items() if k not in ['cases','tables','limits']}))
if not result['passed']:sys.exit(1)
