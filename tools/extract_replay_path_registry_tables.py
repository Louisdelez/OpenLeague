from pathlib import Path
import hashlib,json,sys,pefile
binary=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=binary.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image()
regions=[{'address':p,'bytes':n,'hex':image[p-base:p-base+n].hex()}for p,n in [(0x2d8bab4,4),(0x2d8bac0,0x10a8),(0x10caa28,9),(0x10caa34,4),(0x1085eac,8)]]
Path(sys.argv[1]).write_text(json.dumps({'native_sha256':digest,'regions':regions,'runtime_image_regions':[[0x2d8bab4,4],[0x2d8bac0,0x10a8]],'limits':['First two regions are required runtime globals. Remaining entries identify exact LogFile%1, %s= and typed formatting table data; Rust format behavior is independently compared with native output. No singleton vtable exists.']},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_sha256':digest,'regions':len(regions)}))
