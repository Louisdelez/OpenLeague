from pathlib import Path
import itertools,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_game_cfg_parser.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native parsing prerequisites','exec'))
saved=None;inputs={};calls=[]
def merge_hook(uc,a,size,user):
 global saved,warnings,exception
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0x6eb840:slots.clear();records.clear();warnings=0;finish(this);return
 if a==0x5ed390:finish(read(sp+4),16);return
 if a==0x8aec00:
  path=cbytes(read(sp+4));flag=read(sp+8);data=inputs[path];calls.append(dict(path=path.decode(),flag=flag,opened=data is not None))
  if data is None:finish(0x80004005,8);return
  saved={reg:uc.reg_read(reg) for reg in [UC_X86_REG_EBX,UC_X86_REG_ESI,UC_X86_REG_EDI,UC_X86_REG_EBP,UC_X86_REG_ESP]};saved['return']=read(sp)
  u.mem_write(frame-0xc0,b'\0'*0xc0);ssowrite(frame-0x40,data+b'\0');w(frame-0xa8,owner);w(frame-0x9c,0);w(frame-0x90,alloc(path));w(frame+12,flag)
  uc.reg_write(UC_X86_REG_EBP,frame);uc.reg_write(UC_X86_REG_ESP,frame-0x100);uc.reg_write(UC_X86_REG_EAX,len(data)+1);uc.reg_write(UC_X86_REG_EIP,0x8aed5d);return
 if a==0x8af242:
  for reg in [UC_X86_REG_EBX,UC_X86_REG_ESI,UC_X86_REG_EDI,UC_X86_REG_EBP]:uc.reg_write(reg,saved[reg])
  uc.reg_write(UC_X86_REG_ESP,saved[UC_X86_REG_ESP]+12);uc.reg_write(UC_X86_REG_EIP,saved['return']);uc.reg_write(UC_X86_REG_EAX,0);saved=None;return
 if 0x8aeb70<=a<0x8aebfb:visited.add(a);return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,merge_hook)
source=r/'data/4.20/configuration/defaults/Game.cfg';actual=source.read_bytes()
samples=[None,b'',b'[Performance]\nEnvironmentQuality=1\n',b'[Performance]\nEnvironmentQuality=1\nEnvironmentQuality=4\n',b'[performance]\nenvironmentquality=2\n',b'[Other]\nPresent=1\n',b'[Performance]\nEnvironmentQuality=true',b'[Performance]\nEnvironmentQuality="4"\n',b'[Performance]\nEnvironmentQuality=\n',b'NoSection=9\n']
defaults=[None,b'',b'[Performance]\nEnvironmentQuality=3\n',b'[Performance]\nEnvironmentQuality=3\nEnvironmentQuality=4\n',b'[Other]\nPresent=2\n',actual]
cases=[]
for primary,baseline in itertools.product(samples,defaults):
 allocation=heap;slots.clear();records.clear();warnings=0;exception=None;calls.clear();saved=None
 u.mem_write(owner,b'\0'*0x180);w(owner+4,sentinel);w(owner+0xc,sentinel);ssowrite(owner+0x14c,b'user.cfg');ssowrite(owner+0x164,b'defaults.cfg');inputs={b'user.cfg':primary,b'defaults.cfg':baseline}
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8aeb70,end,count=5000000)
 assert exception is None and u.reg_read(UC_X86_REG_EIP)==end
 opened=bool(u.reg_read(UC_X86_REG_EAX)&255);assert opened==(primary is not None or baseline is not None)
 assert [c['flag'] for c in calls]==[0,1]
 for row in records:assert ssoread(slots[row['hash']]).decode('latin1')==row['value']
 cases.append(dict(primary=None if primary is None else list(primary),baseline=None if baseline is None else list(baseline),calls=calls.copy(),opened=opened,result=dict(entries=[dict(row) for row in records],warnings=warnings,error=exception)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8aeb70',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['Original dual-load8AEB70 call ordering, duplicate-warning flags, return decision and parsing8AED5D..8AF242/hash branches execute.','8AEC00 file opening/read/close adapted to supplied bytes or missing result; parser entered after I/O and returns controlled success after its original loop.','String/container/search/insert/diagnostic boundaries adapted; a shared map spans both parses. No real filesystem operations.'],limits=['Successful parser and missing-file cases only; full8AEC00 resources/I/O/error/exception paths and allocation/container implementation remain open.','Configuration cache, binary overlays, localized resource predicates, menu/persistence and whole game remain open.'])
(r/'data/4.20/native_config_text_merge_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
