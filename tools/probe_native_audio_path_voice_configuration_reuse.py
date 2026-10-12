from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x4000;query=vector+0x5000;resource=vector+0x6000;voice=vector+0x7000;manager=vector+0x8000;table=vector+0x9000;node=vector+0xa000;history=vector+0xb000;orientation=vector+0xc000;borrowed=vector+0xd000;descriptors=vector+0xe000;calls=[];freed=[];allocated=[];nth=0;visited=set();rng=17
matrices=[]
for i in range(8):
 values=[(-1. if j%2 else 1.)*(1.+i*9+j)for j in range(9)];matrices.append(struct.pack('<9f',*values));u.mem_write(0x14a7eb0+i*0x90,matrices[-1])
def hook(uc,a,size,data):
 global nth,rng
 if a==0xada670:
  nth+=1;sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);assert pool==17
  target=node if size==108 else history if size==2 else orientation;assert size in [108,2,108 if listener_mask==7 else listener_mask.bit_count()*36]
  # Node and listener allocations can both be108; current fixture uses byte mask3 only.
  reference=0 if nth==failure else target;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':reference})
  if reference:u.mem_write(reference,bytes([pattern])*size);allocated.append({'reference':reference,'size':size})
  finish(reference);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,reference=read(sp+4),read(sp+8);assert pool==17 and reference not in freed;freed.append(reference);calls.append({'kind':'free','pool':pool,'reference':reference});finish(1);return
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;value=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':value});finish(value);return
 assert 0xaed8d0<=a<0xaeda05 or 0xaf1a70<=a<0xaf1a8d or 0xb13fa0<=a<0xb1400d or 0xb1b480<=a<0xb1b4dd or 0xb1b3c0<=a<0xb1b3ed or 0xb142d0<=a<0xb14301 or 0xb1b9a0<=a<0xb1ba41 or 0xb1b4e0<=a<0xb1b505 or 0xb1b850<=a<0xb1b8d5 or 0xb14180<=a<0xb141ed or 0xb1bca0<=a<0xb1bd0f or 0x5642d0<=a<0x5642d3 or 0xb1b590<=a<0xb1b670,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
profiles=list(itertools.product([0,0xa5],[0,1,2,3],['current','query','mismatch'],[0,1,4],[False,True],[False,True]))
for pattern,flags,cache_mode,voice_flags,source_gate,orient in profiles:
 reused=False;empty=False;failure=0
 calls.clear();freed.clear();allocated.clear();nth=0;rng=17;listener_mask=3
 u.mem_write(voice,bytes([pattern])*408);w(voice+48,resource);w(voice+96,source);w(voice+104,query);u.mem_write(voice+299,bytes([voice_flags]));w(voice+400,node if cache_mode=='current'else 0);w(voice+404,0x11223344)
 u.mem_write(source,bytes([pattern])*96);w(source+32,0);w(source+68,resource);w(source+48,0x400 if source_gate else 0);u.mem_write(source+47,bytes([0x10]));u.mem_write(query,bytes([pattern])*12);w(query,node if cache_mode!='current'else 0);w(query+4,0x12345678 if cache_mode=='query'else 0x87654321);u.mem_write(query+10,bytes([listener_mask]))
 u.mem_write(resource,bytes([pattern])*72);w(resource+4,0x12345678);w(resource+32,flags);w(resource+48,0 if empty else descriptors);w(resource+52,0 if empty else 2);u.mem_write(resource+56,bytes([0 if orient else 0x10]));w(resource+64,0);w(resource+68,borrowed if reused else 0)
 u.mem_write(borrowed,bytes([0x33])*4);u.mem_write(history,bytes([0x33])*4);u.mem_write(node,bytes([0x33])*108);u.mem_write(orientation,bytes([0x33])*72);u.mem_write(table,bytes([pattern])*16);w(manager,table);w(manager+4,1 if cache_mode in ['current','query']else 0);w(manager+8,4);w(manager+12,4);w(0x14a7a40,manager);w(0x12100dc,17)
 if cache_mode in ['current','query']:
  w(table,node);w(node,1);w(node+32,0);w(node+8,0);w(node+24,0);w(node+104,0)
 def snap():return {'voice':bytes(u.mem_read(voice,408)).hex(),'source':bytes(u.mem_read(source,96)).hex(),'query':bytes(u.mem_read(query,12)).hex(),'resource':bytes(u.mem_read(resource,72)).hex(),'manager':bytes(u.mem_read(manager,16)).hex(),'table':bytes(u.mem_read(table,16)).hex(),'node':bytes(u.mem_read(node,108)).hex(),'borrowed':bytes(u.mem_read(borrowed,4)).hex(),'history':bytes(u.mem_read(history,4)).hex(),'orientation':bytes(u.mem_read(orientation,72)).hex(),'rng_state':rng,'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex(),'freed':v['reference']in freed}for v in allocated]}
 before=snap();w(stack,end);w(stack+4,query);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0xaed8d0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'cache_mode':cache_mode,'voice_flags':voice_flags,'source_gate':source_gate,'pattern':pattern,'flags':flags,'reused':reused,'empty':empty,'failure':failure,'orient':orient,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'freed':list(freed)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaed8d0','case_count':len(rows),'listener_matrices':[m.hex()for m in matrices],'cases':rows,'native_addresses':len(visited),'limits':['Actual original caller, manager allocation/publication/removal, constructor, source-state lookup, resource guards/configuration, selection and orientation execute. Physical allocator/free and CRT random are controlled transports. Voice gate0/1/4 and source activation-bit guard execute, with current-node reuse, matching external identity reuse and mismatching external identity causing fresh configuration. Existing node layout is supplied. Source parent-chain longer than1, force-reconfiguration flag4, orientation/allocation size collision, actual full normal activation/cleanup and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_configuration_reuse_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original voice configuration/manager/state/selection/orientation cases')
