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
values=[0.0,-0.0,0.25,0.5,0.75,1.5,2.5,3.5,99.5,100.5,123.125,2147483648.0,1e20,-0.25,-0.5,-1.5,-2.5,-99.5]
for entry,present,flags,value in itertools.product([0x6d44b0,0x6d4500],[False,True],[0,0x400,0x1000,0x1400],values):
 reset();w(actor+0x1c,flags);bits=struct.pack('<f',value);u.mem_write(float_storage,bits);u.mem_write(0x2d7c160,b'\xcc'*256);w(stack,end);w(stack+4,actor if present else 0);u.reg_write(UC_X86_REG_ESP,stack);run(entry)
 assert u.reg_read(UC_X86_REG_EIP)==end and unsupported is None,(hex(u.reg_read(UC_X86_REG_EIP)),unsupported)
 address=u.reg_read(UC_X86_REG_EAX);output=cbytes(address);assert last_error==97
 bounty.append({'entry':hex(entry),'actor_present':present,'flags':flags,'float_bits_hex':bits.hex(),'output_hex':output.hex(),'output_pointer':address,'ops':ops.copy(),'crt_calls':calls.copy()})
champion=[]
names=[b'',b'Garen',b'Annie',b'A\0B',bytes(range(1,128)),bytes(range(128,256)),bytes(range(1,256)),b'a'*255]
for entry,present,flags,name in itertools.product([0x6d4520,0x6d45a0],[False,True],[0,0x400,0x1000,0x1400],names):
 reset();w(actor+0x1c,flags);u.mem_write(raw_name,name+b'\0');u.mem_write(0x2d7c260,b'\xcc'*256);w(stack,end);w(stack+4,actor if present else 0);u.reg_write(UC_X86_REG_ESP,stack);run(entry)
 assert u.reg_read(UC_X86_REG_EIP)==end and unsupported is None,(hex(u.reg_read(UC_X86_REG_EIP)),unsupported)
 address=u.reg_read(UC_X86_REG_EAX);output=cbytes(address);assert last_error==97
 champion.append({'entry':hex(entry),'actor_present':present,'flags':flags,'name_hex':name.hex(),'output_hex':output.hex(),'output_pointer':address,'buffer_hex':bytes(u.mem_read(0x2d7c260,256)).hex(),'ops':ops.copy(),'crt_calls':calls.copy()})
digest=hashlib.sha256(raw).hexdigest()
for name,cases,limits in [('bounty',bounty,['Original6D44B0/6D4500 gate, x87 float-to-double promotion and C9811C sprintf/actual CRT execute. Float provider supplied by real fld/ret instructions with explicit32bit values. Native rounded bytes, source gate and destination pointer retained.','OriginalCA1DA7 floating dispatch initializer and actual fresh CRT TLS/default PE locale execute with supplied calloc/Windows imports and identity EncodePointer/DecodePointer ABI adapters. Finite selected float32 inputs only; nonfinite, complete startup/custom locales and actor lifetimes remain incomplete.']),('champion_field',champion,['Original6D4520/6D45A0 gate, originalC9F8B6 bounded length scan and originalC9F8D1 secure copy execute. No supplied copied/string output. Supplied nonnull raw name getter;0..255byte names and non-ASCII/raw byte transport tested.','Null actor/nonbit10 literal0 bypass included. Eligible getter returningNULL deliberately excluded: native diagnostic/GetLastError/NULL write fault requires separate qualification. Names exceeding255 trigger invalid-parameter handling and remain unqualified. Physical live actor/cache concurrency remain incomplete.'])]:
 proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'limits':limits};(r/f'data/4.20/audio_announcer_{name}_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_bounty_and_champion_fields.py'),r/'tools/qualify_announcer_bounty_and_champion_fields.py')
print(json.dumps({'bounty_cases':len(bounty),'champion_field_cases':len(champion),'half_outputs':[c['output_hex'] for c in bounty if c['entry']=='0x6d44b0' and c['actor_present'] and c['flags']==0x400][:12]}))
