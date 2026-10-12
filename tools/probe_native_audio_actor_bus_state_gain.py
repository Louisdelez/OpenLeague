"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xa000;curves=heap+0xa400;points=heap+0xb000;table=heap+0xc000
u.mem_map(heap+0x10000,0x10000);bus_nodes=[heap+0x11000+i*0x100 for i in range(3)]
u.mem_write(table,p.get_data(0xff1cd8-base,0x180));calls=[];rng=17
regions=[(0xaeebb0,0xaeec4f),(0xaed0b0,0xaed0f9),(0xb02a70,0xb02cda),(0xaf0880,0xaf14c2),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global rng
 if a==0xaf0880:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'actor','node':nodes.index(u.reg_read(UC_X86_REG_ECX)),'first':read(sp+20,'I')[0],'last':read(sp+28,'I')[0]})
 if a==0xb02a70:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'bus','node':100+bus_nodes.index(u.reg_read(UC_X86_REG_ECX)),'mask':read(sp+8,'I')[0],'owner':read(sp+16,'I')[0],'first':read(sp+20,'I')[0],'last':read(sp+28,'I')[0]})
 if a==0xaeebb0:
  sp=u.reg_read(UC_X86_REG_ESP);sub,flags,gain_bits=read(sp+4,'III');calls.append({'kind':'gain','node':nodes.index(sub) if sub in nodes else 100+bus_nodes.index(sub),'flags':flags,'gain_bits':gain_bits})
 if a==0xb11040:
  sp=u.reg_read(UC_X86_REG_ESP);sub,param,owner=read(sp+4,'III');calls.append({'kind':'rtpc','node':nodes.index(sub) if sub in nodes else 100+bus_nodes.index(sub),'parameter':param,'owner':owner})
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
for depth,mask,first,flags,scope,range_mode,enabled,owner,bus_position,last,bus_depth,gain_profile,existing_gains in itertools.product([1,3],[31],[0,1],[(0xe0,3)],[3],[2],[False,True],[0,77],['child','root'],[0,1],[1,3],[(1.,1.,1.),(0.5,0.75,0.25),(0.,1.,-0.),(2.,-1.,2.)],[False,True]):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 configs=[];binding_index=0;bus_index=0 if bus_position=='child' else depth-1
 for index,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',table);put(address+0x20,'I',nodes[index+1] if index+1<depth else 0);u.mem_write(address+0x55,bytes(flags));props={23:-7.25+index,24:3.5-index,0:-31.+index*8.,2:40.+index*7.,3:5.5+index,32:12.5+index,22:-6.25+index,33:-2.25+index};prop_ptr=heap+0x3000+index*0x300;props.pop(32,None) if flags[1]==4 else None;scalar(prop_ptr,props);put(address+0x28,'I',prop_ptr)
  global_props={10:gain_profile[0],0:1.25+index,2:-3.5-index,3:2.+index} if scope in [1,3] else {};owner_props={10:gain_profile[1],0:0.5+index,2:4.25+index,3:-1.25-index} if scope in [2,3] else {};cached=[{0:2.+index,2:-1.5-index,3:3.25+index,4:0.75+index},{0:-0.25-index,2:0.5+index,3:1.25+index,4:-0.5-index}] if scope==3 else []
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
   put(address+0x30,'II',(1<<0)|(1<<2)|(1<<3)|(1<<22)|(1<<23)|(1<<19),(1<<(35-32))|(1<<(36-32)))
   for parameter in [0,2,3,19,22,23,35,36]:
    binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=((address+parameter)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,parameter,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+parameter,100,ps,2,0);begin=parameter*0.125+index*2.;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4);binding_index+=1
  put(address+0x24,'I',bus_nodes[0] if index==bus_index else 0)
  configs.append({'bus':index==bus_index,'props':props,'global':global_props,'object':owner_props,'cached':cached,'ranges':ranges,'flags55':flags[0],'flags56':flags[1],'reference':address,'rtpc':enabled})
 bus_configs=[]
 for i,address in enumerate(bus_nodes[:bus_depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',0xff1380);put(address+0x24,'I',bus_nodes[i+1] if i+1<bus_depth else 0);props={0:99.,2:3.25+i,3:-2.5+i,4:88.};ptr=heap+0x12000+i*0x200;scalar(ptr,props);put(address+0x28,'I',ptr);global_props={10:gain_profile[2],2:1.5+i,3:-0.75-i} if scope==3 else {};cached=[{0:22.,2:-1.25+i,3:0.5+i,4:42.}] if scope==3 else []
  if global_props:at=heap+0x13000+i*0x200;put(address+0x14,'I',at);put(at+0xc,'I',at+0x20);scalar(at+0x20,global_props,8)
  if cached:at=heap+0x14000+i*0x200;put(address+0x10,'I',at);put(address+0x2e,'B',0x80);put(at+8,'I',0);put(at+0x10,'I',at+0x20);scalar(at+0x20,cached[0],8)
  if enabled:
   put(address+0x30,'II',(1<<2)|(1<<3),0)
   for parameter in [2,3]:
    binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=((address+parameter)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,parameter,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+parameter,100,ps,2,0);begin=parameter*0.125+i*2.;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4);binding_index+=1
  bus_configs.append({'reference':address,'props':props,'global':global_props,'cached':cached,'rtpc':enabled})
 before_gains=[] if not existing_gains else [{'id':nodes[0],'flags':0xa6,'gain_bits':0x3f000000},{'id':bus_nodes[0],'flags':0xa7,'gain_bits':0x3f4ccccd}];gain_array=heap+0x1a000;u.mem_write(gain_array,bytes(32*12));put(heap+0x2200,'III',gain_array,len(before_gains),32)
 for i,e in enumerate(before_gains):put(gain_array+i*12,'III',e['id'],e['flags'],e['gain_bits'])
 u.mem_write(out,bytes(84));put(out,'ff',13.,1.);put(out+8,'ff',17.,19.);put(out+0x14,'f',5.);put(extra,'fff',23.,29.,31.);calls.clear();rng=17;sp=stack+0x8000;put(sp,'IIIIIIII',trap,out,mask,heap+0x2200,owner,first,extra,last);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xaf0880,trap,count=30000);assert u.reg_read(UC_X86_REG_EIP)==trap and u.reg_read(UC_X86_REG_EAX)==1
 after_gains=[{'id':read(gain_array+i*12,'I')[0],'flags':read(gain_array+i*12+4,'I')[0],'gain_bits':read(gain_array+i*12+8,'I')[0]} for i in range(read(heap+0x2200+4,'I')[0])]
 rows.append({'gain_profile':gain_profile,'before_gains':before_gains,'after_gains':after_gains,'bus_index':bus_index,'bus_nodes':bus_configs,'last':last,'mask':mask,'first':first,'owner':owner,'nodes':configs,'output_block':bytes(u.mem_read(out,84)).hex(),'output_extras_bits':read(extra,'III'),'rng':rng,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'parameter_mapping':{'0':0,'2':2,'3':3,'32':35,'33':36,'22':19},'default_property32_bits':read(0x1210188,'I')[0],'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Only CRT random result adapted to explicit seed17 sequence (prior CRT arithmetic qualification). Original AF0880/AFEF40 parent recursion, state/static/range arithmetic and actual RTPC manager/curve code execute unchanged.','Constructed verified-layout static/global/object/cached tables, raw flags and manager bindings. Actual FF1380 bus actor B02A70 executes unchanged from the selected actor bus24. Effects absent. Non-unit state10 global/object/bus gain callers and AEEBB0/AED0B0 lookup/mutation execute unchanged with spare-capacity vector.'],'limits':['Non-unit state10 gain entries are executed and raw caller flags captured. Upper flag bits include native call-frame locals; class bits and preserved existing flags require explicit qualification. Extended50/effects4C and vector growth absent.','Raw flags55/56 used as explicit internal layout inputs; bank-to-node initialization still separate.','Runtime RNG ownership, live state updates/smoothing and device/voice output remain open.']}
(r/'data/4.20/audio_actor_bus_state_gain_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original actor/bus non-unit state10 gain-entry composition cases')
