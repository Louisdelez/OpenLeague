import json,pathlib,sys,unittest
sys.path.insert(0,str(pathlib.Path(__file__).parent))
from audit_community_semantics import buff_literal,class_names,garen_case
R=pathlib.Path('E:/OpenLeague');N=pathlib.Path(json.loads((R/'docs/reference_client_4_20.json').read_bytes())['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy'
class CommunitySemanticTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.case=garen_case(R,N,json.loads((R/'docs/fidelity_community_review_4_20.json').read_bytes()))
 def test_actual_rank_one_match_does_not_qualify_all_silence_ranks(self):
  rows=[x for x in self.case['rank_matrix'] if x['quantity']=='silence_seconds'];self.assertEqual([x['matches_native_base'] for x in rows],[True,False,False,False,False])
 def test_actual_haste_literals_conflict_at_every_rank(self):
  rows=[x for x in self.case['rank_matrix'] if x['quantity']=='haste_seconds'];self.assertEqual(len(rows),5);self.assertFalse(any(x['matches_native_base'] for x in rows))
 def test_named_missing_source_dependency_is_not_full_runtime_proof(self):
  self.assertEqual(self.case['missing_named_haste_class_in_797_sources'],[]);self.assertFalse(self.case['fully_qualified']);self.assertTrue(any('loaded assembly' in x for x in self.case['remaining_unknowns']))
 def test_alternate_conflicting_native_tooltip_remains_explicit(self):
  self.assertNotEqual(self.case['native_tooltip']['line'],self.case['alternate_native_tooltip']['line']);self.assertTrue(any('GarenQBuff' in x for x in self.case['remaining_unknowns']))
 def test_ambiguous_call_refused_and_commented_call_excluded(self):
  call='AddBuff("Silence", 1.5f, 1, spell, ai, owner)';self.assertEqual(buff_literal('// '+call+'\n'+call,'Silence')['seconds'],1.5)
  with self.assertRaisesRegex(ValueError,'one exact'):buff_literal(call+';'+call,'Silence')
 def test_class_name_in_comment_or_string_is_not_a_native_candidate(self):
  self.assertEqual(class_names('// class FalseOne {}\nclass RealOne { string a="class FalseTwo {}";}'),['RealOne'])
if __name__=='__main__':unittest.main(verbosity=2)
