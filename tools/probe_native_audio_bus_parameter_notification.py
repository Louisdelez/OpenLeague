"""Original Bus parameter notification with native static/cache gates and dispatch selection."""
from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;cache=heap+0x2000;source=heap+0x3000;calls=[]
regions=[(0xb04a00,0xb04ad5),(0xb02f20,0xb02fbe),(0xb02ec0,0xb02f1f),(0xb03740,0xb03779)]
def guard(uc,a,n,d):
 if a in [0xb0d1a0,0xb0d140]:
  sp=u.reg_read(UC_X86_REG_ESP);args=read(sp+4,'II' if a==0xb0d1a0 else 'III');calls.append({'kind':'root' if a==0xb0d1a0 else 'bus','args':list(args)});ret(0,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for parameter,kind,linked,cache_present,source_present,cached_flags,source_flags,nonempty in itertools.product([0,23,24,25,26,27,28,29,0xffffffff],[0,0x80],[False,True],[False,True],[False,True],[0,1,15,31,0xa5,0xff],[0,1,15,31,0xa5,0xff],[False,True]):
 u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+8,'I',1234);put(node+0x14,'I',source if source_present else 0);put(node+0x18,'I',cache if cache_present else 0);put(node+0x24,'I',heap+0x4000 if linked else 0);u.mem_write(node+0xc4,bytes([kind|0x25]));u.mem_write(cache,bytes(0x24));u.mem_write(cache+0x20,bytes([cached_flags]));u.mem_write(source,bytes(0x14));u.mem_write(source+0x10,bytes([source_flags]));
 for i in range(4):put(cache+i*8+4,'I',1 if nonempty else 0)
 before=bytes(u.mem_read(node,200)).hex();calls.clear();sp=stack+0x8000;put(sp,'II',trap,parameter);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb04a00,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'parameter':parameter,'kind':kind,'linked':linked,'cache_present':cache_present,'source_present':source_present,'cached_flags':cached_flags,'source_flags':source_flags,'nonempty':nonempty,'before':before,'after':bytes(u.mem_read(node,200)).hex(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual B04A00, B02F20/B02EC0 static/cache flags and virtual6C B03740 dispatch execute unchanged. Only root and identified-bus control-application interfaces B0D1A0/B0D140 recorded; their bodies do not execute.'],'limits':['Preparatory reference; Rust notification consumer not yet ported.','RTPC mask30/34 absent: enabled live RTPC manager evaluation and physical application remain unqualified.','No lifecycle, complete normal resource graph or audible output proof.']}
(r/'data/4.20/audio_bus_parameter_notification_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus parameter gate and root/identified dispatch cases')
