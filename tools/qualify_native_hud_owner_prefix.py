from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD owner prefix prerequisites','exec'))
owner=vector+0x6000
def hook(uc,address,size,user):
 visited.add(address)
 if address==0x9a3a54:uc.reg_write(UC_X86_REG_EIP,end)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for fill in [0,0xa5]:
 u.mem_write(owner,bytes([fill])*0x240);w(0,0);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x9a3a00,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read(owner+0x18)==0x3f800000
 assert read(owner+0x1c)==read(owner+0x20)==int.from_bytes(bytes([fill])*4,'little')
 cases.append(dict(fill=fill,scalar_bits=read(owner+0x18),width_storage=read(owner+0x1c),height_storage=read(owner+0x20)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9a3a00',stop_boundary='0x9a3a54',case_count=2,native_addresses=len(visited),cases=cases,limits=['Original constructor prefix initializes owner scalar1.0; viewport storage not initialized at this boundary.','Constructor remainder, settings overrides, viewport producers and normal runtime bootstrap remain unqualified.','No full owner constructor/pool/renderer qualification.'])
(r/'data/4.20/native_hud_owner_prefix_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=2,initial_scalar_bits='0x3f800000',viewport_initialized=False)))
