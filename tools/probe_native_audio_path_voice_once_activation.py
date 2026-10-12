from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
voice=vector+0x4000;resource=vector+0x5000;source=vector+0xd000;node=vector+0x6000;descriptor=vector+0x7000;points=vector+0x7800;table=vector+0x8000;links=[vector+0x9000+i*64 for i in range(3)];targets=[vector+0xa000+i*64 for i in range(3)];calls=[];visited=set();state=vector+0xb000;mask=vector+0xb100;context=vector+0xc000
def hook(uc,a,size,data):
 global rng
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,n=read(sp+4),read(sp+8);assert pool==17 and n==1;calls.append({'kind':'allocate','pool':pool,'bytes':n,'reference':mask});finish(mask);return
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;v=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':v});finish(v);return
 assert 0xb1ba70<=a<0xb1bc91 or 0xb1b8e0<=a<0xb1b944 or 0xb1bdf0<=a<0xb1be2f or 0xb1b9a0<=a<0xb1ba41 or 0xb1b4e0<=a<0xb1b505 or 0xb1b850<=a<0xb1b8d5 or 0xb14310<=a<0xb14385 or 0xb1b510<=a<0xb1b5c5 or 0xaef540<=a<0xaef589 or 0xaf3150<=a<0xaf31a9 or 0xb1b990<=a<0xb1b99d or 0xb1b670<=a<0xb1b680 or 0xaf1a70<=a<0xaf1a8d,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
profiles=list(itertools.product([0,0xa5],[0,7,127,128,255],[False,True],[0,1,2],[2,3],[1,3],[0,1024,0xffffffff]))
for pattern,voice_flags,present,node_class,flags,depth,frame in profiles:
 calls.clear();rng=17
 u.mem_write(voice,bytes([pattern])*408);w(voice+48,resource);w(voice+96,source);w(voice+400,node if present else 0);u.mem_write(voice+301,bytes([voice_flags]))
 u.mem_write(resource,bytes([pattern])*72);u.mem_write(resource+56,bytes([0]));w(resource+64,0);w(resource+68,0)
 chain=[source+i*128 for i in range(depth)]
 for i,ref in enumerate(chain):
  u.mem_write(ref,bytes([pattern])*96);w(ref+40,0);w(ref+72,0);w(ref+32,chain[i+1]if i+1<depth else 0);w(ref+68,resource if i==depth-1 else 0)
 u.mem_write(node,bytes([pattern])*108);w(node,node_class);u.mem_write(node+28,b'\0');w(node+24,flags);w(node+4,descriptor);w(node+12,descriptor);w(node+32,table);w(node+36,3);w(node+104,0)
 w(context+0x7c,frame);w(0x14a7a28,context);w(0x14a7a40,context);w(0x12100f8,1024)
 u.mem_write(descriptor,struct.pack('<2I2f',points,2,4.,8.));u.mem_write(points,struct.pack('<3fI3fI3fI',1.,-2.,3.,40,1.,-2.,3.,40,13.,8.,-9.,40));u.mem_write(table,bytes([pattern])*12)
 for i,(link,target)in enumerate(zip(links,targets)):
  u.mem_write(link,bytes([pattern])*52);w(link+48,target);u.mem_write(target,bytes([pattern])*60);u.mem_write(target+56,bytes([4 if i==0 else 0]));w(table+i*4,link)
 def snap():return {'voice':bytes(u.mem_read(voice,408)).hex(),'source_chain':[{'reference':v,'raw':bytes(u.mem_read(v,96)).hex()}for v in chain],'resource':bytes(u.mem_read(resource,72)).hex(),'node':bytes(u.mem_read(node,108)).hex(),'descriptor':bytes(u.mem_read(descriptor,16)).hex(),'points':bytes(u.mem_read(points,48)).hex(),'table':bytes(u.mem_read(table,12)).hex(),'links':[{'reference':v,'raw':bytes(u.mem_read(v,52)).hex()}for v in links],'targets':[{'reference':v,'raw':bytes(u.mem_read(v,60)).hex()}for v in targets],'rng_state':rng}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,voice);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0xaef540,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'voice_flags':voice_flags,'present':present,'node_class':node_class,'flags':flags,'depth':depth,'frame':frame,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaef540','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AEF540 voice-once activation caller executes with original AF3150 default property lookup, source-chain nearest resource state and complete B14310 activation. Voice half296 overwrite before guard, byte301 high-bit suppression, null node, class guard, owner pose, RNG and all raw memory effects recorded. Source property tables at offsets40/72 are null in these cases; nonnull table/range/random lookup remains unqualified. Supplied voice/source constructors, frame integration, final voice retirement and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_once_activation_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original once-only voice activation cases')
