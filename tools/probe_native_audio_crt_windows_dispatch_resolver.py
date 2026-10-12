from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
regions=[('dispatch_table',0x2da5300,0x100),('cookie',0x1222ed0,4)];calls=[];module=0;layout='none';export_index=0;written=set()
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def cstring(a):return bytes(u.mem_read(a,128)).split(b'\0')[0].decode('ascii')
def wstring(a):
 out=[]
 for j in range(64):
  c=int.from_bytes(u.mem_read(a+j*2,2),'little')
  if c==0:break
  out.append(chr(c))
 return ''.join(out)
w(0xfa4414,vector+0x28000);w(0xfa43dc,vector+0x28010)
def hook(uc,a,z,user):
 global export_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==vector+0x28000:calls.append({'kind':'GetModuleHandleW','name':wstring(read(sp+4)),'result':module,'at_call':snapshot()});finish(module,4);return
 if a==vector+0x28010:
  handle=read(sp+4);name=cstring(read(sp+8));available=module!=0 and(layout=='all'or(layout=='alternating'and export_index%2==0)or(layout=='fls'and name.startswith('Fls')));result=vector+0x4000+export_index*16 if available else 0;calls.append({'kind':'GetProcAddress','module':handle,'name':name,'result':result,'at_call':snapshot()});export_index+=1;finish(result,8);return
 assert base<=a<base+len(image),hex(a)
def writes(uc,kind,a,z,value,user):
 if base<=a<base+len(image):written.add(a);assert 0x2da5300<=a and a+z<=0x2da5400,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_WRITE,writes);rows=[]
for pattern,cookie,module,layout in itertools.product([0,165],[0,0x11223344,0xffffffff],[0,0x12340000],['none','all','alternating','fls']):
 u.mem_write(0x2da5300,bytes([pattern])*0x100);w(0x1222ed0,cookie);calls.clear();written.clear();export_index=0;before=snapshot();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xcabde8,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'cookie':cookie,'module':module,'layout':layout,'before':before,'after':snapshot(),'calls':list(calls),'written_addresses':sorted(written),'result':u.reg_read(UC_X86_REG_EAX),'terminal':True})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xcabde8','regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'export_names':[c['name']for c in rows[0]['calls']if c['kind']=='GetProcAddress'],'cases':rows,'limits':['Actual CABDE8 original Windows function resolver: imported GetModuleHandleW/GetProcAddress only supplied, original symbol names/order and XOR-cookie publication execute. Opaque export pointers supplied; canonical entry/final tables and each global write address captured.','No actual Windows module/export availability or security-cookie initialization claim. Module NULL and varied export availability are controlled outcomes. Full C9A0B9 encoded default-handler initialization, global heap/TLS creation and original resolver to normal runtime composition remain separate. Rust replay pending.']}
(r/'data/4.20/audio_crt_windows_dispatch_resolver_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_windows_dispatch_resolver.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'original resolver cases;',len(p['export_names']),'exports:',p['export_names'])
