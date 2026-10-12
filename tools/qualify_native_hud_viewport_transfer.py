from pathlib import Path
import json,hashlib,datetime,shutil,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD viewport prerequisites','exec'))
u.mem_map(0x50000000,0x40000);game=0x50000000;root=vector+0x6000;fonts=vector+0x7000;textures=vector+0x8000;elements=vector+0xe000;groups=vector+0x14000;backend_calls=[]
def hook(uc,address,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if address in [0x99e800,0x9a60a0]:backend_calls.append(dict(function=hex(address),width=read(sp+4),height=read(sp+8)));finish(0,8);return
 if address==0x9a95b0:finish(0,4);return
 if address==0x9a7212:uc.reg_write(UC_X86_REG_EIP,end);return
 scanner_hook(uc,address,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for width,height,flags in itertools.product([1280,1920],[800,1080],[2,3,10]):
 backend_calls.clear();u.mem_write(root,b'\0'*0x100);u.mem_write(elements,b'\xa5'*0x240);u.mem_write(groups,b'\0'*0x100);w(elements+0x18,0x3f800000);w(0,0);w(0x2d79078,game);w(game+0x20328,width);w(game+0x2032c,height);w(root+4,vector+0x15000);w(root+8,vector+0x16000);w(root+0xc,fonts);w(root+0x10,textures);w(root+0x14,elements);w(root+0x18,groups);w(root+0x24,flags)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,root);u.emu_start(0x9a7110,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read(elements+0x1c)==width and read(elements+0x20)==height and read(elements+0x18)==0x3f800000,(width,height,[hex(read(elements+off)) for off in [0x18,0x1c,0x20]],backend_calls,[hex(read(root+off)) for off in [0x14,0x18,0x2c,0x30]])
 assert read(groups+0x40)==width and read(groups+0x44)==height
 assert len(backend_calls)==2 and all(c['width']==width and c['height']==height for c in backend_calls)
 cases.append(dict(width=width,height=height,root_flags=flags,element_width=read(elements+0x1c),element_height=read(elements+0x20),group_width=read(groups+0x40),group_height=read(groups+0x44),scalar_bits=read(elements+0x18),backend_calls=list(backend_calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original9A7110accepted resize branch through9A7212transfers supplied Game20328/2032Cdimensions into element/group owners; preserves supplied constructor scalar1.0.','Font/texture resize and scene file initialization supplied at call boundaries; resource cache invalidation/GPU behavior not qualified.','Upstream Game dimensions producer, settings overrides, later bootstrap and normal resize event integration remain separate.'])
(r/'data/4.20/native_hud_viewport_transfer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
