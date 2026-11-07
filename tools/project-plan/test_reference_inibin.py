import pathlib,struct,sys,unittest
sys.path.insert(0,str(pathlib.Path(__file__).parent));from reference_inibin import decode,InibinError,hashkey
def sample(bit,fmt,value):
 vals=value if isinstance(value,(tuple,list)) else [value]
 return struct.pack('<BHHHI',2,0,1<<bit,1,123)+struct.pack('<'+fmt,*vals)
class InibinTests(unittest.TestCase):
 def test_packed_scalar_tenths(self):self.assertEqual(decode(sample(2,'B',15))['123'],1.5)
 def test_three_packed_components_tenths(self):self.assertEqual(decode(sample(6,'3B',[0,20,0]))['123'],[0.,2.,0.])
 def test_two_packed_components_tenths(self):self.assertEqual(decode(sample(8,'2B',[10,50]))['123'],[1.,5.])
 def test_four_packed_components_tenths(self):self.assertEqual(decode(sample(10,'4B',[50,50,50,30]))['123'],[5.,5.,5.,3.])
 def test_float_vector_not_divided_by_ten(self):self.assertEqual(decode(sample(7,'3f',[166,16,59]))['123'],[166.,16.,59.])
 def test_byte_integer_not_tenths(self):self.assertEqual(decode(sample(4,'B',15))['123'],15)
 def test_packed_zero_one_has_numeric_projection_as_independent_reader(self):
  a=decode(sample(5,'B',1))['123'];self.assertEqual(a,1);self.assertIs(type(a),int)
 def test_truncation_refused(self):
  with self.assertRaises(InibinError):decode(sample(10,'4B',[50,50,50,30])[:-1])
 def test_wrong_version_refused(self):
  with self.assertRaises(InibinError):decode(b'\x01'+b'\0'*4)
 def test_hash_normalization(self):self.assertEqual(hashkey('SpellData','Cooldown1'),hashkey('spelldata','cooldown1'))
 def test_actual_native_azir_level_vector_matches_independent_decoder_contract(self):
  import json
  ref=json.loads(pathlib.Path('E:/OpenLeague/docs/reference_client_4_20.json').read_bytes())
  p=pathlib.Path(ref['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Characters/Azir/Azir.inibin'
  self.assertEqual(decode(p.read_bytes())[hashkey('Data','MaxLevels')],[5.,5.,5.,3.])
if __name__=='__main__':unittest.main(verbosity=2)
