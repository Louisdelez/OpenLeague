from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
node=vector+0x6000;mask=vector+0x8000;desc=vector+0x7000;state=vector+0x5000;resource=vector+0x4000;calls=[];visited=set()
def hook(uc,a,size,data):
 global rng
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,n=read(sp+4),read(sp+8);assert pool==17 and n==count;calls.append({'kind':'allocate','pool':pool,'bytes':n,'reference':0 if mode=='failure'else mask});finish(0 if mode=='failure'else mask);return
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;v=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':v});finish(v);return
 assert 0xb1b3c0<=a<0xb1b3ed or 0xb142d0<=a<0xb14301 or 0xb1b9a0<=a<0xb1ba41 or 0xb1b4e0<=a<0xb1b505 or 0xb1b850<=a<0xb1b8d5,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,node_ref,guard,loop in itertools.product([0,0xa5],[0,0xf0000000],['count','descriptor','both'],[0,31,32,255]):
 calls.clear();rng=17;count=0 if guard in ['count','both'] else 2;mode='new'
 u.mem_write(node,bytes([pattern])*96);u.mem_write(state,bytes([pattern])*8);u.mem_write(resource,bytes([pattern])*64)
 w(resource+32,3);w(resource+48,0 if guard in ['descriptor','both'] else desc);w(resource+52,count);u.mem_write(resource+56,bytes([loop]))
 def snap():return {'node':bytes(u.mem_read(node,96)).hex(),'state':bytes(u.mem_read(state,8)).hex(),'resource':bytes(u.mem_read(resource,64)).hex(),'rng_state':rng}
 before=snap();w(stack,end);w(stack+4,node_ref);w(stack+8,state);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,resource);u.emu_start(0xb1b3c0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);assert result==31 and not calls and snap()==before
 rows.append({'node_reference':node_ref,'guard':guard,'before':before,'after':snap(),'result':result,'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1b3c0','case_count':len(rows),'cases':rows,'limits':['Null and deliberately unmapped node reference guarded by zero descriptor pointer/count. Actual B1B3C0 and B142D0 execute; no node dereference or callback occurs. Invalid nonempty node and end-to-end frame remain unqualified.']}
(r/'data/4.20/audio_path_resource_configuration_guard_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native resource guard-before-node-dereference cases')
