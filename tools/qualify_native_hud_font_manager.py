from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'font manager prerequisites','exec'))
fonts=vector+0x8000;owner=vector+0x6000;name=vector+0x9000;assign=None
def hook(uc,address,size,user):
 global assign
 if address==0x9a686e:
  sp=uc.reg_read(UC_X86_REG_ESP);ptr=read(sp);length=read(sp+4);assert uc.reg_read(UC_X86_REG_ECX)==fonts+0xc
  assign=dict(name_hex=bytes(uc.mem_read(ptr,length)).hex(),length=length);uc.reg_write(UC_X86_REG_EIP,end);return
 if address==0x9a6873:uc.reg_write(UC_X86_REG_EIP,end);return
 scanner_hook(uc,address,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);constructors=[]
for prefill in [0,0xa5]:
 u.mem_write(fonts,bytes([prefill])*0x48);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,fonts);u.emu_start(0x9a5be0,end,count=1000)
 assert read(fonts)==read(fonts+4)==0 and read(fonts+8)==0x3f800000 and read(fonts+0x20)==15 and read(fonts+0x1c)==0 and bytes(u.mem_read(fonts+0xc,1))==b'\0'
 constructors.append(dict(prefill=prefill,output_hex=bytes(u.mem_read(fonts,0x48)).hex()))
cases=[]
for width,height,value in itertools.product([1280,1920],[800,1080],[None,b'',b'FontA',b'Font with spaces and a longer name']):
 assign=None;u.mem_write(fonts,b'\xa5'*0x48);w(owner+0xc,fonts);w(owner+0x2c,width);w(owner+0x30,height)
 w(stack+0x800-0x54,0 if value is None else name)
 if value is not None:u.mem_write(name,value+b'\0')
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x800);u.reg_write(UC_X86_REG_EDI,owner);u.emu_start(0x9a683d,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read(fonts)==width and read(fonts+4)==height and (assign is not None)==(value is not None),(width,height,value,read(fonts),read(fonts+4),assign)
 if value is not None:assert assign==dict(name_hex=value.hex(),length=len(value))
 cases.append(dict(width=width,height=height,default_name_hex=None if value is None else value.hex(),assignment_requested=assign))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),constructor_cases=constructors,case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original9A5BE0font manager constructor executes for zero/A5provided allocation storage; initial default string empty.','Original9A683Dinitialization branch copies supplied root viewport and requests string assignment for any nonnull supplied default font, including empty string. Stops before564C20assignment and later bootstrap.','High-level bootstrap receives default font from78D1C0service virtual method38; upstream locale/service result and complete font GPU loading remain unqualified.'])
(r/'data/4.20/native_hud_font_manager_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,constructors=len(constructors),initialization_cases=len(cases),native_addresses=len(visited))))
