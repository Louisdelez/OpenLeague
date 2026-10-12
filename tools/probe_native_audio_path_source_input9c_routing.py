from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;owner=vector+0x2000;parents=vector+0x3000;wrapper=vector+0x4000;vt=vector+0x5000;stub=vector+0x1f000
regions=[('source',source,160),('owner',owner,64),('parents',parents,96),('wrapper',wrapper,8)];calls=[];visited=set();mutate=False
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 if a==stub:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'parent_virtual9c','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()})
  if mutate:w(source+32,0)
  finish(0,4);return
 if a==0xafe9c0:
  calls.append({'kind':'empty_release_boundary','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()});w(source+28,0);finish(0);return
 assert 0xafe5b0<=a<0xafe64e,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(vt+0x9c,stub);rows=[]
gates=['absent','zero_wrap','one_empty','two','ffff','counter48','counter52','counter54','head','count']
for pattern,gate,secondary,wrapper_kind,primary,selector,mutate in itertools.product([0,0xa5],gates,[False,True],['absent','null','present'],[False,True],[0,1,2,3,0x10000,0x10001,0x10002,0xffffffff],[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 w(source,0xff1cd8);w(source+28,0 if gate=='absent'else owner);w(source+32,parents if primary else 0);w(source+36,parents+32 if secondary else 0);w(source+56,0 if wrapper_kind=='absent'else wrapper);w(wrapper,parents+64 if wrapper_kind=='present'else 0)
 for i in range(3):w(parents+i*32,vt)
 u.mem_write(owner+48,bytes(8));u.mem_write(owner+50,({'zero_wrap':0,'two':2,'ffff':65535}.get(gate,1)).to_bytes(2,'little'));w(owner+12,0);w(owner+4,0)
 if gate.startswith('counter'):u.mem_write(owner+int(gate[7:]),(1).to_bytes(2,'little'))
 if gate=='head':w(owner+12,parents)
 if gate=='count':w(owner+4,1)
 before=snap();calls.clear();w(stack,end);w(stack+4,selector);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xafe5b0,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'gate':gate,'secondary':secondary,'wrapper_kind':wrapper_kind,'primary':primary,'selector':selector,'mutate_primary':mutate,'before':before,'after':snap(),'calls':list(calls)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual SourceFF1CD8 AFE5B0 counter50 wrapping decrement and all four counter/head/count gates; optional parent36 then wrapper56 parent then parent32 calls; high selector bits truncate only on matched secondary routing; parent32 reread after caller supplied mutation.','Parent virtual9C is a controlled mutable ABI service. Empty AFE9C0 boundary controlled here to isolate gate; actual physical owner destruction is separately prepared in648 full property cases. Class constructors, recursive parent bodies, aliases, Rust replay, full normal frame and physical audio remain open.']}
(r/'data/4.20/audio_path_source_input9c_routing_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual input9C counter/gate/selector/parent routing cases')
