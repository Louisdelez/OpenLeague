import contextlib,hashlib,http.client,json,pathlib,sqlite3,tempfile,threading,unittest
from work_store import Store
from server import Server
import work_model as w
class WorkIntegrationTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory();root=pathlib.Path(self.tmp.name);self.store=Store.__new__(Store);self.store.root=root;self.store.data_dir=root;self.store.path=root/'plan.sqlite3';self.store.source_cache=root
  self.store.ensure_schema()
  with self.store.db()as c:
   c.execute("INSERT INTO meta VALUES('catalog_version','isolated-work-fixture')");c.execute('INSERT INTO phases VALUES(?,?,?)',('D01',0,json.dumps(dict(id='D01',title='Fixture audit'))));c.execute('INSERT INTO packages VALUES(?,?,?,?)',('P','D01',0,json.dumps(dict(id='P',title='Single scoped fixture',task_ids=['A','B']))))
   for i,id in enumerate(['A','B']):
    data=dict(id=id,title='Fixture '+id,depends_on=[]);c.execute('INSERT INTO tasks VALUES(?,?,?,?,?,?,?,?,?,?,?,1)',(id,'P','D01',i,data['title'],'source','open',1,id.lower(),json.dumps(data),'Complete fixture instruction '+id));c.execute('INSERT INTO task_state VALUES(?,0,?,0,NULL)',(id,'Existing note '+id));c.execute("INSERT INTO task_groups VALUES(?,'Fixture')",(id,))
   c.commit()
  self.server=Server(('127.0.0.1',0),self.store);self.thread=threading.Thread(target=self.server.serve_forever,daemon=True);self.thread.start()
 def tearDown(self):self.server.shutdown();self.server.server_close();self.thread.join();self.tmp.cleanup()
 def request(self,path,method='GET',data=None):
  c=http.client.HTTPConnection('127.0.0.1',self.server.server_port);c.request(method,path,body=json.dumps(data)if data is not None else None,headers={'Content-Type':'application/json'});r=c.getresponse();body=r.read();status=r.status;c.close();return status,json.loads(body)if r.getheader('Content-Type','').startswith('application/json')else body
 def test_actual_routes_bootstrap_task_copy_and_restart(self):
  status,b=self.request('/api/bootstrap');self.assertEqual(status,200);self.assertEqual(b['work_metrics']['audits']['denominator'],2)
  _,a=self.request('/api/work/task/A');v=a['assessment'];v['audit']='en_cours';v['record']={'scope':'A single persisted source audit'};self.assertEqual(self.request('/api/work/task/A','POST',v)[0],200)
  _,t=self.request('/api/task/A');self.assertEqual(t['assessment']['audit'],'en_cours');self.assertEqual(t['notes'],'Existing note A');_,copy=self.request('/api/copy?kind=task&id=A');self.assertIn('SUIVI INDÉPENDANT',copy['text']);self.assertIn('en_cours',copy['text'])
  self.store.ensure_schema();self.assertEqual(self.store.task('A')['assessment']['record']['scope'],v['record']['scope'])
 def test_actual_correction_copy_and_proof_identity(self):
  f=pathlib.Path(self.tmp.name)/'proof.txt';f.write_text('A real fixture observation');status,p=self.request('/api/work/proof','POST',{'path':str(f)});self.assertEqual(status,200);self.assertEqual(p['sha256'],hashlib.sha256(f.read_bytes()).hexdigest())
  record={k:'Explicit fixture '+k for k in w.CORRECTION_FIELDS};status,result=self.request('/api/work/correction','POST',dict(task_id='A',objective='Recover one named fixture field',record=record));self.assertEqual(status,200)
  status,data=self.request('/api/copy?kind=correction&id='+result['id']);self.assertEqual(status,200);self.assertIn('COMPORTEMENT ATTENDU',data['text']);self.assertIn('CONDITION DE REPRISE',data['text']);self.assertGreater(len(data['text'].splitlines()),15)
 def test_snapshot_and_weekly_do_not_invent_prior_history(self):
  _,week=self.request('/api/work/weekly');self.assertFalse(week['comparison_available']);_,shot=self.request('/api/work/snapshot','POST',{});self.assertIn('evidence_sets',shot['metrics']);self.assertFalse(self.request('/api/work/weekly')[1]['comparison_available'])
 def test_invalid_state_and_stale_revision_are_refused_without_note_loss(self):
  _,data=self.request('/api/work/task/A');v=data['assessment'];v['audit']='termine_avec_preuves';self.assertEqual(self.request('/api/work/task/A','POST',v)[0],400);self.assertEqual(self.store.task('A')['notes'],'Existing note A')
  v['audit']='en_cours';self.assertEqual(self.request('/api/work/task/A','POST',v)[0],200);self.assertEqual(self.request('/api/work/task/A','POST',v)[0],409)
 def test_shared_frontend_asset_is_served(self):
  status,body=self.request('/work_ui.js');self.assertEqual(status,200);self.assertIn(b'OpenLeagueWorkUI',body)
if __name__=='__main__':unittest.main()
