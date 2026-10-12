"""Execute B124E0 creation/replacement, original vectors and notifications."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
manager=heap;node=heap+0x8000;vtable=heap+0x8100;bus=heap+0x8500;point=heap+0x7000
put(node,'I',vtable);put(node+0x30,'I',bus);put(vtable+4,'I',trap+0x100);put(vtable+0xcc,'I',trap+0x200)
bump=heap+0x9000;calls=[]
regions=[(0xb1eed0,0xb1ef4e),(0xb100f0,0xb14000),(0xae4550,0xae45f5),(0xaeed80,0xaeedb7),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4)]
def guard(uc,a,n,d):
 global bump
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool,size=read(sp+4,'II');address=bump;bump=(bump+size+15)&~15;assert bump<heap+0x10000;u.mem_write(address,bytes(size));ret(address,0);return
 if a==0xada3e0:ret(0,0);return
 if a==0xca1ef0:
  dst,src,size=read(sp+4,'III');u.mem_write(dst,bytes(u.mem_read(src,size)));ret(dst,0);return
 if a==trap+0x100:
  parameter,ptr,size=read(sp+4,'III');assert size==4;calls.append({'kind':'control','parameter':parameter,'value_bits':read(ptr,'I')[0]});ret(1,12);return
 if a==trap+0x200:calls.append({'kind':'invalidate'});ret(0,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(args):
 sp=stack+0x8000;put(sp,'I',trap)
 for index,value in enumerate(args):put(sp+4+index*4,'I',value)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb124e0,trap,count=100000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
def snapshot():
 bindings=[]
 for bucket in range(193):
  address=read(manager+0x614+bucket*4,'I')[0]
  while address:
   subscriber,parameter,next,owner,kind,ptr,count,cap=read(address,'IIIIIIII');assert subscriber==node
   curves=[]
   for i in range(count):
    curve_id,rtpc,ps,n,scaling=read(ptr+i*20,'IIIII');curves.append({'curve_id':curve_id,'rtpc':rtpc,'scaling':scaling,'points':[dict(zip(['from','to','interp'],read(ps+j*12,'ffI'))) for j in range(n)]})
   bindings.append({'parameter':parameter,'owner':owner,'class':kind,'curves':curves});address=next
 return bindings
patterns=[[(100,500,0.),(100,500,4.),(293,500,8.)],[(100,500,0.),(100,501,4.),(293,500,8.)],[(100,500,0.),(293,501,4.),(100,500,None)],[(100,500,0.),(100,500,None),(293,501,8.)]]
rows=[]
for parameter,kind,owner,pattern in itertools.product([4,13,29,30],[0,1,2,4],[0,77],range(4)):
 u.mem_write(manager,bytes(0x1800));u.mem_write(bus,bytes(0x80));bump=heap+0x9000
 for i,rtpc in enumerate([100,293]):
  record=heap+0x5000+i*0x400;items=record+0x80;refs=record+0x100;u.mem_write(record,bytes(0x400));existing=read(manager+(rtpc%193)*4,'I')[0];put(record,'IIf',rtpc,existing,20.+i*40.);put(manager+(rtpc%193)*4,'I',record);put(record+0xc,'III',items,2,2);put(items,'IfIf',0,25.+i*10.,77,75.+i*10.);put(record+0x1c,'III',refs,0,16)
 steps=[]
 # Include a second parameter to observe notify-all order and retained first metadata.
 sequence=[(100,parameter+1,900,2.),*[(rtpc,parameter,id,value) for rtpc,id,value in patterns[pattern]]]
 for index,(rtpc,param,id,value) in enumerate(sequence):
  size=2 if value is not None else 0
  if size:put(point,'ffIffI',0.,value,4,100.,value+10.,4)
  current_owner=owner if index<2 else (77 if owner==0 else 0);current_class=kind if index<2 else (4 if kind!=4 else 0)
  calls.clear();result=invoke([node,rtpc,param,id,0,point if size else 0,size,current_owner,current_class])
  steps.append({'rtpc':rtpc,'parameter':param,'curve_id':id,'scaling':0,'points':[] if not size else [{'from':0.,'to':value,'interp':4},{'from':100.,'to':value+10.,'interp':4}],'owner':current_owner,'class':current_class,'result':result,'bindings':snapshot(),'calls':list(calls),'bus_slot13_bits':read(bus+0xc,'I')[0],'bus_slot14_bits':read(bus+0x10,'I')[0]})
 rows.append({'parameter':parameter,'class':kind,'owner':owner,'pattern':pattern,'steps':steps})
proof={'passed':True,'complete':False,'case_count':len(rows),'step_count':sum(len(row['steps']) for row in rows),'subscriber':node,'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Allocator supplies zeroed bounded memory; free and memcpy explicit C ABI adapters.','Original B124E0/hash chains/vector growth/copy/curve replacement/ref-list mutation/B13540/B135C0 execute native code.','Class0 virtual control consumer and class1/2 invalidate captured. Class4 original AEED80 bus state update executes. RTPC record defaults and owner overrides are explicit verified-layout fixtures.'],'limits':['Allocator failure paths and absent global-record construction not exercised.','Class3 subscriber-specific path remains unqualified.','Native runtime smoothing/device voice aggregation still unconnected.']}
(r/'data/4.20/audio_rtpc_subscriptions_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'subscription sequences;',proof['step_count'],'native mutations')
