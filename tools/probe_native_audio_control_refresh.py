"""Original whole AEE790 orchestration/arithmetic; dependency values explicit."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
voice=heap+0x1000;node=heap+0x2000;table=heap+0x3000;entries=heap+0x4000;optional=heap+0x5000;optional_table=heap+0x5100;context=heap+0x6000;source_value=heap+0x7000
put(node,'I',table);put(table+0xe8,'I',trap+0x100);put(table+0xa8,'I',trap+0x200);put(optional,'I',optional_table);put(optional_table+0x30,'I',trap+0x300)
u.mem_write(trap+0x400,b'\xd9\x05'+struct.pack('<I',source_value)+b'\xc2\x04\x00')
calls=[];config={}
regions=[(0xaee790,0xaee995),(0xaee9a0,0xaee9f3),(0xaec310,0xaec3a0),(trap+0x400,trap+0x409)]
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaf3060:
  owner,ptr,pose=read(sp+4,'III');assert owner==77 and ptr==voice+0x160;calls.append({'kind':'spatial','owner':owner});put(ptr,'ff',1.25,2.5);ret(0,12);return
 if a==trap+0x300:calls.append({'kind':'optional'});ret(0,0);return
 if a==trap+0x100:calls.append({'kind':'flag','owner':read(sp+4,'I')[0]});ret(config['flag'],4);return
 if a==0xb1caf0:calls.append({'kind':'source'});u.reg_write(UC_X86_REG_EIP,trap+0x400);return
 if a==0xaef360:calls.append({'kind':'routing'});ret(0,0);return
 if a==trap+0x200:
  raw,mask,listptr,owner,first,extra,last=read(sp+4,'IIIIIII');assert raw==voice+0x78 and listptr==voice+0x18 and owner==77 and extra==voice+0x24 and last==1
  calls.append({'kind':'parameters','mask':mask,'first':first,'prefix_bits':read(raw,'I')[0],'entries_before':read(voice+0x1c,'I')[0]})
  put(raw,'f',read(raw,'f')[0]+config['controls'][0]);put(raw+8,'ff',*config['controls'][1:]);put(extra,'fff',*config['extras']);ret(0,28);return
 if a==0xaff450:
  ptr,owner=read(sp+4,'II');calls.append({'kind':'pair','owner':owner});put(ptr,'ff',*config['pair']);ret(0,8);return
 if a==0xaef2f0:calls.append({'kind':'transition','value_bits':read(sp+4,'I')[0]});ret(0,4);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
layouts=[[],[(1,2,0.25),(2,0,0.5)],[(1,0,0.1),(2,2,0.3),(3,2,0.7)],[(1,0,0.5),(2,0,0.8)]]
rows=[]
for cflag,eflag,pflag,optional_present,flag,layout,values,pair_kind in itertools.product([0,0x80,0xff],[0,0x80,0xc0],[0,1],[False,True],[0,1,255],range(4),range(2),range(3)):
 u.mem_write(voice,bytes(0x200));u.mem_write(voice+0x78,bytes([0xa5])*84);put(voice+0x60,'III',node,0xabcdef,77);put(voice+0x6c,'I',optional if optional_present else 0);u.mem_write(voice+0x12c,bytes([cflag,0x5a,eflag,0xa4]));u.mem_write(voice+0x130,bytes([pflag]));put(voice+0x18,'II',entries,len(layouts[layout]));u.mem_write(entries,bytes(0x100))
 for index,(id,bits,gain) in enumerate(layouts[layout]):put(entries+index*12,'IIf',id,bits,gain)
 controls=[-31.,40.,-7.] if values==0 else [3.375,-12.5,88.25];extras=[2.25,-3.,4.75] if values==0 else [-2.5,7.5,-40.];d4,d8,dc=[1.25,0.8,0.5] if values==0 else [-3.75,-2.,0.25]
 old_pair=[0.,3.25];pair=[0.,3.25] if pair_kind==0 else ([2.,3.25] if pair_kind==1 else [-0.,8.]);config={'flag':flag,'controls':controls,'extras':extras,'pair':pair};put(voice+0xd4,'fff',d4,d8,dc);put(voice+0x13c,'ff',*old_pair);put(voice+0x18c,'I',context);put(context+0x10,'f',6.5);put(source_value,'f',-13.125)
 calls.clear();sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0xaee790,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 count=read(voice+0x1c,'I')[0]
 rows.append({'cflag':cflag,'eflag':eflag,'pflag':pflag,'optional':optional_present,'flag':flag,'entries':[{'id':id,'flags':bits,'gain':gain} for id,bits,gain in layouts[layout]],'controls':controls,'extras':extras,'d4':d4,'d8':d8,'dc':dc,'pair':pair,'old_pair':old_pair,'source':-13.125,'context':6.5,'output_block':bytes(u.mem_read(voice+0x78,84)).hex(),'output_flags':list(u.mem_read(voice+0x12c,5)),'output_cc_d0':[read(voice+0xcc,'I')[0],read(voice+0xd0,'I')[0]],'output_pair_bits':read(voice+0x13c,'II'),'output_entries':[dict(zip(['id','flags','gain_bits'],read(entries+i*12,'III'))) for i in range(count)],'output_spatial_bits':read(voice+0x160,'II'),'range_limit_bits':read(voice+0x170,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions if a<trap],'adapters':['AF3060 spatial pair1.25/2.5, optional callback, node flag getter, B1CAF0 source float, AEF360 routing callback, virtualA8 parameter contributions and AFF450 pair are explicit dependency interfaces.','Whole original AEE790/AEC310/AEE9A0 reset/prune/ordered arithmetic/product/clamp/pair comparisons/final flags execute native instructions. AEF2F0 transition command captured.'],'limits':['Actual dependency getter/actor aggregation/spatial/routing/pair/transition producer bodies remain to qualify/connect; this does not prove their supplied fixture values are game-derived.','Only finite arithmetic inputs; class-specific callback failures and device output unqualified.','No normal audio runtime acceptance.']}
(r/'data/4.20/audio_control_refresh_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'whole native control refresh cases')
