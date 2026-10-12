"""Original verified FF1380 A8=B02A70 bus actor + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path(__file__).resolve().parents[1];__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000+i*0x100 for i in range(3)];out=heap+0x2000;extra=heap+0x2100;manager=heap+0x8000;record=heap+0x9800;bindings=heap+0xc400;curves=heap+0xa400;points=heap+0xb000
assert read(0xff1380+0xa8,'I')[0]==0xb02a70
regions=[(0xb02a70,0xb02cda),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)];calls=[]
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xb02a70:calls.append({'kind':'bus','node':nodes.index(u.reg_read(UC_X86_REG_ECX)),'mask':read(sp+8,'I')[0],'owner':read(sp+16,'I')[0],'first':read(sp+20,'I')[0],'last':read(sp+28,'I')[0]})
 if a==0xb11040:
  sub,param,owner=read(sp+4,'III');calls.append({'kind':'rtpc','node':nodes.index(sub),'parameter':param,'owner':owner})
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def scalar(address,props,stride=4):
 keys=list(props);header=(len(keys)+4)&~3;u.mem_write(address,bytes(0x80));u.mem_write(address,bytes([len(keys),*keys]));
 for i,key in enumerate(keys):
  if stride==4:put(address+header+i*stride,'f',props[key])
  else:put(address+header+i*stride,'ff',props[key],0.)
rows=[]
for depth,mask,first,owner,last,scope,enabled,profile in itertools.product([1,3],[0,1,2,4,8,16,0xffffffff,0xffffffef],[0,1],[0,77],[0,1],range(4),[False,True],range(3)):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager);configs=[];binding_index=0
 for i,address in enumerate(nodes[:depth]):
  u.mem_write(address,bytes(0x100));put(address,'I',0xff1380)
  if i+1<depth:put(address+0x24,'I',nodes[i+1])
  # Bus actor ignores actor-parent20 and object-child40, unlike sound actor.
  put(address+0x20,'I',address);put(address+0x40,'I',address)
  props={} if profile==0 else {0:-31.+i,2:(-0. if profile==1 else 3.25+i),3:5.5-i,4:7.25};prop_ptr=heap+0x3000+i*0x300;scalar(prop_ptr,props);put(address+0x28,'I',prop_ptr)
  global_props={0:91.,2:-3.5-i,3:2.+i,4:99.,10:1.} if scope&1 else {};state_ptr=heap+0x4000+i*0x300
  if global_props:put(address+0x14,'I',state_ptr);put(state_ptr+0xc,'I',state_ptr+0x80);scalar(state_ptr+0x80,global_props,8)
  cached=[{0:32.+i,2:-1.5-i,3:3.25+i,4:47.+i},{0:99.,2:0.5+i,3:1.25+i,4:-8.}] if scope&2 else []
  if cached:
   ptr=heap+0x5000+i*0x300;put(address+0x10,'I',ptr);put(address+0x2e,'B',0x80)
   for j,values in enumerate(cached):
    at=ptr+j*0x100;put(at+8,'I',at+0x100 if j==0 else 0);put(at+0x10,'I',at+0x20);scalar(at+0x20,values,8)
  if enabled:
   put(address+0x30,'II',(1<<2)|(1<<3),0)
   for param in [2,3]:
    binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=((address+param)&0xffffffff)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',address,param,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+param,100,ps,2,0);begin=param*0.125+i*2.;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4);binding_index+=1
  configs.append({'reference':address,'props':props,'global':global_props,'cached':cached,'rtpc':enabled})
 u.mem_write(out,bytes(84));put(out,'ff',13.,1.);put(out+8,'ff',17.,19.);put(out+0x14,'f',5.);put(extra,'fff',23.,29.,31.);calls.clear();sp=stack+0x8000;put(sp,'IIIIIIII',trap,out,mask,heap+0x2200,owner,first,extra,last);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xb02a70,trap,count=30000);assert u.reg_read(UC_X86_REG_EIP)==trap and u.reg_read(UC_X86_REG_EAX)==1
 rows.append({'mask':mask,'first':first,'owner':owner,'last':last,'nodes':configs,'output_block':bytes(u.mem_read(out,84)).hex(),'output_extras_bits':read(extra,'III'),'calls':calls.copy()})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'bus_vtable':'0xff1380','entry':'0xb02a70','regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Original verified bus A8=B02A70 and cached-state/RTPC manager/curves execute unchanged. No bus parameter or consumer result adapters.','Constructed linked bus24 chain, cached/global/static stores and explicit manager snapshots. Global state10 absent or1 so gain-entry mutation is not executed. Self references in unused bus20/40 prove this actor traverses24 only.'],'limits':['Non-unit state10 gain entries, actor-to-bus composition, runtime bank initialization/allocation/lifecycle and full bank parser remain open. No audible device output acceptance.']}
(r/'data/4.20/audio_bus_controls_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual FF1380 bus actor/static/cache/global/RTPC/recursion cases')
