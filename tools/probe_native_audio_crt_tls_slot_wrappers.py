from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
regions=[('dispatch',0x2da5300,8),('cookie',0x1222ed0,4)];calls=[];action='allocate';extended=False;api_result=0
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
w(0xfa4374,vector+0x28000);w(0xfa436c,vector+0x28010)
def hook(uc,a,z,user):
 if a in [vector+0x28000,vector+0x28010,vector+0x28020,vector+0x28030]:
  sp=u.reg_read(UC_X86_REG_ESP);kind={vector+0x28000:'TlsAlloc',vector+0x28010:'TlsFree',vector+0x28020:'FlsAlloc',vector+0x28030:'FlsFree'}[a];args=[]if kind=='TlsAlloc'else[read(sp+4)];calls.append({'kind':kind,'arguments':args,'result':api_result,'at_call':snapshot()});finish(api_result,4 if args else 0);return
 assert 0xcabc85<=a<0xcabcc2,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for action,extended,cookie,api_result,param_index in itertools.product(['allocate','free'],[False,True],[0,0x11223344,0xffffffff],[0,5,0xffffffff],[0,1]):
 parameter=([0,0xca9026]if action=='allocate'else[5,0xffffffff])[param_index];w(0x1222ed0,cookie);w(0x2da5300,cookie^(vector+0x28020 if extended else 0));w(0x2da5304,cookie^(vector+0x28030 if extended else 0));calls.clear();before=snapshot();w(stack,end);w(stack+4,parameter);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xcabc85 if action=='allocate'else 0xcabca3,end,count=500);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'action':action,'extended':extended,'cookie':cookie,'api_result':api_result,'parameter':parameter,'before':before,'after':snapshot(),'calls':list(calls),'result':u.reg_read(UC_X86_REG_EAX),'stack_delta':u.reg_read(UC_X86_REG_ESP)-stack,'terminal':True})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual CABC85 allocation/CABCA3 freeing wrappers execute with real cookie decode and original fallback/extended calling conventions. Supplied WindowsTlsAlloc/TlsFree/FlsAlloc/FlsFree boundary outcomes and arguments captured; fallbackTlsAlloc receives no callback argument, extendedFlsAlloc receives supplied callback.','Controlled slot/BOOL results and callback pointers are not OS allocation or callback lifetime evidence. Original thread-subsystem startup/cleanup callers, encoded Get/Set wrappers, actual provider availability and multithread behavior remain separate. Rust replay pending.']}
(r/'data/4.20/audio_crt_tls_slot_wrappers_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_tls_slot_wrappers.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'original TLS/FLS slot allocation/free wrapper cases')
