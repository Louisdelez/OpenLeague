from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native library version prerequisites','exec'))
memory=vector+0x6000;library=vector+0x7000;scratch=vector+0x9000;output=vector+0xe000;allocations=[]
def hook(uc,a,size,user):
 if a==0xc3f4a0:
  sp=uc.reg_read(UC_X86_REG_ESP);assert read(sp+4)==memory;size=read(sp+8);error=read(sp+12);assert size in [0xc8,0x4000];w(error,0);allocations.append(size);finish(library if size==0xc8 else scratch);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for prefill in [0,0xa5]:
 allocations.clear();u.mem_write(library,bytes([prefill])*0xc8);w(output,0);w(stack,end);w(stack+4,memory);w(stack+8,output);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xc3c040,end,count=3000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==0 and read(output)==library
 version=[read(library+offset) for offset in [0xc,0x10,0x14]];assert version==[2,4,8] and read(library+0xc4)==1 and allocations==[0xc8,0x4000]
 cases.append(dict(prefill=prefill,version=version,reference_count=read(library+0xc4),allocations=list(allocations)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xc3c040',native_addresses=len(visited),version=[2,4,8],cases=cases,limits=['Original library constructor executes and stores2/4/8version fields and reference count. Supplied allocation boundary/storage; allocation/module/rasterization behavior not qualified.','Version is established; compiler options, native patches, interpreter/hinting/load flags and glyph bitmap equality remain open.'])
(r/'data/4.20/native_freetype_version_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
destination=r/'tools'/Path(__file__).name
if destination.resolve()!=Path(__file__).resolve():shutil.copy2(Path(__file__),destination)
print(json.dumps(dict(passed=True,version=version,native_addresses=len(visited))))
