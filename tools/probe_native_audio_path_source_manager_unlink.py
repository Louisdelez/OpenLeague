from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
table=vector+0x1000;nodes=vector+0x2000;keyptr=vector+0x3000;visited=set()
def hook(uc,a,size,data):assert 0xaf6650<=a<0xaf66bb,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,position,key,counter,duplicate in itertools.product([0,0xa5],[0,1,3],range(4),[0,192,193,0xffffffff],[0,3],[False,True]):
 u.mem_write(table,bytes([pattern])*780);u.mem_write(nodes,bytes([pattern])*48)
 for i in range(193):w(table+i*4,0)
 w(table+key%193*4,nodes if count else 0);w(table+772,counter);w(keyptr,key)
 for i in range(3):
  n=nodes+i*16;w(n+4,nodes+(i+1)*16 if i+1<count else 0)
  other=key+(i+1)*193 if key<0xfffff000 else key-(i+1)*193
  w(n+8,key if i==position or duplicate and position<count and i>=position else other)
 before={'table':bytes(u.mem_read(table,780)).hex(),'nodes':bytes(u.mem_read(nodes,48)).hex()};w(stack,end);w(stack+4,keyptr);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,table);u.emu_start(0xaf6650,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 after={'table':bytes(u.mem_read(table,780)).hex(),'nodes':bytes(u.mem_read(nodes,48)).hex()}
 rows.append({'pattern':pattern,'count':count,'position':position,'key':key,'counter':counter,'duplicate':duplicate,'before':before,'after':after})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'findings':['Actual AF6650 selects unsigned key modulo193 bucket, unlinks first matching next4/key8 node and decrements count at table+772 wrapping. Removed node/tail/padding retained; no free occurs.'],'limits':['Supplied bucket/node producers and concurrency not qualified. Rust replay and full source terminal reference release composition remain required.']}
(r/'data/4.20/audio_path_source_manager_unlink_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native source manager unlink cases')
