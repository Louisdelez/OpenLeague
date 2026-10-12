from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'manager singleton prerequisites','exec'))
registrations=[]
def registration(uc,address,size,user):
 if address==0x5cf24e:registrations.append(read32(u.reg_read(UC_X86_REG_ESP)))
u.hook_add(unicorn.UC_HOOK_CODE,registration)
tables={str(p):[read32(p+i*4) for i in range(n)]for p,n in [(0x10b012c,3),(0x10b0128,1),(0x10b00c4,16),(0x10b0138,16),(0x108606c,3),(0x1086078,3),(0x10afd14,3),(0x10afd20,3),(0x10afd34,3),(0x1085f4c,3),(0x10d5f34,8),(0x1085f2c,3)]}
cases=[]
for poison,reinit,registered in itertools.product([0,165],[0,1],[0,1]):
 write32(0x2d78520,0);u.mem_write(0x2d784e6,bytes([reinit]));u.mem_write(0x2d78288,bytes([registered]));u.mem_write(0x2d78240,bytes([poison])*68)
 snapshot();baseline=set(live);registrations.clear();steps=[]
 for action in ['get','get_again','shutdown','get_after_shutdown','shutdown_again']:
  call(0x5d81b0 if action.startswith('shutdown') else 0x5cf1e0,0,[])
  steps.append({'action':action,'snapshot':snapshot(),'words':[read32(0x2d78240+i*4) for i in range(17)],'pointer':read32(0x2d78520),'flags':[int(u.mem_read(p,1)[0])for p in [0x2d784e6,0x2d78288]],'registrations':list(registrations)})
 assert set(live)==baseline
 cases.append({'fill':poison,'initial_flags':[reinit,registered],'steps':steps})
proof={'passed':True,'native_sha256':digest,'current_id':read32(0x123df84),'tables':tables,'cases':cases,'limits':['Eight native5CF1E0/5D81B0 singleton get/repeated-get/shutdown/reinitialize lifetimes with both flags and two memory fills. Parent stream/metadata initialization is deliberately not invoked; that has separate full initialization and opening fixtures.','The registration callback is observed at its original call site. Primitive allocator/CRT dependencies use existing supplied boundaries.']}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'cases':len(cases),'tables':len(tables)}))
