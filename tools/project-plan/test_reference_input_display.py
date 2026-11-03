import copy,unittest
from requirement_trace import append_reference_inputs,TraceError

class ReferenceInputDisplayTests(unittest.TestCase):
 def setUp(self):
  self.source=dict(path='C:/explicit/source-contract.json',sha256='a'*64)
  self.sources={'one':self.source};self.row=dict(reference_inputs=[dict(source_id='one',relation='local_contract_not_native_game_rule',selector='/rules')]);self.lines=[]
 def test_local_contract_is_precise_without_native_or_acceptance_promotion(self):
  before=copy.deepcopy((self.row,self.sources));append_reference_inputs(self.row,self.sources,self.lines);text='\n'.join(self.lines)
  for s in ['C:/explicit/source-contract.json','a'*64,'local_contract_not_native_game_rule','/rules','ni complétude native ni comportement accepté']:self.assertIn(s,text)
  self.assertNotIn('Source native associée',text);self.assertEqual((self.row,self.sources),before)
 def test_distinct_conflicting_selectors_survive_a_shared_source(self):
  self.row['reference_inputs'] += [dict(source_id='one',relation='other_configuration',selector='/priority/other'),dict(source_id='one',relation='local_contract_not_native_game_rule',selector='/rules')]
  append_reference_inputs(self.row,self.sources,self.lines);text='\n'.join(self.lines);self.assertEqual(text.count(self.source['path']),1);self.assertEqual(text.count('/rules'),1);self.assertIn('/priority/other',text)
 def test_three_distinct_sources_and_overflow_are_explicit(self):
  for i in range(2,6):
   sid=str(i);self.sources[sid]=dict(path=f'C:/reference-{i}.json',sha256=str(i)*64);self.row['reference_inputs'].append(dict(source_id=sid,relation='research_not_recovered_native_contract',selector=None))
  append_reference_inputs(self.row,self.sources,self.lines);text='\n'.join(self.lines);self.assertEqual(text.count('- Référence associée :'),3);self.assertIn('supplémentaires : 2',text);self.assertIn('non précisé',text);self.assertNotIn('reference-4.json',text)
 def test_empty_references_do_not_invent_a_source(self):
  self.row['reference_inputs']=[];append_reference_inputs(self.row,self.sources,self.lines);self.assertEqual(self.lines,[])
 def test_unregistered_source_is_an_explicit_refusal(self):
  with self.assertRaisesRegex(TraceError,'Reference source missing'):append_reference_inputs(self.row,{},self.lines)
 def test_missing_path_or_sha_is_an_explicit_refusal(self):
  for change in [dict(path=' '),dict(sha256='not-a-sha')]:
   with self.subTest(change=change),self.assertRaisesRegex(TraceError,'identity incomplete'):append_reference_inputs(self.row,{'one':{**self.source,**change}},[])
 def test_missing_relation_cannot_be_hidden_by_source_presence(self):
  self.row['reference_inputs'][0]['relation']=' '
  with self.assertRaisesRegex(TraceError,'relation missing'):append_reference_inputs(self.row,self.sources,self.lines)
 def test_unseen_fourth_source_is_validated_before_truncation(self):
  self.test_three_distinct_sources_and_overflow_are_explicit();self.sources.pop('5')
  with self.assertRaisesRegex(TraceError,'Reference source missing'):append_reference_inputs(self.row,self.sources,[])

if __name__=='__main__':unittest.main(verbosity=2)
