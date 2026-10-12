from pathlib import Path
import struct,json,datetime,hashlib,itertools
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
frame=stack-0x1000;owner=vector+0x6000;proxy=vector+0x7000;trampoline=end-0x100
w(owner+0x20c,proxy);w(proxy+0x20,vt);w(proxy+0x24,7)
# Supply original post-accessor x87 result; execute original clamp and fraction instructions.
u.mem_write(trampoline,b'\xd9\x45\xe8\xe9'+struct.pack('<i',0x7eb702-(trampoline+8)))
visited=set()
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def bits(x):return struct.unpack('<I',struct.pack('<f',x))[0]
def observe(uc,a,n,unused):
 assert a in [trampoline,trampoline+3] or 0x7eb702<=a<0x7eb733 or 0x7eb774<=a<0x7eb7be,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,observe);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
cases=[]
for needed,fraction,maximum_level in itertools.product([300.0,400.0,600.0,3555.0],[-.25,0,.001,.25,.5,.999,1,1.25],[False,True]):
 current=f32(needed*fraction);w(frame-0x18,bits(current));w(frame-0x10,bits(needed));w(frame-0xc,bits(needed));u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EDI,owner)
 u.emu_start(trampoline,0x7eb733,count=50);assert u.reg_read(UC_X86_REG_EIP)==0x7eb733
 clamped=read(frame-8);assert clamped==bits(min(max(current,0.0),needed))
 u.reg_write(UC_X86_REG_EAX,proxy);u.reg_write(UC_X86_REG_EFLAGS,0x242 if maximum_level else 0x202)
 stop=0x7eb796 if maximum_level else 0x7eb7bb
 u.emu_start(0x7eb774,stop,count=50);assert u.reg_read(UC_X86_REG_EIP)==stop
 result=read(frame-0x1c if maximum_level else frame-0x14);expected=bits(1.0 if maximum_level else f32(min(max(current,0.0),needed)/needed));assert result==expected
 cases.append(dict(needed_f32=needed,current_level_experience_f32=current,maximum_level=maximum_level,fraction_bits=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),source_xp_bar_reference='0x7ea27d',source_handle_store='0x7ea2a0',clamp_slice=['0x7eb702','0x7eb733'],ratio_slice=['0x7eb774','0x7eb7bb'],case_count=len(cases),native_addresses=len(visited)-2,cases=cases,findings=['Current-level XP is clamped to zero..needed XP; ordinary level divides by needed XP in f32.','At maximum level the original controller submits full width fraction1.'],limits=['Original instruction slices after experience/curve/level accessors. Supplied accessor results, flags and proxy context; native accessors and UI callbacks not emulated.','Synthetic caller trampoline loads x87 input only. Original clamp, maximum-level branch and scalar division execute unmodified.','Fractional threshold derivation, cap-level policy, animation/highlight and complete original framebuffer still require separate qualification.'])
(r/'data/4.20/native_hud_experience_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),passed=True)))
