import json
import pathlib
import shutil
import struct
import tempfile
import unittest

from original_config_cache_reference import OriginalConfigCache

R=pathlib.Path('E:/OpenLeague')
TEMP=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision9')


class OriginalConfigCacheTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        ref=json.loads((R/'docs/reference_client_4_20.json').read_bytes())
        cls.binary=pathlib.Path(ref['source_root'])/ref['client']['binary']
        cls.deploy=cls.binary.parent
        cls.base=cls.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin'
        cls.legacy=cls.deploy/'DATA/Characters/Renekton/Renekton.inibin'
        cls.native=OriginalConfigCache(cls.binary,[cls.deploy])

    def fixture(self, root, logical, source):
        path=root/logical
        path.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(source,path)
        return path

    def query(self, x, path='DATA/Fixture/Example.ini', section='MeshSkin', field='SkinScale', default=-1., force=False):
        return x.cached_scalar(path,section,field,default,force)

    def test_01_real_reference_full_cache_constructor_and_scalar(self):
        x=self.native;x.start()
        r=self.query(x,'DATA/Characters/Renekton/Skins/Base/Base.ini')
        self.assertEqual(r['float32_hex'],struct.pack('<f',1.559999942779541).hex())
        self.assertEqual(len(r['new_opened_streams']),1)
        self.assertIsNone(r['pair']['override'])
        self.assertEqual(x.constructed[0]['arguments'][1],'data/characters/renekton/skins/base/defaults/base.ini')
        self.assertTrue(x.evidence()['original_full_config_constructor_executed'])
        self.assertTrue(x.evidence()['original_compiled_config_cache_executed'])

    def test_02_same_request_hits_original_cache_without_reopening(self):
        x=self.native;x.start();path='DATA/Characters/Renekton/Skins/Base/Base.ini'
        a=self.query(x,path);b=self.query(x,path)
        self.assertEqual(a['pair']['pair'],b['pair']['pair'])
        self.assertEqual(b['new_opened_streams'],[])
        self.assertEqual(a['float32_hex'],b['float32_hex'])

    def test_03_missing_field_uses_original_caller_default(self):
        x=self.native;x.start()
        r=self.query(x,'DATA/Characters/Renekton/Skins/Base/Base.ini','MeshSkin','NoSuchField',7.25)
        self.assertEqual(r['value'],7.25)
        self.assertEqual([e['found'] for e in r['original_scalar_events']],[False])

    def test_04_missing_requested_compiled_file_uses_actual_defaults_payload(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);self.fixture(root,'DATA/Fixture/defaults/Example.inibin',self.legacy)
            x=OriginalConfigCache(self.binary,[root]);x.start();r=self.query(x)
            self.assertEqual(r['float32_hex'],struct.pack('<f',1.6).hex())
            self.assertEqual(r['pair']['primary']['flags_148_149_14a'][2:4],'01')
            self.assertIn('/defaults/',r['new_opened_streams'][0]['logical'])

    def test_05_present_main_does_not_merge_missing_compiled_fields_from_defaults(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);self.fixture(root,'DATA/Fixture/Example.inibin',self.base)
            self.fixture(root,'DATA/Fixture/defaults/Example.inibin',self.legacy)
            x=OriginalConfigCache(self.binary,[root]);x.start();a=self.query(x);b=self.query(x,section='MeshSkin1',default=7.25)
            self.assertEqual(a['float32_hex'],struct.pack('<f',1.559999942779541).hex())
            self.assertEqual(b['value'],7.25)
            self.assertEqual([e['found'] for e in b['original_scalar_events']],[False])

    def test_06_original_locale_override_then_per_field_primary_fallback(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);self.fixture(root,'DATA/Fixture/Example.inibin',self.legacy)
            self.fixture(root,'DATA/Fixture/Example_en_GB.inibin',self.base)
            x=OriginalConfigCache(self.binary,[root]);x.start('en_GB');a=self.query(x);b=self.query(x,section='MeshSkin1')
            self.assertIsNotNone(a['pair']['override'])
            self.assertEqual(a['float32_hex'],struct.pack('<f',1.559999942779541).hex())
            self.assertEqual(b['float32_hex'],struct.pack('<f',1.6).hex())
            self.assertEqual([e['found'] for e in b['original_scalar_events']],[False,True])

    def test_07_absent_locale_variant_keeps_primary_without_invented_override(self):
        x=self.native;x.start('en_GB');r=self.query(x,'DATA/Characters/Renekton/Skins/Base/Base.ini')
        self.assertIsNone(r['pair']['override'])
        self.assertEqual(r['float32_hex'],struct.pack('<f',1.559999942779541).hex())

    def test_08_exact_Spells_path_suppresses_secondary_locale_object(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);self.fixture(root,'DATA/Fixture/Spells/Example.inibin',self.legacy)
            self.fixture(root,'DATA/Fixture/Spells/Example_en_GB.inibin',self.base)
            x=OriginalConfigCache(self.binary,[root]);x.start('en_GB');r=self.query(x,'DATA/Fixture/Spells/Example.ini')
            self.assertIsNone(r['pair']['override'])
            self.assertEqual(r['float32_hex'],struct.pack('<f',1.6).hex())

    def test_09_force_reload_uses_original_destruction_reload_and_publication(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);path=self.fixture(root,'DATA/Fixture/Example.inibin',self.base)
            x=OriginalConfigCache(self.binary,[root]);x.start();a=self.query(x)
            path.write_bytes(self.legacy.read_bytes())
            b=self.query(x);c=self.query(x,force=True)
            self.assertEqual(b['float32_hex'],a['float32_hex']);self.assertEqual(b['new_opened_streams'],[])
            self.assertEqual(c['float32_hex'],struct.pack('<f',1.6).hex())
            self.assertNotEqual(c['pair']['pair'],a['pair']['pair'])

    def test_10_native_last_path_fast_lookup_is_case_insensitive(self):
        x=self.native;x.start();a=self.query(x,'DATA/Characters/Renekton/Skins/Base/Base.ini')
        b=self.query(x,'data/characters/renekton/skins/base/base.ini')
        self.assertEqual(a['pair']['pair'],b['pair']['pair']);self.assertEqual(b['new_opened_streams'],[])

    def test_11_original_file_provider_order_selects_first_readable_payload(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);a=root/'first';b=root/'second';a.mkdir();b.mkdir()
            self.fixture(a,'DATA/Fixture/Example.inibin',self.base);self.fixture(b,'DATA/Fixture/Example.inibin',self.legacy)
            x=OriginalConfigCache(self.binary,[a,b]);x.start();first=self.query(x)
            y=OriginalConfigCache(self.binary,[b,a]);y.start();second=self.query(y)
            self.assertEqual(first['float32_hex'],struct.pack('<f',1.559999942779541).hex())
            self.assertEqual(second['float32_hex'],struct.pack('<f',1.6).hex())

    def test_12_truncated_compiled_source_refused_and_context_quarantined(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);p=self.fixture(root,'DATA/Fixture/Example.inibin',self.base);p.write_bytes(p.read_bytes()[:-1])
            x=OriginalConfigCache(self.binary,[root]);x.start()
            with self.assertRaisesRegex(ValueError,'Truncated cache source'):
                self.query(x)
            self.assertFalse(x.cache_ready)

    def test_13_invalid_paths_and_locale_refused_before_native_file_access(self):
        x=self.native;x.start()
        for path in ['../outside.ini','C:/Windows/test.ini','/absolute.ini','DATA/../outside.ini','\\\\host\\share\\file.ini']:
            with self.subTest(path=path),self.assertRaises(ValueError):self.query(x,path)
        for locale in ['EUW','en_gb','../en_GB']:
            with self.subTest(locale=locale),self.assertRaises(ValueError):x.start(locale)
        self.assertEqual(x.opened,[])

    def test_14_original_directory_mutation_branch_is_refused_without_host_changes(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);p=root/'DATA/Fixture/Example.ini';p.mkdir(parents=True)
            x=OriginalConfigCache(self.binary,[root]);x.start()
            with self.assertRaisesRegex(ValueError,'Host directory mutation refused'):
                self.query(x)
            self.assertTrue(p.is_dir());self.assertEqual(list(p.iterdir()),[])

    def test_15_existing_raw_text_ini_remains_explicitly_unqualified(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);p=root/'DATA/Fixture/Example.ini';p.parent.mkdir(parents=True);p.write_text('[MeshSkin]\nSkinScale=2\n')
            x=OriginalConfigCache(self.binary,[root]);x.start()
            with self.assertRaisesRegex(ValueError,'raw INI stat|Raw text'):
                self.query(x)
            self.assertEqual(p.read_text(),'[MeshSkin]\nSkinScale=2\n')

    def test_16_missing_both_payloads_preserves_explicit_scalar_default(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            x=OriginalConfigCache(self.binary,[pathlib.Path(td)]);x.start();r=self.query(x,default=7.25)
            self.assertEqual(r['value'],7.25);self.assertEqual(r['new_opened_streams'],[])
            self.assertEqual(r['pair']['primary']['flags_148_149_14a'],'000000')

    def test_17_unprepared_context_and_nonfinite_defaults_refused(self):
        x=self.native;x.reset()
        with self.assertRaises(ValueError):self.query(x)
        x.start()
        for value in [float('nan'),float('inf'),True]:
            with self.subTest(value=value),self.assertRaises(ValueError):self.query(x,default=value)

    def test_18_repeated_fresh_contexts_do_not_reuse_process_owned_global_storage(self):
        x=self.native;path='DATA/Characters/Renekton/Skins/Base/Base.ini'
        for _ in range(4):
            x.start();self.query(x,path);self.query(x,path)
            r=self.query(x,path,field='NoSuchField',default=7.25)
            self.assertEqual(r['value'],7.25)
            self.assertTrue(x.writable_reset_ranges)

    def test_19_original_file_open_rejects_write_flags_before_any_host_write(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);p=self.fixture(root,'DATA/Fixture/Example.inibin',self.base);before=p.read_bytes()
            x=OriginalConfigCache(self.binary,[root]);x.start()
            x.u.mem_write(x.work+0x3000,b'DATA/Fixture/Example.inibin\0')
            x.u.mem_write(x.work+0x3300,b'wb\0')
            with self.assertRaisesRegex(ValueError,'Non-read-only backend access refused'):
                x.invoke(0x8b4ef0,[x.work+0x3000,x.work+0x3300])
            self.assertEqual(p.read_bytes(),before)


if __name__=='__main__':unittest.main()
