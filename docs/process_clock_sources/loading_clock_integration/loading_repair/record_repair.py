"""Record the tests-only candidate; never modifies production or candidate."""
from pathlib import Path
from datetime import datetime, timezone
import difflib
import hashlib
import json
import struct

root = Path(__file__).resolve().parent
name = 'audio_replay_windows_loading_packets_tests.rs'
production = Path(r'E:\OpenLeague\crates\core\src') / name
candidate = root / name
base_sha = '1f88e8187e635631134b1c0220d5c535a2dd142db8a8655d74a4077859dcca1c'
candidate_sha = '20b02e9777567e25127b854ebcf47afe77d4f367263fa0d2474e9104d47e4f04'
sha = lambda b: hashlib.sha256(b).hexdigest()
raw = candidate.read_bytes()
assert sha(raw) == candidate_sha
base = production.read_bytes()
if sha(base) == base_sha:
    (root / 'changes.patch').write_text(''.join(difflib.unified_diff(
        base.decode().splitlines(True), raw.decode().splitlines(True),
        fromfile=str(production), tofile=str(candidate))), encoding='utf-8')
    (root / 'base_tests.rs.txt').write_bytes(base)
else:
    # The parent may already have installed the frozen candidate.
    assert sha(base) == candidate_sha, 'Unexpected production change'

manifest_path = Path(r'E:\OpenLeague\data\4.20\runtime\replay_runtime_image_manifest.json')
image_path = manifest_path.with_name('replay_runtime_image.bin')
m = json.loads(manifest_path.read_text())
image = image_path.read_bytes()
slots = []
for address, expected in [(0x10afed4, 0x72ad90), (0x10afed8, 0x72ae40), (0x2d787b8, 0)]:
    region = next(r for r in m['regions'] if r['address'] <= address
                  and address + 4 <= r['address'] + r['size'])
    value = struct.unpack_from('<I', image, region['payload_offset'] + address - region['address'])[0]
    assert value == expected
    slots.append({'address': hex(address), 'value': hex(value), 'region': region['name']})

receipt = {
    'created_utc': datetime.now(timezone.utc).isoformat(),
    'scope': 'Tests-only diagnostic service publication; no production modification by this agent',
    'production_file': str(production), 'base_sha256': base_sha,
    'candidate_file': str(candidate), 'candidate_sha256': candidate_sha,
    'image_file': str(image_path), 'image_sha256': sha(image),
    'source_native_sha256': m['native_sha256'],
    'verified_image_words': slots,
    'test_changes': [
        'Publish the actual configured service pointer before the three first-name consumers',
        'Check pointer identity and native vtable slots +48/+4C without replacing either',
        'Restore SERVICE_GLOBAL after recipient destruction and before manager/service closure',
        'Include runtime error details when delivery or missing-UI expectation fails',
    ],
    'verification_executed': ['Candidate hash', 'Image words', 'Static binding and teardown ordering review'],
    'rust_compilation_executed': False, 'tests_executed': False,
    'limits': [
        'Normal source producer/lifecycle for SERVICE_GLOBAL remains unported',
        'These are explicit diagnostic bindings, not qualification of normal publication',
        'Root must compile and run the integrated tests',
    ],
}
(root / 'repair_manifest.json').write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'candidate_sha256': candidate_sha, 'manifest': str(root / 'repair_manifest.json'),
                  'production_observed_sha256': sha(base), 'verified_words': slots}, indent=2))
