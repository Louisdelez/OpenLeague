from pathlib import Path
import datetime,hashlib,json,shutil
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
assert R.resolve()==Path('E:/OpenLeague').resolve()
for name in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:
 p=P/'data/4.20/runtime'/name;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(S/name,p)
now=datetime.datetime.now(datetime.timezone.utc);backup=R/'docs/plan_history'/('loading-source-'+now.strftime('%Y%m%dT%H%M%S%fZ'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
rows={}
for src in sorted(P.rglob('*')):
 if not src.is_file():continue
 rel=src.relative_to(P);dest=R/rel;before=sha(dest) if dest.exists() else None
 if before is not None:
  archived=backup/rel;archived.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(dest,archived)
 dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dest);rows[rel.as_posix()]={'before':before,'after':sha(dest)}
(S/'installed.json').write_text(json.dumps({'saved_utc':now.isoformat(),'backup':str(backup),'files':rows},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'installed':len(rows),'backup':str(backup)}))
