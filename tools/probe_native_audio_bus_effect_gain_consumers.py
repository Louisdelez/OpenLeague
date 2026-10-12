from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_audio_bus_effects_callbacks_composition.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(heap+0x10000,0x10000)
parent=heap+0xe000;static_table=heap+0xc000;parent_table=heap+0xc100;range_table=heap+0xc200;state=heap+0xc300;state_table=heap+0xc400;manager=heap+0x18000;record=heap+0x19800;bindings=heap+0x1a000;curves=heap+0x1a400;points=heap+0x1b000
regions +=[(0xb02ce0,0xb02eba),(0xb03610,0xb03657),(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4),(0xb0ec10,0xb0ecdf),(0xb0ebb0,0xb0ec09),(0xb088b0,0xb08980),(0xb27310,0xb27369),(0xb26fb0,0xb2701b),(0xafeca0,0xafee20)]
def actual_guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool,size=read(sp+4,'II');assert size==36;calls.append({'kind':'allocate','size':size});ret(0 if allocation_failure else allocated,0);return
 if a==0xb03d40:calls.append({'kind':'changed'})
 if a==0xb04b80:calls.append({'kind':'slot','index':read(sp+4,'I')[0]})
 if a==0xb041b0:calls.append({'kind':'mask','args':list(read(sp+4,'II'))})
 if a==0xafef40:calls.append({'kind':'state','node':u.reg_read(UC_X86_REG_ECX),'mask':read(sp+8,'I')[0]})
 if a==0xb11040:
  sub,param,owner=read(sp+4,'III');calls.append({'kind':'rtpc','node':sub,'parameter':param,'owner':owner})
 if a==0xb088b0:calls.append({'kind':'gain','voice':u.reg_read(UC_X86_REG_ECX),'bits':read(sp+4,'I')[0]})
 if a==0xafeca0:calls.append({'kind':'spatial','node':u.reg_read(UC_X86_REG_ECX),'owner':read(sp+4,'I')[0]})
 if a==0xb270b0:calls.append({'kind':'refresh_slot','voice':u.reg_read(UC_X86_REG_ECX),'binding':read(sp+4,'I')[0],'index':read(sp+8,'I')[0]});ret(0,8);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,actual_guard)
def scalar(address,props,stride=4):
 keys=list(props);header=(len(keys)+4)&~3;raw=bytearray(header+len(keys)*stride);raw[:len(keys)+1]=bytes([len(keys),*keys])
 for i,key in enumerate(keys):struct.pack_into('<f',raw,header+i*stride,props[key])
 u.mem_write(address,bytes(raw));return bytes(raw).hex()
