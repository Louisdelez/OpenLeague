import contextlib,hashlib,http.client,json,os,pathlib,sqlite3,tempfile,threading,unittest,urllib.request
from store import Store,Invalid,Conflict
from server import Server

ROOT=pathlib.Path(os.environ.get('OPENLEAGUE_PLAN_TEST_ROOT','E:/OpenLeague'))
class PlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.test_root=pathlib.Path(__file__).resolve().parent.parent/'test_runs'
        cls.test_root.mkdir(exist_ok=True)
        cls.temp=tempfile.TemporaryDirectory(prefix='run-',dir=cls.test_root)
        cls.before=hashlib.sha256((ROOT/'docs/completion_tasks_2026-10-20.json').read_bytes()).hexdigest()
        cls.store=Store(ROOT,pathlib.Path(cls.temp.name)/'state')
        cls.catalog=json.loads((ROOT/'docs/completion_tasks_2026-10-20.json').read_bytes())
        cls.hierarchy=json.loads((ROOT/'docs/execution_plan_A_Z.json').read_bytes())
        cls.server=Server(('127.0.0.1',0),cls.store)
        cls.thread=threading.Thread(target=cls.server.serve_forever,daemon=True);cls.thread.start()
        cls.url='http://127.0.0.1:'+str(cls.server.server_port)
    @classmethod
    def tearDownClass(cls):
        cls.server.shutdown();cls.server.server_close();cls.thread.join()
        after=hashlib.sha256((ROOT/'docs/completion_tasks_2026-10-20.json').read_bytes()).hexdigest()
        assert cls.before==after
        assert pathlib.Path(cls.temp.name).resolve().is_relative_to(cls.test_root.resolve())
        cls.temp.cleanup()
    def current(self,ident):return self.store.task(ident)
    def update(self,ident,**fields):
        return self.store.change([{'id':ident,'revision':self.current(ident)['revision'],**fields}])
    def test_01_complete_real_catalog(self):
        s=self.store.summary();self.assertEqual((s['total'],s['packages'],len(s['phases'])),(len(self.catalog['tasks']),len(self.hierarchy['packages']),24))
        with self.store.db() as c:
            self.assertEqual(c.execute('SELECT COUNT(DISTINCT id) FROM tasks WHERE active=1').fetchone()[0],len(self.catalog['tasks']))
            self.assertEqual(c.execute('PRAGMA integrity_check').fetchone()[0],'ok')
    def test_02_sqlite_survives_reopen_and_catalog_sync(self):
        ident='SYS-01.1-01';self.update(ident,done=True,notes='Preuve locale de persistance éàç')
        with self.store.db() as c:
            c.execute("UPDATE meta SET value='force-catalog-refresh' WHERE key='catalog_version'");c.commit()
        other=Store(ROOT,self.store.data_dir);t=other.task(ident)
        self.assertEqual(t['done'],1);self.assertIn('éàç',t['notes'])
        self.update(ident,done=False,notes='')
    def test_03_stale_revision_rejected_without_lost_write(self):
        ident='SYS-01.1-02';old=self.current(ident);self.update(ident,notes='A')
        with self.assertRaises(Conflict):self.store.change([{'id':ident,'revision':old['revision'],'done':True}])
        self.assertEqual(self.current(ident)['notes'],'A');self.update(ident,notes='')
    def test_04_batch_unknown_id_rolls_back_every_row(self):
        ident='SYS-01.1-03';before=self.current(ident)
        with self.assertRaises(Invalid):self.store.change([{'id':ident,'revision':before['revision'],'done':True},{'id':'NOT-A-TASK','revision':0,'done':True}])
        self.assertEqual(self.current(ident)['revision'],before['revision']);self.assertEqual(self.current(ident)['done'],before['done'])
    def test_05_batch_undo_restores_values(self):
        ident='SYS-01.1-04';before=self.current(ident);r=self.update(ident,done=True,notes='à annuler')
        self.store.undo(r['change_id']);after=self.current(ident)
        self.assertEqual((after['done'],after['notes']),(before['done'],before['notes']))
        with self.assertRaises(Invalid):self.store.undo(r['change_id'])
    def test_06_search_accents_filters_and_pagination(self):
        q=self.store.list_packages(query='garen Q',page=1)
        self.assertGreater(q['matched_tasks'],0)
        self.assertTrue(any(t['id']=='CH-Garen-Q-SIMULATION' for p in q['packages'] for t in p['tasks']))
        a=self.store.list_packages(phase='D02',query='récupérer');b=self.store.list_packages(phase='D02',query='recuperer')
        self.assertEqual(a['matched_tasks'],b['matched_tasks'])
        ids=[];first=self.store.list_packages()
        for page in range(1,first['pages']+1):ids.extend(t['id'] for p in self.store.list_packages(page=page)['packages'] for t in p['tasks'])
        self.assertEqual(len(ids),len(self.catalog['tasks']));self.assertEqual(len(set(ids)),len(ids))
        exact=self.store.list_packages(query='Garen Q')
        self.assertNotIn('CH-Garen-W-SOURCE',[t['id'] for p in exact['packages'] for t in p['tasks']])
        ident='SYS-01.1-05';self.update(ident,done=True)
        self.assertIn(ident,[t['id'] for p in self.store.list_packages(query=ident,status='done')['packages'] for t in p['tasks']]);self.update(ident,done=False)
    def test_07_copy_is_complete_and_precise(self):
        r=self.store.copy_text('task','CH-Garen-Q-SIMULATION')['text']
        for term in ['CH-Garen-Q-SIMULATION','GarenQ','CH-Garen-Q-SOURCE','TRAVAIL À EFFECTUER','RÉSULTAT ATTENDU','SOURCES ET EMPLACEMENTS','VÉRIFICATIONS',str(ROOT)]:
            self.assertIn(term,r)
        self.assertNotIn('Traite tous les champions',r)
        pack=self.store.copy_text('package','D06-CH-Garen')['text']
        self.assertIn('CH-Garen-Q-SOURCE',pack);self.assertIn('CH-Garen-Q-ACCEPTANCE',pack)
    def test_08_export_import_and_undo(self):
        ident='SYS-01.1-06';snapshot=self.store.export();self.update(ident,done=True,notes='test import')
        result=self.store.import_progress(snapshot);self.assertEqual(self.current(ident)['done'],0)
        self.store.undo(result['change_id']);self.assertEqual(self.current(ident)['notes'],'test import');self.update(ident,done=False,notes='')
    def test_09_invalid_import_does_not_overwrite_state(self):
        ident='SYS-01.1-07';before=self.current(ident)
        with self.assertRaises(Invalid):self.store.import_progress({'schema':'openleague_plan_progress/v1','tasks':[{'task_id':ident,'done':1,'notes':'wrong'},{'task_id':'unknown','done':0}]})
        self.assertEqual(self.current(ident)['revision'],before['revision'])
    def test_10_sqlite_consistent_backup(self):
        ident='SYS-01.2-01';self.update(ident,done=True);p=pathlib.Path(self.temp.name)/'backup.sqlite3';self.store.backup(p)
        with contextlib.closing(sqlite3.connect(p)) as c:
            self.assertEqual(c.execute('PRAGMA integrity_check').fetchone()[0],'ok')
            self.assertEqual(c.execute('SELECT done FROM task_state WHERE task_id=?',(ident,)).fetchone()[0],1)
        self.update(ident,done=False)
    def test_11_http_routes_local_boundary(self):
        with urllib.request.urlopen(self.url+'/api/health') as r:self.assertEqual(json.load(r)['ready'],True)
        with urllib.request.urlopen(self.url+'/') as r:self.assertIn('Plan OpenLeague'.encode(),r.read())
        c=http.client.HTTPConnection('127.0.0.1',self.server.server_port)
        c.request('POST','/api/status',body=b'{}',headers={'Origin':'https://example.com','Content-Type':'application/json'})
        r=c.getresponse();self.assertEqual(r.status,403);r.read();c.close()
        try:urllib.request.urlopen(self.url+'/../../AGENTS.md')
        except urllib.error.HTTPError as e:self.assertEqual(e.code,404)
        else:self.fail('Filesystem route exposed')
    def test_12_http_mutation_and_response(self):
        ident='SYS-01.2-02';revision=self.current(ident)['revision']
        req=urllib.request.Request(self.url+'/api/status',data=json.dumps({'updates':[{'id':ident,'revision':revision,'done':True}]}).encode(),headers={'Content-Type':'application/json'})
        with urllib.request.urlopen(req) as r:result=json.load(r)
        self.assertEqual(self.current(ident)['done'],1);self.store.undo(result['change_id'])

    def test_13_old_progress_keeps_archived_global_state_without_checking_children(self):
        ident='OL-01-001'
        with self.store.db() as c:
            c.execute('INSERT OR IGNORE INTO tasks VALUES(?,?,?,?,?,?,?,?,?,?,?,?)',(ident,'retired','P01',999999,'Ancienne tâche globale','work','archive',1,'archive','{}','archive',0))
            c.execute('INSERT OR IGNORE INTO task_state(task_id) VALUES(?)',(ident,));c.commit()
        child_before=self.current('SYS-01.1-01')['done']
        self.store.import_progress({'schema':'openleague_plan_progress/v1','tasks':[{'task_id':ident,'done':1,'notes':'ancienne preuve conservée'}]})
        snapshot=self.store.export()
        archived=next(t for t in snapshot['archived_tasks'] if t['task_id']==ident)
        self.assertEqual((archived['done'],archived['notes']),(1,'ancienne preuve conservée'))
        self.assertEqual(self.current('SYS-01.1-01')['done'],child_before)
        with self.assertRaises(Invalid):self.store.change([{'id':ident,'revision':archived['revision'],'done':False}])

    def test_14_each_champion_is_one_complete_individual_package(self):
        found=self.store.list_packages(phase='D06',query='Elise')
        self.assertEqual(found['matched_packages'],1)
        elise=found['packages'][0]
        self.assertGreater(len(elise['tasks']),100)
        self.assertTrue(any(t['id']=='CH-Elise-KIT' for t in elise['tasks']))
        self.assertTrue(any('SEC' in t['id'] for t in elise['tasks']))
        self.assertGreater(len({t['task_group'] for t in elise['tasks']}),5)

if __name__=='__main__':unittest.main(verbosity=2)
