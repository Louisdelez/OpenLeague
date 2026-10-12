from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_zip_central_directory.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native ZIP open prerequisites','exec'))
central_hook=hook;nameptr=0x40014080;fallback=False;open_ok=True
def open_hook(uc,a,size,user):
 global fallback
 if a==0xc9951e:
  sp=uc.reg_read(UC_X86_REG_ESP);assert cbytes(read(sp+4))==b'controlled.zip';finish(stream if open_ok else 0);return
 if a==0x8b9a10:fallback=True;finish(0);return
 if 0x8b9510<=a<0x8b963e:visited.add(a);return
 if a==0xc9ce75:
  global pos
  sp=uc.reg_read(UC_X86_REG_ESP);assert read(sp+4)==stream
  value=read(sp+8);value=value if value<0x80000000 else value-0x100000000;origin=read(sp+12)
  assert origin in [0,1,2];pos=([0,pos,len(payload)][origin])+value;assert pos>=0
  calls.append(['seek',pos,origin]);finish(0);return
 central_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,open_hook);u.mem_write(0x2d77b20,b'\x01');w(0x14bef58,0);u.mem_write(nameptr,b'controlled.zip\0')
archives=[];cases=[]
for source in sorted(Path('D:/LeagueOfLegendsV2/4.20/Client').rglob('*.zip')):
 data=source.read_bytes();archive_id=len(archives);archives.append(dict(path=str(source),sha256=hashlib.sha256(data).hexdigest()))
 for scenario in ['original','bad_start_signature','missing_end_signature','disk_9999','open_failed']:
  mutable=bytearray(data);eocd=mutable.rfind(b'PK\x05\x06');assert eocd>=0
  if scenario=='bad_start_signature':mutable[0]=0
  if scenario=='missing_end_signature':mutable[eocd]=0
  if scenario=='disk_9999':mutable[eocd+4:eocd+6]=(9999).to_bytes(2,'little')
  payload=bytes(mutable);pos=0;fallback=False;open_ok=scenario!='open_failed';allocation=0x41000000;calls.clear();u.mem_write(archive,b'\0'*0x120)
  w(stack,end);w(stack+4,nameptr);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,archive);u.emu_start(0x8b9510,end,count=2000000)
  assert u.reg_read(UC_X86_REG_EIP)==end;success=bool(u.reg_read(UC_X86_REG_EAX));assert success==(scenario not in ['bad_start_signature','open_failed']);assert fallback==(scenario in ['missing_end_signature','disk_9999'])
  count=(read(archive+0x10c)-read(archive+0x108))//32
  cases.append(dict(archive=archive_id,scenario=scenario,success=success,fallback=fallback,entry_count=count,calls=list(calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b9510 + 0x8b97f0',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),archives=archives,cases=cases,adapters=['Native open, initial PK check, fixed399-byte tail scan, disk9999 branch and central reader execute. CRT fopen/read/seek, allocation/vector/cookie adapted.','Fallback local-header scanner8B9A10 adapted as boundary only, without parsing.'],limits=['Native fallback scanner, short archives/tail reads, long ZIP comments, ZIP64 and malformed header lengths remain open.','Normal five native archives qualified; unsupported fallback must remain explicit in Rust.','No full resource-provider/HUD/game proof.'])
(r/'data/4.20/native_zip_open_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
