"""Original Bus parameter notification with native static/cache gates and dispatch selection."""
from pathlib import Path
import itertools,json,hashlib,struct
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;cache=heap+0x2000;source=heap+0x3000;calls=[];manager=heap+0xd000;binding=heap+0xa000;collision=heap+0xa100;curve_array=heap+0xb000;record=heap+0x9000;curve_ids={}
put(0x14a7a3c,'I',manager);u.mem_write(trap+0x100,b'\xdb\xe3')
regions=[(0xb11040,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4),(trap+0x100,trap+0x102),(0xb04a00,0xb04ad5),(0xb02f20,0xb02fbe),(0xb02ec0,0xb02f1f),(0xb03740,0xb03779)]
def guard(uc,a,n,d):
 if a in [0xb0d1a0,0xb0d140]:
  sp=u.reg_read(UC_X86_REG_ESP);args=read(sp+4,'II' if a==0xb0d1a0 else 'III');calls.append({'kind':'root' if a==0xb0d1a0 else 'bus','args':list(args)});ret(0,0);return
 if a==0xb11040:
  subscriber,parameter,owner=read(u.reg_read(UC_X86_REG_ESP)+4,'III');calls.append({'kind':'rtpc','subscriber':subscriber,'parameter':parameter,'owner':owner})
 if a==0xadecf0:calls.append({'kind':'curve','index':curve_ids[u.reg_read(UC_X86_REG_ECX)],'input_bits':read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0]})
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
profiles=[None,[],[0.],[-1.],[-1.,1.],[-5.]]
for parameter,kind,linked,cache_present,source_present,flags,nonempty,enabled,profile in itertools.product(range(24,29),[0,0x80],[False,True],[False,True],[False,True],[(0,0),(15,31),(0xa5,0xff)],[False,True],[False,True],range(6)):
 cached_flags,source_flags=flags
 u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+8,'I',1234);put(node+0x14,'I',source if source_present else 0);put(node+0x18,'I',cache if cache_present else 0);put(node+0x24,'I',heap+0x4000 if linked else 0);u.mem_write(node+0xc4,bytes([kind|0x25]));u.mem_write(cache,bytes(0x24));u.mem_write(cache+0x20,bytes([cached_flags]));u.mem_write(source,bytes(0x14));u.mem_write(source+0x10,bytes([source_flags]));
 for i in range(4):put(cache+i*8+4,'I',1 if nonempty else 0)
 if enabled:put(node+0x30,'I',1<<parameter)
 u.mem_write(manager,bytes(0x1800));u.mem_write(binding,bytes(0x200));u.mem_write(curve_array,bytes(0x100));curve_ids.clear();curves=[]
 found=profiles[profile] is not None;bucket=((node+parameter)&0xffffffff)%193
 put(collision,'III',node+193,parameter,binding if found else 0);put(binding,'III',node,parameter,0);put(manager+0x614+bucket*4,'I',collision)
 for index,value in enumerate(profiles[profile] or []):
  point=heap+0xc000+index*0x100;entry=curve_array+index*20;end=value+10. if profile==5 else value;put(point,'ffIffI',0.,value,4,100.,end,4);put(entry,'IIIII',0,100,point,2,0);curve_ids[entry+8]=index;curves.append({'rtpc':100,'scaling':0,'points':[{'from':0.,'to':value,'interp':4},{'from':100.,'to':end,'interp':4}]})
 put(binding+0x14,'II',curve_array,len(curves));u.mem_write(record,bytes(0x100));put(record,'IIf',100,0,20.);put(manager+(100%193)*4,'I',record);put(record+0xc,'III',record+0x80,1,1);put(record+0x80,'If',0,75.)
 records=[{'rtpc':100,'default':20.,'overrides':[{'owner':0,'value':75.}]}]
 before=bytes(u.mem_read(node,200)).hex();calls.clear();u.emu_start(trap+0x100,trap+0x102);sp=stack+0x8000;put(sp,'II',trap,parameter);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb04a00,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'enabled':enabled,'profile':profile,'found':found,'curves':curves,'records':records,'parameter':parameter,'kind':kind,'linked':linked,'cache_present':cache_present,'source_present':source_present,'cached_flags':cached_flags,'source_flags':source_flags,'nonempty':nonempty,'before':before,'after':bytes(u.mem_read(node,200)).hex(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions if a<trap],'adapters':['Actual B04A00, B02F20/B02EC0 static/cache flags and virtual6C B03740 dispatch execute unchanged. Actual B11040/B110A0 manager lookup, owner fallback and curve accumulation execute; only root and identified-bus control-application interfaces B0D1A0/B0D140 recorded; their bodies do not execute.'],'limits':['Preparatory reference; Rust notification consumer not yet ported.','Constructed finite scaling0/linear4 curves and records; bank binding creation/smoothing, physical application and normal ownership remain open.','No lifecycle, complete normal resource graph or audible output proof.']}
(r/'data/4.20/audio_bus_parameter_notification_rtpc_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus notification plus actual RTPC manager cases')
