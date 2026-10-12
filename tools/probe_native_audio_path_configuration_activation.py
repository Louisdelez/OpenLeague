from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
node=vector+0x6000;descriptor=vector+0x7000;points=vector+0x7800;table=vector+0x8000;links=[vector+0x9000+i*64 for i in range(3)];targets=[vector+0xa000+i*64 for i in range(3)];calls=[];visited=set();state=vector+0xb000;mask=vector+0xb100;context=vector+0xc000
def hook(uc,a,size,data):
 global rng
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,n=read(sp+4),read(sp+8);assert pool==17 and n==1;calls.append({'kind':'allocate','pool':pool,'bytes':n,'reference':mask});finish(mask);return
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;v=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':v});finish(v);return
 assert 0xb1ba70<=a<0xb1bc91 or 0xb1b8e0<=a<0xb1b944 or 0xb1bdf0<=a<0xb1be2f or 0xb1b9a0<=a<0xb1ba41 or 0xb1b4e0<=a<0xb1b505 or 0xb1b850<=a<0xb1b8d5 or 0xb14310<=a<0xb14385 or 0xb1b510<=a<0xb1b5c5,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
profiles=list(itertools.product([0,0xa5],[0,1024,0xffffffff],[-1,0,1,2,3],['equal','distinct'],[1,40,0xffffffff],[0,3],[17,0xffffffff]))
profiles=[(*profile,flags)for profile in profiles for flags in [0,1,2,3]]
for pattern,frame,count,layout,duration,binding_count,seed,flags in profiles:
 calls.clear();rng=seed;u.mem_write(node,bytes([pattern])*96);w(node,0);u.mem_write(node+28,b'\0');w(state,0);w(state+4,0);u.mem_write(mask,b'\xa5');w(0x12100dc,17);w(context+0x7c,frame);w(0x14a7a28,context);w(node+12,0 if count is None else descriptor);w(node+32,table);w(node+36,binding_count);u.mem_write(descriptor,struct.pack('<2I2f',points,(count or 0)&0xffffffff,4.,8.));coords=(1.,-2.,3.);nextcoords=coords if layout=='equal'else(9.,4.,-5.);u.mem_write(points,struct.pack('<3fI3fI3fI',*coords,duration,*nextcoords,40,13.,8.,-9.,40));w(0x12100f8,1024);u.mem_write(table,bytes([pattern])*12)
 for i,(link,target)in enumerate(zip(links,targets)):u.mem_write(link,bytes([pattern])*52);w(link+48,target);u.mem_write(target,bytes([pattern])*60);u.mem_write(target+56,bytes([4 if i==0 else 0]));w(table+i*4,link)
 def snap():return {'state':bytes(u.mem_read(state,8)).hex(),'mask':bytes(u.mem_read(mask,1)).hex(),'node':bytes(u.mem_read(node,96)).hex(),'descriptor':bytes(u.mem_read(descriptor,16)).hex(),'points':bytes(u.mem_read(points,48)).hex(),'table':bytes(u.mem_read(table,12)).hex(),'links':[{'reference':v,'raw':bytes(u.mem_read(v,52)).hex()}for v in links],'targets':[{'reference':v,'raw':bytes(u.mem_read(v,60)).hex()}for v in targets],'rng_state':rng}
 def invoke(entry,args):
  w(stack,end)
  for i,v in enumerate(args):w(stack+4+i*4,v)
  u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(entry,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end;return u.reg_read(UC_X86_REG_EAX)
 before=snap();configured=invoke(0xb1b9a0,[descriptor,1,flags,1,state]);after_configuration=snap();configuration_calls=list(calls);calls.clear();activated=invoke(0xb14310,[node,state]);rows.append({'frame':frame,'flags':flags,'interval':1024,'before':before,'configured':after_configuration,'configured_result':configured,'configuration_calls':configuration_calls,'after':snap(),'activated_result':activated,'activation_calls':list(calls)})

proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entries':['0xb1b9a0','0xb14310'],'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual configuration and outer activation execute together, with owned history initialization, real selection and shared RNG, flag4-gated owner pose and caller restart. Allocation is a controlled mandatory transport. Rust replay, normal binding/path producers, ownership lifetime and broad arithmetic qualification remain required.']}
(r/'data/4.20/audio_path_configuration_activation_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native initial activation cases')
