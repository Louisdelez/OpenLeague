"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xa000;curves=heap+0xa400;points=heap+0xb000;table=heap+0xc000
u.mem_write(table,p.get_data(0xff1cd8-base,0x180));calls=[];rng=17
regions=[(0xaf0880,0xaf14c2),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global rng
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
for depth,mask,first,flags,scope,range_mode,enabled,owner in itertools.product([1,3],[0,1,2,4,7,16,23,0xffffffef],[0,1],[(0,0),(0xe0,3),(0xf0,4)],range(4),range(3),[False,True],[0,77]):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 configs=[];binding_index=0
 for index,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',table);put(address+0x20,'I',nodes[index+1] if index+1<depth else 0);u.mem_write(address+0x55,bytes(flags));props={0:-31.+index*8.,2:40.+index*7.,3:5.5+index,32:12.5+index,22:-6.25+index,33:-2.25+index};prop_ptr=heap+0x3000+index*0x300;props.pop(32,None) if flags[1]==4 else None;scalar(prop_ptr,props);put(address+0x28,'I',prop_ptr)
  global_props={0:1.25+index,2:-3.5-index,3:2.+index} if scope in [1,3] else {};owner_props={0:0.5+index,2:4.25+index,3:-1.25-index} if scope in [2,3] else {};cached=[{0:2.+index,2:-1.5-index,3:3.25+index,4:0.75+index},{0:-0.25-index,2:0.5+index,3:1.25+index,4:-0.5-index}] if scope==3 else []
  state_ptr=heap+0x4000+index*0x300
  if global_props:put(address+0x14,'I',state_ptr);put(state_ptr+0xc,'I',state_ptr+0x80);scalar(state_ptr+0x80,global_props,8)
  object_ptr=heap+0x5000+index*0x300
  if owner_props:put(address+0x40,'I',object_ptr);put(object_ptr,'II',object_ptr+0x20,1);put(object_ptr+0x20,'II',77,object_ptr+0x40);put(object_ptr+0x4c,'I',object_ptr+0x80);scalar(object_ptr+0x80,owner_props,8)
  cache_ptr=heap+0x6000+index*0x300
  if cached:
   u.mem_write(address+0x2e,b'\x80');put(address+0x10,'I',cache_ptr)
   for item,values in enumerate(cached):
    ptr=cache_ptr+item*0x100;put(ptr+8,'I',ptr+0x100 if item==0 else 0);put(ptr+0x10,'I',ptr+0x20);scalar(ptr+0x20,values,8)
  ranges={} if range_mode==0 else ({0:(-8.,-8.),2:(3.25,3.25),3:(0.,0.)} if range_mode==1 else {0:(-8.,-2.),2:(0.,200.),3:(0.,0.)})
  if ranges:
   ptr=prop_ptr+0x100;keys=list(ranges);header=(len(keys)+4)&~3;u.mem_write(ptr,bytes([len(keys),*keys]));
   for item,key in enumerate(keys):put(ptr+header+item*8,'ff',*ranges[key])
   put(address+0x48,'I',ptr)
  if enabled:
   put(address+0x30,'II',(1<<0)|(1<<2)|(1<<3)|(1<<19),(1<<(35-32))|(1<<(36-32)))
   for parameter in [0,2,3,19,35,36]:
    binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=((address+parameter)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,parameter,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+parameter,100,ps,2,0);begin=parameter*0.125+index*2.;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4);binding_index+=1
  configs.append({'props':props,'global':global_props,'object':owner_props,'cached':cached,'ranges':ranges,'flags55':flags[0],'flags56':flags[1],'reference':address,'rtpc':enabled})
 u.mem_write(out,bytes(84));put(out,'ff',13.,1.);put(out+8,'ff',17.,19.);put(out+0x14,'f',5.);put(extra,'fff',23.,29.,31.);calls.clear();rng=17;sp=stack+0x8000;put(sp,'IIIIIIII',trap,out,mask,heap+0x2200,owner,first,extra,1);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xaf0880,trap,count=30000);assert u.reg_read(UC_X86_REG_EIP)==trap and u.reg_read(UC_X86_REG_EAX)==1
 rows.append({'mask':mask,'first':first,'owner':owner,'nodes':configs,'output_block':bytes(u.mem_read(out,84)).hex(),'output_extras_bits':read(extra,'III'),'rng':rng,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'parameter_mapping':{'0':0,'2':2,'3':3,'32':35,'33':36,'22':19},'default_property32_bits':read(0x1210188,'I')[0],'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Only CRT random result adapted to explicit seed17 sequence (prior CRT arithmetic qualification). Original AF0880/AFEF40 parent recursion, state/static/range arithmetic and actual RTPC manager/curve code execute unchanged.','Constructed verified-layout static/global/object/cached tables, raw flags and manager bindings. Extended spatial/bus/effect handlers intentionally absent, not replaced by zero results.'],'limits':['Extended50 structures, bus24 routing, effects4C and non-unit state10 bus contribution not exercised.','Raw flags55/56 used as explicit internal layout inputs; bank-to-node initialization still separate.','Runtime RNG ownership, live state updates/smoothing and device/voice output remain open.']}
(r/'data/4.20/audio_actor_controls_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual actor hierarchy/RTPC/state/range cases')
