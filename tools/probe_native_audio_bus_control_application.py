"""Original bus control target selection and actual B27280 five flag writes."""
from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
voices=[heap+0x1000,heap+0x2000,heap+0x3000];nodes=[heap+0x4000,heap+0x4100];array=heap+0x5000;roots=heap+0x6000;calls=[]
regions=[(0xb0d140,0xb0d197),(0xb0d1a0,0xb0d1f4),(0xb27280,0xb27302),(0xb27cd0,0xb27cdd)]
def guard(uc,a,n,d):
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
 if a==0xb27280:calls.append({'voice':u.reg_read(UC_X86_REG_ECX),'args':list(read(u.reg_read(UC_X86_REG_ESP)+4,'II'))})
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for operation,pattern,profile,mask,value in itertools.product(['root','bus'],[0,1,0xa5,0xff],range(4),[0,1,2,4,8,16,31,255,0xffffffff],[0,1,2,16,31,0xffffffff]):
 for i,voice in enumerate(voices):
  u.mem_write(voice,bytes([pattern])*0x500);put(voice+0x4d0,'I',nodes[i] if i<2 else 0)
 for node in nodes:put(node,'III',0xff1380,0,1234)
 put(0x14a7d58,'II',array,3)
 for i,voice in enumerate(voices):put(array+i*4,'I',voice)
 put(0x14a7cf8,'II',roots,3);u.mem_write(roots,bytes(3*0x38))
 for i,voice in enumerate(voices):put(roots+i*0x38,'I',voice);put(roots+i*0x38+0x10,'II',0 if i==profile else i+1,0)
 requested=[0,1234,2222,0xffffffff][profile];before=[bytes(u.mem_read(v,0x500)).hex() for v in voices];calls.clear();sp=stack+0x8000;put(sp,'I',trap);args=[value,mask] if operation=='root' else [requested,value,mask]
 for i,arg in enumerate(args):put(sp+4+i*4,'I',arg)
 u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xb0d1a0 if operation=='root' else 0xb0d140,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'operation':operation,'pattern':pattern,'profile':profile,'id':requested,'mask':mask,'value':value,'before':before,'after':[bytes(u.mem_read(v,0x500)).hex() for v in voices],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['No result/callback adapters: actual B0D1A0 root descriptor selection, B0D140 matching bus iteration, B27CD0 ID/null resolution and B27280 selected bit0 flag writes execute unchanged.','Explicit constructed three voices, root descriptors and bus bindings; duplicate matching Bus IDs and null Bus pointer included.'],'limits':['Preparatory reference; Rust physical-target consumer and whole notification composition not yet ported.','No normal voice admission/registration/lifecycle, signal processing or audible-output proof.']}
(r/'data/4.20/audio_bus_control_application_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Bus control target selection and voice flag update cases')
