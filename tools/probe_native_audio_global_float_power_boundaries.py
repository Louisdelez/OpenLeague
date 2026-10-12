from pathlib import Path
import json,itertools,struct,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
last_error=97;exponent=0;power=0;vis=set();windows=0
w(0xfa43bc,vector+0x28000);w(0xfa43fc,vector+0x28010);w(0xfa4440,vector+0x28020);w(0x2da5308,read(0x1222ed0));w(0x12230cc,5);w(0x2da52e8,0)
def hook(uc,a,z,user):
 global last_error,exponent,power,windows
 vis.add(a);sp=u.reg_read(UC_X86_REG_ESP)
 if a==vector+0x28000:windows+=1;finish(last_error);return
 if a==vector+0x28010:assert read(sp+4)==5;last_error=0;finish(vector+0x12000,4);return
 if a==vector+0x28020:last_error=read(sp+4);finish(0,4);return
 if a==0xca2fa0:exponent=read(u.reg_read(UC_X86_REG_EBP)-4)
 if a==0xaeb45f:power=read(u.reg_read(UC_X86_REG_EBP)-0x14)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
bits=lambda v:struct.unpack('<I',struct.pack('<f',v))[0]
values={bits(-96.3*i/4096) for i in range(4097)};seed=0x12345678
for i in range(8192):
 seed=(1664525*seed+1013904223)&0xffffffff;v=struct.unpack('<f',struct.pack('<I',0x80000000|(seed%0x42c0999b)))[0]
 values.add(bits(v))
values|={0,0x80000000,0xc2c0999a,0xc2c09999,0xc2140000,0xc213ffff,0xc2140001,0x7fc12345,0xffc12345,0x7f812345,0xff812345}
rows=[]
for value in sorted(values):
 w(0x12100d4,2);w(0x14a7970,0);w(0x14a7974,0);u.mem_write(vector+0x12000,bytes(0x3bc));u.mem_write(stack-0x1000,bytes(0x1000));last_error=97;exponent=None;power=None
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);w(stack,end);w(stack+4,value);w(stack+8,2);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xaeb3d0,end,count=25000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)==1 and exponent is not None and power is not None
 rows.append({'bits':value,'exponent_bits':exponent,'power_bits':power,'threshold_bits':read(0x121022c),'value_bits':read(0x1210230),'errno':read(vector+0x12008),'last_error':last_error})
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'native_addresses':len(vis),'windows_get_calls':windows,'cases':rows,'limits':['Actual AEB3D0 and original CRT fallback body; rounded native power captured after original FSTP m32 atAEB45F, exponent captured atCA2FA0.4097 dense values plus8192 deterministic raw-bit values, zero/minimum/subnormal/near-minimum/fast-path boundary/quiet and signaling NaNs; overlapping inputs deduplicated.','Explicit measured Windows API boundaries, initialized thread record and PC64nearest037F/MXCSR1F80; no full startup/devices. Native emulator signaling-NaN/precision may differ from actual hardware; preserve original capture, compare separately before claiming equivalence.']}
(r/'data/4.20/audio_global_float_power_boundary_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_global_float_power_boundaries.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('PASS',len(rows),'actual CRT power/result numeric boundary cases')
