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
bounty=[]
import random
rng=random.Random(420)
bit_patterns=[0,0x80000000,1,0x80000001,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fc00000,0xffc00000,0x3effffff,0x3f000000,0x3f000001,0xbf000000,0x40200000,0xc0200000,*[rng.getrandbits(32) for _ in range(1024)]]
values=[struct.unpack('<f',struct.pack('<I',b))[0] for b in bit_patterns]
for entry,present,flags,value in itertools.product([0x6d44b0,0x6d4500],[True],[0x400],values):
 reset();w(actor+0x1c,flags);bits=struct.pack('<f',value);u.mem_write(float_storage,bits);u.mem_write(0x2d7c160,b'\xcc'*256);w(stack,end);w(stack+4,actor if present else 0);u.reg_write(UC_X86_REG_ESP,stack);run(entry)
 assert u.reg_read(UC_X86_REG_EIP)==end and unsupported is None,(hex(u.reg_read(UC_X86_REG_EIP)),unsupported)
 address=u.reg_read(UC_X86_REG_EAX);output=cbytes(address);assert last_error==97
 bounty.append({'entry':hex(entry),'actor_present':present,'flags':flags,'float_bits_hex':bits.hex(),'output_hex':output.hex(),'output_pointer':address,'ops':ops.copy(),'crt_calls':calls.copy()})

proof={'native_sha256':hashlib.sha256(raw).hexdigest(),'passed':True,'complete':False,'cases':bounty,'limits':['Actual6D44B0/6D4500 x87 float32-to-double and C9811C CRT formatting execute with actual CA1DA7 floating dispatch initialization; no floating output supplied. Deterministic seed420 random values plus signed zero, subnormal, maximum finite, infinity, quiet NaN and half boundaries.','Windows/TLS/calloc/EncodePointer/DecodePointer identity boundaries supplied as in baseline bounty contract. Full native process startup, alternate locale/FPCW and actor ownership remain incomplete. Python float32 unpack/pack may quiet signaling NaNs before provider storage; recorded input bits are authoritative.']}
(r/'data/4.20/audio_announcer_bounty_extended_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_bounty_extended.py'),r/'tools/qualify_announcer_bounty_extended.py')
print(json.dumps({'native_bounty_extended_cases':len(bounty)}))
