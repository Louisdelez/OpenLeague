from pathlib import Path
import itertools,json,hashlib,shutil,struct
r=Path('E:/OpenLeague');bootstrap=(r/'tools/probe_native_audio_crt_fresh_thread_initialized_locks.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(bootstrap,'native_crt_setup','exec'))
actor=vector+0x1000;vt=vector+0x2000;raw_name=vector+0x3000;float_storage=vector+0x8000;float_get=vector+0x29000;name_get=vector+0x29010
# Execute x87 fld as the explicit actor float provider; the original callback
# performs its actual fstp double conversion before invoking the real CRT.
u.mem_write(float_get,b'\xd9\x05'+struct.pack('<I',float_storage)+b'\xc3')
w(0xfa42e8,vector+0x29020);w(0xfa42ec,vector+0x29030)
ops=[]
def capture(uc,a,size,user):
 if a in [vector+0x29020,vector+0x29030]:ops.append({'op':'DecodePointer' if a==vector+0x29020 else 'EncodePointer'});finish(read(u.reg_read(UC_X86_REG_ESP)+4),4);return
 if a==float_get:ops.append({'op':'bounty_getter'});return
 if float_get<a<float_get+7:return
 if a==name_get:ops.append({'op':'champion_getter'});finish(raw_name);return
 if a==vector+0x29040:ops.append({'op':'invalid_parameter','args':[read(u.reg_read(UC_X86_REG_ESP)+i) for i in [4,8,12,16,20]]});finish(0);return
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
for entry,flags,name,fill in itertools.product([0x6d4520,0x6d45a0],[0x400,0x1400],[b'a'*256,b'b'*257,b'c'*512,b'd'*255+b'\0tail'],[0,0xa5,0xcc]):
 reset();w(0x14ae624,vector+0x29040);w(actor+0x1c,flags);u.mem_write(raw_name,name+b'\0');u.mem_write(0x2d7c260,bytes([fill])*256);w(stack,end);w(stack+4,actor);u.reg_write(UC_X86_REG_ESP,stack);run(entry)
 assert u.reg_read(UC_X86_REG_EIP)==end and unsupported is None
 address=u.reg_read(UC_X86_REG_EAX);buffer=bytes(u.mem_read(0x2d7c260,256));output=cbytes(address)
 assert address==0x2d7c260 and last_error==97
 cases.append({'entry':hex(entry),'flags':flags,'name_hex':name.hex(),'initial_fill':fill,'output_hex':output.hex(),'buffer_hex':buffer.hex(),'errno':read(record+8) if tls_record else 0,'ops':ops.copy(),'crt_calls':calls.copy()})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'cases':cases,'limits':['Original6D4520/6D45A0 callback, ignored bounded255-byte scan, complete original secure256-byte copy/error setter and original invalid-parameter dispatcher execute. Provided returning invalid-parameter callback is installed in14AE624 with identity DecodePointer. No copy/result adapter.','Lengths256/257/512 clear destination first byte but retain copied remaining255 bytes; errno34 and invalid-parameter callback observed. Source255 plusNUL succeeds. Default terminating invalid handler, native exception/unwind and actual global callback initialization remain incomplete.','Actor raw getter, Windows/calloc/TLS and identity pointer-codec supplied. Null getter fault qualified separately.']}
(r/'data/4.20/audio_announcer_champion_field_copy_errors_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_champion_copy_errors.py'),r/'tools/qualify_announcer_champion_copy_errors.py')
print(json.dumps({'native_champion_copy_error_cases':len(cases)}))
