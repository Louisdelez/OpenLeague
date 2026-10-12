from pathlib import Path
import json,datetime,hashlib,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'font selection prerequisites','exec'))
owner=vector+0x6000;element=vector+0x7000;fonts=vector+0x8000;default_name=vector+0x9000;handle=vector+0xa000;calls=[];removed=False
def hook(uc,address,size,user):
 global removed
 if address==0x9a5ec0:
  sp=uc.reg_read(UC_X86_REG_ESP);ptr=read(sp+4);name=bytes(uc.mem_read(ptr,256)).split(b'\0')[0]
  assert uc.reg_read(UC_X86_REG_ECX)==fonts
  calls.append(dict(name_hex=name.hex(),size=read(sp+8),shadow=read(sp+12)&255));finish(handle if success else 0,12);return
 if address==0x9a53f0:removed=True;assert read(uc.reg_read(UC_X86_REG_ESP)+4)==element;finish(0,4);return
 if address in [0x9a35c3,0x9a32fd]:uc.reg_write(UC_X86_REG_EIP,end);return
 visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook);source=json.loads((r/'data/4.20/native_hud_file_loop_contract.json').read_text());selected={};cases=[]
for c in source['cases']:
 if c['variant']=='restored' or c['path'] not in selected:selected[c['path']]=c
for c in selected.values():
 for record in c['accepted']:
  initial=bytes.fromhex(record['output_hex'])
  if int.from_bytes(initial[0x40:0x44],'little')!=3:continue
  for profile,success in itertools.product(['inline','heap','heap_null'],[False,True]):
   calls.clear();removed=False;u.mem_write(element,initial);u.mem_write(fonts,b'\0'*0x100);w(owner+0xc,fonts)
   if profile=='inline':u.mem_write(fonts+0xc,b'FontA\0');w(fonts+0x20,15);expected=b'FontA'
   elif profile=='heap':u.mem_write(default_name,b'FontB\0');w(fonts+0xc,default_name);w(fonts+0x20,16);expected=b'FontB'
   else:w(fonts+0xc,0);w(fonts+0x20,16);expected=initial[0x1e0:0x200].split(b'\0')[0]
   w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x800);u.reg_write(UC_X86_REG_EBX,owner);u.reg_write(UC_X86_REG_EDI,element);u.emu_start(0x9a33c4,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
   assert len(calls)==1 and calls[0]==dict(name_hex=expected.hex(),size=int.from_bytes(initial[0x204:0x208],'little'),shadow=(int.from_bytes(initial[0x48:0x4c],'little')>>4)&1)
   assert read(element+0x200)==(handle if success else 0) and removed==(not success)
   cases.append(dict(path=c['path'],name=record['name'],profile=profile,success=success,request=calls[0],element_removed=removed))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original Text font selection branch executes on154selected source elements with inline/heap/null supplied manager default string profiles.','Font resolution9A5EC0and element deletion9A53F0are supplied call boundaries; proves request and failure removal routing, not font allocation/GPU glyph loading/deletion lifecycle.','Default font producer, options, prior font release and full file loader remain separate.'])
(r/'data/4.20/native_hud_font_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
