from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
resource=heap+0x1000;registry=heap+0x2000;allocator=0x1210234;vt=heap+0x3000;old=heap+0x4000;payload=heap+0x7000;calls=[];allocations=[];next_pointer=heap+0x5000;profile='success';pattern=0
put(allocator,'I',vt);put(vt+4,'II',trap+0x500,trap+0x510)
regions=[(0xb253f0,0xb2548c),(0xb094b0,0xb09514),(0xb3df60,0xb3df7d),(0xb3e040,0xb3e07d),(0xb3e0b0,0xb3e0ff),(0xb3e080,0xb3e0a3),(0xb3e1d0,0xb3e1f2)]
def guard(uc,a,n,d):
 global next_pointer
 sp=u.reg_read(UC_X86_REG_ESP);owner=u.reg_read(UC_X86_REG_ECX)
 if a==trap+0x500:
  size=read(sp+4,'I')[0];ref=0 if profile=='failure'else next_pointer
  if ref:next_pointer+=0x100;u.mem_write(ref,bytes([pattern])*size);allocations.append({'reference':ref,'size':size,'freed':False})
  calls.append({'kind':'allocate','allocator':owner,'size':size,'reference':ref});ret(ref,4);return
 if a==trap+0x510:
  ref=read(sp+4,'I')[0];item=next(v for v in allocations if v['reference']==ref);assert not item['freed'];item['freed']=True;calls.append({'kind':'free','allocator':owner,'reference':ref});ret(0,4);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(id,length):
 sp=stack+0x8000;put(sp,'IIII',trap,id,payload,length);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,resource);u.emu_start(0xb253f0,trap,count=3000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
rows=[];blob=struct.pack('<fffffBI',.2,2.5,-60.,8.,.75,255,0xdeadbeef);u.mem_write(payload,blob)
for profile,existing,length,pattern in itertools.product(['success','missing','null_parameter','failure'],[False,True],[0,1,25,255],[0,0xa5,0xff]):
 calls.clear();allocations.clear();next_pointer=heap+0x5000;u.mem_write(resource,bytes([0xa5])*48);put(resource+16,'II',0x11223344,old if existing else 0);u.mem_write(old,bytes([pattern])*32);put(old,'I',0xff36a4)
 if existing:allocations.append({'reference':old,'size':32,'freed':False})
 put(registry,'III',0x810003,0xb3e260,0 if profile=='null_parameter'else 0xb3df60);put(0x14a7abc,'II',registry,0 if profile=='missing'else 1);before=bytes(u.mem_read(resource,48)).hex();stages=[]
 for id in [0x810003,0xdeadbeef]:
  result=invoke(id,length);stages.append({'id':id,'result':result,'resource':bytes(u.mem_read(resource,48)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
 rows.append({'profile':profile,'existing':existing,'length':length,'pattern':pattern,'payload':blob.hex(),'before':before,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'findings':['Actual resource parameter install B253F0 uses parameter factory B094B0 and fixed allocator1210234. Actual Meter Init and old Term/destructor execute.','Missing factory,null parameter creator and allocation failure return1 while preserving original resource plugin/parameter fields. Successful initialization frees old parameter before publishing new parameter and plugin ID.','Second missing plugin install preserves live first result and creates no allocation.'],'adapters':['Only physical virtual allocation/free boundaries;actual factory,parameter Init and destruction bodies execute.'],'limits':['Preparatory evidence,no Rust resource install port yet. Meter Init always1;other plugin Init failures require qualification.','Full HIRC8 payload reader/resource construction,subscription lifetime,normal bank scheduling and audible output remain open.']}
(r/'data/4.20/audio_effect_resource_parameter_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual resource parameter install/replacement/preservation cases')
