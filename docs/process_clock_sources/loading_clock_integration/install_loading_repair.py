from pathlib import Path
import datetime,hashlib,json,shutil
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/loading_clock_integration');rel=Path('crates/core/src/audio_replay_windows_loading_packets_tests.rs')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=S/'loading_repair'/rel.name
assert sha(R/rel)==sha(S/'production'/rel)=='1f88e8187e635631134b1c0220d5c535a2dd142db8a8655d74a4077859dcca1c'
assert sha(source)=='20b02e9777567e25127b854ebcf47afe77d4f367263fa0d2474e9104d47e4f04'
now=datetime.datetime.now(datetime.timezone.utc);backup=R/'docs/plan_history'/('process-clock-loading-tests-'+now.strftime('%Y%m%dT%H%M%S%fZ'))
backup.mkdir(parents=True);shutil.copyfile(R/rel,backup/rel.name)
shutil.copyfile(source,S/'production'/rel);shutil.copyfile(source,R/rel)
receipt={'saved_utc':now.isoformat(),'path':rel.as_posix(),'backup':str(backup),'after':sha(R/rel),'tests_pending':True,'normal_service_global_publication_claimed':False}
(S/'loading_repair_installed.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt))
