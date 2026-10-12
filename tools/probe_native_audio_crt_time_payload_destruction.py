from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
time=vector+0x7000;payload=vector+0x18000;regions=[('time',time,0x164),('payloads',payload,89*32)];calls=[];freed=[]
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,z,user):
 if a==0xc98528:
  sp=u.reg_read(UC_X86_REG_ESP);ref=read(sp+4);calls.append({'kind':'free','reference':ref,'at_call':snapshot()});freed.append(ref);finish(0);return
 assert 0xcc8564<=a<0xcc88e4,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for layout in ['null_record','null_payloads','all','alternating']:
 u.mem_write(time,bytes(0x164));u.mem_write(payload,bytes([0xa5])*89*32)
 for j in range(89):
  off=j*4
  if off>=0x164:break
  if off in[0xac,0xb0]:continue
  if layout=='all'or(layout=='alternating'and j%2==0):w(time+off,payload+j*32)
 calls.clear();freed.clear();before=snapshot();w(stack,end);w(stack+4,0 if layout=='null_record'else time);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xcc8564,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'layout':layout,'reference':0 if layout=='null_record'else time,'before':before,'after':snapshot(),'calls':list(calls),'freed':list(freed),'terminal':True})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xcc8564','regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual CC8564 time payload destructor executes. NULL record, NULL/all/alternating distinct payload identities reveal all87 field reads in original order; fieldsAC/B0 deliberately excluded by native body. Canonical full time record and each distinct32byte payload retained; original allocator free boundary supplied. Rust comparison pending.','Normal time-locale producer, allocator implementation, concurrency, custom-locale/thread composition with these nonNULL time payloads remain open.']}
(r/'data/4.20/audio_crt_time_payload_destruction_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_time_payload_destruction.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured4 original time helper cases;87 ordered distinct/NULL payload frees')
