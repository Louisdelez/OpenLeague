"""Recover actual Annie SpellData VFX references; retain ambiguous/unresolved data."""
from pathlib import Path
import ast,struct,sys,importlib.util,json,hashlib,datetime,re,shutil
from PIL import Image
r=Path('E:/OpenLeague');native=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
sys.path.insert(0,str(r/'tools'));from native_troy import decode,key_hash
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def module(n,p):
 s=importlib.util.spec_from_file_location(n,p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
rd=module('annie_vfx_reader',r/'tools/references/lolpytools/lolpytools_inibin2.py');fx=module('annie_vfx_fixer',r/'tools/references/lolpytools/lolpytools_troybin_fix.py')
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct};exec(compile(ast.Module(body=[x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name in ['ini','hashkey']],type_ignores=[]),'native','exec'),ns)
source=Path('D:/LeagueOfLegendsV2/4.20/GameServer/GameServerLib/Content/SpellData.cs')
# Names from supplied community reader, values exclusively from native INIBIN.
names=sorted(set(re.findall(r'file\.Get\w+\("SpellData",\s*"([^"]+)"',source.read_text(encoding='utf-8-sig'))))
names+=['MissileBoneName','MissileTargetHeightAugment','ParticleStartOffset']
folders=[native/'DATA/Characters/Annie/Skins/Base/Particles',native/'DATA/Shared/Particles',native/'DATA/Particles']
index={}
for folder in folders:
 for p in folder.iterdir():
  if p.is_file():index.setdefault((p.stem.lower(),p.suffix.lower()),[]).append(p)
def candidates(name,extensions):
 return [p for ext in extensions for p in index.get((Path(name).stem.lower(),ext),[])]
bindings=[];effects={}
for p in sorted((native/'DATA/Characters/Annie/Spells').glob('*.inibin')):
 raw=ns['ini'](p);named={k:raw[ns['hashkey']('SpellData',k)] for k in names if ns['hashkey']('SpellData',k) in raw}
 refs=[]
 for h,v in raw.items():
  if isinstance(v,str) and v.lower().endswith(('.troy','.troybin')):
   keys=[k for k in names if ns['hashkey']('SpellData',k)==h]
   c=candidates(v,['.troybin']);unique={sha(x) for x in c};resolved=c[0] if len(unique)==1 else None
   entry={'native_hash':h,'field_names':keys,'reference':v,'candidates':[str(x) for x in c],'resolution':'unique-content' if resolved else 'missing' if not c else 'ambiguous','source':str(resolved) if resolved else None}
   refs.append(entry)
   if resolved:effects.setdefault(resolved,[]).append({'spell':p.stem,**entry})
 bindings.append({'spell':p.stem,'source':str(p),'sha256':sha(p),'named_fields':named,'effect_references':refs})
out=r/'data/4.20/particles/annie';out.mkdir(parents=True,exist_ok=True)
asset=r/'assets/particles/annie';asset.mkdir(parents=True,exist_ok=True)
texture_uses={};receipts=[]
for p,uses in effects.items():
 raw=decode(p);ref=rd.from_file(str(p));fx.fix(ref);known=[]
 for section,values in ref['Values'].items():
  for name,v in values.items():
   h=key_hash(section,name);field=raw[h];value=field['value'];expected=rd.sanitize_str(value) if isinstance(value,str) else value
   normal=lambda x:list(x) if isinstance(x,tuple) else x
   assert normal(expected)==normal(v),(p,section,name)
   known.append({'section':section,'name':name,'native_hash':h,**field})
   if isinstance(v,str) and name in ['p-texture','p-meshtex','p-rgba','p-normal-map','p-distortion','p-alphamap']:
    texture_uses.setdefault(v,[]).append({'effect':p.stem,'group':section,'field':name})
 unknown={str(h):f for h,f in raw.items() if h not in {x['native_hash'] for x in known}}
 assert len(known)+len(unknown)==len(raw)
 target=out/(p.stem+'.json')
 target.write_text(json.dumps({'native_file':str(p),'source_sha256':sha(p),'sections':ref['Values'],'fields':known,'unknown_fields':unknown,'semantics_qualified':False},indent=2)+'\n',encoding='utf-8')
 groups=[v for k,v in ref['Values'].get('System',{}).items() if re.fullmatch('GroupPart[0-9]+',k)]
 receipts.append({'source':str(p),'sha256':sha(p),'contract':str(target.relative_to(r)).replace('\\','/'),'contract_sha256':sha(target),'fields':len(raw),'independent_named_fields_equal':len(known),'unknown_fields':len(unknown),'declared_groups':groups,'missing_groups':[g for g in groups if g not in ref['Values']],'uses':uses})
textures=[]
for name,uses in texture_uses.items():
 c=candidates(name,['.dds','.tga']);hashes={sha(p) for p in c}
 entry={'reference':name,'uses':uses,'candidates':[str(p) for p in c],'resolution':'unique-content' if len(hashes)==1 else 'missing' if not c else 'ambiguous'}
 if len(hashes)==1:
  p=c[0];im=Image.open(p).convert('RGBA');target=asset/(p.stem+'.png')
  if target.exists():assert Image.open(target).convert('RGBA').tobytes()==im.tobytes()
  else:im.save(target)
  assert Image.open(target).convert('RGBA').tobytes()==im.tobytes()
  entry.update(source=str(p),source_sha256=sha(p),asset=str(target.relative_to(r/'assets')).replace('\\','/'),png_sha256=sha(target),dimensions=list(im.size),rgba_sha256=hashlib.sha256(im.tobytes()).hexdigest(),pixels_equal=True)
 textures.append(entry)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_spell_bindings':bindings,'field_name_source':{'path':str(source),'sha256':sha(source),'kind':'Supplied community reader supplies names, not original runtime semantics'},'effects':receipts,'textures':textures,'summary':{'spell_files':len(bindings),'effect_files':len(receipts),'native_fields':sum(x['fields'] for x in receipts),'independent_named_fields_equal':sum(x['independent_named_fields_equal'] for x in receipts),'unknown_fields':sum(x['unknown_fields'] for x in receipts),'pixel_exact_textures':sum(x.get('pixels_equal',False) for x in textures),'unresolved_textures':sum(x['resolution']!='unique-content' for x in textures)},'limits':['Actual native SpellData references recovered; no substitute old Disintegrate_mis for Annie_Q_mis.','Path precedence not inferred when candidate content differs; ambiguous and missing references remain open.','Unknown hashes/raw byte fields retained without assigning guessed meanings.','Recovery does not implement native emitters, attachment, timing, audio or skins. Original runtime fidelity and client consumers incomplete.']}
(r/'docs/annie_spell_vfx_sources.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copyfile(Path(__file__),r/'tools/recover_annie_spell_vfx.py');print(json.dumps(proof['summary']))
