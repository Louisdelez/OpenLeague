import contextlib
import json
import pathlib
import shutil
import tempfile
import unittest

from original_text_config_reference import OriginalTextConfig

R=pathlib.Path('E:/OpenLeague')
TEMP=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision10')


class OriginalTextConfigTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ref=json.loads((R/'docs/reference_client_4_20.json').read_bytes())
        cls.binary=pathlib.Path(cls.ref['source_root'])/cls.ref['client']['binary']
        cls.deploy=cls.binary.parent
        cls.native=OriginalTextConfig(cls.binary,[cls.deploy],cls.ref['source_root'])
        cls.locale=cls.deploy/'DATA/CFG/defaults/Locale.cfg'

    @contextlib.contextmanager
    def fixture(self, files):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td).resolve()
            assert root.is_relative_to(TEMP.resolve())
            for rel,content in files.items():
                p=root/rel;p.parent.mkdir(parents=True,exist_ok=True)
                if isinstance(content,pathlib.Path):shutil.copyfile(content,p)
                else:p.write_bytes(content)
            x=OriginalTextConfig(self.binary,[root],TEMP);x.start()
            yield root,x

    def test_01_reference_caller_reads_default_locale_and_sets_en_GB(self):
        x=self.native;x.start();r=x.initialize_locale()
        self.assertEqual((r['locale'],r['application_string']),('en_GB','en_GB'))
        self.assertTrue(r['enabled']);self.assertIsNone(r['selected_user_config'])
        self.assertIn(0x82d1a0,x.case_visited);self.assertIn(0x8b2e70,x.case_visited)
        self.assertNotIn(0x8b15d0,x.case_visited)
        self.assertEqual([v['bytes'] for v in x.opened],[37])
        self.assertFalse(r['historical_effective_locale_qualified'])

    def test_02_native_last_line_without_newline_is_preserved(self):
        self.assertFalse(self.locale.read_bytes().endswith(b'\n'))
        x=self.native;x.start()
        r=x.cached_string('DATA/CFG/Locale.cfg','General','LanguageLocaleRegion')
        self.assertEqual(r['value'],'en_GB')
        self.assertEqual(x.read_streams[-1]['position'],37)
        self.assertTrue(x.read_streams[-1]['closed'])
        self.assertIn(0x8aec00,x.case_visited);self.assertIn(0x8b5030,x.case_visited)

    def test_03_missing_field_uses_the_native_callers_default(self):
        x=self.native;x.start()
        r=x.cached_string('DATA/CFG/Locale.cfg','General','NoSuchField','unknown')
        self.assertEqual(r['value'],'unknown')

    def test_04_native_bounded_output_has_an_explicit_terminator(self):
        x=self.native;x.start()
        r=x.cached_string('DATA/CFG/Locale.cfg','General','LanguageLocaleRegion',capacity=3)
        self.assertEqual(r['value'],'en_')
        self.assertEqual(bytes(x.u.mem_read(x.work+0x3a03,2)),b'\0\xcc')

    def test_05_explicit_main_locale_overrides_default(self):
        with self.fixture({'DATA/CFG/defaults/Locale.cfg':self.locale,
                           'DATA/CFG/Locale.cfg':b'[General]\r\nLanguageLocaleRegion=fr_FR'}) as (_,x):
            r=x.initialize_locale();self.assertEqual(r['locale'],'fr_FR')
            self.assertNotIn(0x8b15d0,x.case_visited)
            self.assertEqual({v['bytes'] for v in x.opened},{37})

    def test_06_native_setter_is_one_shot(self):
        x=self.native;x.start()
        a=x.set_locale('en_GB');b=x.set_locale('fr_FR')
        self.assertEqual(a['after'],b['after']);self.assertEqual(b['after'],'en_GB')

    def test_07_invalid_locale_refused_before_native_diagnostics(self):
        for value in [None,'','en','en_GB_extra','fr_\0R','éé_FR',True]:
            with self.subTest(value=value):
                x=self.native;x.start()
                with self.assertRaises(ValueError):x.set_locale(value)
                self.assertNotIn(0x8b2e70,x.case_visited)

    def test_08_global_fallback_native_directory_and_copied_sources(self):
        with self.fixture({'DATA/CFG/defaults/Game.cfg':self.deploy/'DATA/CFG/defaults/Game.cfg',
                           'DATA/CFG/Game.cfg':self.deploy/'DATA/CFG/Game.cfg',
                           'Config/Game.cfg':pathlib.Path(self.ref['source_root'])/'Config/Game.cfg'}) as (root,x):
            r=x.initialize_locale();self.assertEqual(r['locale'],'en_US')
            self.assertEqual(pathlib.Path(r['selected_user_config']).resolve(),(root/'Config/Game.cfg').resolve())
            for entry in [0x8b15d0,0x8b3970,0x8b3140]:self.assertIn(entry,x.case_visited)
            self.assertTrue(any(v.get('adapter')=='readonly_already_existing_directory' for v in x.upstream_events))
            self.assertTrue(any(v['bytes']==14789 for v in x.opened))

    def test_09_global_user_config_has_priority_over_defaults(self):
        with self.fixture({'DATA/CFG/defaults/Game.cfg':b'[General]\nLanguageLocaleRegion=en_US\n',
                           'DATA/CFG/Game.cfg':b'[General]\nLanguageLocaleRegion=en_US\n',
                           'Config/Game.cfg':b'[General]\nLanguageLocaleRegion=fr_FR\n'}) as (_,x):
            self.assertEqual(x.initialize_locale()['locale'],'fr_FR')

    def test_10_missing_settings_use_native_en_US_literal(self):
        with self.fixture({'Config/Game.cfg':b'[General]\nOther=1\n'}) as (_,x):
            self.assertEqual(x.initialize_locale()['locale'],'en_US')

    def test_11_creation_refused_without_host_mutation(self):
        with self.fixture({}) as (root,x):
            with self.assertRaisesRegex(ValueError,'directory creation refused'):x.initialize_locale()
            self.assertFalse((root/'Config').exists())

    def test_12_native_file_migration_refused_without_host_mutation(self):
        with self.fixture({'Config/keep.txt':b'unchanged',
                           'DATA/CFG/Game.cfg':b'[General]\nLanguageLocaleRegion=en_US\n'}) as (root,x):
            with self.assertRaisesRegex(ValueError,'file move refused'):x.initialize_locale()
            self.assertFalse((root/'Config/Game.cfg').exists())
            self.assertEqual((root/'Config/keep.txt').read_bytes(),b'unchanged')
            self.assertTrue((root/'DATA/CFG/Game.cfg').is_file())

    def test_13_unqualified_raw_payloads_refused(self):
        for content in [b'[General]\nA=a\0b',b'[General]\nA=\xff',b'a'*0x10000]:
            with self.subTest(size=len(content)):
                with self.fixture({'DATA/CFG/Locale.cfg':content}) as (_,x):
                    with self.assertRaisesRegex(ValueError,'encoding/size/NUL'):
                        x.initialize_locale()

    def test_14_traversal_and_observation_escape_refused(self):
        x=self.native;x.start()
        for path in ['../Game.cfg','D:/Game.cfg','/DATA/CFG/Locale.cfg','DATA/../Game.cfg']:
            with self.subTest(path=path):
                with self.assertRaises(ValueError):x.cached_string(path,'General','LanguageLocaleRegion')
        with self.assertRaisesRegex(ValueError,'escaped declared root'):x.observed_path('C:/Windows/win.ini')

    def test_15_backend_write_access_still_refused(self):
        x=self.native;x.start()
        marker=next(k for k,v in x.markers.items() if v=='access')
        x.u.mem_write(x.work+0x3000,b'DATA/CFG/Locale.cfg\0')
        with self.assertRaisesRegex(ValueError,'Non-read-only backend access'):
            x.invoke(marker,[x.work+0x3000,2],next(iter(x.backend_objects)))

    def test_16_raw_text_cache_hits_and_forced_reload(self):
        with self.fixture({'DATA/CFG/Locale.cfg':self.locale}) as (root,x):
            a=x.cached_string('DATA/CFG/Locale.cfg','General','LanguageLocaleRegion')
            (root/'DATA/CFG/Locale.cfg').write_bytes(b'[General]\nLanguageLocaleRegion=fr_FR\n')
            b=x.cached_string('DATA/CFG/Locale.cfg','General','LanguageLocaleRegion')
            c=x.cached_string('DATA/CFG/Locale.cfg','General','LanguageLocaleRegion',force=True)
            self.assertEqual((a['value'],b['value'],c['value']),('en_GB','en_GB','fr_FR'))
            self.assertEqual(b['new_opened_streams'],[])
            self.assertNotEqual(a['pair']['pair'],c['pair']['pair'])

    def test_17_repeated_cold_contexts_have_no_locale_or_string_leak(self):
        x=self.native
        for i in range(4):
            x.start();self.assertEqual(x.initialize_locale()['locale'],'en_GB')
            self.assertEqual(x.set_locale('fr_FR')['after'],'en_GB')

    def test_18_original_compiled_scalar_composes_after_native_locale_init(self):
        x=self.native;x.start();x.initialize_locale()
        r=x.cached_scalar('DATA/Characters/Renekton/Skins/Base/Base.ini','MeshSkin','SkinScale',-1.)
        self.assertEqual(r['float32_hex'],'14aec73f')
        self.assertEqual(int(x.identity_field('MeshSkin')['value']),58000)

    def test_19_invalid_query_contract_refused(self):
        x=self.native;x.start()
        for kw in [{'capacity':0},{'capacity':True},{'force':1},{'default':'a\0b'}]:
            with self.subTest(kw=kw):
                with self.assertRaises(ValueError):x.cached_string('DATA/CFG/Locale.cfg','General','LanguageLocaleRegion',**kw)

    def test_20_mutating_windows_imports_refused_before_dispatch(self):
        for marker,kind in self.native.directory_markers.items():
            if kind == 'create_directory':continue
            self.native.start()
            with self.subTest(kind=kind):
                with self.assertRaisesRegex(ValueError,'refused before execution'):
                    self.native.invoke(marker)


if __name__=='__main__':unittest.main()
