"""Release membership checks on original 4.20 bytes, never executing AIR."""
import copy,json,pathlib,tempfile,unittest
from frontend_builds import (BuildError,release_manifest,manifest_member,
                             excluded_union_candidate,verify)

ROOT=pathlib.Path('E:/OpenLeague')
TEMP=pathlib.Path('E:/mapslol3v3/Build_identity_revalidation_4_20_2026-10-20')

class ManifestBuildTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.doc=json.loads((ROOT/'docs/reference_frontend_builds_4_20.json').read_bytes())
        cls.files={x['id']:pathlib.Path(cls.doc['source_roots'][x['root']])/x['path'] for x in cls.doc['sources']}
        cls.manifest=release_manifest(cls.files['air_manifest'],'lol_air_client','0.0.1.119')

    def test_01_exact_manifest_membership_for_both_build_sources(self):
        r=verify(self.doc,ROOT)['manifest_verification']
        self.assertEqual(r['patcher']['member']['md5'],'ace2737187b05155ed3aa317d5c307f1')
        self.assertEqual(r['air']['member']['md5'],'18e2488befd98ec98ab3a2fa459e2178')
        self.assertEqual(r['air']['manifest_files'],7886)

    def test_02_wrong_manifest_project_refused(self):
        with self.assertRaisesRegex(BuildError,'Projet du manifeste'):
            release_manifest(self.files['air_manifest'],'lol_patcher','0.0.1.119')

    def test_03_wrong_manifest_release_refused(self):
        with self.assertRaisesRegex(BuildError,'Release du manifeste'):
            release_manifest(self.files['air_manifest'],'lol_air_client','0.0.1.120')

    def test_04_missing_manifest_member_refused(self):
        with self.assertRaisesRegex(BuildError,'absente du manifeste'):
            manifest_member(self.manifest,'version.txt',self.files['stale_version'],'0.0.1.119')

    def test_05_wrong_manifest_member_release_refused(self):
        with self.assertRaisesRegex(BuildError,'Release de la ressource'):
            manifest_member(self.manifest,'lib/ClientLibCommon.dat',self.files['air_common'],'0.0.1.118')

    def test_06_changed_library_refused_by_manifest(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            p=pathlib.Path(td)/'common.dat';b=bytearray(self.files['air_common'].read_bytes());b[-1]^=1;p.write_bytes(b)
            with self.assertRaisesRegex(BuildError,'Contenu de la ressource'):
                manifest_member(self.manifest,'lib/ClientLibCommon.dat',p,'0.0.1.119')

    def test_07_truncated_manifest_refused(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            p=pathlib.Path(td)/'manifest';p.write_bytes(self.files['air_manifest'].read_bytes()[:100])
            with self.assertRaisesRegex(BuildError,'Manifeste RADS invalide'):
                release_manifest(p,'lol_air_client','0.0.1.119')

    def test_08_union_descriptor_explicitly_excluded(self):
        r=excluded_union_candidate(self.manifest,'META-INF/AIR/application.xml',self.files['air_descriptor'],
                                  'different_content_from_release_manifest')
        self.assertEqual(r['manifest_entry']['release'],'0.0.1.67')
        self.assertNotEqual(r['candidate_md5'],r['manifest_entry']['md5'])
        with self.assertRaisesRegex(BuildError,'Contenu de la ressource'):
            manifest_member(self.manifest,'META-INF/AIR/application.xml',self.files['air_descriptor'],'0.0.1.67')

    def test_09_stale_version_is_absent_not_inherited_release119_member(self):
        r=excluded_union_candidate(self.manifest,'version.txt',self.files['stale_version'],'absent_from_release_manifest')
        self.assertIsNone(r['manifest_entry'])

    def test_10_cannot_promote_union_candidate_to_release119(self):
        d=copy.deepcopy(self.doc);d['archive_candidate_classification']['air_descriptor']='matches_release_manifest'
        with self.assertRaisesRegex(BuildError,'Ressources anciennes non exclues'):verify(d,ROOT)

    def test_11_missing_manifest_contract_source_refused(self):
        d=copy.deepcopy(self.doc);d['sources']=[x for x in d['sources'] if x['id']!='air_manifest']
        with self.assertRaisesRegex(BuildError,'Ensemble des sources'):verify(d,ROOT)

    def test_12_false_field_binding_metadata_refused(self):
        d=copy.deepcopy(self.doc);d['air']['field']='versionNumber'
        with self.assertRaisesRegex(BuildError,'Liaison du champ'):verify(d,ROOT)

    def test_13_cannot_invent_exact_descriptor_values(self):
        for key,value in [('source_release','0.0.1.76'),('version_number','1.0.0'),('namespace','http://ns.adobe.com/air/application/3.7')]:
            with self.subTest(key=key):
                d=copy.deepcopy(self.doc);d['air']['descriptor_expected_by_release119'][key]=value
                with self.assertRaisesRegex(BuildError,'Descripteur 4.20 non récupéré'):verify(d,ROOT)

    def test_14_changed_manifest_provenance_refused(self):
        d=copy.deepcopy(self.doc);d['archive']['release_manifest']['provenance_sha256']='0'*64
        with self.assertRaisesRegex(BuildError,'Reçu du manifeste AIR modifié'):verify(d,ROOT)

if __name__=='__main__':unittest.main(verbosity=2)
