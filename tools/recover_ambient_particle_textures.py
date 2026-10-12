from pathlib import Path
import json,hashlib,datetime
from PIL import Image
r=Path(__file__).resolve().parents[1];deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');folder=deploy/'DATA/Particles';d=json.loads((r/'data/4.20/particles/TT_Fire_03_Orange.json').read_text());references={}
for group,fields in d['sections'].items():
 for field,value in fields.items():
  if isinstance(value,str) and any(x in field for x in ['texture','normal-map','rgba']) and value.lower().endswith(('.tga','.dds')):references.setdefault(value,[]).append({'group':group,'field':field})
files={}
for p in deploy.rglob('*'):
 if p.is_file() and p.suffix.lower() in ['.dds','.tga']:files.setdefault(p.stem.lower(),[]).append(p)
out=r/'assets/particles/map10';out.mkdir(parents=True,exist_ok=True);proofs=[];missing=[]
for name,uses in sorted(references.items()):
 candidates=files.get(Path(name).stem.lower(),[])
 if not candidates:missing.append({'reference':name,'uses':uses});continue
 hashes={hashlib.sha256(p.read_bytes()).hexdigest() for p in candidates};assert len(hashes)==1,('Ambiguous native texture',name,candidates)
 source=candidates[0];im=Image.open(source).convert('RGBA');target=out/(source.stem+'.png');im.save(target)
 restored=Image.open(target).convert('RGBA');assert im.tobytes()==restored.tobytes()
 proofs.append({'native_reference':name,'uses':uses,'source':str(source),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'asset':str(target.relative_to(r/'assets')),'png_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'dimensions':im.size,'rgba_pixel_sha256':hashlib.sha256(im.tobytes()).hexdigest(),'rgba_pixels_equal':True})
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'textures':proofs,'native_texture_count':len(proofs),'missing_native_textures':missing,'group_part_fields':{k:v for k,v in d['sections']['System'].items() if k.startswith('GroupPart')},'passed':True,'complete':False,'limits':['RGBA pixels match the decoded original DDS; native sampler/mip/gamma and particle shader semantics remain incomplete.','Color lookup, atlas and distortion textures retained separately; no generated fire replaces originals.','Texture recovery does not prove particle playback or visible native equivalence.']}
(r/'data/4.20/ambient_particle_textures.json').write_text(json.dumps(proof,indent=2)+'\n');(r/'docs/map_ambient_texture_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('Native particle textures:',len(proofs),'images with identical RGBA pixels; missing:',[x['reference'] for x in missing])
