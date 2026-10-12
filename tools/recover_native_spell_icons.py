from pathlib import Path
import json, sys, hashlib, datetime, struct, shutil
from PIL import Image
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/references/lolpytools'))
import lolpytools_inibin2 as ini
def sha(b):return hashlib.sha256(b).hexdigest()
inventory=json.loads((r/'docs/content_reference_inventory.json').read_text(encoding='utf-8-sig'))
native=Path(inventory['native_root']);dirs={x['id']:Path(x['native_directory']) for x in inventory['champions']}
spells=json.loads((r/'data/4.20/native_spells_420.json').read_text(encoding='utf-8-sig'))
assert len(spells)==488 and len({(x['champion'].lower(),x['slot']) for x in spells})==488
global_files={}
for p in (native/'DATA/Spells/Icons2D').rglob('*'):
 if p.is_file():global_files.setdefault(p.name.casefold(),[]).append(p)
character_files={}
for key,d in dirs.items():
 index={}
 for p in d.rglob('*'):
  if p.is_file() and p.suffix.casefold()=='.dds' and 'deprecated' not in [s.casefold() for s in p.relative_to(d).parts]:index.setdefault(p.name.casefold(),[]).append(p)
 character_files[key]=index
entries=[];unknown=[]
for s in spells:
 key=s['champion'].lower();config=native/s['native_resource'];decoded=ini.from_file(str(config))['UNKNOWN_HASHES']
 fields=['InventoryIcon']+sorted(k for k in s['values'] if k.startswith('InventoryIcon') and k!='InventoryIcon')
 for field in fields:
  filename=s['values'].get(field,'');native_value=decoded.get(ini.ihash('SpellData',field))
  record=dict(champion=key,slot=s['slot'],spell=s['spell'],field=field,filename=filename,config=str(config),config_sha256=sha(config.read_bytes()),field_hash=ini.ihash('SpellData',field))
  if not filename:
   if field=='InventoryIcon':unknown.append(dict(**record,reason='empty primary icon'))
   continue
  if native_value!=filename:unknown.append(dict(**record,reason='native field does not match exported reference',native_value=native_value));continue
  candidates=character_files[key].get(filename.casefold(),[])+global_files.get(filename.casefold(),[])
  if not candidates:unknown.append(dict(**record,reason='source file not found in character or global icon directories'));continue
  hashes={sha(p.read_bytes()) for p in candidates}
  if len(hashes)!=1:unknown.append(dict(**record,reason='different candidate bytes; original lookup precedence unqualified',candidates=[dict(source=str(p),sha256=sha(p.read_bytes())) for p in candidates]));continue
  source=candidates[0];raw=source.read_bytes();assert raw[:4]==b'DDS ' and len(raw)>128
  height,width=struct.unpack_from('<II',raw,12);assert height>0 and width>0
  with Image.open(source) as image:
   image.load();assert image.size==(width,height);rgba=image.convert('RGBA').tobytes()
  asset=Path('ui/native420/spells')/key/(str(s['slot'])+'-'+field+'.dds');out=r/'assets'/asset;out.parent.mkdir(parents=True,exist_ok=True)
  if out.exists():assert out.read_bytes()==raw
  else:shutil.copy2(source,out)
  assert out.read_bytes()==raw
  entries.append(dict(**record,source=str(source),source_sha256=sha(raw),asset=asset.as_posix(),bytes=len(raw),width=width,height=height,mips=max(1,struct.unpack_from('<I',raw,28)[0]),fourcc=raw[84:88].decode('ascii',errors='replace'),decoded_rgba_sha256=sha(rgba),equivalent_candidates=[str(p) for p in candidates]))
primary=sum(e['field']=='InventoryIcon' for e in entries)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,required_primary_icons=488,recovered_primary_icons=primary,recovered_variant_icons=len(entries)-primary,entries=entries,unresolved=unknown,limits=['Native SpellData/InventoryIcon fields verified against supplied original inibin files; DDS bytes copied without alteration and all recovered images decoded. Community parser is used; original client lookup precedence is not emulated.','Variant fields recovered only where present in the488primary QWER records. Secondary spells, forms, skins, passives and dynamic selection are not covered by this manifest.','Recovery is resource preparation only. HUD binding, enabled/disabled/rank/cooldown states, interaction and graphical icon rendering remain unqualified. No complete champion kit or domain is closed.'])
(r/'data/4.20/native_spell_icons.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/recover_native_spell_icons.py'),r/'tools/recover_native_spell_icons.py')
print(json.dumps({'primary_icons':primary,'variant_icons':len(entries)-primary,'unresolved':len(unknown),'unresolved_sample':unknown[:4],'complete':False}))
