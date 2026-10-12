from pathlib import Path
import json,hashlib,shutil,datetime,re
r=Path('E:/OpenLeague');deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');menu=deploy/'DATA/menu';dest=r/'data/4.20/font_configuration';files=[];configs=[]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def copy(source,relative):
 target=dest/relative;target.parent.mkdir(parents=True,exist_ok=True);digest=sha(source)
 if target.exists():assert sha(target)==digest,'preserve differing existing file: '+str(target)
 else:shutil.copy2(source,target)
 assert sha(target)==digest
 row=dict(source=str(source),path=target.relative_to(r).as_posix(),bytes=target.stat().st_size,sha256=digest);files.append(row);return row
copy(deploy/'DATA/cfg/defaults/locale.cfg','locale.cfg');copy(deploy.parents[4]/'system/locale.cfg','system_locale.cfg')
locale_cfg=(dest/'locale.cfg').read_text(encoding='utf-8-sig');locale=re.search(r'(?m)^LanguageLocaleRegion\s*=\s*([A-Za-z_]+)\s*$',locale_cfg).group(1)
system_locale=re.search(r'(?m)^locale\s*=\s*([A-Za-z_]+)\s*$',(dest/'system_locale.cfg').read_text()).group(1);assert locale.lower()==system_locale.lower()
for p in sorted(menu.glob('fontconfig_*.txt')):
 row=copy(p,'menu/'+p.name);text=p.read_text(encoding='utf-8-sig');maps=[];libs=[];headers=[]
 for line in text.splitlines():
  if line.startswith('map '):
   m=re.fullmatch(r'map\s+"([^"]+)"\s*=\s*"([^"]+)"\s*',line);assert m,'unsupported source map inventory: '+line;maps.append(dict(alias=m.group(1),name=m.group(2)))
  if line.startswith('fontlib '):libs.append(re.fullmatch(r'fontlib\s+"([^"]+)"\s*',line).group(1))
  if line.startswith('[FontConfig '):headers.append(line)
 assert len(headers)==1 and len(maps)==4 and len(libs)==1
 configs.append(dict(locale=p.stem.removeprefix('fontconfig_'),path=row['path'],sha256=row['sha256'],header=headers[0],maps=maps,fontlibs=libs,normal_font=next(v['name'] for v in maps if v['alias']=='$NormalFont')))
for p in sorted(menu.glob('fonts*.gfx')):copy(p,'menu/'+p.name)
assert any(c['locale']==locale for c in configs)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,source_default_locale=locale,source_system_locale=system_locale,source_locale_files_agree=True,configuration_count=len(configs),file_count=len(files),bytes=sum(v['bytes'] for v in files),all_bytes_verified=True,configurations=configs,files=files,runtime_selected=False,native_fontconfig_parser_qualified=False,native_swf_gfx_alias_resolution_qualified=False,limits=['Original supplied locale/fontconfig/GFXfiles copied and hashes compared; map inventory extracted from observed four-directive source profile.','Agreement of two supplied locale files does not qualify every native language override/selection path.','Native full fontconfig parser, SWF/GFX aliases, active locale initialization and GPU glyph loading remain open.'])
(r/'data/4.20/native_font_configuration_manifest.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'));d['native_font_configuration_import']=dict(complete=False,proof='data/4.20/native_font_configuration_manifest.json',file_count=len(files),configuration_count=len(configs),source_default_locale=locale,all_bytes_verified=True,runtime_selected=False);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(configurations=len(configs),files=len(files),bytes=proof['bytes'],source_default_locale=locale,normal_fonts=sorted({c['normal_font'] for c in configs}),runtime_selected=False)))
