from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();pending='--pending' in sys.argv;sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '293 passed; 0 failed' in (r/'logs/native-hud-effect-uniforms-tests.log').read_text(encoding='utf-8')
if not pending:assert 'Finished `dev` profile' in (r/'logs/native-hud-layout-client-build.log').read_text(encoding='utf-8')
p=r/'docs/native_hud_layout_provider_progress.json';proof=json.loads(p.read_text(encoding='utf-8'));proof.update(updated_utc=now,client_source_tests_passed=293,current_source_suite_pending=False,client_build_pending=pending,application_rebuilt_after_changes=not pending,current_binary_sha256=sha('target/debug/openleague-client.exe'))
if not pending:
 proof['current_application_source_tests']=293
 receipt=dict(updated_utc=now,complete=False,client_sha256=proof['current_binary_sha256'],source_tests_passed=293,tests_log='logs/native-hud-effect-uniforms-tests.log',build_log='logs/native-hud-layout-client-build.log',source_hashes=proof['hashes'],hud_layout_loading_runtime_verified=False,hud_widgets_drawn=False)
 (r/'docs/native_hud_layout_build_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
p.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'));d.update(updated_utc=now,complete=False,native_hud_layout_provider_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=293,current_source_suite_pending=False,client_build_pending=pending,current_client_application_tests=279 if pending else 293,client_test_source_matches_current_build=not pending,current_source_progress='docs/native_hud_layout_provider_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[dict(session_id=63270,command='cargo build -p openleague-client --bin openleague-client -j1',log='logs/native-hud-layout-client-build.log',state='verified_live_when_checkpoint_written')] if pending else [])
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(build_pending=pending,source_tests=293,runtime_verified=False)))
