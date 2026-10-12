from pathlib import Path
import datetime, hashlib, json, re

S=Path(__file__).resolve().parent
R=Path('E:/OpenLeague')
F=S/'review/test_order_repair'
F.mkdir(parents=True,exist_ok=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
relative='crates/core/src/audio_replay_windows_loading_retirement_tests.rs'
before='73ec176c36c32b0b98ef0b2654289a95d71a1af5f2ec897b46cae12a7afe9204'
path=R/relative
assert sha(path)==sha(S/'production'/relative)==before
raw=path.read_bytes()
old=(b'        let manager=r.initialize_loading_resources().unwrap();\n'
     b'        let service=r.configure_service(Defaults).unwrap();r.initialize_game_manager().unwrap();')
new=(b'        let service=r.configure_service(Defaults).unwrap();\n'
     b'        let manager=r.initialize_loading_resources().unwrap();r.initialize_game_manager().unwrap();')
if b'\r\n' in raw:
    old=old.replace(b'\n',b'\r\n')
    new=new.replace(b'\n',b'\r\n')
assert raw.count(old)==1
candidate=F/path.name
candidate.write_bytes(raw.replace(old,new))
assert candidate.read_bytes().replace(new,old)==raw
log=R/'logs/core-loading-resource-manager-tests.log'
logtext=log.read_text(encoding='utf-8-sig')
assert re.findall(r'test result: FAILED\. (\d+) passed; (\d+) failed; 0 ignored; 0 measured; (\d+) filtered out',logtext)==[('891','1','480')]
failed='audio_replay_windows_transport::loading_packets::tests::audio_replay_windows_loading_standard_packet_uses_real_resource_manager_and_retires_normalized_key_on_factory_boundary'
assert logtext.count('---- '+failed+' stdout ----')==1
assert 'configured service requires a fresh owned runtime lifetime' in logtext
saved=F/'core-tests-before-order-fix.log'
saved.write_bytes(log.read_bytes())
assert sha(saved)==sha(log)
diagnostic={
    'reason':'The new integration test initialized resource allocations before configure_service, whose existing host precondition requires a fresh owned bank.',
    'correction':'Configure service first, then initialize resource manager and game manager. Production ownership guards stay intact.',
    'full_original_startup_order_qualified':False,
    'byte_replacement':{'before_hex':old.hex(),'after_hex':new.hex()},
    'source_guards':{name:sha(R/'crates/core/src'/name) for name in ['audio_replay_windows_service.rs','audio_replay_windows_game_manager.rs']},
    'test_names_unchanged':True,
}
decision=F/'decision.json'
decision.write_text(json.dumps(diagnostic,indent=2)+'\n',encoding='utf-8')
manifest={
    'schema':1,'complete':False,'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'assembled_sha256':sha(S/'assembled.json'),'installed_sha256':sha(S/'installed.json'),
    'index_repair_manifest_sha256':sha(S/'review/index_read_repair/repair_manifest.json'),
    'index_repair_installed_sha256':sha(S/'index_repair_installed.json'),
    'files':{relative:{'before_sha256':before,'after_sha256':sha(candidate),'bytes':candidate.stat().st_size,'candidate':candidate.relative_to(S).as_posix()}},
    'added_tests':[],
    'proof_files':{p.relative_to(S).as_posix():{'bytes':p.stat().st_size,'sha256':sha(p)} for p in [saved,decision,candidate]},
    'failed_run':{'log':saved.relative_to(S).as_posix(),'sha256':sha(saved),'passed':891,'failed':1,'filtered':480,'failed_test':failed,'client_build_executed':False},
}
target=S/'test_order_repair.json'
target.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest_sha256':sha(target),'candidate_sha256':sha(candidate),'production_modified':False}))
