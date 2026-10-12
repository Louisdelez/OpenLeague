from pathlib import Path
import json,hashlib,datetime
out=Path(__file__).resolve().parent
sources=json.loads((out/'source_regions.json').read_text());functions=json.loads((out/'call_contracts.json').read_text());constants=json.loads((out/'constants.json').read_text())
assert sources['native_sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
for r in sources['regions']:
    data=bytes.fromhex(r['hex']);assert len(data)==r['size'] and hashlib.sha256(data).hexdigest()==r['sha256']
assert len(constants['table'])==12 and all(bytes.fromhex(r['hex'])==bytes(181) for r in constants['table'])
assert constants['provider_vtable']['28']==0x903ee0
names=['AUDIT.md','extract_static.py','source_regions.json','functions.txt','call_contracts.json','constants.json','operand_candidates.json','extraction_result.json','check_compare.py','compare_windows.txt','record_manifest.py']
files=[]
for name in names:
    p=out/name;data=p.read_bytes();files.append(dict(path=str(p),bytes=len(data),sha256=hashlib.sha256(data).hexdigest()))
result=dict(prepared_at_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),scope='Bounded static audit of standard loading-screen first-record initialization and selected direct providers/ownership dependencies',static_only=True,native_executed=False,rust_compiled=False,production_modified=False,complete=False,source_sha256=sources['native_sha256'],regions=len(sources['regions']),source_bytes=sum(r['size'] for r in sources['regions']),selected_functions=len(functions),reachable_instructions=sum(f['reachable_instructions'] for f in functions),table_rows=12,table_stride=181,table_mapped_initial_bytes_all_zero=True,files=files,next_action='Native empty-name branch57D650 using actual metadata provider, then read-only cache-hit oracles90AD00/72E390/815CF0; real table producers and asset lifetimes before first full standard UI success')
(out/'preparation_manifest.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:result[k] for k in ['static_only','native_executed','regions','source_bytes','selected_functions','reachable_instructions']}))
