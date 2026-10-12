"""Read-only native executable string/xref discovery; no runtime behavior qualification."""
from pathlib import Path
import sys,re,struct,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
n=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
b=n.read_bytes();p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
matches=[]
for m in re.finditer(rb'[\x20-\x7e]{5,}\x00',b):
    s=m.group()[:-1].decode('ascii')
    if not any(t in s.lower() for t in ['simple_projected','offset_and_scale','sin_and_cos','shared/particles','shared\\particles','p-texture','projection-y','particles/%','particles\\%']):continue
    try: va=base+p.get_rva_from_offset(m.start())
    except pefile.PEFormatError: continue
    refs=[]
    for section in p.sections:
        if not section.Characteristics & 0x20000000:continue
        data=section.get_data(); off=0
        while True:
            at=data.find(struct.pack('<I',va),off)
            if at<0: break
            refs.append(hex(base+section.VirtualAddress+at));off=at+4
    matches.append({'string':s,'address':hex(va),'potential_code_references':refs})
proof={'source':str(n),'sha256':hashlib.sha256(b).hexdigest(),'complete':False,'matches':matches,'limits':['Raw immediate-address matches are discovery candidates, not verified instruction/function boundaries or native behavior.','No path precedence or projection constants qualified by string matches.']}
Path('E:/OpenLeague/docs/native_projection_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
for item in matches:print(json.dumps(item))
