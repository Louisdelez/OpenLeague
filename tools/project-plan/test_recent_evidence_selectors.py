import json,pathlib,unittest
from audit_recent_evidence_selectors import pointer,verify_edge,SelectorError
class RecentEvidenceSelectors(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.document=json.loads(pathlib.Path('F:/OpenLeague/docs/reference_rads_empty_sources/rads-empty-v161.json').read_bytes())
 def test_each_real_task_resolves_to_its_entry(self):
  for i,row in enumerate(self.document['associations']):
   self.assertTrue(verify_edge(self.document,'/associations/'+str(i),row['task_id'],'associations'))
 def test_objective_requires_whole_collection(self):
  self.assertTrue(verify_edge(self.document,'/associations','SYS-01.2-02','associations'))
  with self.assertRaises(SelectorError):verify_edge(self.document,'/associations/0','SYS-01.2-02','associations')
 def test_original_regression_missing_facts_refused(self):
  with self.assertRaises(SelectorError):verify_edge(self.document,'/facts','EMPTY-033-CLASSIFY','associations')
 def test_neighbor_task_rebinding_refused(self):
  with self.assertRaises(SelectorError):verify_edge(self.document,'/associations/1','EMPTY-033-CLASSIFY','associations')
 def test_bad_indices_refused(self):
  for suffix in ['-1','01','8','-','1.0','']:
   with self.subTest(suffix=suffix),self.assertRaises(SelectorError):pointer(self.document,'/associations/'+suffix)
 def test_scalar_traversal_refused(self):
  with self.assertRaises(SelectorError):pointer(self.document,'/associations/0/task_id/x')
 def test_literal_escaped_keys(self):
  self.assertEqual(pointer({'a/b':{'~':42}},'/a~1b/~0'),42)
  with self.assertRaises(SelectorError):pointer({'a~2b':1},'/a~2b')
 def test_non_pointer_refused(self):
  for s in [None,'associations','']:
   with self.assertRaises(SelectorError):pointer(self.document,s)
if __name__=='__main__':unittest.main(verbosity=2)
