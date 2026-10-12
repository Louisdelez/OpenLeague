from pathlib import Path
import json,hashlib,datetime,shutil
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/loading_clock_integration');P=S/'production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def save(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
base=load(S/'base_hashes.json')
for name in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:
 rel='data/4.20/runtime/'+name;(P/rel).parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(S/name,P/rel);base[rel]=sha(R/rel)
save(S/'base_hashes.json',base)
for rel,digest in base.items():
 assert (R/rel).resolve().is_relative_to(R.resolve())
 assert (sha(R/rel) if (R/rel).exists() else None)==digest,rel
 assert (P/rel).exists(),rel
now=datetime.datetime.now(datetime.timezone.utc);backup=R/'docs/plan_history'/('process-clock-source-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
rows={}
for rel,digest in base.items():
 if digest:
  target=backup/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(R/rel,target)
 target=R/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(P/rel,target);assert sha(target)==sha(P/rel)
 rows[rel]={'before':digest,'after':sha(target)}
receipt={'saved_utc':now.isoformat(),'backup':str(backup),'files':rows,'complete':False,'tests_pending':True};save(S/'installed.json',receipt)
checkpoint=R/'docs/resume_checkpoint.json';shutil.copyfile(checkpoint,backup/'resume_checkpoint.json');d=load(checkpoint)
d['in_progress']={'scope':'Canonical process clock and real first loading names','stage':str(S),'installed':str(S/'installed.json'),'tests_pending':True,'saved_utc':now.isoformat()}
d['saved_utc']=now.isoformat();d['state']='active';save(checkpoint,d)
print(json.dumps({'installed_files':len(rows),'backup':str(backup),'tests_pending':True}))
