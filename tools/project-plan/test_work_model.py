import copy,hashlib,json,pathlib,sqlite3,tempfile,unittest
import work_model as w
class WorkModelTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory();self.path=pathlib.Path(self.tmp.name)/'subset.sqlite3';self.c=sqlite3.connect(self.path);self.c.execute('PRAGMA foreign_keys=ON')
  self.c.executescript("CREATE TABLE tasks(id TEXT PRIMARY KEY,active INTEGER);CREATE TABLE meta(key TEXT PRIMARY KEY,value TEXT);CREATE TABLE task_state(task_id TEXT PRIMARY KEY,done INTEGER,notes TEXT,revision INTEGER);CREATE TABLE changes(id TEXT PRIMARY KEY,before_json TEXT,after_json TEXT);INSERT INTO tasks VALUES('P',1),('A',1),('B',1),('C',1),('ARCHIVE',0);INSERT INTO task_state VALUES('A',1,'Note conservée ✓',4);INSERT INTO changes VALUES('old','avant','après');")
  self.legacy=lambda:(self.c.execute('SELECT * FROM task_state').fetchall(),self.c.execute('SELECT * FROM changes').fetchall(),self.c.execute('SELECT * FROM tasks').fetchall())
  self.before=self.legacy();w.migrate(self.c);f=pathlib.Path(self.tmp.name)/'proof.txt';f.write_text('Observed scoped fixture evidence',encoding='utf8');self.proof=dict(path=str(f),sha256=hashlib.sha256(f.read_bytes()).hexdigest(),kind='isolated_test_fixture',verified_utc=w.now())
 def tearDown(self):self.c.close();self.tmp.cleanup()
 def body(self,id='A'):
  a=w.assessment(self.c,id);a.pop('inherited');a.pop('updated_at');a.pop('task_id');return a
 def record(self):return {k:'Documented fixture '+k for k in w.CONTRACT['audit_fields']}|dict(reviewer='unit-fixture',reviewed_utc=w.now(),proofs=[self.proof],has_gaps=False,no_correction_reason='No correction in this explicitly bounded synthetic case')
 def fix(self,task='A',objective='Implement one missing fixture behavior',**extra):
  record={k:['explicit fixture value']for k in w.CORRECTION_FIELDS};return w.correction(self.c,dict(task_id=task,objective=objective,record=record,**extra))
 def test_migration_is_additive_idempotent_and_reversible(self):
  w.migrate(self.c);self.assertEqual(self.legacy(),self.before);backup=w.rollback(self.c);self.assertEqual(self.legacy(),self.before);self.assertEqual(set(backup['tables']),set(w.TABLES));self.assertFalse(self.c.execute("SELECT name FROM sqlite_master WHERE name LIKE 'work_%'").fetchall());w.migrate(self.c);self.assertEqual(len(w.definitions(self.c)),7)
 def test_legacy_done_does_not_finish_an_audit(self):
  a=w.assessment(self.c,'A');self.assertTrue(a['inherited']);self.assertEqual(a['audit'],'a_examiner');self.assertEqual(a['implementation'],'non_evaluee');self.assertEqual(w.metrics(self.c)['audits']['numerator'],0)
 def test_finished_audit_can_have_absent_feature_and_open_correction(self):
  fix=self.fix();b=self.body();b.update(audit='termine_avec_preuves',implementation='absente',record=self.record());b['record'].update(has_gaps=True,correction_ids=[fix['id']]);got=w.change(self.c,'A',b);self.assertEqual(got['audit'],'termine_avec_preuves');self.assertEqual(got['implementation'],'absente');self.assertEqual(got['verification'],'non_executee');self.assertEqual(w.metrics(self.c)['corrections']['numerator'],0);self.assertEqual(self.legacy(),self.before)
 def test_identified_source_blocker_does_not_invent_implementation(self):
  b=self.body();b.update(audit='bloque',record=dict(blocker=dict(kind='source',required_input='Exact missing fixture archive',resume_condition='Provide that archive with identity',impact='Cannot determine the historical fixture rule')));w.change(self.c,'A',b);m=w.metrics(self.c);self.assertEqual(m['blockers']['by_kind'],{'source':1});self.assertEqual(w.assessment(self.c,'A')['implementation'],'non_evaluee')
 def test_implemented_but_unverified_is_independent(self):
  b=self.body();b.update(audit='en_cours',implementation='implementee');w.change(self.c,'A',b);self.assertEqual(w.assessment(self.c,'A')['verification'],'non_executee');self.assertEqual(w.metrics(self.c)['audits']['numerator'],0)
 def test_proof_and_scope_required_for_success_and_no_automatic_human_acceptance(self):
  b=self.body();b['verification']='reussie'
  with self.assertRaises(ValueError):w.change(self.c,'A',b)
  b['record']=dict(proofs=[self.proof],verification_scope='Fixture loader refusal only',controls=[dict(name='fixture',expected='refused',observed='refused',execution_kind='isolated',outcome='passed')]);w.change(self.c,'A',b);self.assertEqual(w.assessment(self.c,'A')['acceptance'],'non_demandee')
 def test_acceptance_needs_decision_or_non_applicability_reason(self):
  for status in ['acceptee','refusee','non_applicable']:
   b=self.body();b['acceptance']=status
   with self.assertRaises(ValueError):w.change(self.c,'A',b)
 def test_parent_and_child_are_not_counted_twice_and_cycles_refused(self):
  for id in ['P','A']:
   b=self.body(id);b.update(audit='termine_avec_preuves',record=self.record());b['parent_task_id']='P'if id=='A'else None;w.change(self.c,id,b)
  m=w.metrics(self.c)['audits'];self.assertEqual((m['numerator'],m['denominator']),(1,3));b=self.body('P');b['parent_task_id']='A'
  with self.assertRaises(ValueError):w.change(self.c,'P',b)
 def test_reopening_preserves_assessment_and_legacy_data(self):
  b=self.body();b.update(audit='en_cours',implementation='partielle',record=dict(scope='Persist this scope'));w.change(self.c,'A',b);self.c.close();self.c=sqlite3.connect(self.path);self.assertEqual(w.assessment(self.c,'A')['record']['scope'],'Persist this scope');self.assertEqual(self.legacy(),self.before)
 def test_stale_revision_and_modified_evidence_are_refused(self):
  b=self.body();w.change(self.c,'A',b)
  with self.assertRaises(ValueError):w.change(self.c,'A',b)
  b=self.body();b['record']=self.record();pathlib.Path(self.proof['path']).write_text('different')
  with self.assertRaises(ValueError):w.change(self.c,'A',b)
 def test_partial_or_simulated_journey_does_not_finish_real_journey(self):
  j=w.definitions(self.c)[0];b=dict(revision=0,verification='reussie',record=dict(execution_kind='simulation',scope='partial',passed_criteria=j['definition']['criteria'],proofs=[self.proof]))
  with self.assertRaises(ValueError):w.journey(self.c,j['id'],b)
  b['record']['execution_kind']='real_client';b['record']['passed_criteria']=[]
  with self.assertRaises(ValueError):w.journey(self.c,j['id'],b)
  self.assertEqual(w.metrics(self.c)['journeys']['numerator'],0)
 def test_snapshot_is_dated_and_frozen(self):
  a=w.snapshot(self.c);b=self.body();b['audit']='en_cours';w.change(self.c,'A',b);row=self.c.execute('SELECT created_at,data FROM work_snapshots WHERE id=?',(a['id'],)).fetchone();self.assertTrue(row[0]);self.assertEqual(json.loads(row[1]),a['metrics'])
 def test_weekly_uses_id_sets_and_reports_reopened_audits_and_lifted_blockers(self):
  b=self.body('A');b['audit']='bloque';b['record']=dict(blocker=dict(kind='source',required_input='Missing archive',resume_condition='Supply exact archive',impact='Cannot qualify source'));w.change(self.c,'A',b)
  snap=w.metrics(self.c);snap['evidence_sets']=w.evidence_sets(self.c);self.c.execute('INSERT INTO work_snapshots VALUES(?,?,?)',('baseline','2000-01-01T00:00:00+00:00',json.dumps(snap)));self.c.commit()
  b=self.body();b.update(audit='termine_avec_preuves',record=self.record());w.change(self.c,'A',b);report=w.weekly(self.c);self.assertTrue(report['comparison_available']);self.assertEqual(report['results']['audits'],1);self.assertEqual(report['results']['blockers_lifted'],1)
 def test_snapshots_refuse_update_delete_but_targeted_migration_can_roll_back(self):
  item=w.snapshot(self.c)
  with self.assertRaises(sqlite3.IntegrityError):self.c.execute('UPDATE work_snapshots SET data=? WHERE id=?',('{}',item['id']))
  self.c.rollback()
  with self.assertRaises(sqlite3.IntegrityError):self.c.execute('DELETE FROM work_snapshots WHERE id=?',(item['id'],))
  self.c.rollback();archive=w.rollback(self.c);self.assertEqual(len(archive['tables']['work_snapshots']['rows']),1);self.assertEqual(self.legacy(),self.before)
 def test_roundtrip_targeted_rollback_retains_new_states_and_legacy_values(self):
  b=self.body();b.update(audit='en_cours',implementation='partielle',record=dict(scope='Preserve the exact new assessment'));w.change(self.c,'A',b);w.snapshot(self.c);expected=w.export_work(self.c);archive=w.rollback(self.c);w.restore_work(self.c,archive);after=w.export_work(self.c);self.assertEqual(expected['tables'],after['tables']);self.assertEqual(self.legacy(),self.before)
if __name__=='__main__':unittest.main()
