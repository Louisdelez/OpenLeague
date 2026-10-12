from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
observed=[]
def dispatch_hook(uc,a,size,user):
 if a in [0x6c9210,0x6153d0,0x5eb4b0]:observed.append([u.reg_read(UC_X86_REG_ECX),hex(a)])
 if a==0x717f15:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,dispatch_hook)
objects=[vector+0x1b000+i*0x300 for i in range(3)];items=vector+0x1a000;rows=[]
for order in [[],[0],[0,1,2],[2,1,0]]:
 for bits in range(8):
  for i,obj in enumerate(objects):u.mem_write(obj,b'\0'*0x200);w(obj,0x10a4960);w(obj+0x15c,i);w(obj+0xb0,0x212|(0x100000 if bits&(1<<i) else 0))
  for i,index in enumerate(order):w(items+i*4,objects[index])
  w(0x2d7c3c4,items+len(order)*4)
  histories=[]
  for repeat in range(2):
   observed=[];u.reg_write(UC_X86_REG_ESI,items);u.reg_write(UC_X86_REG_EBP,stack+0x100);run(0x717e90,0,[])
   expected=[] if repeat else [[objects[i],cb] for i in order if bits&(1<<i) for cb in ['0x6c9210','0x6153d0','0x5eb4b0']]
   assert observed==expected,(order,bits,repeat,observed,expected);histories.append([[objects.index(obj),cb] for obj,cb in observed])
  masks=[read(obj+0x15c) for obj in objects]
  assert masks==[0xffffffff if i in order and bits&(1<<i) else i for i in range(3)]
  rows.append(dict(order=order,pending_bits=bits,passes=histories,masks=masks))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Native list iteration preserves supplied order and skips objects without100000.','Each pending object receives44,50,54 once; flag cleared before callbacks.','A second unchanged pass invokes no callbacks. Empty lists invoke none.'],adapters=['List contents and end pointer supplied; original iteration717E90..717F15 executed.','Absent Troy resources and registry membership metadata; inherited bounds callback adapted.'],limits=['No insertion/removal during iteration, registry queue construction or full frame scheduling qualification.'])
(r/'data/4.20/projectile_deferred_list_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS32 list scenarios with two passes each')
