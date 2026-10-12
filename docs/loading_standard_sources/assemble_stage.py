from pathlib import Path
import hashlib,json,re,shutil

R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
base={}
previous=load(R/'docs/process_clock_validation.json')
previous_hashes={**previous['source_hashes'],**previous['resource_hashes']}
def stage(rel,source=None,text=None):
 current=R/rel
 if current.exists():
  digest=sha(current)
  assert rel in previous_hashes and previous_hashes[rel]==digest,rel
 else:digest=None
 base[rel]=digest
 destination=P/rel;destination.parent.mkdir(parents=True,exist_ok=True)
 if source is not None:shutil.copyfile(source,destination)
 else:destination.write_text(text,encoding='utf-8')

generic=load(S/'generic/stage_manifest.json')
for row in generic['files']:
 path=Path(row['path']);assert sha(path)==row['sha256'] and path.stat().st_size==row['bytes']
 if path.suffix=='.rs':stage('crates/core/src/'+path.name,source=path)
for row in generic['fixture_dependencies']:
 path=Path(row['path']);assert sha(path)==row['sha256'] and path.stat().st_size==row['bytes']
 stage('data/4.20/'+path.name,source=path)

# Windows files must have completed independent review before calling this
# assembler. Save their exact hashes; do not keep reading changing candidates.
windows=list((S/'windows').glob('*.rs'))
assert {p.name for p in windows}=={'audio_replay_windows_loading_packets.rs','audio_replay_windows_loading_packets_tests.rs','audio_replay_windows_loading_retirement.rs','audio_replay_windows_loading_retirement_tests.rs','audio_replay_windows_transport.rs'}
assert sha(S/'windows/stage_manifest.json')=='c0e9e229bdd495d3db5be9c87e30a87751836ad840fc59301f87dd092b2f879c'
win=load(S/'windows/stage_manifest.json')
for row in [*win['files'],*win['baselines'],*win['artifacts'],*win['dependencies'].values()]:
 path=Path(row['path']);assert sha(path)==row['sha256'] and path.stat().st_size==row['bytes'],str(path)
for path in windows:stage('crates/core/src/'+path.name,source=path)

rel='crates/core/src/lib.rs';text=(R/rel).read_text(encoding='utf-8')
for name in ['audio_loading_owned_string','audio_loading_standard_prefix']:
 assert 'pub mod '+name+';' not in text
 text+='\npub mod '+name+';\n'
stage(rel,text=text)

for rel,digest in load(S/'image_base_hashes.json').items():
 assert sha(R/rel)==digest==previous_hashes[rel]
 base[rel]=digest
for name in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:
 stage('data/4.20/runtime/'+name,source=S/name)
runner=(R/'tools/run_process_clock_probes.ps1').read_text(encoding='utf-8-sig').replace('client-process-clock-','client-loading-standard-')
stage('tools/run_loading_standard_probes.ps1',text=runner)

expect=[]
for path in list((S/'generic').glob('*_tests.rs'))+list((S/'windows').glob('*_tests.rs')):
 expect+=re.findall(r'#\[test\]\s*fn\s+(\w+)\s*\(',path.read_text(encoding='utf-8'))
assert len(expect)==len(set(expect)) and len(expect)>=17
assert 'audio_loading_standard_prefix_matches128_native_stops_and_distinct_cleanup' in expect
receipt={'base':base,'files':{rel:sha(P/rel) for rel in base},'required_core_tests':expect,
         'previous_qualification':'docs/process_clock_validation.json','previous_receipt_sha256':sha(R/'docs/process_clock_validation.json'),
         'generic_manifest_sha256':sha(S/'generic/stage_manifest.json'),
         'windows_candidate_hashes':{p.name:sha(p) for p in windows},'compiled':False}
(S/'assembled.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'staged_files':len(base),'required_core_tests':len(expect),'image_regions':62}))
