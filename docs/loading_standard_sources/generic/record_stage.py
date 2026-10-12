"""Record generic stage provenance and static checks; no build or execution."""
from pathlib import Path
import hashlib,json,re,difflib
ROOT=Path(__file__).resolve().parent
def h(p):
    with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def row(p):return {'path':str(p),'bytes':p.stat().st_size,'sha256':h(p)}
baseline=json.loads((ROOT/'baseline.json').read_text())
for name,record in baseline.items():
    assert h(Path(record['path']))==record['sha256'],record['path']
owned=Path('E:/mapslol3v3/loading_string24_ownership_repair')
assert h(ROOT/'audio_loading_owned_string.rs')==h(owned/'audio_loading_owned_string.rs')
assert h(ROOT/'audio_loading_owned_string_tests.rs')==h(owned/'audio_loading_owned_string_tests.rs')
prefix=(ROOT/'audio_loading_standard_prefix.rs').read_text()
assert 'names::assign_owned_non_alias' not in prefix
assert 'owned::assign_owned_non_alias(b, name, source)?;' in prefix
consumer=(ROOT/'audio_loading_screen_packet.rs').read_text()
assert 'return owned::finish(b, name, primary).map_err(ReceiveFailure::Owned);' in consumer
assert 'initialize_standard_record(recipient, record, payload, service, &mut name)?;' in consumer
tests={name:re.findall(r'#\[test\]\s*fn\s+(\w+)',(ROOT/name).read_text())
       for name in baseline if name.endswith('_tests.rs')}
assert [len(tests[n]) for n in ['audio_loading_owned_string_tests.rs','audio_loading_screen_packet_tests.rs','audio_loading_standard_prefix_tests.rs']]==[4,6,4]
fixtures=[owned/'loading_owned_string_probe.json',
          Path('E:/mapslol3v3/loading_standard_prefix_port/loading_standard_prefix_probe.json')]
for path in fixtures:assert len(json.loads(path.read_text())['cases'])==128
diff=''
for name,source in baseline.items():
    old=Path(source['path']).read_text().splitlines(keepends=True)
    new=(ROOT/name).read_text().splitlines(keepends=True)
    diff+=''.join(difflib.unified_diff(old,new,fromfile=source['path'],tofile=str(ROOT/name)))
(ROOT/'changes.patch').write_text(diff)
names=[*baseline,'README.md','baseline.json','changes.patch','prepare_stage.py','record_stage.py']
manifest={'status':'prepared_generic_integration_not_compiled',
          'production_modified':False,'frozen_lots_modified':False,'rust_compiled':False,
          'rust_tests_executed':0,'native_execution_run':False,
          'source_baseline_reverified':baseline,'tests_prepared':tests,'test_functions':sum(map(len,tests.values())),
          'added_test_functions':8,'new_native_cases':0,
          'fixture_dependencies':[row(p) for p in fixtures],
          'image_requirement':{'address':0x2d78f1c,'bytes':4,'source_value':0,'provider_invoked':False},
          'host_requirement':'Retain typed remaining Temporary and reserved scratch lease before reporting string errors; retry through atomic release_owned only.',
          'scope':'Only standard native57D6FE..57D775 prefix; explicit stops before diagnostic991E60/resource90AD00; tutorial operation order retained.',
          'static_checks_executed':['Six baselines unchanged','Owned module/tests byte-identical to frozen ownership preparation','No global assign rename/use','Typed consumer-to-guard connection present','Two fixtures each128 cases','Prepared test function counts4+6+4'],
          'files':[row(ROOT/name) for name in names]}
(ROOT/'stage_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'manifest':row(ROOT/'stage_manifest.json'),'test_functions_prepared':manifest['test_functions'],'rust_tests_executed':0}))
