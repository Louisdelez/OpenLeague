from pathlib import Path
import json,hashlib,shutil,datetime
r=Path('E:/OpenLeague');source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Fonts');dest=r/'assets/fonts/native4.20';rows=[]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for p in sorted(source.rglob('*')):
 if not p.is_file():continue
 relative=p.relative_to(source);target=dest/relative;target.parent.mkdir(parents=True,exist_ok=True)
 original_sha=sha(p)
 if target.exists():assert sha(target)==original_sha,'preserve differing existing asset: '+str(target)
 else:shutil.copy2(p,target)
 assert sha(target)==original_sha
 rows.append(dict(source=str(p),path=target.relative_to(r).as_posix(),bytes=p.stat().st_size,sha256=original_sha,extension=p.suffix.lower(),reconstructed=False))
now=datetime.datetime.now(datetime.timezone.utc).isoformat();proof=dict(updated_utc=now,complete=False,source_directory=str(source),source_version='LoL4.20 local supplied client release0.0.1.68',file_count=len(rows),bytes=sum(v['bytes'] for v in rows),files=rows,all_bytes_verified=True,runtime_selected=False,font_mapping_producer_qualified=False,glyph_gpu_rendering_qualified=False,limits=['Original Fonts directory copied byte-for-byte without modifying source or existing differing assets.','File availability does not prove native font-name mapping, glyph rendering, locale/options or full HUD completion.'])
(r/'data/4.20/native_hud_fonts_manifest.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'));d['native_hud_fonts_import']=dict(updated_utc=now,complete=False,file_count=len(rows),bytes=proof['bytes'],proof='data/4.20/native_hud_fonts_manifest.json',all_bytes_verified=True,runtime_selected=False)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(files=len(rows),bytes=proof['bytes'],font_files=sum(v['extension'] in ['.ttf','.otf'] for v in rows),byte_verified=True,runtime_selected=False)))
