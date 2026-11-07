import json
import pathlib
import tempfile
import unittest
from native_skin_loader_reference import OriginalSkinLoader
from reference_inibin import read, hashkey


class OriginalSkinLoaderTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = pathlib.Path('E:/OpenLeague')
        ref = json.loads((cls.root / 'docs/reference_client_4_20.json').read_bytes())
        cls.binary = pathlib.Path(ref['source_root']) / ref['client']['binary']
        cls.loader = OriginalSkinLoader(cls.binary)
        cls.deploy = cls.binary.parent

    def test_01_base_file(self):
        r = self.loader.filename('Renekton', 0, ['Base.ini'])
        self.assertEqual((r['logical_name'], r['dedicated']), ('Base.ini', True))

    def test_02_requested_skin_precedes_base(self):
        r = self.loader.filename('Renekton', 1, ['Base.ini', 'Skin01.ini'])
        self.assertEqual((r['logical_name'], r['dedicated']), ('Skin01.ini', True))
        self.assertEqual([x['logical_name'] for x in r['queries']], ['Skin01.ini', 'Skin01.ini'])

    def test_03_missing_requested_skin_uses_base(self):
        r = self.loader.filename('Renekton', 1, ['Base.ini'])
        self.assertEqual((r['logical_name'], r['dedicated']), ('Base.ini', True))
        self.assertEqual([x['present'] for x in r['queries']], [False, True])

    def test_04_no_dedicated_file_returns_legacy(self):
        r = self.loader.filename('Renekton', 1, [])
        self.assertEqual((r['logical_name'], r['dedicated']), ('Renekton.ini', False))

    def test_05_skin_without_base_is_selected(self):
        r = self.loader.filename('Renekton', 4, ['Skin04.ini'])
        self.assertEqual((r['logical_name'], r['dedicated']), ('Skin04.ini', True))

    def test_06_dedicated_flag_bypasses_legacy_index(self):
        r = self.loader.section('Renekton', 4, True, {hashkey('MeshSkin4', 'SkinScale'): 1.6})
        self.assertEqual(r['section'], 'MeshSkin')
        self.assertEqual(r['lookup_calls'], [])

    def test_07_legacy_index_with_scale(self):
        r = self.loader.section('Renekton', 4, False, {hashkey('MeshSkin4', 'SkinScale'): 1.6})
        self.assertEqual(r['section'], 'MeshSkin4')
        self.assertEqual(r['lookup_calls'][0]['original_default'], -1.)

    def test_08_missing_or_sentinel_scale_keeps_base_section(self):
        for values in [{}, {hashkey('MeshSkin4', 'SkinScale'): -1.}]:
            self.assertEqual(self.loader.section('Renekton', 4, False, values)['section'], 'MeshSkin')

    def test_09_zero_scale_is_not_missing(self):
        self.assertEqual(self.loader.section('Renekton', 4, False, {hashkey('MeshSkin4', 'SkinScale'): 0.})['section'], 'MeshSkin4')

    def test_10_base_number_does_not_probe_index(self):
        r = self.loader.section('Renekton', 0, False, {})
        self.assertEqual(r['section'], 'MeshSkin')
        self.assertEqual(r['lookup_calls'], [])

    def test_11_actual_seven_legacy_sections(self):
        values = read(self.deploy / 'DATA/Characters/Renekton/Renekton.inibin')
        for number in range(7):
            result = self.loader.section('Renekton', number, False, values)
            self.assertEqual(result['section'], 'MeshSkin' + (str(number) if number else ''))

    def test_12_invalid_inputs_explicitly_refused(self):
        for champion, number in [('../Renekton', 1), ('Renekton', True), ('Renekton', -1), ('Renekton', 100)]:
            with self.assertRaises(ValueError):
                self.loader.filename(champion, number, [])
        with self.assertRaises(ValueError):
            self.loader.filename('Renekton', 1, ['../Base.ini'])
        for bad in ['1.6garbage', float('nan'), float('inf'), True]:
            with self.assertRaises(ValueError):
                self.loader.section('Renekton', 1, False, {hashkey('MeshSkin1', 'SkinScale'): bad})

    def test_13_changed_binary_explicitly_refused(self):
        with tempfile.TemporaryDirectory(dir=pathlib.Path(__file__).resolve().parent) as td:
            bad = pathlib.Path(td) / 'changed.exe'
            bad.write_bytes(b'not the native image')
            with self.assertRaisesRegex(ValueError, 'identity mismatch'):
                OriginalSkinLoader(bad)

    def test_14_scope_does_not_claim_original_resource_provider(self):
        self.assertFalse(self.loader.filename('Renekton', 1, ['Skin01.ini'])['original_resource_provider_executed'])
        self.assertFalse(self.loader.section('Renekton', 1, True, {})['original_config_cache_executed'])
        self.assertFalse(self.loader.evidence()['historical_game_process_launched'])

    def test_15_original_bin_suffix_alias(self):
        r = self.loader.alias('Characters/Renekton/Skins/Base/Base.inibin')
        self.assertEqual(r['alias'], {'key': 'Base.ini', 'value': 'Characters/Renekton/Skins/Base/Base.ini'})
        self.assertTrue(r['original_alias_branch_taken'])
        self.assertFalse(r['original_map_insert_executed'])

    def test_16_original_obj_suffix_alias(self):
        r = self.loader.alias('Characters/Renekton/Spells/RenektonQ.luaobj')
        self.assertEqual(r['alias'], {'key': 'RenektonQ.lua', 'value': 'Characters/Renekton/Spells/RenektonQ.lua'})

    def test_17_other_extensions_do_not_get_compiled_alias(self):
        for path in ['Characters/Renekton/Base.ini', 'Characters/Renekton/Base.dds', 'Characters/Renekton/Base.a']:
            r = self.loader.alias(path)
            self.assertIsNone(r['alias'])
            self.assertFalse(r['original_alias_branch_taken'])
        with self.assertRaises(ValueError):
            self.loader.alias('../Base.inibin')


if __name__ == '__main__':
    unittest.main()
