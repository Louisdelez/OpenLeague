"""Verify frozen candidates and assemble one concrete production change set."""
from pathlib import Path
import hashlib,json,re,shutil
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
previous=load(R/'docs/loading_standard_validation.json')
assert previous['passed'] and sha(R/'docs/loading_standard_validation.json')=='cb966f4328ea827eb7ca398d501ab8a94b16f68807cb395371b4f4a123f7f84d'
manifests={
 'cache/manifest.json':'e640282d63b657633e9ecefdb40127071d482595abd0f3d756fc87ba4c53810d',
 'ownership/stage_manifest.json':'f2eb751b4a8f5fe19e97213cd308964c5bcc9ada51a3e457b5e888c843591356',
}
# The manager's final immutable manifest must be supplied before assembly.
manager_pin=load(S/'manager_pin.json')
manifests['manager/'+manager_pin['name']]=manager_pin['sha256']
for rel,digest in manifests.items():
 path=S/rel;assert sha(path)==digest,rel
 manifest=load(path)
 for name,row in manifest['files'].items():
  source=path.parent/name;assert source.resolve().is_relative_to(path.parent.resolve())
  assert sha(source)==row['sha256'],source
 for source in path.parent.glob('*.rs'):
  target=P/'crates/core/src'/source.name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,target)
review=load(S/'review/root_windows_review.json')
assert sha(S/'review/root_windows_review.json')=='bebf7914d37b8cf506fd1491a5c7cf345d620a7067b760f6a41e538facc95920'
assert not review['open_concrete_defects']
for row in review['files']:assert sha(Path(row['path']))==row['sha256'],row['path']
for source in (S/'windows').glob('*.rs'):shutil.copyfile(source,P/'crates/core/src'/source.name)
fixtures={
 'manager/loading_resource_manager_oracle.json':'loading_resource_manager_oracle.json',
 'native_manager_null_probe.json':'loading_resource_manager_null_probe.json',
 'cache/native_cache_retirement_oracle.json':'loading_resource_cache_contract.json',
}
for rel,name in fixtures.items():
 assert load(S/rel)['passed'],rel
 target=P/'data/4.20'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(S/rel,target)
image=load(S/'independent_image_verification.json')
assert image['passed'] and not image['errors'] and image['region_count']==73
assert sha(P/'data/4.20/runtime/replay_runtime_image.bin')==image['package_sha256']=='d2d0a8517da861a959bbb4f6914573a7897c6f78c1f1d8d7e6e90b50e50a5099'
def tests(path):
 return set(re.findall(r'#\[test\]\s*fn\s+(\w+)',path.read_text(encoding='utf-8'))) if path.is_file() else set()
rows={};added=set();removed=set();required=set(previous['core_tests']['required_tests'])
for path in sorted(P.rglob('*')):
 if not path.is_file():continue
 rel=path.relative_to(P).as_posix();before=sha(R/rel) if (R/rel).is_file() else None
 if before is not None:
  assert rel in previous['source_and_resource_hashes'],('unrecorded previous file',rel)
  assert before==previous['source_and_resource_hashes'][rel],rel
 rows[rel]={'before':before,'after':sha(path),'bytes':path.stat().st_size}
 if path.suffix=='.rs':
  old=tests(R/rel);new=tests(path);added|=new-old;removed|=old-new;required|=new
assert not removed,removed
assert len(added)==25,(len(added),sorted(added))
assert len(rows)==24,(len(rows),list(rows))
value={'scope':'Resource manager empty lifetime, normalized cache lookup and paired temporary cleanup',
 'complete':False,'production_integrated':False,'previous_qualification':'docs/loading_standard_validation.json',
 'previous_receipt_sha256':sha(R/'docs/loading_standard_validation.json'),'candidate_manifests':manifests,
 'files':rows,'added_tests':sorted(added),'required_core_tests':sorted(required),
 'expected_core_passed':865+len(added),'expected_core_filtered':480,'image':image['package_sha256']}
(S/'assembled.json').write_text(json.dumps(value,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'files':len(rows),'new_tests':len(added),'required_tests':len(required),'expected_core_passed':value['expected_core_passed']}))
