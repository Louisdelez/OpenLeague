from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;targets=[heap+0x2000,heap+0x3000,heap+0x4000];array=heap+0x6000;roots=heap+0x7000;table=heap+0x8000;calls=[]
regions=[(0xb0ec10,0xb0ecdf),(0xb0ebb0,0xb0ec09),(0xb088b0,0xb08980),(0xb27310,0xb27369),(0xb26fb0,0xb2701b),(0xb27cd0,0xb27cdd),(0xafeca0,0xafee20),(trap+0x200,trap+0x202)]
u.mem_write(trap+0x200,b'\xdb\xe3')
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xb088b0:calls.append({'kind':'gain','voice':u.reg_read(UC_X86_REG_ECX),'bits':read(sp+4,'I')[0]})
 if a==0xafeca0:calls.append({'kind':'spatial','node':u.reg_read(UC_X86_REG_ECX),'owner':read(sp+4,'I')[0]})
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[];modes=[[0,0,0],[1,0xffffffff,0],[2,0,2],[2,2,2]]
for path,first_free,profile,gain,spatial in itertools.product([('root',0),('root',1),('root',2),('root',256),('bus',0),('bus',1234),('bus',777)],range(4),range(4),[-800.,-740.,-60.,0.,24.,48.],[False,True]):
 u.mem_write(node,bytes(200));put(node,'III',0xff1380,0,1234);u.mem_write(node+0x2f,bytes([4 if spatial else 0]));put(node+0x28,'I',table);u.mem_write(table,bytes([3,11,12,13]));put(table+4,'fff',-.75,12.5,7.25)
 put(0x14a7d58,'II',array,3);put(0x14a7cf8,'II',roots,3);u.mem_write(roots,bytes(3*0x38));put(0x14a7970,'II',0xffffffff,0)
 for i,target in enumerate(targets):
  u.mem_write(target,b'\xa5'*0x500);put(target+0x4d0,'II',node if i<2 else 0,modes[profile][i]);put(array+i*4,'I',target);put(roots+i*0x38,'I',target);put(roots+i*0x38+0x10,'II',0 if i==first_free else i+1,0)
 before=[bytes(u.mem_read(t,0x500)).hex()for t in targets];calls.clear();u.emu_start(trap+0x200,trap+0x202);sp=stack+0x8000;put(sp,'IIf',trap,path[1],gain);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xb0ec10 if path[0]=='root' else 0xb0ebb0,trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'path':path[0],'selector':path[1],'first_free':first_free,'modes':modes[profile],'gain':gain,'spatial':spatial,'before':before,'after':[bytes(u.mem_read(t,0x500)).hex()for t in targets],'calls':list(calls),'lazy_gain_constant':read(0x14a7970,'II')})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions if a<trap],'constants':{hex(a):read(a,'I')[0]for a in [0x1138a98,0xff0100,0xff00f8,0xff00d8,0xff00c4,0xff00e8]},'adapters':['No gain or spatial result adapters. Actual root/identified dispatch, gain conversion, target update/defaults and static spatial getter execute. Constructed Bus/voice/root lists; null third binding.'],'findings':['Identified gain path includes mode2 voices (slot refresh excludes them).','Root selector uses its low byte: nonzero selects first zero-key descriptor, zero updates all nonzero-key descriptors.','Root gain resets spatial state with null Bus, identified gain reads its bound Bus spatial flag and getter.'],'limits':['Preparatory reference for actual Rust gain application, not device/mixer acceptance. Finite gains through48dB only.','Static spatial fields only; actual spatial RTPC and normal resource bindings/lifetimes remain separate.']}
(r/'data/4.20/audio_bus_gain_application_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual gain application and target spatial/default cases')
