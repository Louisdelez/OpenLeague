"""File-backed 4.20 content inventory. Presence is not release availability or implementation."""
from pathlib import Path
from datetime import datetime, timezone
import json,hashlib
root=Path(__file__).resolve().parents[1]
deploy=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy')
community=Path(r'D:\LeagueOfLegendsV2\4.20\GameServer\Content\LeagueSandbox-Default')
folders={p.name.casefold():p for p in (deploy/'DATA/Characters').iterdir() if p.is_dir()}
champions=json.loads((root/'data/4.20/champions.json').read_text(encoding="utf-8"))
entries=[]
for champion in champions:
    source=folders.get(champion['id'].casefold()) or folders.get(champion['name'].casefold())
    files=list(source.rglob('*')) if source else []
    files=[p for p in files if p.is_file()]
    entries.append({'id':champion['id'],'native_directory':str(source) if source else None,'file_count':len(files),'zero_byte_files':[str(p.relative_to(source)) for p in files if p.stat().st_size==0], 'files':[{'path':str(p.relative_to(source)),'bytes':p.stat().st_size} for p in files], 'kit_implementation_complete':False,'source_behaviors_qualified':False})
sections={}
for name in ['Items','Spells','Stats','Talents','Maps','Globals']:
    base=community/name
    rows=[]
    for p in sorted(base.rglob('*.json')):
        data=p.read_bytes()
        try:json.loads(data);parse_ok=True
        except (ValueError,UnicodeDecodeError):parse_ok=False
        rows.append({'path':str(p.relative_to(community)),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data),'valid_json':parse_ok})
    sections[name]={'json_count':len(rows),'invalid_json_count':sum(not x['valid_json'] for x in rows),'files':rows,'availability_4_20_qualified':False}
report={'generated_utc':datetime.now(timezone.utc).isoformat(),'native_root':str(deploy),'community_root':str(community),'champion_count':len(entries),'missing_native_champion_directories':[x['id'] for x in entries if x['native_directory'] is None],'champions':entries,'community_sections':sections,'native_level_directories':[p.name for p in sorted((deploy/'LEVELS').iterdir()) if p.is_dir()],'limits':['Filesystem presence does not establish released skins, playable modes or object availability in patch 4.20.','Community JSON is a reference requiring comparison to native data and runtime behavior.','Nonzero Lua bytecode files may contain empty function bodies; file size does not prove server scripts exist.','No champion kit or domain is marked complete by this inventory.']}
(root/'docs/content_reference_inventory.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'champions':len(entries),'missing_native_directories':report['missing_native_champion_directories'],'community_json':{k:v['json_count'] for k,v in sections.items()},'invalid_json':{k:v['invalid_json_count'] for k,v in sections.items()},'native_level_directories':report['native_level_directories']}))
