from pathlib import Path
import hashlib,json,sys,pefile,struct
binary=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=binary.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image()
regions=[{'address':p,'bytes':size,'hex':image[p-base:p-base+size].hex(),'words':list(struct.unpack('<'+'I'*(size//4),image[p-base:p-base+size]))}for p,size in [(0x10b00c4,4),(0x10b0138,4),(0x1085f4c,12)]]
assert [row['words'] for row in regions]==[[0x729d20],[0x727f00],[0x5a3220,0x5d5b40,0x5d6840]]
proof={'native_sha256':digest,'regions':regions,'new_runtime_regions':[[0x10b00c4,4],[0x10b0138,4]],'control_runtime_region_already_present':[0x1085f4c,12],'limits':['Only scalar-delete entries required by the metadata lifecycle module are extracted. Other base/derived metadata virtual methods are not mapped as supported implementations by this lifecycle qualification.']}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'native_sha256':digest,'regions':len(regions)}))
