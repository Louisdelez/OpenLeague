from pathlib import Path
import json,hashlib,itertools,shutil
r=Path('E:/OpenLeague');bootstrap=(r/'tools/probe_native_audio_crt_fresh_thread_initialized_locks.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(bootstrap,'native_crt_setup','exec'))
digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
u.hook_add(unicorn.UC_HOOK_CODE,hook);baseline=bytes(u.mem_read(base,len(image)));cases=[]
for fmt,value,cached in itertools.product(['%ld','%lx'],[*range(256),0x7fffffff,0x80000000,0xffffffff],[False,True]):
 u.mem_write(base,baseline);calls.clear();trail.clear();tls_record=0;failure='none';last_error=97;unsupported=None;u.mem_write(record,bytes(0x3bc));u.mem_write(stack-0x1000,bytes(0x1100));w(0,0xffffffff)
 if cached:
  w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca91a9,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and tls_record==record;calls.clear();trail.clear();last_error=97
 u.mem_write(vector+0x1000,fmt.encode()+b'\0');u.mem_write(vector+0x2000,b'\xcc'*64);w(stack,end);w(stack+4,vector+0x2000);w(stack+8,64);w(stack+12,vector+0x1000);w(stack+16,value);u.reg_write(UC_X86_REG_ESP,stack)
 u.emu_start(0xc981a0,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end and unsupported is None
 buffer_bytes=bytes(u.mem_read(vector+0x2000,64));text=buffer_bytes.split(b'\0',1)[0].decode('ascii');expected=str(value if value<0x80000000 else value-0x100000000) if fmt=='%ld' else format(value,'x');result=u.reg_read(UC_X86_REG_EAX)
 assert text==expected and result==len(expected) and buffer_bytes[len(expected)]==0 and last_error==97
 cases.append({'format':fmt,'value':value,'cached_tls':cached,'capacity':64,'output':text,'buffer_hex':buffer_bytes.hex(),'result':result,'last_error':last_error,'tls_record':tls_record,'calls':calls.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original C981A0 bounded printf wrapper and complete native CRT formatting execute; no supplied integer/string formatter. Actual CA91A9 getter,CA9218 initializer and default-PE-locale thread context execute for fresh/cached TLS. All256 color-component values plus signed32 boundaries tested.','Explicit calloc/free and Windows GetLastError/TLS/critical-section/current-thread imports supplied with previously qualified lock slots12/13 and TLSslot5. Source default locale retained from PE; full native allocator/startup/concurrency excluded.','%ld/%lx with capacity64 and one32bit argument only. Other flags/types/width/truncation/exceptional/custom locales and C++ num_put grouping/padding/writer machinery remain incomplete.']}
(r/'data/4.20/audio_announcer_native_integer_printf_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_native_integer_printf.py'),r/'tools/qualify_announcer_native_integer_printf.py')
print(json.dumps({'native_integer_printf_cases':len(cases)}))
