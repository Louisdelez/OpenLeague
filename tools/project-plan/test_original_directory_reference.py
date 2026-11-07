import json
import pathlib
import tempfile
import unittest

from original_directory_reference import OriginalDirectoryScanner

R = pathlib.Path('E:/OpenLeague')
TEMP = pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision8')


class OriginalDirectoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        ref = json.loads((R/'docs/reference_client_4_20.json').read_bytes())
        cls.binary = pathlib.Path(ref['source_root'])/ref['client']['binary']
        cls.scanner = OriginalDirectoryScanner(cls.binary, cls.binary.parent/'DATA')

    def test_01_original_scanner_registers_actual_skin_file_and_alias(self):
        r = self.scanner.scan_directories(['Characters/Renekton/Skins/Skin01'])
        self.assertTrue(r['original_file_scan_executed'])
        self.assertEqual(r['entries']['Skin01.ini'], 'Characters/Renekton/Skins/Skin01/Skin01.ini')
        self.assertIn('Skin01.inibin', r['entries'])
        self.assertTrue(self.scanner.filename_registered('Renekton', 1)['dedicated'])

    def test_02_absent_directory_is_empty_not_invented_content(self):
        r = self.scanner.scan_directories(['Characters/NoSuchReferenceCharacter/Skins/Base'])
        self.assertEqual(r['entries'], {})
        self.assertFalse(r['enumerations'][0]['exists'])
        self.assertEqual(self.scanner.resolve_registered('Base.ini')['path'], '')

    def test_03_original_file_scan_filters_directories_without_recursion(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root = pathlib.Path(td); (root/'Fixture/Sub').mkdir(parents=True)
            (root/'Fixture/A.inibin').write_bytes(b'fixture')
            (root/'Fixture/Sub/hidden.inibin').write_bytes(b'fixture')
            x = OriginalDirectoryScanner(self.binary, root)
            r = x.scan_directories(['Fixture'])
            self.assertEqual(set(r['entries']), {'A.ini', 'A.inibin'})
            self.assertTrue(any(e['is_directory'] for e in r['enumerations'][0]['entries']))

    def test_04_original_directory_scan_filters_files(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root = pathlib.Path(td); (root/'Fixture/Skin01Folder').mkdir(parents=True)
            (root/'Fixture/Skin01File.inibin').write_bytes(b'fixture')
            x = OriginalDirectoryScanner(self.binary, root)
            r = x.scan_directories(['Fixture'], 'directories', 'Skin01*')
            self.assertTrue(r['original_directory_scan_executed'])
            self.assertEqual(r['entries'], {'Skin01Folder': 'Fixture/Skin01Folder'})

    def test_05_original_registration_retains_compiled_and_logical_names(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root = pathlib.Path(td); (root/'Fixture').mkdir()
            for name in ['Example.inibin', 'Example.luaobj']:
                (root/'Fixture'/name).write_bytes(b'fixture')
            x = OriginalDirectoryScanner(self.binary, root)
            entries = x.scan_directories(['Fixture'])['entries']
            self.assertEqual(set(entries), {'Example.ini', 'Example.inibin', 'Example.lua', 'Example.luaobj'})

    def test_06_original_non_base_builder_selects_actual_folder_and_subdirectories(self):
        r = self.scanner.discover_skin('Renekton', 1)
        self.assertTrue(r['original_skin_package_scan_executed'])
        self.assertTrue(r['original_directory_scan_executed'])
        self.assertTrue(r['original_file_scan_executed'])
        self.assertFalse(r['original_host_iterator_factory_executed'])
        self.assertEqual([e['query'] for e in r['enumerations']], [
            'Characters/Renekton/Skins/Skin01*',
            'Characters/Renekton/Skins/Skin01/*',
            'Characters/Renekton/Skins/Skin01/Animations/*',
            'Characters/Renekton/Skins/Skin01/Particles/*',
            'Characters/Renekton/Skins/Skin01/Sounds/*',
            'Characters/Renekton/Sounds/Skin01/Sounds/*'])

    def test_07_original_builder_selects_first_native_tree_key(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root = pathlib.Path(td)
            # Deliberately create the lexically later candidate first.
            for name in ['Skin01Z', 'Skin01A']:
                folder = root/'Characters/Fixture/Skins'/name; folder.mkdir(parents=True)
                (folder/'Skin01.inibin').write_bytes(b'fixture')
            x = OriginalDirectoryScanner(self.binary, root)
            r = x.discover_skin('Fixture', 1)
            self.assertEqual(r['entries']['Skin01.ini'], 'Characters/Fixture/Skins/Skin01A/Skin01.ini')
            self.assertFalse(any('/Skin01Z/' in e['query'] for e in r['enumerations']))

    def test_08_bad_paths_and_wildcards_refused(self):
        for value in ['../outside', '/absolute', 'C:/Windows', 'Characters/../outside', 'Characters\\Renekton', 'Characters//Renekton']:
            with self.subTest(value=value), self.assertRaises(ValueError):
                self.scanner.scan_directories([value])
        for pattern in ['*.*', '../*', 'Skin*', 'Skin01?', '']:
            with self.subTest(pattern=pattern), self.assertRaises(ValueError):
                self.scanner.scan_directories(['Characters'], pattern=pattern)

    def test_09_base_and_invalid_skin_numbers_not_qualified_by_non_base_builder(self):
        for value in [0, -1, 100, True, '1']:
            with self.subTest(value=value), self.assertRaises(ValueError):
                self.scanner.discover_skin('Renekton', value)

    def test_10_reset_invalidates_scan_qualification(self):
        self.scanner.discover_skin('Renekton', 1)
        self.scanner.reset()
        self.assertFalse(self.scanner.scan_ready)
        with self.assertRaises(ValueError):
            self.scanner.filename_registered('Renekton', 1)

    def test_11_directory_bound_refuses_unqualified_large_iterator(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root = pathlib.Path(td); (root/'Fixture').mkdir()
            for number in range(513):
                (root/'Fixture'/f'{number}.txt').write_bytes(b'fixture')
            x = OriginalDirectoryScanner(self.binary, root)
            with self.assertRaisesRegex(ValueError, 'Bounded directory'):
                x.scan_directories(['Fixture'])

    def test_12_bootstrap_cache_and_game_remain_unqualified(self):
        d = self.scanner.evidence()
        self.assertFalse(d['original_package_map_construction_executed'])
        self.assertFalse(d['original_compiled_config_cache_executed'])
        self.assertFalse(d['historical_game_process_launched'])

    def test_13_large_original_directory_tree_and_arenas(self):
        result = self.scanner.discover_skin('Aatrox', 1)
        self.assertGreater(result['native_map_count'], 200)
        self.assertEqual(result['entries']['Skin01.ini'], 'Characters/Aatrox/Skins/Skin01/Skin01.ini')
        self.assertEqual(len(result['tree_invariants_verified']), 4)

    def test_14_original_ascii_suffix_fold_handles_uppercase_compiled_extensions(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root = pathlib.Path(td); (root/'Fixture').mkdir()
            for name in ['Mixed.INIBIN', 'Other.LUAOBJ']:
                (root/'Fixture'/name).write_bytes(b'fixture')
            x = OriginalDirectoryScanner(self.binary, root)
            entries = x.scan_directories(['Fixture'])['entries']
            self.assertEqual(set(entries), {'Mixed.INI', 'Mixed.INIBIN', 'Other.LUA', 'Other.LUAOBJ'})

    def test_15_original_ascii_ctype_all_inputs_and_locale_guard(self):
        x = self.scanner; x.begin()
        try:
            for value in range(128):
                actual = x.invoke(0xc98074, [value])
                self.assertEqual(actual, value-32 if 97 <= value <= 122 else value)
            x.w(0x14ae870, 1)
            with self.assertRaisesRegex(ValueError, 'locale-dependent'):
                x.invoke(0xc98074, [ord('a')])
        finally:
            x.w(0x14ae870, 0)
            x.scan_mode = False; x.native_registration_mode = False


if __name__ == '__main__':
    unittest.main()
