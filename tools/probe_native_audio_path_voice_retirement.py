from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
voice=vector+0xe000;source=vector+0xc000;resource=vector+0xd000;manager=vector+0x5000;table=vector+0x7000;nodes=[vector+0x8000+i*128 for i in range(3)];calls=[];freed=[];allocations=[];visited=set()
def hook(uc,a,size,data):
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==17 and ref in [v['reference']for v in allocations] and ref not in freed;freed.append(ref);calls.append({'kind':'free','pool':pool,'reference':ref,'manager_at_call':bytes(u.mem_read(manager,16)).hex(),'table_at_call':bytes(u.mem_read(table,16)).hex(),'voice_at_call':bytes(u.mem_read(voice,424)).hex(),'resource_at_call':bytes(u.mem_read(resource,72)).hex()});finish(1);return
 if a==0x5642d0:calls.append({'kind':'destroy_node','reference':u.reg_read(UC_X86_REG_ECX)})
 assert 0xaefb30<=a<0xaefc0a or 0xaf1a70<=a<0xaf1a8d or 0xb141f0<=a<0xb14261 or 0xb14180<=a<0xb141ed or 0xb1bca0<=a<0xb1bd0f or 0x5642d0<=a<0x5642d3,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,mode,voice_flags,present,flags,retained,depth in itertools.product([0,0xa5],[0,1,2,3],[0,1,128,16,255],[False,True],[0,2],[False,True],[1,3]):
 calls.clear();freed.clear();allocations.clear();u.mem_write(manager,bytes([pattern])*16);w(manager,table);w(manager+4,1);w(manager+8,4);w(manager+12,4);u.mem_write(table,bytes([pattern])*16);w(table,nodes[0]);w(0x12100dc,17);w(0x14a7a40,manager)
 n=nodes[0];bindings=vector+0x9000;mask=vector+0xa000;aux=vector+0xb000
 u.mem_write(n,bytes([pattern])*108);w(n,1);w(n+24,flags);w(n+32,bindings);w(n+36,1);w(n+40,4);u.mem_write(n+44,bytes([int(retained),1]));w(n+8,mask);w(n+104,aux)
 for ref,size,p in [(n,108,None),(bindings,16,0x33),(mask,4,0x5a),(aux,36,0x77)]:
  if p is not None:u.mem_write(ref,bytes([p])*size)
  allocations.append({'reference':ref,'size':size})
 w(bindings,voice);u.mem_write(voice,bytes([pattern])*424);w(voice+48,resource);w(voice+80,0);w(voice+84,0);w(voice+96,source);w(voice+400,n if present else 0);w(voice+404,0x11223344);u.mem_write(voice+301,bytes([voice_flags]));u.mem_write(resource,bytes([pattern])*72);w(resource+64,123);w(resource+68,mask)
 chain=[source+i*128 for i in range(depth)]
 for i,ref in enumerate(chain):u.mem_write(ref,bytes([pattern])*96);w(ref+32,chain[i+1]if i+1<depth else 0);w(ref+68,resource if i==depth-1 else 0)
 def snap():return {'voice':bytes(u.mem_read(voice,424)).hex(),'source_chain':[{'reference':ref,'raw':bytes(u.mem_read(ref,96)).hex()}for ref in chain],'resource':bytes(u.mem_read(resource,72)).hex(),'manager':bytes(u.mem_read(manager,16)).hex(),'table':bytes(u.mem_read(table,16)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex(),'freed':v['reference']in freed}for v in allocations]}
 before=snap();w(stack,end);w(stack+4,mode);w(stack+8,1);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0xaefb30,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'mode':mode,'voice_flags':voice_flags,'present':present,'flags':flags,'retained':retained,'depth':depth,'before':before,'after':snap(),'calls':list(calls),'freed':list(freed)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaefb30','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual original voice retirement phase guard, mode0/2 gate, source nearest state clear, actual voice binding B141F0 removal and last-owner B14180/B1BCA0 object retirement execute. Voice424 includes untouched tail; borrowed resource state clears before physical free; retained node remains managed. Callback suppression argument1 supplied; slots80/84 null, B1C080 dispatch and AF5B90 owner release not executed. Physical frees are controlled transports with whole voice/resource/manager/table snapshots; constructor producers, other ownership branches, full frame integration and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_retirement_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual voice binding/borrowed-state/node retirement cases')
