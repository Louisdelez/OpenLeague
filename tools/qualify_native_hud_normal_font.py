from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'normal font prerequisites','exec'))
service=vector+0x6000;entries=vector+0x7000;entry=vector+0x8000;fontmap=vector+0x9000;result=vector+0xa000;lookup_calls=[]
def hook(uc,address,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if address==vector+0x5100:
  ptr=read(sp+4);delta=read(sp+8);old=read(ptr);w(ptr,(old+delta)&0xffffffff);finish(old,8);return
 if address==0xd02ae0:
  out=read(sp+4);key=bytes(uc.mem_read(read(sp+8),32)).split(b'\0')[0];assert key==b'$NormalFont' and uc.reg_read(UC_X86_REG_ECX)==fontmap;lookup_calls.append(key.decode())
  if profile=='success':w(out,result|tag)
  finish(int(profile=='success'),8);return
 scanner_hook(uc,address,size,user)
w(0xfa4210,vector+0x5100);u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for profile,tag,value in itertools.product(['no_entries','null_entry','null_map','missing','success'],range(4),[b'',b'Gill Sans MT Pro Medium',b'Arial Unicode MS']):
 lookup_calls.clear();w(0,0);u.mem_write(service,b'\0'*0xb0);u.mem_write(entry,b'\0'*0x30);w(service+0x24,entries);w(service+0x28,0 if profile=='no_entries' else 2);w(entries,0 if profile=='null_entry' else entry);w(entries+4,entry);w(entry+0x1c,0 if profile=='null_map' else fontmap)
 u.mem_write(result,b'\0'*0x100);w(result+4,2);u.mem_write(result+8,value+b'\0');w(0x1225d70,1)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,service);u.emu_start(0x790020,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 returned=u.reg_read(UC_X86_REG_EAX);assert returned==(result+8 if profile=='success' else 0),(profile,tag,hex(returned))
 assert len(lookup_calls)==int(profile in ['missing','success'])
 cases.append(dict(profile=profile,tag=tag,mapped_name_hex=value.hex(),lookup_keys=list(lookup_calls),returned_name_hex=value.hex() if returned else None,result_refcount=read(result+4)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original790020getter and790100temporary release execute, supplied service first-entry/font-map/string-object storage. First font map only, alias$NormalFont.','Font map lookupD02AE0and InterlockedExchangeAdd supplied; lookup parser/hash, string allocation/lifetime and locale loading remain separate.','Source fontconfig files contain$NormalFont mappings, but active language/fontmap initialization and runtime GPU font loading not qualified.'])
(r/'data/4.20/native_hud_normal_font_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))

