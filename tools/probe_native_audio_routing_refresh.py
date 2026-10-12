"""Original whole AEE790 + AF0880 composition, no actor parameter adapter."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xc400;curves=heap+0xa400;points=heap+0xb000;table=heap+0xc000
u.mem_write(table,p.get_data(0xff1cd8-base,0x180));calls=[];rng=17
u.mem_map(heap+0x10000,0x10000);pose=heap+0x14000;att_manager=heap+0x11000;att=heap+0x15000;att_points=heap+0x15400;att_table=heap+0x15900
put(0x14a7a08,'I',att_manager);put(0xfa4424,'I',trap+0x900);put(0xfa4428,'I',trap+0xa00);put(att_table+8,'I',trap+0x800)

voice=heap+0xd000;context=heap+0xe000;source_value=heap+0xe100
u.mem_write(trap+0x400,b"\xd9\x05"+struct.pack("<I",source_value)+b"\xc2\x04\x00")

route_manager=heap+0x1c000
regions=[(0xaef360,0xaef40c),(0xb15530,0xb1555d),(0xafeb10,0xafeb1b),(0xb1ad70,0xb1ade0),(0xb1aa50,0xb1aaf5),(0xaf1900,0xaf19dd),(0xaff1e0,0xaff35a),(0xb1caf0,0xb1cb24),(0xaff450,0xaff55c),(0xaef2f0,0xaef35c),(0xb014d0,0xb01513),(0xafd670,0xafd803),(0xafd970,0xafdcee),(0xaf14d0,0xaf1583),(0xaf06f0,0xaf071c),(0xaf3060,0xaf30a5),(0xafeca0,0xafee20),(0xafee20,0xafef32),(0xaf19e0,0xaf1a66),(0xaf9530,0xaf9593),(0xaee790,0xaee995),(0xaee9a0,0xaee9f3),(0xaec310,0xaec3a0),(trap+0x400,trap+0x409),(0xaf0880,0xaf14c2),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global rng
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaf14d0:calls.append({'kind':'node','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
 if a==0xaf06f0:calls.append({'kind':'object','node':(u.reg_read(UC_X86_REG_ECX)-heap-0x5000)//0x300,'owner':read(sp+4,'I')[0]})
 if a==trap+0x900:calls.append({'kind':'lock'});ret(0,4);return
 if a==trap+0xa00:calls.append({'kind':'unlock'});ret(0,4);return
 if a==trap+0x800:
  assert u.reg_read(UC_X86_REG_ECX)==att;count=read(att+0xc,'I')[0];assert count==4;put(att+0xc,'I',count-1);calls.append({'kind':'release'});ret(0,0);return
 if a==0xaf19e0:calls.append({'kind':'attenuation','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
 if a==0xaf9530:calls.append({'kind':'lookup','id':read(sp+4,'I')[0]})
 if a==0xafeca0:calls.append({'kind':'chosen','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
 if a==trap+0x100:calls.append({'kind':'flag','owner':read(sp+4,'I')[0]});ret(1,4);return
 if a==0xb1caf0:calls.append({'kind':'source'})
 if a==0xaef360:calls.append({'kind':'routing'})
 if a==0xaf1900:calls.append({'kind':'inherit','node':nodes.index(u.reg_read(UC_X86_REG_ECX)),'first_raw':read(sp+16,'I')[0]})
 if a==0xada610:
  pool,size,align=read(sp+4,'III');calls.append({'kind':'allocate','size':size,'alignment':align});ret(0 if pair_mode==3 else context,0);return
 if a==0xaff450:calls.append({'kind':'pair','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
 if a==0xaef2f0:calls.append({'kind':'transition','value_bits':read(sp+4,'I')[0]})
 if a==0xb014d0:calls.append({'kind':'dispatch','group':u.reg_read(UC_X86_REG_ECX),'voice':read(sp+8,'I')[0],'value_bits':read(sp+4,'I')[0]})
 if a==0xaf0880:calls.append({'kind':'actor','node':nodes.index(u.reg_read(UC_X86_REG_ECX)),'first':read(sp+20,'I')[0],'last':read(sp+28,'I')[0]})
 if a==0xb11040:
  sub,param,owner=read(sp+4,'III');calls.append({'kind':'rtpc','node':nodes.index(sub),'parameter':param,'owner':owner})
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
for depth,mask,first,flags,scope,range_mode,enabled,owner,att_mode,endpoint,pose_present,flag_mode,pair_mode in itertools.product([1,3],[0xffffffef,0xffffffff],[0,1],[(0,0),(0xe0,3)],[0,3],[2],[False,True],[0,77],[5],[50.],[False,True],[0,3],range(4)):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 u.mem_write(att_manager+0x12c0,bytes(0x400));u.mem_write(att,bytes(0x100));put(att,'I',att_table);put(att+8,'II',1234,3);u.mem_write(att+0x5c,b'\x01');put(att_manager+0x12c0+0x18+(1234%193)*4,'I',att);put(att+0x2c,'III',att_points,3,0)
 for i in range(3):put(att_points+i*12,'ffI',endpoint if i==2 else i*5.,1.+i,4)
 source_refs=[heap+0x19000+i*0x100 for i in range(3)];selected_source=pair_mode%3;source_bits=[0xc1520000,0x80000000,0,0x40580000][pair_mode];source_entries=[]
 for i,ptr in enumerate(source_refs):
  bits=source_bits if i==selected_source else struct.unpack('<I',struct.pack('<f',1.+i))[0];u.mem_write(ptr,bytes(0x40));put(ptr+0x20,'I',bits);source_entries.append({'id':101+i,'source':ptr,'value_bits':bits})
 configs=[];binding_index=0
 for index,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',table);put(address+0x20,'I',nodes[index+1] if index+1<depth else 0);u.mem_write(address+0x55,bytes(flags));props={0:-31.+index*8.,2:40.+index*7.,3:5.5+index,32:12.5+index,22:-6.25+index,33:-2.25+index};prop_ptr=heap+0x3000+index*0x300;props.update({11:-4.25+index,12:12.5+index*3.,13:7.25+index});props.update({5:-0. if pair_mode==1 else -31.+index*8.,6:3.25 if pair_mode==1 else 5.5+index});props.pop(5,None) if pair_mode==0 else None;props.pop(6,None) if pair_mode==2 else None;scalar(prop_ptr,props);put(address+0x28,'I',prop_ptr)
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
  source_array=heap+0x19300+index*0x100;put(address+0x58,'II',source_array,len(source_entries))
  for item,entry in enumerate(source_entries):put(source_array+item*8,'II',entry['id'],entry['source'])
  flags2f=(0x10 if index==0 and flags[0]&0x40 else 0)|(0x20 if flags[0]&0x20 else 0);u.mem_write(address+0x2f,bytes([flags2f]))
  if att_mode!=0:
   desc=heap+0x7000+index*0x100;put(desc+8,'I',1234);put(address+0x44,'I',desc)
  if index==0 and flags[0]&0x40:flags2f|=0x40
  u.mem_write(address+0x2f,bytes([flags2f]))
  flag_initial=None if flag_mode==0 else 0xa5|((int(flag_mode==2)^(index%2))<<4)
  if flag_initial is not None:
   ptr=heap+0x17000+index*0x100;u.mem_write(ptr,bytes(0x40));u.mem_write(ptr+0x20,bytes([flag_initial]));put(address+0x18,'I',ptr)
  flag_global=None if not global_props else 0xa5|((int(flag_mode!=2)^(index%2))<<4)
  if flag_global is not None:u.mem_write(state_ptr+0x10,bytes([flag_global]))
  flag_objects=None if not owner_props else [(77,0xa5|((int(flag_mode==2)^(index%2))<<4))]
  if flag_objects is not None:u.mem_write(object_ptr+0x50,bytes([flag_objects[0][1]]))
  flags2e=(0x80 if cached else 0)|(0x40 if pair_mode in [1,3] and index==0 else 0)|(0x20 if pair_mode in [1,2] else 0);u.mem_write(address+0x2e,bytes([flags2e]))
  pair_begin=0. if pair_mode==1 else ([-2.5,0.,-2.5,2.5][pair_mode]+index*2.);pair_end=pair_begin+(0. if pair_mode==1 else 10.)
  if enabled:
   put(address+0x30,'II',(1<<0)|(1<<2)|(1<<3)|(1<<8)|(1<<19)|(1<<20)|(1<<21)|(1<<28),(1<<(35-32))|(1<<(36-32))|(1<<(37-32))|(1<<(38-32)))
   for parameter in [0,2,3,8,19,20,21,28,35,36,37,38]:
    binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=((address+parameter)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,parameter,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+parameter,100,ps,2,0);begin=parameter*0.125+index*2.;end=begin+10.;
    if parameter==8:begin=pair_begin;end=pair_end
    if parameter==28:begin=[-2.5,0.,2.5,-2.5][flag_mode];end=begin+(10. if flag_mode==3 else 0.)
    put(ps,'ffIffI',0.,begin,4,100.,end,4);binding_index+=1
  configs.append({'props':props,'global':global_props,'object':owner_props,'cached':cached,'ranges':ranges,'flags55':flags[0],'flags56':flags[1],'reference':address,'rtpc':enabled,'flags2f':flags2f,'flags2e':flags2e,'pair_curve':[pair_begin,pair_end],'flag_initial':flag_initial,'flag_global':flag_global,'flag_objects':flag_objects,'flag_curve':[[-2.5,0.,2.5,-2.5][flag_mode],[-2.5,0.,2.5,7.5][flag_mode]],'rtpc_mask':3 if enabled else 0,'pose_mask':3 if enabled else 0,'attenuation':None if att_mode==0 else 1234})
 u.mem_write(voice,bytes(0x200));u.mem_write(voice+0x78,bytes([0xa5])*84)
 put(voice+0x60,'III',nodes[0],source_refs[selected_source],owner);cflag=0 if first else 0x80;eflag=0x80 if owner==77 else 0;pflag=1 if mask==0xffffffff else 0
 u.mem_write(voice+0x12c,bytes([cflag,0x5a,eflag,0xa4,pflag]));put(voice+0xd4,'fff',1.25,0.8,0.5);put(voice+0x13c,'ff',0.,3.25);put(voice+0x18c,'I',context if pair_mode==0 else 0);u.mem_write(context,b'\xa5'*0x1000 if pair_mode!=0 else bytes(0x1000));put(context+0x10,'f',6.5 if pair_mode==0 else 0.);put(voice+0x74,'I',3);put(voice+0x12b,'B',5);u.mem_write(route_manager,bytes(0x100));put(route_manager+0x4d,'B',1);put(route_manager+0x10,'I',1);put(0x14a7e4c,'I',0 if pair_mode==2 else route_manager)
 u.mem_write(pose,bytes([0xa5])*60);put(pose+0x14,'fff',9.25,11.5,0.25);initial_pose=bytes(u.mem_read(pose,60)).hex();put(voice+0x30,'I',pose if pose_present else 0)
 priority_old=50. if pair_mode==1 else (5. if pair_mode==3 else 0.);priority_key=0x80000000 if owner==77 else 2;put(voice+0x134,'fI',priority_old,priority_key)
 priority_others=[heap+0x18000+i*0x400 for i in range(4)];priority_groups=[heap+0x1a000,heap+0x1a100,0x12100e0];priority_arrays=[heap+0x1b000,heap+0x1b100,heap+0x1b200];priority_voices=[{'reference':voice,'value':priority_old,'key':priority_key}]
 for ptr,value,key in zip(priority_others,[20.,10.,5.,0.],[0,1,0x7fffffff,0xffffffff]):
  u.mem_write(ptr,bytes(0x200));put(ptr+0x134,'fI',value,key);priority_voices.append({'reference':ptr,'value':value,'key':key})
 group_inputs=[]
 for i,(group,array) in enumerate(zip(priority_groups,priority_arrays)):
  ascending=i==1 or (i==2 and owner==77);refs=priority_others+[voice];refs.sort(key=lambda ptr:(-read(ptr+0x134,'f')[0],read(ptr+0x138,'I')[0] if ascending else -read(ptr+0x138,'I')[0]));u.mem_write(group,bytes(0x18));put(group,'II',array,len(refs));u.mem_write(group+0xe,bytes([int(ascending)]))
  for item,ptr in enumerate(refs):put(array+item*4,'I',ptr)
  group_inputs.append({'reference':group,'ascending':ascending,'before':refs})
 local_groups=[priority_groups[0],priority_groups[1]] if scope==3 else [None,None];put(voice+0x198,'II',*[g or 0 for g in local_groups])
 calls.clear();rng=17;sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0xaee790,trap,count=40000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'mask':mask,'first':first,'owner':owner,'cflag':cflag,'eflag':eflag,'pflag':pflag,'nodes':configs,'routing_mode':pair_mode,'routing_context_reference':context,'routing_initial_prefix':(bytes(16)+struct.pack('<f',6.5)+bytes(28)).hex() if pair_mode==0 else None,'routing_output_reference':read(voice+0x18c,'I')[0],'routing_output_prefix':bytes(u.mem_read(context,48)).hex() if read(voice+0x18c,'I')[0] else None,'source_entries':source_entries,'source_reference':source_refs[selected_source],'priority_voice':voice,'priority_voices':priority_voices,'priority_groups':group_inputs,'priority_local':local_groups,'priority_global':priority_groups[2],'priority_output_bits':read(voice+0x134,'I')[0],'priority_after':[{'reference':g,'after':[read(a+i*4,'I')[0] for i in range(read(g+4,'I')[0])]} for g,a in zip(priority_groups,priority_arrays)],'output_pair_bits':read(voice+0x13c,'II'),'att_mode':att_mode,'endpoint':endpoint,'initial_pose':initial_pose if pose_present else None,'output_pose':bytes(u.mem_read(pose,60)).hex() if pose_present else None,'output_spatial':bytes(u.mem_read(voice+0x160,16)).hex(),'output_block':bytes(u.mem_read(voice+0x78,84)).hex(),'output_flags':list(u.mem_read(voice+0x12c,5)),'output_cc_d0':read(voice+0xcc,'II'),'output_extras_bits':read(voice+0x24,'III'),'rng':rng,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'parameter_mapping':{'0':0,'2':2,'3':3,'32':35,'33':36,'22':19},'default_property32_bits':read(0x1210188,'I')[0],'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions if a<trap],'adapters':['Allocator callback is an explicit dependency interface. Original AEF360/B15530/AFEB10/B1AD70/B1AA50/AF1900/AFF1E0 routing and inheritance execute unchanged; no routing result adapter. Whole AEE790/AEC310/AEE9A0, AF0880, AF3060/AFECA0/AFEE20/AF19E0/AF9530, FF1CD8 E8=AF14D0/AF06F0, AFF450, AEF2F0/B014D0/AFD970/AFDB30, B1CAF0 source lookup and actual manager/curves execute unchanged.','OS lock/unlock and resource release callback are explicit adapters; original acquisition increments counter and adapted release decrements it, verified balanced. Release/destruction body remains separate.','Only CRT random result adapted to explicit seed17 sequence (prior CRT arithmetic qualification). Original AF0880/AFEF40 parent recursion, state/static/range arithmetic and actual RTPC manager/curve code execute unchanged.','Constructed verified-layout static/global/object/cached tables, raw flags and manager bindings. Extended spatial/bus/effect handlers intentionally absent, not replaced by zero results.'],'limits':['Extended50 structures, bus24 routing, effects4C and non-unit state10 bus contribution not exercised.','Raw flags55/56 used as explicit internal layout inputs; bank-to-node initialization still separate.','Runtime RNG ownership, live state updates/smoothing and device/voice output remain open.']}
(r/'data/4.20/audio_routing_refresh_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'whole refresh + original routing/context/source/actor composition cases')
