from pathlib import Path
import datetime,hashlib,json,shutil
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/loading_clock_integration');rel=Path('crates/core/src/audio_replay_windows_clock_host.rs')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=S/'ownership_repair'/rel.name
assert sha(R/rel)==sha(S/'production'/rel)=='e4ca3ffaba8c330d061d55bd5aa6a3ea885a182f03fe56cdc7bdf991e1ca4fd6'
assert sha(source)=='6946fcc5806250510496735518b807cdf89b984e3e6e1d2f7cc015d00d019dc8'
now=datetime.datetime.now(datetime.timezone.utc);backup=R/'docs/plan_history'/('process-clock-ownership-'+now.strftime('%Y%m%dT%H%M%S%fZ'))
backup.mkdir(parents=True);shutil.copyfile(R/rel,backup/rel.name)
shutil.copyfile(source,S/'production'/rel);shutil.copyfile(source,R/rel)
receipt={'saved_utc':now.isoformat(),'path':rel.as_posix(),'backup':str(backup),'after':sha(R/rel),'tests_pending':True}
(S/'ownership_repair_installed.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt))
