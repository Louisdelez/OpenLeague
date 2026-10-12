from pathlib import Path
import hashlib,json,datetime
OUT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert not (OUT/'manifest.json').exists()
j=json.loads((OUT/'loader_inventory.json').read_text())
assert sha(Path(j['dll_path']))==j['dll_sha256']
assert sha(Path(j['exe_path']))==j['exe_sha256']
m={'schema':1,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'integrated':False,'native_execution':False,
   'kind':'static_x86_RADS_loader_preparation','source_dll_sha256':j['dll_sha256'],'source_exe_sha256':j['exe_sha256'],
   'files':{p.name:{'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(OUT.iterdir()) if p.is_file() and p.name!='manifest.json'}}
(OUT/'manifest.json').write_text(json.dumps(m,indent=2)+'\n')
print(json.dumps({'files':len(m['files']),'manifest_sha256':sha(OUT/'manifest.json')}))
