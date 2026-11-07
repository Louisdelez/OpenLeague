"""Local operator/agent entrypoint. Uses the same SQLite model as the web app."""
import argparse,json,pathlib,sqlite3,sys
import work_model as w

def main():
 p=argparse.ArgumentParser();p.add_argument('--database',default=str(pathlib.Path(__file__).resolve().parents[2]/'runtime/project-plan/plan.sqlite3'));p.add_argument('command',choices=['migrate','metrics','get','assess','correction','journey','snapshot','weekly','proof','export-method','rollback-method','restore-method']);p.add_argument('--task');p.add_argument('--id');p.add_argument('--file');p.add_argument('--output');p.add_argument('--path');a=p.parse_args()
 try:
  database=pathlib.Path(a.database).resolve(strict=True);c=sqlite3.connect(database.as_uri()+'?mode=rw',uri=True,timeout=15);c.row_factory=sqlite3.Row;c.execute('PRAGMA foreign_keys=ON');c.execute('PRAGMA synchronous=FULL')
  if a.command=='migrate':w.migrate(c);value=dict(migrated=True,database=str(database),metrics=w.metrics(c))
  elif a.command=='metrics':value=w.metrics(c)
  elif a.command=='weekly':value=w.weekly(c)
  elif a.command=='snapshot':value=w.snapshot(c)
  elif a.command=='proof':value=w.proof_identity(a.path or '')
  elif a.command=='get':value=w.assessment(c,a.task)
  elif a.command=='assess':value=w.change(c,a.task,json.loads(pathlib.Path(a.file).read_bytes()))
  elif a.command=='correction':value=w.correction(c,json.loads(pathlib.Path(a.file).read_bytes()))
  elif a.command=='journey':value=w.journey(c,a.id,json.loads(pathlib.Path(a.file).read_bytes()))
  elif a.command in ['export-method','rollback-method']:
   if not a.output:raise ValueError('Fichier de sauvegarde ciblée requis.')
   target=pathlib.Path(a.output);archive=w.export_work(c)
   with target.open('x',encoding='utf8')as f:json.dump(archive,f,ensure_ascii=False,indent=2)
   if a.command=='rollback-method':w.rollback(c)
   value=dict(saved=str(target),rollback=a.command=='rollback-method',legacy_tables_changed=False)
  else:value=w.restore_work(c,json.loads(pathlib.Path(a.file).read_bytes()))
  c.close();print(json.dumps(value,ensure_ascii=False));return 0
 except (ValueError,OSError,sqlite3.Error,TypeError)as e:print(json.dumps(dict(error=str(e)),ensure_ascii=False),file=sys.stderr);return 1
if __name__=='__main__':sys.exit(main())
