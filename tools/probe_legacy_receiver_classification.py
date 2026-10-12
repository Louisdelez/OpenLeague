from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
node=heap+0x1e000;rect=heap+0x1e100;u.mem_write(rect,struct.pack('<4f',0,0,10,10));cases=[]
intervals=[[-20,-10],[-1,0],[0,10],[2,8],[10,11],[11,20],[-1,11]]
for x,z in itertools.product(intervals,repeat=2):
 bounds=[x[0],-200000,z[0],x[1],200000,z[1]];u.mem_write(node,struct.pack('<6f',*bounds));write32(sp,end)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.reg_write(UC_X86_REG_EDX,rect);u.emu_start(0x95b5a0,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end
 codes=[(1 if px<0 else 2 if px>10 else 0)|(8 if pz<0 else 4 if pz>10 else 0) for px,pz in itertools.product(x,z)]
 union=codes[0]|codes[1]|codes[2]|codes[3];intersection=codes[0]&codes[1]&codes[2]&codes[3]
 assert u.reg_read(UC_X86_REG_EAX)==union and u.reg_read(UC_X86_REG_EDX)==intersection
 cases.append({'bounds':bounds,'union':union,'intersection':intersection,'classification':1 if union==0 else -1 if intersection else 0})
p={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x95b5a0','rectangle':[0,0,10,10],'cases':cases,'limits':['Actual leaf instructions execute; node and rectangle are supplied.','Tree traversal and draw eligibility downstream remain unqualified; finite ordered bounds only.']}
(r/'data/4.20/legacy_receiver_classification_contract.json').write_text(json.dumps(p,indent=2)+'\n');print('49 native receiver classifications passed')
