from pathlib import Path
import datetime,hashlib,json,shutil
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def save(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
a=load(S/'assembled.json')
assert sha(R/a['previous_qualification'])==a['previous_receipt_sha256']
assert not (S/'installed.json').exists(),'already installed; use a separate repair receipt'
for rel,expected in a['files'].items():
 assert (R/rel).resolve().is_relative_to(R.resolve())
 assert (P/rel).resolve().is_relative_to(P.resolve())
 assert sha(P/rel)==expected,rel
 assert (sha(R/rel) if (R/rel).exists() else None)==a['base'][rel],rel
now=datetime.datetime.now(datetime.timezone.utc)
backup=R/'docs/plan_history'/('loading-standard-'+now.strftime('%Y%m%dT%H%M%S%fZ'))
backup.mkdir(parents=True)
for rel,before in a['base'].items():
 if before is not None:
  target=backup/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(R/rel,target)
checkpoint=R/'docs/resume_checkpoint.json'
shutil.copyfile(checkpoint,backup/'resume_checkpoint.before.json')
for rel in a['files']:
 dest=R/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(P/rel,dest)
 assert sha(dest)==a['files'][rel]
receipt={'saved_utc':now.isoformat(),'backup':str(backup),'compiled':False,'tests_pending':True,
         'assembled_sha256':sha(S/'assembled.json'),
         'files':{rel:{'before':a['base'][rel],'after':digest} for rel,digest in a['files'].items()}}
save(S/'installed.json',receipt)
d=load(checkpoint)
d['state']='active';d['saved_utc']=now.isoformat()
d['in_progress']={'task':'Qualify standard nonempty loading-name prefix and owned temporary cleanup on the canonical Windows bank.',
 'stage':str(S),'installed_receipt':str(S/'installed.json'),'tests_pending':True,
 'normal_loading_screen_complete':False,'resource90AD00_connected':False}
save(checkpoint,d)
print(json.dumps({'installed_files':len(a['files']),'backup':str(backup),'tests_pending':True}))
