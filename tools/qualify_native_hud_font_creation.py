from pathlib import Path
import json,hashlib,datetime,itertools,struct,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'font creation prerequisites','exec'))
manager=vector+0x6000;font=vector+0x7000;name=vector+0x8000;service=vector+0x9000;vtable=vector+0xa000;device=vector+0xb000
u.mem_write(name,b'Gill Sans MT Pro Medium\0');w(service,vtable);w(vtable,vector+0x5100);w(0x2d78dc0,service);w(0x2da52e8,1)
native_calls=[];released=False;inserted=False
def hook(uc,address,size,user):
 global released,inserted
 if address==0x9aa350:
  assert uc.reg_read(UC_X86_REG_ECX)==manager+0x30;finish(font);return
 if address==0x99aa80:
  assert uc.reg_read(UC_X86_REG_ECX)==name and uc.reg_read(UC_X86_REG_EDX)==font+4
  native_calls.append('font_name_assignment');finish(font+4);return
 if address==vector+0x5100:
  assert uc.reg_read(UC_X86_REG_ECX)==service and read(uc.reg_read(UC_X86_REG_ESP)+4)==font+4
  native_calls.append('font_device_request');finish(device if success else 0,4);return
 if address==0x9aa470:
  assert uc.reg_read(UC_X86_REG_ECX)==manager+0x30 and read(uc.reg_read(UC_X86_REG_ESP)+4)==font
  released=True;finish(0,4);return
 if address==0x5bd2f0:
  assert uc.reg_read(UC_X86_REG_ECX)==manager+0x24 and read(read(uc.reg_read(UC_X86_REG_ESP)+4))==font
  inserted=True;finish(0,4);return
 scanner_hook(uc,address,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
factor_bits=read(0x1138a18);assert factor_bits==0x3aaaaaab
source=json.loads((r/'data/4.20/native_hud_font_selection_contract.json').read_text())
sizes=sorted({c['request']['size'] for c in source['cases']}|{0,1,8,768,0x7fffffff,0x80000000,0xffffffff})
heights=[0,1,767,768,800,1080,1440,2160,16384,0x7fffffff,0x80000000,0xffffffff]
cases=[]
for control,height,requested,shadow,success in itertools.product([0x27f,0x37f],heights,sizes,[0,1,255],[False,True]):
 native_calls.clear();released=inserted=False;u.mem_write(manager,b'\0'*0x48);w(manager+4,height);u.mem_write(font,b'\xa5'*0x40)
 u.reg_write(UC_X86_REG_FPCW,control);w(stack,end);w(stack+4,name);w(stack+8,requested);w(stack+12,shadow)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager)
 u.emu_start(0x9a5ec0,end,count=5000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+16
 assert read(font)==requested and read(font+0x20)==0 and read(font+0x24)==(0x14 if shadow else 0x10)
 assert native_calls==['font_name_assignment','font_device_request'] and released==(not success) and inserted==success
 assert u.reg_read(UC_X86_REG_EAX)==(font if success else 0)
 assert read(font+0x28)==(device if success else 0xa5a5a5a5)
 cases.append(dict(control_word=control,height=height,requested_size=requested,shadow_byte=shadow,device_success=success,scaled_size=read(font+0x1c),flags=read(font+0x24),released=released,inserted=inserted,returned_font=success))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9a5ec0',factor_bits=factor_bits,case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original font creation and original SSE CRT ceil execute with supplied x87 control words 0x27f (53-bit) and 0x37f (64-bit); original context producer not yet qualified.','Font pool allocation/release, name assignment, service device creation and list insertion are explicit adapted boundaries. Success/failure routing and initialized fields checked; no original allocator/string/device lifetime qualification.','Supplied source name used for all cases; no GPU glyph rasterization or full native font mapping qualification.','Signed fild conversion and unsigned 2^32 adjustment execute for high-bit dimensions/sizes. This is a font creation contract, not a complete HUD/game claim.'])
(r/'data/4.20/native_hud_font_creation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited),source_sizes=sizes)))
