import json,pathlib,unittest
from original_skin_provider_reference import OriginalSkinProvider

class OriginalSkinProviderTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  d=json.loads(pathlib.Path('E:/OpenLeague/docs/reference_client_4_20.json').read_bytes());cls.loader=OriginalSkinProvider(pathlib.Path(d['source_root'])/d['client']['binary'])
 def test_01_local_dedicated(self):
  p=[{'context':'DATA','local':{'Skin01.ini':'Characters/Renekton/Skins/Skin01/Skin01.ini'},'base':{'Base.ini':'Characters/Renekton/Skins/Base/Base.ini'}}]
  r=self.loader.filename_native('Renekton',1,p);self.assertEqual((r['logical_name'],r['dedicated']),('Skin01.ini',True));self.assertTrue(r['original_resource_provider_executed'])
 def test_02_base_map_fallback(self):
  p=[{'context':'DATA','local':{},'base':{'Base.ini':'Characters/Renekton/Skins/Base/Base.ini'}}]
  r=self.loader.filename_native('Renekton',1,p);self.assertEqual((r['logical_name'],r['dedicated']),('Base.ini',True));self.assertEqual([x['result'] for x in r['provider_queries']],[False,True])
 def test_03_no_dedicated_uses_legacy(self):
  r=self.loader.filename_native('Akali',1,[{'context':'DATA','local':{},'base':{'Akali.ini':'Characters/Akali/Akali.ini'}}]);self.assertEqual((r['logical_name'],r['dedicated']),('Akali.ini',False))
 def test_04_resolved_local_path(self):
  p=[{'context':'DATA','local':{'Skin01.ini':'Characters/Renekton/Skins/Skin01/Skin01.ini'},'base':{}}]
  self.assertEqual(self.loader.resolve_path('Skin01.ini',p)['path'],p[0]['local']['Skin01.ini'])
 def test_05_resolved_base_path(self):
  p=[{'context':'DATA','local':{},'base':{'Base.ini':'Characters/Renekton/Skins/Base/Base.ini'}}]
  self.assertEqual(self.loader.resolve_path('Base.ini',p)['path'],p[0]['base']['Base.ini'])
 def test_06_case_insensitive_file_keys(self):
  p=[{'context':'DATA','local':{'sKiN01.InI':'Characters/Renekton/Skins/Skin01/Skin01.ini'},'base':{}}]
  self.assertTrue(self.loader.filename_native('Renekton',1,p)['dedicated']);self.assertEqual(self.loader.resolve_path('SKIN01.INI',p)['path'],p[0]['local']['sKiN01.InI'])
 def test_07_missing_path_empty(self):
  self.assertEqual(self.loader.resolve_path('missing.ini',[{'context':'DATA','local':{},'base':{}}])['path'],'')
 def test_08_provider_order_for_local(self):
  p=[{'context':'first','local':{'Base.ini':'first/Base.ini'},'base':{}},{'context':'second','local':{'Base.ini':'second/Base.ini'},'base':{}}]
  self.assertEqual(self.loader.resolve_path('Base.ini',p)['path'],'first/Base.ini');self.assertEqual(self.loader.resolve_path('Base.ini',p[::-1])['path'],'second/Base.ini')
 def test_09_all_local_maps_precede_all_base_maps_for_path(self):
  p=[{'context':'first','local':{},'base':{'Base.ini':'first/base/Base.ini'}},{'context':'second','local':{'Base.ini':'second/local/Base.ini'},'base':{}}]
  self.assertEqual(self.loader.resolve_path('Base.ini',p)['path'],'second/local/Base.ini')
 def test_10_invalid_or_ambiguous_map_refused(self):
  for p in [[],[{'context':'DATA','local':{'Base.ini':'a','base.ini':'b'},'base':{}}],[{'context':'DATA','local':{},'base':{}},{'context':'DATA','local':{},'base':{}}]]:
   with self.assertRaises(ValueError):self.loader.filename_native('Renekton',1,p)
 def test_11_real_tree_search_multiple_keys(self):
  m={f'Skin{n:02}.ini':f'Characters/Renekton/Skins/Skin{n:02}/Skin{n:02}.ini' for n in range(1,8)};p=[{'context':'DATA','local':m,'base':{}}]
  for n in range(1,8):self.assertEqual(self.loader.resolve_path(f'Skin{n:02}.ini',p)['path'],m[f'Skin{n:02}.ini'])
 def test_12_scope_keeps_map_population_cache_and_game_open(self):
  d=self.loader.evidence();self.assertFalse(d['original_package_map_construction_executed']);self.assertFalse(d['original_compiled_config_cache_executed']);self.assertFalse(d['historical_game_process_launched'])
 def test_13_original_alias_registration_constructs_native_map(self):
  r=self.loader.register_physical_files(['Characters/Renekton/Skins/Base/Base.inibin'])
  self.assertEqual(r['entries'],{'Base.ini':'Characters/Renekton/Skins/Base/Base.ini','Base.inibin':'Characters/Renekton/Skins/Base/Base.inibin'})
 def test_14_original_insertions_queries_and_file_selection(self):
  self.loader.register_physical_files(['Characters/Renekton/Skins/Base/Base.inibin','Characters/Renekton/Skins/Skin01/Skin01.inibin','Characters/Renekton/Renekton.inibin'])
  r=self.loader.filename_registered('Renekton',1);self.assertEqual((r['logical_name'],r['dedicated']),('Skin01.ini',True))
  self.assertEqual(self.loader.resolve_registered(r['logical_name'])['path'],'Characters/Renekton/Skins/Skin01/Skin01.ini')
 def test_15_original_balancing_and_missing_lookup(self):
  files=[f'Characters/Renekton/Skins/Skin{n:02}/Skin{n:02}.inibin' for n in range(1,20)]
  r=self.loader.register_physical_files(files);self.assertEqual(r['native_map_count'],38)
  for n in [1,8,19]:self.assertEqual(self.loader.resolve_registered(f'Skin{n:02}.ini')['path'],files[n-1][:-3])
  self.assertEqual(self.loader.resolve_registered('missing.ini')['path'],'')
 def test_16_original_duplicate_key_last_value(self):
  self.loader.register_physical_files(['Characters/First/Base.inibin','Characters/Second/Base.inibin'])
  self.assertEqual(self.loader.resolve_registered('base.INI')['path'],'Characters/Second/Base.ini')
 def test_17_reset_cannot_reuse_claim_of_registered_map(self):
  self.loader.register_physical_files(['Characters/First/Base.inibin']);self.loader.resolve_path('Base.ini',[{'context':'DATA','local':{},'base':{}}])
  with self.assertRaises(ValueError):self.loader.resolve_registered('Base.ini')

if __name__=='__main__':unittest.main()
