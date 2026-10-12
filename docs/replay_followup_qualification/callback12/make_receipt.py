from pathlib import Path
import datetime,hashlib,json,re,subprocess
root=Path(__file__).parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
test=(root/'test.log').read_text(encoding='utf-8-sig')
compile_log=(root/'compile.log').read_text(encoding='utf-8-sig')
assert 'test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out;' in test
assert len(re.findall(r'^test tests::.* \.\.\. ok$',test,re.M))==3
assert not re.search(r'^error(?:\[|:)',compile_log,re.M)
native=json.loads((root/'callback12_native_probe.json').read_text())
assert native['passed'] is True and len(native['cases'])==96
assert native['negative_control']['faults']==[[0x30001000,4]] and native['negative_control']['terminal_calls']==0
compiler=Path('C:/Users/loicd/.cargo/bin/rustc.exe')
dep=Path('E:/OpenLeague/target/debug/deps/libserde_json-06e1b1b57f0ae5f7.rlib')
source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
assert sha(source)==native['native_sha256']
files=[p for p in root.iterdir() if p.suffix in ['.rs','.py','.patch','.json','.log','.exe','.pdb','.md'] and p.name!='callback12_validation_receipt.json']
receipt={
 'schema':'openleague.callback12.scratch-validation.v1',
 'recorded_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'scope':'Standalone5CCEB0 wrapper only; no production integration, Windows consumer or cargo build',
 'compiler_version':subprocess.check_output([str(compiler),'--version','--verbose'],text=True).strip(),
 'compile':{'command':[str(compiler),'--test','--edition=2021','callback12_harness.rs','--extern','serde_json='+str(dep),'-L','dependency=E:/OpenLeague/target/debug/deps','-o','callback12_tests.exe'],'cwd':str(root),'observed_exit_code':0,'log':'compile.log'},
 'tests':{'command':['callback12_tests.exe','--test-threads=1','--nocapture'],'observed_exit_code':0,'passed':3,'failed':0,'ignored':0,'log':'test.log'},
 'native':{'fixture':'callback12_native_probe.json','source':str(source),'source_sha256':native['native_sha256'],'cases':96,'protected_tail_negative_control':native['negative_control'],'terminal_consumers_executed':False},
 'dependency':{'path':str(dep),'sha256':sha(dep)},
 'files':{p.name:{'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(files)},
}
path=root/'callback12_validation_receipt.json';path.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt':str(path),'receipt_sha256':sha(path),'tests_passed':3,'tests_failed':0,'native_cases':96,'file_hashes':len(files)}))
