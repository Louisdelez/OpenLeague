from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD resize gate prerequisites','exec'))
root=vector+0x6000;elements=vector+0xe000;entered=False
def hook(uc,address,size,user):
 global entered
 if address==0x9a7372:entered=True;uc.reg_write(UC_X86_REG_EIP,end);return
 scanner_hook(uc,address,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for flags,element_flags in itertools.product(range(16),[0,1,2,3,4,6]):
 entered=False;u.mem_write(root,b'\0'*0x100);u.mem_write(elements,b'\0'*0x240);w(0,0);w(root+0x14,elements);w(root+0x24,flags);w(elements+0x198,element_flags)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,root);u.emu_start(0x9a7340,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert entered==bool(flags&4 and (flags&1 or element_flags&2))
 cases.append(dict(root_flags=flags,element_flags=element_flags,entered=entered))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original9A7340gate runs; stop9A7372before Game dimensions and all resource/cache reconstruction.','Gate requires root bit4 and root bit1 or element-owner bit2. Upstream setters and complete resize lifecycle remain unqualified.'])
(r/'data/4.20/native_hud_resize_gate_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
