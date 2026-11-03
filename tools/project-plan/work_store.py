"""Actual web planner adapter; original checkbox/catalog store is preserved."""
import json
from store import Store as LegacyStore,Invalid,Conflict
import work_model as work
class Store(LegacyStore):
 def ensure_schema(self):
  super().ensure_schema()
  with self.db()as c:work.migrate(c)
 def summary(self):
  out=super().summary()
  with self.db()as c:out['work_metrics']=work.metrics(c)
  return out
 def task(self,ident):
  out=super().task(ident)
  with self.db()as c:out['assessment']=work.assessment(c,ident);out['corrections']=self.corrections(c,ident)
  return out
 def copy_text(self,kind,ident):
  if kind=='correction':
   with self.db()as c:return work.correction_instruction(c,ident)
  out=super().copy_text(kind,ident)
  if kind=='task':
   with self.db()as c:out['text']+=work.copy_context(c,ident)
  return out
 @staticmethod
 def corrections(c,ident):
  out=[]
  for r in c.execute('SELECT * FROM work_corrections WHERE task_id=? ORDER BY id',(ident,)):
   v=dict(r);v['record']=json.loads(v['record']);out.append(v)
  return out
 def work_request(self,path,method,body=None):
  try:
   with self.db()as c:
    if method=='POST'and path=='/api/work/proof':return work.proof_identity(body.get('path',''),body.get('kind','document_review'))
    if method=='GET'and path=='/api/work/contract':return work.CONTRACT
    if method=='GET'and path=='/api/work/metrics':return work.metrics(c)
    if method=='GET'and path=='/api/work/weekly':return work.weekly(c)
    if method=='GET'and path=='/api/work/journeys':return work.definitions(c)
    if method=='POST'and path=='/api/work/snapshot':return work.snapshot(c)
    if method=='POST'and path=='/api/work/correction':return work.correction(c,body)
    if path.startswith('/api/work/task/'):
     ident=path[len('/api/work/task/'):]
     if method=='GET':return dict(assessment=work.assessment(c,ident),corrections=self.corrections(c,ident))
     if method=='POST':return work.change(c,ident,body)
    if method=='POST'and path.startswith('/api/work/journey/'):return work.journey(c,path[len('/api/work/journey/'):],body)
   raise Invalid('Commande de suivi inconnue.')
  except ValueError as e:
   if 'Conflit'in str(e):raise Conflict(str(e))from e
   raise Invalid(str(e))from e
