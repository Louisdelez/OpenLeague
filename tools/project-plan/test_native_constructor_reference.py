import copy,json,os,pathlib,sys,unittest
S=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20');R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(pathlib.Path(__file__).parent));sys.path.insert(0,str(R/'tools/project-plan'))
from native_constructor_reference import resolve_rank_default,resolve_effect_default,resolve_projectile_range,resolve_special_recipe
class NativeConstructorTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.doc=json.loads((R/'docs/fidelity_catalogue_comparison_4_20.json').read_bytes());cls.receipt=json.loads((pathlib.Path(os.environ.get('OPENLEAGUE_CONSTRUCTOR_RECEIPTS',str(R/'docs/reference_native_constructor_sources')))/'rank-constructor-execution.json').read_bytes());cls.effect=json.loads((pathlib.Path(os.environ.get('OPENLEAGUE_CONSTRUCTOR_RECEIPTS',str(R/'docs/reference_native_constructor_sources')))/'effect-constructor-execution.json').read_bytes());cls.row=next(x for x in cls.doc['rows'] if x['subject']=='Annie:2' and x['field']=='cooldown:1');cls.sha=cls.doc['native_sources'][cls.row['native_path']]['sha256']
 def test_actual_native_loop_default_is_used(self):self.assertEqual(resolve_rank_default(self.row,self.sha,self.receipt)['value'],10.)
 def test_receipt_for_another_binary_refused(self):
  r={**self.receipt,'binary':{**self.receipt['binary'],'sha256':'0'*64}};self.assertIsNone(resolve_rank_default(self.row,self.sha,r))
 def test_source_sha_mismatch_refused(self):self.assertIsNone(resolve_rank_default(self.row,'0'*64,self.receipt))
 def test_rank_outside_actual_native_loop_not_invented(self):
  r={**self.row,'field':'cooldown:7'};self.assertIsNone(resolve_rank_default(r,self.sha,self.receipt))
 def test_difference_not_erased_by_receipt(self):
  r={**self.row,'catalogue':999};self.assertIsNone(resolve_rank_default(r,self.sha,self.receipt))
 def test_absent_malformed_input_case_stays_open(self):
  r=next(x for x in self.doc['rows'] if x['subject']=='Karma:0' and x['field']=='cooldown:2');self.assertIsNone(resolve_rank_default(r,self.doc['native_sources'][r['native_path']]['sha256'],self.receipt))
 def test_original_effect_default_is_explicit(self):
  r=next(x for x in self.doc['rows'] if x['subject']=='Jayce:0' and x['field']=='effect4:5');self.assertEqual(resolve_effect_default(r,self.doc['native_sources'][r['native_path']]['sha256'],self.effect)['value'],0.)
 def test_nami_primary_and_related_projectile_not_conflated(self):
  row={'family':'champion_display_range','subject':'Nami:3','field':'range:1','catalogue':2750}
  self.assertIsNone(resolve_projectile_range(row,{'Spell4':'NamiR','ExtraSpell1':'Other'},{'CastRange':2750}));r=resolve_projectile_range(row,{'Spell4':'NamiR','ExtraSpell1':'NamiRMissile'},{'CastRange':2750});self.assertFalse(r['mechanical_adoption_qualified'])
 def test_special_recipe_not_regular_recipe_or_shop_admission(self):
  row={'family':'item_recipe_component','native':None,'catalogue':'3169'};self.assertIsNone(resolve_special_recipe(row,{'SpecialRecipe':3169,'InStore':1}));self.assertEqual(resolve_special_recipe(row,{'SpecialRecipe':3169,'InStore':0})['status'],'resolved_native_special_recipe_link')
if __name__=='__main__':unittest.main(verbosity=2)
