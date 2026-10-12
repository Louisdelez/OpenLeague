from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
slots=vector+0x19000;pending=vector+0x1a000;active=vector+0x1a100;node=vector+0x1b000
spatial=[]
def registration_hook(uc,a,size,user):
 if a==0x9933e0:
  assert read(uc.reg_read(UC_X86_REG_ESP)+4)==12
  finish(node)
 if a==0x95ee90:
  sptr=uc.reg_read(UC_X86_REG_ESP)
  for offset in [4,8,12]:
   assert bytes(uc.mem_read(read(sptr+offset),12))==bytes(12),'native initial spatial bounds must be zero'
  spatial.append(dict(node=uc.reg_read(UC_X86_REG_ECX),manager=read(node),owner=read(node+4)))
  finish(0,12)
u.hook_add(unicorn.UC_HOOK_CODE,registration_hook)
rows=[]
for occupied,slot,generation,excluded in itertools.product([[0,0,0,0],[1,0,1,1],[0,0,1,1],[1,0,1,0]],[1],[0,0xffff,0x10000],[False,True]):
 u.mem_write(wrapper,b'\0'*0x200);w(wrapper,0x10a4960);w(wrapper+0xb0,0x212|(0x100 if excluded else 0));w(wrapper+0xfc,0)
 for i,value in enumerate(occupied):w(slots+i*4,0x77770000+i*4 if value else 0)
 for a,v in [(0x2d62878,0),(0x2d628c0,slots),(0x2d628c4,4),(0x2d628c8,sum(occupied)),(0x2d628cc,slot),(0x2d628d0,generation),(0x2d6290c,pending),(0x2d62910,pending),(0x2d62914,pending+64),(0x2d62918,active),(0x2d6291c,active),(0x2d62920,active+64)]:w(a,v)
 spatial=[];result=run(0x717970,0,[wrapper])
 remaining=[i for i in list(range(slot+1,4))+list(range(slot)) if not occupied[i]]
 expected_next=remaining[0] if remaining else 0xffffffff
 assert result==1 and read(slots+4*slot)==wrapper
 assert read(wrapper+8)==((generation<<16)|slot)&0xffffffff
 assert read(0x2d628d0)==generation+1 and read(0x2d628c8)==sum(occupied)+1
 assert read(0x2d628cc)==expected_next
 assert read(0x2d62910)==pending+4 and read(pending)==wrapper
 assert read(0x2d6291c)==active+(0 if excluded else 4)
 assert read(wrapper+0xe4)==0x2d628b8 and read(wrapper+0xcc)==node
 assert spatial==[dict(node=node,manager=0x2d628e4,owner=wrapper)]
 rows.append(dict(occupied=occupied,generation=generation,excluded_bit100=excluded,identity=read(wrapper+8),next_slot=expected_next,spatial=spatial.copy()))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Native717970 assigns generation<<16|slot, updates count and scans forward then wraps for a free slot; full table marksFFFFFFFF.','Every registration enters initialization vector; bit100 excludes only active vector.','Original71A470 creates12byte spatial node pointing at manager+2C and wrapper, stores node in wrapperCC.'],adapters=['Heap allocation returns supplied node.95EE90 spatial tree insertion recorded but not executed.','Name index bypassed with native sentinel; registry and vector capacity preallocated.'],limits=['Spatial insertion geometry, names, allocation failure, unregister and stale identity behavior remain unqualified.','No full runtime fidelity claim.'])
(r/'data/4.20/projectile_registration_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS24 native registration cases')
