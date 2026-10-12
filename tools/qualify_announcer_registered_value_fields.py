from pathlib import Path
import itertools,json,hashlib,shutil,struct
r=Path('E:/OpenLeague');bootstrap=(r/'tools/probe_native_audio_crt_fresh_thread_initialized_locks.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(bootstrap,'native_crt_setup','exec'))
actor=vector+0x1000;vt=vector+0x2000;raw_name=vector+0x3000;float_storage=vector+0x8000;float_get=vector+0x29000;name_get=vector+0x29010
# Execute x87 fld as the explicit actor float provider; the original callback
# performs its actual fstp double conversion before invoking the real CRT.
u.mem_write(float_get,b'\xd9\x05'+struct.pack('<I',float_storage)+b'\xc3')
w(0xfa42e8,vector+0x29020);w(0xfa42ec,vector+0x29030)
outputs=[];output=vector+0xa000;input_address=vector+0xb000
ops=[]
def capture(uc,a,size,user):
 if a in [vector+0x29020,vector+0x29030]:ops.append({'op':'DecodePointer' if a==vector+0x29020 else 'EncodePointer'});finish(read(u.reg_read(UC_X86_REG_ESP)+4),4);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);pointer,n=read(sp+4),read(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output;outputs.append(bytes(u.mem_read(pointer,n)).hex());finish(output,8);return
 if a==float_get:ops.append({'op':'bounty_getter'});return
 if float_get<a<float_get+7:return
 if a==name_get:ops.append({'op':'champion_getter'});finish(raw_name);return
 if a==0x991f80:raise AssertionError('unexpected native null name diagnostic')
 hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,capture);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;baseline=bytes(u.mem_read(base,len(image)))
def reset():
 global tls_record,failure,last_error,unsupported,ops
 u.mem_write(base,baseline);calls.clear();trail.clear();tls_record=0;failure='none';last_error=97;unsupported=None;ops=[];u.mem_write(record,bytes(0x3bc));u.mem_write(stack-0x1000,bytes(0x1100));w(0,0xffffffff);w(actor,vt);w(vt+0x278,float_get);w(vt+0x1f8,name_get)
def cbytes(a):
 b=bytes(u.mem_read(a,512));assert 0 in b;return b.split(b'\0',1)[0]
def run(entry):
 try:u.emu_start(entry,end,count=1000000)
 except Exception:
  print(json.dumps({'entry':hex(entry),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'eax':hex(u.reg_read(UC_X86_REG_EAX)),'ecx':hex(u.reg_read(UC_X86_REG_ECX)),'trail':[hex(a) for a in trail[-15:]]}));raise
cases=[]
for entry,kind,present,flags,variant,index in itertools.product([0x6d4a10,0x6d4dc0],['bounty','champion'],[False,True],[0,0x400,0x1000,0x1400],['exact','upper','tail'],range(6)):
 reset();outputs=[];pattern=b' bounty@' if kind=='bounty' else b' champion@';input_bytes=pattern.upper() if variant=='upper' else pattern+b'tail' if variant=='tail' else pattern
 names=[b'',b'Garen',b'A\0B',bytes(range(128,256)),b'a'*255,b'Annie'];values=[0.,-0.,0.5,2.5,1e20,-2.5];name=names[index];bits=struct.pack('<f',values[index]);w(actor+0x1c,flags);u.mem_write(raw_name,name+b'\0');u.mem_write(float_storage,bits);u.mem_write(input_address,input_bytes+b'\0')
 w(stack,end);w(stack+4,output);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if present else 0);run(entry)
 assert u.reg_read(UC_X86_REG_EIP)==end and unsupported is None and len(outputs)==1
 cases.append({'entry':hex(entry),'kind':kind,'input_hex':input_bytes.hex(),'actor_present':present,'flags':flags,'name_hex':name.hex(),'float_bits_hex':bits.hex(),'output_hex':outputs[0],'ops':ops.copy(),'crt_calls':calls.copy()})
proof={'native_sha256':hashlib.sha256(raw).hexdigest(),'passed':True,'complete':False,'cases':cases,'limits':['Original plain/localized ordered dispatcher and actual matchers execute with complete native bounty/champion callbacks and actual CRT. No supplied callback, format/copy or final byte result. Exact/uppercase/trailing suffix prefix forms, actor/flag gates, signed-zero/half/large float and raw non-ASCII/NUL/max255byte names included.','Explicit output storage adapter5FDA30 captures the native byte span; actor getter, Windows/TLS/calloc/pointer codecs supplied as in field fixtures. Actual shared globals retained/reset by native callback; lifetime/concurrency and unregistered fallback inputs not qualified here.','Does not complete all30plain23localized ordered composition, event registration or in-game playback.']}
(r/'data/4.20/audio_announcer_registered_value_fields_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_registered_value_fields.py'),r/'tools/qualify_announcer_registered_value_fields.py');print(json.dumps({'native_registered_value_field_cases':len(cases)}))
