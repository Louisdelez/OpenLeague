"""Verify resources against the recorded import receipt in this project."""
import hashlib,json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
receipt=json.loads((root/'docs/import_receipt.json').read_text(encoding='utf-8'))
failures=[]
for entry in receipt['resources']:
    target=(root/entry['target']).resolve()
    assert root.resolve() in target.parents
    if not target.is_file() or hashlib.sha256(target.read_bytes()).hexdigest()!=entry['sha256']:failures.append(entry['target'])
result={'checked':len(receipt['resources']),'mismatches':failures,'passed':not failures,'limits':'File provenance only; not a gameplay or visual acceptance test.'}
(root/'docs/resource_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result))
raise SystemExit(bool(failures))
