from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
owner=terrain+0x2000;handle=0x12340002;cases=[]
for team_tag,lifetime,has_owner,radius in itertools.product([100,200],[0.,0.2,2.],[False,True],[200.,1350.]):
 u.mem_write(obj,bytes([0xcc])*0x80);u.mem_write(owner,bytes(0x2000));write32(owner+8,handle)
 words=[0,55,66,team_tag,owner if has_owner else 0]
 args=struct.pack('<5I6f',*words,128.,64.,lifetime,radius,7684.,6934.)
 write32(sp,end);u.mem_write(sp+4,args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x6b0790,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==obj
 offsets=[4,8,0xc,0x10,0x14,0x18,0x1c,0x20,0x24,0x28,0x2c,0x30,0x38,0x3c,0x40,0x48,0x4c,0x50,0x54,0x58]
 cases.append(dict(team_tag=team_tag,lifetime=lifetime,has_owner=has_owner,radius=radius,result_words={hex(offset):read32(obj+offset) for offset in offsets},cached_owner=bool(read32(obj+0x34)),applied=bool(u.mem_read(obj+0x44,1)[0]),generation_dirty=bool(u.mem_read(obj+0x45,1)[0]),pending=bool(u.mem_read(obj+0x5c,1)[0])))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b0790',native_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Complete original base source constructor executes with null weak provider and supplied owner pointer/team-tag argument. Derived circle/cone constructors and actual source creation callers not executed.','Source+28/+2C inputs55/66 are opaque identifiers; their producers are unqualified. Tags100/200 match values inspected in source filtering; full team mapping/caller provenance remains open.','Non-null weak provider acquisition and complete actor/provider construction, removal queue/destruction and ordinary fog rendering remain open.'])
(r/'data/4.20/fow_source_constructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
