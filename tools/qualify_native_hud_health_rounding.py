from pathlib import Path
import math,struct,json,hashlib,datetime
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
# Original health HUD uses ca5f30 then ca1e40 at 7d6de4..7d6e23.
# Only a caller trampoline is synthetic; both CRT routines execute original instructions.
trampoline=end-0x100
u.mem_write(trampoline,b'\xe8'+struct.pack('<i',0xca1e40-(trampoline+5))+b'\x83\xc4\x08\xc3')
w(0x2da52e8,1);w(0x14ae660,1)
u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x37f)
addresses=set()
def observed(uc,address,length,unused):
 assert address==trampoline or trampoline+5<=address<=trampoline+8 or 0xca5f30<=address<=0xca604c or 0xca1e40<=address<=0xca1e5b,hex(address)
 addresses.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,observed)
cases=[]
for value in [0.0,0.001,0.25,0.5,0.999,1.0,1.001,12.5,123.75,456.5,514.4,616.6,1000000.25]:
 v=struct.unpack('<f',struct.pack('<f',value))[0]
 w(stack,trampoline);u.mem_write(stack+4,struct.pack('<d',v));w(stack+12,end)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca5f30,end,count=200)
 assert u.reg_read(UC_X86_REG_EIP)==end
 actual=u.reg_read(UC_X86_REG_EAX);assert actual==math.ceil(v),(v,actual)
 cases.append(dict(input_f32=v,health_integer=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0xca5f30','0xca1e40'],source_health_calls=['0x7d6df5','0x7d6dfd','0x7d6e16','0x7d6e1e'],health_text_submission='0x7d756d',format_address='0x10bc19c',format='%d / %d',case_count=len(cases),cases=cases,native_addresses=len(addresses)-3,limits=['Only the positive finite health integer conversion helpers executed; caller input retrieval and Text submission observed by disassembly, not emulated here.','Synthetic caller trampoline only; original CRT fast paths execute. Fallback CRT path, negative, nonfinite and overflow inputs not qualified.','Mana conversion uses a different SSE floor path and remains to qualify. Full original formatting, localization and framebuffer equivalence remain open.','Current client still floors health values; correction requires integration and validation.'])
(r/'docs/native_hud_health_rounding_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),passed=True,health_conversion='ceil')))
