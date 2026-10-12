from pathlib import Path
import json,struct,hashlib,datetime,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD scanner prerequisites','exec'))
u.mem_map(0,0x1000)
obj=vector+0x8000;text=vector+0x9000;origin=vector+0xa000;errno=vector+0xb000;thread=vector+0xc000;calls=[]
decode_pointer=read(0xfa42e8)
u.mem_write(thread,b'\0'*0x400);w(thread+0x6c,read(0x122323c));w(thread+0x68,read(0x1222dd4));w(thread+0x70,2)
def scanner_hook(uc,a,size,user):
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x5642d0:finish(0);return
 if a==0xc9b780:finish(errno);return
 if a==0xca9191:finish(thread);return
 if a==decode_pointer:finish(read(uc.reg_read(UC_X86_REG_ESP)+4),4);return
 visited.add(a)
 if size>=5 and bytes(uc.mem_read(a,1))==b'\xe8':calls.append(hex(a)+' -> '+hex(a+5+struct.unpack('<i',uc.mem_read(a+1,4))[0]))
u.hook_add(unicorn.UC_HOOK_CODE,scanner_hook)
w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
anchor='--anchor' in sys.argv
u.mem_write(obj,b'\xa5'*0x300);u.mem_write(text,b' 1 , 2\0' if anchor else b' 16 , 32 - 96 , 128 / 1024 x 1024\0');u.mem_write(origin,struct.pack('<2f',0.,0.));w(stack,end);w(stack+4,obj);w(stack+8,text);w(stack+12,0);w(stack+16,origin);u.reg_write(UC_X86_REG_ESP,stack)
error=None
try:u.emu_start(0x9a2000 if anchor else 0x9a2180,end,count=250000)
except unicorn.UcError as e:error=str(e)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),qualified=False,complete=False,terminal=u.reg_read(UC_X86_REG_EIP)==end,error=error,eip=hex(u.reg_read(UC_X86_REG_EIP)),eax=hex(u.reg_read(UC_X86_REG_EAX)),registers={name:hex(u.reg_read(reg)) for name,reg in [('ecx',UC_X86_REG_ECX),('edx',UC_X86_REG_EDX),('esi',UC_X86_REG_ESI),('edi',UC_X86_REG_EDI),('ebp',UC_X86_REG_EBP),('esp',UC_X86_REG_ESP)]},native_addresses=len(visited),last_calls=calls[-30:],output_bits=list(struct.unpack('<4I',u.mem_read(obj+0x1c0,16))),limits=['Exploratory single-input probe; original runtime initialization/locale and scanner semantics not qualified.'])
(r/'data/4.20/native_hud_formatted_scanner_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
proof['locale_pointers']={hex(p):hex(read(p)) for p in [0x122323c,0x1222dd4]}
proof['anchor_output']=list(struct.unpack('<4i',u.mem_read(obj+0x1a8,16)))
print(json.dumps(proof))
