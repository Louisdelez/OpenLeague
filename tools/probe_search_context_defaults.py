from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(prefix,'native prerequisites','exec'))
allocation_cursor=0x70000000
context=0x40008000;frame=sp+0x1000
u.mem_write(context,bytes([0xcc])*0x94);u.mem_write(frame-0x140,bytes(0x140));write32(0x2d78f20,0)
u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESI,context);u.reg_write(UC_X86_REG_EDI,0);u.reg_write(UC_X86_REG_EBX,0)
# Execute original default branch after the allocator/XML decision boundary.
u.emu_start(0x906487,0x9065d8,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==0x9065d8
assert read32(0x2d78f20)==context and read32(context)==0
def native_string(at):
 ptr=read32(at) if read32(at+0x14)>=16 else at
 return bytes(u.mem_read(ptr,read32(at+0x10))).decode('ascii')
fields={hex(offset):native_string(context+offset) for offset in [4,0x1c,0x34,0x4c,0x64,0x7c]}
assert list(fields.values())==['now','Content/Src','Content/Built','Content/Loadable','DATA','-data_overlay_now'],fields
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).parent
config=source/'ToolsConfig.xml';assert not config.exists()
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x906487',stop='0x9065D8',constructor='0x9062A0',global_context='0x2D78F20',native_addresses=len(visited),default_context={'next_null':True,'fields':fields},source_context={'deploy':str(source),'tools_config_present':False},limits=['Original default branch string construction, context constructor, global assignment and temporary string destruction execute. Supplied allocated context and absent prior list.','XML decision/allocator caller skipped explicitly; ToolsConfig.xml absent in supplied extracted deploy but launching directory and command-line overlays are not qualified.','Root fields identify native default descriptors, not recursive lookup paths or populated resource tables. Do not infer FOWTexture selection from this proof.','Original string copies/destruction execute; standard allocation/free/cookie adapters reused. No filesystem or resource search adapters.'])
(r/'data/4.20/search_context_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
