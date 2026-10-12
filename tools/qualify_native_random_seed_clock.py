"""Qualify native UTC FILETIME seed conversion and startup call fragment."""
from pathlib import Path
import json,struct,datetime,random
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'setup','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
imports={v.address:v.name.decode() for imp in p.DIRECTORY_ENTRY_IMPORT for v in imp.imports if v.name}
assert imports[0xfa419c]=='SystemTimeToFileTime' and imports[0xfa41c0]=='GetSystemTime'
convert=end+0x100;get_time=end+0x200
write32(0xfa419c,convert);write32(0xfa41c0,get_time)
epoch=datetime.datetime(1601,1,1);unix=datetime.datetime(1970,1,1)
base=int((unix-epoch).total_seconds())*10000000
supplied=None;calls=[]
def filetime(t):
 delta=t-epoch
 return (delta.days*86400+delta.seconds)*10000000+delta.microseconds*10
def hook(uc,a,size,user):
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==get_time:
  dest=read32(u.reg_read(UC_X86_REG_ESP)+4);t=supplied
  fields=[t.year,t.month,(t.weekday()+1)%7,t.day,t.hour,t.minute,t.second,t.microsecond//1000]
  u.mem_write(dest,struct.pack('<8H',*fields));calls.append({'api':'GetSystemTime','fields':fields});finish(pop=4);return
 if a==convert:
  sp=u.reg_read(UC_X86_REG_ESP);src,dest=read32(sp+4),read32(sp+8)
  fields=list(struct.unpack('<8H',u.mem_read(src,16)))
  y,m,_,d,h,minute,sec,ms=fields;t=datetime.datetime(y,m,d,h,minute,sec,ms*1000)
  ft=filetime(t);u.mem_write(dest,struct.pack('<Q',ft));calls.append({'api':'SystemTimeToFileTime','fields':fields,'filetime':ft});finish(pop=8,eax=1);return
 assert any(lo<=a<hi for lo,hi in [(0x993da0,0x993e38),(0xca2910,0xca2978),(0x58d985,0x58d9ab),(0x8e2630,0x8e2694)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def reset():write32(0x2d91058,0);write32(0x2d91030,0);write32(0x2d91034,0)
def conversion(ft):
 u.mem_write(heap+0x6000,struct.pack('<Q',ft));sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap+0x6000)
 u.emu_start(0x993da0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 return u.reg_read(UC_X86_REG_EAX)|(u.reg_read(UC_X86_REG_EDX)<<32)
randomizer=random.Random(420)
values=[0,1,base-10001,base-10000,base-9999,base-1,base,base+1,base+9999,base+10000,base+10001,0x7fffffffffffffff,0x8000000000000000,0xffffffffffffffff]+[randomizer.getrandbits(64) for _ in range(100)]
rows=[]
for i,ft in enumerate(values):
 reset();calls=[];out=conversion(ft);expected=((ft-base)&0xffffffffffffffff)//10000;assert out==expected
 assert len(calls)==1 and calls[0]['fields']==[1970,1,0,1,0,0,0,0]
 assert read32(0x2d91030)|(read32(0x2d91034)<<32)==base
 again=conversion(ft);assert again==out and len(calls)==1
 rows.append({'filetime':ft,'milliseconds_u64':out,'seed_u32':out&0xffffffff,'cached_repeat_equal':True})
startup=[]
for t in [datetime.datetime(1970,1,1),datetime.datetime(2014,11,20),datetime.datetime(2026,10,4,6,30,15,999000),datetime.datetime(1969,12,31,23,59,59,999000),datetime.datetime(2000,2,29,12,34,56,123000),datetime.datetime(2100,3,1)]:
 reset();supplied=t;calls=[];u.reg_write(UC_X86_REG_ESP,stack+0x8000);u.reg_write(UC_X86_REG_EBP,stack+0x7000)
 u.emu_start(0x58d985,0x58d9ab,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x58d9ab
 expected=(((filetime(t)-base)&0xffffffffffffffff)//10000)&0xffffffff
 state={'words':list(struct.unpack('<55I',u.mem_read(0x2d6ec08,220))),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)}
 table=list(struct.unpack('<55I',u.mem_read(0x10cf9a8,220)))
 assert state['words']==[table[(i+expected%55)%55]^expected for i in range(55)] and state['first']==0 and state['second']==31
 assert [x['api'] for x in calls]==['GetSystemTime','SystemTimeToFileTime','SystemTimeToFileTime']
 startup.append({'utc':t.isoformat(),'filetime':filetime(t),'seed_u32':expected,'rng':state,'os_calls':calls})
proof={'native_sha256':digest,'passed':True,'complete':False,'unix_epoch_filetime':base,'conversion_cases':rows,'startup_cases':startup,'limits':['Original993DA0 and unsigned64 divisionCA2910 executed, with security-cookie adapter preserving EAX. OS SystemTimeToFileTime returns supplied UTC conversions; original Windows API is not executed.','Original startup fragment58D985..58D9AB executes GetSystemTime, conversion993DA0 and RNG seed8E2630. Remaining startup function not qualified.','Explicit UTC FILETIME inputs; no live startup clock or cross-system RNG draw ordering integration claimed. Camera shake activation/effect bindings still incomplete.']}
(r/'data/4.20/random_seed_clock_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('Native clock seed:',len(rows),'conversions/cache repeats,',len(startup),'startup fragments')
