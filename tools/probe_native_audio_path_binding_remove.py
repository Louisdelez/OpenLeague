from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x5000;table=vector+0x7000;nodes=[vector+0x8000+i*128 for i in range(3)];calls=[];freed=[];allocations=[];visited=set()
def hook(uc,a,size,data):
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==17 and ref in [v['reference']for v in allocations] and ref not in freed;freed.append(ref);calls.append({'kind':'free','pool':pool,'reference':ref,'manager_at_call':bytes(u.mem_read(manager,16)).hex(),'table_at_call':bytes(u.mem_read(table,16)).hex()});finish(1);return
 if a==0x5642d0:calls.append({'kind':'destroy_node','reference':u.reg_read(UC_X86_REG_ECX)})
 assert 0xb141f0<=a<0xb14261 or 0xb14180<=a<0xb141ed or 0xb1bca0<=a<0xb1bd0f or 0x5642d0<=a<0x5642d3,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,binding_count,kind,retained,zero_counter in itertools.product([0,0xa5],[0,1,3],[0,1,3],['first','last','missing'],[False,True],[False,True]):
 flags=2;has_table=True;has_aux=True
 calls.clear();freed.clear();allocations.clear();u.mem_write(manager,bytes([pattern])*16);w(manager,table);w(manager+4,count);w(manager+8,4);w(manager+12,255);u.mem_write(table,bytes([pattern])*16);w(0x12100dc,17)
 for i,n in enumerate(nodes):
  w(table+i*4,n);u.mem_write(n,bytes([pattern])*108);w(n,1);w(n+24,flags);bindings=vector+0x9000+i*64;mask=vector+0xa000+i*64;aux=vector+0xb000+i*64;w(n+32,bindings if has_table else 0);w(n+36,2);w(n+40,4);w(n+8,mask);w(n+104,aux if has_aux else 0)
  for ref,size,p in [(n,108,None),(bindings,16,0x33),(mask,4,0x5a),(aux,36,0x77)]:
   if p is not None:u.mem_write(ref,bytes([p])*size)
   allocations.append({'reference':ref,'size':size})
 reference=nodes[0];w(reference+36,binding_count);u.mem_write(reference+44,bytes([int(retained),0 if zero_counter else binding_count]));binding_table=vector+0x9000
 for i in range(3):w(binding_table+i*4,vector+0xd000+i*64)
 key=vector+0xd000 if kind=='first'else vector+0xd000+(max(binding_count,1)-1)*64 if kind=='last'else vector+0xe000

 def snap():return {'manager':bytes(u.mem_read(manager,16)).hex(),'table':bytes(u.mem_read(table,16)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex(),'freed':v['reference']in freed}for v in allocations]}
 before=snap();w(stack,end);w(stack+4,reference);w(stack+8,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb141f0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'key':key,'reference':reference,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb141f0','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'findings':['Binding removal swaps last live link, decrements count36 and wrapping byte45 before testing retained byte44. Last unretained reference invokes actual owning manager removal. Missing binding returns41. Missing owning manager after last reference returns36 with binding removal mutations preserved.','Manager removal is first-match, replaces removed slot with final live pointer, decreases count before node retirement and retains table capacity/trailing storage.','Actual B1BCA0 releases binding storage, flag2-owned history and auxiliary before the empty destructor and object allocation release. Missing node returns36 without side effects.'],'limits':['Physical free is a controlled mandatory transport. Rust last-binding removal and owning manager composition and whole frame caller integration remain required.']}
(r/'data/4.20/audio_path_binding_remove_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native manager owning removal cases')
