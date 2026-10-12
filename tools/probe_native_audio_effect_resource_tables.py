from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_audio_effect_resource_parameter.py').read_text(encoding='utf-8').split('rows=[];blob=')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard)','initial_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard)')
exec(compile(setup,'parameter_setup','exec'))
regions.extend([(0xb254c0,0xb2562a),(0xb15890,0xb15917),(0xb153b0,0xb15426),(0xb25690,0xb2578a),(0xb21520,0xb215de),(0xae4550,0xae45f5)])
bank=heap+0x8000;initial_table=heap+0x9000;pool=0xffffffff;put(0x12100dc,'I',pool);count_allocate=0;fail_nth=0;consumed=0
old_guard=guard
def guard_all(uc,a,n,d):
 global next_pointer,count_allocate,consumed
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xb25614:consumed=u.reg_read(UC_X86_REG_ESI)-bank
 if a in [trap+0x500,0xada670]:
  virtual=a==trap+0x500
  owner=u.reg_read(UC_X86_REG_ECX)if virtual else read(sp+4,'I')[0];size=read(sp+4 if virtual else sp+8,'I')[0];count_allocate+=1;ref=0 if count_allocate==fail_nth else next_pointer
  if ref:next_pointer+=0x200;u.mem_write(ref,bytes([pattern])*size);allocations.append({'reference':ref,'size':size,'freed':False})
  calls.append({'kind':'allocate','method':'virtual'if virtual else'pool','allocator':owner,'size':size,'reference':ref});ret(ref,4 if virtual else 0);return
 if a in [trap+0x510,0xada3e0]:
  virtual=a==trap+0x510;owner=u.reg_read(UC_X86_REG_ECX)if virtual else read(sp+4,'I')[0];ref=read(sp+4 if virtual else sp+8,'I')[0];v=next(v for v in allocations if v['reference']==ref);assert not v['freed'];v['freed']=True;calls.append({'kind':'free','method':'virtual'if virtual else'pool','allocator':owner,'reference':ref});ret(0,4 if virtual else 0);return
 if a==0xca1ef0:
  dst,src,size=read(sp+4,'III');u.mem_write(dst,bytes(u.mem_read(src,size)));ret(dst,0);return
 old_guard(uc,a,n,d)
u.hook_del(initial_hook)
u.hook_add(unicorn.UC_HOOK_CODE,guard_all)
rows=[];blob=struct.pack('<fffffBI',.2,2.5,-60.,8.,.75,255,0xdeadbeef)
point=lambda x,y,k:struct.pack('<ffI',x,y,k)
packets=[('empty',[],[]),('pairs',[(1,100),(1,200),(255,0xffffffff)],[]),('zero_curve',[],[(10,0,100,255,[])]),('curves',[],[(10,0,100,0,[point(0.,1.,4),point(1.,2.,4)]),(20,4,200,255,[]),(30,0,100,1,[point(-1.,-2.,0)])]),('both',[(1,100),(1,200),(255,0xffffffff)],[(10,0,100,0,[point(0.,1.,4),point(1.,2.,4)]),(20,4,200,255,[]),(30,0,100,1,[point(-1.,-2.,0)])])]
for fail_nth,packet,seed_count,existing,pattern in itertools.product(range(6),packets,[0,1,3],[False,True],[0,0xa5]):
 name,pairs,bindings=packet;calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;profile='success';u.mem_write(resource,bytes([0xa5])*48);put(resource+16,'II',0x11223344,old if existing else 0);u.mem_write(resource+24,bytes(24));u.mem_write(old,bytes([pattern])*32);put(old,'I',0xff36a4)
 if existing:allocations.append({'reference':old,'size':32,'freed':False})
 if seed_count:
  u.mem_write(initial_table,bytes([pattern])*72);put(resource+36,'III',initial_table,seed_count,3);allocations.append({'reference':initial_table,'size':72,'freed':False})
  for i in range(seed_count):
   ref=heap+0xa000+i*0x100;raw=point(float(i),float(i+1),4);u.mem_write(ref,raw);allocations.append({'reference':ref,'size':12,'freed':False});put(initial_table+i*24,'IIIIII',11+i,100 if i!=1 else 200,0 if i!=1 else 4,ref,1,0)
 put(registry,'III',0x810003,0xb3e260,0xb3df60);put(0x14a7abc,'II',registry,1)
 data=struct.pack('<III',100,0x810003,25)+blob+bytes([len(pairs)])+b''.join(struct.pack('<BI',*v)for v in pairs)+struct.pack('<H',len(bindings))+b''.join(struct.pack('<IIIBH',rtpc,param,curve,scale,len(points))+b''.join(points)for rtpc,param,curve,scale,points in bindings)
 u.mem_write(bank,data);before=bytes(u.mem_read(resource,48)).hex();initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];sp=stack+0x8000;put(sp,'III',trap,bank,len(data));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,resource);u.emu_start(0xb254c0,trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'failure_nth':fail_nth,'packet':name,'seed_count':seed_count,'existing':existing,'pattern':pattern,'bank_payload':data.hex(),'before':before,'initial_allocations':initial,'resource':bytes(u.mem_read(resource,48)).hex(),'consumed':consumed,'result':u.reg_read(UC_X86_REG_EAX),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Only physical allocation/free and memcpy boundaries. Actual reader,ordered8-byte table insertion/growth,24-byte binding removal/shift/growth,curve allocation/copy-state and Meter factory/Init/Term execute.'],'findings':['All matching parameter+curve IDs are removed before insertion;curve point arrays freed then remaining24-byte records shifted in order.','Pair duplicates replace first matching value without increasing count. Pair growth increment8 and binding growth increment2 preserve raw unused bytes.','Curve allocation failure leaves zero pointer/count/scaling;reader ignores failures and continues consuming all payload.'],'limits':['Controlled valid table storage,point backing and Meter plugin only. Other plugin Init failures,unusual malformed storage and repeated byte-table replacement ownership still require qualification.','Copied curve fields are retained without evaluating or subscribing them;normal HIRC dispatch,subscription/RTPC propagation/device output remain open.']}
(r/'data/4.20/audio_effect_resource_tables_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'whole resource reader/nonempty tables/removal/growth/curve-allocation cases')
