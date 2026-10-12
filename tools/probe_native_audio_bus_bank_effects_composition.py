"""Actual FF1380 virtual144 B044E0 bank loader orchestration and control list."""
from pathlib import Path
import json,itertools,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;parent=heap+0x2000;payload=heap+0x3000;blocks=[heap+0x5000+i*0x100 for i in range(4)];table=0xff1380
property_loader=read(table+0x11c,'I')[0];effects_loader=read(table+0x120,'I')[0];put(0x12100f4,'I',48000);calls=[];allocated=0;cfg={}
effect_cache=heap+0x8000;put(0x14a7d5c,'I',0);put(0x14a7cfc,'I',0)
regions=[(0xb04350,0xb043e6),(0xb00770,0xb007fb),(0xaffbd0,0xaffc5e),(0xafdde0,0xafde1a),(0x574170,0x574173),(0xb03740,0xb03779),(0xb0d140,0xb0d197),(0xb0d1a0,0xb0d1f4),(0xb044e0,0xb046e4),(0xb02430,0xb02490)]
def guard(uc,a,n,d):
 global allocated
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaf6480:
  ident,selector=read(sp+4,'II');calls.append({'kind':'lookup','id':ident,'selector':selector});ret(parent if cfg['found'] else 0,8);return
 if a==read(table+4,'I')[0]:calls.append({'kind':'retain','node':u.reg_read(UC_X86_REG_ECX)});ret(0,0);return
 if a==read(table+8,'I')[0]:calls.append({'kind':'release','node':u.reg_read(UC_X86_REG_ECX)});ret(0,0);return
 if a==read(table+0x24,'I')[0]:calls.append({'kind':'attach','parent':u.reg_read(UC_X86_REG_ECX),'child':read(sp+4,'I')[0]});ret(cfg['attach'],4);return
 stage={property_loader:'properties',effects_loader:'effects',0xb008b0:'rtpc',0xb000c0:'states',0xb00010:'position'}.get(a)
 if stage:
  ptr,remaining=read(sp+4,'II');calls.append({'kind':stage,'offset':read(ptr,'I')[0]-payload,'remaining':read(remaining,'I')[0]})
  if stage!='effects':ret(2 if cfg['failure_stage']==stage else 1,8);return
 if a==0xada670:
  pool,size=read(sp+4,'II')
  if size==36:calls.append({'kind':'allocate_effects','size':size});ret(0 if cfg['effect_failure'] else effect_cache,0);return
  assert size==0x1c;calls.append({'kind':'allocate','size':size});value=0 if cfg['allocation_failure'] else blocks[allocated];allocated+=1;ret(value,0);return
 if a==0xb03d40:calls.append({'kind':'changed'});ret(0,0);return
 if a==0xb04b80:calls.append({'kind':'slot','index':read(sp+4,'I')[0]});ret(0,4);return
 if a==0xb041b0:calls.append({'kind':'mask','args':list(read(sp+4,'II'))});ret(0,8);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
layouts=[[],[(100,0x3f000000,7,2,3,4)],[(100,0x3f000000,7,2,3,4),(100,0x80000000,8,9,10,11)],[(100,0x3f000000,7,2,3,4),(200,0x3f800000,8,9,10,11)]]
effect_layouts=[[],[(0,0,0,170)],[(0,100,0,170)],[(3,1234,255,85)],[(0,100,1,170),(2,293,2,85)],[(0,100,1,170),(4,999,1,85),(1,200,1,51)]]
rows=[]
for parent_id,found,attach,primary,secondary,failure_stage,layout_index,allocation_failure,effect_layout,effect_failure,bypass in itertools.product([0],[True],[1],[0],[0],[None,'rtpc','states','position'],range(4),[False,True],range(6),[False,True],[0,1,31,255]):
 cfg={'effect_failure':effect_failure,'found':found,'attach':attach,'failure_stage':failure_stage,'allocation_failure':allocation_failure};allocated=0;calls.clear();u.mem_write(node,bytes(0xc8));put(node,'I',table);put(node+8,'I',55);u.mem_write(node+0xc4,b'\xa5');put(node+0x78,'I',100);put(parent,'I',table);put(parent+8,'I',1234)
 u.mem_write(effect_cache,b'\xa5'*36)
 for address in blocks:u.mem_write(address,bytes(0x1c))
 put(0x14a7aac,'I',primary);put(0x14a7ab0,'I',secondary)
 raw=struct.pack('<IIII',55,parent_id,25,0x3f400000)+struct.pack('<I',len(layouts[layout_index]))
 for record in layouts[layout_index]:raw+=struct.pack('<IIIIBB',*record)
 items_fx=effect_layouts[effect_layout];raw+=bytes([len(items_fx)])+(bytes([bypass])+b''.join(struct.pack('<BIBB',*e) for e in items_fx) if items_fx else b'')
 u.mem_write(payload,raw);before=bytes(u.mem_read(node,0xc8)).hex();sp=stack+0x8000;put(sp,'III',trap,payload,len(raw));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(read(table+0x144,'I')[0],trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap
 items=[];cursor=read(node+0x68,'I')[0]
 while cursor:
  assert cursor in blocks and len(items)<4;items.append({'reference':cursor,'words':read(cursor,'IIIIIII')});cursor=read(cursor,'I')[0]
 rows.append({'effect_layout':effect_layout,'effect_failure':effect_failure,'bypass':bypass,'after_cache':bytes(u.mem_read(effect_cache,36)).hex() if read(node+0x18,'I')[0] else None,'parent_id':parent_id,'found':found,'attach_result':attach,'primary':primary,'secondary':secondary,'failure_stage':failure_stage,'layout':layout_index,'allocation_failure':allocation_failure,'payload':raw.hex(),'before':before,'after':bytes(u.mem_read(node,0xc8)).hex(),'result':u.reg_read(UC_X86_REG_EAX),'primary_after':read(0x14a7aac,'I')[0],'secondary_after':read(0x14a7ab0,'I')[0],'items':items,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Actual FF1380 virtual144 B044E0 executes parent lookup/attach ordering, root selection, raw control-list reading and stage short circuits unchanged. Actual B02430 list allocation/linking, existing-key mutation and count updates execute unchanged; heap allocator is an explicit result interface.','Parent lookup/retain/attach/release and property/RTPC/state/position loaders and virtualCC/84/DC callbacks are mandatory interfaces; actual B04350/B00770/AFFBD0/AFDDE0 effects reader/cache/mask bodies execute. Other stages that consume zero bytes. Payload is an orchestration fixture, not a complete native bank payload.'],'limits':['Preparatory evidence: dependency loader bodies and parent callbacks remain separately required; no complete bank format/runtime acceptance.','Sample rate48000 is an explicit global input; other rates, capacities/pool paths and resource lifetime require qualification.','No normal audio device/runtime acceptance.']}
(r/'data/4.20/audio_bus_bank_effects_composition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Bus bank and effects reader/cache cases')
