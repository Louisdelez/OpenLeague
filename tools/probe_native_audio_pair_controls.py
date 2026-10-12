"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xa000;curves=heap+0xa400;points=heap+0xb000;table=heap+0xc000
u.mem_write(table,p.get_data(0xff1cd8-base,0x180));calls=[];rng=17
regions=[(0xaff450,0xaff55c),(0xaf0880,0xaf14c2),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global rng
 if a==0xaff450:calls.append({'kind':'pair','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
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
for depth,selection,secondary,enabled,missing,profile,owner in itertools.product([1,3],range(4),[False,True],[False,True],range(4),range(3),[0,77,88,0xffffffff]):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 configs=[]
 for index,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',table);put(address+0x20,'I',nodes[index+1] if index+1<depth else 0)
  chosen=(selection==1 and index==0) or (selection==2 and index==depth//2) or (selection==3 and index+1==depth);flags2e=(0x40 if chosen else 0)|(0x20 if secondary else 0);u.mem_write(address+0x2e,bytes([flags2e]))
  props={5:[-31.+index*8.,0.,-0.][profile],6:5.5+index}
  if missing&1:props.pop(5)
  if missing&2:props.pop(6)
  ptr=heap+0x3000+index*0x300;scalar(ptr,props);put(address+0x28,'I',ptr)
  if enabled:put(address+0x30,'I',1<<8)
  binding=bindings+index*32;curve=curves+index*20;ps=points+index*32;bucket=((address+8)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,8,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1008,100,ps,2,0);begin=[-2.5,0.,2.5][profile]+index*0.125;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4)
  configs.append({'reference':address,'flags2e':flags2e,'props':props,'rtpc':enabled,'curve':[begin,begin+10.]})
 u.mem_write(out,bytes([0xa5])*8);calls.clear();sp=stack+0x8000;put(sp,'III',trap,out,owner);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xaff450,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap and u.reg_read(UC_X86_REG_EAX)==out
 rows.append({'owner':owner,'nodes':configs,'output_bits':read(out,'II'),'calls':list(calls)})
proof={'complete':False,'passed':True,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'default_property5_bits':read(0x121011c,'I')[0],'default_property6_bits':read(0x1210120,'I')[0],'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Original AFF450 ancestor selection, static/default properties5/6, RTPC8 manager/curve evaluation and raw pair copy execute unchanged; no pair result adapter.'],'limits':['Preparatory native evidence; Rust pair dependency is not replaced by this probe.','AEF2F0 transition consumer and normal sound output remain open.']}
(r/'data/4.20/audio_pair_controls_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native inherited pair cases')
