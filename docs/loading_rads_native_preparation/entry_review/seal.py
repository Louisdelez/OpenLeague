from pathlib import Path
import hashlib,json,datetime
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
proof=json.loads((ROOT/'entry_static.json').read_text(encoding='utf-8'))
review=json.loads((ROOT/'REVIEW.json').read_text(encoding='utf-8'))
assert proof['source_sha256']==review['source_sha256']
assert proof['tls'] is None and proof['delay_imports']==[]
assert sum(e['target']!='0x0' for e in proof['initializer_tables']['c_error_initializers']['entries'])==5
assert sum(e['target']!='0x0' for e in proof['initializer_tables']['cpp_initializers']['entries'])==68
assert not (ROOT/'manifest.json').exists()
files=['inspect_entry.py','entry_static.json','entry_disassembly.txt','REVIEW.json','seal.py']
result={'schema':1,'frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'native_execution':False,'production_modified':False,'complete':False,
 'scope':'bounded static entry and initializer effect audit; no execution qualification',
 'source':{'path':proof['source'],'bytes':proof['bytes'],'sha256':proof['source_sha256']},
 'decoded_function_entries':len(proof['functions']),'c_initializers':5,'cpp_initializers':68,
 'files':{f:{'bytes':(ROOT/f).stat().st_size,'sha256':sha(ROOT/f)} for f in files},
 'consulted_frozen_manifests':{str(p):sha(p) for p in [Path('E:/mapslol3v3/loading_provider_crt_integration/manifest.json'),Path('E:/mapslol3v3/loading_rads_loader_next/manifest.json')]}}
(ROOT/'manifest.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest_sha256':sha(ROOT/'manifest.json'),'functions':len(proof['functions']),'files':len(files)}))
