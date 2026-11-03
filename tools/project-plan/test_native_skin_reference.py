import copy,json,pathlib,sys,unittest
sys.path.insert(0,str(pathlib.Path(__file__).parent));from native_skin_reference import choose,integer_identity,resolve
R=pathlib.Path('E:/OpenLeague');ref=json.loads((R/'docs/reference_client_4_20.json').read_bytes());DEP=pathlib.Path(ref['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy'
class SkinReferenceTests(unittest.TestCase):
 def test_legacy_base_and_variant_are_explicit_id_bindings(self):
  base=resolve(DEP,'Akali',0,'84000');skin=resolve(DEP,'Akali',1,'84001');self.assertEqual(base['qualified_bindings'][0]['section'],'MeshSkin');self.assertEqual(skin['qualified_bindings'][0]['section'],'MeshSkin1');self.assertEqual(skin['qualified_bindings'][0]['fields']['Texture'],'Akali_Yellow_TX_CM.dds')
 def test_modern_dedicated_skin_remains_supported(self):
  row=resolve(DEP,'Aatrox',1,'266001');self.assertTrue(row['qualified_bindings']);self.assertTrue(any('Skin01' in x['source']['path'] for x in row['qualified_bindings']))
 def test_wrong_catalogue_id_does_not_bind_same_number(self):
  row=resolve(DEP,'Akali',1,'84002');self.assertFalse(row['qualified_bindings']);self.assertTrue(any(x['status']=='different_explicit_skin_id_refused' for x in row['candidates']))
 def test_absent_variant_never_falls_back_to_base_skin(self):
  row=resolve(DEP,'Akali',999,'84999');self.assertFalse(row['qualified_bindings']);self.assertEqual(row['candidates'][1]['section'],'MeshSkin999')
 def test_actual_renekton_scale_conflict_stays_ambiguous(self):
  row=resolve(DEP,'Renekton',1,'58001');self.assertEqual(row['status'],'ambiguous_native_skin_bindings');self.assertFalse(row['qualified_bindings']);self.assertEqual({x['fields']['SkinScale'] for x in row['candidates'] if x['status']=='matches_explicit_skin_id'},{1.559999942779541,1.6})
 def test_config_identity_does_not_qualify_runtime_skin_dispatch(self):self.assertFalse(resolve(DEP,'Akali',1,'84001')['runtime_skin_selection_qualified'])
 def test_path_traversal_and_invalid_numbers_refused(self):
  for champion,num,sid in [('../Akali',1,'84001'),('Akali',True,'84001'),('Akali',-1,'84001'),('Akali',1,'84001suffix')]:
   with self.assertRaises(ValueError):resolve(DEP,champion,num,sid)
 def test_identity_booleans_and_prefix_strings_refused(self):self.assertIsNone(integer_identity(True));self.assertIsNone(integer_identity('84001.0000'));self.assertEqual(integer_identity('84001'),84001)
 def test_equivalent_candidates_require_all_named_fields_to_match(self):
  one={'status':'matches_explicit_skin_id','fields':{'ChampionSkinID':1,'Texture':'A'}};two=copy.deepcopy(one);self.assertEqual(choose([one,two])['status'],'equivalent_native_skin_bindings');two['fields']['Texture']='B';self.assertEqual(choose([one,two])['status'],'ambiguous_native_skin_bindings')
if __name__=='__main__':unittest.main(verbosity=2)
