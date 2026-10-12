from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_windows_dispatch_resolver.py').read_text(encoding='utf-8');exec(compile(source.split('\nu.hook_add(')[0],'setup','exec'))
original_hook=hook;regions=[];encode_null=0x13572468;collect=True;access=set();dirty=set();w(0xfa42ec,vector+0x28020)
def wrapped(uc,a,z,user):
 if a==vector+0x28020:
  value=read(u.reg_read(UC_X86_REG_ESP)+4);result=value^encode_null;calls.append({'kind':'EncodePointer','input':value,'result':result,'at_call':snapshot()});finish(result,4);return
 original_hook(uc,a,z,user)
def memory(uc,kind,a,z,value,user):
 if collect and base<=a<base+len(image):
  access.update(range(a,a+z))
  if kind==unicorn.UC_MEM_WRITE:dirty.update(range(a,a+z))
u.hook_add(unicorn.UC_HOOK_CODE,wrapped);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)));module=0x12340000;layout='all';calls.clear();export_index=0;w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xc9a0b9,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end;collect=False;words=sorted({a&~3 for a in access});dirty_words=sorted({a&~3 for a in dirty});intervals=[]
for a in words:
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
regions=[(f'global_{a:08x}',a,b-a)for a,b in intervals];rows=[]
for pattern,cookie,encode_null,module,layout in itertools.product([0,165],[0,0x11223344,0xffffffff],[0,0x13572468,0xffffffff],[0,0x12340000],['none','all']):
 u.mem_write(base,baseline)
 for a in dirty_words:u.mem_write(a,bytes([pattern])*4)
 w(0x1222ed0,cookie);calls.clear();export_index=0;before=snapshot();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xc9a0b9,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'cookie':cookie,'encode_null':encode_null,'module':module,'layout':layout,'before':before,'after':snapshot(),'calls':list(calls),'result':u.reg_read(UC_X86_REG_EAX),'terminal':True})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xc9a0b9','written_words':dirty_words,'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual C9A0B9 and all six original encoded-default setters plus CABDE8 resolver execute. EncodePointer(NULL and original static pointer inputs with explicit XOR-key service outcomes), GetModuleHandleW and GetProcAddress are explicit supplied Windows outcomes. Every original data read/write fragment discovered in successful full-export path captured; all boundary and final banks retained.','EncodedNULL result/security cookie/module/export outcomes supplied, not native OS pointer encoding or startup initialization proof. Actual TLSslot/heap startup, live Windows API providers and normal game integration remain open. Rust replay pending.']}
(r/'data/4.20/audio_crt_global_dispatch_initialization_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_global_dispatch_initialization.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'original global handler+33-export initializations;',len(regions),'canonical regions; written words',[hex(a)for a in dirty_words])
