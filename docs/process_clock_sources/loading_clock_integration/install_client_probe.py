from pathlib import Path
import json, hashlib, shutil, datetime
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/loading_clock_integration');P=S.parent/'process_clock_client_probe'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def save(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
installed=load(S/'installed.json')
main='crates/client/src/main.rs';clock='crates/client/src/native_effect_clock.rs'
for rel in [main,clock]:
 assert sha(R/rel)==sha(S/'production'/rel)==installed['files'][rel]['after'],rel
body=(R/main).read_text(encoding='utf-8');assert '--native-process-clock-probe' not in body
anchor='    let arguments:Vec<String>=std::env::args().collect();'
assert body.count(anchor)==1
dispatch=(P/'main_dispatch.rs.txt').read_text(encoding='utf-8').split('\n',1)[1]
addition=(P/'main_probe.rs.txt').read_text(encoding='utf-8').split('\n',2)[2]
body=body.replace(anchor,anchor+'\n'+dispatch)+'\n'+addition
effect=(R/clock).read_text(encoding='utf-8').replace('//! Scratch proposal: requires the qualified core clock handle, no local QPC/epoch.','//! Uses the canonical core clock handle; it owns no local QPC epoch.')
runner=(R/'tools/run_loading_probes.ps1').read_text(encoding='utf-8-sig').replace('client-loading-','client-process-clock-').replace("$runs=@(\n","$runs=@(\n @('clock','--native-process-clock-probe'),\n")
assert "@('clock','--native-process-clock-probe')" in runner
now=datetime.datetime.now(datetime.timezone.utc)
backup=R/'docs/plan_history'/('process-clock-client-probe-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
edits={main:body,clock:effect,'tools/run_process_clock_probes.ps1':runner}
rows={}
for rel,text in edits.items():
 path=R/rel;before=sha(path) if path.exists() else None
 if path.exists():
  dst=backup/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(path,dst)
 stage=S/'production'/rel;stage.parent.mkdir(parents=True,exist_ok=True);stage.write_text(text,encoding='utf-8')
 shutil.copyfile(stage,path);rows[rel]={'before':before,'after':sha(path)}
save(S/'client_probe_installed.json',{'saved_utc':now.isoformat(),'backup':str(backup),'files':rows,'tests_pending':True})
print(json.dumps({'files':list(rows),'backup':str(backup)}))
