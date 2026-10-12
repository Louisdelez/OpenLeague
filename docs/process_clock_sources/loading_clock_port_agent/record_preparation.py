"""Verify existing receipts and freeze hashes; never compiles or edits production."""
from pathlib import Path
import ast,hashlib,json,re
ROOT=Path(__file__).resolve().parent
PREP=Path('E:/mapslol3v3/loading_clock_preparation')
EXPECTED='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
sha=lambda raw:hashlib.sha256(raw).hexdigest()
native_raw=(ROOT/'native_clock_results.json').read_bytes();native=json.loads(native_raw)
hardware=json.loads((ROOT/'clock_x87_hardware.json').read_text())
assert native['passed'] and native['case_count']==253 and native['native_sha256']==EXPECTED
assert hardware['passed'] and hardware['source_sha256']==sha(native_raw) and hardware['native_sha256']==EXPECTED
assert len(hardware['cases'])==277 and hardware['mismatches']==[]
assert sum(len(c['samples']) for c in native['cases'])==349
assert sum(len(c['events']) for c in native['cases'])==3387
old=json.loads((PREP/'clock_sources.json').read_text())
assert sha(Path(old['native_source']).read_bytes())==EXPECTED
local=ROOT/'source';local.mkdir(exist_ok=True)
sources=[]
for r in old['regions']:
    if r['address'] in [0x993c70,0x993ce0,0xce298a,0xce13e2,0x995850]:
        raw=(PREP/r['path']).read_bytes();assert len(raw)==r['size'] and sha(raw)==r['sha256']
        path=local/Path(r['path']).name;path.write_bytes(raw)
        sources.append({**r,'path':path.relative_to(ROOT).as_posix()})
assert len(sources)==5
(ROOT/'source/native_sources.json').write_text(json.dumps(dict(native_sha256=EXPECTED,preparation_sources_sha256=sha((PREP/'clock_sources.json').read_bytes()),regions=sources),indent=2)+'\n')
for script in ROOT.glob('*.py'):ast.parse(script.read_text(encoding='utf-8'))
tests=re.findall(r'#\[test\]\s*fn\s+(\w+)',(ROOT/'audio_native_process_clock_tests.rs').read_text())
assert len(tests)==4
records=[]
for path in sorted(ROOT.rglob('*')):
    if path.is_file() and path.name!='manifest.json':
        raw=path.read_bytes();records.append(dict(path=path.relative_to(ROOT).as_posix(),bytes=len(raw),sha256=sha(raw)))
result=dict(schema=1,status='Oracle natif et x87 physique vérifiés; Rust non compilé',frozen=True,native_sha256=EXPECTED,
            native_execution_run=True,native_sequences=253,native_calls=349,native_events=3387,hardware_samples=277,hardware_mismatches=0,
            rust_compilation_attempted=False,rust_tests_run=False,rust_tests_passed=None,planned_rust_tests=tests,
            windows_connected=False,client_producer_changed=False,production_integrated=False,
            boundary_functions=['CE5247','CE290B','CE2934','KERNEL32!QueryPerformanceCounter','KERNEL32!QueryPerformanceFrequency'],
            x87_control_word=0x37f,limits=['Mutex allocation, synchronization, concurrency and shutdown remain unqualified boundaries.',
            'QPF untouched bytes are controlled inputs, never invented Windows outputs. Native BOOL values remain ignored.',
            'Physical x87 output bits match; arbitrary control words and status/exception side effects remain unqualified.',
            'Proposed Rust has NOT been compiled or run. No code from this preparation is integrated in production.'],files=records)
(ROOT/'manifest.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
# Verify every written artifact, including the explicit non-compilation status.
receipt=json.loads((ROOT/'manifest.json').read_text(encoding='utf-8'))
for r in receipt['files']:
    raw=(ROOT/r['path']).read_bytes();assert len(raw)==r['bytes'] and sha(raw)==r['sha256']
assert receipt['rust_compilation_attempted'] is False and receipt['rust_tests_run'] is False
print(json.dumps(dict(verified=True,files=len(records),rust_status='Rust non compilé',
                     manifest_sha256=sha((ROOT/'manifest.json').read_bytes()),
                     native_results_sha256=sha(native_raw),
                     rust_source_sha256=sha((ROOT/'audio_native_process_clock.rs').read_bytes()),
                     rust_tests_sha256=sha((ROOT/'audio_native_process_clock_tests.rs').read_bytes()))))
