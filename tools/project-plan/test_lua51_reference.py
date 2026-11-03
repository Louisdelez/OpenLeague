import copy,json,pathlib,struct,sys,unittest
sys.path.insert(0,str(pathlib.Path(__file__).parent))
from lua51_reference import HEADER,LuaReferenceError,Reader,inspect,literal_globals
R=pathlib.Path('E:/OpenLeague');N=pathlib.Path(json.loads((R/'docs/reference_client_4_20.json').read_bytes())['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy'
class LuaReferenceTests(unittest.TestCase):
 def test_actual_passive_agrees_with_prior_independent_structural_receipt(self):
  previous=json.loads((R/'docs/garen_passive_source_audit.json').read_bytes())['native_sources']
  for x in previous:
   if not x['path'].endswith('.luaobj'):continue
   actual=inspect(pathlib.Path(x['path']));self.assertEqual(actual['sha256'],x['sha256']);self.assertEqual(actual['top_level_instructions'],x['top_level_instructions']);self.assertEqual(actual['child_function_prototypes'],x['child_functions']);self.assertTrue(actual['reader_consumed_all_bytes'])
 def test_actual_passive_has_named_metadata_not_server_callbacks(self):
  r=inspect(N/'DATA/Characters/Garen/Spells/GarenPassive.luaobj');self.assertEqual(r['literal_initialization']['globals']['BuffName'],'GarenPassive');self.assertFalse(r['original_server_behavior_proven'])
 def test_wrong_header_refused(self):
  with self.assertRaisesRegex(LuaReferenceError,'header'):Reader(b'notlua')
 def test_truncation_refused(self):
  p=N/'DATA/Characters/Garen/Spells/GarenPassive.luaobj'
  with self.assertRaises(LuaReferenceError):Reader(p.read_bytes()[:-1]).parse()
 def test_trailing_bytes_refused(self):
  p=N/'DATA/Characters/Garen/Spells/GarenPassive.luaobj'
  with self.assertRaisesRegex(LuaReferenceError,'Trailing'):Reader(p.read_bytes()+b'extra').parse()
 def test_unbounded_count_refused(self):
  with self.assertRaisesRegex(LuaReferenceError,'count'):Reader(HEADER+struct.pack('<I',0xffffffff)).parse()
 def test_engine_global_is_symbolic_not_false_or_zero(self):
  p={'children':[],'constants':['ENGINE','VALUE'],'max_stack':2,'words':[5,7+(1<<14),30+(1<<23)]};r=literal_globals(p);self.assertEqual(r['globals']['VALUE'],{'unresolved_engine_global':'ENGINE'})
 def test_branch_discards_earlier_literals(self):
  p={'children':[],'constants':['value',42.],'max_stack':2,'words':[1+(1<<14),7,22,30+(1<<23)]};r=literal_globals(p);self.assertFalse(r['qualified_straight_line_literals']);self.assertEqual(r['globals'],{})
 def test_nested_callback_does_not_become_metadata_only_success(self):
  self.assertFalse(literal_globals({'children':[{}]})['qualified_straight_line_literals'])
 def test_constant_index_outside_pool_refused(self):
  with self.assertRaisesRegex(LuaReferenceError,'constant index'):literal_globals({'children':[],'constants':[],'max_stack':2,'words':[1]})
if __name__=='__main__':unittest.main(verbosity=2)
