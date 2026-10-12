from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;table=vector+0x2000;owners=vector+0x3000;transitions=vector+0x4000
regions=[('registry',registry,108),('key_table',table,32),('owners',owners,72),('transitions',transitions,72)]
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
visited=set()
def hook(uc,a,z,data):
 assert 0xaf7280<=a<0xaf72c1 or 0xaf6a30<=a<0xaf6a72,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
layouts=[[],[(7,owners)],[(7,owners),(7,owners+24),(200,owners+48)],[(200,owners),(7,owners+24),(0xffffffff,owners+48)],[(7,0)]]
for pattern,layout_index,key,duration in itertools.product([0,0xa5],range(5),[7,200,0xffffffff],[0,1,97,0xffffffff]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 layout=layouts[layout_index];w(registry,table);w(registry+4,len(layout))
 for j,(k,ref)in enumerate(layout):w(table+j*8,k);w(table+j*8+4,ref)
 for j in range(3):
  ref=owners+j*24;old=0x11223344+j;w(ref,99+j);w(ref+4,old);w(ref+8,0);w(ref+12,transitions+j*24);w(ref+16,2)
  for k,value in enumerate([37,91]):w(transitions+j*24+k*12,old);w(transitions+j*24+k*12+4,0xaabbccdd);w(transitions+j*24+k*12+8,value)
 before=snapshot();w(stack,end);w(stack+4,key);w(stack+8,duration);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);fault=None
 try:u.emu_start(0xaf7280,end,count=1000)
 except unicorn.UcError:
  assert u.reg_read(UC_X86_REG_EIP)==0xaf72ad;fault='native_null_owner_default_write'
 result=None if fault else u.reg_read(UC_X86_REG_EAX);after=snapshot();lookups=[]
 if not fault:
  assert u.reg_read(UC_X86_REG_EIP)==end
  for j in range(3):
   ref=owners+j*24;old=read(ref+4)
   for target in [0xaabbccdd,0x55667788]:
    w(stack,end);w(stack+4,old);w(stack+8,target);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,ref+12);u.emu_start(0xaf6a30,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end;at=u.reg_read(UC_X86_REG_EAX);lookups.append({'owner':ref,'old_value':old,'new_value':target,'matched_reference':at,'effective_duration':read(at)if at else read(ref)})
 rows.append({'pattern':pattern,'layout':layout_index,'key':key,'duration':duration,'before':before,'after':after,'result':result,'fault':fault,'duration_lookups':lookups})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual AF7280 first-key default duration owner.word0 publication and AF6A30 first matching explicit transition/fallback duration lookup execute original routines without services. Missing key returns20, first duplicate retained; current state owner.word4 and explicit transition arrays stay untouched. NULL owner maps to actual write fault AF72AD with partial bank captured.','Default-duration setting is a different operation from AF6FF0 current state value publication. Full AFB320 resource reader, growth/transition creation, startup publishing and normal-frame producer are still open. Rust replay pending.']}
(r/'data/4.20/audio_action_registry_default_duration_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual default-duration setter and transition/fallback lookup cases')
