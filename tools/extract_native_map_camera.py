from pathlib import Path
import re,json,hashlib
r=Path(__file__).resolve().parents[1]
context=json.loads((r/'data/4.20/ambient_audio_context.json').read_text(encoding='utf-8-sig'))
bank=Path(context['banks'][0]['path']);deploy=next(p for p in bank.parents if (p/'League of Legends.exe').is_file())
source=deploy/'LEVELS/Map10/Constants.var';raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest()
assert digest=='178d86117826819d02af09477083eae625d418ee4b0b8bff4763a1a56c7b2be2',digest
names=['cam_MinX','cam_MinY','cam_MaxX','cam_MaxY','cam_FarZ','cam_KeyboardOrbitSpeedX','cam_KeyboardOrbitSpeedY'];values={};text=raw.decode('utf-8-sig')
for key in names:
 m=re.search(r'^'+re.escape(key)+r'\s*=\s*([-+0-9.]+)',text,re.M);assert m,key;values[key]=float(m.group(1))
manifest={'source':str(source),'source_sha256':digest,'native_values':values,'rectangle':[values[k] for k in names[:4]],'rectangle_order':'min_x, min_z, max_x, max_z; source Y maps to native horizontal Z in7D1A60','limits':['cam_FarZ qualified through5755C4 raw depth transfer; keyboard orbit values remain recorded only. Generic near50 bootstrap and native config registration/parser remain unqualified.','Runtime config registration/parser is not emulated; native rectangle clamp reads directly traced global variables with these map source values supplied.']}
(r/'data/4.20/camera_map10_settings.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8');print(digest,values)
