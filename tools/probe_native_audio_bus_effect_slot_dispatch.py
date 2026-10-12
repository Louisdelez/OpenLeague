"""Original Bus virtual84 slot dispatch and native root/identified target filtering."""
from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;targets=[heap+0x2000,heap+0x3000,heap+0x4000];array=heap+0x6000;roots=heap+0x7000;calls=[]
regions=[(0xb04b80,0xb04bb3),(0xb0f960,0xb0f9b8),(0xb0f9c0,0xb0fa24),(0xb27cd0,0xb27cdd)]
def guard(uc,a,n,d):
 if a==0xb270b0:
  binding,index=read(u.reg_read(UC_X86_REG_ESP)+4,'II');calls.append({'voice':u.reg_read(UC_X86_REG_ECX),'binding':binding,'index':index});ret(0,8);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[];modes=[[0,0,0],[1,0xffffffff,0],[2,0,2],[2,2,2]]
for id,kind,linked,first_free,profile,index in itertools.product([0,1234,777],[0,0x80],[False,True],range(4),range(4),[0,1,3,4,0xffffffff]):
 u.mem_write(node,bytes(200));put(node,'III',0xff1380,0,id);put(node+0x24,'I',heap+0x5000 if linked else 0);u.mem_write(node+0xc4,bytes([kind|0x25]));put(0x14a7aac,'I',node);put(0x14a7d58,'II',array,3);put(0x14a7cf8,'II',roots,3);u.mem_write(roots,bytes(3*0x38))
 for i,target in enumerate(targets):
  u.mem_write(target,b'\xa5'*0x500);put(target+0x4d0,'II',node if i<2 else 0,modes[profile][i]);put(array+i*4,'I',target);put(roots+i*0x38,'I',target);put(roots+i*0x38+0x10,'II',0 if i==first_free else i+1,0)
 before=bytes(u.mem_read(node,200)).hex();before_targets=[bytes(u.mem_read(t,0x500))for t in targets];calls.clear();sp=stack+0x8000;put(sp,'II',trap,index);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb04b80,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 assert all(bytes(u.mem_read(t,0x500))==before for t,before in zip(targets,before_targets))
 rows.append({'id':id,'kind':kind,'linked':linked,'first_free':first_free,'modes':modes[profile],'index':index,'before':before,'after':bytes(u.mem_read(node,200)).hex(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual B04B80/B0F960/B0F9C0/B27CD0 select root or identified target in native order. Only B270B0 effect refresh consumer is recorded as a mandatory interface; its body does not execute.'],'findings':['Identified path skips matching target when raw mode4D4 equals2; root path does not apply that filter.','Root refresh passes address14A7AAC of the primary Bus binding; identified path passes address(target+4D0), not the Bus value itself.','Unchanged targets checked explicitly with the refresh consumer adapter.'],'limits':['Preparatory Rust dispatch evidence; actual B270B0 effect resource/DSP replacement and runtime ownership remain open.','Invalid slot semantics belong to the separately required consumer; dispatch merely forwards its raw index.']}
(r/'data/4.20/audio_bus_effect_slot_dispatch_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus effect slot target dispatch cases')
