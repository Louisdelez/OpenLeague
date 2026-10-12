from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8'))['source']).parent
for relative in ['DATA/CFG/defaults/Game.cfg','DATA/CFG/defaults/Game.inibin','Config/game.cfg','Game.cfg']:
 p=source/relative
 if p.exists():
  raw=p.read_bytes();print(json.dumps(dict(path=str(p),bytes=len(raw),sha256=hashlib.sha256(raw).hexdigest(),preview=raw[:500].decode('utf-8',errors='replace'))))
 else:print(json.dumps(dict(path=str(p),exists=False)))
for relative in ['DATA/CFG/defaults','Config']:
 p=source/relative
 if p.is_dir():print(json.dumps(dict(directory=str(p),files=[f.name for f in p.iterdir()][:60])))
