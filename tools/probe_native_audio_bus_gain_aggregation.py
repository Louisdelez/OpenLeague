"""Original Bus B02CE0 gain aggregation, lists, source range and parent gate."""
from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
nodes=[heap+0x1000,heap+0x2000,heap+0x3000];out=heap+0xf000;rtpc_value=heap+0xf100;calls=[];state_profile=0
u.mem_write(trap+0x100,b'\xd9\x05'+struct.pack('<I',rtpc_value)+b'\xc2\x0c\x00');u.mem_write(trap+0x200,b'\xdb\xe3');u.mem_write(trap+0x300,b'\xd9\x1d'+struct.pack('<I',out))
regions=[(0xb02ce0,0xb02eba),(0xb03610,0xb03657),(0x574170,0x574173),(trap+0x100,trap+0x109),(trap+0x200,trap+0x202),(trap+0x300,trap+0x306)]
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xafef40:
  node=u.reg_read(UC_X86_REG_ECX);dest,mask=read(sp+4,'II');value=state_profile*4.+nodes.index(node)*0.25;offset=0 if mask==1 else 0x10;put(dest+offset,'f',value);calls.append({'kind':'state','node':node,'mask':mask,'bits':struct.unpack('<I',struct.pack('<f',value))[0]});ret(0,8);return
 if a==0xb11040:
  node,parameter,owner=read(sp+4,'III');calls.append({'kind':'rtpc','node':node,'parameter':parameter,'owner':owner});u.reg_write(UC_X86_REG_EIP,trap+0x100);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[];statics=[None,-31.,40.,1e20];lists=[[],[5.5,-2.],[-5.,-5.]]
for prop,traverse,depth,parent_stage,static_profile,list_profile,baseline,rtpc,state_profile in itertools.product([0,4],[0,1],range(3),[False,True],range(4),range(3),[0.,0.75],[None,0.375,-23.125],range(2)):
 inputs=[]
 for i,node in enumerate(nodes):
  u.mem_write(node,bytes(200));put(node,'III',0xff1380,0,100+i);put(node+0x24,'I',nodes[i+1] if i<depth else 0);cache=heap+0x4000+i*0x100;u.mem_write(cache,bytes(36));put(node+0x18,'I',cache);put(cache+4,'I',777 if parent_stage and i==1 else 0);put(node+0x64,'f',baseline)
  table=heap+0x5000+i*0x100;static=statics[static_profile];static=static+i*0.5 if static is not None else None
  if static is not None:u.mem_write(table,bytes([1,prop,0,0]));put(table+4,'f',static);put(node+0x28,'I',table)
  source=heap+0x6000+i*0x100;ranges=heap+0x7000+i*0x100;u.mem_write(source,bytes(20));put(node+0x14,'I',source);minimum=-3.25-i*0.25 if static_profile==3 else None
  if minimum is not None:put(source+0xc,'I',ranges);u.mem_write(ranges,bytes([1,prop,0,0]));put(ranges+4,'ff',minimum,777.)
  refs=[]
  for j,value in enumerate(lists[list_profile]):
   entry=heap+0x8000+i*0x200+j*0x40;refs.append(entry);u.mem_write(entry,bytes(24));put(entry+0x14,'f',value+i*0.25)
  for j,entry in enumerate(refs):put(entry,'I',refs[j+1] if j+1<len(refs) else 0)
  put(node+(0x84 if prop==0 else 0xa0),'I',refs[0] if refs else 0)
  if rtpc is not None:put(node+0x30,'I',1<<prop)
  inputs.append({'reference':node,'static':static,'minimum':minimum,'list_values':[value+i*0.25 for value in lists[list_profile]],'baseline':baseline,'parent':nodes[i+1] if i<depth else 0,'processing':bool(parent_stage and i==1) or i>=depth,'state':state_profile*4.+i*0.25})
 put(rtpc_value,'f',rtpc or 0.);calls.clear();u.emu_start(trap+0x200,trap+0x202);sp=stack+0x8000;put(sp,'III',trap+0x300,traverse,prop);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xb02ce0,trap+0x306,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap+0x306
 rows.append({'property':prop,'traverse':traverse,'depth':depth,'parent_stage':parent_stage,'rtpc':rtpc,'nodes':inputs,'result_bits':read(out,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions if a<trap],'adapters':['Actual B02CE0/B03610 gain aggregation/static lookup/source range-minimum/list sum/baseline comparison/parent recursion execute. AFEF40 state contribution and B11040 RTPC result are explicit mandatory interfaces, not executed here.'],'limits':['Preparatory Rust gain evaluator evidence; actual state/RTPC consumer composition and normal resource bindings remain required.','Finite values, acyclic linked lists and parent graph only; duplicate keys/nonfinite behavior and other property indices separately unqualified.','No gain application/DSP/device acceptance.']}
(r/'data/4.20/audio_bus_gain_aggregation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus gain aggregation and parent processing gate cases')
