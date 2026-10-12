from pathlib import Path
import hashlib,json,shutil,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');p=r/'crates/client/src/main.rs';expected=json.loads((s/'replay_client_main_source.json').read_text())
assert hashlib.sha256(p.read_bytes()).hexdigest()==expected['original_sha256'],'client main changed during staging'
assert hashlib.sha256((s/'replay_client_main_updated.rs').read_bytes()).hexdigest()==expected['updated_sha256']
assert '725 passed; 0 failed' in (r/'logs/core-replay-application-tests.log').read_text(encoding='utf-8-sig')
backup=r/'docs/plan_history'/('replay-client-application-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True);shutil.copy2(p,backup/p.name)
shutil.copy2(s/'replay_client_main_updated.rs',p)
for name in ['prepare_replay_client_application.py','install_replay_client_application.py']:shutil.copy2(s/name,r/'tools'/name)
print('Installed shared normal-client/runtime-probe attachment:',backup)
