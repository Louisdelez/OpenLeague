"""Install exactly the hash-checked change set, preserving prior files."""
from pathlib import Path
import datetime,hashlib,json,shutil
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def save(p,v):
 t=p.with_suffix(p.suffix+'.resource-install-pending');t.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 assert load(t)==v;t.replace(p)
a=load(S/'assembled.json');assert len(a['files'])==24
assert sha(R/a['previous_qualification'])==a['previous_receipt_sha256']
for rel,row in a['files'].items():
 target=R/rel;assert target.resolve().is_relative_to(R.resolve())
 assert sha(P/rel)==row['after'],rel
 assert (sha(target) if target.is_file() else None)==row['before'],rel
backup=R/'docs/plan_history'/('resource-manager-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
backup.mkdir(parents=True)
checkpoint=R/'docs/resume_checkpoint.json';shutil.copyfile(checkpoint,backup/'resume_checkpoint.json')
for rel,row in a['files'].items():
 if row['before'] is not None:
  target=backup/'files'/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(R/rel,target)
state=load(checkpoint)
state['in_progress']={'scope':a['scope'],'stage':str(S),'backup':str(backup),'assembled_sha256':sha(S/'assembled.json'),
                      'tests_pending':True,'normal_loading_screen_complete':False,'real_resource_factory_connected':False}
state['state']='active';save(checkpoint,state)
for rel,row in a['files'].items():
 target=R/rel;target.parent.mkdir(parents=True,exist_ok=True)
 temp=target.with_suffix(target.suffix+'.resource-install-pending');shutil.copyfile(P/rel,temp)
 assert sha(temp)==row['after'];temp.replace(target)
 assert sha(target)==row['after'],rel
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'assembled_sha256':sha(S/'assembled.json'),
         'backup':str(backup),'files':a['files'],'tests_pending':True,'complete':False}
save(S/'installed.json',receipt)
print(json.dumps({'installed_files':len(a['files']),'backup':str(backup),'tests_pending':True}))
