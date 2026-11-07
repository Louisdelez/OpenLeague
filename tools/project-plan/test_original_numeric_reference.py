import copy,json,os,pathlib,sys,tempfile,unittest
sys.path.insert(0,str(pathlib.Path(__file__).parent))
from original_numeric_reference import OriginalNumeric,resolve_karma_numeric
R=pathlib.Path('E:/OpenLeague');V=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision4')
class OriginalNumericTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  ref=json.loads((R/'docs/reference_client_4_20.json').read_bytes());cls.binary=pathlib.Path(ref['source_root'])/ref['client']['binary'];cls.converter=OriginalNumeric(cls.binary)
  p=pathlib.Path(os.environ.get('OPENLEAGUE_NUMERIC_RECEIPT',str(R/'docs/reference_native_constructor_sources/original-numeric-execution.json')));cls.receipt=json.loads(p.read_bytes());doc=json.loads((R/'docs/fidelity_catalogue_comparison_4_20.json').read_bytes());cls.row=next(x for x in doc['rows'] if x['subject']=='Karma:0' and x['field']=='cooldown:2')
 def test_actual_original_numeric_function_handles_both_native_karma_texts(self):
  self.assertEqual(self.converter.convert('6.5.0000')['value'],6.5);self.assertEqual(self.converter.convert('5.5.0000')['value'],5.5)
 def test_original_suffix_and_exponent_semantics_are_exercised(self):
  self.assertEqual(self.converter.convert('6.5abc')['value'],6.5);self.assertEqual(self.converter.convert('1e2')['value'],100.);self.assertEqual(self.converter.convert('6,5')['value'],6.)
 def test_embedded_nul_nonascii_and_oversized_strings_refused(self):
  for value in ['6.5\0.0','é','1'*1024]:
   with self.assertRaises(ValueError):self.converter.convert(value)
 def test_another_binary_is_never_executed(self):
  with tempfile.TemporaryDirectory(dir=V) as td:
   p=pathlib.Path(td)/'wrong.exe';p.write_bytes(b'MZwrong')
   with self.assertRaisesRegex(ValueError,'identity'):OriginalNumeric(p)
 def test_actual_rank_store_and_numeric_receipt_match_catalogue(self):
  r=resolve_karma_numeric(self.row,self.receipt['native_source']['sha256'],self.receipt);self.assertEqual(r['value'],6.5);self.assertFalse(r['mechanical_adoption_qualified']);self.assertIn('Historical locale',r['scope'])
 def test_wrong_source_and_converter_entry_refused(self):
  self.assertIsNone(resolve_karma_numeric(self.row,'0'*64,self.receipt));p={**self.receipt,'converter':{**self.receipt['converter'],'original_entry':'0x0'}};self.assertIsNone(resolve_karma_numeric(self.row,self.receipt['native_source']['sha256'],p))
 def test_other_field_or_catalogue_difference_not_erased(self):
  for row in [{**self.row,'field':'cooldown:6'},{**self.row,'subject':'Other:0'},{**self.row,'catalogue':99.}]:self.assertIsNone(resolve_karma_numeric(row,self.receipt['native_source']['sha256'],self.receipt))
 def test_missing_original_rank_store_evidence_refused(self):
  p={**self.receipt,'actual_rank_constructor':{}};self.assertIsNone(resolve_karma_numeric(self.row,self.receipt['native_source']['sha256'],p))
if __name__=='__main__':unittest.main(verbosity=2)
