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
profiles=list(itertools.product([0,0xa5],[0,1],[1,2,3,8],[0,1,2,3],[0,255],['new','failure','borrowed'],[0,0xffffffff]))
profiles += [(pattern,0,65537,flags,255,'new',17)for pattern,flags in itertools.product([0,0xa5],[0,1,2,3])]
profiles += [(p,k,0,f,l,'new',17) for p,k,f,l in itertools.product([0,0xa5],[0,1],[0,3],[0,255])]
for case_index,(pattern,kind,count,flags,loop,mode,seed) in enumerate(profiles):
 calls.clear();rng=seed;u.mem_write(resource,bytes([pattern])*64);w(resource+32,flags);w(resource+48,desc);w(resource+52,count);u.mem_write(resource+56,bytes([loop]));u.mem_write(node,bytes([pattern])*96);w(node,kind);w(state,0xcafe);w(state+4,mask if mode=='borrowed'else 0);u.mem_write(mask,bytes([0xa5])*count);w(0x12100dc,17)
 def snap():return {'node':bytes(u.mem_read(node,96)).hex(),'mask':bytes(u.mem_read(mask,count)).hex(),'state':bytes(u.mem_read(state,8)).hex(),'rng_state':rng,'resource':bytes(u.mem_read(resource,64)).hex()}
 before=snap();w(stack,end)
 for i,v in enumerate([node,state]):w(stack+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,resource);u.emu_start(0xb1b3c0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'count':count,'flags':flags,'loop':loop,'mode':mode,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1b3c0','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Allocation is a mandatory controlled transport, not a qualified allocator. Borrowed state masks are not cleared or read. Actual B1B4E0 history clear and B1B850 selection execute. Normal activation, lifetime and caller integration remain required. Zero-count random selection is separately qualified as an explicit fault by the existing selection contract.']}
(r/'data/4.20/audio_path_resource_configuration_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native resource caller configuration cases')
