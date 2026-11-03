import copy,json,pathlib,shutil,sys,tempfile,unittest
from air_reference import verify,AirReferenceError
ROOT=pathlib.Path('E:/OpenLeague');TEMP=pathlib.Path('E:/mapslol3v3/AIR_routes_4_20_2026-10-20')
class AirReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.doc=json.loads((ROOT/'docs/reference_air_routes_4_20.json').read_bytes())
    def reject(self,doc,message):
        with self.assertRaisesRegex(AirReferenceError,message):verify(doc,ROOT,False)
    def test_01_full_original_inventory_nominal(self):
        r=verify(self.doc,ROOT)
        self.assertEqual((r['code_files'],r['modules'],r['original_sources'],r['review_sources']),(109,31,186,9139))
        self.assertEqual((r['screens'],r['journeys'],r['guards'],r['ui_components']),(51,47,18,788))
        self.assertFalse(r['native_executed']);self.assertFalse(r['manual_state_mutated'])
    def test_02_missing_manifest_code_file_refused(self):
        d=copy.deepcopy(self.doc);d['original_sources']=[x for x in d['original_sources'] if x['path']!='mod/lgn/mod_lgn2.dat']
        self.reject(d,'fichiers de code incomplet')
    def test_03_missing_module_descriptor_refused(self):
        d=copy.deepcopy(self.doc);d['modules'].pop();self.reject(d,'modules incomplet')
    def test_04_wrong_build_reference_refused(self):
        d=copy.deepcopy(self.doc);d['build_reference_sha256']='0'*64;self.reject(d,'build AIR divergente')
    def test_05_nonexistent_screen_in_journey_refused(self):
        d=copy.deepcopy(self.doc);d['journeys'][0]['steps'].append('invented-screen');self.reject(d,'écran non recensé')
    def test_06_missing_journey_anchor_refused(self):
        d=copy.deepcopy(self.doc);d['journeys'][0]['anchors']=['A9999'];self.reject(d,'sans ancre')
    def test_07_empty_placeholder_method_is_not_evidence(self):
        d=copy.deepcopy(self.doc);row=next(x for x in d['review_sources'] if x['path'].endswith('/LobbyViewController.as'))
        m=next(x for x in row['analysis']['methods'] if x['name']=='navigateToHome')
        d['anchors'][0].update(source=row['path'],method=m['name'],line=m['line'],end_line=m['end_line'])
        self.reject(d,'méthode vide/interface')
    def test_08_stale_mock_module_cannot_become_public(self):
        d=copy.deepcopy(self.doc);next(x for x in d['excluded_candidates'] if 'DO_NOT_SHIP' in x['module_path'])['promoted_as_public']=True
        self.reject(d,'Ancien module promu')
    def test_09_cannot_invent_native_screen_observation(self):
        d=copy.deepcopy(self.doc);d['screens'][0]['observed_native']=True;self.reject(d,'observation non prouvée')
    def test_10_cannot_hide_loader_file_gaps(self):
        d=copy.deepcopy(self.doc);d['dependency_target_gaps']=[];self.reject(d,'dépendances masqués')
    def test_11_cannot_hide_decompilation_errors(self):
        d=copy.deepcopy(self.doc);d['decompilation_errors']=[];self.reject(d,'décompilation masquées')
    def test_12_cannot_use_failed_decompilation_as_route_anchor(self):
        d=copy.deepcopy(self.doc);d['anchors'][0]['source']=d['decompilation_errors'][0]
        self.reject(d,'export incomplet')
    def test_13_components_cannot_be_deleted_or_claimed_public(self):
        for mutation in ['delete','public']:
            d=copy.deepcopy(self.doc)
            if mutation=='delete':d['ui_components'].pop()
            else:d['ui_components'][0]['public_visibility_proven']=True
            self.reject(d,'Index des composants')
    def test_14_altered_original_payload_refused(self):
        with tempfile.TemporaryDirectory(dir=TEMP) as td:
            root=pathlib.Path(td);dest=root/'docs/reference_air_sources';dest.mkdir(parents=True)
            for name in ['reference_frontend_builds_4_20.json','reference_client_4_20.json']:
                shutil.copy2(ROOT/'docs'/name,root/'docs'/name)
            shutil.copy2(ROOT/'docs/reference_air_sources/releasemanifest',dest/'releasemanifest')
            row=self.doc['original_sources'][0];p=dest/'original'/row['path'];p.parent.mkdir(parents=True)
            b=bytearray((ROOT/'docs/reference_air_sources/original'/row['path']).read_bytes());b[-1]^=1;p.write_bytes(b)
            with self.assertRaisesRegex(AirReferenceError,'Source originale modifiée'):verify(self.doc,root)
    def test_15_no_automatic_acceptance_claim(self):
        d=copy.deepcopy(self.doc);d['human_acceptance']='accepted';self.reject(d,'Acceptation ou exécution')
    def test_16_exact_gates_are_present_in_original_sources(self):
        root=ROOT/'docs/reference_air_sources'
        def text(stem):
            row=next(x for x in self.doc['review_sources'] if x['path'].endswith('/'+stem+'.as') and x['analysis']['role']=='application_class')
            return (root/row['path']).read_text(encoding='utf-8-sig')
        self.assertIn('_buttonLore.setVisible(false)',text('ChromeTopLevelNavigationView'))
        self.assertIn('replaySystemStates.replayServiceEnabled',text('ChromeTopLevelNavigationView'))
        self.assertIn('Aborting lobby state request',text('LobbyController'))
        self.assertIn('STORE_UNAVAILABLE_URL',text('StoreController'))
        self.assertIn('Unexpected flow - unable to proceed',text('CapViewMediator'))
if __name__=='__main__':unittest.main(verbosity=2)
