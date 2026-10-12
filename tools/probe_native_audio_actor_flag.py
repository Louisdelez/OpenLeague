"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xa000;curves=heap+0xa400;points=heap+0xb000;table=heap+0xc000
u.mem_write(table,p.get_data(0xff1cd8-base,0x180));calls=[];rng=17
regions=[(0xaf14d0,0xaf1583),(0xaf06f0,0xaf071c),(0xaf0880,0xaf14c2),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global rng
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaf14d0:calls.append({'kind':'node','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
 if a==0xaf06f0:calls.append({'kind':'object','node':(u.reg_read(UC_X86_REG_ECX)-heap-0x5000)//0x300,'owner':read(sp+4,'I')[0]})
 if a==0xaf0880:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'actor','node':nodes.index(u.reg_read(UC_X86_REG_ECX)),'first':read(sp+20,'I')[0],'last':read(sp+28,'I')[0]})
 if a==0xb11040:
  sp=u.reg_read(UC_X86_REG_ESP);sub,param,owner=read(sp+4,'III');calls.append({'kind':'rtpc','node':nodes.index(sub),'parameter':param,'owner':owner})
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;draw=(rng>>16)&0x7fff;calls.append({'kind':'draw','value':draw});ret(draw,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def scalar(address,props,stride=4):
 keys=list(props);count=len(keys);header=(count+4)&~3;u.mem_write(address,bytes(0x80));u.mem_write(address,bytes([count,*keys]));
 for index,key in enumerate(keys):
  if stride==4:put(address+header+index*stride,'f',props[key])
  else:put(address+header+index*stride,'ff',props[key],0.)
rows=[]
for depth,selection,init_mode,global_mode,object_mode,enabled,profile,owner in itertools.product([1,3],range(4),range(3),range(3),range(4),[False,True],range(4),[0,77,88,0xffffffff]):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 configs=[]
 for index,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',table);put(address+0x20,'I',nodes[index+1] if index+1<depth else 0)
  chosen=(selection==1 and index==0) or (selection==2 and index==depth//2) or (selection==3 and index+1==depth);flags2f=0x40 if chosen else 0;u.mem_write(address+0x2f,bytes([flags2f]))
  initial=None if init_mode==0 else 0xa5|((int(init_mode==2)^(index%2))<<4)
  if initial is not None:
   ptr=heap+0x4000+index*0x300;u.mem_write(ptr,bytes(0x40));u.mem_write(ptr+0x20,bytes([initial]));put(address+0x18,'I',ptr)
  global_flag=None if global_mode==0 else 0xa5|((int(global_mode==2)^(index%2))<<4)
  if global_flag is not None:
   ptr=heap+0x6000+index*0x300;u.mem_write(ptr,bytes(0x40));u.mem_write(ptr+0x10,bytes([global_flag]));put(address+0x14,'I',ptr)
  objects=None if object_mode==0 else ([] if object_mode==3 else [(77,0xa5|((int(object_mode==2)^(index%2))<<4)),(0,0xa5|((int(object_mode!=2)^(index%2))<<4)),(77,0xa5|((int(object_mode!=2)^(index%2))<<4))])
  if objects is not None:
   ptr=heap+0x5000+index*0x300;u.mem_write(ptr,bytes(0x200));put(address+0x40,'I',ptr);put(ptr,'II',ptr+0x20,len(objects))
   for item,(id,flag) in enumerate(objects):
    state=ptr+0x80+item*0x30;put(ptr+0x20+item*8,'II',id,state);u.mem_write(state+0x10,bytes([flag]))
  begin=[-2.5,0.,2.5,-2.5][profile]+index*0.125;end=begin+(10. if profile==3 else 0.)
  if profile==1:begin=end=0.
  if enabled:put(address+0x30,'I',1<<28)
  binding=bindings+index*32;curve=curves+index*20;ps=points+index*32;bucket=((address+28)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,28,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1028,100,ps,2,0);put(ps,'ffIffI',0.,begin,4,100.,end,4)
  configs.append({'reference':address,'flags2f':flags2f,'initial':initial,'global':global_flag,'objects':objects,'rtpc':enabled,'curve':[begin,end]})
 calls.clear();sp=stack+0x8000;put(sp,'II',trap,owner);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xaf14d0,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap;value=u.reg_read(UC_X86_REG_EAX)&255;assert value in [0,1]
 rows.append({'owner':owner,'nodes':configs,'value':value,'calls':list(calls)})
proof={'complete':False,'passed':True,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Original FF1CD8 E8=AF14D0 inheritance, static/RTPC prefix, AF06F0 linear first-match owner lookup and actual manager/curve bodies execute unchanged. No flag result adapter.','Constructed native-layout initialization/global/object records including absent and empty owner arrays, duplicate owner entries and raw flags with unrelated bits.'],'limits':['Bank/runtime initialization, owner-state mutations and synchronization remain open.','Only finite curve inputs/outputs; Rust must reject invalid manager values explicitly rather than invent a Boolean result.','Full voice refresh composition and normal audio output remain separate.']}
(r/'data/4.20/audio_actor_flag_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native actor inherited flag cases')
