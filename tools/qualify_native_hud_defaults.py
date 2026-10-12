from pathlib import Path
import zipfile,json,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_game_cfg_parser.py').read_text(encoding='utf-8').split('\nsamples=')[0],'native HUD defaults parser prerequisites','exec'))
source=r/'data/4.20/archives/menu/HUD.zip';cases=[]
with zipfile.ZipFile(source) as z:
 for name in ['HUD/defaults/FastHUD.ini','HUD/defaults/Chat.ini']:
  data=z.read(name)
  for flag in [0,1]:
   result=parse(data,flag);assert result['error'] is None
   cases.append(dict(name=name,bytes=list(data),flag=flag,result=result,sha256=hashlib.sha256(data).hexdigest()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8aed5d..0x8af242',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),archive_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),cases=cases,adapters=['Original configuration parser/hash branches execute against original FastHUD/Chat bytes. Standard strings/container/diagnostics adapted as in existing native parser qualification.'],limits=['INI parser only; HUD profile selection, atlas loader, layout grammar, widget rendering and interaction remain open.'])
(r/'data/4.20/native_hud_defaults_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),entries=[len(c['result']['entries']) for c in cases],warnings=[c['result']['warnings'] for c in cases])))
