from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
obj=heap+0x1000;param=heap+0x2000;value=heap+0x3000;allocator=heap+0x4000;vtable=heap+0x4100;manager=heap+0x5000;previous=heap+0x6000;fmt=heap+0x7000
put(allocator,'I',vtable);put(vtable+8,'I',trap+0x500)
regions=[(0xb3e100,0xb3e1a5),(0xb3e1d0,0xb3e1f2),(0xb3e080,0xb3e0a3),(0xb3e2e0,0xb3e34f),(0xb3e350,0xb3e383),(0xb3e390,0xb3e3dc),(0xb3f280,0xb3f2a2),(0xb3eb60,0xb3ebba)]
calls=[];allocation_failure=False
# Known x87 settings for raw finite/infinite loads; signaling NaNs remain unqualified.
finit=trap+0x600;u.mem_write(finit,b'\xdb\xe3\xc3')
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==trap+0x500:calls.append({'kind':'free','allocator':u.reg_read(UC_X86_REG_ECX),'object':read(sp+4,'I')[0]});ret(0,4);return
 if a==0xada670:calls.append({'kind':'allocate_manager','allocator':read(sp+4,'I')[0],'size':read(sp+8,'I')[0]});ret(0 if allocation_failure else manager,0);return
 if a==0xae9f60:calls.append({'kind':'register_callback','callback':read(sp+4,'I')[0]});ret(0,0);return
 if finit<=a<finit+3:return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(entry,args=(),this=obj):
 sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(finit,trap,count=10)
 put(sp,'I'*(len(args)+1),trap,*args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.emu_start(entry,trap,count=3000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
sets=[]
for id,bits,length in itertools.product([0,1,2,3,4,5,6,7,8,0x7fff,0xffff,0x10000,0xffff0002,0x8000],[0,0x80000000,0x3f000000,0xc2400000,0x7f800000],[0,1,4,255]):
 u.mem_write(obj,b'\xa5'*32);put(obj,'I',0xff36a4);put(value,'I',bits);before=bytes(u.mem_read(obj,32)).hex();status=invoke(0xb3e100,[id,value,length]);sets.append({'id':id,'bits':bits,'length':length,'before':before,'after':bytes(u.mem_read(obj,32)).hex(),'result':status})
resets=[]
for pattern,bits in itertools.product([0,0xa5,0xff],[0,0x80000000,0x3f000000,0xc2400000,0x7f800000]):
 u.mem_write(obj,bytes([pattern])*84);put(obj,'I',0xff36d4);put(obj+8,'I',param);put(param+12,'I',bits);before=bytes(u.mem_read(obj,84)).hex();status=invoke(0xb3e390);resets.append({'bits':bits,'before':before,'after':bytes(u.mem_read(obj,84)).hex(),'result':status})
terms=[]
for kind,pattern,deferred in itertools.product(['effect','parameter'],[0,0xa5,0xff],[False,True]):
 size=84 if kind=='effect'else 32;u.mem_write(obj,bytes([pattern])*size);put(obj,'I',0xff36d4 if kind=='effect'else 0xff36a4)
 if kind=='effect':put(obj+20,'I',manager if deferred else 0)
 before=bytes(u.mem_read(obj,size)).hex();calls.clear();status=invoke(0xb3e350 if kind=='effect'else 0xb3e080,[allocator]);terms.append({'kind':kind,'deferred':deferred,'before':before,'after':bytes(u.mem_read(obj,size)).hex(),'result':status,'calls':list(calls)})
inits=[]
for pattern,profile in itertools.product([0,0xa5,0xff],['absent','allocation_failure','empty','tail']):
 allocation_failure=profile=='allocation_failure';u.mem_write(obj,bytes([pattern])*84);put(obj,'I',0xff36d4);u.mem_write(manager,bytes([pattern])*16);u.mem_write(previous,bytes([pattern])*84);put(0x14a83c4,'I',manager if profile in ['empty','tail']else 0)
 if profile in ['empty','tail']:put(manager,'IIII',allocator,7,previous if profile=='tail'else 0,previous if profile=='tail'else 0)
 put(param+12,'I',0xc2400000);put(param+28,'I',0xdeadbeef);put(fmt,'II',48000,0x12345678);before=bytes(u.mem_read(obj,84)).hex();manager_before=bytes(u.mem_read(manager,16)).hex();previous_before=bytes(u.mem_read(previous,84)).hex();calls.clear();status=invoke(0xb3e2e0,[allocator,0x30009900,param,fmt]);inits.append({'pattern':pattern,'profile':profile,'before':before,'after':bytes(u.mem_read(obj,84)).hex(),'manager_before':manager_before,'manager_after':bytes(u.mem_read(manager,16)).hex(),'previous_before':previous_before,'previous_after':bytes(u.mem_read(previous,84)).hex(),'global_manager':read(0x14a83c4,'I')[0],'result':status,'calls':list(calls)})
proof={'passed':True,'complete':False,'set_cases':sets,'reset_cases':resets,'term_cases':terms,'init_cases':inits,'counts':{'set':len(sets),'reset':len(resets),'term':len(terms),'init':len(inits)},'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual SetParam/Reset/Term/Init and singleton manager creation/linked-list insertion execute; allocator/free and global callback registration supply explicit boundaries.'],'findings':['SetParam sign extends low16bits;3 is invalid;32767 copies final u32;float indices0/1/4/5/6 load/storef32,2 copiesu32;declared length ignored.','Meter effect termination with manager sets byte50 and defers release; otherwise destructor rewrites class then allocator free. Parameter termination always rewrites class then allocator free.','Init acquires or allocates singleton16-byte manager and enqueues effect in intrusive list; manager allocation failure returns2 after partial field writes. Reset copies parameterwordC to10 channel words and resetsword1C.'],'limits':['Floating SetParam/Reset references cover finite, signed-zero and positive infinity only; signaling/quiet NaN and altered x87 modes not qualified.','Deferred manager update/delivery and Process, physical allocation/free, callback registration ownership and actual RTPC production remain incomplete.','Preparatory evidence, no Rust lifecycle implementation or audible acceptance yet.']}
(r/'data/4.20/audio_meter_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',proof['counts'],'actual Meter lifecycle/parameter bodies')
