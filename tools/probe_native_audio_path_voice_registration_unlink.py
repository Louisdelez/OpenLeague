from pathlib import Path
import json,hashlib,itertools,struct
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x8000;table=vector+0x9000;voices=vector+0x4000;target=vector+0x7000;calls=[];visited=set()
def hook(uc,a,size,data):
 if a in [0xaf3ff0,0xaf4080]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'reclaim_single'if a==0xaf3ff0 else'reclaim_multiple','registry':read(sp+4)});return
 assert 0xaf3ff0<=a<=0xaf402c or 0xaf4080<=a<=0xaf40bc or 0xb00250<=a<=0xb002d4 or 0xafd670<=a<0xafd740 or 0xafd740<=a<0xafd810,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,ascending,count,profile,match,selector,list_position in itertools.product([0,0xa5],[False,True],[0,1,3],['distinct','ties','duplicate'],['first','middle','last','missing'],[0,1,2],['first','middle','last','missing','empty']):
 calls.clear();u.mem_write(registry,bytes([pattern])*20);w(registry,table);w(registry+4,count);w(registry+8,4);u.mem_write(registry+14,bytes([int(ascending)]));u.mem_write(table,bytes([pattern])*16);u.mem_write(voices,bytes([pattern])*1536);u.mem_write(target,bytes([pattern])*424)
 keys=[(3.0-i*2.0,10+i*10)for i in range(3)]if profile=='distinct'else[(3.0,10+i*10)for i in range(3)]if profile=='ties'else[(3.0,20)for i in range(3)]
 keys.sort(key=lambda k:(-k[0],k[1]if ascending else-k[1]))
 for i,(score,key)in enumerate(keys):v=voices+i*512;u.mem_write(v+308,struct.pack('<f',score));w(v+312,key);w(table+i*4,v)
 score,key=keys[0 if match=='first'or count==0 else min(count-1,1)if match=='middle'else count-1]if match!='missing'else(100.0,999)
 u.mem_write(target+308,struct.pack('<f',score));w(target+312,key)

 a=vector+0xa000;b=vector+0xb000;u.mem_write(a,bytes([pattern])*20);u.mem_write(b,bytes([pattern])*20)
 order=[registry,a,b]if list_position=='first'else[a,registry,b]if list_position=='middle'else[a,b,registry]if list_position=='last'else[a,b]if list_position=='missing'else[]
 w(registry+16,0);w(a+16,0);w(b+16,0)
 for j,ref in enumerate(order):w(ref+16,order[j+1]if j+1<len(order)else 0)
 w(0x14a7a9c,order[0]if order and selector==1 else 0);w(0x14a7a98,order[0]if order and selector==2 else 0)
 def snap():return {'registry':bytes(u.mem_read(registry,20)).hex(),'table':bytes(u.mem_read(table,16)).hex(),'voices':bytes(u.mem_read(voices,1536)).hex(),'target':bytes(u.mem_read(target,424)).hex(),'single_head':read(0x14a7a9c),'multiple_head':read(0x14a7a98),'sibling_a':bytes(u.mem_read(a,20)).hex(),'sibling_b':bytes(u.mem_read(b,20)).hex()}
 before=snap();w(stack,end);w(stack+4,target);w(stack+8,selector);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xb00250,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'ascending_tie_key':ascending,'count':count,'profile':profile,'match':match,'selector':selector,'list_position':list_position,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb00250','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual B00250 registration removal and AFD670/AFD740 binary search execute on descending finite float word308 and descending/ascending unsigned tie-key312 depending registry byte14. Includes empty, duplicate, first/middle/last/missing keys and physical table tail/padding retention. Actual AF3FF0/AF4080 unlink global single/multiple lists on zero registration count, including first/middle/last/missing/empty positions, preserving removed next pointers and sibling/header padding. These are list unlink operations, not allocation frees; producer ordering, nonfinite inputs, alias/lifetime and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_registration_unlink_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native compound-key registration removal/search cases')
