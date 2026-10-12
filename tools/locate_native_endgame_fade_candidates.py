from pathlib import Path
import re,json
s=Path('E:/mapslol3v3/locate_native_endgame_getters.py').read_text(encoding='utf-8')
scope={};exec(s[:s.index('for name in [')],scope)
names=sorted({m.group().decode('ascii') for m in re.finditer(rb'[ -~]{5,}',scope['image']) if any(v in m.group().lower() for v in [b'fade',b'norender',b'mainsfx']) and len(m.group())<140})
Path('E:/mapslol3v3/native_endgame_fade_candidate_names.json').write_text(json.dumps(names,indent=2),encoding='utf-8')
selected=[name for name in names if 'ClientSide' in name or 'Minion' in name or 'MainSFX' in name]
a=s.index('for name in [');b=s.index(']:',a)+2;s=s[:a]+'for name in '+repr(selected)+':'+s[b:];s=s.replace('native_endgame_getter_locations.json','native_endgame_fade_candidate_locations.json').replace('print(json.dumps(rows,indent=2))','print(json.dumps([dict(name=row["name"],matches=len(row["matches"]),refs=sum(len(m["references"]) for m in row["matches"])) for row in rows]))')
exec(compile(s,'native-fade-candidate-symbols','exec'))
