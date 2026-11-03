import copy
import json
import os
import pathlib
import struct
import unittest

from native_base_scale_catalogue import ScaleError, bits, compressed_field, compressed_tenths, repair
from reference_inibin import InibinError, decode, hashkey

ROOT = pathlib.Path('E:/OpenLeague')


class NativeBaseScaleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.fixture = json.loads((ROOT / 'crates/client/src/animation_scale_reference_cases.json').read_bytes())
        cls.manifest = json.loads((ROOT / 'data/4.20/animation_manifest.json').read_bytes())
        path = pathlib.Path(os.environ.get('OPENLEAGUE_COMPRESSED_RECEIPT', str(
            ROOT / 'docs/reference_native_skin_loader_sources/original-compressed-byte-precision.json')))
        cls.qualification = json.loads(path.read_bytes())
        cls.source_root = json.loads((ROOT / 'docs/reference_client_4_20.json').read_bytes())['source_root']

    def test_01_all_actual_bindings_match_and_non_scale_fields_are_preserved(self):
        original = copy.deepcopy(self.manifest)
        result, receipt = repair(self.manifest, self.fixture, self.qualification, self.source_root)
        self.assertEqual(self.manifest, original)
        self.assertEqual(len(receipt['rows']), 122)
        self.assertEqual(receipt['qualified_type2_sources'], 51)
        self.assertTrue(receipt['all_122_bits_match'])
        for change in receipt['changes']:
            result[change['key']]['scale'] = change['before_value']
        self.assertEqual(result, original)

    def test_02_all_256_outputs_match_original_instruction_vectors(self):
        for row in self.qualification['supplemental_cases']:
            self.assertEqual(bits(compressed_tenths(row['byte'])),
                             row['observed']['scalar']['float32_hex'])

    def test_03_comparison_reader_keeps_its_old_semantics(self):
        key = int(hashkey('MeshSkin', 'SkinScale'))
        data = b'\2' + struct.pack('<HHHI', 0, 4, 1, key) + b'\r'
        self.assertEqual(bits(decode(data)[str(key)]), '6666a63f')
        self.assertEqual(bits(compressed_tenths(compressed_field(data))), '6766a63f')

    def test_04_invalid_byte_and_nonfinite_scale_refused(self):
        for value in [-1, 256, 13.0, True]:
            with self.assertRaises(ScaleError):
                compressed_tenths(value)
        for value in [float('nan'), float('inf'), '1.3', True]:
            with self.assertRaises(ScaleError):
                bits(value)

    def test_05_truncated_and_duplicate_native_tables_refused(self):
        key = int(hashkey('MeshSkin', 'SkinScale'))
        for data in [b'\2' + struct.pack('<HHHI', 0, 4, 1, key),
                     b'\2' + struct.pack('<HHHII', 0, 4, 2, key, key) + b'\r\r']:
            with self.assertRaises((InibinError, ScaleError)):
                compressed_field(data)

    def test_06_changed_native_source_identity_refused(self):
        fixture = copy.deepcopy(self.fixture)
        fixture['cases'][0]['source']['sha256'] = '0' * 64
        with self.assertRaisesRegex(ScaleError, 'source changed'):
            repair(self.manifest, fixture, self.qualification, self.source_root)

    def test_07_golden_disagreement_refused(self):
        fixture = copy.deepcopy(self.fixture)
        next(x for x in fixture['cases'] if x['champion'] == 'Akali')['native_float32_hex'] = '00000000'
        with self.assertRaisesRegex(ScaleError, 'disagreement'):
            repair(self.manifest, fixture, self.qualification, self.source_root)

    def test_08_non_type2_repair_and_missing_catalogue_entry_refused(self):
        manifest = copy.deepcopy(self.manifest)
        manifest['aatrox']['scale'] = 99
        with self.assertRaisesRegex(ScaleError, 'Non-type-2'):
            repair(manifest, self.fixture, self.qualification, self.source_root)
        del manifest['aatrox']
        with self.assertRaisesRegex(ScaleError, 'binding absent'):
            repair(manifest, self.fixture, self.qualification, self.source_root)

    def test_09_unqualified_operator_or_incomplete_corpus_refused(self):
        for mode in ['operator', 'corpus', 'partial']:
            receipt = copy.deepcopy(self.qualification)
            if mode == 'operator':
                receipt['original_multiplications'][0]['memory_operands'][0]['bytes'] = '00000000'
            elif mode == 'corpus':
                receipt['supplemental_cases'].pop()
            else:
                receipt['passed'] = False
            with self.assertRaises(ScaleError):
                repair(self.manifest, self.fixture, receipt, self.source_root)

    def test_10_selected_source_escape_and_duplicate_binding_refused(self):
        fixture = copy.deepcopy(self.fixture)
        fixture['cases'][0]['source']['path'] = str(ROOT / 'AGENTS.md')
        with self.assertRaisesRegex(ScaleError, 'escapes'):
            repair(self.manifest, fixture, self.qualification, self.source_root)
        fixture = copy.deepcopy(self.fixture)
        fixture['cases'][1]['current_manifest_key'] = fixture['cases'][0]['current_manifest_key']
        with self.assertRaisesRegex(ScaleError, 'distinct'):
            repair(self.manifest, fixture, self.qualification, self.source_root)


if __name__ == '__main__':
    unittest.main(verbosity=2)
