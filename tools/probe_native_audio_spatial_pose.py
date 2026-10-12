"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xa000;curves=heap+0xa400;points=heap+0xb000;table=heap+0xc000
u.mem_write(table,p.get_data(0xff1cd8-base,0x180));calls=[];rng=17
pose=heap+0xe000;att_manager=heap+0xd000;att=heap+0xf000;att_points=heap+0xf400;att_table=heap+0xf900
put(0x14a7a08,'I',att_manager);put(0xfa4424,'I',trap+0x900);put(0xfa4428,'I',trap+0xa00);put(att_table+8,'I',trap+0x800)

regions=[(0xafee20,0xafef32),(0xaf19e0,0xaf1a66),(0xaf9530,0xaf9593),(0xaf3060,0xaf30a5),(0xafeca0,0xafee20),(0xaf0880,0xaf14c2),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global rng
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==trap+0x900:calls.append({'kind':'lock'});ret(0,4);return
 if a==trap+0xa00:calls.append({'kind':'unlock'});ret(0,4);return
 if a==trap+0x800:
  assert u.reg_read(UC_X86_REG_ECX)==att;count=read(att+0xc,'I')[0];assert count==4;put(att+0xc,'I',count-1);calls.append({'kind':'release'});ret(0,0);return
 if a==0xaf19e0:calls.append({'kind':'attenuation','node':nodes.index(u.reg_read(UC_X86_REG_ECX))})
 if a==0xaf9530:calls.append({'kind':'lookup','id':read(sp+4,'I')[0]})
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
for depth,selection,flag20,spatial_mask,pose_mask,att_mode,owner,endpoint in itertools.product([1,3],range(4),[False,True],range(4),range(4),range(6),[0,77],[0.,50.,-25.]):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 u.mem_write(att_manager+0x12c0,bytes(0x400));u.mem_write(att,bytes(0x100));put(att,'I',att_table);put(att+8,'II',1234,3);u.mem_write(att+0x5c,bytes([255 if att_mode==2 else 1]));
 if att_mode!=1:put(att_manager+0x12c0+0x18+(1234%193)*4,'I',att)
 count=1 if att_mode==4 else 3;put(att+0x2c,'III',0 if att_mode==3 else att_points,count,0)
 for i in range(count):put(att_points+i*12,'ffI',endpoint if i+1==count else i*5.,1.+i,4)
 configs=[];binding_index=0
 for index,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',table);put(address+0x20,'I',nodes[index+1] if index+1<depth else 0)
  chosen=(selection==1 and index==0) or (selection==2 and index==depth//2) or (selection==3 and index+1==depth);flags=(0x10 if chosen else 0)|(0x20 if flag20 else 0);u.mem_write(address+0x2f,bytes([flags]))
  props={11:-4.25+index,12:12.5+index*3,13:7.25+index};ptr=heap+0x3000+index*0x300;scalar(ptr,props);put(address+0x28,'I',ptr);put(address+0x30,'II',((spatial_mask&1)<<20)|((spatial_mask&2)<<20),((pose_mask&1)<<5)|((pose_mask&2)<<5))
  if att_mode!=0:
   desc=heap+0x7000+index*0x100;put(desc+8,'I',1234);put(address+0x44,'I',desc)
  for parameter in [20,21,37,38]:
   binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=((address+parameter)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,parameter,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+parameter,100,ps,2,0);begin=parameter*0.125+index*2.;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4);binding_index+=1
  configs.append({'reference':address,'flags2f':flags,'props':props,'rtpc_mask':spatial_mask,'pose_mask':pose_mask,'attenuation':None if att_mode==0 else 1234})
 u.mem_write(out,bytes([0xa5])*16);u.mem_write(pose,bytes([0xa5])*60);put(pose+0x14,'fff',9.25,11.5,0.25);initial_pose=bytes(u.mem_read(pose,60)).hex();calls.clear();sp=stack+0x8000;put(sp,'IIII',trap,owner,out,pose);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xaf3060,trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap and read(att+0xc,'I')[0]==3
 rows.append({'owner':owner,'nodes':configs,'att_mode':att_mode,'endpoint':endpoint,'initial_pose':initial_pose,'output':bytes(u.mem_read(out,16)).hex(),'output_pose':bytes(u.mem_read(pose,60)).hex(),'calls':list(calls)})
proof={'complete':False,'passed':True,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'percent_bits':read(0x1138a58,'I')[0],'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Original AF3060/AFECA0/AFEE20/AF19E0/AF9530 and actual manager/curves execute unchanged.','Only OS critical-section enter/leave and resource release callback are explicit adapters; original AF9530 increments the resource counter, adapter decrements it and verifies balance. Resource release/destruction body is not qualified.','Constructed native-layout spatial/pose nodes, resource hash registry and attenuation records, including absent descriptors/resources/curve index/points. No spatial/pose/attenuation result adapter.'],'limits':['Bank/runtime initialization, synchronization and actual resource release/destruction remain separate.','Spatial selected-node controls and attenuation last-point field are raw native data, not inferred final device gain/pitch.','Normal audio output/lifecycle and full match remain open.']}
(r/'data/4.20/audio_spatial_pose_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native spatial+pose+attenuation manager cases')
