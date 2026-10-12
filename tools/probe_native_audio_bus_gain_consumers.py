from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_audio_bus_gain_aggregation.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(heap+0x10000,0x10000)
manager=heap+0x18000;record=heap+0x19800;bindings=heap+0x1a000;curves=heap+0x1a400;points=heap+0x1b000
regions +=[(0xafef40,0xaff090),(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4),(0xb03d40,0xb03e21),(0xb04bc0,0xb04c36)]
def coupled_guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xafef40:
  _,mask=read(sp+4,'II');calls.append({'kind':'state','node':u.reg_read(UC_X86_REG_ECX),'mask':mask})
 if a==0xb11040:
  sub,param,owner=read(sp+4,'III');calls.append({'kind':'rtpc','node':sub,'parameter':param,'owner':owner})
 if a in [0xb0ec10,0xb0ebb0]:
  calls.append({'kind':'root_gain' if a==0xb0ec10 else 'bus_gain','args':list(read(sp+4,'II'))});ret(0,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,coupled_guard)
def scalar(address,props,stride=4):
 keys=list(props);header=(len(keys)+4)&~3;raw=bytearray(header+len(keys)*stride);raw[:len(keys)+1]=bytes([len(keys),*keys])
 for i,key in enumerate(keys):struct.pack_into('<f',raw,header+i*stride,props[key])
 u.mem_write(address,bytes(raw));return bytes(raw).hex()
rows=[]
for prop,traverse,depth,parent_stage,state_profile,rtpc_profile,static_profile in itertools.product([0,4],[0,1],range(3),[False,True],range(3),range(3),range(4)):
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,20.);put(record+0xc,'III',record+0x80,2,2);put(record+0x80,'IfIf',0,25.,77,75.);put(0x14a7a3c,'I',manager)
 configurations=[];binding_index=0
 for i,node in enumerate(nodes):
  u.mem_write(node,bytes(200));put(node,'III',0xff1380,0,100+i);put(node+0x24,'I',nodes[i+1]if i<depth else 0);u.mem_write(node+0xc4,bytes([[0,0xa5,0xff][state_profile]]))
  cache=heap+0x4000+i*0x100;u.mem_write(cache,bytes(36));put(node+0x18,'I',cache);put(cache+4,'I',777 if parent_stage and i==1 else 0);put(node+0x64,'f',0.75)
  statics=[None,-31.,40.,1e20];static=statics[static_profile];static=static+i*.5 if static is not None else None;table=heap+0x5000+i*0x100
  rawtable=None
  if static is not None:rawtable=scalar(table,{prop:static});put(node+0x28,'I',table)
  source=heap+0x6000+i*0x100;ranges=heap+0x7000+i*0x100;u.mem_write(source,bytes(20));put(node+0x14,'I',source);minimum=-3.25-i*.25 if static_profile==3 else None;rawrange=None
  if minimum is not None:put(source+0xc,'I',ranges);rawrange=scalar(ranges,{prop:minimum},8)
  values=[5.5+i*.25,-2.+i*.25];entries=[]
  for j,v in enumerate(values):
   ptr=heap+0x8000+i*0x200+j*0x40;u.mem_write(ptr,bytes(24));put(ptr,'I',ptr+0x40 if j==0 else 0);put(ptr+0x14,'f',v);entries.append({'reference':ptr,'next':ptr+0x40 if j==0 else 0,'value':v})
  put(node+(0x84 if prop==0 else 0xa0),'I',entries[0]['reference'])
  states=[]
  if state_profile:
   u.mem_write(node+0x2e,b'\x80');put(node+0x10,'I',heap+0xa000+i*0x300)
   for j in range(state_profile):
    ptr=heap+0xa000+i*0x300+j*0x100;state_table=heap+0xb000+i*0x300+j*0x100;put(ptr+8,'I',ptr+0x100 if j+1<state_profile else 0);put(ptr+0x10,'I',state_table)
    rawstate=scalar(state_table,{0:2.+i-j*.25,4:-.75+i*.5+j*.125},8);states.append({'reference':ptr,'next':ptr+0x100 if j+1<state_profile else 0,'table':state_table,'raw':rawstate})
  routes=[]
  if rtpc_profile:
   put(node+0x30,'I',(1<<0)|(1<<4))
   for param in [0,4]:
    binding=bindings+binding_index*32;curve=curves+binding_index*20;ps=points+binding_index*32;bucket=(node+param)%193;previous=read(manager+0x614+bucket*4,'I')[0];put(binding,'IIIIIIII',node,param,previous,0,0,curve,1,1);put(manager+0x614+bucket*4,'I',binding);put(curve,'IIIII',1000+param,100,ps,2,0);begin=param*.125+i*2.;put(ps,'ffIffI',0.,begin,4,100.,begin+10.,4);routes.append({'parameter':param,'begin':begin});binding_index+=1
  configurations.append({'reference':node,'cache':cache,'cache_raw':bytes(u.mem_read(cache,36)).hex(),'table':table if static is not None else 0,'table_raw':rawtable,'source':source,'source_raw':bytes(u.mem_read(source,20)).hex(),'range':ranges if minimum is not None else 0,'range_raw':rawrange,'lists':entries,'states':states,'routes':routes})
 if rtpc_profile==1:put(record+0xc,'III',0,0,0)
 before=[bytes(u.mem_read(node,200)).hex()for node in nodes];calls.clear();u.emu_start(trap+0x200,trap+0x202);sp=stack+0x8000;put(sp,'III',trap+0x300,traverse,prop);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xb02ce0,trap+0x306,count=30000);assert u.reg_read(UC_X86_REG_EIP)==trap+0x306
 result=read(out,'I')[0];aggregate_calls=list(calls);calls.clear();u.emu_start(trap+0x200,trap+0x202);put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xb03d40,trap,count=60000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'property':prop,'traverse':traverse,'depth':depth,'parent_stage':parent_stage,'state_profile':state_profile,'rtpc_profile':rtpc_profile,'nodes':configurations,'before':before,'after':[bytes(u.mem_read(node,200)).hex()for node in nodes],'result_bits':result,'aggregate_calls':aggregate_calls,'changed_calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions if a<trap],'adapters':['Actual B02CE0/B03610, cached state AFEF40, manager B11040/B11320 and curves, changed B03D40/B04BC0 execute. Only root/identified gain application remains recorded interface.'],'limits':['Constructed acyclic Bus, state and manager resource layouts. Normal factory, state loading, RTPC binding/smoothing and physical gain/DSP remain incomplete.','Finite0/4 properties; no active children in changed hierarchy (separately qualified), nonfinite and other property indices remain outside scope.']}
(r/'data/4.20/audio_bus_gain_consumers_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Bus gain/state/RTPC/cache refresh cases')
