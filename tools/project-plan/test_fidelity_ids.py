import copy,json,os,pathlib,sys,unittest,uuid
ROOT=pathlib.Path('E:/OpenLeague');S=pathlib.Path(__file__).parent
sys.path.insert(0,os.environ.get('OPENLEAGUE_FIDELITY_CODE_ROOT',str(ROOT/'tools/project-plan')))
from fidelity_ids import IdentityError,NAMESPACE,canonical_task_key,for_task,stable_id,validate,validate_aliases
SNAPSHOT=pathlib.Path(os.environ.get('OPENLEAGUE_FIDELITY_ID_SNAPSHOT',str(ROOT)))

class FidelityIdentityTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.reg=json.loads((ROOT/'docs/completion_tasks_2026-10-20.json').read_bytes())
  cls.doc=json.loads((SNAPSHOT/'docs/fidelity_requirement_ids_4_20.json').read_bytes())
 def test_01_all_current_historical_and_archived_requirements_have_unique_ids(self):
  r=validate(self.doc,self.reg)
  self.assertEqual(r['active_requirements'],42214);self.assertEqual(r['historical_requirements'],151)
  self.assertEqual(r['archived_requirements'],392);self.assertEqual(r['unique_identities'],42757)
 def test_02_titles_status_evidence_and_order_do_not_change_identity(self):
  t={'id':'CH-Garen-Q-SOURCE','title':'Initial','status':'a_faire'}
  ident=for_task(t);t.update(title='Renommé',status='a_valider',evidence=['new.json'])
  self.assertEqual(for_task(t),ident)
  self.assertEqual([for_task(x) for x in reversed(self.reg['tasks'][:25])],list(reversed([for_task(x) for x in self.reg['tasks'][:25]])))
 def test_03_empty_scan_ordinal_and_windows_path_case_are_not_identity(self):
  a={'id':'EMPTY-001-CLASSIFY','entity':r'DATA\Spells\Example.luaobj'}
  b={'id':'EMPTY-999-CLASSIFY','entity':'data/spells/example.luaobj'}
  self.assertEqual(for_task(a),for_task(b))
  b['id']='EMPTY-999-RESOLVE';self.assertNotEqual(for_task(a),for_task(b))
 def test_04_namespace_is_pinned_independently_of_task_description(self):
  ns=uuid.UUID('ca018cd0-36bd-56d9-8515-f616cb194d4a')
  self.assertEqual(NAMESPACE,ns)
  self.assertEqual(for_task({'id':'SYS-01.2-01'}),'OLF-'+str(uuid.uuid5(ns,'task:SYS-01.2-01')))
 def test_05_source_resource_must_stay_inside_native_relative_root(self):
  for value in ['../outside','C:/outside','/outside',r'..\outside','']:
   with self.subTest(value=value),self.assertRaises(IdentityError):for_task({'id':'EMPTY-001-CLASSIFY','entity':value})
 def test_06_missing_or_duplicate_active_record_refused(self):
  for mode in ['missing','duplicate']:
   d=copy.deepcopy(self.doc)
   if mode=='missing':d['requirements'].pop()
   else:d['requirements'].append(d['requirements'][0])
   with self.subTest(mode=mode),self.assertRaisesRegex(IdentityError,'coverage incomplete'):validate(d,self.reg)
 def test_07_rebinding_existing_id_refused(self):
  d=copy.deepcopy(self.doc);d['requirements'][0]['requirement_id']=d['requirements'][1]['requirement_id']
  with self.assertRaisesRegex(IdentityError,'identity rebound'):validate(d,self.reg)
 def test_08_historical_and_archived_ids_cannot_disappear(self):
  for key in ['historical_requirements','archived_requirements']:
   d=copy.deepcopy(self.doc);d[key].pop()
   with self.subTest(key=key),self.assertRaisesRegex(IdentityError,'coverage incomplete|identities dropped'):validate(d,self.reg)
 def test_09_changed_definition_requires_explicit_registry_refresh_not_new_identity(self):
  r=copy.deepcopy(self.reg);r['tasks'][0]['title']='Changed scope'
  self.assertEqual(for_task(r['tasks'][0]),for_task(self.reg['tasks'][0]))
  with self.assertRaisesRegex(IdentityError,'definitions changed'):validate(self.doc,r)
 def test_10_new_requirement_not_silently_absorbed_by_existing_one(self):
  self.assertNotEqual(for_task({'id':'SYS-01.2-01'}),for_task({'id':'SYS-01.2-02'}))
  d=copy.deepcopy(self.doc);d['namespace_uuid']=str(uuid.UUID(int=0))
  with self.assertRaisesRegex(IdentityError,'namespace/schema'):validate(d,self.reg)
 def test_11_no_manual_acceptance_inferred_from_identity_assignment(self):
  for key,value in [('manual_state_mutated',True),('human_acceptance','accepted')]:
   d=copy.deepcopy(self.doc);d[key]=value
   with self.subTest(key=key),self.assertRaisesRegex(IdentityError,'manual acceptance'):validate(d,self.reg)
 def test_12_invalid_raw_identifiers_refused(self):
  for value in [None,'',' leading','line\nother']:
   with self.subTest(value=value),self.assertRaises(IdentityError):canonical_task_key({'id':value})
 def test_13_positional_task_families_reindex_without_identity_changes(self):
  samples=[('REF-01-AUDIT','REF-999-AUDIT'),('STRUCTURE-00-POSITION','STRUCTURE-999-POSITION'),
           ('CAMP-00-SOURCE','CAMP-999-SOURCE'),('TT-MAT-000-SOURCE','TT-MAT-999-SOURCE'),('ROLE-01','ROLE-999')]
  for old,new in samples:
   task=next(t for t in self.reg['tasks'] if t['id']==old);changed=copy.deepcopy(task);changed['id']=new
   with self.subTest(old=old):self.assertEqual(for_task(task),for_task(changed))
 def test_14_semantic_aliases_refuse_duplicate_or_rebound_seed(self):
  from fidelity_ids import __file__ as module_path
  original=json.loads(pathlib.Path(module_path).with_name('fidelity_identity_aliases_4_20.json').read_bytes())
  d=copy.deepcopy(original);d['bindings'].append(d['bindings'][0])
  with self.assertRaisesRegex(IdentityError,'Duplicate or ambiguous'):validate_aliases(d)
  d=copy.deepcopy(original);d['bindings'][0]['requirement_id']=d['bindings'][1]['requirement_id']
  with self.assertRaises(IdentityError):validate_aliases(d)
 def test_15_positional_identity_needs_its_semantic_subject(self):
  for task in [{'id':'ROLE-01','entity':{}},{'id':'TT-MAT-000-SOURCE','entity':{}},{'id':'CAMP-00-SOURCE','entity':None}]:
   with self.subTest(task=task),self.assertRaises(IdentityError):for_task(task)

if __name__=='__main__':unittest.main(verbosity=2)
