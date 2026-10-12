from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
table=0x1223580;storage=0x14ae988;regions=[('lock_table',table,36*8),('static_lock_storage',storage,36*24),('encoded_dispatch',0x2da5310,4),('cookie',0x1222ed0,4)];original_flags=[read(table+j*8+4)for j in range(36)];calls=[];api_result=1
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
w(0xfa4270,vector+0x28000)
def hook(uc,a,z,user):
 if a in [vector+0x28000,vector+0x28010]:
  sp=u.reg_read(UC_X86_REG_ESP);ref=read(sp+4);spin=read(sp+8);flags=read(sp+12)if a==vector+0x28010 else None;assert spin==4000;assert storage<=ref<storage+36*24
  calls.append({'kind':'InitializeCriticalSectionEx'if flags is not None else 'InitializeCriticalSectionAndSpinCount','reference':ref,'spin':spin,'flags':flags,'result':api_result,'at_call':snapshot(),'supplied_storage_bytes':'5a'*24});u.mem_write(ref,bytes([0x5a])*24);finish(api_result,12 if flags is not None else 8);return
 assert any(lo<=a<hi for lo,hi in [(0xcb0378,0xcb03b1),(0xcabd7a,0xcabda8)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,layout,initial_pointer,extended,api_result in itertools.product([0,165],['native','empty','all','alternating'],[0,0xa5a5a5a5],[False,True],[0,1]):
 u.mem_write(storage,bytes([pattern])*36*24);flags=original_flags if layout=='native'else [int(layout=='all'or(layout=='alternating'and j%2==0))for j in range(36)]
 for j,flag in enumerate(flags):w(table+j*8,initial_pointer);w(table+j*8+4,flag)
 w(0x2da5310,read(0x1222ed0)^(vector+0x28010 if extended else 0));calls.clear();before=snapshot();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xcb0378,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'layout':layout,'initial_pointer':initial_pointer,'extended':extended,'api_result':api_result,'before':before,'after':snapshot(),'calls':list(calls),'result':u.reg_read(UC_X86_REG_EAX)})
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual original CB0378 static-lock startup and CABD7A encoded extended/fallback wrapper execute.36 table entries scanned; only flag exactly1 publishes sequential24byte static storage and initializes with spin4000/flags0. Return1 ignores API result in original initializer.','Explicit Windows API boundaries return0/1 and write supplied opaque24byte5A storage for snapshot stress, not actual Windows critical-section object layout or initialization proof. Supplied encoded dispatch and global table flags; real resolver/global heap/physical runtime not proved. Rust replay pending.']}
(r/'data/4.20/audio_crt_static_lock_startup_dispatch_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_static_lock_startup_dispatch.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'native static-lock startup/encoded wrapper cases')
