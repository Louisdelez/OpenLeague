"""Record only this scratch candidate. Never builds or writes production."""
from pathlib import Path
import datetime,difflib,hashlib,json,re
S=Path(__file__).resolve().parent
R=Path('E:/OpenLeague/crates/core/src')
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
base=json.loads((S/'baseline.json').read_text(encoding='utf-8'))
files={};tests=[];new=[];diff=[]
for name,digest in base.items():
 assert sha(R/name)==digest,('production baseline changed',name)
 path=S/name;files[name]={'bytes':path.stat().st_size,'sha256':sha(path),'baseline_sha256':digest}
 before=(R/name).read_text(encoding='utf-8');after=path.read_text(encoding='utf-8')
 prior=re.findall(r'#\[test\]\s*fn\s+(\w+)',before)
 current=re.findall(r'#\[test\]\s*fn\s+(\w+)',after)
 assert set(prior)<=set(current),('removed tests',name)
 tests+=current;new += [n for n in current if n not in prior]
 diff.extend(difflib.unified_diff(before.splitlines(True),after.splitlines(True),fromfile='a/crates/core/src/'+name,tofile='b/crates/core/src/'+name))
assert len(new)==8 and len(tests)==21
(S/'ownership.patch').write_text(''.join(diff),encoding='utf-8')
oracle=S.parent/'cache/native_cache_retirement_oracle.json'
proof=json.loads(oracle.read_text(encoding='utf-8'))
assert proof['passed'] and proof['complete'] is False
assert proof['source_sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
for name in ['README.md','record_stage.py','baseline.json','ownership.patch']:
 path=S/name;files[name]={'bytes':path.stat().st_size,'sha256':sha(path)}
manifest={
 'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'status':'prepared_for_root_review_and_compilation','production_integrated':False,
 'rust_compiled':False,'rust_tests_run':False,'client_executed':False,'complete':False,
 'files':files,'new_test_count':8,'new_tests':new,'required_tests':tests,
 'native_reference':{'path':str(oracle),'sha256':sha(oracle),'source_sha256':proof['source_sha256'],
  'executed_by_this_agent':False,'scope':'66 cache hits plus 8 separate miss abandonments; reset trace from peer oracle'},
 'dependencies':['audio_loading_resource_cache::Boundary and initialize_key/resolve/Outcome',
  'Windows resource-manager module with Runtime::initialize_loading_resources and cache::Boundary'],
 'transport_patch_required':False,'lib_patch_owned_by_this_stage':False,
 'limitations':['Rust source and tests are not compiled or executed in this candidate.',
  'Missing factories/UI remain explicit errors. No fabricated provider or playable-screen claim.',
  'Host failures preserve ownership; panic/OOM/abort and non-atomic custom release are outside scope.']}
(S/'stage_manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest_sha256':sha(S/'stage_manifest.json'),'new_tests':len(new),'required_tests':len(tests),'rust_compiled':False}))
