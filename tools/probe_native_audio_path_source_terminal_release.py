from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;manager=vector+0x5000;nodes=vector+0x7000;buffers=vector+0x8000;calls=[];visited=set()
w(0x14a7a08,manager);w(0x12100dc,19);w(0xfa4424,vector+0xf000);w(0xfa4428,vector+0xf010)
def snap():return {n:bytes(u.mem_read(a,size)).hex()for n,a,size in [('source',source,160),('manager',manager,1600),('nodes',nodes,48),('buffers',buffers,160)]}
def hook(uc,a,size,data):
 if a in [vector+0xf000,vector+0xf010]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'lock'if a==vector+0xf000 else'unlock','receiver':read(sp+4)});finish(1,4);return
 if a in [0xaf6650,0xae13f0,0xb22660]:
  sp=u.reg_read(UC_X86_REG_ESP);ev={'kind':{0xaf6650:'remove_manager_key',0xae13f0:'source_virtual14',0xb22660:'source_destructor'}[a],'receiver':u.reg_read(UC_X86_REG_ECX)}
  if a==0xaf6650:ev['key']=read(read(sp+4))
  if a==0xb22660:ev['argument']=read(sp+4)
  calls.append(ev);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8),'source_at_call':bytes(u.mem_read(source,160)).hex()});finish(1);return
 assert any(b<=a<e for b,e in [(0xb00180,0xb00243),(0xaf6430,0xaf6445),(0xaf6650,0xaf66bb),(0xae13f0,0xae13f5),(0xafec20,0xafec9d),(0xb22660,0xb22691),(0xb01d30,0xb01d35),(0xb01da0,0xb01dfc),(0xaf30d0,0xaf30db),(0xaefc60,0xaefdda),(0xafdf20,0xafe0d7),(0xafd4f0,0xafd4fb),(0xafd4b0,0xafd4b7)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[];key=0x12345678
for pattern,flag,count,owned,position in itertools.product([0,0xa5],[0,2],[0,1,2,0xffffffff],[False,True],range(5)):
 u.mem_write(source,bytes([pattern])*160);u.mem_write(manager,bytes(1600));u.mem_write(nodes,bytes([pattern])*48);u.mem_write(buffers,bytes([0x33])*160)
 w(source,0xff1cd8);w(source+4,0);w(source+8,key);w(source+12,count);u.mem_write(source+47,bytes([flag]));
 for o in [16,20,24,28,32,36,40,48,52,56,64,68,72,76,80]:w(source+o,0)
 for j,o in enumerate([24,40,72,80]):w(source+o,buffers+j*32 if owned else 0)
 w(source+104,4 if owned else 0);w(source+108,buffers+128 if owned else 0)
 chain=([source,nodes,nodes+16]if position==0 else[nodes,source,nodes+16]if position==1 else[nodes,nodes+16,source]if position==2 else[nodes,nodes+16,nodes+32]if position==3 else[])
 for i,n in enumerate(chain):w(n+4,chain[i+1]if i+1<len(chain)else 0);w(n+8,key if n==source else key+1+i)
 section=manager+(0x320 if flag&2 else 0);table=section+24;w(table+(key%193)*4,chain[0]if chain else 0);w(table+772,len(chain))
 calls.clear();before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xb00180,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)==(count-1)&0xffffffff
 rows.append({'pattern':pattern,'flag':flag,'count':count,'owned':owned,'position':position,'before':before,'after':snap(),'calls':list(calls),'result':u.reg_read(UC_X86_REG_EAX)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual B00180/AF6430/AF6650/AE13F0/AFEC20/B22660/B01D30/B01DA0/AF30D0/AEFC60/AFDF20/AFD4F0/AFD4B0 compose in one original execution. OS locking and physical allocator free adapted; ordered source bytes at every free captured.','Source action list, owner, parent/wrapper, state/auxiliary descriptor tables and callback bit mask are null here; terminal inline managed buffer and simple source buffers are exercised. Constructors/concurrent locks and Rust replay remain required.']}
(r/'data/4.20/audio_path_source_terminal_release_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual source reference terminal cleanup/destructor cases')