layouts=[[],[(0,0,0,0xaa)],[(0,100,0,0xaa)],[(3,1234,255,0x55)],[(0,100,1,0xaa),(2,293,2,0x55)],[(0,100,1,0xaa),(4,999,1,0x55),(1,200,1,0x33)]];rows=[]
for mode,existing,layout_index,bypass,profile,allocation_failure in itertools.product(range(3),range(3),range(6),[0,31,255],range(2),[False,True]):
 u.mem_write(node,bytes(200));put(node,'III',0xff1380,0,1234);put(node+0x18,'I',cache if existing else 0);put(node+0x24,'I',parent if mode==2 else 0);u.mem_write(node+0xc4,bytes([0xa5 if mode==0 else 0x25]));put(node+0x28,'I',static_table);put(node+0x64,'f',.75);u.mem_write(node+0x2f,bytes([0x24 if profile else 0]));put(node+0x14,'I',source)
 u.mem_write(parent,bytes(200));put(parent,'III',0xff1380,0,777);put(parent+0x28,'I',parent_table)
 tables=[{'reference':static_table,'raw':scalar(static_table,{0:-12. if profile else 0.,4:24. if profile else 0.,11:-.75,12:12.5,13:7.25})},{'reference':parent_table,'raw':scalar(parent_table,{0:5.,4:1.})}]
 rawrange=scalar(range_table,{0:-.5,4:.25},8);u.mem_write(source,b'\xa5'*20);put(source+0xc,'I',range_table);u.mem_write(source+0x10,bytes([profile]));states=[]
 if profile:
  u.mem_write(node+0x2e,b'\x80');put(node+0x10,'I',state);put(state+8,'I',0);put(state+0x10,'I',state_table);states=[{'reference':state,'next':0,'table':state_table,'raw':scalar(state_table,{0:1.,4:-.25},8)}]
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,0.);put(0x14a7a3c,'I',manager);routes=[];index=0
 if profile:
  for i,bus in enumerate([node,parent]):
   put(bus+0x30,'I',(1<<0)|(1<<4))
   for param,value in [(0,2.+i),(4,1.+i)]:
    binding=bindings+index*32;curve=curves+index*20;ps=points+index*32;bucket=(bus+param)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',bus,param,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+param,100,ps,1,0);put(ps,'ffI',0.,value,4);routes.append({'node':bus,'parameter':param,'value':value});index+=1
 u.mem_write(cache,bytes(36));u.mem_write(allocated,b'\xa5'*36)
 if existing==2:
  for i in range(4):put(cache+i*8,'BB',0,1);put(cache+i*8+4,'I',[100,200,293,1234][i])
  u.mem_write(cache+0x20,b'\xa5')
 put(0x14a7aac,'I',node);put(0x14a7d58,'II',target_array,2);put(0x14a7cf8,'II',root_array,2);u.mem_write(root_array,bytes(2*0x38));put(0x14a7970,'II',0xffffffff,0)
 for i,target in enumerate(targets):
  u.mem_write(target,b'\xa5'*0x500);put(target+0x4d0,'II',node,2 if i==0 and existing==2 else 0);put(target_array+i*4,'I',target);put(root_array+i*0x38,'I',target);put(root_array+i*0x38+0x10,'II',i,0)
 before_source=bytes(u.mem_read(source,20)).hex();before_targets=[bytes(u.mem_read(t,0x500)).hex()for t in targets];items=layouts[layout_index];raw=bytes([len(items)])+(bytes([bypass])+b''.join(struct.pack('<BIBB',*e)for e in items)if items else b'');u.mem_write(payload,raw);put(holder,'II',payload,len(raw));before=[bytes(u.mem_read(b,200)).hex()for b in [node,parent]];before_cache=bytes(u.mem_read(cache,36)).hex()if existing else None;calls.clear();u.emu_start(trap+0x200,trap+0x202);sp=stack+0x8000;put(sp,'IIII',trap,holder,holder+4,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb04350,trap,count=60000);assert u.reg_read(UC_X86_REG_EIP)==trap
 pointer=read(node+0x18,'I')[0];rows.append({'mode':mode,'existing':existing,'layout':layout_index,'bypass':bypass,'profile':profile,'allocation_failure':allocation_failure,'before':before,'after':[bytes(u.mem_read(b,200)).hex()for b in [node,parent]],'tables':tables,'range_raw':rawrange,'states':states,'routes':routes,'before_source':before_source,'after_source':bytes(u.mem_read(source,20)).hex(),'before_targets':before_targets,'after_targets':[bytes(u.mem_read(t,0x500)).hex()for t in targets],'before_cache':before_cache,'after_cache':bytes(u.mem_read(pointer,36)).hex()if pointer else None,'payload':raw.hex(),'result':u.reg_read(UC_X86_REG_EAX),'consumed':read(holder,'I')[0]-payload,'remaining':read(holder+4,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions if a<trap],'adapters':['Actual complete effects reader/CC/84/DC callbacks, gain evaluator/cached states/RTPC manager/curves, gain application/spatial/default writes and flag application execute. Allocator returns controlled memory; only B270B0 effect-instance replacement is a mandatory recorded interface.'],'limits':['Constructed acyclic resources, root primary/secondary and one linked Bus, no active child groups. Normal factories/shared ownership and audible/mixing/device output remain incomplete.','Finite scaling0 RTPC; retained logarithmic scaling2, real effect resources/plugins and other bank readers remain required.']}
(r/'data/4.20/audio_bus_effect_gain_consumers_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'full effects reader with actual gain/state/RTPC/spatial/application consumers')
