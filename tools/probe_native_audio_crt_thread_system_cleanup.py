from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
storage=vector+0x8000
regions=[('table',0x1223580,36*8),('slot',0x12230cc,4),('dispatch',0x2da5304,4),('cookie',0x1222ed0,4),('storage',storage,36*24)]
calls=[];freed=[]
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
w(0xfa436c,vector+0x28000);w(0xfa41bc,vector+0x28010)
def emit(kind,args,result,extra=None):
 v={'kind':kind,'arguments':args,'result':result,'at_call':snapshot()}
 if extra:v.update(extra)
 calls.append(v)
def hook(uc,a,z,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a in [vector+0x28000,vector+0x28020]:emit('TlsFree'if a==vector+0x28000 else'FlsFree',[read(sp+4)],1);finish(1,4);return
 if a==vector+0x28010:
  ref=read(sp+4);emit('DeleteCriticalSection',[ref],0,{'supplied_storage_bytes':'dd'*24});u.mem_write(ref,bytes([0xdd])*24);finish(0,4);return
 if a==0xc98528:ref=read(sp+4);emit('free',[ref],0);freed.append(ref);finish(0);return
 assert 0xca9341<=a<0xca935e or 0xcb027b<=a<0xcb02cf or 0xcabca3<=a<0xcabcc2,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for layout,extended,cookie,index in itertools.product(['null','static','dynamic','mixed','non_one','holes'],[False,True],[0,0x11223344,0xffffffff],[5,0xffffffff]):
 u.mem_write(storage,bytes([0x5a])*36*24);w(0x12230cc,index);w(0x1222ed0,cookie);w(0x2da5304,cookie^(vector+0x28020 if extended else 0))
 for j in range(36):
  ref=0 if layout=='null'or(layout=='holes'and j%3==0)else storage+j*24
  flag=1 if layout=='static'else 0 if layout in ['null','dynamic']else [0,1,2][j%3] if layout in ['mixed','holes']else 2
  w(0x1223580+j*8,ref);w(0x1223580+j*8+4,flag)
 calls.clear();freed.clear();before=snapshot();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca9341,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'layout':layout,'extended':extended,'cookie':cookie,'index':index,'before':before,'after':snapshot(),'calls':list(calls),'freed':list(freed),'terminal':True})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xca9341','regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual CA9341/CABCA3/CB027B execute. Exact flag1 static locks remain published; every other nonNULL lock deleted and CRT-freed before static deletion pass. NULL slots skipped; fallback/extended cookie decoding and TLS index5/MAX cleanup captured.','Opaque critical section DD bytes and free result supplied; slot data explicitly NULL, so no fake FLS callback/destructor execution. Freed memory retained only for passive canonical snapshots; no alias/double-free or callbacks mutating table scenario claimed. Rust comparison pending.']}
(r/'data/4.20/audio_crt_thread_system_cleanup_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_thread_system_cleanup.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'original static/dynamic two-pass lock and TLS/FLS cleanup cases')
