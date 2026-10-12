"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xa000;curves=heap+0xa400;points=heap+0xb000;table=heap+0xc000
u.mem_write(table,p.get_data(0xff1cd8-base,0x180));calls=[];rng=17
regions=[(0xaf3060,0xaf30a5),(0xafeca0,0xafee20),(0xaf0880,0xaf14c2),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global rng
 if a==0xafeca0:calls.append({'kind':'chosen','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
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
for depth,selection,flag20,rtpc_mask,missing,owner,variant in itertools.product([1,3],range(4),[False,True],range(4),range(5),[0,77,88],range(2)):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 configs=[];binding_index=0
 for index,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',table);put(address+0x20,'I',nodes[index+1] if index+1<depth else 0)
  selected=(selection==1 and index==0) or (selection==2 and index==depth//2) or (selection==3 and index+1==depth)
  flags=(0x10 if selected else 0)|(0x20 if flag20 else 0);u.mem_write(address+0x2f,bytes([flags]))
  props={11:-4.25+index+variant,12:12.5+index*3-variant,13:-0.0 if variant==0 else 7.25+index}
  if missing in [1,2,3]:props.pop(10+missing)
  if missing==4:props={}
  ptr=heap+0x3000+index*0x300;scalar(ptr,props);put(address+0x28,'I',ptr);put(address+0x30,'I',((rtpc_mask&1)<<20)|((rtpc_mask&2)<<20))
  for parameter in [20,21]:
   binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=((address+parameter)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,parameter,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+parameter,100,ps,2,0);begin=parameter*0.125+index*2.+variant;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4);binding_index+=1
  configs.append({'reference':address,'flags2f':flags,'props':props,'rtpc_mask':rtpc_mask,'variant':variant})
 u.mem_write(out,bytes([0xa5])*16);calls.clear();sp=stack+0x8000;put(sp,'IIII',trap,owner,out,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xaf3060,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'owner':owner,'nodes':configs,'output':bytes(u.mem_read(out,16)).hex(),'calls':list(calls)})
proof={'complete':False,'passed':True,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Constructed original-layout node property tables, raw flags and actual manager records/curves. Original AF3060/AFECA0 ancestor selection and static/RTPC code execute unchanged. No spatial result adapter.'],'limits':['Optional third AF3060 pose pointer is null; AFEE20 pose contribution and virtual78 attenuation getter remain unqualified.','Three f32 fields plus flag byte are captured. Existing core Backend spatial pair only represents the first two fields and must be expanded before claiming integration.','Runtime node/pose initialization, updates and actual sound output remain open.']}
(r/'data/4.20/audio_spatial_controls_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native spatial selection/static/RTPC controls cases')
