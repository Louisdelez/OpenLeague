import pathlib,sys,unittest
sys.path.insert(0,str(pathlib.Path(__file__).parent));from fidelity_compare import mirror_relation,catalogue_relation
class CompareTests(unittest.TestCase):
 def test_numeric_strings_and_float_error(self):self.assertEqual(mirror_relation('1.5',1.50000001,'Mana'),'numeric_or_exact_match')
 def test_boolean_lexeme_equivalence(self):self.assertEqual(mirror_relation('Yes','true','IsMelee'),'equivalent_boolean_lexemes')
 def test_vector_representation(self):self.assertEqual(mirror_relation([1,2,3],'1 2 3','WorldOffset'),'equivalent_vector_encoding')
 def test_different_vector_not_equal(self):self.assertEqual(mirror_relation([1,2,3],'1 2 4','WorldOffset'),'unresolved_value_or_semantic_difference')
 def test_flags_signedness_only_for_flags(self):
  self.assertEqual(mirror_relation(-2147415804,2147551492,'Flags'),'equivalent_signed_unsigned_u32_bitpattern')
  self.assertEqual(mirror_relation(-2147415804,2147551492,'Damage'),'unresolved_value_or_semantic_difference')
 def test_raw_range_sentinel_never_server_reach(self):
  r=catalogue_relation({'status':'display_value_matches_named_native_field'});self.assertFalse(r['mechanical_adoption_qualified'])
 def test_missing_rank_not_zero_or_scalar_default(self):
  r=catalogue_relation({'status':'missing_or_not_numeric','native':None,'catalogue':0,'family':'champion_spell'});self.assertEqual(r['status'],'open')
 def test_regen_requires_current_actual_value(self):
  row={'status':'divergent','family':'champion_regen','native_raw':1.3016,'catalogue':6.505}
  self.assertEqual(catalogue_relation(row,1.3016)['status'],'resolved_current_native_regeneration');self.assertEqual(catalogue_relation(row,6.505)['status'],'open')
 def test_percent_conversion_limited_to_known_field_subjects(self):
  row={'status':'divergent','family':'champion_spell_effect','subject':'Lissandra:0','native':-.16,'catalogue':16}
  self.assertEqual(catalogue_relation(row)['status'],'signed_fraction_vs_display_percent');row['subject']='Other:0';self.assertEqual(catalogue_relation(row)['status'],'open')
 def test_non_shop_link_not_generic_recipe(self):
  row={'status':'divergent','family':'item_recipe_component','subject':'3040','native':0,'catalogue':3003}
  self.assertEqual(catalogue_relation(row,not_purchasable=True)['status'],'non_shop_evolution_not_buy_recipe');self.assertEqual(catalogue_relation(row)['status'],'open')
if __name__=='__main__':unittest.main(verbosity=2)
