from pathlib import Path
import datetime,hashlib,json,re,subprocess
root=Path(__file__).parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
test=(root/'test.log').read_text(encoding='utf-8-sig')
compile_log=(root/'compile.log').read_text(encoding='utf-8-sig')
assert 'test result: ok. 11 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out;' in test
assert len(re.findall(r'^test .* \.\.\. ok$',test,re.M))==11
assert not re.search(r'^error(?:\[|:)',compile_log,re.M)
native=json.loads((root/'signatures_native_probe.json').read_text())
assert native['passed'] and len(native['cases'])==336 and len(native['real_leaf_wrappers'])==12 and len(native['direct_leaves'])==12
assert len(native['negative_controls'])==2 and all(c['faults']==[[0x30001000,4]] and c['terminal_calls']==0 for c in native['negative_controls'])
compiler=Path('C:/Users/loicd/.cargo/bin/rustc.exe')
dep=Path('E:/OpenLeague/target/debug/deps/libserde_json-06e1b1b57f0ae5f7.rlib')
assert sha(Path(native['source']))==native['native_sha256']
previous=Path('E:/mapslol3v3/replay_callback12_agent')
for filename in ['callback12_tests.rs','callback12_native_probe.json','audio_replay_events.rs']:
    assert (root/filename).read_bytes()==(previous/filename).read_bytes()
files=[p for p in root.iterdir() if p.suffix in ['.rs','.py','.patch','.json','.log','.exe','.pdb','.md','.txt'] and p.name!='validation_receipt.json']
receipt={
 'schema':'openleague.callback-signatures.scratch-validation.v1',
 'recorded_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'scope':'Four typed wrappers and two real AL0 leaves only; no production, Windows adapter or cargo build',
 'compiler_version':subprocess.check_output([str(compiler),'--version','--verbose'],text=True).strip(),
 'compile':{'command':[str(compiler),'--test','--edition=2021',str(root/'signatures_harness.rs'),'--extern','serde_json='+str(dep),'-L','dependency=E:/OpenLeague/target/debug/deps','-o',str(root/'signatures_tests.exe')],'observed_exit_code':0,'log':'compile.log','unused_warnings':70},
 'tests':{'command':[str(root/'signatures_tests.exe'),'--test-threads=1','--nocapture'],'observed_exit_code':0,'passed':11,'failed':0,'ignored':0,'new_tests':8,'preserved_callback12_tests':3,'log':'test.log'},
 'native':{'fixture':'signatures_native_probe.json','source':native['source'],'source_sha256':native['native_sha256'],'boundary_cases':336,'real_leaf_wrappers':12,'direct_leaves':12,'negative_controls':2,'unimplemented_consumer_bodies_executed':False},
 'preserved_callback12':{'fixture_sha256':sha(root/'callback12_native_probe.json'),'original_receipt_sha256':sha(previous/'callback12_validation_receipt.json'),'cases':96},
 'dependency':{'path':str(dep),'sha256':sha(dep)},
 'files':{p.name:{'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(files)},
}
path=root/'validation_receipt.json';path.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt':str(path),'receipt_sha256':sha(path),'tests_passed':11,'tests_failed':0,'file_hashes':len(files)}))
