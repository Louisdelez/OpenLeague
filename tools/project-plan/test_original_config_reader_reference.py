import json,pathlib,unittest,tempfile,struct
from original_config_reader_reference import OriginalConfigReader

class OriginalConfigReaderTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  ref=json.loads(pathlib.Path('E:/OpenLeague/docs/reference_client_4_20.json').read_bytes());binary=pathlib.Path(ref['source_root'])/ref['client']['binary'];cls.binary=binary;cls.reader=OriginalConfigReader(binary);cls.deploy=binary.parent
 def test_01_actual_Renekton_base_parsed_and_typed_getters(self):
  r=self.reader.parse('Characters/Renekton/Skins/Base/Base.ini',self.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin');self.assertEqual(r['bytes_consumed'],r['bytes'])
  self.assertEqual(self.reader.string_field('MeshSkin','ChampionSkinID')['value'],'58000')
  self.assertEqual(self.reader.string_field('MeshSkin','Texture')['value'],'renekton_base_TX_CM.dds')
  self.assertEqual(self.reader.float_field('MeshSkin','SkinScale')['value'],1.559999942779541)
 def test_02_original_legacy_sections_and_packed_float(self):
  p=self.deploy/'DATA/Characters/Renekton/Renekton.inibin';self.reader.parse('Characters/Renekton/Renekton.ini',p)
  for n in range(7):
   section='MeshSkin'+(str(n) if n else '')
   self.assertEqual(int(self.reader.identity_field(section)['value']),58000+n)
   self.assertEqual(self.reader.float_field(section,'SkinScale')['value'],struct.unpack('<f',struct.pack('<f',1.6))[0])
 def test_03_absent_typed_fields_remain_absent(self):
  self.reader.parse('Characters/Renekton/Skins/Base/Base.ini',self.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin')
  self.assertFalse(self.reader.float_field('MeshSkin','NoSuchField')['found']);self.assertFalse(self.reader.string_field('MeshSkin','NoSuchField')['found'])
 def test_04_truncated_stream_refused_at_original_read(self):
  with tempfile.TemporaryDirectory(dir=pathlib.Path(__file__).parent) as d:
   p=pathlib.Path(d)/'truncated.inibin';p.write_bytes((self.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin').read_bytes()[:-1])
   with self.assertRaisesRegex(ValueError,'Truncated compiled reference stream'):self.reader.parse('Base.ini',p)
 def test_05_wrong_binary_version_original_refusal(self):
  with tempfile.TemporaryDirectory(dir=pathlib.Path(__file__).parent) as d:
   p=pathlib.Path(d)/'wrong-version.inibin';raw=bytearray((self.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin').read_bytes());raw[0]=3;p.write_bytes(raw)
   with self.assertRaisesRegex(ValueError,'Original compiled parser refused'):self.reader.parse('Base.ini',p)
 def test_06_append_bin_is_original_and_exact(self):
  r=self.reader.parse('Characters/Renekton/Skins/Skin04/Skin04.ini',self.deploy/'DATA/Characters/Renekton/Skins/Skin04/Skin04.inibin')
  self.assertEqual(r['opened'],[{'requested_name':'Characters/Renekton/Skins/Skin04/Skin04.inibin','mode':'rb','supplied':True}])
  self.assertEqual(self.reader.identity_field('MeshSkin')['value'],58004)
 def test_07_original_parser_scope_explicit(self):
  d=self.reader.evidence();self.assertFalse(d['original_config_cache_manager_executed']);self.assertFalse(d['original_host_file_provider_executed']);self.assertFalse(d['historical_game_process_launched'])
 def test_08_general_getter_success_survives_cookie_and_typed_fallbacks(self):
  self.reader.parse('Characters/Renekton/Skins/Base/Base.ini',self.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin')
  r=self.reader.numeric_field('MeshSkin','SkinScale');self.assertTrue(r['found']);self.assertEqual(r['value'],1.559999942779541)
  r=self.reader.numeric_field('MeshSkin','ChampionSkinID');self.assertTrue(r['found']);self.assertEqual(r['value'],58000.)
  self.reader.parse('Characters/Renekton/Skins/Skin04/Skin04.ini',self.deploy/'DATA/Characters/Renekton/Skins/Skin04/Skin04.inibin')
  r=self.reader.numeric_field('MeshSkin','ChampionSkinID');self.assertTrue(r['found']);self.assertEqual(r['value'],58004.)
 def test_09_section_gate_uses_original_compiled_getter(self):
  from original_skin_provider_reference import OriginalSkinProvider
  provider=OriginalSkinProvider(self.binary)
  self.reader.parse('Characters/Renekton/Renekton.ini',self.deploy/'DATA/Characters/Renekton/Renekton.inibin')
  r=provider.section_using_compiled_reader('Renekton',4,False,self.reader);self.assertEqual(r['section'],'MeshSkin4');self.assertFalse(r['python_inibin_lookup_used']);self.assertTrue(r['native_compiled_lookup_transfers'][0]['getter']['found'])
  self.reader.parse('Characters/Renekton/Skins/Base/Base.ini',self.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin')
  r=provider.section_using_compiled_reader('Renekton',4,False,self.reader);self.assertEqual(r['section'],'MeshSkin');self.assertFalse(r['native_compiled_lookup_transfers'][0]['getter']['found']);self.assertEqual(r['native_compiled_lookup_transfers'][0]['original_default'],-1.)

if __name__=='__main__':unittest.main()
