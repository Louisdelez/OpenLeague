from pathlib import Path
import sys,json,hashlib,datetime,shutil,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/references/lolpytools'));import lolpytools_inibin2 as ini
inventory=json.loads((r/'docs/content_reference_inventory.json').read_text(encoding='utf-8'));entries=[];key=ini.ihash('Info','IconSquare');assert key==3606610482
for champion in inventory['champions']:
 d=Path(champion['native_directory']);config=d/(d.name+'.inibin');filename=ini.from_file(str(config))['UNKNOWN_HASHES'].get(key);assert isinstance(filename,str),(champion['id'],filename)
 candidates=[d/f['path'] for f in champion['files'] if Path(f['path']).name.casefold()==filename.casefold()];assert candidates,(champion['id'],filename)
 candidates.sort(key=lambda p:('hud' not in str(p.relative_to(d)).casefold(),str(p)))
 excluded=[p for p in candidates if 'deprecated' in [part.casefold() for part in p.relative_to(d).parts]]
 candidates=[p for p in candidates if p not in excluded];assert candidates,(champion['id'],'only deprecated candidates')
 raw=candidates[0].read_bytes();assert all(p.read_bytes()==raw for p in candidates);assert raw[:4]==b'DDS ' and len(raw)>128
 height,width=struct.unpack_from('<II',raw,12);assert height>0 and width>0
 out=r/'assets/ui/native420/portraits'/(champion['id']+'.dds');out.parent.mkdir(parents=True,exist_ok=True)
 if out.exists():assert out.read_bytes()==raw
 else:shutil.copy2(candidates[0],out)
 entries.append(dict(id=champion['id'],native_directory=str(d),config=str(config),config_sha256=hashlib.sha256(config.read_bytes()).hexdigest(),native_field='Info/IconSquare',field_hash=key,filename=filename,source=str(candidates[0]),source_sha256=hashlib.sha256(raw).hexdigest(),asset=str(out.relative_to(r/'assets')).replace('\\','/'),bytes=len(raw),width=width,height=height,mips=max(1,struct.unpack_from('<I',raw,28)[0]),fourcc=raw[84:88].decode('ascii',errors='replace')))
 if excluded:entries[-1]['excluded_deprecated']=[dict(source=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),reason='Deprecated directory; current HUD file retained') for p in excluded]
assert len(entries)==122 and len({e['id'] for e in entries})==122
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,count=122,entries=entries,limits=['Original base champion Info/IconSquare textures copied byte-for-byte; no skin/form/death portrait variant selection qualified.','Community parser used for extraction; native HUD AvatarImage binding producer and original backend texture decoding/color behavior remain unqualified.'])
(r/'data/4.20/native_champion_portraits.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/recover_native_champion_portraits.py'),r/'tools/recover_native_champion_portraits.py')
print(json.dumps(dict(count=122,bytes=sum(e['bytes'] for e in entries),dimensions=sorted({(e['width'],e['height']) for e in entries}))))
