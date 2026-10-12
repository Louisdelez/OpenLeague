from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
node=vector+0x6000;table=vector+0x7000;mask=vector+0x8000;aux=vector+0x9000;calls=[];freed=[];visited=set()
def hook(uc,a,size,data):
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,pointer=read(sp+4),read(sp+8);assert pool==17 and pointer in [table,mask,aux] and pointer not in freed;freed.append(pointer);calls.append({'kind':'free','pool':pool,'reference':pointer,'node_at_call':bytes(u.mem_read(node,108)).hex()});finish(1);return
 assert 0xb1b480<=a<0xb1b4dd or 0xb1bca0<=a<0xb1bd0f,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
profiles=[('construct',p,0,False,False,False)for p in [0,0xa5,0xff]]+list(('retire',p,flags,t,m,a)for p,flags,t,m,a in itertools.product([0,0xa5],[0,2],[False,True],[False,True],[False,True]))
for kind,pattern,flags,t,m,a in profiles:
 calls.clear();freed.clear();u.mem_write(node,bytes([pattern])*108);u.mem_write(table,bytes([0xa5])*16);u.mem_write(mask,bytes([0x5a])*4);u.mem_write(aux,bytes([0x33])*36);w(0x12100dc,17)
 if kind=='retire':w(node,1);w(node+32,table if t else 0);w(node+36,3);w(node+40,4);w(node+8,mask if m else 0);w(node+24,flags);w(node+104,aux if a else 0)
 def snap():return {'node':bytes(u.mem_read(node,108)).hex(),'table':bytes(u.mem_read(table,16)).hex(),'mask':bytes(u.mem_read(mask,4)).hex(),'aux':bytes(u.mem_read(aux,36)).hex(),'freed':list(freed)}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb1b480 if kind=='construct'else 0xb1bca0,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'kind':kind,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'counts':{'construct':3,'retire':32},'cases':rows,'native_addresses':len(visited),'findings':['Constructor initializes specific words/halfwords of108 bytes and preserves untouched fields.','Retirement frees binding table first, clears count before transport call and base/capacity afterwards. History is freed and nulled only under flag2. Auxiliary allocation at104 is freed last and pointer remains unchanged.'],'limits':['Physical free is a controlled mandatory transport. Standalone native preparation only; Rust108byte construction, owned retirement and caller integration remain required. Repeated retirement with dangling auxiliary pointer is not accepted as normal success.']}
(r/'data/4.20/audio_path_lifecycle_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native108byte construction/retirement cases')
