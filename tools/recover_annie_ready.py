from pathlib import Path
import sys,importlib.util,json,hashlib,datetime
from PIL import Image
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));from native_troy import decode,key_hash
native=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def module(name,path):
 spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
reader=module('ready_ref_reader',r/'tools/references/lolpytools/lolpytools_inibin2.py');fixer=module('ready_ref_fixer',r/'tools/references/lolpytools/lolpytools_troybin_fix.py')
p=native/'DATA/Particles/StunReady.troybin';raw=decode(p);ref=reader.from_file(str(p));fixer.fix(ref);assert not ref['UNKNOWN_HASHES'];entries=[]
for section,values in ref['Values'].items():
 for name,value in values.items():
  key=key_hash(section,name);field=raw[key];decoded=field['value'];expected=reader.sanitize_str(decoded) if isinstance(decoded,str) else decoded
  normal=lambda v:list(v) if isinstance(v,tuple) else v
  assert normal(expected)==normal(value),(section,name,expected,value)
  entries.append({'section':section,'name':name,'native_hash':key,**field})
assert len(entries)==len(raw)
result={'native_file':str(p),'source_sha256':sha(p),'sections':ref['Values'],'fields':entries,'unknown_hashes':{},'semantics_qualified':False}
(r/'data/4.20/particles/StunReady.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
references={}
for group,values in ref['Values'].items():
 for field,value in values.items():
  if isinstance(value,str) and field in ['p-texture','p-meshtex','p-rgba']:references.setdefault(value,[]).append({'group':group,'field':field})
files={}
for folder in [native/'DATA/Particles',native/'DATA/Shared/Particles',native/'DATA/Characters/Annie/Skins/Base/Particles']:
 for p in folder.iterdir():
  if p.is_file() and p.suffix.lower() in ['.dds','.tga']:files.setdefault(p.stem.lower(),[]).append(p)
out=r/'assets/particles/annie';out.mkdir(parents=True,exist_ok=True);textures=[];missing=[]
for name,uses in references.items():
 candidates=files.get(Path(name).stem.lower(),[])
 if not candidates:missing.append({'name':name,'uses':uses});continue
 assert len({sha(p) for p in candidates})==1,(name,candidates)
 source=candidates[0];im=Image.open(source).convert('RGBA');target=out/(source.stem+'.png');im.save(target);assert Image.open(target).convert('RGBA').tobytes()==im.tobytes()
 textures.append({'native_reference':name,'uses':uses,'source':str(source),'source_sha256':sha(source),'asset':str(target.relative_to(r/'assets')).replace('\\','/'),'png_sha256':sha(target),'dimensions':list(im.size),'rgba_sha256':hashlib.sha256(im.tobytes()).hexdigest(),'pixels_equal':True})
declared=[v for k,v in ref['Values']['System'].items() if k.startswith('GroupPart') and 'Importance' not in k]
missing_groups=[name for name in declared if name not in ref['Values']]
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_fields':len(raw),'independent_fields_equal':len(entries),'textures':textures,'missing_textures':missing,'declared_groups':declared,'missing_group_definitions':missing_groups,'base_emitter':'ready1','keyword_excluded':'FreljordAnnie','contract':'data/4.20/particles/StunReady.json','limits':['All98 native fields independently decoded; shader/runtime/attachment semantics not native-runtime-qualified.','GroupPart2 ready2 is declared but no section exists; do not fabricate emitter.','Frost skin sphere emitters retained but not yet implemented.','Original DDS decoded RGBA preserved pixel-for-pixel; sampling/gamma/blending/curves/fidelity need runtime qualification.']}
(r/'docs/annie_ready_sources.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Recovered',len(raw),'native fields and',len(textures),'pixel-exact textures; undefinedgroups',missing_groups,'missingtextures',missing)
