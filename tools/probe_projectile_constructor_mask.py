from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
allocation=vector+0x19000
calls=[]
def constructor_hook(uc,a,size,user):
 if a in [0x9933e0,0x5c7470,0x5c7740]:calls.append(hex(a));finish(allocation);return
 if a==0x5d22f0:calls.append(hex(a));finish(u.reg_read(UC_X86_REG_ECX),4);return
 if a==0x6ea710:calls.append(hex(a));finish(u.reg_read(UC_X86_REG_ECX),8);return
u.hook_add(unicorn.UC_HOOK_CODE,constructor_hook)
rows=[]
for initial in [0,1,3,0x55555555,0xffffffff]:
 u.mem_write(wrapper,b'\0'*0x300);w(wrapper+0x15c,initial);calls=[]
 result=run(0x6c8be0,wrapper,[]);mask=read(wrapper+0x15c);assert result==wrapper and read(wrapper)==0x10a4960 and mask==initial
 rows.append(dict(initial_mask=initial,after_constructor_mask=mask,type_flags=read(wrapper+0xb0),adapters=calls))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Original derived6C8BE0 and base716890 execute and preserve mask15C across supplied initial values.','Constructor itself does not establishFFFFFFFF in this qualified path; virtual44 reset remains separate.'],adapters=['Heap allocation9933E0 supplies scratch memory. Container constructors5C7470/5C7740 return scratch handles; shared-pointer helper5D22F0 and tail container6EA710 adapted.','Adapted subobjects are before11C or at18C, away from mask15C. No claim of complete container or allocator semantics.'],limits=['Object memory supplied, not actual registry allocator.','Must trace allocation/zeroing/reset lifecycle before assigning initial default.'])
(r/'data/4.20/projectile_constructor_mask_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS5 constructor mask preservation cases')
