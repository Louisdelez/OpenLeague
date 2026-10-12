"""Hash an already reviewed static evidence package; no native execution."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parent
def record(path):
    data=path.read_bytes()
    return {'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
inputs=[
    Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/RiotRadsIO.dll'),
    Path('E:/mapslol3v3/loading_rads_entry_review/manifest.json'),
    Path('E:/mapslol3v3/loading_rads_entry_review/inspect_entry.py'),
    Path('E:/mapslol3v3/loading_rads_entry_review/REVIEW.json'),
    Path('E:/mapslol3v3/loading_rads_entry_review/entry_static.json')]
manifest={'schema':1,'kind':'static_review_only','native_execution':False,
    'production_modified':False,'source_inputs':{str(p):record(p) for p in inputs},
    'files':{p.name:record(p) for p in sorted(ROOT.iterdir()) if p.is_file() and p.name!='manifest.json'}}
for name in ('REVIEW.json','continuation_static.json','delta_review.json'):
    if (ROOT/name).exists():json.loads((ROOT/name).read_text(encoding='utf-8'))
payload=json.dumps(manifest,indent=2)+'\n'
(ROOT/'manifest.json').write_text(payload,encoding='utf-8')
print(json.dumps({'files':len(manifest['files']),'manifest_sha256':hashlib.sha256(payload.encode()).hexdigest()}))
