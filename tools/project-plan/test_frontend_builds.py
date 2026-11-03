import copy,json,pathlib,sys,tempfile,unittest,zlib,struct
from frontend_builds import BuildError,air_version,installed_release,pe_versions,verify,safe_source
ROOT=pathlib.Path('E:/OpenLeague')
STAGE=pathlib.Path('E:/mapslol3v3/Build_identity_4_20_2026-10-20')
class FrontendBuildTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.doc=json.loads((ROOT/'docs/reference_frontend_builds_4_20.json').read_bytes())
        cls.air=pathlib.Path(cls.doc['source_roots']['air'])/'lib/ClientLibCommon.dat'
    def test_01_nominal_ten_sources_and_reference(self):
        r=verify(self.doc,ROOT)
        self.assertTrue(r['facts_verified']);self.assertEqual(r['verified_sources'],10)
        self.assertFalse(r['native_executed']);self.assertFalse(r['manual_state_mutated'])
        self.assertEqual(r['human_acceptance'],'not_given')
    def test_02_patcher_real_versioninfo(self):
        path=pathlib.Path(self.doc['source_roots']['native'])/self.doc['sources'][0]['path']
        self.assertEqual(pe_versions(path),{'file_version':'0.4.0.122','product_version':'0.4.0.122'})
    def test_03_real_air_abc_field(self):
        r=air_version(self.air)
        self.assertEqual(r['build'],'4.20.14_11_18_18_52');self.assertEqual(r['field'],'CURRENT_VERSION')
        self.assertEqual(r['class'],'com.riotgames.platform.gameclient.application.Version')
    def test_04_reject_different_build(self):
        d=copy.deepcopy(self.doc);d['air']['build']='4.19.14_11_04_18_00'
        with self.assertRaisesRegex(BuildError,'Build AIR divergent'):verify(d,ROOT)
    def test_05_no_confusion_between_rads_and_pe(self):
        d=copy.deepcopy(self.doc);d['patcher']['file_version']='0.0.0.11'
        with self.assertRaisesRegex(BuildError,'patcher divergente'):verify(d,ROOT)
    def test_06_changed_source_refused(self):
        d=copy.deepcopy(self.doc);d['sources'][4]['sha256']='0'*64
        with self.assertRaisesRegex(BuildError,'Source modifiée'):verify(d,ROOT)
    def test_07_missing_source_refused(self):
        d=copy.deepcopy(self.doc);d['sources'][4]['path']='missing.dat'
        with self.assertRaisesRegex(BuildError,'Source absente'):verify(d,ROOT)
    def test_08_project_scoped_log_not_global_maximum(self):
        s=('EnumerateInstalledProjectReleases: (lol_air_client_config_euw)\n'
           'EnumerateInstalledProjectReleases: Found candidate "0.0.0.50" (0x00000032).\n'
           'EnumerateInstalledProjectReleases: Found OK-file, candidate is valid\n'
           'EnumerateInstalledProjectReleases: Succeeded.\n')
        with self.assertRaises(BuildError):installed_release(s,'lol_air_client')
        self.assertEqual(installed_release(s,'lol_air_client_config_euw'),'0.0.0.50')
    def log(self,version='0.0.1.119',hexnum='00000177',ok=True):
        return ('EnumerateInstalledProjectReleases: (lol_air_client)\n'
                f'EnumerateInstalledProjectReleases: Found candidate "{version}" (0x{hexnum}).\n'+
                ('EnumerateInstalledProjectReleases: Found OK-file, candidate is valid\n' if ok else '')+
                'EnumerateInstalledProjectReleases: Succeeded.\n')
    def test_09_candidate_without_ok_not_install(self):
        with self.assertRaises(BuildError):installed_release(self.log(ok=False),'lol_air_client')
    def test_10_decimal_hex_divergence(self):
        with self.assertRaises(BuildError):installed_release(self.log(hexnum='00000178'),'lol_air_client')
    def test_11_ambiguous_valid_installs_refused(self):
        with self.assertRaises(BuildError):installed_release(self.log()+self.log('0.0.1.120','00000178'),'lol_air_client')
    def test_12_reject_string_with_wrong_field_binding(self):
        b=self.air.read_bytes();data=zlib.decompress(b[8:]);data=data.replace(b'CURRENT_VERSION',b'WRONGXX_VERSION')
        with tempfile.TemporaryDirectory(dir=STAGE) as td:
            p=pathlib.Path(td)/'wrong.dat';p.write_bytes(b[:8]+zlib.compress(data))
            with self.assertRaises(BuildError):air_version(p)
    def test_13_refuse_corrupt_swf(self):
        with tempfile.TemporaryDirectory(dir=STAGE) as td:
            p=pathlib.Path(td)/'broken.dat';p.write_bytes(self.air.read_bytes()[:75])
            with self.assertRaises(BuildError):air_version(p)
    def test_14_source_path_traversal_refused(self):
        for value in ['../outside','/absolute','C:/Windows/test','..\\outside']:
            with self.subTest(value=value),self.assertRaises(BuildError):safe_source(ROOT,value)
    def test_15_do_not_invent_timezone_or_loader_version(self):
        for k,v in [('build_timezone','UTC'),('pe_loader_version','4.20')]:
            d=copy.deepcopy(self.doc);d['air'][k]=v
            with self.assertRaisesRegex(BuildError,'non établi'):verify(d,ROOT)
    def test_16_stale_xml_descriptor_not_used_as_build(self):
        self.assertEqual(self.doc['air']['descriptor_version'],'1.0.0')
        self.assertNotEqual(self.doc['air']['descriptor_version'],self.doc['air']['build'])
        self.assertIsNone(self.doc['air']['build_timezone'])
        d=copy.deepcopy(self.doc);d['air']['descriptor_source_release']='0.0.1.119'
        with self.assertRaisesRegex(BuildError,'Héritage'):verify(d,ROOT)
    def test_17_plan_instruction_real_consumer(self):
        from instructions import make_instruction
        tasks=json.loads((ROOT/'docs/completion_tasks_2026-10-20.json').read_bytes())['tasks']
        t=next(t for t in tasks if t['id']=='SYS-01.1-02')
        h=json.loads((ROOT/'docs/execution_plan_A_Z.json').read_bytes())
        p=next(p for p in h['packages'] if t['id'] in p['task_ids']);phase=next(x for x in h['phases'] if x['id']==p['phase'])
        text=make_instruction(t,phase,p,{t['id']:t},ROOT,STAGE)
        for v in ['0.4.0.122','0.0.0.11','4.20.14_11_18_18_52','0.0.1.119','reference_frontend_builds_4_20.json','CURRENT_VERSION']:
            self.assertIn(v,text)
        self.assertFalse(t['acceptance_complete']);self.assertEqual(t['human_acceptance'],'not_given')
if __name__=='__main__':unittest.main(verbosity=2)
